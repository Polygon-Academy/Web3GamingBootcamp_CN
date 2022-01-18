
const {ccclass, property} = cc._decorator;
import NodeData from "./../data/NodeData";

@ccclass
export default class RankPanel extends cc.Component {

    @property(cc.Label)
    private address: cc.Label;

    @property(cc.Label)
    private block: cc.Label;

    @property(cc.Label)
    private grade: cc.Label;

    OpenPanel(data){
        this.address.string = data.address;
        this.block.string = data.block;
        this.grade.string = data.grade;
        this.node.active = true;
    }

    ClosePanel(){
        this.node.active = false;
    }

    joinGame(){
        console.log("加入游戏")
    }

    // update (dt) {}
}
