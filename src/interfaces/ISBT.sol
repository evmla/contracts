//SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

/**
 * @title Soulbound 👻 Token (SBT)
 * TIP: For a detailed writeup see
 * https://vitalik.eth.limo/general/2022/01/26/soulbound.html
 *
 * @author Alex Baker <alex.baker.fon@gmail.com>
 */

interface ISBT {

    struct Metadata {
        address owner;
        string soul;
        string name;
        string description;
        string image;
        string link;
    }
    
    /**
     * @dev Emitted when the minted new Soulbound 👻 Token
     */
    event Mint(
        address indexed owner,
        string indexed soul,
        string indexed name,
        string description,
        string image,
        string link
    );

    /**
     * @dev Emitted when the updated Soulbound 👻 Token
     */
    event Update(
        address indexed owner,
        string indexed soul,
        string indexed name,
        string description,
        string image,
        string link
    );

    /**
     * @dev Mint new Soulbound 👻 Token
     * @param soul_ Emoji Soulbound 👻 Token
     * @param name_ Name Soulbound 👻 Token
     * @param description_ Description Soulbound 👻 Token
     * @param image_ IPFS image Soulbound 👻 Token
     * @param link_ Link Soulbound 👻 Token
     * @return true unless throwing
     */
    function mint(
        string memory soul_,
        string memory name_,
        string memory description_,
        string memory image_,
        string memory link_
    ) external payable returns (bool);

    /**
     * @dev Update metadata Soulbound 👻 Token
     * @param name_ Name Soulbound 👻 Token
     * @param description_ Description Soulbound 👻 Token
     * @param image_ IPFS image Soulbound 👻 Token
     * @param link_ Link Soulbound 👻 Token
     * @return true unless throwing
     */
    function update(
        string memory name_,
        string memory description_,
        string memory image_,
        string memory link_
    ) external returns (bool);
}