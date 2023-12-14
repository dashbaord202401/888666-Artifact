// SPDX-License-Identifier: MIT

/* 
                 __  _  _  _____    ____  ____  ____  _  _  ___ 
                /__\( \/ )(  _  )  ( ___)(  _ \( ___)( \( )/ __)
               /(__)\\  /  )(_)(    )__)  )   / )__)  )  ( \__ \
              (__)(__)\/  (_____)  (__)  (_)\_)(____)(_)\_)(___/

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&#################&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@&&########################&&@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@&############################&@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@&##############################&@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@&%&&&&&&&%%#############%&&&&%&#####&@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&%###&########&########%%#########&#####&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@&####&########&#########&#########&###&&@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@&&&&&&&&&&&&&&&&%#####%%%&&&&&/(((((&&@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&&(((((,,,,,,,,,,,,,,,,,,,,,,,,((((*&&*@@@@@@@@@@@@@@@@@@@@
@@@&&@@@@@@@@@@@@@@@@&&((((,,,,,,%%%,,,,,,,,%%%%,,,,,(((**&&**@@@@@@@@@@@@@@@@@@
@&&&&&&&@@@@@@@@@@@@&&#((((,,,,,%%%%%,,,,,,,,,,%%,,,,,((((&**@@@@@@@@@@@@@@@@@@@
@@@&&@@@@@@@@@@@@@@@&&((((/,,,,,,,,,,,,,,,,,,,,,,,,,,,((((&&&@@@@@@@@@@@@@@@@@@@
@@@&&@@@@@@@@@@@@@@&&&((((,,,,,,,,,%%,,,,,,,%%,,,,,,,,,((((&&@@@@@@@@@@@@@@@@@@@
@@@&&&@@@@@@@@@@@@@&&((((/,,,,,,,,,,,%%%%%%%,,,,,,,,,,,((((&&&@@@@@@@@@@@@@@@@@@
@@@@&&@@@@@@@@@@@@&&(((((,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,((((&&@@@@@@@@@@@@@@@@@@
@@@@@&&&&@@@@@@@@&&#((((,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,(((((&&&&@@@@@@@@@@@@@@@
@@@@@@@@@@@&&&&&&&%((((,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,((((#&&@@&&&&&@@@@@@@@@
@@@@@@@@@@@@@@@&&(((((,,,,,,,,,,,,,,,&&&&&&%,,,,,,,,,,,,,,(((((&&@@@@@@&&&@@@@@@
@@@@@@@@@@@@@@&&(((((,,,,,,,,,,,&&&&&&&&&&&&&&&&&,,,,,,,,,,(((((&&@@@@@@@&&&@@@@
@@@@@@@@@@@@@&&(((((,,,,,,,,,#&&&&&&&&&&&&&&&&&&&&&,,,,,,,,,(((((&&@@@@@@@&&&@@@
@@@@@@@@@@@@&&#((((,,,,,,,,,&&&&&&&&&&&&&&&&&&&&&&&&&,,,,,,,,(((((&&@@@@@@@&&@@@
@@@@@@@@@@@@&&(((((,,,,,,,,%&&&&&&&&&&&&&&&&&&&&&&&&&#,,,,,,,,(((((&&@@@@@@@&&@@
@@@@@@@@@@@&&%((((,,,,,,,,(&&&&&&&&&&&&&&&&&&&&&&&&&&&,,,,,,,,,((((&&@@@@@@@&&&@
@@@@@@@@@@@&&(((((,,,,,,,,,&&&&&&&&&&&&&&&&&&&&&&&&&&&,,,,,,,,,((((%&&@@@@&&&&&&
@@@@@@@@@@@&&(((((,,,,,,,,,#&&&&&&&&&&&&&&&&&&&&&&&&&,,,,,,,,,,((((#&&@@@@&&&&@&
@@@@@@@@@@@&&(((((*,,,,,,,,,#&&&&&&&&&&&&&&&&&&&&&&&,,,,,,,,,,,((((&&&@@@@@@@@@@
@@@@@@@@@@@@&&(((((,,,,,,,,,,,#&&&&&&&&&&&&&&&&&&&,,,,,,,,,,,,(((((&&@@@@@@@@@@@
@@@@@@@@@@@@&&&(((((,,,,,,,,,,,,,##&&&&&&&&&&&#,,,,,,,,,,,,,*(((((&&@@@@@@@@@@@@
@@@@@@@@@@@@@@&&#(((((,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,/(((((%&&@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@&&&((((((,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,(((((((&&&@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@&&&&(((((((((/,,,,,,,,,,,,,,,,,/(((((((((%&&&@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@&&&&&#((((((((((((((((((((((((((((&&&&&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&&&&&&&#((((((((#&&&&&&&&&@@@@@@@@@@@@@@@@@@@@@@@@@

 */

pragma solidity ^0.8.9;

import './ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import '@openzeppelin/contracts/utils/cryptography/MerkleProof.sol';

contract AvoFrens is ERC721, ReentrancyGuard, Ownable {
  using Strings for uint256;

  uint256 private constant MAX_TOKENS_PURCHASE = 16;
  uint256 private constant MAX_TOKENS_PRESALE = 16;
  uint256 private constant TOKENS_FOR_ONE_FREE = 8;
  uint256 private constant INITIAL_TOKENS = 6;

  // Maximum amount of tokens available
  uint256 public maxTokens = 10000;

  // Amount of ETH required per mint
  uint256 public price  = 75000000000000000; // 0.075 ETH;

  // Contract to recieve ETH raised in sales
  address public vault = 0x0Efa349d9A0b6b25651a1f1Bed9FeC5B0dc0F2F0;

  // Control for public sale
  bool public isRevealed = false;

  // Control for public sale
  bool public isActive = false;

  // Control for claim process
  bool public isClaimActive = false;

  // Control for presale
  bool public isPresaleActive = false;

  // Used for verification that an address is included in claim process
  bytes32 public claimMerkleRoot;

  // Used for verification that an address is included in presale
  bytes32 public presaleMerkleRoot;

  // Reference to image and metadata storage
  string private _baseTokenURI = "https://www.avofrens.com/nft/prereveal/";

  // Storage of addresses that have minted with the `claim()` function
  mapping(address => bool) private claimParticipants;

  // Storage of addresses that have minted with the `presale()` function
  mapping(address => bool) private presaleParticipants;

  // Constructor
  constructor() ERC721("Avo Frens", "AVF") {
  }

  // Override of `_baseURI()` that returns _baseTokenURI
  function _baseURI() internal view virtual override returns (string memory) {
    return _baseTokenURI;
  }

 // Sets `_baseTokenURI` to be returned by `_baseURI()`
  function setBaseURI(string memory baseURI) public onlyOwner {
    _baseTokenURI = baseURI;
  }

  // Sets `isRevealed` to activate specific `tokenURI()`
  function setRevealed(bool _isRevealed) external onlyOwner {
    isRevealed = _isRevealed;
  }

  // Are the tokens revealed
  function _revealed() internal view virtual override returns (bool) {
    return isRevealed;
  }

  // Sets `isActive` to turn on/off minting in `mint()`
  function setActive(bool _isActive) external onlyOwner {
    isActive = _isActive;
  }

  // Sets `isClaimActive` to turn on/off minting in `claim()`
  function setClaimActive(bool _isClaimActive) external onlyOwner {
    isClaimActive = _isClaimActive;
  }

  // Sets `claimMerkleRoot` to be used in `presale()`
  function setClaimMerkleRoot(bytes32 _claimMerkleRoot) external onlyOwner {
    claimMerkleRoot = _claimMerkleRoot;
  }

  // Sets `isPresaleActive` to turn on/off minting in `presale()`
  function setPresaleActive(bool _isPresaleActive) external onlyOwner {
    isPresaleActive = _isPresaleActive;
  }

  // Sets `presaleMerkleRoot` to be used in `presale()`
  function setPresaleMerkleRoot(bytes32 _presaleMerkleRoot) external onlyOwner {
    presaleMerkleRoot = _presaleMerkleRoot;
  }

  // Sets `maxTokens`
  function setMaxTokens(uint256 _maxTokens) public onlyOwner {
    maxTokens = _maxTokens;
  }

  // Sets `price` to be used in `presale()` and `mint()`(called on deployment)
  function setPrice(uint256 _price) public onlyOwner {
    price = _price;
  }

  // Sets `vault` to recieve ETH from sales and used within `withdraw()`
  function setVault(address _vault) external onlyOwner {
    vault = _vault;
  }

  // Minting function used in the claim process (Max 1 per wallet)
  function claim(bytes32[] calldata _merkleProof) external {
    uint256 supply = totalSupply();
    require(isClaimActive, 'Not Active');
    require(supply < maxTokens, 'Supply Denied');
    require(!claimParticipants[_msgSender()], 'Mint Already Claimed');

    bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
    require(MerkleProof.verify(_merkleProof, claimMerkleRoot, leaf), 'Proof Invalid');

    _safeMint(_msgSender(), supply + 1);

    claimParticipants[_msgSender()] = true;
  }

  // Minting function used in the presale
  function presale(bytes32[] calldata _merkleProof, uint256 _amount) external payable {
    uint256 supply = totalSupply();

    require(isPresaleActive, 'Not Active');
    require(_amount <= MAX_TOKENS_PRESALE, 'Amount Denied');
    require(supply + _amount <= maxTokens, 'Supply Denied');
    require(!presaleParticipants[_msgSender()], 'Presale Already Claimed');
    require(msg.value >= price * _amount, 'Ether Amount Denied');

    bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
    require(MerkleProof.verify(_merkleProof, presaleMerkleRoot, leaf), 'Proof Invalid');

    _amount = _amount + _amount / TOKENS_FOR_ONE_FREE;
    for(uint256 i=1; i <= _amount; i++){
      _safeMint(_msgSender(), supply + i );
    }

    presaleParticipants[_msgSender()] = true;
  }

  // Minting function used in the public sale
  function mint(uint256 _amount) external payable {
    uint256 supply = totalSupply();

    require(isActive, 'Not Active');
    require(_amount <= MAX_TOKENS_PURCHASE, 'Amount Denied');
    require(supply + _amount <= maxTokens, 'Supply Denied');
    require(msg.value >= price * _amount, 'Ether Amount Denied');
    
    _amount = _amount + _amount / TOKENS_FOR_ONE_FREE;
    for(uint256 i=1; i <= _amount; i++){
      _safeMint(_msgSender(), supply + i);
    }
  }

  // Initial minting for owner
  function initialMint() external onlyOwner {
    uint256 supply = totalSupply();
    for(uint256 i=1; i <= INITIAL_TOKENS; i++){
      _safeMint(_msgSender(), supply + i);
    }
  }

  // Send balance of contract to address referenced in `vault`
  function withdrawToVault() external nonReentrant onlyOwner {
    require(vault != address(0), 'Vault Invalid');
    (bool success, ) = vault.call{value: address(this).balance}("");
    require(success, "Failed to send to vault.");
  }

  // Send amount to address referenced in `vault`
  function withdrawAmtToVault(uint256 amount) external nonReentrant onlyOwner {
    require(vault != address(0), 'Vault Invalid');
    (bool success, ) = vault.call{value: amount}("");
    require(success, "Failed to send to vault.");
  }
  
  // Send balance of contract to owner wallet
  function withdrawToOwner() external nonReentrant onlyOwner {
    require(vault != address(0), 'Vault Invalid');
    (bool success, ) = _msgSender().call{value: address(this).balance}("");
    require(success, "Failed to send to vault.");
  }

  // Send amount to address referenced in `vault`
  function withdrawAmtToOwner(uint256 amount) external nonReentrant onlyOwner {
    require(vault != address(0), 'Vault Invalid');
    (bool success, ) = _msgSender().call{value: amount}("");
    require(success, "Failed to send to vault.");
  }
}

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
  using Address for address;
  using Strings for uint256;

  string private _name;
  string private _symbol;

  address[] internal _owners;

  mapping(uint256 => address) private _tokenApprovals;
  mapping(address => mapping(address => bool)) private _operatorApprovals;

  // Initializes the contract by setting a `name` and a `symbol` to the token collection.
  constructor(string memory name_, string memory symbol_) {
    _name = name_;
    _symbol = symbol_;
  }

  // See {IERC165-supportsInterface}.
  function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
    return interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC721Metadata).interfaceId || super.supportsInterface(interfaceId);
  }


  // See {IERC721-balanceOf}.
  function balanceOf(address owner) public view virtual override returns (uint) {
    require(owner != address(0), "ERC721: balance query for the zero address");

    uint count;
    for(uint i; i < _owners.length; ++i){
      if(owner == _owners[i]) ++count;
    }
    return count;
  }


  // See {IERC721-ownerOf}.
  function ownerOf(uint256 tokenId) public view virtual override returns (address) {
    require(tokenId >= 1, "Token ID too low");
    require(tokenId <= totalSupply(), "Token ID too high");
    address owner = _owners[tokenId-1];
    require(owner != address(0), "ERC721: owner query for nonexistent token");
    return owner;
  }

  // See {IERC721Metadata-name}.
  function name() public view virtual override returns (string memory) {
    return _name;
  }

  // See {IERC721Metadata-symbol}.
  function symbol() public view virtual override returns (string memory) {
    return _symbol;
  }

  // Base URI for computing {tokenURI}.
  function _baseURI() internal view virtual returns (string memory) {
    return "";
  }

  // Are the tokens revealed
  function _revealed() internal view virtual returns (bool) {
    return false;
  }

  // See {IERC721Metadata-tokenURI}.
  function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
    require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
    string memory baseURI = _baseURI();
    if(!_revealed()){
      return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, "prereveal.json")) : "";
    }else{
      return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
    }
  }
  // Returns totalSupply
 function totalSupply() public view virtual returns (uint256) {
    return _owners.length;
  }

  // See {IERC721-approve}.
  function approve(address to, uint256 tokenId) public virtual override {
    address owner = ERC721.ownerOf(tokenId);
    require(to != owner, "ERC721: approval to current owner");
    require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()), "ERC721: approve caller is not owner nor approved for all");

    _approve(to, tokenId);
  }

  // See {IERC721-getApproved}.
  function getApproved(uint256 tokenId) public view virtual override returns (address) {
    require(_exists(tokenId), "ERC721: approved query for nonexistent token");
    return _tokenApprovals[tokenId];
  }

  // See {IERC721-setApprovalForAll}.
  function setApprovalForAll(address operator, bool approved) public virtual override {
    require(operator != _msgSender(), "ERC721: approve to caller");

    _operatorApprovals[_msgSender()][operator] = approved;
    emit ApprovalForAll(_msgSender(), operator, approved);
  }

  // See {IERC721-isApprovedForAll}.
  function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
    /** @dev Opensea whitelisting */
    if(operator == address(0xa5409ec958C83C3f309868babACA7c86DCB077c1)){
        return true;
    }
    return _operatorApprovals[owner][operator];
  }
  // See {IERC721-transferFrom}.
  function transferFrom(address from, address to, uint256 tokenId) public virtual override {
    require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
    _transfer(from, to, tokenId);
  }

  // See {IERC721-safeTransferFrom}.
  function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
    safeTransferFrom(from, to, tokenId, "");
  }

  // See {IERC721-safeTransferFrom}.
  function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
    require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
    _safeTransfer(from, to, tokenId, _data);
  }


  // Safely transfers `tokenId` token from `from` to `to`.
  function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
    _transfer(from, to, tokenId);
    require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
  }

  // Returns whether `tokenId` exists.
  function _exists(uint256 tokenId) internal view virtual returns (bool) {
    return tokenId >= 1 && tokenId <= _owners.length && _owners[tokenId-1] != address(0);
  }

  // Returns whether `spender` is allowed to manage `tokenId`.
  function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
    require(_exists(tokenId), "ERC721: operator query for nonexistent token");
    address owner = ERC721.ownerOf(tokenId);
    return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
  }

  // Safely mints `tokenId` and transfers it to `to`.
  function _safeMint(address to, uint256 tokenId) internal virtual {
    _safeMint(to, tokenId, "");
  }

  // Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter.
  function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
    _mint(to, tokenId);
    require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
  }

  // Mints `tokenId` and transfers it to `to`.
  function _mint(address to, uint256 tokenId) internal virtual {
    require(to != address(0), "ERC721: mint to the zero address");
    require(!_exists(tokenId), "ERC721: token already minted");

    _beforeTokenTransfer(address(0), to, tokenId);
    _owners.push(to);

    emit Transfer(address(0), to, tokenId);
  }

  // Destroys `tokenId`.
  function _burn(uint256 tokenId) internal virtual {
    address owner = ERC721.ownerOf(tokenId);

    _beforeTokenTransfer(owner, address(0), tokenId);
    _approve(address(0), tokenId);
    _owners[tokenId-1] = address(0);

    emit Transfer(owner, address(0), tokenId);
  }

  // Transfers `tokenId` from `from` to `to`. (No restrictions on sender)
  function _transfer(address from, address to, uint256 tokenId) internal virtual {
    require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
    require(to != address(0), "ERC721: transfer to the zero address");

    _beforeTokenTransfer(from, to, tokenId);
    _approve(address(0), tokenId);
    _owners[tokenId-1] = to;

    emit Transfer(from, to, tokenId);
  }

  // Approve `to` to operate on `tokenId`
  function _approve(address to, uint256 tokenId) internal virtual {
    _tokenApprovals[tokenId] = to;
    emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
  }

  // Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
  function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool) {
    if (to.isContract()) {
      try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
        return retval == IERC721Receiver.onERC721Received.selector;
      } catch (bytes memory reason) {
        if (reason.length == 0) {
          revert("ERC721: transfer to non ERC721Receiver implementer");
        } else {
          assembly {
            revert(add(32, reason), mload(reason))
          }
        }
      }
    } else {
      return true;
    }
  }

 // Hook that is called before any token transfer.
 function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual {}
}

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)

pragma solidity ^0.8.0;

import "../utils/Context.sol";

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)

pragma solidity ^0.8.0;

/**
 * @dev These functions deal with verification of Merkle Trees proofs.
 *
 * The proofs can be generated using the JavaScript library
 * https://github.com/miguelmota/merkletreejs[merkletreejs].
 * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
 *
 * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
 */
library MerkleProof {
    /**
     * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
     * defined by `root`. For this, a `proof` must be provided, containing
     * sibling hashes on the branch from the leaf to the root of the tree. Each
     * pair of leaves and each pair of pre-images are assumed to be sorted.
     */
    function verify(
        bytes32[] memory proof,
        bytes32 root,
        bytes32 leaf
    ) internal pure returns (bool) {
        return processProof(proof, leaf) == root;
    }

    /**
     * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
     * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
     * hash matches the root of the tree. When processing the proof, the pairs
     * of leafs & pre-images are assumed to be sorted.
     *
     * _Available since v4.4._
     */
    function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
        bytes32 computedHash = leaf;
        for (uint256 i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];
            if (computedHash <= proofElement) {
                // Hash(current computed hash + current element of the proof)
                computedHash = _efficientHash(computedHash, proofElement);
            } else {
                // Hash(current element of the proof + current computed hash)
                computedHash = _efficientHash(proofElement, computedHash);
            }
        }
        return computedHash;
    }

    function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
        assembly {
            mstore(0x00, a)
            mstore(0x20, b)
            value := keccak256(0x00, 0x40)
        }
    }
}

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)

pragma solidity ^0.8.0;

import "./IERC165.sol";

/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
 * for the additional interface id that will be supported. For example:
 *
 * ```solidity
 * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
 *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
 * }
 * ```
 *
 * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
 */
abstract contract ERC165 is IERC165 {
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)

pragma solidity ^0.8.0;

import "../../utils/introspection/IERC165.sol";

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;
}

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)

pragma solidity ^0.8.0;

import "../IERC721.sol";

/**
 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
interface IERC721Metadata is IERC721 {
    /**
     * @dev Returns the token collection name.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the token collection symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     */
    function tokenURI(uint256 tokenId) external view returns (string memory);
}

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)

pragma solidity ^0.8.1;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)

pragma solidity ^0.8.0;

/**
 * @dev String operations.
 */
library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }
}

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)

pragma solidity ^0.8.0;

/**
 * @title ERC721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC721 asset contracts.
 */
interface IERC721Receiver {
    /**
     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
     */
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}