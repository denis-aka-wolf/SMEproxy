// SPDX-License-Identifier: CC0
pragma solidity = 0.8.19 || 0.8.20 || 0.8.23;

import {DynamicRouterStorage} from "/contracts/storage/LibDynamicRouterStorage.sol";
import "/contracts/modules/dynamicRouter/DynamicRouter.sol";

/**
 * @title Proxy
 * @custom:version 0.1
 * @author ACTPOHABT denis.aka.wolf@gmail.com
 * @dev free - свободные функции
 *      lib - все внешние библиотеки
 *      mixins - миксины
 *      modules - имплементации модулей и функций
 *      storage - все библиотеки работы с хранилищем
 * 
 * @notice Точка входа в экосистему - динамический маршрутизатор
 *      Все имплементации отделены друг от друга и от хранилища.
 *      Логика описывается модулями, в то время как работа с хранилищем производится 
 *      только через библиотеки для раздельных хранилищ
**/
contract Proxy is DynamicRouter{
  ///@dev Пример структуры UpdateProxy - [[0xdd875e44bf1d52823b242cc06ba0c798a33729d6 ,[0x9f889b6e,0xdfb80831,0x63de14fc,0xb2494df3,0x4b503f0b,0x0abe1796]]] 
  constructor(DynamicRouterStorage.moduleDefinition[] memory modules) DynamicRouter(modules){} 
}