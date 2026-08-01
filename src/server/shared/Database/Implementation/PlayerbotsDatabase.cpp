/*
* This file is part of the Pandaria 5.4.8 Project. See THANKS file for Copyright information
*
* This program is free software; you can redistribute it and/or modify it
* under the terms of the GNU General Public License as published by the
* Free Software Foundation; either version 2 of the License, or (at your
* option) any later version.
*
* This program is distributed in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
* FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
* more details.
*
* You should have received a copy of the GNU General Public License along
* with this program. If not, see <http://www.gnu.org/licenses/>.
*/

#include "PlayerbotsDatabase.h"

void PlayerbotsDatabaseConnection::DoPrepareStatements()
{
    if (!m_reconnecting)
        m_stmts.resize(MAX_PLAYERBOTSDATABASE_STATEMENTS);

    PrepareStatement(PLAYERBOTS_DEL_RANDOM_BOTS_BY_OWNER, "DELETE FROM playerbots_random_bots WHERE owner = ? AND bot = ?", CONNECTION_ASYNC);
    PrepareStatement(PLAYERBOTS_DEL_RANDOM_BOTS_BY_OWNER_AND_EVENT, "DELETE FROM playerbots_random_bots WHERE owner = ? AND bot = ? AND event = ?", CONNECTION_ASYNC);
    PrepareStatement(PLAYERBOTS_UPD_RANDOM_BOTS, "UPDATE playerbots_random_bots SET value = ? WHERE event = ? AND bot = ?", CONNECTION_ASYNC);
    PrepareStatement(PLAYERBOTS_SEL_RANDOM_BOTS_BY_OWNER_AND_EVENT, "SELECT bot, value, data FROM playerbots_random_bots WHERE owner = ? AND event = ?", CONNECTION_SYNCH);
    PrepareStatement(PLAYERBOTS_SEL_RANDOM_BOTS_BY_OWNER_AND_BOT, "SELECT event, value, time, validIn, data FROM playerbots_random_bots WHERE owner = ? AND bot = ?", CONNECTION_SYNCH);
    PrepareStatement(PLAYERBOTS_INS_RANDOM_BOTS, "INSERT INTO playerbots_random_bots (id, owner, bot, time, validIn, event, value, data) VALUES (?, 0, ?, ?, ?, ?, ?, ?)", CONNECTION_ASYNC);
    PrepareStatement(PLAYERBOTS_SEL_CUSTOM_STRATEGY_BY_OWNER_AND_NAME, "SELECT id, action_line FROM playerbots_custom_strategy WHERE owner = ? AND name = ? ORDER BY idx", CONNECTION_SYNCH);
}