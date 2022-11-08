pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

error Withdraw_Failed();
error SellToken_Failed();
error NotOwner();

contract Vendor is Ownable {
    //event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

    YourToken public yourToken;
    uint256 public constant tokensPerEth = 100;

    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

    constructor(address tokenAddress) {
        yourToken = YourToken(tokenAddress);
    }

    modifier isOwner() {
        if (msg.sender != owner()) revert NotOwner();
        _;
    }

    function buyTokens() public payable {
        uint256 numTokens = msg.value * tokensPerEth;
        yourToken.transfer(msg.sender, numTokens);
        emit BuyTokens(msg.sender, msg.value, numTokens);
    }

    function withdraw() public isOwner {
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        if (!callSuccess) revert Withdraw_Failed();
    }

    function sellTokens(uint256 _amount) public {
        yourToken.transferFrom(msg.sender, address(this), _amount);
        (bool callSuccess, ) = payable(msg.sender).call{
            value: _amount / tokensPerEth
        }("");
        if (!callSuccess) revert SellToken_Failed();
    }
    // ToDo: create a payable buyTokens() function:

    // ToDo: create a withdraw() function that lets the owner withdraw ETH

    // ToDo: create a sellTokens(uint256 _amount) function:
}
