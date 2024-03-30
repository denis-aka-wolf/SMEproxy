// SPDX-License-Identifier: CC0
pragma solidity = 0.8.19 || 0.8.20 || 0.8.23;

import {DynamicRouterStorage} from "../dynamicRouter/DynamicRouterStorage.sol";
import "./IUpdateProxy.sol";
import "./UpdateProxyFunction.sol";
import "../utils/mixins/Ownable.sol";
/**
* @author ACTPOHABT denis.aka.wolf@gmail.com
*
* @dev Точка входа в экосистему - динамический маршрутизатор
*/
contract UpdateProxy is IUpdateProxy, Ownable{

  constructor() Ownable(msg.sender){
  }

  //Обновление модулей
  function updateModules(moduleDefinition[] memory _modules) external onlyOwner{
    DynamicRouterStorage.updateModules(_modules);
  } 

  /// @dev получение всех имплементаций
  function getModules() external view returns(modules[] memory){
    dynamicRouterStorage storage _storage = _getStorage();
    modules[] memory _modules = new modules[](_storage.selectors.length);
    for (uint256 i = 0; i < _storage.selectors.length; ++i) {
      _modules[i] = modules(_storage.selectors[i], _storage.modules[_storage.selectors[i]]);
    }
    return _modules;
  }

  /// @dev получение всех функций
  function getImpl() external view returns(address[] memory _allImpl){
    return _getStorage().impl;
  }

  /// @dev получение всех селекторов
  function getSelectors() external view returns(bytes4[] memory){
    return _getStorage().selectors;  
  }

  /// @dev получение селекторов имплементации
  function getSelectorsByImpl(address _impl) external view returns(bytes4[] memory){
    dynamicRouterStorage storage _storage = _getStorage();
    bytes4[] memory _selectorsBuf = new bytes4[](_storage.selectors.length);
    uint _j;
    for (uint256 i = 0; i < _storage.selectors.length; ++i) {
      if(_impl == _storage.modules[_storage.selectors[i]]){
        _selectorsBuf[i] = _storage.selectors[i];
        _j++;
      }
    }
    bytes4[] memory _selectors = new bytes4[](_j);
    for (uint256 i = 0; i < _j; ++i) _selectors[i] = _selectorsBuf[i];
    return _selectors;
  }

  /// @dev получение адреса имплементации по селектору
  function getModuleBySelector(bytes4 _selector) external view returns(address){
    return _getStorage().modules[_selector];  
  }

  /// @dev получение хранилища
  function _getStorage() private pure returns(dynamicRouterStorage storage _storage) {
    return getStorage(DynamicRouterStorage.SLOT);
  }

}