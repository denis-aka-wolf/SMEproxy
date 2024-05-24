// SPDX-License-Identifier: CC0
pragma solidity = 0.8.19 || 0.8.20 || 0.8.23;

import "../dynamicRouter/DynamicRouterFunction.sol";
import "./UpdateProxyFunction.sol";

/**
* @dev Интерфейс модуля UpdateProxy
*/
interface IUpdateProxy{

  /// @dev обновление селекторов модулей		
  function updateModules(moduleDefinition[] memory _modules) external ;
  
  /// @dev получение всех модулей
  function getModules() external view returns(modules[] memory _modules);
  
  /// @dev получение всех функций
  function getImpl() external view returns(address[] memory _allImpl);

  /// @dev получение всех селекторов
  function getSelectors() external view returns(bytes4[] memory);

  /// @dev получение селекторов имплементации
  function getSelectorsByImpl(address _impl) external view returns(bytes4[] memory _selectors);

  /// @dev получение адреса имплементации по селектору
  function getModuleBySelector(bytes4 _selector) external view returns(address _imp);
}