# TaiShang World Generator

> **Authors:** leeduckgo, msfew, fengfeng

## 0x01 Brief Introduction ⚡️

The random map generation currently available on the market is done off-chain to generate a random map, and then upload the coordinates of the map to the blockchain. Since there is no repeatability, the world generated in this way is not as Web3. Users cannot generate a world like Sandbox by themselves, and the ownership of the world is still in the hands of Sandbox.

Therefore, this project decided to start from this point, on-chain data that can not be tampered with data (such as block data, hash data) will be the seed for the generation of abstract maps. Abstract maps can be further mint into NFT, then derive more ways to play.

![img](https://tva1.sinaimg.cn/large/008i3skNgy1gy6o5maasaj31hc0p2gq4.jpg)

**Innovations of this project:**

- A new perspective on blockchains -- **verifiable self-growing distributed data sources;**
- **The practice of abstract NFT:** NFT consists only pointers to renderers;
- **The practice of cold media NFT:** the on-chain data is responsible for the generation of the 2D matrix map and the users are responsible for telling the "story of the map" by recreation of maps;
- **The practice of Arweave with traditional Layer1:** traditional chains are responsible for the storage of data, and Arweave is responsible for the storage of stateless code (e.g., generation rules) and resources.

## 0x02 Background

Blockchains are the product of a combination of many complex technologies. As such, the system can be viewed from many different and interesting perspectives:

- A distributed consensus network with infinitely increasing nodes and no performance degradation

- A Gaussian timer

- A Web3 network

- ……

However, this project attempts to take a fresh perspective on blockchain as a **verifiable self-growing distributed data source**.

Such a data source has the following characteristics.

- **Self-growing**

On-chain data self-grows at a fixed frequency, and so, under deterministic rules, the same happens to map areas, treasures, monsters, and other objects generated from the metadata!

- **Distributed**

The metadata comes from blockchain, so there is no need to worry about the loss of metadata and tampering.

- **Verifiable** 

All on-chain data including "metadata" and "transformation rules" are "verifiable".

- **Free**

Blockchain data retrieval is free, so the equivalent of what we have is a free data source!

## 0x03 Project Details

### 3.1 Project manual for the player

- Click `Generate`  to generate game map based on blockchain data

![generate_map](https://tva1.sinaimg.cn/large/008i3skNgy1gy7p0dddidg31360kydwl.gif)

- Character could walk in map, talk to NPC, open the chest

![walks](https://tva1.sinaimg.cn/large/008i3skNgy1gy7p1ibtz2g31360kykdo.gif)

- Click `Mint` to mint the map as `mapNFT`：

![mint](https://tva1.sinaimg.cn/large/008i3skNgy1gy7p39y15ug31360kyx6p.gif)

- Click `View` to see the map of `mapNFT` by token_id

![view_token](https://tva1.sinaimg.cn/large/008i3skNgy1gy7p44j5y0g31360kyb29.gif)

### 3.2 Full flow of On-chain data source -> Game maps

![TaiShang World Generator Main Process](https://tva1.sinaimg.cn/large/008i3skNgy1gy7ragak27j30u01cstch.jpg)![img]()

<center>Full flow of On-chain data source -> Game maps</center>

#### 3.1.1 Steps on chain

**Step 0x01 Getting on-chain data**

> [ block-height-based or contract-based or user-based ] x [block data, transaction data]

**Step 0x02 Transforming on-chain raw data by on-chain rules**

On-chain rules are code snippets written on the Arweave chain that can be dynamically loaded into the tai-shang-nft-generator project.

An example of an on-chain rule module:

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

After this step, we get the abstract 2D matrix map.

**Step 0x03 Mintting abstract maps to NFT**

Players can declare their ownership of an abstract 2D matrix map by minting it into an NFT.

When minting, the player can fill in a description into the NFT to enable the player's participation in the process.

#### 3.1.2 Steps off chain

**Step 0x04 Rendering abstract maps to maps in game**

Game operators can render abstract 2D matrix maps into actual game maps

 -- This can be either a 2D map or a 3D map.

### 3.3 NFT contract code explained

Source codes are at: 

> [tai-shang-world-generator/mapNFT.sol at main · WeLightProject/tai-shang-world-generator](https://github.com/WeLightProject/tai-shang-world-generator/blob/main/contracts/mapNFT.sol)

#### 3.3.1 Key variables

#### 3.3.1 Key variables

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

#### 3.3.2 Key funtions

Functions for setting variables by contract owner for only once: 

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

tokenURI concatenating rule:

```solidity
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

Final presentation style of NFT in the exchange market:

![image-20220108232049431](https://tva1.sinaimg.cn/large/008i3skNgy1gy6odnii6kj30pr06vjrs.jpg)

claim function: 

Setting parameters of blockHeight and tokenInfo of token

```solidity
function claim(uint256 _blockHeight,string memory _tokenInfo) public nonReentrant {
        _safeMint(_msgSender(), tokenId);
        blockHeight[tokenId] = _blockHeight;
        tokenInfo[tokenId] = _tokenInfo;
        tokenId++;
    }
```

## 0x04 应用场景说明 Scenario Description

## 0x04 Scenario Description

This project is mainly for two groups: NFT players and game project teams.

NFT players can be further divided into "gaming players", "creating players" and "trading players". These three types can overlap, that is, a player may be a single type or a combination of types.

### 4.1 Player groups

#### 4.1.1 Gaming players

Gaming players focus on the experience and socialization brought by the game, and other processes. For such players, exploring the map and experiencing the game process designed by the game project team in the process of exploration can attract them.

#### 4.1.2 Creating players

Creating players will focus on the process of building and creating. TaiShang World Generator can be played in three ways, all of which can be provided by the game project team:

- minting map NFTs and combining them into larger maps;

- Telling stories about the maps at the time of minting NFT;

- Rendering the map at your own discretion, as long as the rendering result is logically consistent with the "2D abstract matrix map".

#### 4.1.3 Trading players

Trading players will get revenues and satisfaction from exchanging maps.

### 4.2 Game project teams

For game project teams, TaiShang World Generator provides a crypto native approach to map generation while bringing in an initial group of players.

The game project team can build on the paradigm provided by this project and give full play to their creativity. For example:

- Game project teams can purchase map NFT for game operation and thus get revenue;

- Game project teams can also let players provide map NFT to build a set of economic systems;

- If the game project has less connection with NFT, it can also use the open source repo from TaiShang directly and only use the abstract map generation function.

The game project team and the player have a complementary relationship. The game project team is creative and provides game rules, gameplay, etc. NFT players, as the natives of the TaiShang world, can travel through the worlds outlined by each game team at will.

## 0x05 Progress now & future plans

Currently, the following functions have been implemented:

- Generating 2D abstract matrix maps based on on-chain data

- A demo of rendering a figurative 2D game map

- Minting the map with the player's story as NFT (In Progress)

 TaiShang World Generator is one of the infrastructures of the TaiShang metaverse.

![img](https://tva1.sinaimg.cn/large/008i3skNgy1gy6oe6ipeij31hc0p2gq4.jpg)

In the future, we hope to build the TaiShang meta-universe on the basis of a series of open source projects such as TaiShang World Generator, so as to attract more players and developers to participate in this world; on the other hand, we hope to supply developers of each meta-universe to use and prosper the meta-universe ecosystem together.

## 0x06  Team members

**NonceGeek:** Cool-Oriented Programming.

