#ifndef _PLAYERBOT_TEXT_MGR_H
#define _PLAYERBOT_TEXT_MGR_H

#include "Common.h"
#include <map>
#include <mutex>
#include <string>
#include <vector>

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

private:
    mutable std::mutex _lock;
    std::map<std::string, std::vector<BotTextEntry>> _texts;
};

#define sPlayerbotTextMgr PlayerbotTextMgr::instance()

#endif
