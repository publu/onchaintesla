// contracts/MintableModule.sol
pragma solidity 0.8.13;
import "./IComparison.sol";

contract Mintable_Comparison is IComparison {
    error TxFailedError();

    function _checkUserDatas(uint8 config,bytes memory user, bytes memory preset, address msgsender) external view override returns (bytes memory) {
        if(config==2){
            user = bytes(abi.encode(msgsender));
            ////user is msgsender
        }
        if(config==3){
            uint256 val = abi.decode(preset, (uint256));
            user = abi.encode(val, address(msgsender));
        }
        return user;
    }

	function _callTarget(
            address _target, 
            string memory _func, 
            bytes memory _data, 
            bytes memory _return,
            uint8 _comparison,
            address msgsender) external view override returns (bool) {
        // prepare data
        bytes memory data;

        if (bytes(_func).length > 0) {
            // data = func selector + _data
            data = abi.encodePacked(
                    bytes4(keccak256(bytes(_func))), _data);
        } else {
            // call fallback with data
            data = _data;
        }

        // call target
        (bool ok, bytes memory res) = _target.staticcall(data);
        if (!ok) {
            revert TxFailedError();
        }

        bool output = false;

        do{
            if(_comparison == 1) {
                output = keccak256(abi.encodePacked(res)) == keccak256(abi.encodePacked(_return));
                break;
            } else if(_comparison == 2) {
                output = abi.decode(res, (uint256)) < abi.decode(_return, (uint256));
                break;
            } else if(_comparison == 3) {
                output = abi.decode(res, (uint256)) <= abi.decode(_return, (uint256));
                break;
            } else if(_comparison == 4) {
                output = abi.decode(res, (uint256)) > abi.decode(_return, (uint256));
                break;
            } else if(_comparison == 5) {
                output = abi.decode(res, (uint256)) >= abi.decode(_return, (uint256));
                break;
            } else if(_comparison == 6) {
                (uint256 val1, uint256 val2) = abi.decode(res, (uint256,uint256));
                output = val1 >= abi.decode(_return, (uint256));
                break;
            } else{
                address response = abi.decode(res, (address));
                output = response == msgsender;
                break;
            }
        } 
        while (true);
        return output;
    }
}