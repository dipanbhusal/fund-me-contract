// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

import {PriceConverter} from "./PriceConverter.sol";

error YoFundMe__NotOwner();

contract YoFundMe {
    using PriceConverter for uint256;
    uint256 public constant MINIMUM_USD = 5e18;
    AggregatorV3Interface public s_priceFeed;
    address[] public funders;
    mapping(address funder => uint256 amountFunded)
        public addressToAmountFunded;

    address public immutable i_owner;

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    function fund() public payable {
        // only allow to fund minimum $5

        require(
            msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD,
            "must send minimum 5 USD"
        );
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function getFeedVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    modifier isOwnerOnly() {
        if (msg.sender != i_owner) {
            revert YoFundMe__NotOwner();
        }
        _; // run remaining statements after the modifier i.e. rest of the code on callign function
    }

    function withdraw() public isOwnerOnly {
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // reset the funders array
        funders = new address[](0);

        // withdraw the funds

        // transfer
        // msg.sender = address
        // payable(msg.sender) = payable address
        // payable(msg.sender).transfer(address(this).balance);

        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "transfer failed");
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
