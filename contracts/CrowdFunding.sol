// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

contract Crowdfunding {
    address public owner;
    uint256 public goal;
    uint256 public raisedAmount;
    mapping(address => uint256) public contributions;

    constructor(uint256 _goal) {
        owner = msg.sender;
        goal = _goal;
    }

    receive() external payable {
        contribute(msg.value);
    }

    function contribute(uint256 _amount) public payable {
        require(raisedAmount < goal, "Goal already reached");
        require(_amount > 0, "Contribution amount must be greater than 0");

        uint256 remainingAmount = goal - raisedAmount;
        uint256 contribution = _amount;

        if (contribution > remainingAmount) {
            contribution = remainingAmount;
        }

        contributions[msg.sender] += contribution;
        raisedAmount += contribution;

        if (raisedAmount >= goal) {
            emit GoalReached();
        }
    }

    function withdraw() public {
        require(msg.sender == owner, "Only the owner can withdraw");
        require(raisedAmount >= goal, "Goal not reached");

        payable(owner).transfer(raisedAmount);
        raisedAmount = 0;
    }

    event GoalReached();
}