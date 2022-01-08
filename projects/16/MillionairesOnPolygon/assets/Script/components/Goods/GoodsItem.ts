const { ccclass, property } = cc._decorator;

import NodeData from "./../../data/NodeData";
import {GoodsList} from "./../../data/StaticData";

@ccclass
export default class GoodsItem extends cc.Component {
  @property(cc.Node)
  private GoodsName: cc.Node = null;

  @property(cc.Node)
  private GoodsPrice: cc.Node = null;

  @property(cc.Node)
  private GoodsRate: cc.Node = null;

  @property(cc.Node)
  private GoodsIcon: cc.Node;


  private goodsId;
  private price;

  // private GoodsList = {
  //   0:"游戏账户",
  //   1:"比特币",
  //   2:"大师字画",
  //   3:"明星球鞋",
  //   4:"大蒜",
  //   5:"高级香水",
  //   6:"黄金",
  //   7:"进口奶粉",
  //   8:"名牌包包",
  //   9:"珍贵皮草",
  //   10:"水果手机",
  //   11:"航拍无人机",
  // }

  public set(goodsPrice, goodsId) {
    this.goodsId = goodsId;
    this.GoodsIcon.getComponent(cc.Sprite).spriteFrame = NodeData.getGameDataComponent().getGobalGoodsSpriteArrItem(goodsId);
    this.GoodsName.getComponent(cc.Label).string = GoodsList[goodsId];
    this.GoodsPrice.getComponent(cc.Label).string = goodsPrice;
    this.price = goodsPrice
    let lastPrice = NodeData.getGameDataComponent().getLastMarketGoodsPriceById(goodsId);
    console.log(lastPrice)
    if(lastPrice == 0){
        // 初始化
        this.GoodsRate.getComponent(cc.Label).string = "0.00%"
        this.GoodsRate.color  = cc.color(102,102,102,255);
    }else if(lastPrice<goodsPrice){
        //up
        let rateTmp = ((goodsPrice - lastPrice)*100/lastPrice).toFixed(2)
        this.GoodsRate.getComponent(cc.Label).string = "+" + rateTmp + "%"
        this.GoodsRate.color  = cc.color(207, 48, 74,255);
    }else if(lastPrice>goodsPrice){
        //down
        let rateTmp = ((lastPrice - goodsPrice)*100/lastPrice).toFixed(2)
        this.GoodsRate.getComponent(cc.Label).string = "-" + rateTmp + "%"
        this.GoodsRate.color  = cc.color(3, 166, 109,255);
    }
  }

  OpenToBuyGoods(){
    console.log("i want to buy" + GoodsList[this.goodsId])
    let data = {
      goodsId:this.goodsId,
      price:this.price
    }
    NodeData.getBuyTipComponent().ShowPanel(data)
  }

  // update (dt) {}
}
