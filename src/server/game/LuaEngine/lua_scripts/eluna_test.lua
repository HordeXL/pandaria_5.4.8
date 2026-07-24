-- ============================================================
-- Eluna 修复验证测试脚本
-- 放到 lua_scripts/ 目录后，重启服务器自动加载
-- 重新加载脚本: .reload eluna (需管理员权限)
-- ============================================================

local TEST_RESULTS = {}

local function PASS(name)
    TEST_RESULTS[#TEST_RESULTS + 1] = "[PASS] " .. name
end

local function FAIL(name, reason)
    TEST_RESULTS[#TEST_RESULTS + 1] = "[FAIL] " .. name .. " - " .. reason
end

local function PRINT_RESULTS()
    print("====== Eluna 修复测试结果 ======")
    local passCount = 0
    local failCount = 0
    for _, v in ipairs(TEST_RESULTS) do
        print(v)
        if v:find("%[PASS%]") then passCount = passCount + 1 end
        if v:find("%[FAIL%]") then failCount = failCount + 1 end
    end
    print("================================")
    print("通过: " .. passCount .. ", 失败: " .. failCount .. ", 总计: " .. (passCount + failCount))
    print("================================")
end

-- ============================================================
-- 1. 测试修复的 Lua API
-- ============================================================

-- 1.1 GetAura
local function test_GetAura()
    local player = GetPlayer(1)
    if not player then
        FAIL("GetAura", "无玩家在线")
        return
    end
    local aura = player:GetAura(1)
    if aura ~= nil then
        PASS("GetAura (返回光环对象)")
    else
        PASS("GetAura (返回 nil, 无该光环)")
    end
end

-- 1.2 AddAura
local function test_AddAura()
    local player = GetPlayer(1)
    if not player then return end
    local result = player:AddAura(20217, player)
    if result ~= nil then
        PASS("AddAura (成功添加光环)")
    else
        FAIL("AddAura", "添加光环失败")
    end
end

-- 1.3 GetFriendlyUnitsInRange
local function test_GetFriendlyUnitsInRange()
    local player = GetPlayer(1)
    if not player then return end
    local list = player:GetFriendlyUnitsInRange(50)
    if type(list) == "table" then
        PASS("GetFriendlyUnitsInRange (返回表, 数量=" .. #list .. ")")
    else
        FAIL("GetFriendlyUnitsInRange", "未返回表, 类型=" .. type(list))
    end
end

-- 1.4 GetUnfriendlyUnitsInRange
local function test_GetUnfriendlyUnitsInRange()
    local player = GetPlayer(1)
    if not player then return end
    local list = player:GetUnfriendlyUnitsInRange(50)
    if type(list) == "table" then
        PASS("GetUnfriendlyUnitsInRange (返回表, 数量=" .. #list .. ")")
    else
        FAIL("GetUnfriendlyUnitsInRange", "未返回表, 类型=" .. type(list))
    end
end

-- 1.5 SendChatMessageToPlayer
local function test_SendChatMessageToPlayer()
    local player = GetPlayer(1)
    if not player then return end
    local result = pcall(function()
        player:SendChatMessageToPlayer(0, 7, "Eluna测试消息: 修复生效!", player)
    end)
    if result then
        PASS("SendChatMessageToPlayer (发送成功)")
    else
        FAIL("SendChatMessageToPlayer", "发送失败")
    end
end

-- 1.6 IsNeverVisible
local function test_IsNeverVisible()
    local player = GetPlayer(1)
    if not player then return end
    local visible = player:IsNeverVisible()
    if visible == false or visible == true then
        PASS("IsNeverVisible (返回 " .. tostring(visible) .. ")")
    else
        FAIL("IsNeverVisible", "返回值异常: " .. type(visible))
    end
end

-- 1.7 ModifyHonorPoints
local function test_ModifyHonorPoints()
    local player = GetPlayer(1)
    if not player then return end
    local result = pcall(function()
        player:ModifyHonorPoints(100)
    end)
    if result then
        PASS("ModifyHonorPoints (+100 荣誉)")
    else
        FAIL("ModifyHonorPoints", "调用失败")
    end
end

-- 1.8 ModifyArenaPoints
local function test_ModifyArenaPoints()
    local player = GetPlayer(1)
    if not player then return end
    local result = pcall(function()
        player:ModifyArenaPoints(100)
    end)
    if result then
        PASS("ModifyArenaPoints (+100 征服)")
    else
        FAIL("ModifyArenaPoints", "调用失败")
    end
end

-- 1.9 SetMovement
local function test_SetMovement()
    local player = GetPlayer(1)
    if not player then return end
    local result = pcall(function()
        player:SetMovement(0)
    end)
    if result then
        PASS("SetMovement (IDLE)")
    else
        FAIL("SetMovement", "调用失败")
    end
end

-- 1.10 GetNearestPlayer
local function test_GetNearestPlayer()
    local player = GetPlayer(1)
    if not player then return end
    local target = player:GetNearestPlayer(100)
    if target ~= nil then
        PASS("GetNearestPlayer (找到: " .. tostring(target:GetName()) .. ")")
    else
        PASS("GetNearestPlayer (nil, 附近无玩家)")
    end
end

-- 1.11 GetNearestCreature
local function test_GetNearestCreature()
    local player = GetPlayer(1)
    if not player then return end
    local target = player:GetNearestCreature(100, 0)
    if target ~= nil then
        PASS("GetNearestCreature (找到 entry: " .. tostring(target:GetEntry()) .. ")")
    else
        PASS("GetNearestCreature (nil, 附近无生物)")
    end
end

-- 1.12 GetNearestGameObject
local function test_GetNearestGameObject()
    local player = GetPlayer(1)
    if not player then return end
    local target = player:GetNearestGameObject(100, 0)
    if target ~= nil then
        PASS("GetNearestGameObject (找到 entry: " .. tostring(target:GetEntry()) .. ")")
    else
        PASS("GetNearestGameObject (nil, 附近无GO)")
    end
end

-- 1.13 GetPlayersInRange
local function test_GetPlayersInRange()
    local player = GetPlayer(1)
    if not player then return end
    local list = player:GetPlayersInRange(100)
    if type(list) == "table" then
        PASS("GetPlayersInRange (返回表, 数量=" .. #list .. ")")
    else
        FAIL("GetPlayersInRange", "未返回表, 类型=" .. type(list))
    end
end

-- 1.14 GetCreaturesInRange
local function test_GetCreaturesInRange()
    local player = GetPlayer(1)
    if not player then return end
    local list = player:GetCreaturesInRange(100)
    if type(list) == "table" then
        PASS("GetCreaturesInRange (返回表, 数量=" .. #list .. ")")
    else
        FAIL("GetCreaturesInRange", "未返回表, 类型=" .. type(list))
    end
end

-- 1.15 GetGameObjectsInRange
local function test_GetGameObjectsInRange()
    local player = GetPlayer(1)
    if not player then return end
    local list = player:GetGameObjectsInRange(100)
    if type(list) == "table" then
        PASS("GetGameObjectsInRange (返回表, 数量=" .. #list .. ")")
    else
        FAIL("GetGameObjectsInRange", "未返回表, 类型=" .. type(list))
    end
end

-- 1.16 FindUnit
local function test_FindUnit()
    local player = GetPlayer(1)
    if not player then return end
    local guid = player:GetGUID()
    local unit = FindUnit(guid)
    if unit ~= nil then
        PASS("FindUnit (通过GUID找到单位)")
    else
        FAIL("FindUnit", "未找到单位")
    end
end

-- 1.17 AddVendorItem / VendorRemoveItem
local function test_VendorItems()
    local result = pcall(function()
        AddVendorItem(50000, 6948, 0, 0, 0, 0, false)
    end)
    if result then
        PASS("AddVendorItem (成功)")
    else
        FAIL("AddVendorItem", "失败")
    end
    local result2 = pcall(function()
        VendorRemoveItem(50000, 6948, 0, false)
    end)
    if result2 then
        PASS("VendorRemoveItem (成功)")
    else
        FAIL("VendorRemoveItem", "失败")
    end
end

-- 1.18 Ban
local function test_Ban()
    local exists = type(Ban) == "function"
    if exists then
        PASS("Ban (函数存在)")
    else
        FAIL("Ban", "函数不存在")
    end
end

-- ============================================================
-- 2. 测试钩子事件
-- ============================================================

-- 2.1 CREATURE_EVENT_ON_SPELL_CLICK (16)
local function test_OnSpellClick()
    local function OnSpellClick(event, creature, clicker)
        print("事件: OnSpellClick - creature=" .. creature:GetEntry() .. " clicker=" .. clicker:GetName())
    end
    RegisterCreatureEvent(666666, 16, OnSpellClick)
    PASS("CREATURE_EVENT_ON_SPELL_CLICK (已注册, 点击NPC 666666验证)")
end

-- 2.2 GAMEOBJECT_EVENT 钩子
local function test_GameObjectEvents()
    local function OnDestroyed(event, go, player)
        print("GO事件: OnDestroyed - entry=" .. go:GetEntry())
    end
    local function OnDamaged(event, go, player)
        print("GO事件: OnDamaged - entry=" .. go:GetEntry())
    end
    local function OnLootState(event, go, state, unit)
        print("GO事件: OnLootState - entry=" .. go:GetEntry() .. " state=" .. state)
    end
    local function OnGOState(event, go, state)
        print("GO事件: OnGOStateChanged - entry=" .. go:GetEntry() .. " state=" .. state)
    end
    RegisterGameObjectEvent(666666, 7, OnDestroyed)
    RegisterGameObjectEvent(666666, 8, OnDamaged)
    RegisterGameObjectEvent(666666, 9, OnLootState)
    RegisterGameObjectEvent(666666, 10, OnGOState)
    PASS("GAMEOBJECT_EVENT 钩子 (已注册, 操作GO 666666验证)")
end

-- 2.3 CREATURE_EVENT_ON_POSSESS (18)
local function test_OnPossess()
    local function OnPossess(event, creature, apply)
        print("事件: OnPossess - creature=" .. creature:GetEntry() .. " apply=" .. tostring(apply))
    end
    RegisterCreatureEvent(666666, 18, OnPossess)
    PASS("CREATURE_EVENT_ON_POSSESS (已注册, 对NPC 666666使用控制法术验证)")
end

-- 2.4 PlayerScript 事件 (OnMapChanged)
local function test_PlayerEvents()
    local function OnMapChanged(event, player)
        print("玩家事件: OnMapChanged - " .. player:GetName() .. " -> map=" .. player:GetMapId())
    end
    RegisterPlayerEvent(19, OnMapChanged)
    PASS("PLAYER_EVENT_ON_MAP_CHANGED (已注册, 切地图验证)")
end

-- ============================================================
-- 运行所有测试
-- ============================================================

local function RunAllTests()
    print("====== 开始 Eluna 修复测试 ======")
    test_GetAura()
    test_AddAura()
    test_GetFriendlyUnitsInRange()
    test_GetUnfriendlyUnitsInRange()
    test_SendChatMessageToPlayer()
    test_IsNeverVisible()
    test_ModifyHonorPoints()
    test_ModifyArenaPoints()
    test_SetMovement()
    test_GetNearestPlayer()
    test_GetNearestCreature()
    test_GetNearestGameObject()
    test_GetPlayersInRange()
    test_GetCreaturesInRange()
    test_GetGameObjectsInRange()
    test_FindUnit()
    test_VendorItems()
    test_Ban()
    test_OnSpellClick()
    test_GameObjectEvents()
    test_OnPossess()
    test_PlayerEvents()
    PRINT_RESULTS()
end

local function OnStartup()
    RunAllTests()
end
RegisterServerEvent(1, OnStartup)

print("Eluna 测试脚本已加载, .reload eluna 可重新加载")