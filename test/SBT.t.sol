// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/SBT.sol";

contract SBTTest is Test {
    SBT public sbt;

    uint256 p = 16;

    address creator = vm.addr(1);
    address alice = vm.addr(2);

    function setUp() public {
        vm.deal(creator, 1000 ether);
        vm.deal(alice, 1000 ether);
        
        vm.startPrank(creator);
        sbt = new SBT(unicode"Soulbound 👻 token", "SBT", p);
        vm.stopPrank();
    }

    function testMint() public {
        vm.startPrank(alice);
        uint256 price = (p - bytes(unicode"👻").length) * 10**18;
        sbt.mint{value: price}(unicode"👻","name","description","image","link");
        vm.stopPrank();
    }

    function testMintFail() public {
        vm.startPrank(alice);
        uint256 price = (p - bytes(unicode"👻").length) * 10**18;
        vm.expectRevert(abi.encodeWithSelector(InsufficientBalance.selector, unicode"👻", price, 0));
        sbt.mint{value: 0}(unicode"👻","name","description","image","link");
        vm.stopPrank();
    }

    function testUpdate() public {
        vm.startPrank(alice);
        uint256 price = (p - bytes(unicode"👻").length) * 10**18;
        sbt.mint{value: price}(unicode"👻","name","description","image","link");
        (bool result) = sbt.update("new name","description","image","link");
        assertEq(sbt.getMetadataBySoul(unicode"👻").name, "new name");
        assertEq(result, true);
        vm.stopPrank();
    }
}
