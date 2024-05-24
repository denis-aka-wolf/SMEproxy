// SPDX-License-Identifier: CC0
pragma solidity = 0.8.19 || 0.8.20 || 0.8.23;

/**
* @dev Модуль управления владельцем
*/
interface IOwnable {

    /// @dev Пустой адрес
    error EmptyAddress();
    /// @dev Функцию использует на владелец
    error AccessDenied(address); 
    /// @dev Время перехода прав новому владельцу завершено
    error TimedOut(address); 
    //// @dev Слишком большое значени gracePeriod 
    error ValueTooHigh(uint); 
    
    /// @dev Инициация передачи прав владения
    event InitialTransferOwner(address indexed oldOwner, address indexed newOwner,  uint timestamp);
    /// @dev Подтверждение передачи прав новым владельцем
    event AcceptTransferNewOwner(address indexed _to,  uint _timestamp);
    /// @dev Установлено новое значение грейс периода
    event SetNewGracePeriod(address indexed _to,  uint _graceperiod);
    
    /// @dev Геттеры
    function getGracePeriod()external view returns(uint);
    function getOwner()external view returns(address);
    function getNewOwner()external view returns(address);
    function getTimestampExp()external view returns(uint);
    
    /// @dev установка грейс периода
    function setGracePeriod(uint _seconds) external;

    /// @dev инициализация передачи прав
    function transferOwner(address _to) external ;

    /// @dev подтверждение передачи прав новым владельцем
    function transferNewOwnerAccept() external ;
}