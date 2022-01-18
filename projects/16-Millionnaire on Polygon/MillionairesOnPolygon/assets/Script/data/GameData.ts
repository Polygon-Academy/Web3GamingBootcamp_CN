const { ccclass, property } = cc._decorator;
import { GoodsList,GoodsMarketTips } from "./StaticData";
import NodeData from "./NodeData";
import GoodsItem from "../components/Goods/GoodsItem";

@ccclass
export default class GameData extends cc.Component {
  @property(cc.Node)
  private CashNode: cc.Node = null;

  @property(cc.Node)
  private TotalAssetsNode: cc.Node = null;

  @property(cc.Node)
  private WareNode: cc.Node = null;

  @property(cc.Node)
  private AgeNode: cc.Node = null;

  // 这个数据必须和GoodsList匹配(全局)
  @property([cc.SpriteFrame])
  private GoodsSpriteArr: Array<cc.SpriteFrame> = [];

  private LastGoodsMarketData = {};
  private currentGoodsMarketData = {};

  private currentGoodsList = [];
  private myGoodsList = [];
  private myGoodsTypeNum = 0;

  private myCash = 100000;
  private totalAssets = 100000;
  private WareHouseCapcity = 0;//库存量
  private totoalWareHouseCapcity = 100 //总库存量
  private currentAge = 0;
  private totalAge = 70;
  private maxTotoalWareHouseCapcity = 200;

  private eventObj = {
    maxAssets:0,
    maxAssetsAge:0,
    firstAge:0,
    secondAge:0,
    thirdAge:0,
    forthAge:0,
    currentAge:0,
  }

  initData() {
    console.log("init data")
  }

  start () {
    this.updateGoodsMarketData()
    this.eventObj.maxAssets = this.totalAssets;
  }

  expandCapcityByCash(){
    if(this.totoalWareHouseCapcity>=this.maxTotoalWareHouseCapcity){
      console.log("已达到最大容量！")
      return;
    }
    let cashTmp = Math.floor(this.totalAssets/2)
    if(this.myCash>cashTmp){
      this.myCash = this.myCash - cashTmp;
      this.totalAssets = this.totalAssets - cashTmp;
      this.totoalWareHouseCapcity = this.totoalWareHouseCapcity + 10;
      this.CashNode.getComponent(cc.Label).string = this.FormatNum(this.myCash);
      this.TotalAssetsNode.getComponent(cc.Label).string = this.FormatNum(this.totalAssets);
      this.WareNode.getChildByName("wareNum").getComponent(cc.Label).string = this.WareHouseCapcity + '/' + this.totoalWareHouseCapcity;
      return 1;
    }else{
      console.log("现金不足")
      return 0;
    }
  }

  flagExpand(){
    if(this.totoalWareHouseCapcity>=this.maxTotoalWareHouseCapcity){
      console.log("已达到最大容量！")
      return;
    }
  }

  expandCapcityByMatic(){
    this.totoalWareHouseCapcity = this.totoalWareHouseCapcity + 10;
    this.WareNode.getChildByName("wareNum").getComponent(cc.Label).string = this.WareHouseCapcity + '/' + this.totoalWareHouseCapcity;
  }

  getUserCurrentAssets(){
    return {
      myCash:this.myCash,
      totalAssets:this.totalAssets,
    }
  }

  leavePanelGetData(){
    return {
      eventObj:this.eventObj,
      totalAssets:this.totalAssets,
    }
  }

  updateEvent(assetsNum){
    if(assetsNum>10**9){
      if(this.eventObj.forthAge == 0){
        this.eventObj.forthAge = this.currentAge;
      }
    }
    if(assetsNum>10**8){
      if(this.eventObj.thirdAge == 0){
        this.eventObj.thirdAge = this.currentAge;
      }
    }
    if(assetsNum>10**7){
      if(this.eventObj.secondAge == 0){
        this.eventObj.secondAge = this.currentAge;
      }
    }
    if(assetsNum>10**6){
      if(this.eventObj.firstAge == 0){
        this.eventObj.firstAge = this.currentAge;
      }
    }
    if(this.eventObj.maxAssets<assetsNum){
      this.eventObj.maxAssets = assetsNum;
      this.eventObj.maxAssetsAge = this.currentAge;
    }
    this.eventObj.currentAge = this.currentAge;
    console.log("########eventObj############")
    console.log(this.eventObj)
    console.log("####################")
  }

  resetAllData(){
    this.LastGoodsMarketData = {};
    this.currentGoodsMarketData = {};
    this.currentGoodsList = [];
    this.myGoodsList = [];
    this.myGoodsTypeNum = 0;
    this.WareHouseCapcity = 0;//库存量
    this.myCash = 100000;
    this.totalAssets = 100000;
    this.currentAge = 0;
    this.eventObj = {
      maxAssets:0,
      maxAssetsAge:0,
      firstAge:0,
      secondAge:0,
      thirdAge:0,
      forthAge:0,
      currentAge:0,
    }
  }
  
  getGobalGoodsSpriteArrItem(goodsId){
    if(goodsId>=this.GoodsSpriteArr.length){
      return this.GoodsSpriteArr[0];
    }
    return this.GoodsSpriteArr[goodsId];
  }

  getUserData(){
    return {
      myCash:this.myCash,
      totalAssets:this.totalAssets,
      WareHouseCapcity:this.WareHouseCapcity,
      myGoodsList:this.myGoodsList,
      totoalWareHouseCapcity:this.totoalWareHouseCapcity,
    }
  }

  currentMarketSaleFlag(goodsId){
    for(let i=0;i<this.currentGoodsList.length;i++){
      if(this.currentGoodsList[i].id == goodsId){
        return 1;
      }
    }
    return 0;
  }

  getBuyFlag(goodsId){
    let count = 0;
    let inFlag = 0;
    for(let i=0;i<this.myGoodsList.length;i++){
      if(this.myGoodsList[i].num >0){
        count = count + 1;
      }
      if(this.myGoodsList[i].id == goodsId){
        inFlag = 1;
      }
    }
    if(inFlag==1){
      return 1;
    }else{
      if(count>=5){
        return 0;
      }else{
        return 1;
      }
    }
  }


  refreshMyTotalAssets(){
    let totalGoodsAssets = 0;
    for(let i=0;i<this.myGoodsList.length;i++){
      if(this.myGoodsList[i].num>0){
        let currentPrice = this.currentGoodsMarketData[this.myGoodsList[i].id].price;
        totalGoodsAssets = totalGoodsAssets + currentPrice*this.myGoodsList[i].num;
      }
    }
    this.totalAssets = this.myCash + totalGoodsAssets;
    this.CashNode.getComponent(cc.Label).string = this.FormatNum(this.myCash);
    this.TotalAssetsNode.getComponent(cc.Label).string = this.FormatNum(this.totalAssets);
    if(this.currentAge + 1>=this.totalAge){
      console.log("退休了！")
      NodeData.getGameComponent().leaveGame();
    }else{
      this.currentAge = this.currentAge + 1;
      this.AgeNode.getChildByName("ageNum").getComponent(cc.Label).string = this.currentAge + ''
    }
    // 记录时间
    this.updateEvent(this.totalAssets);
  }

  updateGoodsMarketData(){
    let randomArr = []
    let count = Math.round(Math.random()*3) + 3;
    while(randomArr.length<count){
        let id = Math.round(Math.random()*7)
        if(this.searchItemInGoodsArr(id,randomArr)==0){
            let price = Math.round(Math.random()*15562)
            randomArr.push({
                id:id,
                price:price
            })
        }
    }
    
    this.updateGoodsMarketCurrentData(randomArr)
  }

  updateCurrentMarketTips(data){
    let marketTipArr = []
    for(let i=0;i<data.length;i++){
      let lastPrice = this.LastGoodsMarketData[data[i].id].price;
      if(lastPrice > 0){
        if(lastPrice>data[i].price){
          let lineType = 0;//下跌
          let markertTip = '市场稳定，价格波动不大'
          let rate = (lastPrice-data[i].price)/lastPrice;
          if(rate>0.5){
            markertTip = GoodsMarketTips[data[i].id][3]
          }else{
            markertTip = GoodsMarketTips[data[i].id][2]
          }
          marketTipArr.push({
            id:data[i].id,
            lineType:lineType,
            markertTip:markertTip
          })
        }else {
          let lineType = 1;//上涨
          let markertTip = '市场稳定，价格波动不大'
          let rate = (data[i].price - lastPrice)/lastPrice;
          if(rate>0.5){
            markertTip = GoodsMarketTips[data[i].id][0]
          }else{
            markertTip = GoodsMarketTips[data[i].id][1]
          }
          marketTipArr.push({
            id:data[i].id,
            lineType:lineType,
            markertTip:markertTip
          })
        }
      }
    }
    // 更新marketTipPanel
    NodeData.getMarketTipPanelComponent().updateMarketTipsList(marketTipArr);
  }

  searchItemInGoodsArr(id,arr){
      for(let i=0;i<arr.length;i++){
          if(id == arr[i].id){
              return 1;
          }
      }
      return 0;
  }

  // type==0:出售商品，type==1:购买商品
  updateMyAssets(goodsId, num, type) {
    let priceTmp = this.currentGoodsMarketData[goodsId].price;
    if (type == 0) {
      //出售商品
      let index = this.getItemIndexInGoodsArr(goodsId,this.myGoodsList)
      console.log(index)
      console.log(this.myGoodsList)
      console.log(this.myGoodsList[index])
      let currentNum = this.myGoodsList[index].num;
      if(num<=currentNum){
        this.myGoodsList[index].num = currentNum - num;
        this.myCash = this.myCash + num*priceTmp
        this.WareHouseCapcity = this.WareHouseCapcity - num;
        if(num == currentNum){
          this.myGoodsTypeNum = this.myGoodsTypeNum - 1;
        }
      }
    } else if (type == 1) {
      // 购买商品
      if (this.myCash < priceTmp * num) {
        console.log("钱不够！");
        return;
      } else {
        let cashTmp = this.myCash - priceTmp*num;
        if(cashTmp<0)return
        let WareHouseCapcityTmp = this.WareHouseCapcity + num;
        if(WareHouseCapcityTmp>this.totoalWareHouseCapcity)return
        this.myCash = cashTmp;
        this.WareHouseCapcity = WareHouseCapcityTmp;
        let index = this.getItemIndexInGoodsArr(goodsId,this.myGoodsList)
        if(index>=0){
          let currentItem = this.myGoodsList[index];
          let totalNum = currentItem.num + num;
          let rangePriceTmp = Math.ceil((currentItem.num*currentItem.rangePrice+priceTmp*num)/totalNum)
          this.myGoodsList[index].rangePrice = rangePriceTmp;
          this.myGoodsList[index].num = totalNum;
        }else{
          this.myGoodsTypeNum = this.myGoodsTypeNum + 1;
          this.myGoodsList.push({
            id:goodsId,
            rangePrice:priceTmp,
            num:num
          })
        }
      }
    }
    this.CashNode.getComponent(cc.Label).string = this.myCash+'';
    this.TotalAssetsNode.getComponent(cc.Label).string = this.totalAssets+'';
    this.WareNode.getChildByName("wareNum").getComponent(cc.Label).string = this.WareHouseCapcity + '/' + this.totoalWareHouseCapcity;
    NodeData.getMyGoodsListComponent().updateMyGoodsList(this.myGoodsList)
  }

  getItemIndexInGoodsArr(id,arr){
    for(let i=0;i<arr.length;i++){
        if(id == arr[i].id){
            return i;
        }
    }
    return -1;
  }

  updateGoodsMarketCurrentData(data) {
    if (this.currentGoodsList.length == 0) {
      for (let i in GoodsList) {
        this.LastGoodsMarketData[i] = {
          id: i,
          price: 0,
        };
      }
    } else {
      console.log("updateLastGoodsMarketData.. ");
      this.updateLastGoodsMarketData();
    }
    for (let i = 0; i < data.length; i++) {
      this.currentGoodsMarketData[data[i].id] = {
        id: data[i].id,
        price: data[i].price,
      };
    }
    // console.log(this.currentGoodsList)
    // console.log(data)
    console.log("LastGoodsMarketData:", this.LastGoodsMarketData);
    // console.log("currentGoodsMarketData:",this.currentGoodsMarketData)
    this.currentGoodsList = data;
    this.updateCurrentMarketTips(data);
    NodeData.getMarketGoodsListComponent().updateMarketGoodsList(data)
    // 更新资产总价值
    this.refreshMyTotalAssets()
  }

  updateLastGoodsMarketData() {
    let tmp = this.currentGoodsList;
    for (let i = 0; i < tmp.length; i++) {
      this.LastGoodsMarketData[tmp[i].id] = {
        id: tmp[i].id,
        price: tmp[i].price,
      };
    }
  }

  getLastMarketGoodsPriceById(GoodsId) {
    return this.LastGoodsMarketData[GoodsId].price;
  }

  getCurrentMarketGoodsPriceById(GoodsId) {
    console.log(this.currentGoodsMarketData)
    return this.currentGoodsMarketData[GoodsId].price;
  }

  // 获取Goods之前的市场价格
  getLastMarketGoodsById(GoodsId) {
    return this.LastGoodsMarketData[GoodsId];
  }

  // 获取Goods当前的市场价格
  getCurrentMarketGoodsById(GoodsId) {
    return this.currentGoodsMarketData[GoodsId];
  }

  FormatNum(num){
    num = num +'';
    var str = "";
    for(var i=num.length- 1,j=1;i>=0;i--,j++){  
        if(j%3==0 && i!=0){//每隔三位加逗号，过滤正好在第一个数字的情况  
            str+=num[i]+",";//加千分位逗号  
            continue;  
        }  
        str+=num[i];//倒着累加数字
    }  
    var out = str.split('').reverse().join("");//字符串=>数组=>反转=>字符串
    if(out[0] == ',')
        return out.splice(0,1)
    return out;
}

  // update (dt) {}
}
