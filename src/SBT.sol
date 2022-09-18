//SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@soulbound/contracts/interfaces/ISBT.sol";

error SoulExists(string soul, address owner);
error SoulNotExists(address owner);
error SoulNotFound();
error FailedMint(string soul);
error InsufficientBalance(string soul, uint256 need, uint256 current);

/**
 * @title Soulbound 👻 Token (SBT)
 * TIP: For a detailed writeup see
 * https://vitalik.eth.limo/general/2022/01/26/soulbound.html
 *
 * @author Alex Baker <alex.baker.fon@gmail.com>
 */

contract SBT is ISBT {
    address private _wallet;

    uint256 _id;
    mapping(uint256 => Metadata) public _souls;

    mapping(string => uint256) public _soul;
    mapping(address => uint256) public _owner;

    string private _name;
    string private _symbol;
    uint256 private _price;

    /**
     * @dev Sets the values for {name}, {symbol} and {price}.
     *
     * price - soul bytes = amount
     * 🇺🇦: 8 soul bytes | 😁: 4 soul bytes
     * when specifying a zero value, tokens can be minted for free.
     *
     * All three of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name_, string memory symbol_, uint256 price_) {
        _name = name_;
        _symbol = symbol_;
        _price = price_;
        _wallet = payable(msg.sender);
    }

    /**
     * @dev Returns the name of the Soulbound 👻 Token.
     */
    function name() public view virtual returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the Soulbound 👻 Token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the price of the Soulbound 👻 Token.
     */
    function price(string memory soul_) public view virtual returns (uint256) {
        return (_price - bytes(soul_).length) * 10**18;
    }

    /**
     * @dev See {ISBT-mint}.
     */
    function mint(
        string memory soul_,
        string memory name_,
        string memory description_,
        string memory image_,
        string memory link_
    ) public payable override returns (bool) {
        uint256 _len = bytes(soul_).length;
        uint256 _amount = (_price - _len) * 10**18;

        if (_len <= 0) {
            revert SoulNotFound();
        }

        if (_soul[soul_] > 0) {
            revert SoulExists(
                soul_,
                _souls[_soul[soul_]].owner
            );
        }

        if (_price > 0 && msg.value < _amount) {
            revert InsufficientBalance(
                soul_, 
                _amount, 
                msg.value
            );
        }

        _id++;
        _souls[_id] = Metadata(msg.sender, soul_, name_, description_, image_, link_);
        _soul[soul_] = _id;
        _owner[msg.sender] = _id;

        emit Mint(msg.sender, soul_, name_, description_, image_, link_);

        (bool sent,) = _wallet.call{value: _amount}("");
        if (!sent) {
            revert FailedMint(
                soul_
            );
        }

        return true;
    }

     /**
     * @dev See {ISBT-update}.
     */
    function update(
        string memory name_,
        string memory description_,
        string memory image_,
        string memory link_
    ) public override returns (bool) {
        if (_owner[msg.sender] <= 0) {
            revert SoulNotExists(msg.sender);
        }

        Metadata storage m = _souls[_owner[msg.sender]];
        m.name = name_;
        m.description = description_;
        m.image = image_;
        m.link = link_;

        emit Update(msg.sender, m.soul, name_, description_, image_, link_);
        
        return true;
    }

    /**
     * @dev Returns the metadata of the Soulbound 👻 Token by soul.
     */
    function getMetadataBySoul(string memory soul_) public view returns(Metadata memory m) {
        m = _souls[_soul[soul_]];
    }

    /**
     * @dev Returns the metadata of the Soulbound 👻 Token by owner.
     */
    function getMetadataByOwner(address owner_) public view returns(Metadata memory m) {
        m = _souls[_owner[owner_]];
    }

    /**
     * @dev Returns the metadata of the Soulbound 👻 Token by ID.
     */
    function getMetadataById(uint256 id_) public view returns(Metadata memory m) {
        m = _souls[id_];
    }

    /**
     * @dev Returns the metadata of the Soulbound 👻 Token by ID desc.
     */
    function getMetadataByIdDesc(uint256 id_) public view returns(Metadata memory m) {
        id_ = _id > 0 && id_ > 0 && _id >= id_ ? _id - id_ + 1 : 0;
        m = _souls[id_];
    }
}
