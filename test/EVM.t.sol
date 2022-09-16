// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/EVM.sol";

contract EVMTest is Test {
    EVM public evm;

    address creator = vm.addr(1);
    address alice = vm.addr(2);

    function setUp() public {
        vm.deal(creator, 1000 ether);
        vm.deal(alice, 1000 ether);
        
        vm.startPrank(creator);
        evm = new EVM();
        vm.stopPrank();
    }

    function testCreate() public {
        vm.startPrank(alice);
        uint256 price = (16 - bytes("slug").length) * 10**18;
        evm.create{value: price}("slug","name","description","image","link");
        vm.stopPrank();
    }

    function testCreateFail() public {
        vm.startPrank(alice);
        vm.expectRevert(bytes("Not EVMOS."));
        evm.create{value: 0}("slug","name","description","image","link");
        vm.stopPrank();
    }

    function testUpdate() public {
        vm.startPrank(alice);
        uint256 price = (16 - bytes("slug").length) * 10**18;
        evm.create{value: price}("slug","name","description","image","link");
        (bool result) = evm.update("new name","description","image","link");
        assertEq(evm.getMetadataBySlug("slug").name, "new name");
        assertEq(result, true);
        vm.stopPrank();
    }
}
