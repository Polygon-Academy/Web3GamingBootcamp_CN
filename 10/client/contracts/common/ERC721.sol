// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)

pragma solidity ^0.8.0;


import "../interfaces/INFTCore.sol";
import "./Address.sol";
import "./Context.sol";
import "./Strings.sol";



contract ERC721 is Context, INFTCore {
    using Address for address;
    using Strings for uint256;

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Mapping : token ID => owner address
    mapping(uint256 => address) private _owners;

    // Mapping : owner address => token count
    mapping(address => uint256) private _balances;

    // Mapping : token ID => approved address
    mapping(uint256 => address) private _tokenApprovals;

    // Mapping : owner => (operator => result(agree or disagree))
    mapping(address => mapping(address => bool)) private _operatorApprovals;
    
    // Mapping : owner => (index in owned token list => token IDs)
    mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
    
    // Array : all token ids, used for enumeration
    uint256[] private _allTokens;

    //Initializes the contract by setting a `name` and a `symbol` to the token collection.
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    //see {INFTERC721-supportsInterface}.
    function supportsInterface(bytes4 interfaceId) external view virtual override returns (bool) {
        return  
                interfaceId == type(INFTCore).interfaceId;
    }

    //Returns the number of tokens in ``owner``'s account.
    function balanceOf(address owner) external view virtual override returns (uint256) {
        require(owner != address(0), "ERC721: balance query for the zero address");

        return _balances[owner];//Mapping
    }

    //Returns the owner of the `tokenId` token
    function ownerOf(uint256 tokenId) external view virtual override returns (address) {
        address owner = _owners[tokenId];//Mapping
        require(owner != address(0), "ERC721: owner query for nonexistent token");

        return owner;
    }

    //Returns string representing the token name
    function name() external view virtual override returns (string memory) {
        return _name;
    }

    //Returns string representing the token symbol
    function symbol() external view virtual override returns (string memory) {
        return _symbol;
    }

    //Returns the URI for a given token ID. May return an empty string.
    function tokenURI(uint256 tokenId) external view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for non-existent token");

        string memory baseURI = _baseURI();
        //return empty URL if it is.
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    //Gives permission to `to` to transfer `tokenId` token to another account
    function approve(address to, uint256 tokenId) external virtual override {
        address owner = this.ownerOf(tokenId);
        //'owner' can't be `to`
        require(to != owner, "ERC721: approval to current owner");
        
        //owner or sb with right of "approved for all" 
        require(
            _msgSender() == owner || this.isApprovedForAll(owner, _msgSender()),
            "ERC721: approve caller is not owner nor approved for all"
        );

        _approve(to, tokenId);
    }

    //Returns the account address, approved for `tokenId` token
    function getApproved(uint256 tokenId) external view virtual override returns (address) {
        require(_exists(tokenId), "ERC721: approved query for nonexistent token");

        return _tokenApprovals[tokenId];//Mapping
    }

    //Approve or remove `operator` as an operator for the caller.
    //Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller
    function setApprovalForAll(address operator, bool approved) external virtual override {
        _setApprovalForAll(_msgSender(), operator, approved);
    }

    //Returns true if the `operator` is allowed to manage all of the assets of `owner`.
    function isApprovedForAll(address owner, address operator) external view virtual override returns (bool) {
        return _operatorApprovals[owner][operator];//Mapping
    }

    //Transfers `tokenId` token from `from` to `to`
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external virtual override {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");

        _transfer(from, to, tokenId);
    }

    //Returns a token ID owned by `owner` at a given `index` of its token list.
    function tokenOfOwnerByIndex(address owner, uint256 index) external view virtual override returns (uint256) {
        require(index < this.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");

        return _ownedTokens[owner][index];//Mapping
    }

    //Returns the total amount of tokens stored by the contract.
    function totalSupply() external view virtual override returns (uint256) {
        return _allTokens.length;//Mapping
    }

    //Returns a token ID at a given `index` of all the tokens stored by the contract.
    function tokenByIndex(uint256 index) external view virtual override returns (uint256) {
        require(index < this.totalSupply(), "ERC721Enumerable: global index out of bounds");

        return _allTokens[index];//Mapping
    }
    
    //Burns `tokenId`.
    function burn(uint256 tokenId) external virtual override {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");

        _burn(tokenId);
    }

    //mint tokens.
    function mint(address to, uint256 tokenId) external override returns (bool) {
        _mint(to, tokenId);

        return true;
    }


    /**************************          BASIC  FUNCTION  FROM  ERC721       ******************************/

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overriden in child contracts.
     */
    function _baseURI() internal view virtual returns (string memory) {
        return "";
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

        address owner = this.ownerOf(tokenId);
        return (spender == owner || this.getApproved(tokenId) == spender || this.isApprovedForAll(owner, spender));
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
        address owner = this.ownerOf(tokenId);

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
        require(this.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
        require(to != address(0), "ERC721: transfer to the zero address");

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

        emit Approval(this.ownerOf(tokenId), to, tokenId);
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

}
