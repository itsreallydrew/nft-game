// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "hardhat/console.sol";

import "../libraries/Base64.sol";

contract MyDopeGame is ERC721 {
    /// @notice this creates an object that will store the information on each character
    /// @dev using uint32 for the variables to reduce the cost of gas

    struct CharacterAttributes {
        uint256 characterIndex;
        string name;
        string imageURI;
        uint32 hp;
        uint32 maxHp;
        uint32 attackDamage;
    }

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    CharacterAttributes[] defaultCharacters;

    mapping(uint256 => CharacterAttributes) public nftHolderAttributes;

    struct BigBoss {
        string name;
        string imageURI;
        uint32 hp;
        uint32 maxHp;
        uint32 attackDamage;
    }

    BigBoss public bigBoss;

    /// @dev maps address to tokenId to store the owner of the NFT
    mapping(address => uint256) public nftHolders;

    event CharacterNFTMinted(
        address sender,
        uint256 tokenId,
        uint256 characterIndex
    );
    event AttackComplete(uint256 newBossHp, uint256 newPlayerHp);

    constructor(
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint256[] memory characterHp,
        uint256[] memory characterAttackDmg,
        string memory bossName,
        string memory bossImageURI,
        uint256 bossHp,
        uint256 bossAttackDamage
    ) ERC721("HeroWarriors", "HWAR") {
        bigBoss = BigBoss({
            name: bossName,
            imageURI: bossImageURI,
            hp: uint32(bossHp),
            maxHp: uint32(bossHp),
            attackDamage: uint32(bossAttackDamage)
        });

        console.log(
            "Done initializing boss %s w/ HP %s, img %s",
            bigBoss.name,
            bigBoss.hp,
            bigBoss.imageURI
        );

        /// @dev must typecast the variables as uint32 because by default the for loop is using uint256

        for (uint256 i = 0; i < characterNames.length; i++) {
            defaultCharacters.push(
                CharacterAttributes({
                    characterIndex: i,
                    name: characterNames[i],
                    imageURI: characterImageURIs[i],
                    hp: uint32(characterHp[i]),
                    maxHp: uint32(characterHp[i]),
                    attackDamage: uint32(characterAttackDmg[i])
                })
            );

            CharacterAttributes memory c = defaultCharacters[i];
            console.log(
                "Done initializing %s w/ img %s, HP %s",
                c.name,
                c.imageURI,
                c.hp
            );
        }
        _tokenIds.increment();
    }

    function mintCharacterNFT(uint256 _characterIndex) external {
        uint256 newItemId = _tokenIds.current();

        _safeMint(msg.sender, newItemId);

        nftHolderAttributes[newItemId] = CharacterAttributes({
            characterIndex: _characterIndex,
            name: defaultCharacters[_characterIndex].name,
            imageURI: defaultCharacters[_characterIndex].imageURI,
            hp: defaultCharacters[_characterIndex].hp,
            maxHp: defaultCharacters[_characterIndex].maxHp,
            attackDamage: defaultCharacters[_characterIndex].attackDamage
        });

        console.log(
            "Minted NFT w/ tokenId %s and characterIndex %s",
            newItemId,
            _characterIndex
        );

        nftHolders[msg.sender] = newItemId;

        _tokenIds.increment();

        emit CharacterNFTMinted(msg.sender, newItemId, _characterIndex);
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        CharacterAttributes memory charAttributes = nftHolderAttributes[
            _tokenId
        ];

        string memory strHp = Strings.toString(charAttributes.hp);
        string memory strMaxHp = Strings.toString(charAttributes.maxHp);
        string memory strAttackDamage = Strings.toString(
            charAttributes.attackDamage
        );

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        charAttributes.name,
                        " -- NFT #: ",
                        Strings.toString(_tokenId),
                        '", "description": "This is an NFT that lets people play in the game Metaverse Hero!", "image": "ipfs://',
                        charAttributes.imageURI,
                        '", "attributes": [ {"trait_type": "Health Points", "value": ',
                        strHp,
                        ', "max_value":',
                        strMaxHp,
                        '}, {"trait_type": "Attack Damage", "value": ',
                        strAttackDamage,
                        "}]}"
                    )
                )
            )
        );

        string memory output = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        return output;
    }

    function attackBoss() public {
        uint256 nftTokenIdOfPlayer = nftHolders[msg.sender];
        CharacterAttributes storage player = nftHolderAttributes[
            nftTokenIdOfPlayer
        ];
        console.log(
            "\nPlayer w/ character %s about to attack. Has %s HP and %s AD",
            player.name,
            player.hp,
            player.attackDamage
        );
        console.log(
            "Boss %s has %s HP and %s AD",
            bigBoss.name,
            bigBoss.hp,
            bigBoss.attackDamage
        );

        require(player.hp > 0, "Error: character must have HP to attack boss.");

        require(bigBoss.hp > 0, "Error: boss has no more HP.");

        if (bigBoss.hp < player.attackDamage) {
            bigBoss.hp = 0;
        } else {
            bigBoss.hp = bigBoss.hp - player.attackDamage;
        }

        if (player.hp < bigBoss.attackDamage) {
            player.hp = 0;
        } else {
            player.hp = player.hp - bigBoss.attackDamage;
        }

        console.log("Player attacked boss. New boss hp: %s", bigBoss.hp);
        console.log("Boss attacked player. New player hp: %s", player.hp);

        emit AttackComplete(bigBoss.hp, player.hp);
    }

    function checkIfUserHasNFT()
        public
        view
        returns (CharacterAttributes memory)
    {
        // get token ID of user's character NFT
        uint256 userNftTokenId = nftHolders[msg.sender];
        // If user has token ID return their character
        if (userNftTokenId > 0) {
            return nftHolderAttributes[userNftTokenId];
            // Else return an empty character
        } else {
            CharacterAttributes memory emptyStruct;
            return emptyStruct;
        }
    }

    function getAllDefaultCharacters()
        public
        view
        returns (CharacterAttributes[] memory)
    {
        return defaultCharacters;
    }

    function getBigBoss() public view returns (BigBoss memory) {
        return bigBoss;
    }
}
