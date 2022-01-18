# FiveSins
FiveSins is a Web3 Game

## ![image.png](https://cdn.nlark.com/yuque/0/2022/png/412186/1641655360859-7a7f169b-4932-44d4-beca-6d4d43a88274.png#clientId=u42df8fc7-f3b9-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=639&id=ub45f92b3&margin=%5Bobject%20Object%5D&name=image.png&originHeight=1278&originWidth=2304&originalType=binary&ratio=1&rotation=0&showTitle=false&size=2182819&status=done&style=none&taskId=u1aaec929-627a-4379-bde1-470f6ebe1ab&title=&width=1152)
## 团队

- Ziqiang Huang：合约开发
- Wenhao Deng：游戏开发、前端
- Rui Shang：交互和体验、世界观设计
- Xin Ma：产品和经济模型设计


## 项目介绍
**掉落合成的PVP链游**

- FiveSins 是一个收集卡牌参与对决的 PVP 游戏。玩家通过收集 NFT 卡牌，参与对局时自动分为两方阵营，卡牌掉落合成
- 秉持 Play to earn 的原则，每一次对局的胜利方会获得收益，若成功合成人类，则会获取超额收益
- 基于元素升级合成人类的世界观，项目希望借此引发人们对人性底层的思考

* github：[https://github.com/ahaclub/FiveSins](https://github.com/ahaclub/FiveSins)
* youtube：[https://youtu.be/peDjeXcbGMg](https://youtu.be/peDjeXcbGMg)



## 世界观
**五宗罪，构成了人类**

- 愤怒、贪婪…… 从小恶到大恶，最终会合成人类
- 玩家可以购买NFT，满足要求即可作为一方阵营出战，每两个小罪，若碰撞到一起，会合成更大的罪，经过4次合成升级，最终会合成人类，则游戏结束
- 玩家在游戏中除了促使本方合成，也可以通过控制掉落位置，去干扰、阻止对方合成，这本身也是一种人性

​

## 玩法介绍
**从小罪合成大罪，最终合成人类**

- 玩家从交易市场购买 30 个NFT（且罪 1 数量大于 20），则获得对局资格
- 匹配对手，随机分配红、绿两方阵营，其NFT也自动变为该颜色
- 红、绿两方轮流掉落NFT，玩家可控制掉落的初始位置，掉落后按照物理定律落到相应位置，若碰撞到相同的罪（且同色），则会合成下一阶的罪
- 先合成人类的一方获得胜利；若 30 张牌掉落完后仍未合成人类，则积分多者获胜

​

## 产品介绍
![image.png](https://cdn.nlark.com/yuque/0/2022/png/412186/1641655878349-6c843142-379d-4611-b545-1f3d29387f47.png#clientId=u42df8fc7-f3b9-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=832&id=u5f368a9b&margin=%5Bobject%20Object%5D&name=image.png&originHeight=1664&originWidth=2518&originalType=binary&ratio=1&rotation=0&showTitle=false&size=263952&status=done&style=none&taskId=uc48923ee-a3ef-401b-bb58-25cfd8b3906&title=&width=1259)


## 经济模型
### NFT价格

- 罪 1、罪 2，每个 NFT 供应数量为 2000 个，编号为 1-2000
- 罪 1 价格：2 SIN
- 罪 2 价格：5 SIN

​

### 游戏结算1
**游戏结算1: 一方合成了人类，获得150 SIN**

- 胜者：收益 150，成本区间为（60，90），净收益区间为（60，90）
- 败者：收益为 0，成本区间为（60，90），净收益区间为（-90，-60）
- 每局结束对代币池的影响为（-30，30）

​

### 游戏结算 2
**游戏结算 2: 均未合成人类，积分多者胜利**

- 胜者利益最大情况：
   - 最高分：最富组合，用完所有牌，但没有合成人类，则结果为 5 个罪 4 = 150分
   - 最低分：最穷组合，用完所有牌，没有任何合成，则结果为 30 个罪 1 = 30 分
   - 胜者/（胜者+败者）= 150/180 = 83%，胜者收益为 83% * 150 = 125 SIN
   - 成本区间（60，90），净收益区间为（35，65）
- 胜者利益最小情况：
   - 1/2 = 50%，胜者收益为 50% *150 = 75 SIN
   - 成本区间（60，90），净收益区间为（-15，15）
- 败者：收益为0，成本区间为（60，90），净收益区间为（-90，-60）
- 未合成人类，胜者净收益区间为（-15，65），败者亏损净收益区间为（-90，-60）
- 每局结束对代币池的影响为（-105，5）
