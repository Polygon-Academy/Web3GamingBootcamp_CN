
const {ccclass, property} = cc._decorator;
import NodeData from "./../data/NodeData";

@ccclass
export default class ClockTip extends cc.Component {

    @property(cc.Animation)
    private ClockAnima: cc.Animation;

    PlayAnima(){
        this.ClockAnima.play("clock");
    }

    ClockEnd(){
        this.node.active = false;
        console.log("clock end....")
        NodeData.getGameDataComponent().updateGoodsMarketData();
        // cc.director.GlobalEvent.emit(cc.Mgr.Event.ClockEnd, {});
        //cc.log("闹钟结束======================================");
    },
}
