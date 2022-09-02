// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Nft{
    string name;
    string description;
    uint64 amount;
    uint dateCreated;
    address owner;

    constructor(){
        owner = msg.sender;
    }

    function AddNft(string memory ntfName, uint64 price, string memory nftDescription) public returns(bool success){

    }
}