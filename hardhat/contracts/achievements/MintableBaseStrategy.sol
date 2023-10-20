pragma solidity 0.8.13;
   
abstract contract Mintable_BaseStrategy {
    error TxFailedError();

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
            1 means byte equality
            2 means <
            3 means > 
            4 means <=
            5 means >=
        */
        bool[] identicalDatas;
        uint8[] _userDatas;
        string baseURI;
        uint256 count;
        bool disabled;
        bool exists;
        bool custom;
        bool bound;
    }


    uint256 public ruleCount; // number of rules
    mapping(uint256 => MintRules) public mintrules; // numbered rules from id

    function createRule(address, bytes memory, string memory) virtual public returns(MintRules memory) {}
}