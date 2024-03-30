// SPDX-License-Identifier: CC0
pragma solidity = 0.8.19 || 0.8.20 || 0.8.23;

/**
* @author ACTPOHABT denis.aka.wolf@gmail.com
*
* @dev библиотека получения селектора функциии по сигнатуре
*/
library libSelector {
    /// @dev возвращает селектор функции по сигнатуре
    function selectorFunction(string memory _signature) internal pure returns(bytes4){
        return bytes4(keccak256(bytes(_signature)));
    }

    /// @dev возвращает селектор хранилища по сигнатуре "name.storage"
    function selectorStorage(string memory _signature) internal pure returns(bytes32){
        return keccak256(bytes(_signature));
    }
}