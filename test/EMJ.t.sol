// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/EMJ.sol";

contract EMJTest is Test {
    EmojiWallet public emj;

    uint256 p = 16;

    address creator = vm.addr(1);
    address alice = vm.addr(2);

    function setUp() public {
        vm.deal(creator, 1000 ether);
        vm.deal(alice, 1000 ether);
        
        vm.startPrank(creator);
        emj = new EmojiWallet();
        vm.stopPrank();
    }

    function testMint() public {
        vm.startPrank(alice);
        uint256 price = (p - bytes(unicode"👻").length) * 10**10;
        emj.mint{value: price}(unicode"👻","name");
        vm.stopPrank();
    }

    function testMintFail() public {
        vm.startPrank(alice);
        vm.expectRevert(bytes("Error Amount"));
        emj.mint{value: 0}(unicode"👻","name");
        vm.stopPrank();
    }
}
