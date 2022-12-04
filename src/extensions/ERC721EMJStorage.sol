// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

abstract contract ERC721EMJStorage is ERC721 {
    using Strings for uint256;

    struct Emoji {
        address owner;
        string emoji;
        string name;
    }

    mapping(uint256 => Emoji) private _emj;

    mapping(string => uint256) private _emojis;
    mapping(address => uint256) private _owners;

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireMinted(tokenId);

        string memory emj = _emj[tokenId].emoji;
        string memory base = _baseURI();

        if (bytes(base).length == 0) {
            bytes memory dataURI = abi.encodePacked(
                '{',
                    '"name": "Emoji Wallet: ', emj, '",',
                    '"description": "Emoji Wallet Link: https://evm.la/#/', emj, '",',
                    '"attributes": "[{"',
                        '"trait_type": "Emoji",',
                        '"value": "', emj, '"',
                    '}]",',
                    '"image": "', _emojiToImageURI(emj), '"'
                '}'
            );

            return string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
        }
        
        if (bytes(emj).length > 0) {
            return string(abi.encodePacked(base, emj));
        }

        return super.tokenURI(tokenId);
    }

    function tokenByEmoji(string memory emoji_) public view returns(Emoji memory e) {
        e = _emj[_emojis[emoji_]];
    }

    function tokenByOwner(address owner_) public view returns(Emoji memory e) {
        e = _emj[_owners[owner_]];
    }

    function _emojiToImageURI(string memory _emoji) internal pure returns (string memory) {
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(
            '<svg width="400" height="400" xmlns="http://www.w3.org/2000/svg"><text style="font-size: 100px;" text-anchor="middle" x="0" y="0" dy="1em" dx="1em">',
            _emoji,
            '</text></svg>'
        ))));
        return string(abi.encodePacked(baseURL, svgBase64Encoded));
    }

    function _setTokenEMJ(uint256 tokenId, string memory _emoji, string memory _name) internal virtual {
        require(_exists(tokenId), "ERC721EMJStorage: EMJ set of nonexistent token");
        require(_emojis[_emoji] == 0, "ERC721EMJStorage: EMJ token exists");
        _emj[tokenId] = Emoji(msg.sender, _emoji, _name);
        _emojis[_emoji] = tokenId;
        _owners[msg.sender] = tokenId;
    }

    function _burn(uint256 tokenId) internal virtual override {
        super._burn(tokenId);

        if (bytes(_emj[tokenId].emoji).length != 0) {
            delete _emj[tokenId];
        }
    }
}
