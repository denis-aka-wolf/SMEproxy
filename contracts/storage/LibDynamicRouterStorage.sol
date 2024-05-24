// SPDX-License-Identifier: CC0
pragma solidity = 0.8.19 || 0.8.20 || 0.8.23;

/**
 * @title DynamicRouterStorage
 * @custom:version 1.0.0
 * @dev В DynamicRouterStorage находятся функции работы с хранилищем
 *     Отделены от имплементации модуля для более безопасного обновления
 *     всех последующих имплементаций. Не имеет зависимостей.
 *     Для корректного обновления модуля реализована функция updateModules.
*/
library DynamicRouterStorage {

  /// @dev Слот хранилища
  bytes32 constant SLOT = keccak256(bytes('DynamicRouter'));

  /// @dev структура загрузки селекторов
  struct moduleDefinition {
      address module;
      bytes4[] selectors;
  }

  /// @dev Структура хранилища селекторов
  struct dynamicRouterStorage {
      mapping (bytes4 => address) modules;
      bytes4[] selectors;
      address[] impl;
  }

  /// @dev Событие обновления имплементации модуля
  event UpdateModule(address _initialized, address _module, bytes4 _selector);

  /**
   * @dev Обновление модулей
   * 
   * @param modules - структура moduleDefinition:
   *     address module - адрес имплементации
   *     bytes4[] selectors - селектор функции
   */
  function updateModules(moduleDefinition[] memory modules) external {
    dynamicRouterStorage storage _storage = _getStorage(SLOT);
    for (uint256 i = 0; i < modules.length; ++i) {
      moduleDefinition memory module = modules[i];

      for (uint256 j = 0; j < module.selectors.length; ++j) {
        bytes4 _selector = module.selectors[j];
        address _module = module.module;
        if(!_findSelector(_selector) && _module != address(0)) _storage.selectors.push(_selector);
        if(!_findModule(_module) && _module != address(0))_storage.impl.push(_module);
        _storage.modules[_selector] = _module;
        emit UpdateModule(msg.sender, _module, _selector);  
      }
    }
  } 
  
  /// @dev Возвращает модуль по селектору
  function getModule(bytes4 _selector) external view returns(address){
    return _getStorage(SLOT).modules[_selector];
  }

  /// @dev Возвращает массив селекторов
  function getSelectors() external view returns(bytes4[] memory){
    return _getStorage(SLOT).selectors;
  }
  
  /// @dev Возвращает имплементации
  function getImpl() external view returns (address[] memory){
    return _getStorage(SLOT).impl;
  }

  /// @dev Возвращает по селектору адрес имплементации
  function getImp(bytes4 _selector) external view returns(address){
    return _getStorage(SLOT).modules[_selector];
  }

  /// @dev смотрим добавлен ли такой селектор
  function _findSelector(bytes4 _selector) private view returns(bool){
    dynamicRouterStorage storage _storage = _getStorage(SLOT);
    for (uint256 i = 0; i < _storage.selectors.length; ++i) {
      if(_selector == _storage.selectors[i]) return true;
    }
    return false;
  }

  /// @dev смотрим добавлен ли такой модуль 
  function _findModule(address _module) private view returns(bool){
    dynamicRouterStorage storage _storage = _getStorage(SLOT);
    for (uint256 i = 0; i < _storage.impl.length; ++i) {
      if(_module == _storage.impl[i]) return true;
    }
    return false;
  }

  /// @dev получаем имплементацию по селектору
  function _getModule(bytes4 _selector) private view returns(address){
    return _getStorage(SLOT).modules[_selector];
  }
  
  /// @dev получение хранилища
  function _getStorage(bytes32 _storage) private pure returns (dynamicRouterStorage storage s){
    assembly{
        s.slot := _storage
    }
  }
}