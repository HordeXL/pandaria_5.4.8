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

#ifndef _PLAYERBOTSDATABASE_H
#define _PLAYERBOTSDATABASE_H

#include "DatabaseWorkerPool.h"
#include "MySQLConnection.h"

class PlayerbotsDatabaseConnection : public MySQLConnection
{
    public:
        PlayerbotsDatabaseConnection(MySQLConnectionInfo& connInfo, ConnectionFlags index)
            : MySQLConnection(connInfo, index) { }

        //- Loads database type specific prepared statements
        void DoPrepareStatements();
};

typedef DatabaseWorkerPool<PlayerbotsDatabaseConnection> PlayerbotsDatabaseWorkerPool;

enum PlayerbotsDatabaseStatements
{
    /*  Naming standard for defines:
        {DB}_{SEL/INS/UPD/DEL/REP}_{Summary of data changed}
    */

    PLAYERBOTS_DEL_RANDOM_BOTS_BY_OWNER,
    PLAYERBOTS_DEL_RANDOM_BOTS_BY_OWNER_AND_EVENT,
    PLAYERBOTS_UPD_RANDOM_BOTS,
    PLAYERBOTS_SEL_RANDOM_BOTS_BY_OWNER_AND_EVENT,
    PLAYERBOTS_SEL_RANDOM_BOTS_BY_OWNER_AND_BOT,
    PLAYERBOTS_INS_RANDOM_BOTS,
    PLAYERBOTS_SEL_CUSTOM_STRATEGY_BY_OWNER_AND_NAME,

    MAX_PLAYERBOTSDATABASE_STATEMENTS
};

#endif