pragma solidity 0.8.13;
   
import "./MintableBaseStrategy.sol";

contract Mintable_Strategy_VaultOwnerMinDebt is Mintable_BaseStrategy {
    // data in this case is amount to check for min borrowed!
    function createRule(address _target, bytes memory _data, string memory _baseURI) public override returns(MintRules memory){

        address[] memory target = new address[](2);
        target[0] = _target;
        target[1] = _target;

        string[] memory func = new string[](2);
        func[0] = "ownerOf(uint256)";
        func[1] = "vaultDebt(uint256)";

        bytes[] memory datasAndReturn = new bytes[](2);
        datasAndReturn[0] = bytes(abi.encode(0));
        datasAndReturn[1] = _data; // 1 mai borrowed?

        uint8[] memory userDatas = new uint8[](2);
        userDatas[0] = 1;
        userDatas[1] = 1;

        uint8[] memory comparison = new uint8[](2);
        comparison[0] = 0;
        comparison[1] = 4; // returned data must be more than or equal to

        bool[] memory identicalData = new bool[](2);
        identicalData[0] = true;
        identicalData[1] = true;

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