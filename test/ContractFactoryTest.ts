import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";
//import { BigNumber } from "ethers";
import { BigNumber } from "@ethersproject/bignumber";
//import { MedOrgContract__factory, MedContractFactory__factory } from "../typechain-types/";
import { MedOrgContract__factory, MedContractFactory__factory } from "../typechain-types/"


describe("MedContractFactory", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshopt in every test.
  async function deployMedContractFactoryFixture() {
    // Contracts are deployed using the first signer/account by default
    const [owner, user1, user2, user3] = await ethers.getSigners();

    const medContractFactory = await new MedContractFactory__factory(owner).deploy();

    return { medContractFactory, owner, user1, user2, user3 };
  }

  describe("Deployment", function () {
    it("Should set org counter to 0", async function () {
      const { medContractFactory } = await loadFixture(deployMedContractFactoryFixture);
      console.log(await medContractFactory.getOrgCount());

      expect(await medContractFactory.getOrgCount()).to.equal(0);
    });

  });

  describe("Med organization management", function () {
    it("Should be asked for approve", async function () {
      const { medContractFactory, owner, user1, user2, user3 } = await loadFixture(deployMedContractFactoryFixture);
      const _orgName = "Hospital1";;
      await medContractFactory.connect(user1).askForApprove(_orgName);
      expect(await medContractFactory.askedForApprove(_orgName)).to.equal(true);
      const _id: BigNumber = await medContractFactory.getIDbyName(_orgName);
      const medicalOrganizatios = await medContractFactory.getMedicalOrganizations();
      expect(medicalOrganizatios[_id]).to.equal(true);

    });

    it("Should be approved", async function () {
      const { medContractFactory } = await loadFixture(deployMedContractFactoryFixture);
      await medContractFactory.askForApprove("Hospital1")

      expect(await medContractFactory.askedForApprove("Hospital1")).to.equal(true);
    });

  });


});
