// SPDX-License-Identifier: CC0
pragma solidity = 0.8.19 || 0.8.20 || 0.8.23;

/**
* @author ACTPOHABT denis.aka.wolf@gmail.com
*
* @dev Базовый интерфейс для определения функции
*/
interface IFeature {

    // solhint-disable func-name-mixedcase

    /// @dev Имя функции
    function FEATURE_NAME() external view returns (string memory name);

    /// @dev Версия функции
    function FEATURE_VERSION() external view returns (uint256 version);
}