// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

library SafeMath { // Only relevant functions
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        uint256 c = a-b;
        return c;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

contract DMS{

    event Transfer(address indexed from, address indexed to,uint256 balance);

    address private owner;
    address payable public receiver;
    address private beneficiary; //beneficiary address added by owner who can trigger the function to transfer the remaining balance once the deadline is over
    uint256 ownerBalance;
    uint lastBlockNumber;
    
    using SafeMath for uint256;

    constructor(address _beneficiary,address payable _receiver){
        beneficiary = _beneficiary;
        receiver = _receiver;
        owner = msg.sender;
        ownerBalance = msg.sender.balance;
        lastBlockNumber = block.number;
    }

    modifier onlyOwner(){
       require(msg.sender == owner,"Function is accessible only by the owner");
       _;
    }

    modifier onlyBeneficiary(){
        require(msg.sender== beneficiary,"Function accessible only by beneficiary added !!");
        _;
    }

     // function to transfer the remaining balance
    function transferRemainingBalance() onlyBeneficiary external returns(bool){
       //Transaction will take only if for last 10 blocks still_alive function is not called
            require(block.number - lastBlockNumber >= 10,"Owner is alive");
            receiver.transfer(ownerBalance);
            emit Transfer(msg.sender, receiver,ownerBalance);  //Calling the event
            return true;
    }

     // still_alive function can only be called by the owner
    function still_alive() onlyOwner public{
        require(block.number - lastBlockNumber < 10,"Owner is not alive");
        lastBlockNumber = block.number;
        ownerBalance = msg.sender.balance;
    }

    function getBlockNumber() public view returns(uint){
        return block.number;
    }

    function getOwnerBalance() public view returns(uint256){
        return ownerBalance;
    }

}