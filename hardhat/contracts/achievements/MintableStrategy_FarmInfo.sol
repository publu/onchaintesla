pragma solidity 0.8.13;
   
import "./MintableBaseStrategy.sol";

contract Mintable_Strategy_FarmInfo is Mintable_BaseStrategy {
    error TxFailedError();

    // data in this case is nothing.
    function createRule(address _target, bytes memory _data, string memory _baseURI) public returns(MintRules memory){

        address[] memory target = new address[](1);
        target[0] = _target; // AKA target

        string[] memory func = new string[](1);
        func[0] = "userInfo(uint256,address)";

        bytes[] memory datas = new bytes[](1);
        datas[0] = bytes(abi.encode(uint256(0)));

        bytes[] memory returnData = new bytes[](1);
        returnData[0] = _data;

        uint8[] memory userDatas = new uint8[](1);
        userDatas[0] = 3; // 3 means uint256,msgsender

        uint8[] memory comparison = new uint8[](1);
        comparison[0] = 6;

        bool[] memory identicalData = new bool[](1);
        identicalData[0] = false;

        return MintRules(
            target, 
            func, 
            datas, 
            returnData,
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