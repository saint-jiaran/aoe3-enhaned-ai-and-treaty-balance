# AoE3 DE 本地 Mod 合集

本目录包含两个相互配套的《帝国时代 3 决定版》本地模组：

| 目录 | 名称 | 作用 |
|------|------|------|
| `209052_enhanced ai` | Enhanced AI（增强 AI） | 大幅强化电脑 AI 的决策、经济与军事逻辑 |
| `mymode` | AI 卡组 + 条约平衡包 | 为全部文明提供 `Enhanced-Land` 卡组，并对单位 / 科技数据做条约平衡调整 |

两者关系：**`mymode` 是 `209052_enhanced ai` 的配套卡组包**。Enhanced AI 会从各文明的主城（homecity）文件里读取名为 `Enhanced-Land` / `Enhanced-Naval` 的卡组作为 AI 的发卡依据，`mymode` 正是为此而建的本地数据模组；此外它还带有一整套面向后期条约战（Treaty）的单位 / 科技平衡调整（见下文第二节）。

---

## 一、Enhanced AI（`209052_enhanced ai`）

### 1. 来源与版本

- 原作者：**EsteGringo**
- 原版版本：**1.1.0b3**（2026-09-10）
- Steam 创意工坊 ID：`209052`
- 项目性质：开源，原作者允许自由使用，但引用其代码需注明出处。

原版目标：让 AI 在陆图与海图上都更有趣、更有竞争力（会渡海登陆、使用战列舰、造墙、使用教堂科技与特殊单位等）。

### 2. 本地的自定义修改

在原版基础上，本人进行了大量二次修改，详细记录见 [`209052_enhanced ai/修改记录.txt`](209052_enhanced%20ai/修改记录.txt)。要点如下：

1. **卡牌发送逻辑**：优先发完所有一次性/有限卡，再回退发送无限卡；并修复了「一次性卡未发完时无限卡被永久挡住」的 bug。
2. **帝王时代原住民升级科技**：把「传说原住民」（+50% 原住民血量/攻击）加入欧洲 / 原住民 / 亚洲文明的帝王时代研究队列。
3. **农民数量上限**：去掉 AI 农民 80 上限，改为出到游戏上限 99；荷兰 50→70；保留法国 80（Coureur des Bois 上限）。
4. **军械库 / 畜栏科技**：新增骑兵强化科技（DESPCHorseBreeding、CavalryRifling）与畜栏科技（DEFullingMills）的自动研究。
5. **战犬单位**：将战犬（WarDog）维持规则从「仅西班牙」扩展到所有欧洲文明；西班牙改研究专属帝王科技 ImpKnighthoodSpain / ImpPeerageSpain。
6. **非洲 deField 建造修复**：修复谷仓选址的作用域 bug，并给农田计划增加基地兜底选址，解决豪萨 / 埃塞俄比亚长期不建农田的问题。
7. **全文明牲畜造满**：新增山羊、水牛、非洲牛（Sanga/Zebu）维持计划；印度圣牛维持到建造上限 20。
8. **原住民祭祀造满**：易洛魁、苏族通过跳舞（HolyDance）把祭祀（Medicine Man）维持到建造上限。
9. **非洲 deField 数量 10→50**：把非洲文明的农田/种植园（deField）建造目标提高到 50 座。
10. **三建筑造满**：豪萨 deUniversity（1→4）、埃塞 deMountainMonastery（→2）、印加 Plantation（3→20）。
11. **亚洲三国茶叶出口**：中国 / 日本 / 印度帝王时代后研究 `DEHCTeaExport2`（领事馆单位训练速度 +50% 等）。

### 3. 文件结构

```
209052_enhanced ai/
├── data/
│   └── protomods.xml          # 数据补丁：移除所有舰船的 AbstractArtillery 标签
├── game/ai/                   # AI 主脚本
│   ├── aimain.xs / age3ai.xs / aiheader.xs / ai*.xs
│   └── core/
│       ├── *.xs               # 经济 / 军事 / 建筑 / 海军 / 卡牌等核心逻辑
│       ├── enhanced/          # 协同进攻、前线基地、明治维新等增强模块
│       └── revolutions/       # 各革命国家独立逻辑（阿根廷、巴西、海地、普鲁士等 21 个）
├── readme.txt                 # 原作者的说明（含自定义卡组制作教程）
└── 修改记录.txt               # 本人的二次修改记录
```

> 说明：`data/protomods.xml` 将所有舰船单位从 `AbstractArtillery` 中移除，用于修正 AI 对舰船的分类（不再把船当作火炮单位），属于原版 Enhanced AI 自带的数据补丁。

---

## 二、mymode —— AI 卡组 + 条约平衡数据

### 1. 作用

Enhanced AI 通过识别主城文件里的 `Enhanced-Land` / `Enhanced-Naval` 卡组来发卡（见原版 readme 的「Instructions for Creating Custom AI Decks」章节）。本模组有两个作用：

1. **AI 卡组**：为 **全部 24 个文明** 各提供一套 `Enhanced-Land` 卡组，覆盖：美国、英国、中国、丹麦、印加、荷兰、埃塞俄比亚、法国、德国、豪萨、印度、意大利、日本、马耳他、墨西哥、奥斯曼、波兰、葡萄牙、俄罗斯、西班牙、瑞典、阿兹特克、易洛魁、苏族。
2. **条约平衡**：对 `protoy.xml`（单位数据）与 `techtreey.xml`（科技树数据）做了一套面向后期条约战（Treaty）的平衡性调整（见下文第 3 节）。

### 2. 内容

```
mymode/
├── data/
│   ├── homecity*.xml          # 24 个文明的主城文件（各含一套 Enhanced-Land 卡组）
│   ├── protoy.xml             # 单位数据（含条约平衡调整）
│   ├── techtreey.xml          # 科技树数据（含条约平衡调整）
│   └── tactics/               # tactics 文件（blockhouse、deTorp、folwark、herd 等 8 个）
└── uscapitalism.png           # 模组封面图
```

### 3. 条约平衡改动（protoy.xml / techtreey.xml）

> 与官方原版数据（`Desktop\新建文件夹 (5)\Data`）比对，`protoy.xml` 约 850 行、`techtreey.xml` 约 3381 行发生改动。整体方向是**强化后期条约战的可玩性与单位克制链**：重步兵能有效反制散兵、轻骑兵提升远程生存、防御建筑上限 +1、经济建筑产出上调，并为多个文明补上缺失的帝王科技 / 专属单位。

#### 3.1 全局通用改动

- **防御建筑上限 +1**：前哨（Outpost）、碉堡（Blockhouse）、战屋（WarHut）、贵族屋（NoblesHut）、亚洲/非洲前哨（YPOutpostAsian / deOutpostAfrican）、deTower、deChinchaRaft 由 7→8；城堡 ypCastle 5→6；deCommandery、deKallanka、dePalace 4→6；deLombard 5→6；圣田 ypSacredField 2→5。
- **重步兵反散兵**：几乎所有重步兵 / 双手剑单位新增或强化对 `AbstractSkirmisher`（散兵）的伤害加成（都卜勒武士、MercLandsknecht、浪人、医护骑士、条顿骑士、deMaceman、骷髅骑士、领事馆双手剑等），手部护甲普遍 0.2→0.3。
- **轻骑兵远程甲**：龙骑兵、骑手、deUSCavalry、deFinnishRider、领事馆 Jinetes/Kalmuck、骆驼兵、象轿等远程护甲提升。
- **经济建筑**：工厂各资源产出上调（金 5.5→6.0、食物 5.5→6.5、木材 5.5→6.0、贸易 2.2→3.5）；城镇中心产出上调并新增自动经验（AutoGatherXP）；种植园金速率 0.8→0.85。
- **牲畜经济**：牛 / 猪 / 水牛 / 牦牛成本上调，绵羊 / 山羊新增自动产金（AutoGatherCoin 0.035），配合新增畜栏科技 `DEFullingMills`。
- **新增科技按钮**：军械库新增 `CavalryRifling`（枪骑兵反重骑 / 反游击），畜栏新增 `DEFullingMills`，教堂新增 `ChurchLandwehr`，城镇中心新增 `DEHCTeaExport2`，国会（Capitol）新增西班牙专属 `ImpKnighthoodSpain` / `ImpPeerageSpain`，前哨 / 指挥所新增 `Frontier*` / `Fortified*` 系列。
- **战犬 WarDog**：移速 5→6，并扩展到全部欧洲文明（建造上限 +10）。

#### 3.2 各文明改动（摘要）

**欧洲 8 国**

- **英国**：长弓兵 +15% 攻/血并新增散兵反制；火枪手近战伤害 +10%（红衫军）；工业后自动研究 `CavalryRifling`；长枪兵（DEHCShipPikemenBritish）成本下调。
- **法国**：Coureur des Bois 远程甲 0.3→0.4；胸甲骑兵血 425→450；革命法国成本上调、农民采集改百分比；近卫军（青年近卫军）解锁。
- **德国**：乌尔兰血/伤/成本全面上调；都卜勒武士反散兵；新增 `ChurchLandwehr`（十字弓→国民军 deLandwehr）；农民上限 +60；工业后 `CavalryRifling`。
- **荷兰**：骑手（Ruyter）成本 30→35 粮、远程甲 0.1→0.2；银行上限 5→10；工业后 `CavalryRifling`。
- **葡萄牙**：龙骑兵远程甲 +0.05；十字弓成本 -25%；工业后 `CavalryRifling`。
- **俄罗斯**：特骑兵（Oprichnik）伤害 +4；散兵血 +20%、射程 +2；农民上限 100；新增巴什基尔马（deNMPandour）可碉堡训练。
- **西班牙**：新增专属帝王科技 `ImpKnighthoodSpain` / `ImpPeerageSpain`（战犬上限 15、英雄 +1000 血、伤害翻倍）。
- **奥斯曼**：近卫军 +5 血、阿布斯炮 +2 伤；西帕希骑兵可稳定营训练；教堂系列（Tanzimat/Topkapi/TopcuCorps）强化；领事馆新增「经济理论」（村民采集 +10%）。

**欧洲 DLC 文明**

- **意大利**：新增教皇轰击炮（deNMPapalBombard，人口 8→7）；大教堂上限 +1；deLombard 上限 5→6、经验速率翻倍；工业后 `CavalryRifling` + `DESPCHorseBreeding`。
- **马耳他**：指挥所（deCommandery）4→6 并新增 `FrontierCommandery` / `FortifiedCommandery`；医护骑士反散兵；马耳他火枪手射程 +2、血/攻 +50%、人口 -1。
- **瑞典**：皮革炮远程甲 0.5→0.75；deSlinger 反攻城、射速 4→3；卡罗林训练提速；出生即解锁 `CavalryRifling` + `DESPCHorseBreeding`。
- **丹麦**：deEspingol 血/攻 +50%；农民上限 90；帝王长枪兵等近战射程 +1。
- **波兰**：翼骑兵赏金 30→28；国会（Sejm）采集科技全面上调（木材/食物/金币 +20%）；农民上限 85。
- **墨西哥**：革命研究点 15→10；deSoldado 船运 6→9；庄园（deHacienda）采集上调；农民上限 95；工业后 `CavalryRifling` + `DESPCHorseBreeding`。
- **美国**：民兵 / 游骑兵 / 骑兵全面提升并可军营训练；磨坊、农田 +15%；堡垒各批次训练时间上调；工业后 `CavalryRifling`。

**非洲文明**

- **豪萨**：王宫（dePalace）4→6 并可训练征召兵；建筑师（deArchitect）伐木 +50%；弗拉武士射程 17→18；王宫炮击 +4 射程。
- **埃塞俄比亚**：deAbun 解除批次限制；修道院（deMountainMonastery）上限 +1；dePriestess 上限 16→15；王宫炮击 +4 射程；帝王时代非洲砍伐加成。

**美洲原住民**

- **印加**：卡兰卡（deKallanka）4→6；堡垒伤害 +2；投石兵（deSlinger）反攻城、射速 4→3；帝王时代解锁大量原住民同盟科技（传说 / 勇士 / 信使等）。
- **阿兹特克**：骷髅骑士反散兵并改粮食成本、可贵族屋训练；鹰骑士手甲 +0.1；箭骑士反炮 5.25→6.0 并新增反攻城；萨满 / 智者加成上调；新同盟科技（美洲豹/鹰武士）。
- **易洛魁**：长屋伤害 10→20；战屋上限 +4、攻速/血上调；帝国传说血/攻 +50%（1.25→1.5）。
- **苏族 / 拉科塔**：狗战士可畜栏训练、改粮食成本；弓骑 / 火枪骑 / 战弓 / 马兵全面上调；雄鹰骑士血/伤/上限上调。

**亚洲文明**

- **中国**：城堡 5→6 并可训练火炮 / 神火飞鸦 / 领事馆火箭；瓷塔 / 白塔产出上调、弟子光环；长刀 / 火绳枪 / 流星锤 / 神火飞鸦 / 手炮全面强化；帝王后研究 `DEHCTeaExport2`。
- **日本**：神社 / 东照宫 / 大佛产出大幅上调；城堡 5→6；町（农民）上限 75→80；武士血/伤/射程上调；明治维新成本上调并解锁帝国火炮；帝王后研究 `DEHCTeaExport2`。
- **印度**：圣田（ypSacredField）2→5 并可训练山羊；象兵系远程甲 / 木材产出 / 反攻城上调；苏瓦尔人口 2→1；泰姬陵可训练狮子、宝箱 +10~25%；阿格拉堡伤害上调；帝王后研究 `DEHCTeaExport2`。

### 4. 注意事项

- `homecity*.xml` 是对原版主城文件的**完整替换**，因此若与朋友联机，对方也需要启用本模组，否则可能出现数据不一致。
- `protoy.xml`、`techtreey.xml` 含上述条约平衡改动，同样属于**完整替换**；联机对局双方需使用同一套数据，否则单位 / 科技数值会不同步。
- 当前仅提供 `Enhanced-Land`（陆图）卡组，暂未提供 `Enhanced-Naval`（海图）卡组；如需海图卡组，可参照原版 readme 的教程自行添加。

---

## 三、安装与使用

1. 两个目录都已放在本机的本地 Mod 目录下：
   `C:\Users\11022\Games\Age of Empires 3 DE\76561198953220667\mods\local\`
2. 进入游戏 → **工具 / 模组（Mods）**，在「本地」页勾选启用 **Enhanced AI** 和 **mymode**。
3. 开一局对抗 AI 即可生效（单人 / 自定义房间均可；联机需双方都启用相同模组）。

---

## 四、兼容性与已知问题

- 两个模组需**同时启用**才能让 AI 使用自定义卡组（`Enhanced-Land` 卡组由 `mymode` 提供，AI 读取逻辑在 `209052_enhanced ai` 中）。
- 联机时，参与对局的玩家需要与你的模组版本保持一致，否则可能出现不同步或无法加入。
- 原版 Enhanced AI 已知的遗留问题（如部分岛屿登陆时单位短暂滞留海岸、奥斯曼不选无限西帕希卡等）仍在原作者的计划列表中，可参考 `readme.txt` 的「Upcoming Features and Fixes」。

---

## 五、致谢

- 增强 AI 基础：**[EsteGringo](https://github.com/AOE3-Modding-Council/Resource-Manager) 的 Enhanced AI**（Steam 创意工坊 ID 209052）
- 卡组制作工具：AoE3 Resource Manager（https://github.com/AOE3-Modding-Council/Resource-Manager）
