// SPDX-License-Identifier: CC0
pragma solidity = 0.8.19 || 0.8.20 || 0.8.23;

import {DynamicRouterStorage} from "/contracts/storage/LibDynamicRouterStorage.sol";
import {Ownable} from "/contracts/mixins/Ownable.sol";
import "./IUpdateProxy.sol";
import "/contracts/modules/IModule.sol";
import "/contracts/free/FreeVersion.sol";
/**
 * @title UpdateProxy
 * @custom:version 1.0.0
 * @dev Логика работы с селекторами функция и маршрутизацией
 * @notice Управление динамическим маршрутизатором
*/
contract UpdateProxy is IUpdateProxy, Ownable{

  /// @dev Название модуля
  string public constant MODULE_NAME = "UpdateProxy";
  /// @dev Версия модуля
  uint256 public immutable MODULE_VERSION = _encodeVersion(1, 0, 0);

  /// @dev структура всех селекторов
  struct modules {
      bytes4 selector;
      address module;
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