import "../css/Main.css"
import { useEffect,useState } from "react";
import {  Link } from "react-router-dom";
import Slime_ABI from "../abi/Slime.json"

import Web3 from "web3";

const {ethereum} = window;
window.web3 = new Web3(window.ethereum);


const Main = (account,web3)=> {


const [name,setName] = useState(0);
const [skillNum,setSkill] = useState(0);
const [power,setPower] =useState(0)
const [nickName,setNick] = useState("一只史莱姆")
const [accountAddr,setAddr] = useState("0");

const [welcomeText,setText] = useState("你好~ 欢迎来到“初界”，史莱姆阁下，我是指引精灵，请先浏览并完善你的系统面板")





useEffect(() => {
    console.log("Check account",accountAddr)
    if(accountAddr != "0"){
    check()
    }
  }, [accountAddr,account])
  

  async function createSlime() {
      if(ethereum)
      {
        const addr = await account.account.then((accounts)=> {
            console.log("Create New Slime.....",accounts[0])

            setAddr(accounts[0])
            // console.log(accountAddr)
            // console.log(SlimeContract.methods.getAddress().call()
            return accounts[0]
           
        })

        console.log("addr is ",account,addr)
        let SlimeContract = new account.web3.eth.Contract(Slime_ABI,"0xAD33C082cd3c43AD17E9676dbb4f49634a931500",{from: addr})



        console.log("Contract is " ,SlimeContract)



        let res = await SlimeContract.methods.createShrem(name).send()
        console.log("Create result is :" , res );
   
        let check = await SlimeContract.methods.getShremId().call();
        if (check != 0)
        {
            console.log("Create Success!!!!!!! your id is ",check)
        }
        else console.log("Create failed ---",check);
        let Btn = document.getElementById('CreateBtn');
        Btn.style.display= "none";

      }
      else{
        console.log("Pls login first")
      }

  }
  async function check() {
    let SlimeContract = new window.web3.eth.Contract(Slime_ABI,"0xAD33C082cd3c43AD17E9676dbb4f49634a931500",{from: accountAddr })
    // console.log(SlimeContract.methods.getAddress().call())
    let SlimeId = SlimeContract.methods.getShremId().then((res)=> {
        if(res == 0){
            console.log("You have not created Slime yet")
        }
        else {
            console.log("Your SLime Id is :  ", res )
        }

    }).catch((err)=>{
        console.log(err)
    })
    }

    async function load() {
        let SlimeContract = new window.web3.eth.Contract(Slime_ABI,"0xAD33C082cd3c43AD17E9676dbb4f49634a931500",{from: accountAddr })
        let SlimeId = SlimeContract.methods.getShremId().call();
        if(SlimeId == 0)
        {
            alert("U have not create Slime yet")
        }
        else console.log("Id is " ,SlimeId)

    }
  



    return(
        <div className="Main">

        
            <div id="Bar1">
                <div className="InfoCard">
                    <div id="textcard" className="InfoText">
                        <div>种族 : 史莱姆</div>
                        <div className="TextBox">
                        <div>名称: <input id="name" type={"text"} style={{height:"50px",width:"200px",color:"black"}} required = {true}></input></div>
                    </div>
                    <div>战斗力 : {power}</div>
                    <div>技能数 : {skillNum}</div>
                    <div>技能列表 : </div>
                    <div>称号 : {nickName}</div>
                </div>




                </div>
                <div className="flex flex-row">
                    <button id="CreateBtn" className="Btn2 mt-5 mr-5" type="button" onClick={()=>{
                        alert("Your slime:"+document.getElementById("name").value+ "is Created!");
                        setName(document.getElementById("name").value)
                        createSlime()
                        setText("欢迎你，尊敬的史莱姆殿下! ")
                        




                    }}> 新建存档 </button>
                    <button id="LoadBtn" className="Btn2 mt-5 ml-5" type="button" onClick={()=>{
                        alert(document.getElementById("name").value);
                        load()
                        setText("欢迎回来，"+name+"!“ 目标是成为无情战斗的魔王伊塔! ” (slogan)")
                    }}> 加载存档 </button>
                </div>
            </div>
            <div className="flex flex-col items-center" >
            <div id="Bar3" className="flex flex-row">
            <Link to = "/Adventure">
                <div  className="Card h-40 w-80 text-center"  onMouseEnter={()=>{
                    setText("初次登录，你就获得了10次机会，用于探索初界地图。\n 每隔一小时，就能增加一次探索次数，上限为10次，记得按时去点击领取喔。\n探索模式不仅可以帮助减少伊塔的饱食度，还隐藏着丰富的碎片，快来发现吧~!")

                }}
                onMouseLeave={()=>{
                    setText("欢迎回来，"+name+"!“ 目标是成为无情战斗的魔王伊塔! ” (slogan)")
                }}
                >
                探索
              
               
                </div>
                </Link>
                <Link to = "/Challenge">

                <div  className="Card h-40 w-80 ml-5 text-center"  onMouseEnter={()=>{
                    setText("只要伊塔的饱食度低于100%，就可以来这里开启挑战\n在挑战模式中，你可以使用已获得的各种技能、发挥战斗力，打败怪物；\n每位伊塔都有一个默认技能:捕食者。如果伊塔挑战成功，则会自动触发捕食者技能，吞噬怪物，同\n时获得怪物掉落的技能和战斗力!当然饱食度也会有一定的回升~\n所以请记住，饱食度、技能和战斗力都是伊塔进化的关键因素哦!")

                }}       onMouseLeave={()=>{
                    setText("欢迎回来，"+name+"!“ 目标是成为无情战斗的魔王伊塔! ” (slogan)")
                }}
                >
                挑战
                </div>
                </Link>
            </div>
            <div id="Bar2" className="Card2 items-start">
                
                <div>系统:</div>
                <div></div>
                <div>{welcomeText}</div>
            </div>
            </div>


        </div>

    );

}


export default Main;

