import { Button,Image,Modal,Space,Carousel } from 'antd';
import React,{useState,useEffect} from 'react';
import './index.css';


            
import CreateNFTPage from '../../components/CreateNFT/createnft';

import Logo02 from '../../assets/Witness_02.png';
import manimg from '../../assets/Man.png';
import womanimg from '../../assets/Woman.png';

const ReachableContext = React.createContext();
const UnreachableContext = React.createContext();
const config = {
    title: 'Use Hook!',
    content: (
        <>
        </>
    ),
  };
function NFT(){
    const [modal, contextHolder] = Modal.useModal();
    let timee = 0;
    let [index,setIndex]=useState(timee);

    const clickLeftLi=()=>{
        setIndex(0);
    }
    const clickRightLi=()=>{
        setIndex(1);
    }
    const MintNFT=()=>{
        console.log("铸造NFT");
        modal.info({
            title: 'Mint NFT',
            content: (
            <div className='modalbody'>
                <CreateNFTPage r={Math.ceil(Math.random()*255)}
                g={Math.ceil(Math.random()*255)}
                b={Math.ceil(Math.random()*255)}/>
            </div>
            ),
            onOk() {},
            width:900,
            // style:{display:'flex',justifyContent:'center'},
        //     bodyStyle:{display:'flex',justifyContent:'center',
        // alignItems:'center'}
        });
    }

    useEffect(()=>{
        const activetimer = setInterval(()=>{
            if(timee<1){
                timee+=1;
            }else{
                timee=0;
            }
            if(timee==0){
                clickLeftLi();
            }else{
                clickRightLi();
            }
        },3000);
        return ()=>clearInterval(activetimer);
    },[timee]);



    return <div>
      <div className="container">
        <div className="bodyG">
            <div className='title'>
                <h1>Record Your Love By NFT</h1>
            </div>
            <div className='smtitle'>
                <h2>Witness</h2>
            </div>
            <div className='contbody'>
                <span>
                You and your lover could record love through daily card games after connecting your wallet and logging in. We will witness your every step. If you persist for 30 consecutive days, you will have a more than 50% chance to get a couple's head picture, and you will still have a chance to get it every 30 consecutive days.
                </span>
                <div>
                <Image preview={false} className="bodylogo" width={200}
                src={Logo02}
                />
                </div>
            </div>
            <div className='contplaybtn'>
                <div>
                <Button className='playbtn' type='primary'
                onClick={MintNFT}>Play to earn</Button>
                </div>
                <div>
                    <ul className="pagetabs">
                        <li onClick={clickLeftLi} className={index==0?"active":""}></li>
                        <li onClick={clickRightLi} className={index==1?"active":""}></li>
                    </ul>
                </div>
            </div>
            <div className='pagefooterpic'>
                <div className={index==0?"up":"down"}>
                <Image preview={false} className="manswap" width={400}
                src={manimg}
                />
                </div>
                <div className={index==0?"down":"up"}>
                <Image preview={false} className="womanswap" width={400}
                src={womanimg}
                />
                </div>
            </div>
        </div>
        </div>
        {contextHolder}
    </div>;
}
export default NFT;