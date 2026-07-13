/*
* This file is part of Project SkyFire https://www.projectskyfire.org.
* See LICENSE.md file for Copyright information
*
* Adapted for Pandaria 5.4.8 - all enums are already defined in the core.
*/

#ifndef ELUNA_COMPATIBILITY_H
#define ELUNA_COMPATIBILITY_H

// Pandaria 5.4.8 uses C++11/14 enums (not scoped enums like SkyFire).
// All TypeID, TempSummonType, GOState, LootState etc. are already
// defined globally, so no compatibility mappings are needed here.

#include "ObjectAccessor.h"

inline WorldObject* ElunaGetWorldObject(WorldObject const& context, uint64 guid)
{
    return ObjectAccessor::GetWorldObject(context, guid);
}

#endif