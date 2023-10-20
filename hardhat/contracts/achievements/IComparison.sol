pragma solidity 0.8.13;

interface IComparison {
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