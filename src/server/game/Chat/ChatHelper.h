/*
 * Copyright (C) 2016+ AzerothCore <www.azerothcore.org>, released under GNU GPL v2 license, you may redistribute it
 * and/or modify it under version 2 of the License, or (at your option), any later version.
 */

#ifndef __CHATHELPER_H
#define __CHATHELPER_H

#include "Common.h"
#include "SpellInfo.h"
#include <string>

class ChatHelper
{
public:
    static std::string FormatSpell(SpellInfo const* spellInfo)
    {
        if (!spellInfo)
            return "Unknown Spell";

        std::ostringstream out;
        out << "|cffffffff|Hspell:" << spellInfo->Id << "|h[" << spellInfo->SpellName << "]|h|r";
        return out.str();
    }
};

#endif