// SPDX-License-Identifier: CC0
pragma solidity = 0.8.19 || 0.8.20 || 0.8.23;

import {DynamicRouterStorage} from "/contracts/storage/LibDynamicRouterStorage.sol";
import "/contracts/mixins/Ownable.sol";
import "./IUpdateProxy.sol";
import "/contracts/modules/IModule.sol";
import "/contracts/free/FreeVersion.sol";
/**
 * @title UpdateProxy
 * @custom:version 1.0.0
 * @dev Логика работы с селекторами функция и маршрутизацией
 * @notice Управление динамическим маршрутизатором
*/
contract UpdateProxy is Ownable, IUpdateProxy, IModule{

  /// @dev Название модуля
  string public constant MODULE_NAME = "UpdateProxy";
  /// @dev Версия модуля
  uint256 public immutable MODULE_VERSION = _encodeVersion(1, 0, 0);

  constructor(){_initOwnable();}

  /// @dev Обновление модулей используя безопасную функцию библиотеки
  function updateModules(DynamicRouterStorage.moduleDefinition[] memory _modules) external onlyOwner{
    DynamicRouterStorage.updateModules(_modules);
  } 

  /**
   * @notice Получение всех имплементаций по селекторам
   * @dev Перебирает все селекторы и получает по ним модули
  **/
  function getModules() external view returns(modules[] memory){
    bytes4[] memory _selectors = DynamicRouterStorage.getSelectors();
    modules[] memory _modules = new modules[](_selectors.length);
    for (uint256 i = 0; i < _selectors.length; ++i) {
      bytes4 _selector = _selectors[i];
      _modules[i] = modules(_selector, DynamicRouterStorage.getModule(_selector));
    }
    return _modules;
  }

  /// @dev получение всех функций
  function getImpl() external view returns(address[] memory _allImpl){
    return DynamicRouterStorage.getImpl();
  }

  /// @dev получение всех селекторов
  function getSelectors() external view returns(bytes4[] memory){
    return DynamicRouterStorage.getSelectors();  
  }

  /// @dev получение селекторов имплементации
  function getSelectorsByImpl(address _impl) external view returns(bytes4[] memory){
    bytes4[] memory _selectors = DynamicRouterStorage.getSelectors();
    bytes4[] memory _selectorsBuf = new bytes4[](_selectors.length);
    uint _j;
    for (uint256 i = 0; i < _selectors.length; ++i) {
      bytes4 _selector = _selectors[i];
      if(_impl == DynamicRouterStorage.getModule(_selector)){
        _selectorsBuf[i] = _selector;
        _j++;
      }
    }
    bytes4[] memory _newSelectors = new bytes4[](_j);
    for (uint256 i = 0; i < _j; ++i) _newSelectors[i] = _selectorsBuf[i];
    return _selectors;
  }

  /// @dev получение адреса имплементации по селектору
  function getModuleBySelector(bytes4 _selector) external view returns(address){
    return DynamicRouterStorage.getModule(_selector);  
  }
  
}