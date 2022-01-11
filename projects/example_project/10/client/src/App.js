import React,{Component} from 'react';
import logo from './logo.svg';
import './App.css';
//import SimpleStorageContract from "./contracts/SimpleStorage.json";
import getWeb3 from "./getWeb3";
import Web3 from 'web3';
import Logo02 from './assets/Witness_02.png';
import AvatarMan from './assets/Man.png';

import HomePage from './components/Home/home';
import NFTPage from './components/NFT/nft';
import MarketPage from './components/Market/market';


import {Tabs,Button,Image} from 'antd';

const {TabPane} = Tabs;

let web3 = null;

let r,g,b=0;

  


class App extends Component{


  state = { loading: false,storageValue: 0, accounts: null, contract: null };

  connectWallet= async()=>{
    console.log("connect web3");
    if (typeof window.ethereum !== 'undefined') {
      console.log('MetaMask is installed!');
    }else{
      window.alert('Please install MetaMask first.');
      return;
    }

    //链接metamask钱包
    window.ethereum.request({ method: 'eth_requestAccounts' });
    const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
    const account = accounts[0];
    console.log(account);
    this.setState({ loading: true });//到这里metamask就连接上了，状态为true
  };

  componentDidUpdate=()=>{
    r=Math.ceil(Math.random()*255);
    g=Math.ceil(Math.random()*255);
    b=Math.ceil(Math.random()*255);
  }

  // componentDidMount = async () => {
  //   try {
    // const web3 = await getWeb3();
    //   const accounts = await web3.eth.getAccounts();
    //   const networkId = await web3.eth.net.getId();
    //   const deployedNetwork = SimpleStorageContract.networks[networkId];
    //   const instance = new web3.eth.Contract(
    //     SimpleStorageContract.abi,
    //     deployedNetwork && deployedNetwork.address,
    //   );

    //   this.setState({ web3, accounts, contract: instance }, this.runExample);
    // } catch (error) {
    //   alert(
    //     `Failed to load web3, accounts, or contract. Check console for details.`,
    //   );
  //     console.error(error);
  //   }
  // };


  // runExample = async () => {
  //   const { accounts, contract } = this.state;
  //   await contract.methods.set(5).send({ from: accounts[0] });
  //   const response = await contract.methods.get().call();
  //   this.setState({ storageValue: response });
  // };

  OperationsSlot= {
    left:<Image preview={false} className="lc"
    src={Logo02}
    />,
    right:<div className="rc">
      <Image className="avatar" preview={false} src={AvatarMan} width={30} height={30}></Image>
      <Button className="wallet" type='primary' onClick={this.connectWallet}>Connect Wallet</Button>
      </div>
  };

  render() {
    return (
      <div className="App">
        <Tabs className="tabs" tabBarExtraContent={this.OperationsSlot}>
          <TabPane className="tabs_c" tab="Home" key="1">
            <HomePage />
          </TabPane>
          <TabPane className="tabs_c" tab="NFT show" key="2">
            <NFTPage/>
          </TabPane>
          <TabPane className="tabs_c" tab="Market" key="3">
            <MarketPage />
          </TabPane>
          {/* <TabPane className="tabs_c" tab="Mint NFT" key="3">
            <CreateNFTPage r={r} g={g} b={b}/>
          </TabPane> */}
        </Tabs>
      </div>
    );
  }
}

export default App;
