
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
    private SaleNumLbl: cc.Label;

    @property(cc.EditBox)
    private InPutBox: cc.EditBox;

    @property(cc.Node)
    private GoodsName: cc.Node = null;
  
    @property(cc.Node)
    private GoodsIcon: cc.Node;

    @property(cc.Node)
    private profit: cc.Node;

    @property(cc.Node)
    private income: cc.Node;


    private Data;
    private saleNum = 0;

    // start(){
    //     let data = {
    //         goodsId:3,
    //         totalNum:12,
    //         rangePrice:155,
    //         name:"dsdsd",
    //       }
    //     this.ShowPanel(data)
    // }

    // data = {price:10,goodsId:0}
    ShowPanel (data) {
        this.node.active = true;
        this.Data = null;
        let userData = NodeData.getGameDataComponent().getUserData()

        let currentPirce = NodeData.getGameDataComponent().getCurrentMarketGoodsPriceById(data.goodsId);

        this.GoodsIcon.getComponent(cc.Sprite).spriteFrame = NodeData.getGameDataComponent().getGobalGoodsSpriteArrItem(data.goodsId);
        this.GoodsName.getComponent(cc.Label).string = GoodsList[data.goodsId];
        if(data.rangePrice>currentPirce&&data.totalNum>0){
            this.profit.getComponent(cc.Label).string = '-' + this.FormatNum((data.rangePrice - currentPirce)*data.totalNum);
            this.profit.color  = cc.color(3, 166, 109,255);
        }else if(data.rangePrice<currentPirce&&data.totalNum>0){
            this.profit.getComponent(cc.Label).string = '+' + this.FormatNum((currentPirce - data.rangePrice)*data.totalNum);
            this.profit.color  = cc.color(207, 48, 74,255);
        }else{
            this.profit.getComponent(cc.Label).string = '0';
        }
        this.income.getComponent(cc.Label).string = this.FormatNum(currentPirce*data.totalNum);

        this.InPutBox.string = data.totalNum+'';
        this.saleNum = data.totalNum;
        // this.DesLbl.string = this.FormatNum(this.CanBuyNum * data.price); 
        this.Slider.progress = 1;
        this.Progress.progress = 1;
        this.Data = data;
    }

    OnSliderChange(){
        let totalSale = Math.floor(this.Slider.progress * this.Data.totalNum);
        this.Progress.progress = this.Slider.progress;
        ////cc.log("+++++++++++++++++++++" + this.price);
        this.SaleNumLbl.string = totalSale +'';
        this.InPutBox.string = totalSale + '';
        // this.DesLbl.string = this.FormatNum(this.BuyNum * this.Data.price);

        let currentPirce = NodeData.getGameDataComponent().getCurrentMarketGoodsPriceById(this.Data.goodsId);
        if(this.Data.rangePrice>currentPirce&&this.Data.totalNum>0){
            this.profit.getComponent(cc.Label).string = '-' + this.FormatNum((this.Data.rangePrice - currentPirce)*totalSale);
            this.profit.color  = cc.color(3, 166, 109,255);
        }else if(this.Data.rangePrice<currentPirce&&this.Data.totalNum>0){
            this.profit.getComponent(cc.Label).string = '+' + this.FormatNum((currentPirce - this.Data.rangePrice)*totalSale);
            this.profit.color  = cc.color(207, 48, 74,255);
        }else{
            this.profit.getComponent(cc.Label).string = '0';
        }
        this.income.getComponent(cc.Label).string = this.FormatNum(currentPirce*totalSale);
        this.saleNum = totalSale;
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
    			if(Number(this.InPutBox.string) > this.Data.totalNum) 
    			{
    				this.InPutBox.string = this.Data.totalNum+'';
    				this.saleNum = this.Data.totalNum;
    				this.Progress.progress = 1;
    				this.Slider.progress = 1;
    			}
    			else
    			{
                    this.saleNum = Number(this.InPutBox.string);
    				this.Slider.progress =  this.saleNum / this.Data.totalNum;
    				this.Progress.progress = this.Slider.progress;
    			}
    		}
    	}
    	else
    	{
    		this.InPutBox.string = "0";
			this.saleNum = 0;
			this.Progress.progress = 0;
			this.Slider.progress = 0;
    	}
    	let currentPirce = NodeData.getGameDataComponent().getCurrentMarketGoodsPriceById(this.Data.goodsId);
        if(this.Data.rangePrice>currentPirce&&this.Data.totalNum>0){
            this.profit.getComponent(cc.Label).string = '-' + this.FormatNum((this.Data.rangePrice - currentPirce)*this.saleNum);
            this.profit.color  = cc.color(3, 166, 109,255);
        }else if(this.Data.rangePrice<currentPirce&&this.Data.totalNum>0){
            this.profit.getComponent(cc.Label).string = '+' + this.FormatNum((currentPirce - this.Data.rangePrice)*this.saleNum);
            this.profit.color  = cc.color(207, 48, 74,255);
        }else{
            this.profit.getComponent(cc.Label).string = '0';
        }
        this.income.getComponent(cc.Label).string = this.FormatNum(currentPirce*this.saleNum);
    }

    SaleGoods(){
        if(this.saleNum <= 0)
        {
            return;
        }
        NodeData.getGameDataComponent().updateMyAssets(this.Data.goodsId, this.saleNum, 0)

        this.ClosePanel();
    }

    
    ClosePanel(){
        this.node.active = false;
    }

    // update (dt) {}
}
