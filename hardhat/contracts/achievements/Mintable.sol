// contracts/Mintable.sol
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/*
    This lets us update the comparisons in case there are more unique ways to compare the data
*/
interface Comparison {
    function _checkUserDatas(
        uint8 config,
        bytes memory user, 
        bytes memory preset, 
        address msgsender) external view returns (bytes memory);
    function _callTarget(
            address _target, 
            string memory _func, 
            bytes memory _data, 
            bytes memory _return,
            uint8 _comparison,
            address msgsender) external view returns (bool);
}

contract Mintable is ERC721, ERC721Enumerable, Ownable {

    error NotAllowed();
    error AlreadyMinted();
    error TxFailedError();
    error MintingDisabled();
    error RuleNonExistent();

    error TokenBoundToAddress();

    error NoSuchStrategy();
    error StrategyCreationFailed();

    event SetStrategy(address strategy, bool enabled);

    // Token name
    string private _name;
    // Token symbol
    string private _symbol;

    string public uri;

    address public comparison;

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize) internal override(ERC721, ERC721Enumerable) {
        TokenInfo memory token = tokenTemplate[tokenId];
        MintRules memory rule = mintrules[token.rule];
        if(!rule.bound || from==address(0)){
            super._beforeTokenTransfer(from, to, tokenId, batchSize);
        }else {
            revert TokenBoundToAddress();
        }
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    /**
         * @dev constructor to create a new ERC721 token with a given name and symbol
         * @param name the name of the token
         * @param symbol the symbol of the token
     */
    constructor(string memory name, string memory symbol, address _comparison)
        ERC721(name, symbol) NominatedOwnable(msg.sender)
    {
        setContractInfo(name, symbol);
        comparison = _comparison;
    }

    /**
         * @dev struct to hold the mint rules for a given token type id
     */
    struct MintRules {
        address[] _targets;
        string[] _funcs;
        bytes[] _datas;
        bytes[] _returns;
        uint8[] _comparisons;
        /*
            0 means equality to msg.sender
            1 means byte equality to _returns
            2 means < to uint256(returns)
            3 means > to uint256(returns) 
            4 means <= to uint256(returns)
            5 means >= to uint256(returns)
            6 means uint256,msgsender >= to uint256(returns). where msgsender gets removed automatically. works well for farms and others
        */
        bool[] identicalDatas;
        uint8[] _userDatas;
        /*
            0 means not provided by user (aka default value so can leave blank)
            1 means must be provided by user
            2 means inferred by the msg.sender value
            3 means uint256, concatenated with msg.sender
        */
        string baseURI;
        uint256 count;
        bool disabled;
        bool exists;
        bool custom;
        bool bound;
    }

    struct TokenInfo {
        uint256 rule;
        uint256 tokenId;
    }

    modifier RuleExists(uint256 _id) {
        if (!mintrules[_id].exists) {
            revert RuleNonExistent();
        }
        _;
    }

    uint256 public ruleCount; // number of rules
    mapping(uint256 => MintRules) public mintrules; // numbered rules from id
    mapping(uint256 => TokenInfo) public tokenTemplate; // global tokenId to TokenInfo;
    mapping(bytes32 => bool) public minted; // hash of rules + custom value from user
    mapping(address=>bool) public strategies; // RuleTemplates

    // We got tokenTemplates which are made by rules. Rules are made by Rule templates (OR admin powers)

    /**
         * @dev internal function to call a target contract's view function and compare the return value with the expected return value
         * @param _target the address of the target contract
         * @param _func the name of the view function to call
         * @param _data the data to pass to the view function
         * @param _return the expected return value
         * @return true if the call to the target contract's view function returns the expected value, false otherwise
     */
    function _callTarget(
            address _target, 
            string memory _func, 
            bytes memory _data, 
            bytes memory _return,
            uint8 _comparison,
            address _msgsender) internal view returns (bool) {

        return Comparison(comparison)._callTarget(_target, _func, _data, _return, _comparison,_msgsender);
        /*
        (bool success, bytes memory data) = comparison.delegatecall(
            abi.encodeWithSignature("_callTarget(address,string,bytes,bytes,uint8,address)", _target, _func, _data, _return, _comparison,_msgsender)
        );
        */
        //(bool response) = abi.decode(data,(bool));
        //return response;
        //return MintableModule(comparison)._callTarget(_target, _func, _data, _return, _comparison);
    }

    /**
         * @dev internal function to iterate through the mint rules for a given token id and call the view functions of the target contracts
         * @param _id the token id to check the mint rules for
         * @return a tuple of a bool indicating if the mint is allowed and the baseURI
     */
    function _splitCalls(uint256 _id, bytes[] memory _datas,address _msgsender) internal view returns (bool, bytes32){
        MintRules memory loop = mintrules[_id];

        if(loop.disabled){
            revert MintingDisabled();
        }

        bytes memory integrity;
        bool check = true;
        uint8 i= 0;
        while(i<loop.identicalDatas.length) {
            if(loop.identicalDatas[i]) {
                if(integrity.length == 0){
                    integrity = _datas[i]; // the first data
                } else {
                    if(keccak256(abi.encodePacked(integrity)) != keccak256(abi.encodePacked(_datas[i]))){
                        check=false;
                        break;
                    }
                }
            }
            i++;
        }

        if(check) {
            bool allowed = false;
            for(i = 0; i<loop._targets.length; i++){

                if(loop._userDatas[i]>1){
                    /*
                    (bool success, bytes memory data) = comparison.delegatecall(
                        abi.encodeWithSignature("_checkUserDatas(uint8,bytes,bytes,address)",loop._userDatas[i], _datas[i], loop._datas[i],_msgsender)
                    );
                    if(!success){
                        revert TxFailedError();
                    }
                    loop._datas[i]= abi.decode(data,(bytes));
                    */
                    loop._datas[i]= Comparison(comparison)._checkUserDatas(loop._userDatas[i], _datas[i],loop._datas[i],_msgsender);
                }

                if(loop._userDatas[i]==1){
                    loop._datas[i]=_datas[i];
                }
                allowed = _callTarget(loop._targets[i], loop._funcs[i], loop._datas[i], loop._returns[i], loop._comparisons[i], _msgsender);
            }
            bytes32 hash = keccak256(abi.encode(_id,loop._targets, loop._funcs, _datas, loop._comparisons)); // ruleID required to make sure we can differentiate per rule
            return (allowed, hash);
        } else {
            return (false, bytes32(keccak256(abi.encode(""))));
        }
    }

    /**
         * @dev function to mint a new token
         * @param _id the ID of the mint rule to use
         * @param _datas the data to pass to the view functions
     */
    function mintable(uint256 _id, bytes[] memory _datas, address _for) public {
        (bool allowed, bytes32 hash) = _splitCalls(_id, _datas,_for);

        if(minted[hash]){
            revert AlreadyMinted();
        }

        if(!allowed){
            revert NotAllowed();
        }
        _mintCustom(_id, hash,_for);
    }

    function checkMintable(uint256 _id, bytes[] memory _datas, address _for) public view returns(uint8 allowed){
        (bool _allowed,bytes32 hash) = _splitCalls(_id, _datas,_for);
        if(_allowed && !minted[hash]){
            allowed=1;
        } else if(minted[hash]){
            allowed=2;
        } else {
            allowed=0;
        }
    }

    function getMintRule(uint256 _id) public view returns (MintRules memory){
        return mintrules[_id];
    }

    /**
     * @dev internal function to mint a new custom token
     * @param _id the ID of the mint rule to use
     * @param _hash the hash of the mint rule and custom value
     */
    function _mintCustom(uint256 _id, bytes32 _hash, address _for) internal {
        minted[_hash] = true;
        uint256 tokenId = totalSupply();
        _mint(_for, tokenId);
        tokenTemplate[tokenId] = TokenInfo(_id, mintrules[_id].count);
        mintrules[_id].count++; // up the internal count
    }

    /**
         * @dev function to create a new mint rule
         * @param _targets the addresses of the target contracts
         * @param _funcs the names of the view functions to call on the target contracts
         * @param _datas the data to pass to the view functions
         * @param _returns the expected return values from the view functions
         * @param _comparisons the comparison operators to use when comparing the return values with the expected return values
         * @param _identicalDatas whether the data passed to the view functions should be identical for the specific rules
         * @param _userDatas whether the data passed to the view functions should be provided by the user or not
         * @param _baseURI the base URI for the mintable tokens
     */
    function createMintable(
        address[] memory _targets, 
        string[] memory _funcs, 
        bytes[] memory _datas,
        bytes[] memory _returns,
        uint8[] memory _comparisons,
        bool[] memory _identicalDatas,
        uint8[] memory _userDatas,
        string memory _baseURI
    ) public onlyOwner {
        mintrules[ruleCount] = MintRules(
            _targets, 
            _funcs, 
            _datas, 
            _returns,
            _comparisons,
            _identicalDatas,
            _userDatas,
            _baseURI,
            0,
            false,
            true,
            false,
            false
            );
        ruleCount++;
    }

    /**
         * @dev function to return the URI of a token
         * @param _tokenId the ID of the token to get the URI for
         * @return the URI of the token
     */
    function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
        _requireMinted(_tokenId);
        /*
            the internal tokenId is the count of the token of type
            this lets us count how many and which one it is of that type
        */
        TokenInfo memory token = tokenTemplate[_tokenId];
        MintRules memory rule = mintrules[token.rule];
        string memory baseURI = rule.baseURI;

        if(rule.custom){
            return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, Strings.toString(token.tokenId))) : "";
        } else{
            return baseURI;
        }
    }

    function getTokenInfo(uint256 _tokenId) external view returns (uint256, uint256, string memory, bool, uint256) {

        TokenInfo memory token = tokenTemplate[_tokenId];
        MintRules memory rule = mintrules[token.rule];

        return (token.rule, _tokenId, rule.baseURI, rule.disabled, rule.count);
    }

    /**
     * @dev See {IERC721Metadata-name}.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev See {IERC721Metadata-symbol}.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function _mintTo(uint256 _id, address _to) internal {
        uint256 tokenId = totalSupply();
        _mint(_to, tokenId);
        tokenTemplate[tokenId] = TokenInfo(_id, mintrules[_id].count);
        mintrules[_id].count++; // up the internal count
    }

    function mintTo(uint256 _id, address _to) public onlyOwner RuleExists(_id) {
        _mintTo(_id,_to);
    }

    function mintToMany(uint256 _id, address[] calldata _to) public onlyOwner RuleExists(_id)  {
        for(uint256 i=0;i<_to.length;i++){
            _mintTo(_id,_to[i]);
        }
    }

    function setTokenTemplate(uint256 _tokenId, uint256 _rule) public onlyOwner RuleExists(_rule) {
        _requireMinted(_tokenId);

        uint256 current = tokenTemplate[_tokenId].rule;
        if(current != _rule){
            tokenTemplate[_tokenId].rule = _rule;
            mintrules[current].count--;
            mintrules[_rule].count++;
        }
    }

    function setContractInfo(string memory name_, string memory symbol_) public onlyOwner {
        _name = name_;
        _symbol = symbol_;
        /*
            CHECK
            opensea event standard we need to add.
        */
    }

    /**
         * @dev function to disable or enable a mint rule
         * @param _rule the ID of the rule to disable/enable
         * @param disabled whether the rule should be disabled or not
     */
    function setDisabled(uint256 _rule, bool disabled) public onlyOwner RuleExists(_rule) {
        mintrules[_rule].disabled = disabled;
    }

    /**
         * @dev function to set the base URI for a mint rule
         * @param _rule the ID of the rule to set the base URI for
         * @param _baseURI the new base URI
     */
    function setTokenBaseUri(uint256 _rule, string memory _baseURI) public onlyOwner RuleExists(_rule) {
        mintrules[_rule].baseURI = _baseURI;
    }

    /**
         * @dev function to set whether the URI should include the token ID
         * @param _custom whether the URI should include the token ID
     */
    function setCustomURI(uint256 _rule, bool _custom) external onlyOwner {
        // this function sets a flag to add the tokenId to the tokenURI
        mintrules[_rule].custom = _custom;
    }

    /**
         * @dev function to disable or enable minting for a mint rule
         * @param _id the ID of the rule to disable/enable minting for
         * @param _disabled whether minting should be disabled or not
     */
    function setMintable(uint256 _id, bool _disabled) public onlyOwner RuleExists(_id) {
        mintrules[_id].disabled = _disabled;
    }

    /**
         * @dev Function to set the bound property of a token defined by a rule ID.
         * @param _id uint256: ID of the token rule to modify.
         * @param _bound bool: New value for the bound property of the token rule.
         * @notice If bound is set to true, tokens associated with this rule will not be transferable.
         * @notice throws if called by a non-owner or if the rule ID does not exist.
     */
    function setBound(uint256 _id, bool _bound) public onlyOwner RuleExists(_id) {
        mintrules[_id].bound = _bound;
    }

    /*
        Strategy functions
    */

    /**
     * @dev Creates a new mintable token with a specific strategy
     * @param strategy The address of the strategy contract
     * @param target The address of the target contract
     * @param data The data to be passed to the strategy contract
     * @param baseuri The base URI for the new mintable token
     */
    function createMintableWithStrategy(address strategy, address target, bytes memory data, string memory baseuri) public onlyOwner {
        if(!strategies[strategy]){
            revert NoSuchStrategy();
        }
        (bool success, bytes memory data) = strategy.call(
            abi.encodeWithSignature("createRule(address,bytes,string)", target, data, baseuri)
        );

        if(!success) {
            revert StrategyCreationFailed();
        }   

        (MintRules memory newRule) = abi.decode(data, (MintRules));

        mintrules[ruleCount] = newRule;
        ruleCount++;
    }

    /**
     * @dev Enables or disables a specific strategy
     * @param strategy The address of the strategy contract
     * @param enabled Whether the strategy should be enabled or not
     */
    function setStrategy(address strategy, bool enabled) public onlyOwner {
        strategies[strategy] = enabled;
        emit SetStrategy(strategy, enabled);
    }
}