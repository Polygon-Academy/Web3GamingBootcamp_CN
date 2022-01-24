# TaiShang World Generator

> **白皮书作者:** leeduckgo, msfew, fengfeng

## 0x01 极速简介 ⚡️Introduction

目前市面上的随机地图生成均是在线下进行地图的随机生成，然后上传地图内对象坐标到区块链上。由于不具备唯一确定性，这样生成的世界是不 Web3 的，用户无法自行生成一个与 Sandbox 一样的世界，世界的所有权依然掌控在 Sandbox 手里。
本项目决定从这一点出发，将区块链视为「可验证的自生长的分布式数据源」，直接通过链上无法篡改的数据（如区块数据、哈希数据）作为种子，进行抽象地图的生成。一方面，抽象地图可以进一步被玩家 Mint 成 NFT，衍生出更多玩法；另一方面，各游戏项目方可以将抽象地图渲染（诠释）为具体游戏地图，直接用在其游戏里。

![img](https://tva1.sinaimg.cn/large/008i3skNgy1gy6o5maasaj31hc0p2gq4.jpg)

**本项目创新点：**

- 看待区块链系统的全新角度 —— **可验证的自生长的分布式数据源；**
- **抽象 NFT 的实践**：NFT 只包括指向渲染器的链接；
- **冷媒介 NFT 的实践**：链上数据负责二维矩阵地图的生成，用户负责讲「地图的故事」；
- **Arweave + 传统链的实践：** 传统链负责数据的存储，Arweave 负责无状态代码（如转换规则）的存储与资源的存储。

## 0x02 背景说明 Background

区块链系统是多种复杂技术的综合产物。因此，可以从许多不同的有趣视角来看待这个系统：

- 一个节点无限增加而性能不下降的分布式共识系统
- [一种高斯计时器](https://mp.weixin.qq.com/s/REZs6PqlY4WdUJXuBVMnbw)
- 一种Web3系统
- ……

然而，本项目试图从一个全新的角度出发，将区块链视为**一个可验证的自生长的分布式数据源**。

这种数据源具备如下特点：

- **自生长**

数据以固定的频率自生长，因此，在确定性的规则下，地区、宝物、怪物等等一系列来自于元数据的对象也在自生长！

- **分布式**

元数据来自于区块链，所以无需担心元数据的丢失问题与篡改问题。

- **可验证**

因为都是链上数据「元数据」和「转化规则」都是「可验证」的 。

- **免费**

区块链的数据读取是免费的，因此相当于我们拥有的是免费的数据源！

##  0x03 项目说明 Project Details

### 3.1 玩家视角下的项目操作

- 点击`Generate` ，根据链上数据生成地图。

![generate_map](https://tva1.sinaimg.cn/large/008i3skNgy1gy7p0dddidg31360kydwl.gif)

- 主角可以行走，可以和NPC对话，可以开宝箱

![walks](https://tva1.sinaimg.cn/large/008i3skNgy1gy7p1ibtz2g31360kykdo.gif)

- 可以通过`Mint`按钮将该区块的地图mint为`mapNFT`：

![mint](https://tva1.sinaimg.cn/large/008i3skNgy1gy7p39y15ug31360kyx6p.gif)

- 可以在首页查看已经被mint出来的地图

![view_token](https://tva1.sinaimg.cn/large/008i3skNgy1gy7p44j5y0g31360kyb29.gif)

### 3.2 链上数据源 -> 游戏地图全流程

![img](https://tva1.sinaimg.cn/large/008i3skNgy1gy6o5sj1jmj30u01es787.jpg)

<center>链上数据源到游戏地图全流程</center>

#### 3.1.1 链上步骤

**Step 0x01 拿到链上数据**

> [ 基于区块高度的 or 基于合约的 or 基于用户的 ] x [区块数据, 交易数据]

**Step 0x02 通过链上规则对链上 Raw Data 进行转换**

链上规则是写在 Arweave 链上的代码片段，可以动态加载到 tai-shang-nft-generator 项目中来。

一个链上规则模块的例子：

```elixir
defmodule TaiShangWorldGenerator.Rule.RuleA do
  alias TaiShangWorldGenerator.MapTranslator.Behaviour, as: MapTranslatorBehaviour
  @map_type ["sand", "green", "ice"]   # 地图风格
  @ele_description %{
    walkable: [0],
    unwalkable: [1],
    object: [31, 40],
    sprite: [41, 55],
  } 
  # 不同类元素的区间情况，可以将元素分为四大类：可行走的/不可行走的/物品/NPC
  # 例如: sprite: [41, 55] 表示的是，41-55 这个范围里的元素都是 NPC 
  @behaviour MapTranslatorBehaviour 
  # 模块约束: Rule 需要实现的接口

  # 原始数据 -> 抽象二维矩阵地图的映射关系
  @impl MapTranslatorBehaviour
  def handle_ele(ele) when ele in 0..200 do
    0
  end

  def handle_ele(ele) when ele in 201..230 do
    1
  end

  def handle_ele(ele)  do
    ele - 200
  end

  # 元素描述，体现在接口返回值中
  @impl MapTranslatorBehaviour
  def get_ele_description, do: @ele_description

  # 获取地图风格
  @impl MapTranslatorBehaviour
  def get_type(hash) do
    type_index =
      hash
      |> Binary.at(0)
      |> rem(Enum.count(@map_type))
    Enum.at(@map_type, type_index)
  end
end
```

在此步骤后得到「抽象二维矩阵地图」。

**Step 0x03 将抽象地图 Mint 为 NFT**

玩家可以通过将抽象二维矩阵地图 Mint 为 NFT，来宣告其对该地图的所有权。

在 Mint 的时候，玩家可将一段描述填写到 NFT 中，以实现 NFT 创造的「玩家参与」。

#### 3.1.2 链下步骤

**Step 0x04 将抽象地图渲染为实际地图**

游戏运营商将抽象二维矩阵地图渲染为实际的游戏地图

 —— 可以是二维地图，也可以是三维地图。

### 3.3 NFT 合约代码讲解

代码见：

> [tai-shang-world-generator/mapNFT.sol at main · WeLightProject/tai-shang-world-generator](https://github.com/WeLightProject/tai-shang-world-generator/blob/main/contracts/mapNFT.sol)

#### 3.3.1 关键变量

```JavaScript
    string public rule; // 合约指定规则，内容为ar上的交易id
    string public baseURL; // 基础 URL，呈现地址为基础 URL + blockHeight 拼接而成
    string public onlyGame; // 合约钦定游戏
    // 如上参数都只能设定一次
    uint256 tokenId = 1;
    mapping(uint256 => uint256) blockHeight;
    // 区块高度（数据源）
    mapping(uint256 => string) tokenInfo;
    // 在mint时候用户自行填写的地图描述
```

#### 3.3.2 关键函数

只能由合约所有人设置一次的变量：

```JavaScript
    function setbaseURL(string memory _baseURL) public onlyOwner {
        require(bytes(baseURL).length == 0, "baseURL is already set!");
        baseURL = _baseURL;
    }

    function setRule(string memory _rule) public onlyOwner {
        require(bytes(rule).length == 0, "rule is already set!");
        rule = _rule;
    }

    function setOnlyGame(string memory _onlyGame) public onlyOwner {
        require(bytes(onlyGame).length == 0, "onlyGame is already set!");
        onlyGame = _onlyGame;
    }
```

tokenURI 拼接方法：

```HTML
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string[11] memory parts;
        parts[
            0
        ] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">';
        parts[1] = "see map in: ";
        parts[2] = '</text><text x="10" y="40" class="base">';
        parts[3] = baseURL;
        parts[4] = "&amp;token_id=";
        parts[5] = toString(tokenId);
        parts[6] = '</text><text x="10" y="60" class="base">';
        parts[7] = "description: ";
        parts[8] = '</text><text x="10" y="80" class="base">';
        parts[9] = tokenInfo[tokenId];
        parts[10] = "</text></svg>";

        string memory output = string(
            abi.encodePacked(
            parts[0],
            parts[1],
            parts[2],
            parts[3],
            parts[4],
            parts[5],
            parts[6],
            parts[7],
            parts[8],
            parts[9]
            )
        );

        output = string(
            abi.encodePacked(
                output,
                parts[10]
                )
        );
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "Map #',
                        toString(tokenId),
                        '", "description": "nfts based on blockHeight.", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(output)),
                        '"}'
                    )
                )
            )
        );
        output = string(abi.encodePacked("data:application/json;base64,", json));

        return output;
    }
```

NFT 最终在交易市场中的呈现样式：

![image-20220108232049431](https://tva1.sinaimg.cn/large/008i3skNgy1gy6odnii6kj30pr06vjrs.jpg)

claim 函数：

设置token 的 blockHeight 与 tokenInfo 两个参数。

```C%23
function claim(uint256 _blockHeight,string memory _tokenInfo) public nonReentrant {
        _safeMint(_msgSender(), tokenId);
        blockHeight[tokenId] = _blockHeight;
        tokenInfo[tokenId] = _tokenInfo;
        tokenId++;
    }
```

## 0x04 应用场景说明 Scenario Description

本项目主要面向 NFT 玩家、游戏项目团队两类群体。

NFT 玩家又可以进一步划分为「体验型玩家」、「创作型玩家」与「经营型玩家」。这三种类型可以是重叠的，就是某个玩家可能是单一类型的，也可能是多种类型兼具。

### 4.1 玩家群体

#### 4.1.1 体验型玩家

体验型玩家注重游戏、游戏社交等过程带来的体验。对于这类玩家，探索地图，在探索的过程中体验游戏项目团队设计好的游戏流程能吸引到他们。

#### 4.1.2 创作型玩家

创作型玩家，会在创作的过程里得到满足感。TaiShang World Generator 可以带来三种玩法，以下玩法均可由游戏项目团队提供：

- 拼接 MAP NFT，将其组合成更大的地图；
- 在 mint NFT 的时候，或者之后给地图赋予故事；
- 自行决定地图的渲染，只要渲染结果和「二维抽象矩阵地图」逻辑一致即可。

#### 4.1.3 经营型玩家

对于经营型玩家，会从经营其所拥有的地图中获得相应的经济回报与精神满足。

### 4.2 游戏项目团队

对于游戏项目团队而言，TaiShang World Generator 提供了一种 CryptoNative 的地图生成方式，同时带来了一批初始玩家。

游戏项目团队可以在本项目提供的范式的基础上，充分发挥其创意。例如：

- 游戏项目团队可以自行购买 map NFT 进行游戏运营，从而获得相关收益；
- 也可以让玩家提供 map NFT，构建一套经济体系；
- 如果该游戏项目和 NFT 关联不大，也可以直接使用开源 Repo，仅使用抽象地图生成功能。



游戏项目团队和玩家相辅相成的关系。游戏项目团队发挥创意，提供游戏规则、玩法等等，NFT玩家在作为TaiShang世界的原住民，可以任意穿梭于各个游戏团队勾勒出的「小世界」中。

## 0x05 已有进度&未来展望 Now & Prospect

目前，已经实现了如下功能：

- 基于链上数据生成二维抽象矩阵地图
- 一个渲染为具象二维游戏地图的例子
- 将地图与玩家自由填写的故事 mint 为 NFT（Doing）

TaiShang World Generator 的定位是 TaiShang 元宇宙的基础设施之一。

![img](https://tva1.sinaimg.cn/large/008i3skNgy1gy6oe6ipeij31hc0p2gq4.jpg)

未来，我们希望能够在TaiShang World Generato等一系列的开源项目的基础上，一方面构造TaiShang元宇宙，吸引更多的玩家和开发参与到这个世界当中来；另一方面供给各个元宇宙的开发者使用，共同繁荣元宇宙生态。

## 0x06  团队介绍 Team Introduction

NonceGeek: Cool-Oriented Programming.
