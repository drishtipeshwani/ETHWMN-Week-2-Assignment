// SPDX-License-Identifier: GPL-3.0
        
pragma solidity >=0.4.22 <0.9.0;
import "remix_tests.sol";
import "../contracts/1_Storage.sol";

contract StorageTest{

    Storage storageToTest;

    function beforeAll() public {
        storageToTest = new Storage();
    }

    function initialValueis0() public returns (bool){
       return Assert.equal(storageToTest.retrieve(),0, "Initial value is not correct");
    }

    function correctValueisStored() public returns (bool){
        storageToTest.store(100);
        return Assert.equal(uint(storageToTest.retrieve()),100,"Correct value is not stored");
    }

}