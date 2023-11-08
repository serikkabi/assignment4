const { ethers } = require("hardhat");
const { Staking } = require("../contracts");

describe("Staking", () => {
  // ...

  it("should allow users to stake tokens", async () => {
    const stakingContract = new Staking(ethers.provider);

    const userBalance = await stakingContract.balanceOf(ethers.provider.getAddress());

    const amount = 100;
    await stakingContract.stake(amount);

    const updatedBalance = await stakingContract.balanceOf(ethers.provider.getAddress());
    expect(updatedBalance).toBe(userBalance - amount);

    const stakedBalance = await stakingContract.stakedBalanceOf(ethers.provider.getAddress());
    expect(stakedBalance).toBe(amount);
  });
});