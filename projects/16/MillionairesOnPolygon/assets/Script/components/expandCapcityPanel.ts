
const {ccclass, property} = cc._decorator;
import NodeData from "./../data/NodeData";

@ccclass
export default class expandCapcityPanel extends cc.Component {

    @property(cc.Node)
    private buyByCash: cc.Node;

    @property(cc.Node)
    private buyByMatic: cc.Node;


    buyByMaticBtn(){
        
    }

    buyByCashBtn(){
        let flag = NodeData.getGameDataComponent().expandCapcityByCash();
        if(flag==1){
            this.ClosePanel()
        }
    }

    openPanel(){
        this.node.active = true;
    }

    ClosePanel(){
        this.node.active = false;
    }

    // update (dt) {}
}
