import React, {useEffect, useRef, useState } from 'react';
import './index.css';

import Man from '../../assets/Man.png';
import Man1 from '../../assets/Man1.png';
import Man2 from '../../assets/Man2.png';
import Man3 from '../../assets/Man3.png';

import WoMan from '../../assets/Woman.png';
import WoMan1 from '../../assets/Woman1.png';
import WoMan2 from '../../assets/Woman2.png';
import WoMan3 from '../../assets/Woman3.png';

let ref = React.createRef();    
let changedata = [];
let wholedata = [];
let subokdata = [];

let r,g,b = 0;
function CreateNFT(props){
    const [imgdata,setData] = useState([]);
    const [alldata,setAlldata] = useState([]);
    const [subdata,setSubdata] = useState([]);


    useEffect(()=>{
        r=props.r;//Math.ceil(Math.random()*255);
        g=props.g;//Math.ceil(Math.random()*255);
        b=props.b;//Math.ceil(Math.random()*255);
        
        console.log(r,g,b);
    },[r,g,b]);

    useEffect(()=>{
        async function fetchdata (){
            let {current} = ref;
            let ctx=null;
            if(current){
                ctx=current.getContext("2d");
                const w=200;
                const h=200;
                return new Promise((resolve)=>{
                    var imgman1=new Image();
                    imgman1.src=Man3;
                    ctx.drawImage(imgman1,200,0,w,h);
                    let imagedata=[];
                    imagedata = ctx.getImageData(200,0,w,h);

                    resolve(imagedata.data);
                    changedata=imagedata.data;
                    setData(imagedata.data);
                });
            }
        }

        fetchdata().then((data)=>{
        })
    },[]);

    useEffect(()=>{
        async function fetchdata (){
            let {current} = ref;
            let ctx=null;
            if(current){
                ctx=current.getContext("2d");
                const w=200;
                const h=200;
                return new Promise((resolve)=>{
                    //底层
                    var imgman=new Image();
                    imgman.src=Man;
                    ctx.drawImage(imgman,0,0,w,h);
                    let allbottomdata=[];
                    allbottomdata = ctx.getImageData(0,0,w,h);
                    resolve(allbottomdata.data);
                    wholedata=allbottomdata.data;
                    setAlldata(allbottomdata.data);
                });
            }
        }

        fetchdata().then((bottomdata)=>{
        })
    },[]);

    useEffect(()=>{
        if(changedata!=undefined && wholedata!=undefined)
        {
            const changdata = normalize(changedata,200,200);
            const bottomdatanormal = normalize(wholedata,200,200);
            const data = peeling(changdata,bottomdatanormal,200,200);
            subokdata=data;
            let {current} = ref;
            let ctx=null;
            if(current){
                ctx=current.getContext("2d");
                const w=200;
                const h=200;
                if(subokdata!=null){
                    console.log("change");
                    const matrix_obj = ctx.createImageData(w,h);
                    matrix_obj.data.set(subokdata);
                    ctx.putImageData(matrix_obj,400,0);
                }
            }
        }
    },[imgdata,alldata]);

    //转换成数组
    const normalize = (data,width,height)=>{
        const list = [];
        const result = [];
        const len = Math.ceil(data.length/4);
        for(let i=0;i<len;i++){
            const start = i*4;
            list.push([data[start],data[start+1],data[start+2],data[start+3]]);
        }

        for(let hh=0;hh<height;hh++){
            const tmp=[];
            for(let ww=0;ww<width;ww++){
                tmp.push(list[hh*width+ww]);
            }
            result.push(tmp);
        }
        return result;
    }

    //换肤
    const peeling =(data,bottomdata,width,height)=>{
        //data = normalize(data,width,height);

        //换颜色
        for(let i=0;i<data.length;i++){
            for(let j=0;j<data[i].length;j++){
                //排除透明度
                if(data[i][j][3]!=0)
                {
                    data[i][j]=[(data[i][j][0]+r-255),(data[i][j][1]+g-255),(data[i][j][2]+b-255),data[i][j][3]];
                }else{
                    data[i][j]=bottomdata[i][j];
                }
            }
        }
        
        return restoreData(data);//转回一维数组
    }

    const restoreData=(data)=>{
        const result = [];
        for(let i=0;i<data.length;i++){
            for(let j=0;j<data[i].length;j++){
                result.push(data[i][j][0],data[i][j][1],data[i][j][2],data[i][j][3]);
            }
        }
        setSubdata(result);
        return result;
    }
    return <div className='ncontainer'>
        <div className='canvasbody'>
            <div className='mangroup'>
                <img id="man" alt='' src={Man} width={50} height={50}></img>
                <img id="man1" alt='' src={Man1} width={50} height={50}></img>
                <img id="man2" alt='' src={Man2} width={50} height={50}></img>
                <img id="man3" alt='' src={Man3} width={50} height={50}></img>
            </div>
            {/* <div className='mangroup'>
                <img id="woman" alt='' src={WoMan} width={200} height={200}></img>
                <img id="woman1" alt='' src={WoMan1} width={200} height={200}></img>
                <img id="woman2" alt='' src={WoMan2} width={200} height={200}></img>
                <img id="woman3" alt='' src={WoMan3} width={200} height={200}></img>
            </div> */}
            <div className='drawImage'>
                <canvas style={{border:'1px solid #000'}}
                ref={ref} id="myCanvas" width={600} height={200}>
                </canvas>
            </div>
        </div>
    </div>
}

export default CreateNFT;