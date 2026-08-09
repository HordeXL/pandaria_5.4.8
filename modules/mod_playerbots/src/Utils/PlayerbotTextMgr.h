#ifndef _PLAYERBOT_TEXT_MGR_H
#define _PLAYERBOT_TEXT_MGR_H

#include "Common.h"
#include <map>
#include <mutex>
#include <string>
#include <vector>

class Player;

struct BotTextEntry
{
    uint32 id;
    std::string text;
    uint8 sayType;
    uint8 replyType;
};

class PlayerbotTextMgr
{
public:
    PlayerbotTextMgr() = default;

    static PlayerbotTextMgr* instance()
    {
        static PlayerbotTextMgr instance;
        return &instance;
    }

    void Initialize();

    std::string GetRandomText(const std::string& name);

    bool HasText(const std::string& name) const { return _texts.count(name) > 0; }

    // Replaces chat placeholders (%item_link, %quest_link, %zone_name, %my_class,
    // %my_race, %my_level, %victim_name, %instance_name, %my_role, %other_name,
    // %category, and legacy printf-style %s) with real values. zhCN names are
    // taken from locale data when available, otherwise English fallback is used.
    static void ReplaceChatPlaceholders(std::string& text, Player* bot, std::string const& targetName = "");

private:
    mutable std::mutex _lock;
    std::map<std::string, std::vector<BotTextEntry>> _texts;
};

#define sPlayerbotTextMgr PlayerbotTextMgr::instance()

#endif
