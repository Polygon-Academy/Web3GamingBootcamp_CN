const { ccclass, property } = cc._decorator;

@ccclass
export default class NodeData{

    /*************************************************
     * ******************  通用方法  ******************
     ************************************************/
    public static getCanvasNode(): cc.Node{
        return cc.find("Canvas");
    }

    public static getWeb3Component(): cc.Node{
        return cc.find("Canvas").getComponent("web3");
    }

    public static getGameDataComponent(){
        return cc.find("Canvas").getComponent("GameData");
    }

    public static getGameComponent(){
        return cc.find("Canvas").getComponent("Game");
    }

    public static getMarketGoodsListComponent(){
        return cc.find("Canvas/Content/MarketPanel/MarketGoodsLeftPanel").getComponent("MarketGoodsList");
    }

    public static getMyGoodsListComponent(){
        return cc.find("Canvas/Content/MarketPanel/MyGoodsRightPanel").getComponent("MyGoodsList");
    }

    public static getBuyTipComponent(){
        return cc.find("Canvas/TipNode/BugTip").getComponent("BuyTip");
    }

    public static getSaleTipComponent(){
        return cc.find("Canvas/TipNode/SaleTip").getComponent("SaleTip");
    }

    public static getNoMarketTipComponent(){
        return cc.find("Canvas/TipNode/NoMarketTip").getComponent("TipTools");
    }

    
    public static getMarketTipPanelComponent(){
        return cc.find("Canvas/TipNode/MarketTipPanel").getComponent("MarketTipList");
    }

    public static getLeavePanelComponent(){
        return cc.find("Canvas/TipNode/leavePanel").getComponent("LeavePanel");
    }

    public static getExpandCapcityPanelComponent(){
        return cc.find("Canvas/TipNode/expandCapcityPanel").getComponent("expandCapcityPanel");
    }

    // loading page
    public static getJoinPanelComponent(){
        return cc.find("Canvas/Panel/JoinPanel").getComponent("joinPanel");
    }

    public static getRankPanelComponent(){
        return cc.find("Canvas/Panel/RankPanel").getComponent("RankPanel");
    }

};


