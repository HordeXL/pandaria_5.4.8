# Copyright (C) 2024 Legends of Azeroth
# Module build system - auto-detects modules in subdirectories

# Temp file for generating ModulesLoader
set(MODULES_LOADER_TEMP "${CMAKE_BINARY_DIR}/ModulesLoader.cpp")
set(MODULES_LOADER_FINAL "${CMAKE_SOURCE_DIR}/modules/ModulesLoader.cpp")
set(MODULES_LOADER_TEMPLATE "${CMAKE_SOURCE_DIR}/modules/ModulesLoader.cpp.in.cmake")

# Function to get all subdirectories of a given directory
function(get_subdirectories result curdir)
    file(GLOB children LIST_DIRECTORIES true ${curdir}/*)
    set(subdirs "")
    foreach(child ${children})
        if(IS_DIRECTORY ${child})
            get_filename_component(folder_name ${child} NAME)
            list(APPEND subdirs ${folder_name})
        endif()
    endforeach()
    set(${result} ${subdirs} PARENT_SCOPE)
endfunction()

# Auto-detect modules (all subdirectories of modules/)
get_subdirectories(MODULE_DIRS ${CMAKE_CURRENT_SOURCE_DIR})

# Detect valid modules
set(VALID_MODULES "")
foreach(MODULE ${MODULE_DIRS})
    if(IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${MODULE})
        # Check if it contains .cpp or .h files
        file(GLOB_RECURSE MODULE_SRC_FILES "${CMAKE_CURRENT_SOURCE_DIR}/${MODULE}/*.cpp" "${CMAKE_CURRENT_SOURCE_DIR}/${MODULE}/*.h")
        if(MODULE_SRC_FILES)
            list(APPEND VALID_MODULES ${MODULE})
        endif()
    endif()
endforeach()

if(NOT PLAYERBOTS)
    list(REMOVE_ITEM VALID_MODULES "mod_playerbots")
endif()

message(STATUS "Modules : ${VALID_MODULES}")

# Add files to Visual Studio groups
set(MODULES_SOURCES "")
foreach(MODULE ${VALID_MODULES})
    string(REPLACE "-" "_" MODULE_FUNC_NAME ${MODULE})

    # Get source files of the module
    file(GLOB_RECURSE MODULE_SRC_FILES "${CMAKE_CURRENT_SOURCE_DIR}/${MODULE}/*.cpp" "${CMAKE_CURRENT_SOURCE_DIR}/${MODULE}/*.h")
    list(APPEND MODULES_SOURCES ${MODULE_SRC_FILES})

    # Create Visual Studio group reflecting file tree
    foreach(SRC_FILE ${MODULE_SRC_FILES})
        get_filename_component(SRC_PATH ${SRC_FILE} DIRECTORY)
        file(RELATIVE_PATH REL_PATH ${CMAKE_CURRENT_SOURCE_DIR} ${SRC_PATH})
        source_group(${REL_PATH} FILES ${SRC_FILE})
    endforeach()
endforeach()

set(MODULES_INCLUDES "")
set(MODULES_DECLARATIONS "")
set(MODULES_CALLS "")

foreach(MODULE ${VALID_MODULES})
    string(REPLACE "-" "_" MODULE_FUNC_NAME ${MODULE})

    # Add includes for modules
    set(MODULES_INCLUDES "${MODULES_INCLUDES}void AddSC_${MODULE_FUNC_NAME}();\n")

    # Add declarations and calls for ModulesLoader.cpp
    set(MODULES_DECLARATIONS "${MODULES_DECLARATIONS}void AddSC_${MODULE_FUNC_NAME}();\n")
    set(MODULES_CALLS "${MODULES_CALLS}    AddSC_${MODULE_FUNC_NAME}();\n")
endforeach()

# Generate temporary ModulesLoader.cpp
configure_file(${MODULES_LOADER_TEMPLATE} ${MODULES_LOADER_TEMP} @ONLY)

# Copy generated file to source directory (replaces old one)
execute_process(COMMAND ${CMAKE_COMMAND} -E copy_if_different ${MODULES_LOADER_TEMP} ${MODULES_LOADER_FINAL})

# Include ModulesLoader.cpp and ModulesLoader.h explicitly
set(MODULES_LOADER_FILES
    ${MODULES_LOADER_FINAL}
    ${CMAKE_SOURCE_DIR}/modules/ModulesLoader.h
)

# Add these files to sources
list(APPEND MODULES_SOURCES ${MODULES_LOADER_FILES})
source_group("ModulesLoader" FILES ${MODULES_LOADER_FILES})

# Base sources used by every script project
if (USE_COREPCH)
  set(PRIVATE_PCH_HEADER ModulesPCH.h)
endif()

# Create static library "modules"
add_library(modules STATIC ${MODULES_SOURCES})

# Function to recursively get all subdirectories
function(get_all_subdirectories result curdir)
    file(GLOB_RECURSE children LIST_DIRECTORIES true ${curdir}/*)
    set(subdirs "")
    foreach(child ${children})
        if (IS_DIRECTORY ${child})
            list(APPEND subdirs ${child})
        endif()
    endforeach()
    set(${result} ${subdirs} PARENT_SCOPE)
endfunction()

# Get all subdirectories in "modules/"
get_all_subdirectories(ALL_MODULE_INCLUDES ${CMAKE_CURRENT_SOURCE_DIR})

# Get all game subdirectories for include paths
function(get_all_game_subdirs result)
    file(GLOB_RECURSE children LIST_DIRECTORIES true ${CMAKE_SOURCE_DIR}/src/server/game/*)
    set(subdirs "")
    foreach(child ${children})
        if(IS_DIRECTORY ${child})
            list(APPEND subdirs ${child})
        endif()
    endforeach()
    set(${result} ${subdirs} PARENT_SCOPE)
endfunction()
get_all_game_subdirs(GAME_INCLUDE_DIRS)

# Add include paths needed for accessing files like "Player.h"
target_include_directories(modules PRIVATE
  ${ALL_MODULE_INCLUDES}
  ${CMAKE_BINARY_DIR}
  ${CMAKE_SOURCE_DIR}/src/server/game
  ${GAME_INCLUDE_DIRS}
  ${CMAKE_SOURCE_DIR}/src/server
  ${CMAKE_SOURCE_DIR}/src/server/shared
  ${CMAKE_SOURCE_DIR}/src/server/shared/Database
  ${CMAKE_SOURCE_DIR}/src/server/shared/DataStores
  ${CMAKE_SOURCE_DIR}/src/server/shared/Logging
  ${CMAKE_SOURCE_DIR}/src/server/shared/Configuration
  ${CMAKE_SOURCE_DIR}/src/server/shared/Packets
  ${CMAKE_SOURCE_DIR}/src/server/shared/Threading
  ${CMAKE_SOURCE_DIR}/src/server/shared/Cryptography
  ${CMAKE_SOURCE_DIR}/src/server/shared/Cryptography/Authentication
  ${CMAKE_SOURCE_DIR}/src/server/shared/Dynamic
  ${CMAKE_SOURCE_DIR}/src/server/shared/Dynamic/LinkedReference
  ${CMAKE_SOURCE_DIR}/src/server/shared/Debugging
  ${CMAKE_SOURCE_DIR}/src/server/shared/Utilities
  ${CMAKE_SOURCE_DIR}/src/server/game/Dynamic
  ${CMAKE_SOURCE_DIR}/src/server/game/Grids
  ${CMAKE_SOURCE_DIR}/src/server/game/Movement
  ${CMAKE_SOURCE_DIR}/src/server/game/Entities/Object
  ${CMAKE_SOURCE_DIR}/src/server/game/Entities/Player
  ${CMAKE_SOURCE_DIR}/src/server/game/Entities/Unit
  ${CMAKE_SOURCE_DIR}/src/server/game/Entities/Creature
  ${CMAKE_SOURCE_DIR}/src/server/game/Globals
  ${CMAKE_SOURCE_DIR}/src/server/game/Groups
  ${CMAKE_SOURCE_DIR}/src/server/game/Accounts
  ${CMAKE_SOURCE_DIR}/src/server/game/Spells
  ${CMAKE_SOURCE_DIR}/src/server/game/Scripting
  ${CMAKE_SOURCE_DIR}/src/server/game/Server
  ${CMAKE_SOURCE_DIR}/src/server/game/Chat
  ${CMAKE_SOURCE_DIR}/src/server/game/Loot
  ${CMAKE_SOURCE_DIR}/src/server/game/Maps
  ${CMAKE_SOURCE_DIR}/src/server/game/Handlers
  ${CMAKE_SOURCE_DIR}/src/server/game/DataStores
  ${CMAKE_SOURCE_DIR}/src/server/game/Miscellaneous
  ${CMAKE_SOURCE_DIR}/src/server/game/Quests
  ${CMAKE_SOURCE_DIR}/src/server/game/Entities/GameObject
  ${CMAKE_SOURCE_DIR}/src/server/game/Entities/Item
  ${CMAKE_SOURCE_DIR}/src/server/game/Entities/Pet
  ${CMAKE_SOURCE_DIR}/src/server/game/Entities/Transport
  ${CMAKE_SOURCE_DIR}/src/server/game/Entities/Vehicle
  ${CMAKE_SOURCE_DIR}/src/server/game/Entities/AreaTrigger
  ${CMAKE_SOURCE_DIR}/src/server/game/Entities/Corpse
  ${CMAKE_SOURCE_DIR}/src/server/game/Battlegrounds
  ${CMAKE_SOURCE_DIR}/src/server/game/AI
  ${CMAKE_SOURCE_DIR}/src/server/game/AI/CoreAI
  ${CMAKE_SOURCE_DIR}/src/server/game/AI/ScriptedAI
  ${CMAKE_SOURCE_DIR}/src/server/game/AI/SmartScripts
  ${CMAKE_SOURCE_DIR}/src/server/game/Guilds
  ${CMAKE_SOURCE_DIR}/src/server/game/OutdoorPvP
  ${CMAKE_SOURCE_DIR}/src/server/game/Combat
  ${CMAKE_SOURCE_DIR}/src/server/game/Conditions
  ${CMAKE_SOURCE_DIR}/src/server/game/Events
  ${CMAKE_SOURCE_DIR}/src/server/game/Instances
  ${CMAKE_SOURCE_DIR}/src/server/game/Pools
  ${CMAKE_SOURCE_DIR}/src/server/game/Reputation
  ${CMAKE_SOURCE_DIR}/src/server/game/Skills
  ${CMAKE_SOURCE_DIR}/src/server/game/Weather
  ${CMAKE_SOURCE_DIR}/src/server/game/World
  ${CMAKE_SOURCE_DIR}/src/server/game/Tools
  ${CMAKE_SOURCE_DIR}/src/server/game/Achievements
  ${CMAKE_SOURCE_DIR}/src/server/game/Addons
  ${CMAKE_SOURCE_DIR}/src/server/game/Calendar
  ${CMAKE_SOURCE_DIR}/src/server/game/BattlePet
  ${CMAKE_SOURCE_DIR}/src/server/game/BattlePay
  ${CMAKE_SOURCE_DIR}/src/server/game/Anticheat
  ${CMAKE_SOURCE_DIR}/src/server/game/CustomLogs
  ${CMAKE_SOURCE_DIR}/src/server/game/CustomTransmogrification
  ${CMAKE_SOURCE_DIR}/src/server/game/DungeonFinding
  ${CMAKE_SOURCE_DIR}/src/server/game/LuaEngine
  ${CMAKE_SOURCE_DIR}/src/server/game/Warden
  ${CMAKE_SOURCE_DIR}/src/server/game/Vignette
  ${CMAKE_SOURCE_DIR}/src/server/game/BlackMarket
  ${CMAKE_SOURCE_DIR}/src/server/game/AuctionHouse
  ${CMAKE_SOURCE_DIR}/src/server/game/Mails
  ${CMAKE_SOURCE_DIR}/src/server/game/Tickets
  ${CMAKE_SOURCE_DIR}/src/server/game/Scenarios
  ${CMAKE_SOURCE_DIR}/src/server/game/Services
  ${CMAKE_SOURCE_DIR}/src/server/game/LookingForGroup
  ${CMAKE_SOURCE_DIR}/src/server/game/Texts
  ${CMAKE_SOURCE_DIR}/src/server/game/Opcodes
  ${CMAKE_SOURCE_DIR}/src/server/game/PrecompiledHeaders
  ${CMAKE_SOURCE_DIR}/src/server/game/Server/Protocol
  ${CMAKE_SOURCE_DIR}/src/server/game/Entities/DynamicObject
  ${CMAKE_SOURCE_DIR}/src/server/game/Entities/Item/Container
  ${CMAKE_SOURCE_DIR}/src/server/game/Entities/Object/Updates
  ${CMAKE_SOURCE_DIR}/src/server/game/Grids/Cells
  ${CMAKE_SOURCE_DIR}/src/server/game/Grids/Notifiers
  ${CMAKE_SOURCE_DIR}/src/server/game/Movement/MovementGenerators
  ${CMAKE_SOURCE_DIR}/src/server/game/Movement/Spline
  ${CMAKE_SOURCE_DIR}/src/server/game/Movement/Waypoints
  ${CMAKE_SOURCE_DIR}/src/server/game/AuctionHouse/AuctionHouseBot
  ${CMAKE_SOURCE_DIR}/src/server/game/Battlegrounds/Zones
  ${CMAKE_SOURCE_DIR}/src/server/game/Chat/Channels
  ${CMAKE_SOURCE_DIR}/src/server/game/Warden/Modules
  ${CMAKE_SOURCE_DIR}/src/server/game/Battlefield
  ${CMAKE_SOURCE_DIR}/src/server/game/Battlefield/Zones
  ${CMAKE_SOURCE_DIR}/src/server/game/Spells/Auras
  ${CMAKE_SOURCE_DIR}/src/server/collision
  ${CMAKE_SOURCE_DIR}/src/server/collision/Management
  ${CMAKE_SOURCE_DIR}/src/server/collision/Models
  ${CMAKE_SOURCE_DIR}/dep/g3dlite/include
  ${CMAKE_SOURCE_DIR}/dep/recastnavigation/Detour/Include
  ${CMAKE_SOURCE_DIR}/dep/gsoap
  ${CMAKE_SOURCE_DIR}/dep/sockets/include
  ${CMAKE_SOURCE_DIR}/dep/SFMT
  ${ACE_INCLUDE_DIR}
  ${MYSQL_INCLUDE_DIR}
  ${OPENSSL_INCLUDE_DIR}
  ${Boost_INCLUDE_DIRS}
)

target_link_libraries(modules
  PUBLIC
    game
    shared
)

add_dependencies(modules revision.h)