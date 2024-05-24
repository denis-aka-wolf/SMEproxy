// SPDX-License-Identifier: CC0
pragma solidity = 0.8.19 || 0.8.20 || 0.8.23;

import {Context} from "contracts/lib/@openzeppelin/contracts/Context.sol";

import {OwnableStorage} from "contracts/storage/LibOwnableStorage.sol";

/**
 * @title Ownable
 * @custom:version 1.0.0
 * @dev Миксин модификатора владельца.
 *      Для использования необходимо импортировать:
 *      import {Ownable} from "/contracts/mixins/Ownable.sol";
 *      Затем наследовать: contract MyContact is Ownable
 *      И использовать: function myF() external onlyOwner{}
 *      
 * @notice Миксин Ownable цель которого является предоставление  
 *      классического модификатора onlyOwner()
 *      Зависим от внешней библиотеки openzeppelin/contracts/Context.sol
**/
abstract contract Ownable is Context {

    /**
     * @dev Основной модификатор доступа проверки на владельца
     *      минимальная реализация сверки Owner с msg.sender
     **/
    modifier onlyOwner() virtual{
        require(OwnableStorage.getOwner() == _msgSender(), "You are not an owner");
        _;
    }

    /**
     * @dev Инициализация владельца. Используется единократно для модулей в конструкторах.
     **/
    function _initOwnable() internal {
        if(OwnableStorage.getOwner() == address(0)){
            OwnableStorage.setowner(_msgSender());
            OwnableStorage.setGracePeriod(7 days);
        }
    }
}