
const {ccclass, property} = cc._decorator;

@ccclass
export default class TipTools extends cc.Component {

    CloseTip(){
        this.node.active = false;
    }

    OpenTip(){
        this.node.active = true;
    }

    // update (dt) {}
}
