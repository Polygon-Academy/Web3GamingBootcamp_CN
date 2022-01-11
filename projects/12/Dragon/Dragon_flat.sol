// SPDX-License-Identifier: MIT OR Apache-2.0
// File: @openzeppelin/contracts/utils/Strings.sol


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

// File: @openzeppelin/contracts/utils/Context.sol


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

// File: @openzeppelin/contracts/utils/Address.sol


// OpenZeppelin Contracts v4.4.1 (utils/Address.sol)

pragma solidity ^0.8.0;

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
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
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

// File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol


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

// File: @openzeppelin/contracts/utils/introspection/IERC165.sol


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

// File: @openzeppelin/contracts/utils/introspection/ERC165.sol


// OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)

pragma solidity ^0.8.0;


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

// File: @openzeppelin/contracts/token/ERC721/IERC721.sol


// OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)

pragma solidity ^0.8.0;


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

// File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol


// OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)

pragma solidity ^0.8.0;


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

// File: @openzeppelin/contracts/token/ERC721/ERC721.sol


// OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)

pragma solidity ^0.8.0;








/**
 * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
 * the Metadata extension, but not including the Enumerable extension, which is available separately as
 * {ERC721Enumerable}.
 */
contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
    using Address for address;
    using Strings for uint256;

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Mapping from token ID to owner address
    mapping(uint256 => address) private _owners;

    // Mapping owner address to token count
    mapping(address => uint256) private _balances;

    // Mapping from token ID to approved address
    mapping(uint256 => address) private _tokenApprovals;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC721-balanceOf}.
     */
    function balanceOf(address owner) public view virtual override returns (uint256) {
        require(owner != address(0), "ERC721: balance query for the zero address");
        return _balances[owner];
    }

    /**
     * @dev See {IERC721-ownerOf}.
     */
    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");
        return owner;
    }

    /**
     * @dev See {IERC721Metadata-name}.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev See {IERC721Metadata-symbol}.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overriden in child contracts.
     */
    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }

    /**
     * @dev See {IERC721-approve}.
     */
    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ERC721.ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(
            _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "ERC721: approve caller is not owner nor approved for all"
        );

        _approve(to, tokenId);
    }

    /**
     * @dev See {IERC721-getApproved}.
     */
    function getApproved(uint256 tokenId) public view virtual override returns (address) {
        require(_exists(tokenId), "ERC721: approved query for nonexistent token");

        return _tokenApprovals[tokenId];
    }

    /**
     * @dev See {IERC721-setApprovalForAll}.
     */
    function setApprovalForAll(address operator, bool approved) public virtual override {
        _setApprovalForAll(_msgSender(), operator, approved);
    }

    /**
     * @dev See {IERC721-isApprovedForAll}.
     */
    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    /**
     * @dev See {IERC721-transferFrom}.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");

        _transfer(from, to, tokenId);
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _safeTransfer(from, to, tokenId, _data);
    }

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * `_data` is additional data, it has no specified format and it is sent in call to `to`.
     *
     * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
     * implement alternative mechanisms to perform token transfer, such as signature-based.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeTransfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    /**
     * @dev Returns whether `tokenId` exists.
     *
     * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
     *
     * Tokens start existing when they are minted (`_mint`),
     * and stop existing when they are burned (`_burn`).
     */
    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }

    /**
     * @dev Returns whether `spender` is allowed to manage `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        address owner = ERC721.ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    /**
     * @dev Safely mints `tokenId` and transfers it to `to`.
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }

    /**
     * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
     * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
     */
    function _safeMint(
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _mint(to, tokenId);
        require(
            _checkOnERC721Received(address(0), to, tokenId, _data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }

    /**
     * @dev Mints `tokenId` and transfers it to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - `to` cannot be the zero address.
     *
     * Emits a {Transfer} event.
     */
    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId);

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }

    /**
     * @dev Destroys `tokenId`.
     * The approval is cleared when the token is burned.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     * Emits a {Transfer} event.
     */
    function _burn(uint256 tokenId) internal virtual {
        address owner = ERC721.ownerOf(tokenId);

        _beforeTokenTransfer(owner, address(0), tokenId);

        // Clear approvals
        _approve(address(0), tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);
    }

    /**
     * @dev Transfers `tokenId` from `from` to `to`.
     *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     *
     * Emits a {Transfer} event.
     */
    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {
        require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId);

        // Clear approvals from the previous owner
        _approve(address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    /**
     * @dev Approve `to` to operate on `tokenId`
     *
     * Emits a {Approval} event.
     */
    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
    }

    /**
     * @dev Approve `operator` to operate on all of `owner` tokens
     *
     * Emits a {ApprovalForAll} event.
     */
    function _setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) internal virtual {
        require(owner != operator, "ERC721: approve to caller");
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }

    /**
     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
     * The call is not executed if the target address is not a contract.
     *
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param tokenId uint256 ID of the token to be transferred
     * @param _data bytes optional data to send along with the call
     * @return bool whether the call correctly returned the expected magic value
     */
    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) private returns (bool) {
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

    /**
     * @dev Hook that is called before any token transfer. This includes minting
     * and burning.
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
     * transferred to `to`.
     * - When `from` is zero, `tokenId` will be minted for `to`.
     * - When `to` is zero, ``from``'s `tokenId` will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}
}

// File: @openzeppelin/contracts/utils/Counters.sol


// OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)

pragma solidity ^0.8.0;

/**
 * @title Counters
 * @author Matt Condon (@shrugs)
 * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
 * of elements in a mapping, issuing ERC721 ids, or counting request ids.
 *
 * Include with `using Counters for Counters.Counter;`
 */
library Counters {
    struct Counter {
        // This variable should never be directly accessed by users of the library: interactions must be restricted to
        // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
        // this feature: see https://github.com/ethereum/solidity/issues/4637
        uint256 _value; // default: 0
    }

    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    function increment(Counter storage counter) internal {
        unchecked {
            counter._value += 1;
        }
    }

    function decrement(Counter storage counter) internal {
        uint256 value = counter._value;
        require(value > 0, "Counter: decrement overflow");
        unchecked {
            counter._value = value - 1;
        }
    }

    function reset(Counter storage counter) internal {
        counter._value = 0;
    }
}

// File: contracts/DragonHatch.sol


pragma solidity ^0.8.3;



struct Dragon {
    string name;
    uint16 race;
    uint256 affinity;
    uint32 readyTime;
    uint16 winCount;
    uint16 lossCount;
    uint256 head;
    uint256 wing;
    uint256 claw;
    uint256 legs;
    uint256 tail;
    uint256 experience;
}

abstract contract DragonHatch is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter public _tokenIds;
    address contractAddress;
    event NewDragon(uint256 dragonId,  uint256 dna);


    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 seconds;
    string empty = '';
    string svgHead = '<path stroke="';

    Dragon[] public dragons;
    mapping (uint => address) public dragonToOwner;
    mapping (uint256 => address) private dragonApprovals;
    mapping (address => uint) ownerDragonCount;
    mapping (address => mapping (address => bool)) private _operatorApprovals;
    
    function _createDragon(string memory _name, uint _dna, address owner, uint16 _race) internal {
        uint256 newItemId = _tokenIds.current();
        uint16 race = _race;
        // string memory race = 'Dragon';
        uint256 affinity = _dna % 5;
        uint256 head = ((_dna % 10000) / 100 );
        uint256 wing = ((_dna % 1000000) / 10000 );
        uint256 claw = (_dna % 20);
        uint256 legs = ((_dna % 10000000000) / 100000000 );
        uint256 tail = ((_dna % 1000000000000) / 10000000000);
        uint256 experience = 0;

        dragons.push(Dragon(_name, race, affinity,uint32(block.timestamp + cooldownTime), 0, 0, 
            head ,wing, claw, legs, tail, experience)) ;
        dragonToOwner[newItemId] = owner;
        ownerDragonCount[owner]++;
        _safeMint(owner, newItemId);
        _tokenIds.increment();
        emit NewDragon(newItemId, _dna);
    }

    // function getAffinity(uint256 tokenId) public view returns (uint256) {
    //     Dragon storage myDragon = dragons[tokenId];
    //     uint[] memory affinity = new uint[](5);
    //     affinity[0] = myDragon.head % 5;
    //     affinity[1] = myDragon.wing % 5;
    //     affinity[2] = myDragon.claw % 5;
    //     affinity[3] = myDragon.legs % 5;
    //     affinity[4] = myDragon.tail % 5;

    //     uint same = 0;
    //     for (uint i = 0; i < affinity.length; i++){
    //         for(uint j = 1; j < affinity.length; j++){
    //             if(affinity[i] == affinity[j]){
    //                 same++;
    //             }
    //         }
    //     }

    //     return same;

    // }

    function getLevel(uint256 tokenId) public view returns (uint256) {
        return sqrt(dragons[tokenId].experience);
    }

    function getNumberOfDragons() public view returns (uint256) {
        return dragons.length; 
    }

    function getDragonStats(uint256 tokenId)
        public
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256
        )
    {
        return (
            dragons[tokenId].affinity,
            dragons[tokenId].head,
            dragons[tokenId].wing,
            dragons[tokenId].claw,
            dragons[tokenId].legs,
            dragons[tokenId].tail,
            dragons[tokenId].experience
        );
    }

    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    function sqrt(uint256 x) internal pure returns (uint256 y) {
        uint256 z = (x + 1) / 2;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }

    function compareStrings(string memory a, string memory b) public pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }

}
// File: contracts/DragonMutation.sol


pragma solidity ^0.8.3;


abstract contract DragonMutation is DragonHatch {
    // mapping (address => address) DragonMutationTarget;
    uint evolution = 100;

    modifier onlyOwnerOf(uint _dragonId) {
        require(msg.sender == dragonToOwner[_dragonId]);
        _;
    }

    function _triggerCooldown(Dragon storage _dragon) internal {
        _dragon.readyTime = uint32(block.timestamp + cooldownTime);
    }

    function _isReady(Dragon storage _dragon) internal view returns (bool) {
        return (_dragon.readyTime <= block.timestamp);
    }

    function _isDragon(Dragon storage _dragon) internal view returns (bool) {
        return _dragon.race == 0;
    }

    function _determineRace(Dragon storage _dragon) internal {
        
        if(_dragon.head >= evolution){ // Hydra
            _dragon.race = 1;
        }else if(_dragon.wing >= evolution){ // Amphithere
            _dragon.race = 2;
        }else if(_dragon.claw >= evolution){ // Kirin
            _dragon.race = 3;
        }else if(_dragon.legs >= evolution){ // Salamander
            _dragon.race = 4;
        }else if(_dragon.tail >= evolution){ // SeaSerpent
            _dragon.race = 5;
        }
    }
    
    function mutation(uint _dragonId, uint _targetId, uint targetParts) internal onlyOwnerOf(_dragonId) {
    // function mutation(uint _dragonId, uint _targetId, uint targetParts) public onlyOwnerOf(_dragonId) {
        
        Dragon storage myDragon = dragons[_dragonId];
        Dragon storage targetDragon = dragons[_targetId];
        require(_isDragon(myDragon), "You have grown up not a baby dragon.");
        // require(_isReady(myDragon));
        uint newPart = 0;
        if(targetParts == 0){
            newPart = targetDragon.head / 2 + myDragon.head;
            myDragon.head = newPart;
        }else if(targetParts == 1){
            newPart = targetDragon.wing / 2 + myDragon.wing;
            myDragon.wing = newPart;
        }else if(targetParts == 2){
            newPart = targetDragon.claw / 2 + myDragon.claw;
            myDragon.claw = newPart;
        }else if(targetParts == 3){
            newPart = targetDragon.legs / 2 + myDragon.legs;
            myDragon.legs = newPart;
        }else {
            newPart = targetDragon.tail / 2 + myDragon.tail;
            myDragon.tail = newPart;
        }
        
        _determineRace(myDragon);
        _triggerCooldown(myDragon);
    }

    function changeRace(uint _dragonId, uint16 _newRace) external onlyOwnerOf(_dragonId) {
        dragons[_dragonId].race = _newRace;
    }
}
// File: contracts/DragonBattle.sol


pragma solidity ^0.8.3;



library DragonAffinity {
    function generation(uint attackAffinity , uint defenseAffinity) 
        public 
        pure 
        returns (bool){
        if(attackAffinity == 0 && defenseAffinity == 2){ // 🏆生💧
            return true;
        }else if(attackAffinity == 2 && defenseAffinity == 1){ // 💧生🪵
            return true;
        }else if(attackAffinity == 1 && defenseAffinity == 3){ // 🪵生🔥
            return true;
        }else if(attackAffinity == 3 && defenseAffinity == 4){ // 🔥生🪨
            return true;
        }else if(attackAffinity == 4 && defenseAffinity == 0){ // 🪨生🏆
            return true;
        }else{
            return false;
        }
    }

    function restraint(uint attackAffinity , uint defenseAffinity) 
        public 
        pure 
        returns (bool){
        if(attackAffinity == 0 && defenseAffinity == 1){ // 🏆克🪵
            return true;
        }else if(attackAffinity == 1 && defenseAffinity == 4){ // 🪵克🪨
            return true;
        }else if(attackAffinity == 4 && defenseAffinity == 2){ // 🪨克💧
            return true;
        }else if(attackAffinity == 2 && defenseAffinity == 3){ // 💧克🔥
            return true;
        }else if(attackAffinity == 3 && defenseAffinity == 0){ // 🔥克🏆
            return true;
        }else{
            return false;
        }
    }
}

abstract contract DragonBattle is DragonMutation {
    using Counters for Counters.Counter;
    Counters.Counter private randNonce;
    event DragonBattleResult(uint my, uint target, bool firstAttack, uint winner , uint loser, uint[] damage);    

    function firstAttack(uint _dragonId, uint _targetId) public view returns(bool) {
        Dragon storage myDragon = dragons[_dragonId];
        Dragon storage targetDragon = dragons[_targetId];
        if(myDragon.race == 2){
            return true;
        }else if(targetDragon.race == 2){
            return false;
        }else if(myDragon.race == 0){
            return true;
        }else if(targetDragon.race == 0){
            return false;
        }else if(myDragon.race == 3){
            return true;
        }else if(targetDragon.race == 3){
            return false;
        }else if(myDragon.legs >= targetDragon.legs){
            return true;
        }else if(myDragon.legs < targetDragon.legs){
            return false;
        }else if(myDragon.experience <= targetDragon.experience ){
            return true;
        }else if(targetDragon.experience < myDragon.experience){
            return false;
        }else{
            return true;
        }
    }

    // function battleResult(){

    // }

    function lessZero(uint num, uint minus) public pure returns(uint) {
        if(num <= minus){
            return 0;
        }else{
            return (num - minus);
        }
    }

    function randMod(uint _modulus) internal view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce.current()))) % _modulus;
    }


    function damage(uint _dragonId, uint _targetId) public view returns (uint) {
        Dragon storage attack = dragons[_dragonId];
        Dragon storage defense = dragons[_targetId];

        bool res = DragonAffinity.restraint(attack.affinity, defense.affinity);
        bool gen = DragonAffinity.generation(attack.affinity, defense.affinity);

        uint attackValue = attack.head;
        uint defenseValue = defense.wing;
        if(res) {
            defenseValue = lessZero(defenseValue ,20);
        }else if(gen) {
            attackValue = attackValue + 20;
        }
        if(randMod(100) < attack.claw) {
            attackValue = attackValue * 2;
        }

        return lessZero(attackValue ,defenseValue);
    }

    function battleTest(uint _dragonId, uint _targetId) public view returns(uint[] memory) {
        bool first = firstAttack(_dragonId, _targetId);
        Dragon storage myDragon = dragons[_dragonId];
        Dragon storage targetDragon = dragons[_targetId];
        uint myHP = myDragon.tail;
        uint targetHP = targetDragon.tail;

        uint i = 0;
        uint256[] memory fight = new uint256[](10);
        while(myHP > 0 && targetHP > 0){
            uint damageNum = 0;
            if(first==true && i%2 == 0) { // 我方先攻，偶数回合
                damageNum = damage(_dragonId, _targetId);
                targetHP = lessZero(targetHP, damageNum);
            }else if(first==false && i%2 == 0) { // 敌方先攻，偶数回合
                damageNum = damage(_targetId, _dragonId);
                myHP = lessZero(myHP, damageNum);
            } else if(first==false && i%2 == 1) { // 敌方先攻，奇数回合
                damageNum = damage(_dragonId, _targetId);
                targetHP = lessZero(targetHP, damageNum);
            } else { // 我方先攻，奇数回合
                damageNum = damage(_targetId, _dragonId);
                myHP = lessZero(myHP, damageNum);
            }
            fight[i] = damageNum;
            i++;
        }

        return fight;
    }

    function battle(uint _dragonId, uint _targetId) public returns(uint[] memory) {
        bool first = firstAttack(_dragonId, _targetId);
        Dragon storage myDragon = dragons[_dragonId];
        Dragon storage targetDragon = dragons[_targetId];
        uint myHP = myDragon.tail;
        uint targetHP = targetDragon.tail;

        uint i = 0;
        uint256[] memory fight = new uint256[](10);
        while(myHP > 0 && targetHP > 0){
            uint damageNum = 0;
            if(first==true && i%2 == 0) { // 我方先攻，偶数回合
                damageNum = damage(_dragonId, _targetId);
                targetHP = lessZero(targetHP, damageNum);
            }else if(first==false && i%2 == 0) { // 敌方先攻，偶数回合
                damageNum = damage(_targetId, _dragonId);
                myHP = lessZero(myHP, damageNum);
            } else if(first==false && i%2 == 1) { // 敌方先攻，奇数回合
                damageNum = damage(_dragonId, _targetId);
                targetHP = lessZero(targetHP, damageNum);
            } else { // 我方先攻，奇数回合
                damageNum = damage(_targetId, _dragonId);
                myHP = lessZero(myHP, damageNum);
            }
            fight[i] = damageNum;
            i++;
        }
        
        if(targetHP <= 0) {
            myDragon.winCount++;
            myDragon.experience++;
            targetDragon.lossCount++;
            string memory timestamp = uint2str(block.timestamp);
            uint rand = uint(keccak256(abi.encodePacked(targetDragon.name, timestamp)));
            mutation(_dragonId, _targetId, rand);
            emit DragonBattleResult(_dragonId, _targetId, first , _dragonId, _targetId, fight);
        }else{
            myDragon.lossCount++;
            targetDragon.winCount++;
            emit DragonBattleResult(_dragonId, _targetId, first ,_targetId, _dragonId, fight);
        }

        return fight;
    }
}
// File: contracts/DragonOutward.sol


pragma solidity ^0.8.3;


library DragonStandard{
    string constant empty = '';
    string constant svgHead = '<path stroke="';

    function compareStrings(string memory a, string memory b) public pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }

    function getLightColor(uint256 target) internal pure returns (string memory) {
        string memory color = '';
        if (target%5 == 0){ // metal
            color = '#FFF8DC';
        }else if(target%5 == 1){ // plant
            color = '#A0CAA7';
        }else if(target%5 == 2){ // water
            color = '#8ED1E9';
        }else if(target%5 == 3){ // fire
            color = '#F08080';
        }else{ // earth
            color = '#FFE4C4';
        }
        return color;
    }

    function getColor(uint256 target) internal pure returns (string memory) {
        string memory color = '';
        if (target%5 == 0){ // metal
            color = '#FFD700';
        }else if(target%5 == 1){ // plant
            color = '#449652';
        }else if(target%5 == 2){ // water
            color = '#00A4DA';
        }else if(target%5 == 3){ // fire
            color = '#C30000';
        }else{ // earth
            color = '#D2691E';
        }
        return color;
    }

    function getDeepColor(uint256 target) internal pure returns (string memory) {
        string memory color = '';
        if (target%5 == 0){ // metal
            color = '#DAA520';
        }else if(target%5 == 1){ // plant
            color = '#4B796B';
        }else if(target%5 == 2){ // water
            color = '#008AC4';
        }else if(target%5 == 3){ // fire
            color = '#A52A2A';
        }else{ // earth
            color = '#A0522D';
        }
        return color;
    }

    function getHead(uint256 head) internal pure returns (string memory) {
        string[7] memory parts;
        string memory color = getColor(head);
        string memory deepColor = getDeepColor(head);
        parts[0] = svgHead;
        parts[1] = color;
        parts[2] = '" d="M17 0h1M18 1h2M19 2h3M20 3h3M19 4h5M18 5h4M23 5h2M18 6h8M17 7h9M17 8h4M17 9h4M18 10h4M18 11h6M19 12h6M19 13h7M19 14h7M19 15h8M21 16h6M21 17h6M21 18h6M21 19h6M21 20h6M21 21h5M21 22h5M21 23h5" />';
        parts[3] = svgHead;
        parts[4] = deepColor;
        parts[5] = '" d="M19 0h1M20 1h2M22 2h1" />';
        parts[6] = '<path stroke="#fffffe" d="M22 5h1" />';
        return string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6]));
    }

    function getWing(uint256 wing, uint16 race) internal pure returns (string memory) {
        string[9] memory parts;
        string memory lightColor = getLightColor(wing);
        string memory color = getColor(wing);
        string memory deepColor = getDeepColor(wing);
        if (race == 1) {
          parts[0] = svgHead; 
          parts[1] = deepColor;
          parts[2] = '" d="M14 3h1M12 4h2M11 5h1" />';
          parts[3] = svgHead;
          parts[4] = color;
          parts[5] = '" d="M16 3h1M14 4h2M12 5h3M11 6h3M10 7h5M9 8h2M12 8h4M8 9h8M8 10h9M13 11h4M13 12h4M13 13h4M13 14h8M13 15h8M13 16h8M13 17h8M13 18h8M15 19h6M15 20h6M15 21h6M15 22h6M15 23h6" />';
          parts[6] = svgHead;
          parts[7] = '#fffffe';
          parts[8] = '" d="M11 8h1" />';
        } else if(race == 5){
          parts[0] = svgHead;
          parts[1] = color;
          parts[2] = '" d="M6 4h1M12 4h1M7 5h1M12 5h1M8 6h1M13 6h1M9 7h1M13 7h1M9 8h1M14 8h1M3 9h1M10 9h1M14 9h1M4 10h2M11 10h1M15 10h1M6 11h1M12 11h1M15 11h1M7 12h2M13 12h1M15 12h1M9 13h1M14 13h1M16 13h1M10 14h2M14 14h1M16 14h5M12 15h1M15 15h1M17 15h4M13 16h2M16 16h5M15 17h6M15 18h6M15 19h6M15 20h6M15 21h6M15 22h6M15 23h6" />';
          parts[3] = svgHead;
          parts[4] = lightColor;
          parts[5] = '" d="M11 4h1M6 5h1M8 5h4M6 6h2M9 6h4M6 7h3M10 7h3M5 8h4M10 8h4M4 9h6M11 9h3M6 10h5M12 10h3M7 11h5M13 11h2M9 12h4M14 12h1M10 13h4M15 13h1M12 14h2M15 14h1M13 15h2M16 15h1M15 16h1" />';
          parts[6] = empty;
          parts[7] = empty;
          parts[8] = empty;
        }else if(race == 3){
          parts[0] = svgHead;
          parts[1] = color;
          parts[2] = '" d="M19 14h2M18 15h3M18 16h3M16 17h5M15 18h6M15 19h6M15 20h6M15 21h6M15 22h6M15 23h6" />';
          parts[3] = empty;
          parts[4] = empty;
          parts[5] = empty;
          parts[6] = empty;
          parts[7] = empty;
          parts[8] = empty;
        }else if(race == 4){
          parts[0] = svgHead;
          parts[1] = color;
          parts[2] = '" d="M19 14h2M18 15h3M18 16h3M16 17h5M15 18h6M15 19h6M15 20h6M15 21h6M15 22h6M15 23h6M15 24h4M14 25h4M14 26h3M14 27h2M14 28h2M15 29h2M16 30h2" />';
          parts[3] = svgHead;
          parts[4] = deepColor;
          parts[5] = '" d="M19 24h2M18 25h2M17 26h2M16 27h2M16 28h2M17 29h2M18 30h2" />';
          parts[6] = empty;
          parts[7] = empty;
          parts[8] = empty;
        }else
        {
          parts[0] = svgHead;
          parts[1] = deepColor;
          parts[2] = '" d="M2 2h7M8 3h2" />';
          parts[3] = svgHead;
          parts[4] = color;
          parts[5] = '" d="M1 3h7M7 4h5M11 5h2M12 6h1M12 7h2M5 8h6M13 8h1M10 9h5M12 10h3M14 11h1M8 12h5M14 12h2M12 13h5M13 14h8M17 15h4M18 16h3M16 17h5M15 18h6M15 19h6M15 20h6M15 21h6M15 22h6M15 23h6" />';
          parts[6] = svgHead;
          parts[7] = lightColor;
          parts[8] = '" d="M2 4h5M3 5h8M4 6h8M5 7h7M11 8h2M6 9h4M7 10h5M8 11h6M13 12h1M10 13h2M11 14h2M12 15h5M15 16h3" />';
        }
        return string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8]));
    }

    function getClaws(uint256 claw, uint16 race) internal pure returns (string memory) {
        string[9] memory parts;
        string memory color = getColor(claw);
        string memory deepColor = getDeepColor(claw);

        if (race == 1) {
          parts[0] = svgHead; 
          parts[1] = color;
          parts[2] = '" d="M18 24h5M24 24h2M18 25h5M25 25h4M18 26h5M25 26h5M19 27h9M29 27h2M20 28h12M21 29h11M22 30h4" />';
          parts[3] = svgHead;
          parts[4] = deepColor;
          parts[5] = '" d="M27 24h2" />';
          parts[6] = svgHead;
          parts[7] = '#fffffe';
          parts[8] = '" d="M28 27h1" />';
        }else if(race == 3) {
          parts[0] = svgHead;
          parts[1] = color;
          parts[2] = '" d="M21 24h2M21 25h2M21 26h2M21 27h2M21 28h2M21 29h3M21 30h4" />';
          parts[3] = svgHead;
          parts[4] = deepColor;
          parts[5] = '" d="M23 24h2M23 25h2M23 26h2M23 27h2M23 28h2M24 29h2M25 30h2" />';
          parts[6] = empty;
          parts[7] = empty;
          parts[8] = empty;
        }else{
          parts[0] = svgHead; 
          parts[1] = color;
          parts[2] = '" d="M21 24h2M21 25h2M21 26h2M21 27h2M21 28h4M21 29h1M23 29h1M25 29h1M21 30h1M24 30h1M26 30h1" />';
          parts[3] = svgHead;
          parts[4] = deepColor;
          parts[5] = '" d="M23 24h5M24 25h6M26 26h1M28 26h1M30 26h1M26 27h1M29 27h1M31 27h1" />';
          parts[6] = empty;
          parts[7] = empty;
          parts[8] = empty;
        }
        return string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8]));

    }

    function getLegs(uint256 legs, uint16 race) internal pure returns (string memory) {
        string[6] memory parts;
        string memory color = getColor(legs);
        string memory deepColor = getDeepColor(legs);

        if(race == 2) {
          parts[0] = svgHead;
          parts[1] = color;
          parts[2] = '" d="M12 19h3M9 20h6M9 21h6M8 22h7M9 23h6" />';
          parts[3] = empty;
          parts[4] = empty;
          parts[5] = empty;
        }else if(race == 5) {
          parts[0] = svgHead;
          parts[1] = color;
          parts[2] = '" d="M12 19h3M9 20h6M9 21h6M8 22h7M9 23h6" />';
          parts[3] = empty;
          parts[4] = empty;
          parts[5] = empty;
        }else {
          parts[0] = svgHead;
          parts[1] = color;
          parts[2] = '" d="M12 19h3M9 20h6M9 21h6M9 22h6M9 23h6M9 24h4M8 25h4M8 26h3M8 27h2M8 28h2M9 29h2M10 30h2" />';
          parts[3] = svgHead;
          parts[4] = deepColor;
          parts[5] = '" d="M13 24h2M12 25h2M11 26h2M10 27h2M10 28h2M11 29h2M12 30h2" />';
        }
        return string(abi.encodePacked( parts[0], parts[1], parts[2], parts[3], parts[4], parts[5]));
        
    }

    function getTail(uint256 tail) internal pure returns (string memory) {
        string[6] memory parts;
        string memory color = getColor(tail);
        string memory deepColor = getDeepColor(tail);
        parts[0] = svgHead;
        parts[1] = deepColor;
        parts[2] = '" d="M4 13h2M3 14h1M2 15h1M2 16h1M3 17h1M3 18h1M4 19h1" />';
        parts[3] = '<path stroke="';
        parts[4] = color;
        parts[5] = '" d="M4 14h1M3 15h1M3 16h2M4 17h1M4 18h2M5 19h4M5 20h4M7 21h2" />';
        return string(abi.encodePacked( parts[0], parts[1], parts[2], parts[3], parts[4], parts[5]));
    }
}

library Base64 {
    bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    /// @notice Encodes some bytes to the base64 representation
    function encode(bytes memory data) internal pure returns (string memory) {
        uint256 len = data.length;
        if (len == 0) return "";

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((len + 2) / 3);

        // Add some extra buffer at the end
        bytes memory result = new bytes(encodedLen + 32);

        bytes memory table = TABLE;

        assembly {
            let tablePtr := add(table, 1)
            let resultPtr := add(result, 32)

            for {
                let i := 0
            } lt(i, len) {

            } {
                i := add(i, 3)
                let input := and(mload(add(data, i)), 0xffffff)

                let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
                out := shl(224, out)

                mstore(resultPtr, out)

                resultPtr := add(resultPtr, 4)
            }

            switch mod(len, 3)
            case 1 {
                mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
            }
            case 2 {
                mstore(sub(resultPtr, 1), shl(248, 0x3d))
            }

            mstore(result, encodedLen)
        }

        return string(result);
    }
}

abstract contract DragonOutward is DragonBattle {
    function getSvg(uint tokenId) internal view returns (string memory) {
        string[5] memory parts;

        parts[0] = DragonStandard.getHead(dragons[tokenId].affinity);
        parts[1] = DragonStandard.getWing(dragons[tokenId].affinity, dragons[tokenId].race);
        parts[2] = DragonStandard.getClaws(dragons[tokenId].affinity, dragons[tokenId].race);
        parts[3] = DragonStandard.getLegs(dragons[tokenId].affinity, dragons[tokenId].race);
        parts[4] = DragonStandard.getTail(dragons[tokenId].affinity);
        string memory top = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 -0.5 32 32" shape-rendering="crispEdges">';
        string memory bottom = '</svg>';
        // return string(abi.encodePacked(top, parts[0], parts[1], parts[2], parts[3], parts[4], bottom));
        return Base64.encode(bytes(string(abi.encodePacked(top, parts[0], parts[1], parts[2], parts[3], parts[4], bottom))));
    }
}
// File: contracts/Dragon.sol


pragma solidity ^0.8.3;




contract FiveElementalDragon is ERC721, DragonOutward {
    mapping (uint => address) dragonApprovals;

    constructor(address marketplaceAddress ) ERC721("Five Elemental Dragon", "FED") {
        contractAddress = marketplaceAddress;
    }

    function balanceOf(address _owner) override public view returns (uint256 _balance) {
        return ownerDragonCount[_owner];
    }

    function ownerOf(uint256 _tokenId) override public view returns (address _owner) {
        return dragonToOwner[_tokenId];
    }

    function _transfer(address _from, address _to, uint256 _tokenId) override internal {
        ownerDragonCount[_to]++;
        ownerDragonCount[_from]--;
        dragonToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        _transfer(msg.sender, _to, _tokenId);
    }

    function approve(address _to, uint256 _tokenId) override public onlyOwnerOf(_tokenId) {
        dragonApprovals[_tokenId] = _to;
        emit Approval(msg.sender, _to, _tokenId);
    }

    function transferFrom(address from, address to, uint256 tokenID) override public {
        // require(dragonApprovals[tokenID] == msg.sender, "ERC721: transfer caller is not owner nor approved");
        // require(to == msg.sender);
        _transferFrom(from, to, tokenID);
    }

    function _generateRandomDna(string memory _str) internal view returns (uint) {
        string memory timestamp = uint2str(block.timestamp);
        uint rand = uint(keccak256(abi.encodePacked(_str, timestamp)));
        return rand % dnaModulus;
    }

    function createRandomDragon(string memory _name, uint16 _race) public {
        // require(ownerDragonCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        // randDna = randDna - randDna % 100;
        _createDragon(_name, randDna, msg.sender, _race);
    }

    function fetchMyNFTs(address _owner) public view returns (uint[] memory) {
        uint[] memory result = new uint[](ownerDragonCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < dragons.length; i++) {
            if (dragonToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

    function _clearApproval(uint256 dragonId) private {
        if (dragonApprovals[dragonId] != address(0)) {
            dragonApprovals[dragonId] = address(0);
        }
    }

    function _transferFrom(address from, address to, uint256 dragonId) internal {
        require(ownerOf(dragonId) == from, "ERC721: transfer of token that is not own");
        require(to != address(0), "ERC721: transfer to the zero address");
        _clearApproval(dragonId);
        ownerDragonCount[from]--;
        ownerDragonCount[to]++;

        dragonToOwner[dragonId] = to;

        emit Transfer(from, to, dragonId);
    }


    function tokenURI(uint256 tokenId) override public view returns (string memory) {
        string memory svgData = getSvg(tokenId);
        string memory output =  string(abi.encodePacked('data:image/svg+xml;base64,', svgData));
        return output;

        // string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "MY NFT", "description": "", "image_data": "', bytes(svgData), '"}'))));
        // return string(abi.encodePacked('data:application/json;base64,', json));
    }

    
}