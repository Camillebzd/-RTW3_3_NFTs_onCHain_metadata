const main = async () => {
  try {
    const nftContractFactory = await hre.ethers.getContractFactory(
      "ChainBattles_v2"
    );
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    
    console.log("Contract deployed to:", nftContract.address);

    await nftContract.mint();
    let json = await nftContract.getTokenURI(1);
    console.log("here is the test: ", json);
    
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};
    
main();