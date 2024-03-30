// SPDX-License-Identifier: CC0
pragma solidity = 0.8.19 || 0.8.20 || 0.8.23;

/**
* @author ACTPOHABT denis.aka.wolf@gmail.com
*
* @dev Управление владельцем с двойным подтверждением и таймлоком
*   базовый контроль доступа
*   только данный миксин реализован без использования механизмов хранилища экосистемы
*/
abstract contract Ownable {
    uint constant MAX_GRACE_PERIOD = 7 days; //максимальное значение грейс периода
    uint constant INITIAL_GRACE_PERIOD = 1 days; //начальное значение грейс периода

    address private owner; // владелец
    address private newOwner; // новый владелец которому передаются права
    uint private timestampExp; //время экспирации перехода прав
    uint private gracePeriod; //в секундах

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

    /// @dev Основной модификатор доступа проверки на владельца
    modifier onlyOwner() virtual{
        if (owner != msg.sender)_accessDenied();
        _;
    }

    /// @dev используется в данном контракте
    modifier _onlyNewOwner() { 
        if (newOwner != msg.sender)_accessDenied();
        _;
    }

    /// @dev используется в данное контракте
    modifier _isValidTimestamp(){ 
        if (timestampExp > block.timestamp) revert TimedOut(msg.sender); 
        _;
    }

    /// @dev право владения не устанавливается по умолчанию
    ///      поэтому нужно явно указывать владельца
    constructor(address _ownerOverride) {
        owner = _ownerOverride; //_ownerOverride == address(0) ? _ownerOverride : msg.sender;
        gracePeriod = INITIAL_GRACE_PERIOD;
    }

    
    function getGracePeriod()external view onlyOwner returns(uint){return gracePeriod;}
    function getOwner()external view onlyOwner returns(address){return owner;}
    function getNewOwner()external view onlyOwner returns(address){return newOwner;}
    function getTimestampExp()external view onlyOwner returns(uint){return timestampExp;}
    
    /// @dev установка грейс периода
    function setGracePeriod(uint _seconds) external onlyOwner{
        if(_seconds > 604800) revert ValueTooHigh(_seconds); //7 дней 
        gracePeriod = _seconds;
        emit SetNewGracePeriod(msg.sender, gracePeriod);
    }

    /// @dev инициализация передачи прав
    function transferOwner(address _to) external onlyOwner {
        _checkAddress(_to);
        newOwner = _to;
        _setTimestampExp();
        emit InitialTransferOwner(msg.sender, _to, block.timestamp);
    }

    /// @dev подтверждение передачи прав новым владельцем
    function transferNewOwnerAccept() external _onlyNewOwner _isValidTimestamp{
        owner = newOwner;
        newOwner = address(0);
        timestampExp = 0;
        emit AcceptTransferNewOwner(newOwner, block.timestamp);
    }
 
    function _setTimestampExp() private onlyOwner{
        timestampExp = block.timestamp + gracePeriod;
    }

    function _checkAddress(address _address) private view onlyOwner {
        if (_address == address(0)) revert EmptyAddress();
    }

    function _accessDenied() private view{
        revert AccessDenied(msg.sender);
    }

}