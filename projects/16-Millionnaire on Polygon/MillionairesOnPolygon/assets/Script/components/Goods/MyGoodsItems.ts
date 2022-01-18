const { ccclass, property } = cc._decorator;

import NodeData from "./../../data/NodeData";
import {GoodsList} from "./../../data/StaticData";

@ccclass
export default class MyGoodsItem extends cc.Component {
  @property(cc.Node)
  private GoodsName: cc.Node = null;

  @property(cc.Node)
  private GoodsPrice: cc.Node = null;

  @property(cc.Node)
  private GoodsNum: cc.Node = null;

  @property(cc.Node)
  private GoodsIcon: cc.Node;

  private goodsId;
  private totalNum = 0;
  private rangePrice = 0;
  private goodsName = "";

  public set(goodsPrice, goodsId, num) {
    this.goodsId = goodsId;
    this.GoodsIcon.getComponent(cc.Sprite).spriteFrame = NodeData.getGameDataComponent().getGobalGoodsSpriteArrItem(goodsId);
    this.GoodsName.getComponent(cc.Label).string = GoodsList[goodsId];
    this.GoodsPrice.getComponent(cc.Label).string = goodsPrice;
    this.GoodsNum.getComponent(cc.Label).string = num;
    this.totalNum = num;
    this.rangePrice = goodsPrice;
    this.goodsName = GoodsList[goodsId];

  }

  OpenToSaleGoods(){
    console.log("i want to sale" + GoodsList[this.goodsId])
    let data = {
      goodsId:this.goodsId,
      totalNum:this.totalNum,
      rangePrice:this.rangePrice,
      name:this.goodsName,
    }
    let marketSaleFlag = NodeData.getGameDataComponent().currentMarketSaleFlag(this.goodsId);
    if(marketSaleFlag == 1){
      NodeData.getSaleTipComponent().ShowPanel(data)
    }else if(marketSaleFlag==0){
      // 没有市场，弹出提示
      NodeData.getNoMarketTipComponent().OpenTip()
    }
  }

  // update (dt) {}
}
