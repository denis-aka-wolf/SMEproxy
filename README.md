# SoulMate Ecosystem

Перед деплоем необходимо в окружение добавить ключ

```shell
npx hardhat vars set PK_BNB 
npx hardhat vars set PK_POLYGON
```
Сеть BNB устарела, в последующих релизах будет исключена

Тестирование проводится на Amoy
Имя сети: Amoy
Новый URL-адрес RPC: https://rpc-amoy.polygon.technology/.
Идентификатор сети: 80002
Символ валюты: MATIC
URL-адрес Block Explorer: https://www.oklink.com/amoy
Кран: https://faucet.polygon.technology/


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

## Proxy
Реализация классического динамического прокси с добавлением таблицы вызываемых функций.

## Solhint
Solhint при каждом запуске проверяет наличие новых весрсий, для избежания коллизий стоит использовать опцию --disc

Для отключения всех проверок:
// solhint-disable-next-line

Отключить только определенные правила:
// solhint-disable-next-line not-rely-on-time, not-rely-on-block-hash

Либо для группы строк:
/* solhint-disable avoid-tx-origin */
...
/* solhint-enable avoid-tx-origin */


## Пример дерева Меркла 
Для белых списков используется дерево Меркла для проверки при минте NFT в смарт-контрактах.

Сначала создается дерево Меркала из всех адресов, внесенныых в беллый список, и генерируется корневой хэш.
В примере используется NodeJs и библиотека merkletreejs

```shell
const {MerkleTree} = require("merkletreejs");
const keccak256 = require("keccak256");
const whitelist = ['0x6090A6e47849629b7245Dfa1Ca21D94cd15878Ef','0xBE0eB53F46cd790Cd13851d5EFf43D12404d33E8'];
const leaves = whitelist.map(addr => keccak256(addr));
const merkleTree = new MerkleTree(leaves, keccak256, {sortPairs: true});
const rootHash = merkleTree.getRoot().toString('hex');
console.log(`Whitelist Merkle Root: 0x${rootHash}`);
whitelist.forEach((address) => {
  const proof =  merkleTree.getHexProof(keccak256(address));
  console.log(`Adddress: ${address} Proof: ${proof}`);
});
```
