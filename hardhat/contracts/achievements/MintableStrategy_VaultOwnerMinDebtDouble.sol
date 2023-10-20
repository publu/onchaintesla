// contracts/MintableStrategy.sol
// SPDX-License-Identifier: Thread AI LLC (c)
pragma solidity 0.8.13;
   

contract Mintable_Strategy_VaultOwnerMinDebtDouble {
    /**
         * @dev struct to hold the mint rules for a given token type id
     */
    struct MintRules {
        address[] _targets;
        string[] _funcs;
        bytes[] _datas;
        bytes[] _returns;
        uint8[] _comparisons;
        bool[] identicalDatas;
        uint8[] _userDatas;
        string baseURI;
        uint256 count;
        bool disabled;
        bool exists;
        bool custom;
        bool bound;
    }

    // data in this case is amount to check for min borrowed!
    function createRule(address _target, bytes memory _data, string memory _baseURI) public returns(MintRules memory){

        address[] memory target = new address[](2);
        target[1] = _target;
        target[0] = _target;

        string[] memory func = new string[](2);
        func[1] = "ownerOf(uint256)";
        func[0] = "vaultDebt(uint256)";

        bytes[] memory datasAndReturn = new bytes[](2);
        datasAndReturn[1] = bytes(abi.encode(0));
        datasAndReturn[0] = _data; // 1 mai borrowed?

        uint8[] memory userDatas = new uint8[](2);
        userDatas[1] = 1;
        userDatas[0] = 1;

        uint8[] memory comparison = new uint8[](2);
        comparison[1] = 5; // returned data must be more than or equal to
        comparison[0] = 0; 

        bool[] memory identicalData = new bool[](2);
        identicalData[1] = true;
        identicalData[0] = true;

        return MintRules(
            target, 
            func, 
            datasAndReturn, 
            datasAndReturn,
            comparison,
            identicalData,
            userDatas,
            _baseURI,
            0, // count
            false, // disabled
            true, // exists
            false,
            false
            );
    }
}