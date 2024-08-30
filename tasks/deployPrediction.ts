import { task } from "hardhat/config";

task("deployPrediction", "Deploys a prediction contract")
  .addParam("stakeamount", "The amount to be staked for voting")
  .addParam("gameend", "The timestamp for game end.")
  .setAction(async (taskArgs, hre) => {
    const stakeAmount = taskArgs.stakeAmount;
    const gameEnd = taskArgs.gameEnd;

    console.log(`Deploying "Prediction" on network: "${hre.network.name}"`);
    const constructorArgs = [
      BigInt(taskArgs.stakeamount),
      BigInt(taskArgs.gameend),
    ];
    console.log(`Contract constructor args: [${constructorArgs}]`);

    const contract = await hre.ethers.deployContract(
      "Prediction",
      constructorArgs,
      {}
    );
    await contract.waitForDeployment();
    console.log(`${taskArgs.contract} deployed to: ${contract.target}`);
  });
