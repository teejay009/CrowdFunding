// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.26;

contract CrowdFunding {
    struct Campaign {
        
        address owner;
        string title;
        string description;
        uint256 fundingGoal;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        bool paidOut;
       
    }

    mapping(uint256 => Campaign) public campaigns;

    uint256 public numberOfCampaigns = 0;

    function createCampaign(
        address _owner,
        string memory _title,
        string memory _description,
        uint256 _target,
        uint256 _deadline,
        string memory _image
    ) public returns (uint256) {
        Campaign storage campaign = campaigns[numberOfCampaigns];

        require(
            _deadline > block.timestamp,
            "The deadline should be a date in the future."
        );

        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.fundingGoal = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;
        campaign.image = _image;

        numberOfCampaigns++;

        return numberOfCampaigns - 1;
    }

    function payout(uint256 _id) public {
        Campaign storage campaign = campaigns[_id];

        require(
            msg.sender == campaign.owner,
            "Only the campaign owner can withdraw funds"
        );
        require(!campaign.paidOut, "Funds already withdrawn");

        uint256 payoutAmount = campaign.amountCollected;
        require(payoutAmount > 0, "No funds to withdraw");

        campaign.amountCollected = 0;
        campaign.paidOut = true;

        (bool sent, ) = payable(campaign.owner).call{value: payoutAmount}("");
        require(sent, "Failed to send funds to the campaign owner");
    }
}