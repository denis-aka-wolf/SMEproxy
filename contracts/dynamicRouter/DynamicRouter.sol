// SPDX-License-Identifier: CC0
pragma solidity = 0.8.19 || 0.8.20 || 0.8.23;

import {DynamicRouterStorage} from "./DynamicRouterStorage.sol";
import "./IDynamicRouter.sol";
/**
* @author ACTPOHABT denis.aka.wolf@gmail.com
*
* @dev Динамический маршрутизатор
*/
contract DynamicRouter is IDynamicRouter{

  /// @dev в конструкторе необходимо передать данные по модулю UpdateProxy
  constructor(moduleDefinition[] memory modules){
    DynamicRouterStorage.updateModules(modules);
  } 
  
  fallback() external payable {_forward();}

  receive() external payable {}

  /// @dev каноническая реализация proxy delegatecall
  function _forward() private{
    bytes4 _selector = msg.sig;
    dynamicRouterStorage storage _storage = getStorage(DynamicRouterStorage.SLOT);
    address _impl = _storage.modules[_selector]; 
    
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