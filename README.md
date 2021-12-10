Nft-game Smart Contract

This is the smart contract for the "Hero Warriors" NFT game.

### Links

- Live Site URL: [Contract on Etherscan](https://rinkeby.etherscan.io/address/0xc0ef218C09411B4F288856BaC33422fd8dCAe944)

### What I learned

I learned how to write basic game logic using code. I also was able to apply a method of gas optimization by reducing the size of the uints inside of the struct and grouping similarly sized items together. By using this method I had to make some adjustments in my code in the front end and the contract. With a regular hex number I would have had to call the toNumber() function but because uint32 is smaller that was unnecessary. I also had to typecast the properties in the attributes object as uint32 to match up with what was set in the struct.

I also wrote a test using Mocha/Chai to verify the ability for a user to mint a character. Code excerpt is below:

```javascript
describe('player actions', () => {
	it('Should be able to mint new character', async function () {
		// first connect the wallet of the person calling the function
		// have the wallet call the mint character function of the contract
		// check to ensure the contract emits the right information
		expect(gameContract.connect(p1).mintCharacterNFT(2)).to.emit(
			p1.address,
			1,
			2
		);
	});
});
```

### Continued development

I expanded upon my knowledge from creating the nft collection and learned more information about where and how to use different sized uints. I believe there is still more specifics to grasp on it so I will continue to learn. I also want to begin to make writing tests a regular practice as it is essential to blockchain development.
