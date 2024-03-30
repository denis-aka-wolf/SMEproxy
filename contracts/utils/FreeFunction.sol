// SPDX-License-Identifier: CC0
pragma solidity = 0.8.19 || 0.8.20 || 0.8.23;

import "./FreeType.sol";
/**
* @author ACTPOHABT denis.aka.wolf@gmail.com
*
* @dev Все pure function экосистемы
*       При достижении размера более 24577 байта разбить на части
*/

/// @dev возвращает селектор функции по сигнатуре
function selectorFunction(string memory _signature) pure returns(bytes4){
    return bytes4(keccak256(bytes(_signature)));
}

/// @dev возвращает селектор хранилища по сигнатуре
function selectorStorage(string memory _signature) pure returns(bytes32){
    return keccak256(bytes(_signature));
}

/// @dev устанавливает бит в слоте по индексу
function setBitmap(uint256 bitmap, uint index, bool value) pure returns(uint){
    if(value){
        bitmap = bitmap | (1 << index);
    } else {
        bitmap = bitmap & (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff ^ (1<<index)); 
    }
    return bitmap;
}

/// @dev получает значение по индексу
function getBitmap(uint bitmap, uint index) pure returns(uint){
    return bitmap & (1<<index);
}