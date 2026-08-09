#include "PlayerbotTextMgr.h"

#include "DatabaseEnv.h"
#include "Log.h"
#include "Playerbots.h"

#include "Chat.h"
#include "Group.h"
#include "ItemPrototype.h"
#include "ObjectMgr.h"
#include "Player.h"
#include "QuestDef.h"
#include "SharedDefines.h"
#include "World.h"
#include "DBCStores.h"

void PlayerbotTextMgr::Initialize()
{
    uint32 oldMSTime = getMSTime();
    _texts.clear();

    QueryResult result = PlayerbotsDatabase.Query("SELECT id, name, text, say_type, reply_type FROM ai_playerbot_texts");
    if (!result)
    {
        TC_LOG_INFO("playerbots", ">> Loaded 0 bot texts (ai_playerbot_texts table is empty)");
        return;
    }

    uint32 count = 0;
    do
    {
        Field* fields = result->Fetch();
        BotTextEntry entry;
        entry.id = fields[0].GetUInt32();
        std::string name = fields[1].GetString();
        entry.text = fields[2].GetString();
        entry.sayType = fields[3].GetUInt8();
        entry.replyType = fields[4].GetUInt8();

        _texts[name].push_back(entry);
        count++;
    } while (result->NextRow());

    TC_LOG_INFO("playerbots", ">> Loaded %u bot texts in %u ms", count, GetMSTimeDiffToNow(oldMSTime));
}

std::string PlayerbotTextMgr::GetRandomText(const std::string& name)
{
    std::lock_guard<std::mutex> guard(_lock);
    auto it = _texts.find(name);
    if (it == _texts.end() || it->second.empty())
        return "";

    const auto& entries = it->second;
    uint32 idx = urand(0, entries.size() - 1);
    return entries[idx].text;
}

static std::string PlayerbotGetClassName(uint8 cls)
{
    switch (cls)
    {
        case CLASS_WARRIOR: return "战士";
        case CLASS_PALADIN: return "圣骑士";
        case CLASS_HUNTER: return "猎人";
        case CLASS_ROGUE: return "潜行者";
        case CLASS_PRIEST: return "牧师";
        case CLASS_DEATH_KNIGHT: return "死亡骑士";
        case CLASS_SHAMAN: return "萨满祭司";
        case CLASS_MAGE: return "法师";
        case CLASS_WARLOCK: return "术士";
        case CLASS_MONK: return "武僧";
        case CLASS_DRUID: return "德鲁伊";
        default: return "未知";
    }
}

static std::string PlayerbotGetRaceName(uint8 race)
{
    switch (race)
    {
        case RACE_HUMAN: return "人类";
        case RACE_ORC: return "兽人";
        case RACE_DWARF: return "矮人";
        case RACE_NIGHTELF: return "暗夜精灵";
        case RACE_UNDEAD_PLAYER: return "亡灵";
        case RACE_TAUREN: return "牛头人";
        case RACE_GNOME: return "侏儒";
        case RACE_TROLL: return "巨魔";
        case RACE_GOBLIN: return "地精";
        case RACE_BLOODELF: return "血精灵";
        case RACE_DRAENEI: return "德莱尼";
        case RACE_WORGEN: return "狼人";
        case RACE_PANDAREN_ALLIANCE:
        case RACE_PANDAREN_HORDE:
        case RACE_PANDAREN_NEUTRAL: return "熊猫人";
        default: return "未知";
    }
}

void PlayerbotTextMgr::ReplaceChatPlaceholders(std::string& text, Player* bot, std::string const& targetName)
{
    if (!bot || text.empty())
        return;

    // zhCN locale index (LOCALE_zhCN = 4); falls back to enUS / raw name when absent.
    static LocaleConstant const CHINESE_LOCALE = LOCALE_zhCN;

    auto replaceAll = [](std::string& str, std::string const& from, std::string const& to)
    {
        size_t pos = 0;
        while ((pos = str.find(from, pos)) != std::string::npos)
        {
            str.replace(pos, from.length(), to);
            pos += to.length();
        }
    };

    // %s - legacy printf-style placeholder: the person the bot is talking to
    if (text.find("%s") != std::string::npos)
        replaceAll(text, "%s", targetName.empty() ? "你" : targetName);

    // %item_link - a random item from the bot's inventory
    if (text.find("%item_link") != std::string::npos)
    {
        std::vector<Item*> items;
        for (uint8 i = EQUIPMENT_SLOT_START; i < EQUIPMENT_SLOT_END; ++i)
            if (Item* item = bot->GetItemByPos(INVENTORY_SLOT_BAG_0, i))
                items.push_back(item);
        for (uint8 i = INVENTORY_SLOT_ITEM_START; i < INVENTORY_SLOT_ITEM_END; ++i)
            if (Item* item = bot->GetItemByPos(INVENTORY_SLOT_BAG_0, i))
                items.push_back(item);

        if (!items.empty())
        {
            Item* item = items[urand(0, items.size() - 1)];
            ItemTemplate const* proto = item->GetTemplate();
            if (proto)
            {
                std::string itemName = proto->Name1;
                if (ItemLocale const* il = sObjectMgr->GetItemLocale(proto->ItemId))
                    if (il->Name.size() > CHINESE_LOCALE && !il->Name[CHINESE_LOCALE].empty())
                        itemName = il->Name[CHINESE_LOCALE];
                std::ostringstream link;
                link << "|c" << std::hex << ItemQualityColors[proto->Quality] << std::dec
                    << "|Hitem:" << proto->ItemId << ":0:0:0:0:0:0:0:0:0|h[" << itemName << "]|h|r";
                replaceAll(text, "%item_link", link.str());
            }
            else
                replaceAll(text, "%item_link", "some junk");
        }
        else
            replaceAll(text, "%item_link", "some junk");
    }

    // %quest_link - a random quest from the bot's quest log
    if (text.find("%quest_link") != std::string::npos)
    {
        std::vector<uint32> questIds;
        for (uint16 slot = 0; slot < MAX_QUEST_LOG_SIZE; ++slot)
        {
            uint32 questId = bot->GetQuestSlotQuestId(slot);
            if (questId)
                questIds.push_back(questId);
        }

        if (!questIds.empty())
        {
            uint32 questId = questIds[urand(0, questIds.size() - 1)];
            Quest const* quest = sObjectMgr->GetQuestTemplate(questId);
            if (quest)
            {
                std::string questName = quest->GetTitle();
                if (QuestLocale const* ql = sObjectMgr->GetQuestLocale(questId))
                    if (ql->Title.size() > CHINESE_LOCALE && !ql->Title[CHINESE_LOCALE].empty())
                        questName = ql->Title[CHINESE_LOCALE];
                std::ostringstream link;
                link << "|cff808080|Hquest:" << questId << ":" << quest->GetQuestLevel() << "|h[" << questName << "]|h|r";
                replaceAll(text, "%quest_link", link.str());
            }
            else
                replaceAll(text, "%quest_link", "a quest");
        }
        else
            replaceAll(text, "%quest_link", "a quest");
    }

    // %zone_name - the bot's current zone
    if (text.find("%zone_name") != std::string::npos)
    {
        uint32 zoneId = bot->GetZoneId();
        AreaTableEntry const* zone = sAreaTableStore.LookupEntry(zoneId);
        std::string zoneName;
        if (zone)
        {
            zoneName = zone->area_name[CHINESE_LOCALE];
            if (zoneName.empty())
                zoneName = zone->area_name[0];
        }
        if (zoneName.empty())
            zoneName = "未知";
        replaceAll(text, "%zone_name", zoneName);
    }

    // %my_class / %my_race / %my_level
    if (text.find("%my_class") != std::string::npos)
        replaceAll(text, "%my_class", PlayerbotGetClassName(bot->GetClass()));
    if (text.find("%my_race") != std::string::npos)
        replaceAll(text, "%my_race", PlayerbotGetRaceName(bot->GetRace()));
    if (text.find("%my_level") != std::string::npos)
        replaceAll(text, "%my_level", std::to_string(bot->GetLevel()));

    // %victim_name - current target or victim, zhCN creature name when available
    if (text.find("%victim_name") != std::string::npos)
    {
        Unit* target = bot->GetVictim();
        if (!target)
            target = bot->GetSelectedUnit();
        std::string name;
        if (target)
        {
            if (target->ToCreature())
            {
                name = target->GetName();
                uint32 entry = target->GetEntry();
                if (CreatureLocale const* cl = sObjectMgr->GetCreatureLocale(entry))
                    if (cl->Name.size() > CHINESE_LOCALE && !cl->Name[CHINESE_LOCALE].empty())
                        name = cl->Name[CHINESE_LOCALE];
            }
            else
                name = target->GetName();
        }
        else
            name = "一只怪物";
        replaceAll(text, "%victim_name", name);
    }

    // %instance_name - current map name (DBC multi-locale, zhCN preferred)
    if (text.find("%instance_name") != std::string::npos)
    {
        uint32 mapId = bot->GetMapId();
        MapEntry const* map = sMapStore.LookupEntry(mapId);
        std::string name;
        if (map)
        {
            name = map->name[CHINESE_LOCALE];
            if (name.empty())
                name = map->name[0];
        }
        if (name.empty())
            name = "the world";
        replaceAll(text, "%instance_name", name);
    }

    // %my_role - rough role detection from spec
    if (text.find("%my_role") != std::string::npos)
    {
        uint32 spec = bot->GetSpecialization();
        std::string role = "DPS";
        if (spec == SPEC_PRIEST_HOLY || spec == SPEC_PRIEST_DISCIPLINE ||
            spec == SPEC_PALADIN_HOLY || spec == SPEC_DRUID_RESTORATION ||
            spec == SPEC_SHAMAN_RESTORATION || spec == SPEC_MONK_MISTWEAVER)
            role = "治疗";
        else if (spec == SPEC_WARRIOR_PROTECTION || spec == SPEC_PALADIN_PROTECTION ||
            spec == SPEC_DRUID_FERAL || spec == SPEC_DEATH_KNIGHT_BLOOD ||
            spec == SPEC_MONK_BREWMASTER)
            role = "坦克";
        replaceAll(text, "%my_role", role);
    }

    // %other_name - a random group member
    if (text.find("%other_name") != std::string::npos)
    {
        std::string name;
        if (Group* group = bot->GetGroup())
        {
            for (GroupReference* gref = group->GetFirstMember(); gref; gref = gref->next())
            {
                Player* member = gref->GetSource();
                if (member && member != bot)
                {
                    name = member->GetName();
                    break;
                }
            }
        }
        if (name.empty())
            name = "someone";
        replaceAll(text, "%other_name", name);
    }

    // %category - a random activity word
    if (text.find("%category") != std::string::npos)
    {
        static std::vector<std::string> const categories = {
            "冒险", "任务", "探索", "打怪", "升级"
        };
        replaceAll(text, "%category", categories[urand(0, categories.size() - 1)]);
    }
}
