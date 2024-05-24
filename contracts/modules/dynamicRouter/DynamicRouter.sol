// SPDX-License-Identifier: CC0
pragma solidity = 0.8.19 || 0.8.20 || 0.8.23;

import {DynamicRouterStorage} from "/contracts/storage/LibDynamicRouterStorage.sol";
import {OwnableStorage} from "/contracts/storage/LibOwnableStorage.sol";
import "./IDynamicRouter.sol";
import "/contracts/modules/IModule.sol";
import "/contracts/free/FreeVersion.sol";
/**
 * @title DynamicRouter
 * @custom:version 1.0.0
 * @dev Динамический маршрутизатор
*/
contract DynamicRouter is IDynamicRouter, IModule{

  /// @dev Название модуля
  string public constant MODULE_NAME = "DynamicRouter";
  /// @dev Версия модуля
  uint256 public immutable MODULE_VERSION = _encodeVersion(1, 0, 0);

  /// @dev В конструктор необходимо передать данные по модулю UpdateProxy
  constructor(DynamicRouterStorage.moduleDefinition[] memory modules){
    DynamicRouterStorage.updateModules(modules);
    OwnableStorage.setowner(msg.sender);
  } 
  
  fallback() external payable {_forward();}

  receive() external payable {}

  /// @dev каноническая реализация proxy delegatecall
  function _forward() private{
    bytes4 _selector = msg.sig;
    address _impl = DynamicRouterStorage.getImp(_selector); 
    
    if(_impl == address(0)){revert UnknownSelector(_selector);}

    assembly {
      calldatacopy(0, 0, calldatasize())

      let result := delegatecall(gas(), _impl, 0, calldatasize(), 0, 0)

      returndatacopy(0, 0, returndatasize())

      switch result
        case 0 {revert (0, returndatasize())}
        default {return (0, returndatasize())}
    }
  }
}