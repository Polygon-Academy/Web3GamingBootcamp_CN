const { ccclass, property } = cc._decorator;

import NodeData from "./../../data/NodeData";

@ccclass
export default class MarketTipList extends cc.Component {
    @property(cc.Node)
    private content: cc.Node = null;

    @property(cc.Node)
    private marketText: cc.Node = null;
  
    @property(cc.Prefab)
    private itemPrefab: cc.Prefab = null;
  
    openNode(){
        this.node.active = true;
    }

    closeNode(){
        this.node.active = false;
    }

    public updateMarketTipsList(data) {
      if(data.length==0){
        this.marketText.active = true;
        return
      }else{
        this.marketText.active = false;
      }
      let count = Math.max(data.length, this.content.childrenCount);
      for (let i = 0; i < count; i++) {
        if (data[i] && this.content.children[i]) {
          // 已存在节点，更新并展示
          this.content.children[i].active = true;
          this.content.children[i].getComponent("MarketTipItem").set(data[i].id, data[i].markertTip, data[i].lineType);
        } else if (data[i] && !this.content.children[i]) {
          // 节点不足，再实例化一个，更新信息
          let node = cc.instantiate(this.itemPrefab);
          node.setParent(this.content);
          node.getComponent("MarketTipItem").set(data[i].id, data[i].markertTip, data[i].lineType);
        } else {
          // 节点多了，关掉吧
          this.content.children[i].active = false;
        }
      }
      this.openNode();
    }

  // update (dt) {}
}
