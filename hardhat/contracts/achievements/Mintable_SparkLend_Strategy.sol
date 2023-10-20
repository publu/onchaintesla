pragma solidity 0.8.13;
   
import "./MintableBaseStrategy.sol";

contract Mintable_Strategy_SparkLend is Mintable_BaseStrategy {
    
    // data in this case is nothing.
    function createRule(address _target, bytes memory _data, string memory _baseURI) public override returns(MintRules memory){

        address[] memory target = new address[](1);
        target[0] = _target; // AKA target

        string[] memory func = new string[](1);
        func[0] = "balanceOf(address)";

        bytes[] memory datasAndReturn = new bytes[](1);
        datasAndReturn[0] = bytes(abi.encode(0));

        uint8[] memory userDatas = new uint8[](1);
        userDatas[0] = 2;

        uint8[] memory comparison = new uint8[](1);
        comparison[0] = 4;

        bool[] memory identicalData = new bool[](1);
        identicalData[0] = false;

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