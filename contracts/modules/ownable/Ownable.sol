// SPDX-License-Identifier: CC0
pragma solidity = 0.8.19 || 0.8.20 || 0.8.23;

import {Context} from "contracts/lib/@openzeppelin/contracts/Context.sol";

import {OwnableStorage} from "contracts/storage/LibOwnableStorage.sol";
import "./IOwnable.sol";
import "/contracts/modules/IModule.sol";
import "/contracts/free/FreeVersion.sol";

/**
 * @title UpdateProxy
 * @custom:version 1.0.0
 * @dev Модуль управления владельцем
 *      Модуль возможно использовать как отдельно, так и в качестве миксина
 * @notice Библиотека хранилища миксина Ownable
**/
contract Ownable is Context, IOwnable, IModule{

    /// @dev Название модуля
    string public constant MODULE_NAME = "Ownable";
    /// @dev Версия модуля
    uint256 public immutable MODULE_VERSION = _encodeVersion(1, 0, 0);

    uint constant MAX_GRACE_PERIOD = 7 days; //максимальное значение грейс периода
    uint constant INITIAL_GRACE_PERIOD = 1 days; //начальное значение грейс периода

    /// @dev Основной модификатор доступа проверки на владельца
    modifier onlyOwner() virtual{
        if (_getOwner() != _msgSender())_accessDenied();
        _;
    }

    /// @dev используется в данном контракте
    modifier _onlyNewOwner() { 
        if (_getNewOwner() != _msgSender())_accessDenied();
        _;
    }

    /// @dev используется в данном контракте
    modifier _isValidTimestamp(){ 
        if (_getTimestampExp() < block.timestamp) revert TimedOut(_msgSender()); 
        _;
    }

     constructor(){
        OwnableStorage.setowner(_msgSender());
        OwnableStorage.setGracePeriod(INITIAL_GRACE_PERIOD);
    }

    function getOwner()external view returns(address){return _getOwner();}
    function getNewOwner()external view returns(address){return _getNewOwner();}
    function getGracePeriod()external view returns(uint){return _getGracePeriod();}
    function getTimestampExp()external view returns(uint){return _getTimestampExp();}
    
    /// @dev установка грейс периода
    function setGracePeriod(uint _seconds) external onlyOwner{
        if(_seconds > 604800) revert ValueTooHigh(_seconds); //7 дней 
        OwnableStorage.setGracePeriod(_seconds);
        emit SetNewGracePeriod(_msgSender(), _seconds);
    }

    /// @dev инициализация передачи прав
    function transferOwner(address _to) external onlyOwner {
        _checkAddress(_to);
        OwnableStorage.setnewOwner(_to);
        _setTimestampExp();
        emit InitialTransferOwner(_msgSender(), _to, block.timestamp);
    }

    /// @dev подтверждение передачи прав новым владельцем
    function transferNewOwnerAccept() external _onlyNewOwner _isValidTimestamp{
        address _newOwner = _getNewOwner();
        OwnableStorage.setowner(_newOwner);
        OwnableStorage.setnewOwner(address(0));
        OwnableStorage.setTimestampExp(0);
        emit AcceptTransferNewOwner(_newOwner, block.timestamp);
    }
    
    function _getNewOwner()private view returns(address){return OwnableStorage.getNewOwner();}
    function _getOwner()private view returns(address){return OwnableStorage.getOwner();}
    function _getTimestampExp()private view returns(uint){return OwnableStorage.getTimestampExp();}
    function _getGracePeriod()private view returns(uint){return OwnableStorage.getGracePeriod();}
    
    /// @dev установка timestampExp
    function _setTimestampExp() private onlyOwner{
        OwnableStorage.setTimestampExp(block.timestamp + _getGracePeriod());
    }

    function _checkAddress(address _address) private view onlyOwner {
        if (_address == address(0)) revert EmptyAddress();
    }

    function _accessDenied() private view{revert AccessDenied(_msgSender());}
}