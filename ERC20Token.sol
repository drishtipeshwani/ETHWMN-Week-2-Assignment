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

contract ERC20Token {

    event Approval(address indexed tokenOwner, address indexed spender,uint tokens);
    event Transfer(address indexed from, address indexed to,uint tokens);

    string public name;  //name of token
    string public symbol; // sumbol of token
    uint8 public decimals;
    uint public _totalSupply;

    mapping(address => uint256) balances;  //Mapping individual address to their corresponding balances
    mapping(address => mapping (address => uint256)) allowed; //All the accounts allowed to withdraw from the given account along with allowed withdrawal sum 

    using SafeMath for uint256;

    constructor(uint total) {
        symbol = "PXL";
        name = "Pixel Coin";
        decimals = 18;
        _totalSupply = total;
        balances[msg.sender] = _totalSupply; //msg.sender containes the current account executing the contract
    }

    //Function to return the total supply
    function totalSupply() public view returns (uint256) {
             return _totalSupply;
    }

    // Function to return balance of tokenOwner
    function balanceOf(address tokenOwner) public view returns (uint) {
        return balances[tokenOwner];
    }

    //Function to transfer token from one account to another
    function transfer(address receiver, uint numTokens) public returns (bool) {
            require(numTokens <= balances[msg.sender]); //In order to make sure that sender has sufficient balance
            balances[msg.sender] = balances[msg.sender].sub(numTokens);
            balances[receiver] = balances[receiver].add(numTokens);
            emit Transfer(msg.sender, receiver, numTokens);  //Calling the event
            return true;
        }

    // Approve function
    function approve(address delegate,uint numTokens) public returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    // Function to return the number of allowed tokens
    function allowance(address owner, address delegate) public view returns (uint) {
            return allowed[owner][delegate];
        }

    //In a marketplace once the number of tokens are approved transfering tokens from owner to third party account
    function transferFrom(address owner, address buyer,uint numTokens) public returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);
        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][msg.sender] =   allowed[owner][msg.sender].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
        emit Transfer(owner, buyer, numTokens);
        return true;
        }

}

//Address of token on testnet - 0xf55Eaf3CE873A1036B1CE20aBeA75ba1956c991b