// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract Staking {
    address public owner;
    uint public stakingPeriod;
    uint public totalRewards;
    mapping(address => uint) public userBalances;
    mapping(address => uint) public stakedBalances;
    mapping(address => uint) public stakingStartTimes;

    constructor(uint _stakingPeriod, uint _totalRewards) {
        owner = msg.sender;
        stakingPeriod = _stakingPeriod;
        totalRewards = _totalRewards;
    }

    function stake(uint _amount) public {
        require(userBalances[msg.sender] >= _amount, "Insufficient balance");

        userBalances[msg.sender] -= _amount;

        stakedBalances[msg.sender] += _amount;

        stakingStartTimes[msg.sender] = block.timestamp;
    }

    function calculateRewards(address _user) public view returns (uint) {

        uint timeStaked = block.timestamp - stakingStartTimes[_user];


        uint rewards = (stakedBalances[_user] * timeStaked) / stakingPeriod;

        return rewards;
    }

    function distributeRewards() public {
        address[] memory stakersList = getStakers();

        for (uint i = 0; i < stakersList.length; i++) {
            address staker = stakersList[i];

            uint rewards = calculateRewards(staker);

            userBalances[staker] += rewards;

            stakedBalances[staker] = 0;
            stakingStartTimes[staker] = 0;
        }
    }

    function getStakers() public view returns (address[] memory) {

    }

    function withdraw() public {
        uint totalBalance = userBalances[msg.sender] + calculateRewards(msg.sender);

        require(totalBalance > 0, "Insufficient balance to withdraw");

        address payable recipient = payable(msg.sender);

        recipient.transfer(totalBalance);

        stakedBalances[msg.sender] = 0;
        stakingStartTimes[msg.sender] = 0;

        if (userBalances[msg.sender] == 0) {
            delete userBalances[msg.sender];
        }
    }
}
