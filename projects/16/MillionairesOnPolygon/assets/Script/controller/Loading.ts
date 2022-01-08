import NodeData from "./../data/NodeData";
const {ccclass, property} = cc._decorator;

@ccclass
export default class Loading extends cc.Component {

    @property(cc.Node)
    private connectBtn: cc.Node;

    @property(cc.Node)
    private rankBtn: cc.Node;

    @property(cc.Node)
    private startBtn: cc.Node;

    connectMetaMask(){

    }

    async connectWallet(){
        await this.node.getComponent("web3").InitWeb3();
    }

    showStart(){
        this.connectBtn.active = false;
        this.rankBtn.active = true;
        this.startBtn.active = true;
    }


    goToGame(){
        NodeData.getGameDataComponent().resetAllData()
        cc.director.loadScene('game');
    }

    openJoinPanel(){
        NodeData.getJoinPanelComponent().OpenPanel();
    }

    startGame(){
        this.node.getComponent("web3").StartGame();
    }

}
