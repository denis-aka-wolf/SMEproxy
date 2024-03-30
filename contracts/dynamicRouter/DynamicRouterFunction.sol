// SPDX-License-Identifier: CC0
pragma solidity = 0.8.19 || 0.8.20 || 0.8.23;

import "./../utils/FreeFunction.sol";
import "./DynamicRouterType.sol";

/**
* @author ACTPOHABT denis.aka.wolf@gmail.com
*
* @dev Тут хранятся все Free function
*/

/// @dev получение хранилища
function getStorage(bytes32 _storage) pure returns (dynamicRouterStorage storage s){
    assembly{
      s.slot := _storage
    }
}