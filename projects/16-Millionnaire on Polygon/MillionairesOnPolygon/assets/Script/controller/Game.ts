
const {ccclass, property} = cc._decorator;

import NodeData from "./../data/NodeData";

@ccclass
export default class Game extends cc.Component {

    getNextYaerMarketData(){
        NodeData.getGameDataComponent().updateGoodsMarketData()
    }

    // 打开市场行情页面
    openMarketTipListPanel(){
        NodeData.getMarketTipPanelComponent().openNode();
    }

    leaveGame(){
        console.log("leave game!")
        // 重置数据
        let dataArr = []
        NodeData.getLeavePanelComponent().setRichTextObj(dataArr)
        // NodeData.getGameDataComponent().resetAllData()
        
    }

    openExpandPanel(){
        NodeData.getExpandCapcityPanelComponent().openPanel();
    }

    returnToLoading(){
        let grade =  NodeData.getGameDataComponent().getUserCurrentAssets()
        this.node.getComponent("web3").postGrade(grade.totalAssets);
    }

    expandByMatic(){
        NodeData.getGameDataComponent().flagExpand();
        this.node.getComponent("web3").ExpandCap();
    }
    // update (dt) {}
}
