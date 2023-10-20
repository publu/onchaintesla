pragma solidity 0.8.13;

import "./Mintable.sol";

contract MintableUtilities {
	
    struct TokenInfo {
        uint256 rule;
        uint256 tokenId;
    }

    function balanceOf(address _mintable, address _user, uint256 _id) public view returns (uint256) {

        Mintable mint = Mintable(_mintable);

        uint256 total = mint.balanceOf(_user);
        uint256 count;

        for(uint256 i=0; i<total;i++){
            uint256 tokenId = mint.tokenOfOwnerByIndex(_user, i);
            (uint256 rule,,,,) = mint.getTokenInfo(tokenId);
            if(rule==_id){
                ++count;
            }
        }
        return count;
    }

    function tokensOfOwner(address _mintable, address _owner) public view returns (uint256[] memory) {

        Mintable mint = Mintable(_mintable);

        uint256 total = mint.balanceOf(_owner);

        uint256[] memory tokens = new uint256[](total);
        
        for(uint256 i=0; i<total;i++){
            uint256 tokenId = mint.tokenOfOwnerByIndex(_owner, i);
            tokens[i] = tokenId;
        }
        return tokens;
    }

    function targetRules(address _mintable, address _target, bool flagged) public view returns (uint256[] memory) {

        Mintable mint = Mintable(_mintable);
        //    bool[] memory ret = new bool[](arr.length);

        uint256 count = mint.ruleCount();
        uint256 added = 0;

        uint256[] memory rules = new uint256[](count);

        for(uint256 i=0; i<count;i++){
            address[] memory rule = mint.getMintRule(i)._targets;
            uint256 m=0;
            while(m<rule.length) {
                if(rule[m]==_target){
                    rules[added]=i;
                    added++;
                    m=rule.length;
                } else{
                    m++;
                }
            }
        }
        uint256[] memory newRules = new uint256[](added);

        for(uint256 i=0; i<(added); i++){
            newRules[i] = rules[i];
        }
        return newRules;
    }

    function checkMintableWithTarget(address _mintable, address _target, uint256 value, address _for, bool flagged) public view returns (uint256[] memory, uint256[] memory){
        Mintable mint = Mintable(_mintable);

        uint256[] memory rules = targetRules(_mintable, _target, flagged);

        uint256[] memory mintable = new uint256[](rules.length);

        for(uint256 i=0; i<rules.length;i++){
            Mintable.MintRules memory rule = mint.getMintRule(i);

            bytes[] memory data = new bytes[](rule._userDatas.length);

            for(uint256 m=0; m<rule._userDatas.length;m++){
                data[m] = bytes(abi.encode(value)); // ex: vault id 1
            }
            try mint.checkMintable(rules[i], data, _for) returns (uint8 val) {
                mintable[i] = val;
            } catch {
                mintable[i] = 4;
            }
        }

        return (rules, mintable);
    }
}