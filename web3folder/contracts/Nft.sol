// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
//hello world
contract Nft{
    
    address owner;

    constructor(){
        owner = msg.sender;
    }
    enum State{
        Purchased,
        Activated,
        Deactivated
    }

    struct NftDetails{
        bytes16 id;
        uint price;
        bytes32 proof;
        address owner;
        bytes32 description;
        uint dateCreated;
        State state;
        bytes32 name;
    }

    mapping(bytes16 => bytes32) OwnerNfthash;
    mapping(bytes32 => NftDetails) ownerNft;

    NftDetails[] AllNfts;

    /// You own this Nft already
    error NftHasOwner();

    function PurchaseNft(
        bytes16 nftId, //0x00000000000000000000000000003130
        bytes32 proof, //0x0000000000000000000000000000313000000000000000000000000000003130
        bytes32 description,
        bytes32 name
    )
    public payable{
        bytes32 nftHash = keccak256((abi.encodePacked(nftId,msg.sender)));

        if(hasNftOwnership(nftHash)){
            revert NftHasOwner();
        }

        bytes32 previosHash =  OwnerNfthash[nftId]; //previous owner = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
                                                    // previous hash = 0xc4eaa3558504e2baa2669001b43f359b8418b44a4477ff417b4b007d7cc86e37
                                                    // new hash = 0xff97578d8dd58d484dac933924a0f06f3ff39cc2843610754dfebd8770f807e5
                                                    // new owner = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
        if(previosHash == ""){
            OwnerNfthash[nftId] = nftHash;
            ownerNft[nftHash] = NftDetails({
                id: nftId,
                price : msg.value,
                proof: proof,
                owner: msg.sender,
                state: State.Purchased,
                description: description,
                dateCreated: block.timestamp,
                name: name
            });
        }else{
            NftDetails memory previousNft = ownerNft[previosHash];       
          
          OwnerNfthash[nftId] = nftHash;

            ownerNft[nftHash] = NftDetails({
                id: previousNft.id,
                price : previousNft.price,
                proof: previousNft.proof,
                owner: msg.sender,
                state: previousNft.state,
                description: previousNft.description,
                dateCreated: previousNft.dateCreated,
                name: previousNft.name
            });
            
            delete ownerNft[previosHash];
        }
    }
    function AddNft(bytes32 ntfName, bytes32 nftDescription, bytes32 proof, bytes16 nftId) 
    external payable
    returns(bool success){

        NftDetails memory nft = NftDetails({
                id: nftId,
                price : msg.value,
                proof: proof,
                owner: msg.sender,
                state: State.Purchased,
                description: nftDescription,
                dateCreated: block.timestamp,
                name: ntfName
        });

        AllNfts.push(nft);

        PurchaseNft(nft.id,nft.proof,nft.description,nft.name);

        return true;

    }

    function GetNftHash(bytes16 nftId)
    external
    view
    returns
    (bytes32){
        return OwnerNfthash[nftId];
    }

    function GetNft(bytes32 nfthash)
    external
    view
    returns
    (NftDetails memory){
        return ownerNft[nfthash];
    }

    function GetAllNfts()
    public
    view
    returns
    (NftDetails[] memory){
        return AllNfts;
    }

    function hasNftOwnership(bytes32 nfthash)
    private 
    view
    returns(bool)
    {
        return ownerNft[nfthash].owner == msg.sender;
    }
}