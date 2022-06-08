// SPDX-License-Identifier: GPL-3.0
pragma solidity >0.7.0 <0.9.0;

import "./03-token.sol";

contract Airdrop {

    // Using Libs

    // Struct

    // Enums
    enum Status { ACTIVE, PAUSED, CANCELLED } //ACTIVE=0, PAUSED=1, CANCELLED=2 -- uint8

    // Properties
    address private owner;
    address public tokenAddress;
    Status contractState;
    address[] private subscribers;


    // Modifiers
    modifier isOwner(){
        require(msg.sender == owner, "Sender is not owner");
        _;
    }
    // Events

    // Constructor
    constructor(address token) {
        owner = msg.sender;
        tokenAddress = token;
        contractState = Status.ACTIVE;
    }

    // Public Functions
    function subscribe() public returns(bool) {
   
        require(hasSubscribed(msg.sender) == false, "Wallet already subscribed!");
        subscribers.push(msg.sender);
        return true;

    }

    function getSubscribe(uint256 index) public view returns(address){
        return subscribers[index];
    }


    function execute() public returns(bool){
        
        uint balance = CryptoToken(tokenAddress).balanceOf(address(this));
        require(balance >= 0, "Insufficient balance to start");

        uint256 amountToTransfer = balance / subscribers.length;
        for(uint256 i = 0; i< subscribers.length; i++){
            require(subscribers[i] != address(0));
            require(CryptoToken(tokenAddress).transfer(subscribers[i],amountToTransfer));
        }
        
        return true;
    }

    function state() public view returns(Status){
        return contractState;
    }


    // Private Functions
    function hasSubscribed(address subscriber) private view returns(bool) {

        for(uint i = 0; i<subscribers.length; i++){
            if(subscriber == subscribers[i]){
                return true;
            }
        }
        return false;
    }

    //Kill
    function kill() public isOwner {
        //TODO: needs implementation
    }

}