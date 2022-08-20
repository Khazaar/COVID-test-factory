// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./MedOrgContract.sol";

contract MedContractFactory is Ownable {
    struct MedicalOrganizationStruct {
        string name;
        bool approved;
        address orgAddress;
        uint256 id;
    }

    struct PersonalCOVIDDada {
        string name;
        uint256 id;
        string CIDUrl;
        DataType dataType;
    }

    enum DataType {
        Cert,
        Test
    }

    MedicalOrganizationStruct[] private medicalOrganizatios;
    string[] medicalOrganizatiosApproved;
    uint256 private orgCount;
    mapping(string => bool) public askedForApprove;
    mapping(string => bool) public approved;
    mapping(string => uint256) public nameOrgToID;

    constructor() {
        orgCount = 0;
    }

    function askForApprove(string memory _orgName) public {
        require(askedForApprove[_orgName] == false, "Approve already asked");
        askedForApprove[_orgName] = true;
        MedicalOrganizationStruct
            memory medicalOrganizationStruct = MedicalOrganizationStruct({
                name: _orgName,
                approved: false,
                orgAddress: address(0),
                id: orgCount
            });

        nameOrgToID[_orgName] = orgCount;
        medicalOrganizatios.push(medicalOrganizationStruct);
        orgCount = orgCount + 1;
    }

    function approveOrg(string memory _orgName)
        public
        onlyOwner
        returns (address)
    {
        // Checking
        require(
            askedForApprove[_orgName] == true,
            "No approve request detected"
        );
        require(
            approved[_orgName] == false,
            "Organization is already approved"
        );
        // Approving
        uint256 _id = nameOrgToID[_orgName];

        // MedicalOrganizationStruct
        //     storage medicalOrganizationStruct = medicalOrganizatios[_id];
        approved[_orgName] == true;
        address newOrgAddress = address(
            new MedOrgContract(_orgName, orgCount, address(this))
        );

        medicalOrganizatios[_id].orgAddress = newOrgAddress;
        medicalOrganizatios[_id].approved = true;

        return newOrgAddress;
    }

    function getMedicalOrganizations()
        public
        view
        onlyOwner
        returns (MedicalOrganizationStruct[] memory)
    {
        return medicalOrganizatios;
    }

    // function createOrg(string memory _orgName)
    //     public
    //     onlyOwner
    //     returns (address)
    // {
    //     require(
    //         approved[_orgName] == true,
    //         "Organization isn't already approved"
    //     );

    //     address newOrgAddress = address(
    //         new MedOrgContract(_orgName, orgCount, address(this))
    //     );
    //     MedicalOrganizationStruct
    //         memory medicalOrganizationStruct = MedicalOrganizationStruct({
    //             name: _orgName,
    //             approved: true,
    //             orgAddress: newOrgAddress
    //         });
    //     return newOrgAddress;
    // }

    function getOrgCount() public view returns (uint256) {
        return orgCount;
    }

    function getIDbyName(string memory _orgName) public view returns (uint256) {
        return nameOrgToID[_orgName];
    }
}
