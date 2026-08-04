#include "PlayerbotTextMgr.h"

#include "DatabaseEnv.h"
#include "Log.h"
#include "Playerbots.h"

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
