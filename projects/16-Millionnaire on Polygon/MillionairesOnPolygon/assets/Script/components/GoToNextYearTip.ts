
const {ccclass, property} = cc._decorator;
import NodeData from "./../data/NodeData";

@ccclass
export default class GoToNextYearTip extends cc.Component {

    @property(cc.Node)
    private NextYearTip: cc.Node;

    @property(cc.Node)
    private clockNode: cc.Node;

    // 再次确认
    comfirm(){
        this.node.active = false;
        this.clockNode.active = true;
        this.clockNode.getComponent("TimePanel").PlayAnima();
    }

    // 弹出comfirm页面
    OpenGoToNextYearTip(){
        this.NextYearTip.active = true;
    }

    ClosePanel(){
        this.node.active = false;
    }

    // update (dt) {}
}
