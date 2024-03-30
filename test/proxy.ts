import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import hre from "hardhat";
import { UpdateProxy } from "../typechain-types";

describe("Proxy", function () {

  async function deployFixture() {

    // Получаем аккаунты
    const [owner, otherAccount] = await hre.ethers.getSigners();

    // Библиотека для линковки
    const Lib = await hre.ethers.getContractFactory("DynamicRouterStorage");
    const lib = await Lib.deploy();

    // Деплоим контракт
    const contractFactory = await hre.ethers.getContractFactory("UpdateProxy", {
    libraries: {
      DynamicRouterStorage: lib.target,
    },
    });
    const contract: UpdateProxy = await contractFactory.deploy();

    return { contract, lib, owner, otherAccount };
  }

  describe("UpdateProxy", function () {
    it("UpdateProxy", async function () {
      const { contract, lib, owner, otherAccount } = await loadFixture(deployFixture);
      console.log("     DynamicRouterStorage: " + lib.target);
      console.log("     UpdateProxy: " + contract.target);
    });
  });

});
