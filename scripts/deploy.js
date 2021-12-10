const main = async () => {
	const gameContractFactory = await hre.ethers.getContractFactory('MyDopeGame');
	const gameContract = await gameContractFactory.deploy(
		[
			'Elmir',
			'Orion',
			'Daredevil',
			'Galahad',
			'Aurora',
			'Mojo',
			'Cleaver',
			'Tristan',
			'Nebula',
			'Ginger',
			'Keira',
			'Satori',
		],
		[
			'Qmd7CtZrgy5tHFBdspQuG4TczhJU3nxoJvz2nTVdef5XpT',
			'QmQ5j3PTTV9NCCvnfBFANboXWXPst5xuEeKjZmo1YRcjMQ',
			'QmTbUSY7poAYwUDi4UTDkpiMXTBE3EUyC7M2n4jFYeSkWv',
			'QmXzQ8FSoyrKjxL33QMw9dwwqEy9tVMFfm4kwQVuH9nXrf',
			'Qme4X9S9nF2TaGhHWFjm3dKmhKjum7yr9KbfEP6qLVx94N',
			'QmWcgfoDUqnzr1jpKCfWLzeGhwStvN72VCZrzZ2DYiycx2',
			'QmRpya9R98SVMmfhEoTGozRcbR6wV7wytCKaoonJiA2Es1',
			'QmcCpBThEzPoFZBoYrEfPsCRxKuiRuCNQ4B7mrjQfEBb79',
			'QmQbmdKygXb7rcrnKzhMLugyRPpN8o3mCjrcHpAWEC7xM8',
			'QmY3ixpywFPUsyVe8Jimz77P1une5o8rwL668X83UDLsWY',
			'Qmcarikqub5c99KiMUHbhngg7AdExKYcMQvgrvMTyH2KA1',
			'QmNgzqEKRR9S6PAyjCuFwCfs8Hv37FmUFJyiZ4kfkedaR1',
		],
		[800, 750, 900, 700, 850, 1000, 850, 950, 1000, 850, 750, 900],
		[300, 300, 250, 400, 200, 350, 500, 450, 200, 500, 350, 250],
		'Amadeus',
		'https://i.imgur.com/kJpYBbn.jpg',
		9500,
		150
	);
	gameContract.deployed();
	console.log('Contract deployed to:', gameContract.address);
};

const runMain = async () => {
	try {
		await main();
		process.exit(0);
	} catch (error) {
		console.log(error);
		process.exit(1);
	}
};

runMain();
