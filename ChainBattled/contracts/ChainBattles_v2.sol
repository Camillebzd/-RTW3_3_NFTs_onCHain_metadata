// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles_v2 is ERC721URIStorage  {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct Hero {
        uint256 level;
        uint256 speed;
        uint256 strenght;
        uint256 life;
    }
    mapping(uint256 => Hero) public tokenIdToHero;

    constructor() ERC721 ("Chain Battles", "CBTLS"){
    }

    function generateCharacter(uint256 tokenId) public view returns(string memory){
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="30%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">', "Level: ",getLevel(tokenId),'</text>',
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Speed: ",getSpeed(tokenId),'</text>',
            '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">', "Strenght: ",getStrength(tokenId),'</text>',
            '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">', "Life: ",getLife(tokenId),'</text>',
            '</svg>'
        );
        return string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svg)
            )    
        );
    }

    function getLevel(uint256 tokenId) public view returns (string memory) {
        return tokenIdToHero[tokenId].level.toString();
    }

    function getSpeed(uint256 tokenId) public view returns (string memory) {
        return tokenIdToHero[tokenId].speed.toString();
    }

    function getStrength(uint256 tokenId) public view returns (string memory) {
        return tokenIdToHero[tokenId].strenght.toString();
    }

    function getLife(uint256 tokenId) public view returns (string memory) {
        return tokenIdToHero[tokenId].life.toString();
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory){
        bytes memory dataURI = abi.encodePacked(
            '{',
                '"name": "Chain Battles #', tokenId.toString(), '",',
                '"description": "Battles on chain",',
                '"image": "', generateCharacter(tokenId), '",',
                '"attributes": [',
                    '{', 
                        '"trait_type" : "Level",',
                        '"value" : "', getLevel(tokenId), '"',
                    '},',
                    '{', 
                        '"trait_type" : "Speed",',
                        '"value" : "', getSpeed(tokenId), '"',
                    '},',
                    '{', 
                        '"trait_type" : "Strength",',
                        '"value" : "', getStrength(tokenId), '"',
                    '},',
                    '{', 
                        '"trait_type" : "Life",',
                        '"value" : "', getLife(tokenId), '"',
                    '}',
                ']',
            '}'
        );
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }

    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        tokenIdToHero[newItemId].level = 0;
        tokenIdToHero[newItemId].speed = random(11);
        tokenIdToHero[newItemId].strenght = random(11);
        tokenIdToHero[newItemId].life = random(11);
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function random(uint number) public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % number;
    }

    function train(uint256 tokenId) public {
        require(_exists(tokenId), "Please use an existing token.");
        require(ownerOf(tokenId) == msg.sender, "You must own this token to train it.");
        tokenIdToHero[tokenId].level++;
        tokenIdToHero[tokenId].speed += 5;
        tokenIdToHero[tokenId].strenght += 5;
        tokenIdToHero[tokenId].life += 5;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }
}