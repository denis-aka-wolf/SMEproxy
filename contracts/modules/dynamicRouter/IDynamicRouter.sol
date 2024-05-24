// SPDX-License-Identifier: CC0
pragma solidity = 0.8.19 || 0.8.20 || 0.8.23;

/**
* @dev Интерфейс динамического маршрутизатора
*/
interface IDynamicRouter {
  
  /// @dev Неизвестный селектор
  error UnknownSelector(bytes4);

}