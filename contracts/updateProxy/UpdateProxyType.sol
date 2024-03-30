// SPDX-License-Identifier: CC0
pragma solidity = 0.8.19 || 0.8.20 || 0.8.23;

/**
* @author ACTPOHABT denis.aka.wolf@gmail.com
*
* @dev Все типы модуля
*/

/// @dev структура всех селекторов
struct modules {
    bytes4 selector;
    address module;
}