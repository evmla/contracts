//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/**
 * @author Alex Baker
 * @title EVM - Soulbound token (SBT)
 * https://vitalik.eth.limo/general/2022/01/26/soulbound.html
 */

interface IEVM {

    struct Metadata {
        address owner;
        string slug;
        string name;
        string description;
        string image;
        string link;
    }
    
    event Create(
        address indexed owner,
        string indexed slug,
        string indexed name,
        string description,
        string image,
        string link
    );

    event Update(
        address indexed owner,
        string indexed slug,
        string indexed name,
        string description,
        string image,
        string link
    );

    function create(
        string memory _slug,
        string memory _name,
        string memory _description,
        string memory _image,
        string memory _link
    ) external payable returns (bool);

    function update(
        string memory _name,
        string memory _description,
        string memory _image,
        string memory _link
    ) external returns (bool);
}

contract EVM is IEVM {
    address private immutable wallet;

    // PRICE = 16 - emoji bytes
    // 🇺🇦: 8 bytes | 😁: 4 bytes
    uint256 private constant PRICE = 16; // EVMOS

    uint256 id;
    mapping(uint256 => Metadata) public slugs;

    mapping(string => uint256) public slug;
    mapping(address => uint256) public owner;

    constructor() {
        wallet = payable(msg.sender);
    }

    function create(
        string memory _slug,
        string memory _name,
        string memory _description,
        string memory _image,
        string memory _link
    ) public payable override returns (bool) {
        require(slug[_slug] == 0, "Slug exists.");
        uint256 len = bytes(_slug).length;
        require(len > 0, "Not slug.");
        uint256 price = (PRICE - len) * 10**18;
        require(msg.value >= price, "Not EVMOS.");
        (bool sent,) = wallet.call{value: msg.value}("");
        require(sent, "Failed to send EVMOS.");
        id++;
        slugs[id] = Metadata(msg.sender, _slug, _name, _description, _image, _link);
        slug[_slug] = id;
        owner[msg.sender] = id;
        emit Create(msg.sender, _slug, _name, _description, _image, _link);
        return true;
    }

    function update(
        string memory _name,
        string memory _description,
        string memory _image,
        string memory _link
    ) public override returns (bool) {
        require(owner[msg.sender] != 0, "Not found.");
        Metadata storage m = slugs[owner[msg.sender]];
        m.name = _name;
        m.description = _description;
        m.image = _image;
        m.link = _link;
        emit Update(msg.sender, m.slug, _name, _description, _image, _link);
        return true;
    }

    function getMetadataBySlug(string memory _slug) public view returns(Metadata memory m) {
        m = slugs[slug[_slug]];
    }

    function getMetadataByAddress(address _owner) public view returns(Metadata memory m) {
        m = slugs[owner[_owner]];
    }

    function getMetadataById(uint256 _id) public view returns(Metadata memory m) {
        m = slugs[_id];
    }

    function getMetadataByIdDesc(uint256 _id) public view returns(Metadata memory m) {
        _id = id > 0 && _id > 0 && id >= _id ? id - _id + 1 : 0;
        m = slugs[_id];
    }
}
