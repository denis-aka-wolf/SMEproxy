// SPDX-License-Identifier: CC0
pragma solidity = 0.8.19 || 0.8.20 || 0.8.23;


/**
* @author ACTPOHABT denis.aka.wolf@gmail.com
*
* @dev Все управляющие структуры динамического маршрутизатора
*/

/// @dev структура загрузки селекторов
struct moduleDefinition {
    address module;
    bytes4[] selectors;
}

/// @dev структура хранилища селекторов
struct dynamicRouterStorage {
    mapping (bytes4 => address) modules;
    bytes4[] selectors;
    address[] impl;
}