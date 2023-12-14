// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "./utils/TimeUtil.sol";

interface TheRabbitNFT {
    function ownerOf(uint256 tokenId) external view returns (address);
    function getWinnerTokenIds(uint luckyNum) external view returns (uint[] memory tokenIds);
}


/**
    code    |	 meaning
    104	    |    Time is illegal
 */
contract RewardPool is Ownable {
    using ECDSA for bytes32;

    uint public lastBalance;
    uint public rewardPoolBalance;
    uint private lastSalt;
    bool public isOpen;
    uint public minBalance = 0.5 ether;
    uint public minValidPrice;

    address private rewardSigner;
    TheRabbitNFT private rabbitContractAddress;
    mapping(uint => mapping(uint => bool)) public rewardRecord; // key1:theDay  key2:tokenId

    constructor (address contractAddress, address _rewardSigner) {
        require(_rewardSigner != address(0), "400");
        rewardSigner = _rewardSigner;
        rabbitContractAddress = TheRabbitNFT(contractAddress);
        lastSalt = uint256(keccak256(abi.encodePacked(msg.sender, contractAddress, address(this), _rewardSigner)));
    }

    // thank you
    function supplementRewardPool() external payable {
        uint theLastBalance = address(this).balance - msg.value;
        uint royalty = theLastBalance - lastBalance;
        rewardPoolBalance += msg.value;
        if (royalty > 0) {
            rewardPoolBalance += (royalty / 3);
        }
        lastBalance = address(this).balance;
    }

    // Set the signer
    function setRewardSigner(address newSigner) external onlyOwner {
        require(newSigner != address(0), "400");
        rewardSigner = newSigner;
    }
    // Set status
    function setOpenStatus(bool _isOpen) external onlyOwner {
        isOpen = _isOpen;
    }
    // The min value with open, wei
    function setMinBalance(uint _minBalance) external onlyOwner {
        minBalance = _minBalance;
    }
    // The min valid price with transfer, wei
    function setMinValidPrice(uint _minValidPrice) external onlyOwner {
        minValidPrice = _minValidPrice;
    }

    // List of awards received
    function getAlreadyRewardTokenIds(uint luckyItem) view external returns (uint[] memory tokenIds) {
        uint[] memory allTokenIds = rabbitContractAddress.getWinnerTokenIds(luckyItem);
        if (allTokenIds.length == 0) return tokenIds;
        uint theDay = getDaysFrom1970();
        uint count = 0;
        tokenIds = new uint[](allTokenIds.length);
        for (uint index = 0; index < allTokenIds.length; index++) {
            if (rewardRecord[theDay][allTokenIds[index]]) tokenIds[count++] = allTokenIds[index];
        }
        if (count == allTokenIds.length) return tokenIds;
        uint[] memory realTokenIds = new uint[](count);
        for (uint j = 0; j < count; j++) {
            realTokenIds[j] = tokenIds[j];
        }
        return realTokenIds;
    }

    // Pool balance, wei
    function getRewardPoolBalance() public view returns (uint count){
        count = rewardPoolBalance;
        if (address(this).balance > lastBalance) {
            uint royalty = address(this).balance - lastBalance;
            count += (royalty / 3);
        }
    }

    event RewardSucceed(address indexed to, uint amount);
    // Do reward
    function reward(
        bytes memory salt, bytes memory token, uint[] calldata tokenIds,
        uint validDay, uint unitPrice
        ) external {
        require(_recover(_hash(salt, tokenIds, validDay, unitPrice), token) == rewardSigner, "400");
        uint theDay = getDaysFrom1970();
        require(theDay == validDay, "104");

        uint count = 0;
        for (uint i = 0; i < tokenIds.length; i++) {
            if (!rewardRecord[theDay][tokenIds[i]] && rabbitContractAddress.ownerOf(tokenIds[i]) == msg.sender) {
                count++;
                rewardRecord[theDay][tokenIds[i]] = true;
            }
        }
        if (count == 0) return;

        if (rewardPoolBalance > address(this).balance) {
            rewardPoolBalance = address(this).balance;
            lastBalance = address(this).balance;
        }

        if (address(this).balance > lastBalance) {
            // handle the royalty
            uint royalty = address(this).balance - lastBalance;
            rewardPoolBalance += (royalty / 3);
            lastBalance = address(this).balance;
        }

        uint paymentAmount = count * unitPrice * 10**9;
        lastBalance = address(this).balance - paymentAmount;
        rewardPoolBalance -= paymentAmount;
        payable(msg.sender).transfer(paymentAmount);
        emit RewardSucceed(msg.sender, paymentAmount);
    }

    // The lucky num today
    // 0:not open
    // >=2:the num
    function getLuckyItem() view external returns (uint luckyItem, uint poolBalance) {
        if (!isOpen) {
            return (0, getRewardPoolBalance() / 10 ** 9);
        }
        poolBalance = getRewardPoolBalance() / 10 ** 9;
        uint theDay = getDaysFrom1970();
        // !hOphOp! Happy Eureka Day! 
        if (theDay % 7 != 6) return (0, poolBalance);
        uint royalty = address(this).balance - lastBalance;

        bool _isOpen = false;
        if (royalty > 0) {
            if (rewardPoolBalance + (royalty / 3) >= minBalance) {
                _isOpen = true;
            }
        } else {
            if (rewardPoolBalance >= minBalance) {
                _isOpen = true;
            }
        }

        if (_isOpen) {
            return ((uint256(keccak256(abi.encodePacked(theDay, lastSalt))) % 78) + 2, poolBalance);
        }
        return (0, poolBalance);
    }

    event Received(address, uint);
    receive() external payable {
        // 1.the royalty
        // 2.player do this and thank you very match
        emit Received(msg.sender, msg.value);
    }
    // Only draw money from outside the pool
    function withdrawFunds() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance - rewardPoolBalance);
        rewardPoolBalance = lastBalance = address(this).balance;
    }
    function getMinPriceInfo() external view returns(uint _minBalance, uint _minValidPrice) {
        return (minBalance / 10 ** 9, minValidPrice / 10 ** 9);
    }

    // tools
    function _hash(bytes memory salt, uint[] calldata tokenIds, uint validDay, uint unitPrice)
    private view returns (bytes32) {
        return keccak256(abi.encodePacked(salt, address(this), tokenIds, validDay, unitPrice));
    }
    function _recover(bytes32 hash, bytes memory token) private pure returns (address) {
        return hash.toEthSignedMessageHash().recover(token);
    }

    function getDaysFrom1970() public view returns (uint _days) {
        _days = TimeUtil.currentTime() / 86400;
    }

}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library TimeUtil {
    function currentTime() internal view returns (uint) {
        unchecked {
            return block.timestamp;
        }
    }
}

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)

pragma solidity ^0.8.0;

import "../Strings.sol";

/**
 * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
 *
 * These functions can be used to verify that a message was signed by the holder
 * of the private keys of a given address.
 */
library ECDSA {
    enum RecoverError {
        NoError,
        InvalidSignature,
        InvalidSignatureLength,
        InvalidSignatureS,
        InvalidSignatureV
    }

    function _throwError(RecoverError error) private pure {
        if (error == RecoverError.NoError) {
            return; // no error: do nothing
        } else if (error == RecoverError.InvalidSignature) {
            revert("ECDSA: invalid signature");
        } else if (error == RecoverError.InvalidSignatureLength) {
            revert("ECDSA: invalid signature length");
        } else if (error == RecoverError.InvalidSignatureS) {
            revert("ECDSA: invalid signature 's' value");
        } else if (error == RecoverError.InvalidSignatureV) {
            revert("ECDSA: invalid signature 'v' value");
        }
    }

    /**
     * @dev Returns the address that signed a hashed message (`hash`) with
     * `signature` or error string. This address can then be used for verification purposes.
     *
     * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
     * this function rejects them by requiring the `s` value to be in the lower
     * half order, and the `v` value to be either 27 or 28.
     *
     * IMPORTANT: `hash` _must_ be the result of a hash operation for the
     * verification to be secure: it is possible to craft signatures that
     * recover to arbitrary addresses for non-hashed data. A safe way to ensure
     * this is by receiving a hash of the original message (which may otherwise
     * be too long), and then calling {toEthSignedMessageHash} on it.
     *
     * Documentation for signature generation:
     * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
     * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
     *
     * _Available since v4.3._
     */
    function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
        // Check the signature length
        // - case 65: r,s,v signature (standard)
        // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
        if (signature.length == 65) {
            bytes32 r;
            bytes32 s;
            uint8 v;
            // ecrecover takes the signature parameters, and the only way to get them
            // currently is to use assembly.
            assembly {
                r := mload(add(signature, 0x20))
                s := mload(add(signature, 0x40))
                v := byte(0, mload(add(signature, 0x60)))
            }
            return tryRecover(hash, v, r, s);
        } else if (signature.length == 64) {
            bytes32 r;
            bytes32 vs;
            // ecrecover takes the signature parameters, and the only way to get them
            // currently is to use assembly.
            assembly {
                r := mload(add(signature, 0x20))
                vs := mload(add(signature, 0x40))
            }
            return tryRecover(hash, r, vs);
        } else {
            return (address(0), RecoverError.InvalidSignatureLength);
        }
    }

    /**
     * @dev Returns the address that signed a hashed message (`hash`) with
     * `signature`. This address can then be used for verification purposes.
     *
     * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
     * this function rejects them by requiring the `s` value to be in the lower
     * half order, and the `v` value to be either 27 or 28.
     *
     * IMPORTANT: `hash` _must_ be the result of a hash operation for the
     * verification to be secure: it is possible to craft signatures that
     * recover to arbitrary addresses for non-hashed data. A safe way to ensure
     * this is by receiving a hash of the original message (which may otherwise
     * be too long), and then calling {toEthSignedMessageHash} on it.
     */
    function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
        (address recovered, RecoverError error) = tryRecover(hash, signature);
        _throwError(error);
        return recovered;
    }

    /**
     * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
     *
     * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
     *
     * _Available since v4.3._
     */
    function tryRecover(
        bytes32 hash,
        bytes32 r,
        bytes32 vs
    ) internal pure returns (address, RecoverError) {
        bytes32 s;
        uint8 v;
        assembly {
            s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
            v := add(shr(255, vs), 27)
        }
        return tryRecover(hash, v, r, s);
    }

    /**
     * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
     *
     * _Available since v4.2._
     */
    function recover(
        bytes32 hash,
        bytes32 r,
        bytes32 vs
    ) internal pure returns (address) {
        (address recovered, RecoverError error) = tryRecover(hash, r, vs);
        _throwError(error);
        return recovered;
    }

    /**
     * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
     * `r` and `s` signature fields separately.
     *
     * _Available since v4.3._
     */
    function tryRecover(
        bytes32 hash,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal pure returns (address, RecoverError) {
        // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
        // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
        // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
        // signatures from current libraries generate a unique signature with an s-value in the lower half order.
        //
        // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
        // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
        // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
        // these malleable signatures as well.
        if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
            return (address(0), RecoverError.InvalidSignatureS);
        }
        if (v != 27 && v != 28) {
            return (address(0), RecoverError.InvalidSignatureV);
        }

        // If the signature is valid (and not malleable), return the signer address
        address signer = ecrecover(hash, v, r, s);
        if (signer == address(0)) {
            return (address(0), RecoverError.InvalidSignature);
        }

        return (signer, RecoverError.NoError);
    }

    /**
     * @dev Overload of {ECDSA-recover} that receives the `v`,
     * `r` and `s` signature fields separately.
     */
    function recover(
        bytes32 hash,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal pure returns (address) {
        (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
        _throwError(error);
        return recovered;
    }

    /**
     * @dev Returns an Ethereum Signed Message, created from a `hash`. This
     * produces hash corresponding to the one signed with the
     * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
     * JSON-RPC method as part of EIP-191.
     *
     * See {recover}.
     */
    function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
        // 32 is the length in bytes of hash,
        // enforced by the type signature above
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }

    /**
     * @dev Returns an Ethereum Signed Message, created from `s`. This
     * produces hash corresponding to the one signed with the
     * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
     * JSON-RPC method as part of EIP-191.
     *
     * See {recover}.
     */
    function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
    }

    /**
     * @dev Returns an Ethereum Signed Typed Data, created from a
     * `domainSeparator` and a `structHash`. This produces hash corresponding
     * to the one signed with the
     * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
     * JSON-RPC method as part of EIP-712.
     *
     * See {recover}.
     */
    function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
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