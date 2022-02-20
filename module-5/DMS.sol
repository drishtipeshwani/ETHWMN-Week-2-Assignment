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
    address constant public receiver = 0x78664B53Fd264a9b4Df93aFB733f8B66721266e7;
    address public beneficiary; //beneficiary address added by owner who can trigger the function to transfer the remaining balance once the deadline is over
    mapping(address=>uint256) balances;
    uint lastBlockNumber;
    
    using SafeMath for uint256;

    constructor(address _beneficiary){
        beneficiary = _beneficiary;
        owner = msg.sender;
        balances[owner] = msg.sender.balance;
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
    function transferRemainingBalance() onlyBeneficiary public returns(bool){
       //Transaction will take only if for last 10 blocks still_alive function is not called
            require(block.number - lastBlockNumber >= 10,"Owner is alive");
            balances[receiver]  = balances[receiver].add(balances[owner]);
            balances[owner] = 0;
            emit Transfer(msg.sender, receiver,balances[owner]);  //Calling the event
            return true;
    }

     // still_alive function can only be called by the owner
    function still_alive() onlyOwner public{
        require(block.number - lastBlockNumber < 10,"Owner is not alive");
        lastBlockNumber = block.number;
        balances[owner] = msg.sender.balance;
    }

    function getBlockNumber() public view returns(uint){
        return block.number;
    }

    function getOwnerBalance() public view returns(uint256){
        return balances[owner];
    }

}