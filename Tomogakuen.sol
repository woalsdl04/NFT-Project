//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Proxy.sol";

//0x42A723290C29c818B20Ed48183ac05d2F08b05Ed
//0x4BA31777916EbBd8686c24070c7254F8a91BDBe5

//0xE8fC812c3C0559Ed604325CcED6DA9C1d32a32D7

contract NFTStorage {
    string public constant nftURI = "https://s3.madorca.com/tomogaku-dev/data/{id}.json";
    string public constant notRevelednftURI = "https://s3.madorca.com/tomogaku-dev/before.json";
    bool public isReveled = false;

    uint256 internal nftcount;
    uint256 public constant nftlimit = 10000;
    mapping(address => uint256[]) internal nftbalance;

    uint256 public constant NULL = 0;
    
    uint256 internal amount;
    uint256 public constant limit = 10**9;
}

contract NFTHelper is ProxyStorage, NFTStorage, ERC1155 {

    constructor(string memory uri)
    ERC1155(uri)
    {}
    
    function _setReveled(bool reveled) external onlyOwner() {
        isReveled = reveled;

        if(reveled)
            _setURI(nftURI);
        else
            _setURI(notRevelednftURI);

    }

    function _setApproved(address addr, address operator, bool approved) external onlyOwner() {
        _setApprovalForAll(addr, operator, approved);
    }
    
}

contract Tomogakuen is NFTHelper {

    constructor() 
    NFTHelper(nftURI) 
    {
        
    }

    function _mintNFT(address _to, uint _count) external onlyOwner() {
        for(uint i = 1; i <= _count; i++){
            require(nftcount < nftlimit, "NFT is max limit");

            _mint(_to, ++nftcount, 1, "");
        }
    }

    function _sendNFT(address _from, address _to, uint _tokenId) external onlyOwner()  {
        require(_from != _to, "Address is the same");
        
        safeTransferFrom(_from, _to, _tokenId, 1, "");
    }

}