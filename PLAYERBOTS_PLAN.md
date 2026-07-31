# PlayerBots 移植修复规划 — 逐步编译验证版

> 项目: `alexkulya/pandaria_5.4.8` (WoW 5.4.8)
> 分支: `playerbots`
> 构建目标: `modules`（静态库，含 `mod_playerbots`）
> 验证命令: `cmake --build . --target modules --config Release 2>&1 | grep -E "error|warning|modules.vcxproj ->"`
> 当前状态: CMake 配置通过，编译有 3 类错误

---

## 如何阅读本规划

每个修复条目包含：
- **目标错误**：编译时看到的错误信息
- **根因**：为什么会出现
- **操作**：精确的修改步骤
- **验证**：修改后运行什么命令确认

建议按 Phase 顺序执行，每个 Phase 结束时编译应完全通过（零 error）。

---

## Phase 1 — 模块编译通过

### 1.1 补全 Include 路径

#### 1.1.1 `Reference.h` / `RefManager.h` 找不到

**错误信息**：
```
src/server/game/Movement/FollowerReference.h(21): error C1083: 无法打开包括文件: “Reference.h”
src/server/game/Grids/GridRefManager.h(21): error C1083: 无法打开包括文件: “RefManager.h”
```

**根因**：`FollowerReference.h` 包含 `#include "Reference.h"`，`Reference.h` 实际在 `src/server/game/Dynamic/` 目录。`GridRefManager.h` 包含 `#include "RefManager.h"`，实际在 `src/server/game/Grids/` 目录。模块的 include 路径中没有这些目录。

**操作**：编辑 `modules/CMakeLists.txt`，在 `target_include_directories(modules PRIVATE ...)` 块中添加：
```cmake
${CMAKE_SOURCE_DIR}/src/server/game/Dynamic
${CMAKE_SOURCE_DIR}/src/server/game/Grids
${CMAKE_SOURCE_DIR}/src/server/game/Movement
${CMAKE_SOURCE_DIR}/src/server/game/Entities/Object
${CMAKE_SOURCE_DIR}/src/server/game/Entities/Player
${CMAKE_SOURCE_DIR}/src/server/game/Entities/Unit
${CMAKE_SOURCE_DIR}/src/server/game/Entities/Creature
${CMAKE_SOURCE_DIR}/src/server/game/Globals
${CMAKE_SOURCE_DIR}/src/server/game/Groups
${CMAKE_SOURCE_DIR}/src/server/game/Accounts
${CMAKE_SOURCE_DIR}/src/server/game/Spells
${CMAKE_SOURCE_DIR}/src/server/game/Scripting
${CMAKE_SOURCE_DIR}/src/server/game/Server
${CMAKE_SOURCE_DIR}/src/server/game/Chat
${CMAKE_SOURCE_DIR}/src/server/game/Handlers
${CMAKE_SOURCE_DIR}/src/server/game/DataStores
${CMAKE_SOURCE_DIR}/src/server/game/Miscellaneous
${CMAKE_SOURCE_DIR}/src/server/game/Entities/GameObject
${CMAKE_SOURCE_DIR}/src/server/game/Entities/Item
${CMAKE_SOURCE_DIR}/src/server/game/Entities/Pet
${CMAKE_SOURCE_DIR}/src/server/game/Battlegrounds
${CMAKE_SOURCE_DIR}/src/server/game/AI
${CMAKE_SOURCE_DIR}/src/server/game/Guilds
${CMAKE_SOURCE_DIR}/src/server/game/OutdoorPvP
${CMAKE_SOURCE_DIR}/src/server/game/Combat
${CMAKE_SOURCE_DIR}/src/server/game/Conditions
${CMAKE_SOURCE_DIR}/src/server/game/Events
${CMAKE_SOURCE_DIR}/src/server/game/Instances
${CMAKE_SOURCE_DIR}/src/server/game/Maps
${CMAKE_SOURCE_DIR}/src/server/game/Loot
${CMAKE_SOURCE_DIR}/src/server/game/Pools
${CMAKE_SOURCE_DIR}/src/server/game/Reputation
${CMAKE_SOURCE_DIR}/src/server/game/Skills
${CMAKE_SOURCE_DIR}/src/server/game/Weather
${CMAKE_SOURCE_DIR}/src/server/game/World
${CMAKE_SOURCE_DIR}/src/server/game/Tools
${CMAKE_SOURCE_DIR}/src/server/game/Achievements
${CMAKE_SOURCE_DIR}/src/server/game/Addons
${CMAKE_SOURCE_DIR}/src/server/game/Calendar
${CMAKE_SOURCE_DIR}/src/server/game/BattlePet
${CMAKE_SOURCE_DIR}/src/server/game/BattlePay
${CMAKE_SOURCE_DIR}/src/server/game/Anticheat
${CMAKE_SOURCE_DIR}/src/server/game/CustomLogs
${CMAKE_SOURCE_DIR}/src/server/game/CustomTransmogrification
${CMAKE_SOURCE_DIR}/src/server/game/DungeonFinding
${CMAKE_SOURCE_DIR}/src/server/game/LuaEngine
${CMAKE_SOURCE_DIR}/src/server/game/Warden
${CMAKE_SOURCE_DIR}/src/server/game/Vignette
${CMAKE_SOURCE_DIR}/src/server/game/BlackMarket
${CMAKE_SOURCE_DIR}/src/server/game/AuctionHouse
${CMAKE_SOURCE_DIR}/src/server/game/Mails
${CMAKE_SOURCE_DIR}/src/server/game/Tickets
${CMAKE_SOURCE_DIR}/src/server/game/Scenarios
${CMAKE_SOURCE_DIR}/src/server/game/Services
${CMAKE_SOURCE_DIR}/src/server/game/LookingForGroup
${CMAKE_SOURCE_DIR}/src/server/game/Texts
${CMAKE_SOURCE_DIR}/src/server/game/Opcodes
${CMAKE_SOURCE_DIR}/src/server/game/PrecompiledHeaders
${CMAKE_SOURCE_DIR}/src/server/game/Server/Protocol
${CMAKE_SOURCE_DIR}/src/server/game/Entities/DynamicObject
${CMAKE_SOURCE_DIR}/src/server/game/Entities/Item/Container
${CMAKE_SOURCE_DIR}/src/server/game/Entities/Object/Updates
${CMAKE_SOURCE_DIR}/src/server/game/Grids/Cells
${CMAKE_SOURCE_DIR}/src/server/game/Grids/Notifiers
${CMAKE_SOURCE_DIR}/src/server/game/Movement/MovementGenerators
${CMAKE_SOURCE_DIR}/src/server/game/Movement/Spline
${CMAKE_SOURCE_DIR}/src/server/game/Movement/Waypoints
${CMAKE_SOURCE_DIR}/src/server/game/AuctionHouse/AuctionHouseBot
${CMAKE_SOURCE_DIR}/src/server/game/Battlegrounds/Zones
${CMAKE_SOURCE_DIR}/src/server/game/Chat/Channels
${CMAKE_SOURCE_DIR}/src/server/game/Warden/Modules
${CMAKE_SOURCE_DIR}/src/server/game/Battlefield
${CMAKE_SOURCE_DIR}/src/server/game/Battlefield/Zones
${CMAKE_SOURCE_DIR}/src/server/game/Spells/Auras
${CMAKE_SOURCE_DIR}/src/server/game/Entities/AreaTrigger
${CMAKE_SOURCE_DIR}/src/server/game/Entities/Corpse
${CMAKE_SOURCE_DIR}/src/server/game/Entities/Transport
${CMAKE_SOURCE_DIR}/src/server/game/Entities/Vehicle
${CMAKE_SOURCE_DIR}/src/server/game/AI/CoreAI
${CMAKE_SOURCE_DIR}/src/server/game/AI/ScriptedAI
${CMAKE_SOURCE_DIR}/src/server/game/AI/SmartScripts
${CMAKE_SOURCE_DIR}/src/server/game/LuaEngine
${CMAKE_SOURCE_DIR}/src/server/game/Movement/FollowerReference.h
```

**验证**：重新运行 cmake 和编译，`Reference.h` 和 `RefManager.h` 错误应消失。

---

### 1.2 Boost.Asio 缺失

#### 1.2.1 `boost/asio.hpp` 找不到

**错误信息**：
```
src/server/shared/Threading/TaskMgr.h(24): error C1083: 无法打开包括文件: “boost/asio.hpp”
```

**根因**：`TaskMgr.h` 是 Legends-of-Azeroth 新增的文件，使用了 Boost.Asio。当前环境的 Boost 1.91.0 可能未包含 Asio 库，或路径未正确配置。

**操作**：检查 Asio 是否可用：
```bash
find "E:/Tools/boost_1_91_0" -name "asio.hpp" 2>/dev/null
```

**方案 A**（如果 Asio 存在）：在 `modules/CMakeLists.txt` 的 include 路径中添加：
```cmake
${CMAKE_SOURCE_DIR}/dep/boost  # 或 Boost 的 asio 头文件路径
```

**方案 B**（如果 Asio 不存在）：修改 `TaskMgr.h` 注释掉 asio 引用，或添加条件编译：
```cpp
// 在 TaskMgr.h 顶部添加
#ifndef BOOST_ASIO_HPP
// 如果 Boost.Asio 不可用，提供空实现或替代
#endif
```

**方案 C**（推荐临时方案）：在 `modules/CMakeLists.txt` 中添加 Asio 的下载或查找逻辑：
```cmake
find_path(BOOST_ASIO_INCLUDE_DIR boost/asio.hpp PATHS ${Boost_INCLUDE_DIRS})
if(BOOST_ASIO_INCLUDE_DIR)
  include_directories(${BOOST_ASIO_INCLUDE_DIR})
endif()
```

**验证**：重新编译，`boost/asio.hpp` 错误应消失。

---

### 1.3 ASSERT 宏找不到

#### 1.3.1 `ASSERT` 未声明

**错误信息**：
```
src/server/shared/Packets/ByteBuffer.h(76): error C3861: “ASSERT”: 找不到标识符
```

**根因**：`ASSERT` 宏定义在 `Debugging/Errors.h` 中，该文件在 `src/server/shared/Debugging/` 目录。模块的 include 路径中缺少此目录。

**操作**：编辑 `modules/CMakeLists.txt`，添加：
```cmake
${CMAKE_SOURCE_DIR}/src/server/shared/Debugging
```

**验证**：重新编译，`ASSERT` 错误应消失。

---

### 1.4 代码兼容性修复

#### 1.4.1 `class ObjectGuid` vs `struct ObjectGuid`

**错误信息**（warning C4099，但可能导致后续 error）：
```
warning C4099: “ObjectGuid”: 类型名称以前使用“struct”现在使用的是“class”
```

**根因**：`ObjectGuid` 在 `ByteBuffer.h` 中定义为 `struct ObjectGuid`，但 `Event.h` 中前向声明为 `class ObjectGuid`。

**操作**：编辑 `modules/mod_playerbots/src/strategy/Event.h`，将第11行的：
```cpp
class ObjectGuid;
```
改为：
```cpp
struct ObjectGuid;
```

**验证**：重新编译，C4099 警告应消失。

---

#### 1.4.2 `MAX_SPECIALIZATIONS` 未定义

**错误信息**：
```
PlayerbotAIConfig.h(74): error C2065: “MAX_SPECIALIZATIONS”: 未声明的标识符
```

**根因**：`PlayerbotAIConfig.h` 使用 `MAX_SPECIALIZATIONS` 常量（来自 Legends-of-Azeroth 的客户端数据定义），但本项目没有此常量。

**操作**：编辑 `modules/mod_playerbots/src/Utils/PlayerbotAIConfig.h`，在 `#include "SharedDefines.h"` 之后添加：
```cpp
#ifndef MAX_SPECIALIZATIONS
#define MAX_SPECIALIZATIONS 4
#endif
```

**验证**：重新编译，`MAX_SPECIALIZATIONS` 错误应消失。

---

#### 1.4.3 `Utf8toWStr` / `WStrToUtf8` / `wcharToUpperOnlyLatin` 找不到

**错误信息**：
```
AccountMgr.h(94): error C3861: “Utf8toWStr”: 找不到标识符
AccountMgr.h(97): error C2065: “wcharToUpperOnlyLatin”: 未声明的标识符
AccountMgr.h(99): error C3861: “WStrToUtf8”: 找不到标识符
```

**根因**：`AccountMgr.h` 中使用了字符串转换函数，这些函数定义在 `StringConvert.h`/`UTF8.h` 中。模块的 include 路径中缺少这些头文件。

**操作**：先检查这些函数在哪里定义：
```bash
grep -rn "Utf8toWStr\|WStrToUtf8\|wcharToUpperOnlyLatin" src/server/shared/ | head -10
```

如果它们存在但路径未包含，添加对应路径。如果不存在，在 `modules/CMakeLists.txt` 中补充：
```cmake
${CMAKE_SOURCE_DIR}/src/server/shared/Utilities
```

**验证**：重新编译，相关错误应消失。

---

#### 1.4.4 其他 `#include` 找不到

**可能出现的其他错误**：
```
error C1083: 无法打开包括文件: “XXX.h”
```

**操作**：对于每个找不到的 `XXX.h`，执行：
```bash
find "E:/GitHub/pandaria_5.4.8/src" -name "XXX.h" 2>/dev/null
```
如果能找到，在 `modules/CMakeLists.txt` 中添加其父目录到 include 路径。
如果找不到，检查该头文件是否来自 Legends-of-Azeroth 新增文件，需要自己创建。

**预期需要补充的路径**（根据 game 库的头文件依赖关系）：
```cmake
${CMAKE_SOURCE_DIR}/src/server/game/Entities/AreaTrigger
${CMAKE_SOURCE_DIR}/src/server/game/Entities/Corpse
${CMAKE_SOURCE_DIR}/src/server/game/Entities/Transport
${CMAKE_SOURCE_DIR}/src/server/game/Entities/Vehicle
${CMAKE_SOURCE_DIR}/src/server/game/AI/CoreAI
${CMAKE_SOURCE_DIR}/src/server/game/AI/ScriptedAI
${CMAKE_SOURCE_DIR}/src/server/game/AI/SmartScripts
${CMAKE_SOURCE_DIR}/src/server/game/LuaEngine
```

---

## Phase 2 — 核心 API 补齐

### 2.1 检查 PlayerBots 使用的核心 API

**操作**：在模块编译通过后，搜索 PlayerBots 中使用但未定义的核心 API：
```bash
grep -rn "sObjectMgr->\|sCharacterCache\|BotCanUseItem\|IsWeapon\|GetAllCreatureData\|GetAllGOData\|GetTrainer" modules/mod_playerbots/src/ | grep -v ".h:" | head -20
```

---

### 2.2 补充缺失方法

按编译错误逐个补充，典型模式：

```cpp
// 在对应类的 .h 文件中添加声明
// 在对应类的 .cpp 文件中添加实现
```

**Player 类扩展**（`src/server/game/Entities/Player/Player.h`）：
```cpp
// 添加
InventoryResult BotCanUseItem(ItemTemplate const* item) const;
```

**ItemTemplate 类扩展**（`src/server/game/Entities/Item/ItemTemplate.h`）：
```cpp
// 添加
bool IsWeapon() const;
bool IsWeaponVellum() const;
```

**ObjectMgr 类扩展**（`src/server/game/Globals/ObjectMgr.h`）：
```cpp
// 添加
CreatureDataContainer const& GetAllCreatureData() const { return mCreatureDataStore; }
GameObjectDataContainer const& GetAllGOData() const { return mGameObjectDataStore; }
TrainerSpellData const* GetTrainer(uint32 id) const;
```

---

## Phase 3 — 链接 worldserver

### 3.1 确认 modules 链接到 worldserver

**检查**：`src/server/worldserver/CMakeLists.txt` 中是否已有：
```cmake
target_link_libraries(worldserver ... modules ...)
```

**操作**：如果缺少，在 `target_link_libraries(worldserver` 块中添加 `modules`。

### 3.2 确认 ModulesLoader 注册

**检查**：`src/server/scripts/ScriptLoader/ScriptLoader.cpp` 的 `AddScripts()` 函数中是否已有：
```cpp
#ifdef PLAYERBOTS
    AddModulesScripts();
#endif
```

---

## Phase 4 — 运行时验证

### 4.1 创建 playerbots 数据库

```sql
CREATE DATABASE IF NOT EXISTS mop_playerbots DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
```

### 4.2 导入 SQL 文件

按顺序导入：
```bash
# 基础表
mysql -u root -p mop_playerbots < modules/mod_playerbots/data/sql/playerbots/base/playerbots_database_full.sql
mysql -u root -p mop_playerbots < modules/mod_playerbots/data/sql/playerbots/base/ai_playerbot_texts.sql
mysql -u root -p mop_playerbots < modules/mod_playerbots/data/sql/playerbots/base/playerbots_travelnode.sql
mysql -u root -p mop_playerbots < modules/mod_playerbots/data/sql/playerbots/base/playerbots_travelnode_link.sql
mysql -u root -p mop_playerbots < modules/mod_playerbots/data/sql/playerbots/base/playerbots_travelnode_path.sql
mysql -u root -p mop_playerbots < modules/mod_playerbots/data/sql/playerbots/base/playerbots_zone_path.sql

# 字符表
mysql -u root -p characters < modules/mod_playerbots/data/sql/characters/playerbots_names.sql
mysql -u root -p characters < modules/mod_playerbots/data/sql/characters/playerbots_arena_team_names.sql
mysql -u root -p characters < modules/mod_playerbots/data/sql/characters/playerbots_guild_names.sql

# 世界表
mysql -u root -p world < modules/mod_playerbots/data/sql/world/world_charsections_dbc.sql
mysql -u root -p world < modules/mod_playerbots/data/sql/world/world_emotetextsound_dbc.sql
mysql -u root -p world < modules/mod_playerbots/data/sql/world/world_playerbots_rpg_races.sql

# 更新
mysql -u root -p mop_playerbots < modules/mod_playerbots/data/sql/playerbots/updates/db_playerbots/2024_08_07_00.sql
```

### 4.3 配置 playerbots.conf

```bash
cp modules/mod_playerbots/config/playerbots.conf.dist build/bin/Release/playerbots.conf
```

编辑 `playerbots.conf`，设置数据库连接：
```ini
PlayerbotsDatabaseInfo = "127.0.0.1;3306;root;root;mop_playerbots"
PlayerbotsDatabase.WorkerThreads = 1
PlayerbotsDatabase.SynchThreads = 1
```

在 `worldserver.conf` 中添加：
```ini
PlayerbotsDatabaseInfo = "127.0.0.1;3306;root;root;mop_playerbots"
PlayerbotsDatabase.WorkerThreads = 1
PlayerbotsDatabase.SynchThreads = 1
Logger.playerbots=3,Console Server
```

### 4.4 启动测试

```bash
cd build/bin/Release
./worldserver
```

观察启动日志，确认：
- `playerbots` 数据库成功连接
- 机器人数据加载完成
- 无崩溃或异常

---

## 常见问题速查

| 症状 | 可能原因 | 解决 |
|------|----------|------|
| cmake 找不到模块 | `PLAYERBOTS=0` | 用 `-DPLAYERBOTS=1` 重新 cmake |
| 编译 error C1083: XXX.h | include 路径缺少 | 找文件位置，加到 CMakeLists.txt |
| 编译 error C3861: 标识符 | 函数不存在 | 实现该函数或修改调用 |
| 链接 error LNK2019 | 函数声明了未实现 | 检查 .cpp 中是否有实现 |
| worldserver 启动崩溃 | 配置错误或 SQL 未导入 | 检查数据库和配置 |
| 机器人不出现 | 配置未启用或 DBC 问题 | 必须使用 enUS DBC |

---

## 逐次验证流程

每完成一个修复步骤后，运行：
```bash
cd build
cmake .. -DPLAYERBOTS=1
cmake --build . --target modules --config Release 2>&1 | grep -E "error C|modules.vcxproj ->"
```

直到输出中出现：
```
modules.vcxproj -> E:\GitHub\pandaria_5.4.8\build\modules\Release\modules.lib
```
即表示模块编译通过。