/*
 * Copyright (C) 2016+ AzerothCore <www.azerothcore.org>, released under GNU GPL v2 license, you may redistribute it
 * and/or modify it under version 2 of the License, or (at your option), any later version.
 */

#ifndef __CHARACTERCACHE_H
#define __CHARACTERCACHE_H

#include "Common.h"
#include "ByteBuffer.h"
#include "ObjectDefines.h"
#include <unordered_map>
#include <string>

struct CharacterCacheEntry
{
    uint32 accountId;
    std::string name;
    uint8 gender;
    uint8 race;
    uint8 playerClass;
    uint8 level;
};

class CharacterCache
{
private:
    std::unordered_map<uint32, CharacterCacheEntry> _cacheByGuidLow;
    std::unordered_map<uint32, uint32> _accountByGuid;

public:
    static CharacterCache* instance()
    {
        static CharacterCache instance;
        return &instance;
    }

    CharacterCache() {}
    ~CharacterCache() {}

    void AddCharacterCacheEntry(uint64 guid, uint32 accountId, std::string const& name, uint8 gender, uint8 race, uint8 playerClass, uint8 level)
    {
        uint32 guidLow = GUID_LOPART(guid);
        _cacheByGuidLow[guidLow] = { accountId, name, gender, race, playerClass, level };
        _accountByGuid[guidLow] = accountId;
    }

    uint32 GetCharacterAccountIdByGuid(uint64 guid) const
    {
        uint32 guidLow = GUID_LOPART(guid);
        auto itr = _accountByGuid.find(guidLow);
        if (itr != _accountByGuid.end())
            return itr->second;
        return 0;
    }

    void RemoveCharacterCacheEntry(uint64 guid)
    {
        uint32 guidLow = GUID_LOPART(guid);
        _cacheByGuidLow.erase(guidLow);
        _accountByGuid.erase(guidLow);
    }
};

#define sCharacterCache CharacterCache::instance()

#endif