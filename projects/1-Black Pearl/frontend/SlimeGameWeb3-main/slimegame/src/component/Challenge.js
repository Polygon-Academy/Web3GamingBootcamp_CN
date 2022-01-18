import "../css/Main.css"

import {  Link } from "react-router-dom";
import Slime_ABI from "../abi/Slime.json"
// import { useWeb3React } from "@web3-react/core"
// import { InjectedConnector } from '@web3-react/injected-connector'
// export const injected = new InjectedConnector({
//   supportedChainIds: [137],
// })
import Web3 from "web3";
const {ethereum} = window;





const Adventure = (account , web3)=> {

  // const { active, account, library, connector, activate, deactivate } = useWeb3React()
  // let web3 = new Web3(Web3.givenProvider || "ws://localhost:8545");

  


 

    return(
        <div  >
            <div id="ChallengeBar" className="ChallengeBg" >

            </div>
        </div>

    );

}


export default Adventure;

