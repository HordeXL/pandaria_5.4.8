# Playerbots 被注释功能恢复规划

> 项目:`alexkulya/pandaria_5.4.8`(WoW 5.4.8)分支 `playerbots`
> 模块:`modules/mod_playerbots`(静态编译进 `worldserver.exe`)
> 构建:Visual Studio 2022,Release x64(MSBuild)
> 状态:**规划中** — 2024-08-04 已恢复"下线轮换",其余待执行

---

## 0. 背景

`mod_playerbots` 源码中存在大量被 `/* */` 整段注释掉或"禁用"的功能代码,主要来自本地化修改(Peiru 等)。其中一部分导致 bot 行为退化(不逃跑、不活跃、开锁失效等),一部分只是旧实现被替代。

本文档逐一列出被注释功能、恢复方案、依赖与风险,按优先级排序。**恢复原则**:每次只动一处 → 全量编译 → 部署备份 → 验证。

---

## 1. 已完成

| 日期 | 功能 | 改动 |
|---|---|---|
| 2024-08-04 | 随机机器人**下线轮换** | `RandomPlayerbotMgr.cpp` `AddRandomBots()`:`add_time = 31104000` → `urand(minRandomBotInWorldTime, maxRandomBotInWorldTime)`,利用既有 `ProcessBot()` 的 `!isValid` 分支完成下线+补位。已编译部署(`worldserver.exe.bak` 可回滚) |
| 2024-08-05 | **P0 批**(R1-R5) | 见提交 `bd73e1f`;R1 登出冷却、R2 LFG 活跃、R3 开锁/剥皮(重写为 `GetLootGUID`+`GameObject::Use`)、R4 被控状态、R5 灵魂碎片 |
| 2024-08-05 | **P1 批**(R6-R9, R12) | 见提交 `94131ef`;R6 `IsInRealGuild`、R7 邻近/好友活跃、R8 升级传送、R9 玩家登录 botAutologin、R12 防拥挤传送。**R10 有意保留**(Peiru 防御修改,见 3.10)、**R11 不恢复**(TravelTarget 系统已删除,见 3.11) |

---

## 2. 待恢复清单总览

> 状态图例:✅ 已恢复(提交 `bd73e1f`/`94131ef`)· ⛔ 不恢复(原因见 3.x 节)· ⬜ 待恢复

| 编号 | 优先级 | 功能 | 位置 | 恢复成本 | 状态 |
|---|---|---|---|---|---|
| R1 | P0 | 登出轮换的 logout 事件补充 | `RandomPlayerbotMgr.cpp:378-396` | 低 | ✅ 已恢复 |
| R2 | P0 | LFG/副本排队活跃检测 | `PlayerbotAI.cpp:627-642` | 低 | ✅ 已恢复 |
| R3 | P0 | 开锁/剥皮 `CMSG_GAMEOBJ_USE` | `PlayerbotAI.cpp:2426-2443` | 低 | ✅ 已恢复 |
| R4 | P0 | 被控状态(root/stun/confuse)检查 | `PlayerbotAI.cpp:1303-1304` | 低 | ✅ 已恢复 |
| R5 | P0 | 术士灵魂碎片检查 | `WarlockActions.cpp:11` | 低 | ✅ 已恢复 |
| R6 | P1 | 真人公会活跃 `IsInRealGuild` | `PlayerbotAI.cpp:562-568` | 中 | ✅ 已恢复 |
| R7 | P1 | 好友/邻近玩家活跃判定 | `PlayerbotAI.cpp:571-574, 645-668` | 中 | ✅ 已恢复 |
| R8 | P1 | 升级自动传送/换装 | `AutoMaintenanceOnLevelupAction.cpp:20-58` | 中 | ✅ 已恢复 |
| R9 | P1 | 玩家登录自动登录 bot | `PlayerbotMgr.cpp:1275-1305` | 中 | ✅ 已恢复 |
| R10 | P1 | 正常登出流程(取消强制即时登出) | `PlayerbotMgr.cpp:382-402` | 中 | ⛔ 不恢复(见 3.10) |
| R11 | P1 | `idleBot` 空闲判断恢复 | `RandomPlayerbotMgr.cpp:439-449` | 低 | ⛔ 不恢复(见 3.11) |
| R12 | P1 | 防拥挤传送 / RPG 目的地传送 | `RandomPlayerbotMgr.cpp:1001-1057` | 中 | ✅ 已恢复 |
| R13 | P2 | bot 活跃百分比(核心活动开关) | `PlayerbotAI.cpp:676-705` | 高 | ⬜ 待恢复 |
| R14 | P2 | Flee 逃跑行为 | `MovementActions.cpp:816+` | 高 | ⬜ 待恢复 |
| R15 | P2 | 等级随在线玩家同步 | `RandomPlayerbotMgr.cpp:530-532` | 高 | ⬜ 待恢复 |
| R16 | P2 | 战场夺旗判断 | `ChooseTargetActions.cpp:15-24, 107-108` | 中 | ⬜ 待恢复 |
| R17 | P2 | 战场死亡等待复活 aura | `ReleaseSpiritAction.cpp:53-79` | 中 | ⬜ 待恢复 |
| R18 | P2 | 副本策略 `applyInstanceStrategies` | `PlayerbotAI.cpp:789-790, 1089-1090` | 高 | ⬜ 待恢复 |
| R19 | 忽略 | 旧实现被替代(见 3.4 节) | — | — | — |

---

## 3. 逐项恢复方案

### 3.1 R1 — 登出轮换的 logout 事件补充(P0)

- **位置**:`RandomPlayerbotMgr.cpp:378-396`(`ProcessBot()` 内被注释块)
- **现状**:轮换已通过 `add_time` 恢复(R1 之外的既有分支),此段被注释的 `logout` 事件逻辑未启用
- **功能**:bot 登出后设置 `logout=1` 持续 `urand(min/maxRandomBotInWorldTime)`,期间 `AddRandomBots()`(`:222`)跳过该 bot,防止下线 bot 立刻被重新选中
- **恢复步骤**:
  1. 取消注释 `:378-396`,把条件 `if (player && !logout && !isValid)` 改为 `if (player && !logout)`(原 `!isValid` 与上层 `:289-310` 分支冲突,恒不成立)
  2. 保持 `LogoutPlayerBot(botGUID)` + 从 `_currentBots` 移除 + `SetEventValue(bot, "logout", 1, urand(...))`
- **依赖**:`LogoutPlayerBot`、`min/maxRandomBotInWorldTime` 均存在 ✅
- **风险**:低。注意与 `add_time` 轮换可能双路径登出,建议 R1 与现有 `!isValid` 分支二选一(推荐保留 add_time 路径,R1 仅补 logout 冷却)
- **验证**:编译通过;观察 bot 下线后短时间内不再上线

### 3.2 R2 — LFG/副本排队活跃检测(P0)

- **位置**:`PlayerbotAI.cpp:627-642`
- **功能**:bot 或其队伍处于 `sLFGMgr` 排队/副本状态时,`IsActive()` 直接返回 true,加快进本
- **恢复步骤**:取消注释即可;`sLFGMgr` 为核心全局,依赖存在 ✅
- **风险**:低。需确认 `sLFGMgr` 相关 API 签名与 5.4.8 核心一致(该核心即本仓库,应一致)
- **验证**:bot 排队随机本后不会被随机化/传送打断

### 3.3 R3 — 开锁/剥皮发包(P0)

- **位置**:`PlayerbotAI.cpp:2426-2443`
- **功能**:对 loot 目标发送 `CMSG_GAMEOBJ_USE`,使开锁/剥皮技能实际生效
- **现状**:注释后开锁/剥皮可能只做动作不产生结果
- **恢复步骤**:取消注释;确认 `WorldPacket(CMSG_GAMEOBJ_USE)` 与 `bot->GetSession()->HandleGameObjectUseOpcode` 相关调用在当前核心可用
- **风险**:低-中。若发包逻辑引用了已删除辅助函数,需按当前 `HandleGameObjectUseOpcode` 签名适配
- **验证**:盗贼开锁、剥皮者剥皮有实际产物

### 3.4 R4 — 被控状态检查(P0)

- **位置**:`PlayerbotAI.cpp:1303-1304`
- **功能**:bot 处于 root/stun/confuse 光环时不主动施法/移动
- **恢复步骤**:取消注释;依赖 `bot->HasAuraType(...)` 等核心 API
- **风险**:低
- **验证**:被变羊/眩晕的 bot 不再乱动

### 3.5 R5 — 术士灵魂碎片(P0)

- **位置**:`WarlockActions.cpp:11`
- **现状**:`/*return ... "soul shard" < 10;*/ return std::rand() % 5 < 2;`
- **功能**:碎片不足时不放消耗碎片的技能
- **恢复步骤**:重写为基于背包/碎片的真实判断(参考上游:统计 `ITEM_SOUL_SHARD` 数量)
- **依赖**:需补一个"获取 bot 灵魂碎片数量"的辅助(可用 `bot->GetItemCount(...)` + 灵魂袋检查)
- **风险**:中(需写新代码)
- **验证**:术士碎片为 0 时不使用碎片技能

### 3.6 R6 — 真人公会活跃(P1)

- **位置**:`PlayerbotAI.cpp:562-568`
- **功能**:bot 在包含真人玩家的公会中时强制活跃(不轮换、不传送走)
- **恢复步骤**:
  1. 实现 `bool PlayerbotAI::IsInRealGuild()`:取 `bot->GetGuildId()`,遍历公会成员,若有非 `IsRandomBot` 的在线玩家返回 true
  2. 取消注释 `:564`
- **依赖**:`IsInRealGuild` 需新增(全库无定义);建议放 `PlayerbotAI.cpp/.h`
- **风险**:中(新增成员函数,注意 `Guild`/`GuildMgr` API)
- **验证**:真人加入的 bot 不再被轮换下线/传送

### 3.7 R7 — 好友/邻近玩家活跃(P1)

- **位置**:`PlayerbotAI.cpp:571-574`(半径内玩家)、`645-659`(好友)、`662-668`(多人聚集)
- **功能**:附近有真人玩家/bot 好友时保持活跃
- **恢复步骤**:取消注释;`HasPlayerNearby`/`HasManyPlayersNearby` 均仍定义 ✅;`BotActiveAloneForceWhenIsFriend` 等配置项需在 `PlayerbotAIConfig.h/.cpp` 补回(默认 0/关闭,由 conf 开启)
- **依赖**:补 3 个配置项
- **风险**:低-中
- **验证**:玩家靠近时 bot 不再秒下线

### 3.8 R8 — 升级自动传送/换装(P1)

- **位置**:`AutoMaintenanceOnLevelupAction.cpp:20-28`(`AutoTeleportForLevel` 空函数)、`:49-58`(`AutoUpgradeEquip` 无条件执行)
- **功能**:升级时按配置自动传送到适合等级区域/自动换装
- **恢复步骤**:参考上游 `RandomTeleportForLevel` 实现函数体;`autoTeleportForLevel`/`autoUpgradeEquip`/`equipmentPersistence` 配置项补回
- **依赖**:`RandomTeleportForLevel` 在 `RandomPlayerbotMgr` 中存在 ✅
- **风险**:中
- **验证**:bot 升级后按配置换装/传送

### 3.9 R9 — 玩家登录自动登录 bot(P1)

- **位置**:`PlayerbotMgr.cpp:1275-1305`(`OnPlayerLogin`,现为空)
- **功能**:`AiPlayerbot.BotAutologin = 1` 时,玩家登录自动把自己的角色当作 bot 上线
- **恢复步骤**:参考上游恢复 `OnPlayerLogin` 中 `PlayerbotMgr::HandlePlayerBotLogin` 调用链
- **依赖**:`HandlePlayerBotLogin` 相关函数需核对是否存在
- **风险**:中(涉及账号/角色遍历,注意死锁)
- **验证**:配置开启后玩家上线自动带 bot

### 3.10 R10 — 正常登出流程(P1,有意保留)

- **位置**:`PlayerbotMgr.cpp:382-402`
- **现状**:`logout = true;`(Peiru 为规避崩溃强制即时登出),使 386-411 正常登出(`TellMaster("I'm logging out!")` + `CMSG_LOGOUT_REQUEST`)成为死代码;`PlayerbotAI::Reset` 的 `CMSG_LOGOUT_CANCEL`(`:733-735`)也被注释
- **恢复步骤**:删除 `:383` 强制行,恢复正常登出;同时恢复 `:301-303, 320-321, 733-735` 的取消登出处理
- **风险**:高(Peiru 注释写明是为解决登出崩溃,恢复后需重点回归测试登出)
- **结论(2024-08-05)**:**有意保留不恢复**。该行为明确标注"为解决登出崩溃"的防御修改;恢复正常登出流程在运营中的服务器上风险大于收益(收益仅为更真实的登出表现)。如确需恢复,建议在测试服验证批量登出无崩溃后再上线。
- **替代方案(可选)**:保留 `logout = true;` 防崩溃,仅在强制登出前补一句 `botAI->TellMaster("I'm logging out!")`,让玩家看到登出反馈;不引入完整登出流程。
- **验证**:多 bot 同时登出无崩溃;`I'm logging out!` 正常发送

### 3.11 R11 — idleBot 空闲判断(P1,不恢复)

- **位置**:`RandomPlayerbotMgr.cpp:439-449`
- **现状**:`TravelTarget` 判断被注释,`idleBot` 恒 true → 有目标(做任务/赶路)的 bot 也会被随机化/传送
- **恢复步骤**:取消注释;`TravelTarget` 相关 API 需确认(`getTravelState()` 等)
- **依赖**:`TravelTarget` 类是否仍存在于 `AiObjectContext` Value
- **风险**:中
- **结论(2024-08-05)**:**不恢复**。`TravelTarget` 类型与 `sTravelMgr`/`"travel target"` value 已从模块整体删除(仅剩注释引用),恢复需重建整个旅行目标系统,成本过高。当前 `idleBot` 恒 true 的行为可接受(随机化/传送仅针对非战斗、非组队、非副本的 bot)。
- **替代方案(可选)**:不重建 TravelTarget,在 `ProcessBot` 的 randomize/teleport 前增加轻量判断——bot 存在未完成任务目标(`QuestStatus`/任务 value)时跳过,防止做任务中的 bot 被传送打断。
- **验证**:做任务中的 bot 不被传送打断

### 3.12 R12 — 防拥挤传送(P1)

- **位置**:`RandomPlayerbotMgr.cpp:1001-1002`(botsNearby 计数)、`:1026`(拥挤判定)、`:1037-1054`(RPG 目的地)、`:1057`(TeleportTo)
- **功能**:目的地 bot 过多时换位置;RPG 模式选择"有意思"的目的地
- **恢复步骤**:逐段取消注释并适配当前 `RandomTeleportForLevel` 结构
- **风险**:中
- **验证**:大城区不再堆满 bot

### 3.13 R13 — bot 活跃百分比(P2)

- **位置**:`PlayerbotAI.cpp:676-705`
- **现状**:`IsActive()` 主体被注释,恒 `return false`(除强制条件)
- **功能**:按 `botActiveAlone` 百分比决定 bot 是否"活跃"(活跃才做任务/传送,不活跃则挂机),配合 `RandomChangeMultiplier` 动态缩放
- **恢复步骤**:需重写——`botActiveAlone` 配置、`AutoScaleActivity()`/`GetFixedBotNumer()`/`BotTypeNumber` 均不存在,参考上游 azerothcore playerbots `PlayerbotAI::IsActive()` 重写并补配置
- **风险**:高;影响所有 bot 行为(建议最后做,或保持禁用)
- **验证**:按配置比例,部分 bot 活跃部分挂机

### 3.14 R14 — Flee 逃跑(P2)

- **位置**:`MovementActions.cpp:816+`(`Flee()` 首行 `return true;`,约 160 行被注释)
- **功能**:低血量/被集火时向坦克/治疗/主人方向逃跑
- **恢复步骤**:重写中段;`FleeManager` 类已不存在,需用现有 API(`MoveNear`/`PlayerBotSpec::IsTank`/`IsHeal`)重新实现简化版
- **风险**:高
- **验证**:bot 残血会拉开距离

### 3.15 R15 — 等级同步(P2)

- **位置**:`RandomPlayerbotMgr.cpp:530-532`
- **功能**:在线玩家平均等级变化时调整 bot 等级池
- **依赖**:配置与 `playersLevel` 局部变量已删,需重写
- **风险**:高(等级池影响面大)
- **验证**:玩家普遍满级后新 bot 等级分布变化

### 3.16 R16 — 战场夺旗(P2)

- **位置**:`ChooseTargetActions.cpp:15-24, 107-108`
- **功能**:`PlayerHasFlag::IsCapturingFlag` 判断(我方夺旗时优先防守)
- **依赖**:`PlayerHasFlag::IsCapturingFlag` 已不存在,需按战场旗帜 aura(如 `SPELL_...` 旗 debuff)重写
- **风险**:中
- **验证**:战场中夺旗 bot 被集火

### 3.17 R17 — 战场死亡复活 aura(P2)

- **位置**:`ReleaseSpiritAction.cpp:53-79`
- **功能**:战场死亡后等待复活计时,避免秒跑尸
- **恢复步骤**:取消注释并适配当前战场 API
- **风险**:中
- **验证**:战场死亡 bot 按节奏释放灵魂

### 3.18 R18 — 副本策略(P2)

- **位置**:`PlayerbotAI.cpp:789-790, 1089-1090`
- **功能**:进副本应用副本专属策略(`applyInstanceStrategies`)
- **依赖**:函数已删除,需按副本 ID 表重写
- **风险**:高
- **验证**:进本后 bot 切换对应策略

---

## 4. 忽略项(不建议恢复)

| 位置 | 说明 |
|---|---|
| `BotFactory.cpp:42-60+` | 初始化特殊任务法术,已被新 Init 流程替代 |
| `BotFactory.cpp:198-217` | 猎人宠物清理,旧逻辑 |
| `RandomPlayerbotFactory.cpp:218-234` | 熊猫人种族改中立,属有意修改 |
| `WorldPosition.cpp:455-470` | `getTransports` 返回空,疑似遗弃 |
| `Engine.cpp:464-468, 654-662` | 性能监控/日志,纯优化 |
| `PlayerbotAI.h:251-273` | 旧聊天成员,已被新回复系统替代 |
| `PlayerbotMgr.cpp:246-254` | 旧逐包处理循环 |
| `RandomItemManager.cpp:454, 701` | 纯注释说明 |
| `PlayerbotMgr.cpp:590-597` | ResetStrategies 竞态说明,有注释文字 |

---

## 5. 通用前置工作

恢复 P1/P2 前需补齐:

1. **配置项**(`Utils/PlayerbotAIConfig.h` + `.cpp`):
   - `BotActiveAloneForceWhenInGuild / InRadius / IsFriend`(bool,默认 0)
   - `autoTeleportForLevel`、`autoUpgradeEquip`、`equipmentPersistence`(bool)
   - `botActiveAlone`(uint32 百分比)、`syncLevelWithPlayers`(bool)、`randomBotFixedLevel`(int)
2. **符号补回**:
   - `PlayerbotAI::IsInRealGuild()`(R6)
   - `PlayerHasFlag::IsCapturingFlag()`(R16,按战场旗 aura 实现)
   - `FleeManager`(R14,简化版或内联实现)
   - `AutoScaleActivity()` / `GetFixedBotNumer()`(R13)
3. 参考实现:上游 `liyunfan1223/azerothcore-wotlk` 与 `alexkulya/pandaria_5.4.8` 的 mod-playerbots 原始版本中同名函数。

---

## 6. 编译与部署流程

```bash
# 1. 全量重建模块库
MSYS_NO_PATHCONV=1 "/c/Program Files/Microsoft Visual Studio/2022/Community/MSBuild/Current/Bin/MSBuild.exe" \
  "E:/GitHub/pandaria_5.4.8/build/modules/modules.vcxproj" /t:Rebuild \
  /p:Configuration=Release /p:Platform=x64 /m /v:minimal /nologo

# 2. 重新链接 worldserver
MSYS_NO_PATHCONV=1 "/c/Program Files/Microsoft Visual Studio/2022/Community/MSBuild/Current/Bin/MSBuild.exe" \
  "E:/GitHub/pandaria_5.4.8/build/src/server/worldserver/worldserver.vcxproj" /t:Rebuild \
  /p:Configuration=Release /p:Platform=x64 /m /v:minimal /nologo

# 3. 部署(备份旧版)
cp /f/pandaria_5.4.8_Release/worldserver.exe /f/pandaria_5.4.8_Release/worldserver.exe.bak
cp /e/GitHub/pandaria_5.4.8/build/bin/Release/worldserver.exe /f/pandaria_5.4.8_Release/worldserver.exe

# 4. 验证
#    - 启动 worldserver 无报错
#    - 观察日志:轮换登出/新 bot 登录日志出现
```

验证要求:每次恢复只允许出现 **0 error**;warning 允许但需与本次改动无直接关联。

---

## 7. 回滚

- 二进制:`/f/pandaria_5.4.8_Release/worldserver.exe.bak`(每次部署前生成,保留最近一份)
- 代码:`git revert <commit>` 或 `git checkout -- <file>`
- 数据库(文本库):`ai_playerbot_texts` 全量重导 `modules/mod_playerbots/data/sql/playerbots/base/ai_playerbot_texts.sql`

---

## 8. 建议执行顺序

1. **P0 批次**(R1-R5,每项独立编译验证,风险低):登出冷却 → LFG 活跃 → 开锁剥皮 → 被控检查 → 灵魂碎片
2. **P1 批次**(R6-R12,补配置项后逐项恢复):真人公会 → 邻近活跃 → 升级换装 → 玩家登录 bot → 正常登出(重点回归)→ idleBot → 防拥挤
3. **P2 批次**(R13-R18,按需):Flee 逃跑 → 战场功能 → 等级同步 → 副本策略 → 活跃百分比(影响全局,最后)

> 建议每批次结束打一个 tag/commit,便于定位回归。
