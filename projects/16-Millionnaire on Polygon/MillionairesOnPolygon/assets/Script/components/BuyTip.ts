
const {ccclass, property} = cc._decorator;
import NodeData from "./../data/NodeData";
import {GoodsList} from "./../data/StaticData";

@ccclass
export default class BuyTip extends cc.Component {

    @property(cc.Slider)
    private Slider: cc.Slider;

    @property(cc.ProgressBar)
    private Progress: cc.ProgressBar;

    @property(cc.Label)
    private BuyNumLbl: cc.Label;

    @property(cc.EditBox)
    private InPutBox: cc.EditBox;

    @property(cc.Label)
    private DesLbl: cc.Label;

    @property(cc.Node)
    private GoodsName: cc.Node = null;
  
    @property(cc.Node)
    private GoodsIcon: cc.Node;

    @property(cc.Node)
    private cost: cc.Node;

    @property(cc.Node)
    private tip: cc.Node;


    private BuyNum = 0;
    private CanBuyNum = 0;

    private Data;

    onLoad(){
        let data = {
            price:10,
            goodsId:1,
        }
        this.ShowPanel(data)
    }

    // data = {price:10,goodsId:0}
    ShowPanel (data) {
        this.node.active = true;
        this.cost.active = true;
        this.tip.active = false;
        this.Data = null;
        let userData = NodeData.getGameDataComponent().getUserData()
        this.CanBuyNum = Math.floor( userData.myCash / data.price);
        if(this.CanBuyNum > userData.totoalWareHouseCapcity-userData.WareHouseCapcity)
        {
            this.CanBuyNum = userData.totoalWareHouseCapcity-userData.WareHouseCapcity;
        }

        this.GoodsIcon.getComponent(cc.Sprite).spriteFrame = NodeData.getGameDataComponent().getGobalGoodsSpriteArrItem(data.goodsId);
        this.BuyNum = this.CanBuyNum;
        this.GoodsName.getComponent(cc.Label).string = GoodsList[data.goodsId];
        this.BuyNumLbl.string = this.CanBuyNum+'';
        this.InPutBox.string = this.CanBuyNum+'';
        this.DesLbl.string = this.FormatNum(this.CanBuyNum * data.price); 
        this.Slider.progress = 1;
        this.Progress.progress = 1;
        this.Data = data;
    }

    OnSliderChange(){
        this.BuyNum = Math.floor(this.Slider.progress * this.CanBuyNum);
        this.Progress.progress = this.Slider.progress;
        ////cc.log("+++++++++++++++++++++" + this.price);
        this.BuyNumLbl.string = this.BuyNum +'';
        this.InPutBox.string = this.BuyNum + '';
        this.DesLbl.string = this.FormatNum(this.BuyNum * this.Data.price);
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


    OnInputBoxEnd(){
    	if(this.InPutBox.string != "")
    	{
    		if(Number(this.InPutBox.string) != null)
    		{
    			if(Number(this.InPutBox.string) > this.CanBuyNum) 
    			{
    				this.InPutBox.string = this.CanBuyNum+'';
    				this.BuyNum = this.CanBuyNum;
    				this.Progress.progress = 1;
    				this.Slider.progress = 1;
    			}
    			else
    			{
    				this.BuyNum = Number(this.InPutBox.string);
    				this.Slider.progress =  this.BuyNum / this.CanBuyNum;
    				this.Progress.progress = this.Slider.progress;
    			}
    		}
    	}
    	else
    	{
    		this.InPutBox.string = "0";
			this.BuyNum = 0;
			this.Progress.progress = 0;
			this.Slider.progress = 0;
    	}
    	this.DesLbl.string = this.FormatNum(this.BuyNum * this.Data.price);
    }

    BuyGoods(){
        if(this.BuyNum <= 0)
        {
            return;
        }
        let userData = NodeData.getGameDataComponent().getUserData()
        let myGoodsTypeNum = NodeData.getGameDataComponent().getBuyFlag(this.Data.goodsId)
        //判断是否已经买了5种商品
        if(myGoodsTypeNum == 0)
        {
            this.cost.active = false;
            this.tip.getChildByName("tipText").getComponent(cc.Label).string = "最多只能购买5种商品哦！"
            this.tip.active = true;
            return;
        }
        
        if(userData.totoalWareHouseCapcity < this.BuyNum+userData.WareHouseCapcity)
        {
            this.cost.active = false;
            this.tip.getChildByName("tipText").getComponent(cc.Label).string = "仓库容量不足！"
            this.tip.active = true;
            return ;
        }
        // cc.Mgr.UserDataMgr.WareHouseCapcity -= this.BuyNum;

        NodeData.getGameDataComponent().updateMyAssets(this.Data.goodsId, this.BuyNum, 1)
        // let data = {
        //     goodsId:this.Data.goodsId,
        //     num:this.BuyNum
        //   }
        // NodeData.getGameDataComponent().updateUserBuyData(data)

        this.ClosePanel();
    }

    
    ClosePanel(){
        this.node.active = false;
    }

    // update (dt) {}
}
