import { useEffect, useState } from 'react'; //check Metamask 
import './App.css';
import { ethers } from 'ethers';
import { abis, addresses } from './contracts/index';
import Toast from "react-common-toast"; 

function App() {

  // 账户信息
  const [currentAccount, setCurrentAccount] = useState(null);

  // 合约交互相关
  const [scBalance, setscBalance] = useState(null);
  const [isLotteryOpen, setIsLotteryOpen] = useState(null);
  const { ethereum } = window;
  const provider = new ethers.providers.Web3Provider(ethereum);
  const signer = provider.getSigner();
  const starcoinContract = new ethers.Contract(addresses.starcoin, abis.starcoin, signer);
  const lotteryContract = new ethers.Contract(addresses.lottery, abis.lottery, signer);
  
  var myAccount,mySCBalance=0,isOpen=false,mySelectedNum=1;
  
  // 连接钱包按钮UI渲染
  const connectWalletButton = () => {
    return (
      <button onClick={connectWalletHandler} className='cta-button connect-wallet-button'>
        Connect Wallet
      </button>
    )
  }

  // 显示开盘状态的UI渲染
  const lotteryOpened = () => {
    return (
      <label>当前: {isLotteryOpen===true ? "已开始" : "已结束等待下一局"}</label>
    )
  }
  // 购买STAR COIN的按钮UI渲染
  const buyStarCoinButton = () => {
    return (
      <button onClick={buyStarCoinHandler} className='buyStarCoinBtn'>
        Buy
      </button>
    )
  }

  // 统计StarCoin的UI渲染
  const starCoinAmount = () => {
    return (
      <label>Star Coin Amount: {scBalance ? scBalance : 0}</label>
    )
  }
  
  
  const deposit = () => {
    return (
	  <button onClick={depositHandler} className='buyStarCoinBtn'>
        Deposit
      </button>
    )
  }
  
  const SelectNum = () => {
    return (
      <input type="number" min="0"  max="6" id="depositor" onChange={handleChange}/>
    )
  }

  // Survive按钮的UI渲染
  const checkSurvivorButton = () => {
    return (
	<button onClick={checkSurvivorHandler} className='cta-button survive-button'>
        Survive
	</button>
    )
  }
  


  // ----------------------------------- 以下是需要跟合约交互的部分 ------------------------------//
    //页面load触发
    const onLoadHandle = async () => { 
	
	  if(!ethereum) {
		console.log("no metamask installed");
		return;
	  } else {
		console.log("metamask found");
	  }
  
	  const accounts = await ethereum.request({ method: 'eth_accounts' });
	  if(accounts.length !== 0) {

		myAccount = accounts[0];
		console.log("Found an authorized account: ", myAccount);
		
		// Check if sthing has changed
		var accountInterval = setInterval(function() {	
			checkLotteryOpenHandler();			  
		  //if (accounts[0] !== currentAccount) {
			//	console.log('currentAccount to be :'+currentAccount+' and myAccount='+myAccount );
		  //}
		}, 30000);
		
		// 监听账户变化，更新对应sc余额
		ethereum.on('accountsChanged', async (acc) => {
			myAccount = acc[0];
			let balance=await starcoinContract.balanceOf(currentAccount);
			mySCBalance=balance.toNumber();
			checkLotteryOpenHandler();
			console.log('accountsChanged,it\'s balance is '+ mySCBalance);
		 });
		
		try{
			//console.log(starcoinContract.address);
			console.log(starcoinContract.interface);
			//console.log(await starcoinContract.name());
			//console.log(await starcoinContract.totalSupply());
			//console.log(await starcoinContract.decimals());
			
			let balance=await starcoinContract.balanceOf(accounts[0]);
			mySCBalance=balance.toNumber();
			checkLotteryOpenHandler();
			console.log('accountsConnected,it\'s balance is '+ mySCBalance);	
			} catch(err){
			  console.log(err);
			}			
	   } else {
				connectWalletHandler();
				console.log("No authorized accound found.");
	   }
	   
	   setCurrentAccount(myAccount);console.log('currentAccount:'+currentAccount);
	   setscBalance(mySCBalance);
	   
	   
	    var box = document.querySelector(".box");
		//box.empty();
		var title = document.createElement("div");
		title.style.width = "498px";
		title.style.color = "red";
		title.style.fontWeight = "bold";
		title.style.textIndent = "10px";
		title.style.marginTop = "10px";
		title.style.border = "1px solid black";

		test(7,12,box);
		function test(h,l,target) {
			for (var i = 0; i  < h ; i++){
				(function (i) {
					var item = document.createElement("div");
					item.setAttribute("class" , "item");
					target.appendChild(item);

					for (var j = 0 ; j < l ; j++){
						(function (j) {
							var div = document.createElement("div");
							if (j == 0 ){
								div.setAttribute("class" , "first");
								div.innerText = "第" + (i+1) + "排"
							}else {
								div.setAttribute("class" , "chart");
								div.innerText = j;
								div.style.backgroundColor = getRandomColor();
								div.onclick = function () {
									this.setAttribute("class" , "onchart");
									//var p = document.createElement("p");
									//p.innerText = "第" + (i + 1) + "排 第" + j + "号";
									//title.appendChild(p);
									Toast.info('选座功能开发中...');
								}
							}
							item.appendChild(div);
						})(j)
					}
					//target.appendChild(title)

				})(i)
			}
		}
		
		function getRandomColor(){
			var rgb='rgb('+Math.floor(Math.random()*255)+','
					 +Math.floor(Math.random()*255)+','
					 +Math.floor(Math.random()*255)+')';
			console.log(rgb);
			return rgb;
		}
    }


    // 连接钱包的handler
    const connectWalletHandler = async () => { 

	  if(!ethereum) {
        alert("Please install Metamask!")
      }
  
      try{
        const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
        console.log("Found an account! Address: ", accounts[0]);
		myAccount = accounts[0];
      } catch (err) {
        console.log(err);
      }
	  //setCurrentAccount(myAccount);
    }
	
 // Step0. 检查开盘状态，并在前端显示
  const checkLotteryOpenHandler =  async () => {
	//console.log(lotteryContract.address);
	console.log(lotteryContract.interface);
	console.log(await lotteryContract.getLotteryId());
	isOpen=await lotteryContract.getLotteryOpen();
	console.log(isOpen);
	if(isLotteryOpen===true){
		//console.log(await lotteryContract.getPool());
		console.log((isLotteryOpen===true)?"开局":"未开始或已结束");
		Toast.info('游戏进行中,有客到...');
	}else{
		Toast.info('请耐心等待,新的一局将开始...');
	}
	setIsLotteryOpen(isOpen);
	console.log(await lotteryContract.manager());
	console.log(isLotteryOpen);
  }


  // Step1: 购买STAR COIN的handler
  const buyStarCoinHandler = async () => {
    try{
      if (ethereum) {
		//console.log(starcoinContract.address);
		//console.log(starcoinContract.interface);
		//console.log(await starcoinContract.name());
		//console.log(await starcoinContract.totalSupply());
		let mySelectedNum = document.getElementById('depositor').value;
		
		if(mySelectedNum>0){
			console.log('您选择购买的数量是'+mySelectedNum);
			console.log(await starcoinContract._mint(currentAccount,mySelectedNum,0));
			Toast.info('购买'+mySelectedNum+'已发出,等待成交');
		}else{
			Toast.info('请在文本框输入数量');
		}
		
		let balance=await starcoinContract.balanceOf(currentAccount);
		mySCBalance = balance.toNumber();
      } else {

      }
    } catch(err){
      console.log(err);
    }
	setscBalance(mySCBalance);
	console.log('目前余额 '+ scBalance);
  }

  // Step2. 捕获质押的数量
  const handleChange = evt => {
    // 可以直接捕获value
    try{
	  //setBuyNum(evt.target.value);
    }catch(err){
      console.log(err);
    }
  //console.log(buyNum);//总是返回上一次的值
  }

  // Step3. 提交质押的StarCoin数量到合约
  const depositHandler = async () => {
    try{
		if (ethereum) {
			console.log(isLotteryOpen===true?"已经开局":"结束或未开始");
			let mySelectedNum = document.getElementById('depositor').value;
			
			if(mySelectedNum>0){
				console.log('您选择质押的数量是'+mySelectedNum);
				let enterTransaction=await lotteryContract.enter(mySelectedNum);
				Toast.info('押宝开始......');
			}else{
				Toast.info('请在文本框输入数量');
			}
			
			//console.log(lotteryContract.interface);
			
			lotteryContract.on("StakeStatus", async (_sender, _amountLimit, event) => {
				console.log('_sender:'+_sender);
				console.log('_amountLimit'+_amountLimit);
				// 查看后面的事件触发器  Event Emitter 了解事件对象的属性
				//console.log(event);
				let balance=await starcoinContract.balanceOf(currentAccount);
				mySCBalance = balance.toNumber();				
				setscBalance(mySCBalance);
				Toast.info('押宝成功,余额:'+mySCBalance);
				console.log(await lotteryContract.getPool());
			});
		}
    }catch(err){
      console.log(err.error.message);
	  Toast.info(err.error.message);
    }
  }

  // Step4. 跟lottery合约交互，拿到是否存活的结果，并在前端显示
  const checkSurvivorHandler =  async () => {
	  Toast.info(isLotteryOpen===true?'游戏仍在紧张进行中......':'查询比赛结果.....',);
		lotteryContract.on("AnnounceWinner", (_winner, _id, _amount, event) => {
			console.log('_winner:'+_winner);
			console.log('_id'+_id);
			console.log('_amount'+_amount);
			// 查看后面的事件触发器  Event Emitter 了解事件对象的属性
			console.log(event.blockNumber);
			Toast.info('比赛结束,胜利者:'+_winner+' 斩获奖励:'+_amount);
		});
  }
  


  // --------------------------------------------------------------------------------------------//

  useEffect(() => {
    //checkWalletIsConnected();
	onLoadHandle();
  }, [])

  return (
    <div className='main-app'>
      <h1>Random Survivor</h1>
      <p>
        {currentAccount ? currentAccount : "User: not connected"} 
      </p>
	  	  <div>
	  兑换比例: MATIC : StarCoin = 1 : 1
	  每局每地址最多质押6 StarCoin
	  </div>
      <div>
      </div>
      <div>
        {currentAccount ? starCoinAmount() : ""}
		{currentAccount ? SelectNum() : ""}
      </div>
      <div>
		{currentAccount ? buyStarCoinButton() : ""}
        {currentAccount ? deposit() : connectWalletButton()}
      </div>

      <div>
        {currentAccount ? checkSurvivorButton() : ""}
      </div>
	  <div>
        {isLotteryOpen ? "已开始" : "已结束等待下一局"}
      </div>

	  <div class="box"> </div>
    </div>
  )
}

export default App;