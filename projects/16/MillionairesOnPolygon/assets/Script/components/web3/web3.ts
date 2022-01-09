const { ccclass, property } = cc._decorator;
const Web3 = require("web3/dist/web3.min.js");

import { GameABI } from "./abi/GameABI";
import NodeData from "./../../data/NodeData";

import { infuraUri, polygonMumbai, GAMEADDRESS } from "./config/config.js";

const WinEthereum = window.ethereum;
const WinWeb3 = window.web3;

@ccclass
export default class Web3Class extends cc.Component {
  private web3Provider;
  private switchChainFlag = 0;
  private contractsInitFlag = 0;
  private web3;

  private GameContract;

  public currentAccount = null;

    async onLoad() {
      // console.log(ERC20ABI);
      // console.log(DistributionABI);
      // console.log(infuraUri);
      await this.InitWeb3();
    }

  async InitWeb3() {
    let my = this;
    let checkMetaMaskFlag = await this.checkMetaMask();
    console.log(checkMetaMaskFlag);
    if (checkMetaMaskFlag == 2) {
      await this.switch();
      if (this.switchChainFlag == 1) {
        let setWeb3ProviderFlag = await this.setWeb3Provider();
        if (setWeb3ProviderFlag == 1) {
          console.log(this.web3Provider);
          this.web3 = await new Web3(this.web3Provider);

          let accounts = await this.web3.eth.getAccounts();
          console.log(accounts);
          if (accounts.length == 0) {
            console.log("账户数组为空");
            return;
          }
          this.currentAccount = accounts[0];
          await this.web3.eth.getBalance(accounts[0], (err, wei) => {
            if (!err) {
              let balance = my.web3.utils.fromWei(wei, "ether");
              console.log("Matic余额==", balance);
              console.log("web3Provider:", my.web3Provider);
              console.log("switchChainFlag:", my.switchChainFlag);
              console.log("web3:", my.web3);
              my.initContracts();
              if(my.node.getComponent("Loading")){
                my.node.getComponent("Loading").showStart();
              }
              // NodeData.getCanvasNode().getComponent("Loading").showStart();
            }
          });
          // 监听钱包切换
          // let my = this;
          WinEthereum.on("accountsChanged", function (accounts) {
            if (accounts.length == 0) {
              console.log("没有已授权的钱包地址");
              return;
            }
            console.log(accounts[0]); //一旦切换账号这里就会执行
            my.currentAccount = accounts[0];
            my.web3.eth.getBalance(accounts[0], (err, wei) => {
              if (!err) {
                let balance = my.web3.utils.fromWei(wei, "ether");
                console.log("Matic余额==", balance);
              }
            });
          });
        } else {
          console.log("setWeb3Provider error");
        }
      } else {
        console.log("转换链失败");
      }
    } else {
      console.log("checkMetaMask error");
    }
  }

  initContracts() {
    this.GameContract = new this.web3.eth.Contract(GameABI, GAMEADDRESS);
    this.contractsInitFlag = 1;
  }

  // 调用payable的方法
  async StartGame() {
    let my = this;
    if (this.GameContract) {
      this.GameContract.methods
        .StartGame()
        .send({
          from: my.currentAccount,
          value: my.web3.utils.toWei("0.5", "ether"),
        })
        .on("receipt", function (receipt) {
          console.log(receipt);
          //开始游戏
          cc.director.loadScene('game');
          // my.node.getComponent("Loading").goToGame();
        })
        .on("error", function (error) {
          console.log(error);
          alert("支付失败！请重新尝试！")
        });
    }
  }

  // 调用payable的方法
  async ExpandCap() {
    let my = this;
    if (this.GameContract) {
      this.GameContract.methods
        .Expand()
        .send({
          from: my.currentAccount,
          value: my.web3.utils.toWei("0.5", "ether"),
        })
        .on("receipt", function (receipt) {
          console.log(receipt);
          NodeData.getGameDataComponent().expandCapcityByMatic()
        })
        .on("error", function (error) {
          console.log(error);
        });
    }
  }

    async getTopPlayerCall() {
      if (this.GameContract) {
        let result = await this.GameContract.methods.getTopPlayer().call();
        console.log(result)
      }
    }

    async totalBlockCall() {
      if (this.GameContract) {
        let result = await this.GameContract.methods.totalBlock().call();
        console.log(result)
      }
    }

    async getRankData(){
      let data = {
        block:"BLOCK:0",
        address:"ADDRESS:0x21Fca6F577b5b6cdD711A5E0E1988c0e38DeC1f0",
        grade:"Grade:99325525"
      }
      if (this.GameContract) {
        let block = await this.GameContract.methods.totalBlock().call();
        let result = await this.GameContract.methods.getTopPlayer().call();
        data.block = 'BLOCK:' + block;
        data.address = 'ADDRESS:' + result[0];
        data.grade = 'Grade:' + result[1];
      }
      return data;
    }

  async postGrade(grade) {
    let my = this;
    this.GameContract.methods
      .PostData(grade)
      .send({ from: my.currentAccount })
      .on("receipt", function (receipt) {
        NodeData.getGameDataComponent().resetAllData()
        NodeData.getLeavePanelComponent().ClosePanel();
      })
      .on("error", function (error) {
        // 告诉用户合约失败了
        alert("交易失败！请重新发起交易！")
      });
  }

  async checkMetaMask() {
    if (WinEthereum) {
      if (typeof WinEthereum !== "undefined") {
        console.log("MetaMask is installed!");
        return 2;
      } else {
        console.log("MetaMask未安装！");
        return 1;
      }
    } else {
      console.log("啥也没有！");
      return 0;
    }
  }

  async setWeb3Provider() {
    if (WinEthereum) {
      this.web3Provider = WinEthereum;
      try {
        // 请求用户授权
        await WinEthereum.enable();
      } catch (error) {
        // 用户不授权时
        console.error("User denied account access");
        return 0;
      }
    } else if (WinWeb3) {
      this.web3Provider = WinWeb3.currentProvider;
    } else {
      this.web3Provider = new Web3.providers.HttpProvider(infuraUri);
    }
    return 1;
  }

  async switch() {
    console.log(WinEthereum.chainId);
    if (WinEthereum.chainId == 0x13881) {
      this.switchChainFlag = 1;
      console.log("已连接到Polygon Mumbai");
      return;
    }
    await this.switchChain(polygonMumbai);
  }

  async addChain(data) {
    try {
      await WinEthereum.request({
        method: "wallet_addEthereumChain",
        params: [data],
      });
    } catch (addError) {
      console.log(addError);
      // handle "add" error
    }
  }

  async switchChain(data) {
    try {
      let { chainId } = data;
      await WinEthereum.request({
        method: "wallet_switchEthereumChain",
        params: [{ chainId }],
      });
      this.switchChainFlag = 1;
    } catch (switchError) {
      // This error code indicates that the chain has not been added to MetaMask.
      console.log(switchError);
      if (switchError.code === 4902) {
        await this.addChain(data);
        this.switchChainFlag = 1;
      }
      // handle other "switch" errors
    }
  }

  // update (dt) {}
}
