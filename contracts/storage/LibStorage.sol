// SPDX-License-Identifier: CC0
pragma solidity = 0.8.19 || 0.8.20 || 0.8.23;

/**
 * @title LibStorage
 * @custom:version 1.0.0
 * @dev Используется другими библиотеками
 * @notice Общие функции работы с хранилищем
**/
library LibStorage {

    /// @dev устанавливает бит в слоте по индексу
    function setBitmap(uint256 bitmap, uint index, bool value) public pure returns(uint){
        if(value){
            bitmap = bitmap | (1 << index);
        } else {
            bitmap = bitmap & (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff ^ (1<<index)); 
        }
        return bitmap;
    }

    /// @dev получает значение по индексу
    function getBitmap(uint bitmap, uint index) public pure returns(uint){
        return bitmap & (1<<index);
    }

    /// @dev возвращает селектор хранилища по сигнатуре "name.storage"
function selectorStorage(string memory _signature) internal pure returns(bytes32){
        return keccak256(bytes(_signature));
    }
}