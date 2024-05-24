// SPDX-License-Identifier: CC0
pragma solidity = 0.8.19 || 0.8.20 || 0.8.23;

/**
* @author ACTPOHABT denis.aka.wolf@gmail.com
*
* @dev Базовый интерфейс для определения модуля
*/
interface IModule {

    // solhint-disable func-name-mixedcase

    /// @dev Имя модуля
    function MODULE_NAME() external view returns (string memory name);

    /// @dev Версия модуля
    function MODULE_VERSION() external view returns (uint256 version);
}