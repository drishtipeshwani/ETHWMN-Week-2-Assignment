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
    address constant private receiver = 0x551803B870F980aD45c552bb14D3A265600f1BE0;
    mapping(address => uint256) balances;
    uint currentDay = 0;
    uint totalCalls = 0;
    string [] storedInfo;

    using SafeMath for uint256;

    constructor(){
        owner = msg.sender;
        balances[msg.sender] = msg.sender.balance;
    }

    modifier onlyOwner(){
        require(isOwner(),"Function accessible only by the owner !!");
        _;
    }

    function isOwner() public view returns(bool){
        return msg.sender == owner;
    }

    function transferRemainingBalance() private returns(bool) {
        // If the still_alive function is not called for last 10 blocks this function can execute
            require(totalCalls - currentDay >= 10,"Person is alive");
            uint256 remainingBalance = balances[msg.sender];
            balances[receiver] = balances[receiver].add(remainingBalance);
            balances[msg.sender] = 0;
            emit Transfer(msg.sender, receiver,remainingBalance);  //Calling the event
            return true;
    }
     // still_alive function can only be called by the owner
    function still_alive() onlyOwner public returns(uint){
        currentDay = currentDay + 1;
        totalCalls = totalCalls + 1;
        return currentDay;
    }

    function storeInfo(string memory _info) public {
        totalCalls = totalCalls + 1;
        storedInfo.push(_info);
    }

    function getInfo() public view returns(string[] memory){
       return storedInfo;
    }

    function getTotalCalls() public view returns(uint){
        return totalCalls;
    }

    function checkIfDead() public returns(bool) { 
        if(transferRemainingBalance()){
            return true;
        }else{
            return false;
        }   
    }
}