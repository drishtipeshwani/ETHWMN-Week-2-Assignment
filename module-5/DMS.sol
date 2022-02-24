// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract DMS{

    event Transfer(address indexed from, address indexed to,uint256 balance);

    address private owner;
    address constant public receiver = 0x78664B53Fd264a9b4Df93aFB733f8B66721266e7;
    address public beneficiary; //beneficiary address added by owner who can trigger the function to transfer the remaining balance once the deadline is over
    uint public ownerBalance;
    uint public lastBlockNumber;
    uint public balanceReceived;
    

    constructor(address _beneficiary) payable {
        beneficiary = _beneficiary;
        owner = msg.sender;
        ownerBalance = msg.sender.balance;
        lastBlockNumber = block.number;
        balanceReceived = msg.value;
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
    function transferRemainingBalance() onlyBeneficiary public returns(bool){
       //Transaction will take only if for last 10 blocks still_alive function is not called
            require(block.number - lastBlockNumber >= 10,"Owner is alive");
            payable(receiver).transfer(ownerBalance);
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
}

// Smart Contract Deployed at Address  - 0x70fFdeF52030DA5dDFd910b629228D914CD058b2
