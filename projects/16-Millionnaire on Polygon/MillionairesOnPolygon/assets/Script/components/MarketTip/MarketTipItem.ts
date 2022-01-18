const { ccclass, property } = cc._decorator;

import NodeData from "./../../data/NodeData";


@ccclass
export default class MarketTipItem extends cc.Component {

  @property(cc.Node)
  private lineNode: cc.Node = null;

  @property(cc.Node)
  private markertTipText: cc.Node = null;

  @property(cc.Node)
  private GoodsIcon: cc.Node;

  @property([cc.SpriteFrame])
  private LineSpriteArr: Array<cc.SpriteFrame> = [];


  //lineType==0:green line;  lineType==1:red line
  public set(goodsId, markertTip, lineType) {
    this.GoodsIcon.getComponent(cc.Sprite).spriteFrame = NodeData.getGameDataComponent().getGobalGoodsSpriteArrItem(goodsId);
    this.lineNode.getComponent(cc.Sprite).spriteFrame = this.LineSpriteArr[lineType];
    this.markertTipText.getComponent(cc.Label).string = markertTip;
  }

  // update (dt) {}
}
