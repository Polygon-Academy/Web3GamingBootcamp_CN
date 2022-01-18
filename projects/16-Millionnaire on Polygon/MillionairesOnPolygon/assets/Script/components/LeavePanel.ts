
const {ccclass, property} = cc._decorator;
import NodeData from "./../data/NodeData";

@ccclass
export default class LeavePanel extends cc.Component {

    @property(cc.RichText)
    richTextObj: cc.RichText;

    setRichTextObj(dataArr){
        let userData = NodeData.getGameDataComponent().leavePanelGetData()
        let data = `<color=#FF0033><b><outline color=white width=2>第1年</outline></b></color>`
        + `<color=white><b><outline color=black width=2>获得家族投资初始资金</outline></b></color>`
        + `<color=#FF0033><b><outline color=#FFFF00 width=2>$100,000</outline></b></color><br/>`;
        if(userData.eventObj.firstAge>0){
            data = data + `<color=#FF0033><b><outline color=white width=2>第`+ userData.eventObj.firstAge + `年</outline></b></color>`
            + `<color=white><b><outline color=black width=2>成为百万富翁，总资产突破</outline></b></color>`
            + `<color=#FF0033><b><outline color=#FFFF00 width=2>$1000,000</outline></b></color><br/>`;
            if(userData.eventObj.secondAge>0){
                data = data + `<color=#FF0033><b><outline color=white width=2>第`+ userData.eventObj.secondAge + `年</outline></b></color>`
                + `<color=white><b><outline color=black width=2>成为千万富翁，总资产突破</outline></b></color>`
                + `<color=#FF0033><b><outline color=#FFFF00 width=2>$10,000,000</outline></b></color><br/>`;
                if(userData.eventObj.thirdAge>0){
                    data = data + `<color=#FF0033><b><outline color=white width=2>第`+ userData.eventObj.thirdAge + `年</outline></b></color>`
                    + `<color=white><b><outline color=black width=2>，历经重重困难，终于成为</outline></b></color>`
                    + `<color=#FF0033><b><outline color=#FFFF00 width=2>亿万富翁！</outline></b></color><br/>`;
                    if(userData.eventObj.forthAge>0){
                        data = data + `<color=#FF0033><b><outline color=white width=2>第`+ userData.eventObj.forthAge + `年</outline></b></color>`
                        + `<color=white><b><outline color=black width=2>，开始登陆福布斯富豪排行榜，总资产突破</outline></b></color>`
                        + `<color=#FF0033><b><outline color=#FFFF00 width=2>$1000,000,000</outline></b></color><br/>`;
                    }
                }
            }
        }
        data = data  +  `<color=#FF0033><b><outline color=white width=2>第`+userData.eventObj.currentAge+`年</outline></b></color>`
        + `<color=white><b><outline color=black width=2>成功退休！总资产为</outline></b></color>`
        + `<color=#FF0033><b><outline color=#FFFF00 width=2>$`+this.FormatNum(userData.totalAssets)+`</outline></b></color><br/><br/>`;
        data = data  +  `<color=#FF0033><b><outline color=white width=2>回顾整个人生历程</outline></b></color>`
        + `<color=white><b><outline color=black width=2>创业维艰！在第`+userData.eventObj.maxAssetsAge+`年，总资产达到了巅峰，为</outline></b></color>`
        + `<color=#FF0033><b><outline color=#FFFF00 width=2>$`+this.FormatNum(userData.eventObj.maxAssets)+`</outline></b></color><br/>`;
        this.richTextObj.string = data;
        this.OpenPanel()
    }


    FormatNum(num){
        num = num +'';
        var str = "";
        for(var i=num.length- 1,j=1;i>=0;i--,j++){  
            if(j%3==0 && i!=0){//每隔三位加逗号，过滤正好在第一个数字的情况  
                str+=num[i]+",";//加千分位逗号  
                continue;  
            }  
            str+=num[i];//倒着累加数字
        }  
        var out = str.split('').reverse().join("");//字符串=>数组=>反转=>字符串
        if(out[0] == ',')
            return out.splice(0,1)
        return out;
    }

    OpenPanel(){
        this.node.active = true;
    }

    ClosePanel(){
        this.node.active = false;
        cc.director.loadScene('loading');
    }

    // update (dt) {}
}
