# SoulMate Ecosystem Proxy

Реализация классического динамического прокси с добавлением таблицы вызываемых функций.

Перед деплоем необходимо в окружение добавить ключ

```shell
npx hardhat vars set PK_BNB
```

Для верификации на сканерах указать API_KEY сканер 
POLYGONSCAN_API_KEY - https://polygonscan.com/
BNB_API_KEY - https://bscscan.com/

```shell
npx hardhat vars set POLYGONSCAN_API_KEY
```

Если в контракты была добавлена еще какая-либо функция, то нужно делать компиляцию заново предварительно очистив для того чтобы были сгенерированы typings! Иначе могут быть проблемы с typechain.
Тесты запускать каждый раз все, не зависимо от того какое было изменение.

```shell
npx hardhat clean
npx hardhat compile
REPORT_GAS=true npx hardhat test
```

Проверка покрытия тестами:

```shell
npx hardhat coverage
```

Линковка
Для модуля UpdateProxy необходимо слинковать библиотеку DynamicRouterStorage.
В случае если в сети деплоя уже имеется развернутая библиотека, в скрипт деплоя нужно указать актуальный адрес.

```js
// обычная линковка
const dynamicRouterStorage = m.library("DynamicRouterStorage");

// с развернутой библиотекой
const dynamicRouterStorage = m.contractAt("DynamicRouterStorage", "0x...");
```

Деплой:

```shell
npx hardhat ignition deploy ./ignition/modules/proxy.ts --network bnb
```

