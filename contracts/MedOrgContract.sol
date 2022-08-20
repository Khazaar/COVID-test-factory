// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";

import "./MedContractFactory.sol";

contract MedOrgContract is Ownable {
    string orgName;
    uint256 orgID;
    address factory;

    MedContractFactory medContractFactory;

    //ContractFactory contractFactory;

    constructor(
        string memory _orgName,
        uint256 _orgID,
        address _factoryAddress
    ) {
        factory = msg.sender;
        orgName = _orgName;
        orgID = _orgID;
        medContractFactory = MedContractFactory(_factoryAddress);
    }
}
