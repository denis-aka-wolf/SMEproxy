// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

//import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "erc721a/contracts/ERC721A.sol"; // активно использует хранилище
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol"; // активно использует хранилище


import "contracts/lib/@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
//import "@openzeppelin/contracts/utils/Address.sol";

//import {Strings} from "contracts/lib/@openzeppelin/contracts/utils/Strings.sol";

//import "@openzeppelin/contracts/utils/Counters.sol";
import "contracts/lib/@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "contracts/lib/@openzeppelin/contracts/security/ReentrancyGuard.sol";

//import {IERC4906} from "contracts/lib/@openzeppelin/contracts/interfaces/IERC4906.sol";
//import {IERC165} from "contracts/lib/@openzeppelin/contracts/interfaces/IERC165.sol";

import {DynamicRouterStorage} from "/contracts/storage/LibDynamicRouterStorage.sol";
import {Ownable} from "/contracts/mixins/Ownable.sol";
//import "./IDynamicRouter.sol";
import "/contracts/modules/IModule.sol";
import "/contracts/free/FreeVersion.sol";

/**
 * @title SMEamb
 * @custom:version 1.0.0
 * @dev Модуль NFT амбассадоров клуба SoulMate Ambassador Club
 * @notice Первая стадия минта GENESIS
**/
contract SMEamb is ERC721A, Ownable, ReentrancyGuard, IERC721Receiver, IModule  {
    
    using Strings for uint256;
    
    // Маппинг всех URI для токенов для дальнешего точечного изменения
    mapping(uint256 tokenId => string) private _tokenURIs;

///// владение токенами
    mapping(address owner => mapping(uint256 index => uint256)) private _ownedTokens;
    mapping(uint256 tokenId => uint256) private _ownedTokensIndex;

    /// @dev РЕФАКТОРИНГ все токены - заменить из ERC721A
    uint256[] private _allTokens; 
    mapping(uint256 tokenId => uint256) private _allTokensIndex;
/////



    /// @dev Название модуля
    string public constant MODULE_NAME = "DynamicRouter";
    /// @dev Версия модуля
    uint256 public immutable MODULE_VERSION = _encodeVersion(1, 0, 0);

    string private _baseTokenURI;
    string private _defaultTokenURI;
    uint256 public constant MAX_SUPPLY_GENESIS = 1200;
    uint256 public constant MAX_SUPPLY_LEGEND = 5000;
    uint256 public constant MAX_SUPPLY_EPIC = 25000;
    bytes32 public genesislistRoot; 
    bytes32 public legendlistRoot; 
    bytes32 public epiclistRoot; 
    uint256 public fee;
    mapping(address => bool) public guaranteed_minted; 
    mapping(address => uint256) public whitelist_minted;
    address public refundAddress;
    mapping(uint256 => bool) public hasRefunded;

    event Refund(address indexed _sender, uint256 indexed _tokenId);

        /// @dev This event emits when the metadata of a token is changed.
    /// So that the third-party platforms such as NFT market could
    /// timely update the images and related attributes of the NFT.
    event MetadataUpdate(uint256 _tokenId);

    /// @dev This event emits when the metadata of a range of tokens is changed.
    /// So that the third-party platforms such as NFT market could
    /// timely update the images and related attributes of the NFTs.
    event BatchMetadataUpdate(uint256 _fromTokenId, uint256 _toTokenId);

    constructor() ERC721A("TEST NFT Genesis SMAC", "SMEamb") {
        _baseTokenURI = "http://158.160.153.72:8080/ipfs/QmP2VvsL8X9YzKVzVoGycokjwc3Tqyk9Q57XEeTrMvjnFo/";
        _defaultTokenURI = "http://158.160.153.72:8080/ipfs/QmP2VvsL8X9YzKVzVoGycokjwc3Tqyk9Q57XEeTrMvjnFo/1.json";
        refundAddress = address(this);
        fee = 5000000000000000000;
    }

    function setFee(uint256 _fee) external onlyOwner {
        fee = _fee;
    }

    function setGenesisRoot(bytes32 merkleroot) external onlyOwner {
        genesislistRoot = merkleroot;
    }

    function setLegendlistRoot(bytes32 merkleroot) external onlyOwner {
        legendlistRoot = merkleroot;
    }

    function setEpiclistRoot(bytes32 merkleroot) external onlyOwner {
        epiclistRoot = merkleroot;
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes memory data
    ) public override returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }
    
    /// @dev Переопределим стартовый индекс токена
    function _startTokenId() internal view virtual override returns (uint256) {
        return 1;
    }

    /// @dev Минт для генезисов - передает proof для проверки
    function genesisMint(address to, bytes32[] calldata proof) external payable nonReentrant {
        uint256 _tokenId = _nextTokenId();
        require( _tokenId < MAX_SUPPLY_GENESIS, "Exceed alloc");
        require(guaranteed_minted[to] == false, "Already minted");
        require(msg.value == fee, "Not match price");
        bytes32 leaf = keccak256(abi.encodePacked(to));
        bool isValidLeaf = MerkleProof.verify(proof, genesislistRoot, leaf);
        require(isValidLeaf == true, "Not in merkle");
        guaranteed_minted[to] = true;
        _safeMint(to, 1);
        _setTokenURI(_tokenId, _tokenURI(_tokenId));
        _updateOwner(address(0x0),to,_tokenId);
    }

    /// @dev Возвращает существует ли tokenId
    function exists(uint256 tokenId) external view returns (bool result){
        return _exists(tokenId);
    }

    function setBaseURI(string calldata URI) external onlyOwner {
        _baseTokenURI = URI;
    }

    function setTokenURI(uint256 tokenId, string calldata URI) external onlyOwner {
        _setTokenURI(tokenId, URI);
    }

    function setDefaultTokenURI(string calldata URI) external onlyOwner {
        _defaultTokenURI = URI;
    }

    function baseURI() public view returns (string memory) {
        return _baseTokenURI;
    }

    function _tokenURI(uint256 tokenId) private view returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory _baseURI = baseURI();
        return bytes(_baseURI).length > 0 ? string(abi.encodePacked(_baseURI, tokenId.toString(),".json")) : _defaultTokenURI;
    }

    function withdraw() external onlyOwner nonReentrant {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Transfer failed.");
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        //_requireOwned(tokenId);

        string memory _tokenURI = _tokenURIs[tokenId];
        string memory base = _baseURI();

        // If there is no base URI, return the token URI.
        if (bytes(base).length == 0) {
            return _tokenURI;
        }
        // If both are set, concatenate the baseURI and tokenURI (via string.concat).
        if (bytes(_tokenURI).length > 0) {
            return string.concat(base, _tokenURI);
        }

        return super.tokenURI(tokenId);
    }

    /**
     * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
     *
     * Emits {MetadataUpdate}.
     */
    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        _tokenURIs[tokenId] = _tokenURI;
        emit MetadataUpdate(tokenId);
    }

    /**
     * @dev Возвращает идентификатор токена по индексу
     */
    function balanceOfId(address owner, uint256 index) public view returns (uint256) {
        //if (owner == address(0)) _revert(BalanceQueryForZeroAddress.selector);
        return _ownedTokens[owner][index];
    }

    /**
     * @dev Обновляем владельцев токена
     */
    function _updateOwner(address previousOwner, address to, uint256 tokenId ) internal {

        if (previousOwner == address(0)) {  // добавление токена в структуры отслеживания
            _addTokenToAllTokensEnumeration(tokenId);
        } else if (previousOwner != to) { // удаление у владельца
            _removeTokenFromOwnerEnumeration(previousOwner, tokenId);
        }
        if (to == address(0)) { //удаление токена из структур отслеживания
            _removeTokenFromAllTokensEnumeration(tokenId);
        } else if (previousOwner != to) {  //добавляем токен новому владельцу
            _addTokenToOwnerEnumeration(to, tokenId);
        } 

    }

        /**
     * @dev Добавление токена в структуры для отслеживания
     * @param tokenId uint256 идентификатор токена
     */
    function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    /**
     * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
     * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
     * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
     * This has O(1) time complexity, but alters the order of the _ownedTokens array.
     * @param from address representing the previous owner of the given token ID
     * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
     */
    function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
        // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
        // then delete the last slot (swap and pop).

        uint256 lastTokenIndex = balanceOf(from);
        uint256 tokenIndex = _ownedTokensIndex[tokenId];

        // When the token to delete is the last token, the swap operation is unnecessary
        if (tokenIndex != lastTokenIndex) {
            uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];

            _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
            _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
        }

        // This also deletes the contents at the last position of the array
        delete _ownedTokensIndex[tokenId];
        delete _ownedTokens[from][lastTokenIndex];
    }

        /**
     * @dev Private function to remove a token from this extension's token tracking data structures.
     * This has O(1) time complexity, but alters the order of the _allTokens array.
     * @param tokenId uint256 ID of the token to be removed from the tokens list
     */
    function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
        // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
        // then delete the last slot (swap and pop).

        uint256 lastTokenIndex = _allTokens.length - 1;
        uint256 tokenIndex = _allTokensIndex[tokenId];

        // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
        // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
        // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
        uint256 lastTokenId = _allTokens[lastTokenIndex];

        _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
        _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index

        // This also deletes the contents at the last position of the array
        delete _allTokensIndex[tokenId];
        _allTokens.pop();
    }


    /**
     * @dev Private function to add a token to this extension's ownership-tracking data structures.
     * @param to address representing the new owner of the given token ID
     * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
     */
    function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
        uint256 length = balanceOf(to) - 1;
        _ownedTokens[to][length] = tokenId;
        _ownedTokensIndex[tokenId] = length;
    }
}