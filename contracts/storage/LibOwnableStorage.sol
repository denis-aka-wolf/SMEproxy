// SPDX-License-Identifier: CC0
pragma solidity = 0.8.19 || 0.8.20 || 0.8.23;

/**
 * @title OwnableStorage
 * @custom:version 1.0.0
 * @dev Логику смотри в модуле Ownable
 * @notice Библиотека хранилища миксина Ownable
**/
library OwnableStorage {

  /// @dev Слот хранилища
  bytes32 constant SLOT = keccak256(bytes('Ownable'));

  uint constant MAX_GRACE_PERIOD = 7 days; //максимальное значение грейс периода
  uint constant INITIAL_GRACE_PERIOD = 1 days; //начальное значение грейс периода

  struct ownableStorage{
    address owner; // владелец
    address newOwner; // новый владелец которому передаются права
    uint timestampExp; //время экспирации перехода прав
    uint gracePeriod; //в секундах
  }
  
  /// @dev Установлено новое значение newOwner
  event SetOwner();
  /// @dev Установлено новое значение newOwner
  event SetNewOwner();
  /// @dev Установлено новое значение timestampExp
  event SeTimestampExp();
  /// @dev Установлено новое значение грейс периода
  event SetGracePeriod();
  
  /// @dev геттеры
  function getOwner()external view returns(address){return _getStorage(SLOT).owner;}
  function getNewOwner()external view returns(address){return _getStorage(SLOT).newOwner;}
  function getTimestampExp()external view returns(uint){return _getStorage(SLOT).timestampExp;}
  function getGracePeriod()external view returns(uint){return _getStorage(SLOT).gracePeriod;}
  
  /// @dev установка owner
  function setowner(address _owner) external{
      _getStorage(SLOT).owner = _owner;
      emit SetOwner();
  }

  /// @dev установка newOwner
  function setnewOwner(address _newOwner) external{
      _getStorage(SLOT).newOwner = _newOwner;
      emit SetNewOwner();
  }

  /// @dev установка timestampExp
  function setTimestampExp(uint _timestampExp) external{
      _getStorage(SLOT).timestampExp = _timestampExp;
      emit SeTimestampExp();
  }

  /// @dev установка gracePeriod
  function setGracePeriod(uint _seconds) external{
      _getStorage(SLOT).gracePeriod = _seconds;
      emit SetGracePeriod();
  }

  /// @dev получение хранилища
  function _getStorage(bytes32 _storage) private pure returns (ownableStorage storage s){
    assembly{
        s.slot := _storage
    }
  }
}