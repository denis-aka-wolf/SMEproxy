// SPDX-License-Identifier: CC0
pragma solidity = 0.8.19 || 0.8.20 || 0.8.23;

import "./dynamicRouter/DynamicRouter.sol";

/**
* @author ACTPOHABT denis.aka.wolf@gmail.com
*
* @dev Точка входа в экосистему - основной динамический маршрутизатор
*/
contract Proxy is DynamicRouter{
  constructor(moduleDefinition[] memory modules) DynamicRouter(modules){} 
}