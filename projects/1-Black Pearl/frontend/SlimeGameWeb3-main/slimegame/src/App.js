import './css/App.css';
import Main from './component/Main';
import First from './component/First';
import Adventure from './component/Adventure';
import Challenge from './component/Challenge'
import { Routes, Route, Link } from "react-router-dom";
import Slime_ABI from "./abi/Slime.json"


// import { Web3ReactProvider } from '@web3-react/core'
// import { Web3Provider } from "@ethersproject/providers";


// function getLibrary(provider) {
//   return new Web3Provider(provider)
// }

import Web3 from "web3";
const {ethereum} = window;


window.web3 = new Web3(window.ethereum);
const account =  window.web3.eth.requestAccounts().then((res)=> {
  console.log("Start",res)
  // let SlimeContract = new window.web3.eth.Contract(Slime_ABI,"0xAD33C082cd3c43AD17E9676dbb4f49634a931500",{from: res[0] })
  // console.log(SlimeContract)

  return res
});
// const account = window.web3
const web3 = window.web3;





function App() {
  async function checkWalletIsConnected() {

    if(!ethereum) {
      console.log("Make sure your Metamask is installed!");
      return;
    }
    else
    {

      
      console.log("User is installed Metamask",account)
      let Btn = document.getElementById("ConnectBtn");
      Btn.style.display = 'none'
    }
  }
  
  return (
      <div className="App">
      <header className="App-header">
      <Routes>
        <Route path="/" element={<First account = {account} web3 = {web3}/>} />
        <Route path="/start" element={<Main account = {account} web3 = {web3} />} />
        <Route path="/Adventure" element={<Adventure account = {account} web3 = {web3}/>} />
        <Route path="/Challenge" element={<Challenge account = {account} web3 = {web3} />} />
        
      </Routes>
      <div className=" ConnectBtn flex flex-col items-center">

              <Link to = "/start">

                    <button id='ConnectBtn' className="  Btn2 mt-5" type="button" onClick={checkWalletIsConnected} > 连接钱包 </button>
                    {/* <button className="Btn2  " type="button" onClick={check}> 查看用户资产 </button> */}

                    {/* <button className="Btn2 " type="button"> 点击进入初界 </button> */}
              </Link>
        </div>
      </header>
   
      </div>
  );
}

export default App;
