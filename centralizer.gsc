main()
{
    level.gametype = getCvar("g_gametype");
    
    level.callbackStartGameType = ::startGameType;
    level.callbackPlayerConnect = ::playerConnect;
    level.callbackPlayerDisconnect = ::playerDisconnect;
    level.callbackPlayerDamage = ::playerDamage;
    level.callbackPlayerKilled = ::playerKilled;

    maps\mp\gametypes\_callbacksetup::SetupCallbacks();

    if(level.gametype == "sd")
    {
        level._effect["bombexplosion"] = loadfx("fx/explosions/mp_bomb.efx");
    }

    allowed[0] = level.gametype;
    if(level.gametype == "sd")
    {
        allowed[1] = "bombzone";
        allowed[2] = "blocker";
    }
    else if(level.gametype == "re")
    {
        allowed[1] = "retrieval";
    }
    maps\mp\gametypes\_gameobjects::main(allowed);

    if(level.gametype == "sd")
    {
        if(getCvar("scr_sd_timelimit") == "")		// Time limit per map
            setcvar("scr_sd_timelimit", "0");
        else if(getCvarFloat("scr_sd_timelimit") > 1440)
            setcvar("scr_sd_timelimit", "1440");
        level.timelimit = getCvarFloat("scr_sd_timelimit");            
    }
    else if(level.gametype == "re")
    {
        if(getCvar("scr_re_timelimit") == "")		// Time limit per map
            setcvar("scr_re_timelimit", "0");
        else if(getCvarFloat("scr_re_timelimit") > 1440)
            setcvar("scr_re_timelimit", "1440");
        level.timelimit = getCvarFloat("scr_re_timelimit");
    }
    else if(level.gametype == "dm")
    {
        if(getCvar("scr_dm_timelimit") == "")		// Time limit per map
            setcvar("scr_dm_timelimit", "30");
        else if(getCvarFloat("scr_dm_timelimit") > 1440)
            setcvar("scr_dm_timelimit", "1440");
        level.timelimit = getCvarFloat("scr_dm_timelimit");
    }
    else if(level.gametype == "tdm")
    {
        if(getCvar("scr_tdm_timelimit") == "")		// Time limit per map
            setcvar("scr_tdm_timelimit", "30");
        else if(getCvarFloat("scr_tdm_timelimit") > 1440)
            setcvar("scr_tdm_timelimit", "1440");
        level.timelimit = getCvarFloat("scr_tdm_timelimit");
    }
    else if(level.gametype == "bel")
    {
        if(getCvar("scr_bel_timelimit") == "")
            setcvar("scr_bel_timelimit", "30");
        else if(getCvarFloat("scr_bel_timelimit") > 1440)
            setcvar("scr_bel_timelimit", "1440");
        level.timelimit = getCvarFloat("scr_bel_timelimit");
    }

    if(level.gametype == "sd" || level.gametype == "re")
    {
        if(!isdefined(game["timeleft"]))
            game["timeleft"] = level.timelimit;
    }
    
    if(level.gametype == "sd")
    {
        if(getCvar("scr_sd_scorelimit") == "")		// Score limit per map
            setcvar("scr_sd_scorelimit", "10");
        level.scorelimit = getCvarInt("scr_sd_scorelimit");
            
        if(getCvar("scr_sd_roundlimit") == "")		// Round limit per map
            setcvar("scr_sd_roundlimit", "0");
        level.roundlimit = getCvarInt("scr_sd_roundlimit");

        if(getCvar("scr_sd_roundlength") == "")		// Time length of each round
            setcvar("scr_sd_roundlength", "4");
        else if(getCvarFloat("scr_sd_roundlength") > 10)
            setcvar("scr_sd_roundlength", "10");
        level.roundlength = getCvarFloat("scr_sd_roundlength");

        if(getCvar("scr_sd_graceperiod") == "")		// Time at round start where spawning and weapon choosing is still allowed
            setcvar("scr_sd_graceperiod", "15");
        else if(getCvarFloat("scr_sd_graceperiod") > 60)
            setcvar("scr_sd_graceperiod", "60");
        level.graceperiod = getCvarFloat("scr_sd_graceperiod");
    }
    else if(level.gametype == "re")
    {
        if(getCvar("scr_re_scorelimit") == "")		// Score limit per map
            setcvar("scr_re_scorelimit", "10");
        level.scorelimit = getCvarInt("scr_re_scorelimit");

        if(getCvar("scr_re_roundlimit") == "")		// Round limit per map
            setcvar("scr_re_roundlimit", "0");
        level.roundlimit = getCvarInt("scr_re_roundlimit");

        if(getCvar("scr_re_roundlength") == "")		// Time length of each round
            setcvar("scr_re_roundlength", "4");
        else if(getCvarFloat("scr_re_roundlength") > 10)
            setcvar("scr_re_roundlength", "10");
        level.roundlength = getCvarFloat("scr_re_roundlength");

        if(getCvar("scr_re_graceperiod") == "")		// Time at round start where spawning and weapon choosing is still allowed
            setcvar("scr_re_graceperiod", "15");
        else if(getCvarFloat("scr_re_graceperiod") > 60)
            setcvar("scr_re_graceperiod", "60");
        level.graceperiod = getCvarFloat("scr_re_graceperiod");
    }
    else if(level.gametype == "dm")
    {
        if(getCvar("scr_dm_scorelimit") == "")		// Score limit per map
            setcvar("scr_dm_scorelimit", "50");
        level.scorelimit = getCvarInt("scr_dm_scorelimit");
    }
    else if(level.gametype == "tdm")
    {
        if(getCvar("scr_tdm_scorelimit") == "")		// Score limit per map
            setcvar("scr_tdm_scorelimit", "100");
        level.scorelimit = getCvarInt("scr_tdm_scorelimit");
    }
    else if(level.gametype == "bel")
    {
        if(getCvar("scr_bel_scorelimit") == "")
            setcvar("scr_bel_scorelimit", "50");
        level.playerscorelimit = getCvarInt("scr_bel_scorelimit");
    }

    if(level.gametype == "bel")
    {
        if(getCvar("scr_bel_alivepointtime") == "")
            setcvar("scr_bel_alivepointtime", "10");
        level.AlivePointTime = getCvarInt("scr_bel_alivepointtime");

        if(getCvar("scr_bel_positiontime") == "")
            setcvar("scr_bel_positiontime", "6");
        level.PositionUpdateTime = getCvarInt("scr_bel_positiontime");

        if(getCvar("scr_bel_respawndelay") == "")
            setcvar("scr_bel_respawndelay", "0");

        if(getCvar("scr_bel_showoncompass") == "")
            setcvar("scr_bel_showoncompass", "1");
    }

    if(level.gametype == "sd" || level.gametype == "re" || level.gametype == "tdm" || level.gametype == "bel")
    {
        if(getCvar("scr_friendlyfire") == "")		// Friendly fire
            setcvar("scr_friendlyfire", "0");

        if(level.gametype == "sd" || level.gametype == "re")
        {
            if(getCvar("scr_roundcam") == "")		// Round Cam On or Off (Default 0 - off)
                setcvar("scr_roundcam", "0");
        }

        if(level.gametype == "sd" || level.gametype == "re" || level.gametype == "tdm")
        {
            if(getCvar("scr_teambalance") == "")		// Auto Team Balancing
                setCvar("scr_teambalance", "0");
            level.teambalance = getCvarInt("scr_teambalance");
            if(level.gametype == "tdm")
            {
                level.teambalancetimer = 0;
            }
            else
            {
                level.lockteams = false;
            }
        }

        if(getCvar("scr_drawfriend") == "")		// Draws a team icon over teammates
            setcvar("scr_drawfriend", "0");
        level.drawfriend = getCvarInt("scr_drawfriend");
    }

    if(level.gametype == "dm" || level.gametype == "tdm")
    {
        if(getCvar("scr_forcerespawn") == "")		// Force respawning
            setcvar("scr_forcerespawn", "0");
    }

    if(getCvar("g_allowvote") == "")
        setcvar("g_allowvote", "1");
    level.allowvote = getCvarInt("g_allowvote");
    setcvar("scr_allow_vote", level.allowvote);

    if(level.gametype == "re")
    {
        if(!isdefined(game["re_attackers"]))
            game["re_attackers"] = "allies";
        if(!isdefined(game["re_defenders"]))
            game["re_defenders"] = "axis";

        if(getCvar("scr_re_showcarrier") == "")
            setcvar("scr_re_showcarrier", "0");

        if(!isdefined(game["re_attackers_obj_text"]))
            game["re_attackers_obj_text"] = (&"RE_ATTACKERS_OBJ_TEXT_GENERIC");
        if(!isdefined(game["re_defenders_obj_text"]))
            game["re_defenders_obj_text"] = (&"RE_DEFENDERS_OBJ_TEXT_GENERIC");            
    }

    if(!isdefined(game["state"]))
        game["state"] = "playing";
    if(level.gametype == "sd" || level.gametype == "re")
    {
        if(!isdefined(game["roundsplayed"]))
            game["roundsplayed"] = 0;
        if(!isdefined(game["matchstarted"]))
            game["matchstarted"] = false;
            
        if(!isdefined(game["alliedscore"]))
            game["alliedscore"] = 0;
        setTeamScore("allies", game["alliedscore"]);

        if(!isdefined(game["axisscore"]))
            game["axisscore"] = 0;
        setTeamScore("axis", game["axisscore"]);
    }

    if(level.gametype == "re")
    {
        game["headicon_allies"] = "gfx/hud/headicon@allies.tga";
        game["headicon_axis"] = "gfx/hud/headicon@axis.tga";
        game["headicon_carrier"] = "gfx/hud/headicon@re_objcarrier.tga";            
    }

    if(level.gametype == "sd")
    {
        level.bombplanted = false;
        level.bombexploded = false;
    }
    if(level.gametype == "sd" || level.gametype == "re")
    {
        level.roundstarted = false;
        level.roundended = false;
    }
    if(level.gametype == "dm")
    {
        level.QuickMessageToAll = true;
    }
    level.mapended = false;
    if(level.gametype == "dm" || level.gametype == "tdm")
    {
        level.healthqueue = [];
        level.healthqueuecurrent = 0;
    }
    if(level.gametype == "bel")
    {
        level.alliesallowed = 1;
    }

    if(level.gametype == "sd" || level.gametype == "re")
    {
        if (!isdefined (game["BalanceTeamsNextRound"]))
            game["BalanceTeamsNextRound"] = false;

        level.exist["allies"] = 0;
        level.exist["axis"] = 0;
        level.exist["teams"] = false;
        level.didexist["allies"] = false;
        level.didexist["axis"] = false;
    }
    if(level.gametype == "re")
    {
        level.numobjectives = 0;
        level.objectives_done = 0;
        level.hudcount = 0;
        level.barsize = 288;
    }
    
    if(level.gametype == "dm" || level.gametype == "tdm" || level.gametype == "bel")
    {
        if(level.gametype == "dm")
        {
            spawnpointname = "mp_deathmatch_spawn";
        }
        else if(level.gametype == "tdm" || level.gametype == "bel")
        {
            spawnpointname = "mp_teamdeathmatch_spawn";
        }
        spawnpoints = getEntArray(spawnpointname, "classname");

        if(spawnpoints.size > 0)
        {
            for(i = 0; i < spawnpoints.size; i++)
                spawnpoints[i] placeSpawnpoint();
        }
        else
            maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
    }
    else
    {
        if(level.gametype == "sd")
        {
            spawnpointname = "mp_searchanddestroy_spawn_allied";
        }
        else if(level.gametype == "re")
        {
            spawnpointname = "mp_retrieval_spawn_allied";
        }
        spawnpoints = getEntArray(spawnpointname, "classname");

        if(spawnpoints.size > 0)
        {
            for(i = 0; i < spawnpoints.size; i++)
                spawnpoints[i] placeSpawnpoint();
        }
        else
            maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
        
        if(level.gametype == "sd")
        {
            spawnpointname = "mp_searchanddestroy_spawn_axis";            
        }
        else if(level.gametype == "re")
        {
            spawnpointname = "mp_retrieval_spawn_axis";            
        }
        spawnpoints = getEntArray(spawnpointname, "classname");

        if(spawnpoints.size > 0)
        {
            for(i = 0; i < spawnpoints.size; i++)
                spawnpoints[i] PlaceSpawnpoint();
        }
        else
            maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
    }

    if(level.gametype == "re")
    {
        players = getEntArray("player", "classname");
        for(i = 0; i < players.size; i++)
            players[i].objs_held = 0;

        //get the minefields
        level.minefield = getEntArray("minefield", "targetname");

        thread maps\mp\gametypes\re::retrieval();
    }

    setarchive(true);

    chat_commands::init();
    mapvote::init();

    thread resetMapGametype_ifEmpty();

    level.quickMessageDelay = 0.75;
}
resetMapGametype_ifEmpty()
{
    for (;;)
    {
        wait 30; // After this time, at least a player should have finished loading map, to prevent the function from executing.
        players = getEntArray("player", "classname");
        if (players.size == 0)
        {
            currentMap = getCvar("mapname");
            currentGametype = getCvar("g_gametype");

            gametypeMapCurrent = "gametype" + " " + currentGametype + " " + "map" + " " + currentMap;
            gametypeMapEmpty = getCvar("scr_gametypeMapEmpty"); // E.g.: "gametype dm map mp_harbor"

            if (gametypeMapEmpty != "" && (gametypeMapCurrent != gametypeMapEmpty))
            {
                setCvar("sv_mapRotationCurrent", gametypeMapEmpty);
                exitLevel(false);
            }
        }

        wait .05;
    }
}

startGameType()
{
    // if this is a fresh map start, set nationalities based on cvars, otherwise leave game variable nationalities as set in the level script
    if((level.gametype == "dm" || level.gametype == "tdm" || level.gametype == "bel") || ((level.gametype == "sd" || level.gametype == "re") && !isdefined(game["gamestarted"])))
    {
        // defaults if not defined in level script
        if(!isdefined(game["allies"]))
            game["allies"] = "american";
        if(!isdefined(game["axis"]))
            game["axis"] = "german";

        if(!isdefined(game["layoutimage"]))
            game["layoutimage"] = "default";
        layoutname = "levelshots/layouts/hud@layout_" + game["layoutimage"];
        precacheShader(layoutname);
        setcvar("scr_layoutimage", layoutname);
        makeCvarServerInfo("scr_layoutimage", "");

        // server cvar overrides
        if(getCvar("scr_allies") != "")
            game["allies"] = getCvar("scr_allies");	
        if(getCvar("scr_axis") != "")
            game["axis"] = getCvar("scr_axis");

        if(getCvar("g_gametype") != "tdm")
        {
            if(level.gametype == "bel")
            {
                game["menu_team"] = "team_germanonly";
        
                game["menu_weapon_all"] = "weapon_" + game["allies"] + game["axis"];
                game["menu_weapon_allies_only"] = "weapon_" + game["allies"];
                game["menu_weapon_axis_only"] = "weapon_" + game["axis"];
            }
            else
            {
                game["menu_team"] = "team_" + game["allies"] + game["axis"];
                game["menu_weapon_allies"] = "weapon_bolt";
                game["menu_weapon_axis"] = "weapon_bolt";
            }
        }
        else
        {
            game["menu_team"] = "team_" + game["allies"] + game["axis"];
            game["menu_weapon_allies"] = "weapon_" + game["allies"];
            game["menu_weapon_axis"] = "weapon_" + game["axis"];
        }

        game["menu_viewmap"] = "viewmap";
        game["menu_callvote"] = "callvote";
        game["menu_quickcommands"] = "quickcommands";
        game["menu_quickstatements"] = "quickstatements";
        game["menu_quickresponses"] = "quickresponses";
        if(level.gametype == "sd" || level.gametype == "tdm" || level.gametype == "bel")
        {
            game["headicon_allies"] = "gfx/hud/headicon@allies.tga";
            game["headicon_axis"] = "gfx/hud/headicon@axis.tga";
        }
        
        if(level.gametype == "sd" || level.gametype == "re")
        {
            precacheString(&"MPSCRIPT_PRESS_ACTIVATE_TO_SKIP");
        }
        else if(level.gametype == "dm" || level.gametype == "tdm" || level.gametype == "bel")
        {
            precacheString(&"MPSCRIPT_PRESS_ACTIVATE_TO_RESPAWN");
        }
        precacheString(&"MPSCRIPT_KILLCAM");
        if(level.gametype == "sd")
        {
            precacheString(&"SD_MATCHSTARTING");
            precacheString(&"SD_MATCHRESUMING");
            precacheString(&"SD_EXPLOSIVESPLANTED");
            precacheString(&"SD_EXPLOSIVESDEFUSED");
            precacheString(&"SD_ROUNDDRAW");
            precacheString(&"SD_TIMEHASEXPIRED");
            precacheString(&"SD_ALLIEDMISSIONACCOMPLISHED");
            precacheString(&"SD_AXISMISSIONACCOMPLISHED");
            precacheString(&"SD_ALLIESHAVEBEENELIMINATED");
            precacheString(&"SD_AXISHAVEBEENELIMINATED");
        }
        else if(level.gametype == "re")
        {
            precacheString(&"MPSCRIPT_ROUNDCAM");
            precacheString(&"MPSCRIPT_ALLIES_WIN");
            precacheString(&"MPSCRIPT_AXIS_WIN");
            precacheString(&"MPSCRIPT_STARTING_NEW_ROUND");
            precacheString(&"RE_U_R_CARRYING");
            precacheString(&"RE_U_R_CARRYING_GENERIC");
            precacheString(&"RE_PICKUP_AXIS_ONLY_GENERIC");
            precacheString(&"RE_PICKUP_AXIS_ONLY");
            precacheString(&"RE_PICKUP_ALLIES_ONLY_GENERIC");
            precacheString(&"RE_PICKUP_ALLIES_ONLY");
            precacheString(&"RE_OBJ_PICKED_UP_GENERIC");
            precacheString(&"RE_OBJ_PICKED_UP_GENERIC_NOSTARS");
            precacheString(&"RE_OBJ_PICKED_UP");
            precacheString(&"RE_OBJ_PICKED_UP_NOSTARS");
            precacheString(&"RE_PRESS_TO_PICKUP");
            precacheString(&"RE_PRESS_TO_PICKUP_GENERIC");
            precacheString(&"RE_OBJ_TIMEOUT_RETURNING");
            precacheString(&"RE_OBJ_DROPPED");
            precacheString(&"RE_OBJ_DROPPED_DEFAULT");
            precacheString(&"RE_OBJ_INMINES_MULTIPLE");
            precacheString(&"RE_OBJ_INMINES_GENERIC");
            precacheString(&"RE_OBJ_INMINES");
            precacheString(&"RE_ATTACKERS_OBJ_TEXT_GENERIC");
            precacheString(&"RE_DEFENDERS_OBJ_TEXT_GENERIC");
            precacheString(&"RE_ROUND_DRAW");
            precacheString(&"RE_MATCHSTARTING");
            precacheString(&"RE_MATCHRESUMING");
            precacheString(&"RE_TIMEEXPIRED");
            precacheString(&"RE_ELIMINATED_ALLIES");
            precacheString(&"RE_ELIMINATED_AXIS");
            precacheString(&"RE_OBJ_CAPTURED_GENERIC");
            precacheString(&"RE_OBJ_CAPTURED_ALL");
            precacheString(&"RE_OBJ_CAPTURED");
            precacheString(&"RE_RETRIEVAL");
            precacheString(&"RE_ALLIES");
            precacheString(&"RE_AXIS");
            precacheString(&"RE_OBJ_ARTILLERY_MAP");
            precacheString(&"RE_OBJ_PATROL_LOGS");
            precacheString(&"RE_OBJ_CODE_BOOK");
            precacheString(&"RE_OBJ_FIELD_RADIO");
            precacheString(&"RE_OBJ_SPY_RECORDS");
            precacheString(&"RE_OBJ_ROCKET_SCHEDULE");
            precacheString(&"RE_OBJ_CAMP_RECORDS");
        }
        else if(level.gametype == "bel")
        {
            precacheString(&"BEL_TIME_ALIVE");
            precacheString(&"BEL_TIME_TILL_SPAWN");
            precacheString(&"BEL_PRESS_TO_RESPAWN");
            precacheString(&"BEL_POINTS_EARNED");
            precacheString(&"BEL_WONTBE_ALLIED");
            precacheString(&"BEL_BLACKSCREEN_KILLEDALLIED");
            precacheString(&"BEL_BLACKSCREEN_WILLSPAWN");
        }

        precacheMenu(game["menu_team"]);
        if(level.gametype == "bel")
        {
            precacheMenu(game["menu_weapon_all"]);
            precacheMenu(game["menu_weapon_allies_only"]);
            precacheMenu(game["menu_weapon_axis_only"]);
        }
        else
        {
            precacheMenu(game["menu_weapon_allies"]);
            precacheMenu(game["menu_weapon_axis"]);
        }
        precacheMenu(game["menu_viewmap"]);
        precacheMenu(game["menu_callvote"]);
        precacheMenu(game["menu_quickcommands"]);
        precacheMenu(game["menu_quickstatements"]);
        precacheMenu(game["menu_quickresponses"]);

        if(level.gametype == "sd" || level.gametype == "re" || level.gametype == "tdm" || level.gametype == "bel")
        {
            precacheHeadIcon(game["headicon_allies"]);
            precacheHeadIcon(game["headicon_axis"]);
        }
        if(level.gametype == "re")
        {
            precacheHeadIcon(game["headicon_carrier"]);
        }
        if(level.gametype == "bel")
        {
            precacheHeadIcon("gfx/hud/headicon@killcam_arrow");
        }

        precacheStatusIcon("gfx/hud/hud@status_dead.tga");
        precacheStatusIcon("gfx/hud/hud@status_connecting.tga");
        if(level.gametype == "re")
        {
            precacheStatusIcon(game["headicon_carrier"]);
        }

        precacheShader("black");
        if(level.gametype == "sd" || level.gametype == "re")
        {
            precacheShader("white");
        }
        precacheShader("hudScoreboard_mp");
        if(level.gametype == "dm")
        {
            precacheShader("gfx/hud/hud@mpflag_none.tga");
        }
        precacheShader("gfx/hud/hud@mpflag_spectator.tga");
        if(level.gametype == "sd")
        {
            precacheShader("ui_mp/assets/hud@plantbomb.tga");
            precacheShader("ui_mp/assets/hud@defusebomb.tga");
            precacheShader("gfx/hud/hud@objectiveA.tga");
            precacheShader("gfx/hud/hud@objectiveA_up.tga");
            precacheShader("gfx/hud/hud@objectiveA_down.tga");
            precacheShader("gfx/hud/hud@objectiveB.tga");
            precacheShader("gfx/hud/hud@objectiveB_up.tga");
            precacheShader("gfx/hud/hud@objectiveB_down.tga");
            precacheShader("gfx/hud/hud@bombplanted.tga");
            precacheShader("gfx/hud/hud@bombplanted_up.tga");
            precacheShader("gfx/hud/hud@bombplanted_down.tga");
            precacheShader("gfx/hud/hud@bombplanted_down.tga");
        }
        else if(level.gametype == "re")
        {
            precacheShader("gfx/hud/hud@objectivegoal.tga");
            precacheShader("gfx/hud/hud@objectivegoal_up.tga");
            precacheShader("gfx/hud/hud@objectivegoal_down.tga");
            precacheShader("gfx/hud/objective.tga");
            precacheShader("gfx/hud/objective_up.tga");
            precacheShader("gfx/hud/objective_down.tga");
        }
        else if(level.gametype == "bel")
        {
            precacheShader("gfx/hud/hud@objective_bel.tga");
            precacheShader("gfx/hud/hud@objective_bel_up.tga");
            precacheShader("gfx/hud/hud@objective_bel_down.tga");
        }

        precacheShader("gfx/hud/damage_feedback.dds");

        ////
        /*
        1.1 issue: map_rotate to same map from dm to sd = bomb precache error
        The cause maybe lies in SV_SpawnServer, see cod2rev G_GetSavePersist
        Always precache these two models for now
        */
        /*if(level.gametype == "sd")
        {*/
            precacheModel("xmodel/mp_bomb1_defuse");
            precacheModel("xmodel/mp_bomb1");
        //}

        // Always precache this one too (health_medium error)
        //if(level.gametype == "dm" || level.gametype == "tdm")
        //{
            precacheItem("item_health");
        //}
        ////

        maps\mp\gametypes\_teams::precache();
        if(level.gametype == "sd" || level.gametype == "re" || level.gametype == "tdm" || level.gametype == "bel")
        {
            maps\mp\gametypes\_teams::scoreboard();
        }
        maps\mp\gametypes\_teams::initGlobalCvars();
        
        if(level.gametype == "sd")
        {
            //thread addBotClients();
        }
        else if(level.gametype == "re")
        {
            //thread addBotClients();
        }
    }

    maps\mp\gametypes\_teams::modeltype();
    maps\mp\gametypes\_teams::restrictPlacedWeapons();

    if(level.gametype == "sd" || level.gametype == "re")
    {
        game["gamestarted"] = true;
    }

    if(level.gametype == "sd")
    {
        thread maps\mp\gametypes\sd::bombzones();
        thread startGame();
        thread maps\mp\gametypes\sd::updateScriptCvars();
        //thread addBotClients();
    }
    else if(level.gametype == "re")
    {
        thread startGame();
        thread maps\mp\gametypes\re::updateScriptCvars();
        //thread addBotClients();
    }
    else if(level.gametype == "dm")
    {
        thread startGame();
        //thread addBotClients(); // For development testing
        thread maps\mp\gametypes\dm::updateScriptCvars();
    }
    else if(level.gametype == "tdm")
    {
        thread startGame();
        //thread addBotClients(); // For development testing
        thread maps\mp\gametypes\tdm::updateScriptCvars();
    }
    else if(level.gametype == "bel")
    {
        thread startGame();
        thread maps\mp\gametypes\bel::updateScriptCvars();            
    }

    level.hud_sprint_bar_maxWidth = 95;
    level.hud_sprint_bar_height = 10;
    level.hud_sprint_bar_x = 153;
    level.hud_sprint_bar_y = 458;

    hud_serverInfo_create();

    if((level.gametype != "dm" && level.gametype != "tdm" && level.gametype != "bel") && game["matchstarted"])
        thread hud_alivePlayers_create();
}













/*
vpnCheckerResult_thread()
{
    self endon("vpnCheckerResult_thread_stop");
    for(;;)
    {
        execute_async_checkdone();
        wait .05;
    }
}
vpnCheckerResult(args)
{
    printLn("###### vpnCheckerResult");
    printLn("###### args[0] = " + args[0]);

    self notify("vpnCheckerResult_thread_stop");
}*/


playerConnect()
{
    /*// Check for VPN
    ip = self getIp();
    url = "https://vpnapi.io/api/" + ip + "?key=xxx";
    arg = "python3 vpnchecker.py \"" + url + "\"";
    execute_async_create(arg, ::vpnCheckerResult);
    self thread vpnCheckerResult_thread();*/
    
    
    
    
    
    self.statusicon = "gfx/hud/hud@status_connecting.tga";
    self waittill("begin");
    self.statusicon = "";
    if(level.gametype == "re")
    {
        self.hudelem = [];
    }
    else if(level.gametype == "bel")
    {
        self.god = false;
        self.respawnwait = false;
    }

    if((level.gametype == "dm" || level.gametype == "tdm") || !isdefined(self.pers["team"]))
        iprintln(&"MPSCRIPT_CONNECTED", self);

    lpselfnum = self getEntityNumber();
    logPrint("J;" + lpselfnum + ";" + self.name + "\n");

    if(level.gametype == "re")
    {
        self.objs_held = 0;
    }
    if(game["state"] == "intermission")
    {
        spawnIntermission();
        return;
    }

    level endon("intermission");

    if(level.gametype == "bel")
    {
        if (isdefined (self.blackscreen))
            self.blackscreen destroy();
        if (isdefined (self.blackscreentext))
            self.blackscreentext destroy();
        if (isdefined (self.blackscreentext2))
            self.blackscreentext2 destroy();
        if (isdefined (self.blackscreentimer))
            self.blackscreentimer destroy();
    }

    if(isdefined(self.pers["team"]) && self.pers["team"] != "spectator")
    {
        self setClientCvar("scr_showweapontab", "1");
        if(level.gametype == "dm")
        {
            self.sessionteam = "none";
        }

        if(self.pers["team"] == "allies")
        {
            if(level.gametype == "tdm" || level.gametype == "bel")
            {
                self.sessionteam = "allies";
            }
            if(level.gametype != "bel")
            {
                self setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
            }
        }
        else
        {
            if(level.gametype == "tdm" || level.gametype == "bel")
            {
                self.sessionteam = "axis";
            }
            if(level.gametype != "bel")
            {
                self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);
            }
        }
        if(level.gametype == "bel")
        {
            self setClientCvar("g_scriptMainMenu", game["menu_weapon_all"]);
        }
        
        if(isdefined(self.pers["weapon"]))
        {
            spawnPlayer();
        }
        else
        {
            if(level.gametype == "sd" || level.gametype == "re")
            {
                self.sessionteam = "spectator";
            }

            spawnSpectator();

            if(self.pers["team"] == "allies")
            {
                if(level.gametype == "bel")
                {
                    self openMenu(game["menu_weapon_allies_only"]);
                }
                else
                {
                    self openMenu(game["menu_weapon_allies"]);
                }
            }
            else
            {
                if(level.gametype == "bel")
                {
                    self openMenu(game["menu_weapon_axis_only"]);
                }
                else
                {
                    self openMenu(game["menu_weapon_axis"]);
                }
            }
        }
    }
    else
    {
        self setClientCvar("g_scriptMainMenu", game["menu_team"]);
        self setClientCvar("scr_showweapontab", "0");

        if(!isdefined(self.pers["team"]))
            self openMenu(game["menu_team"]);

        self.pers["team"] = "spectator";
        self.sessionteam = "spectator";

        spawnSpectator();
    }

    if(isDefined(self.pers["fov"]))
        self setClientCvar("cg_fov", self.pers["fov"]);

    if(level.gametype == "sd")
        self disableItemAutoPickup();

    for(;;)
    {
        self waittill("menuresponse", menu, response);

        if(response == "open" || response == "close")
            continue;
        
        if(menu == game["menu_team"])
        {
            switch(response)
            {
                case "allies":
                case "axis":
                    if(level.gametype == "bel")
                    {
                        if ( (self.pers["team"] != "axis") && (self.pers["team"] != "allies") )
                        {
                            self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis_only"]);
                            self.pers["team"] = "axis";
                            if (isdefined (self.blackscreen))
                                self.blackscreen destroy();
                            if (isdefined (self.blackscreentext))
                                self.blackscreentext destroy();
                            if (isdefined (self.blackscreentext2))
                                self.blackscreentext2 destroy();
                            if (isdefined (self.blackscreentimer))
                                self.blackscreentimer destroy();
                            maps\mp\gametypes\bel::CheckAllies_andMoveAxis_to_Allies(self);
                            if (self.pers["team"] == "axis")
                            {
                                self thread printJoinedTeam("axis");
                                self maps\mp\gametypes\bel::move_to_axis();
                            }
                            else if (self.pers["team"] == "allies")
                                self thread printJoinedTeam("allies");
                        }
                        break;
                    }
                case "autoassign":
                    if(level.gametype == "sd" || level.gametype == "re")
                    {
                        if (level.lockteams)
                            break;
                    }
                    if(response == "autoassign")
                    {
                        if(level.gametype == "sd" || level.gametype == "re" || level.gametype == "tdm")
                        {
                            numonteam["allies"] = 0;
                            numonteam["axis"] = 0;

                            players = getEntArray("player", "classname");
                            for(i = 0; i < players.size; i++)
                            {
                                player = players[i];

                                if(!isdefined(player.pers["team"]) || player.pers["team"] == "spectator" || player == self)
                                    continue;
                    
                                numonteam[player.pers["team"]]++;
                            }

                            // if teams are equal return the team with the lowest score
                            if(numonteam["allies"] == numonteam["axis"])
                            {
                                if(getTeamScore("allies") == getTeamScore("axis"))
                                {
                                    teams[0] = "allies";
                                    teams[1] = "axis";
                                    response = teams[randomInt(2)];
                                }
                                else if(numonteam["allies"] < numonteam["axis"])
                                    response = "allies";
                                else
                                    response = "axis";
                            }
                            else if(numonteam["allies"] < numonteam["axis"])
                                response = "allies";
                            else
                                response = "axis";
                            skipbalancecheck = true;
                        }
                        else if(level.gametype == "dm")
                        {
                            teams[0] = "allies";
                            teams[1] = "axis";
                            response = teams[randomInt(2)];
                        }
                    }

                    if(response == self.pers["team"] && self.sessionstate == "playing")
                        break;
                    
                    if(level.gametype == "sd" || level.gametype == "re" || level.gametype == "tdm")
                    {
                        //Check if the teams will become unbalanced when the player goes to this team...
                        //------------------------------------------------------------------------------
                        if ( (level.teambalance > 0) && (!isdefined (skipbalancecheck)) )
                        {
                            //Get a count of all players on Axis and Allies
                            players = maps\mp\gametypes\_teams::CountPlayers();
                            
                            if (self.sessionteam != "spectator")
                            {
                                if (((players[response] + 1) - (players[self.pers["team"]] - 1)) > level.teambalance)
                                {
                                    if (response == "allies")
                                    {
                                        if (game["allies"] == "american")
                                            self iprintlnbold("Joining American would result in an unbalanced number of players on that team.");
                                        else if (game["allies"] == "british")
                                            self iprintlnbold("Joining British would result in an unbalanced number of players on that team.");
                                        else if (game["allies"] == "russian")
                                            self iprintlnbold("Joining Russian would result in an unbalanced number of players on that team.");
                                    }
                                    else
                                        self iprintlnbold("Joining German would result in an unbalanced number of players on that team.");
                                    break;
                                }
                            }
                            else
                            {
                                if (response == "allies")
                                    otherteam = "axis";
                                else
                                    otherteam = "allies";
                                if (((players[response] + 1) - players[otherteam]) > level.teambalance)
                                {
                                    if (response == "allies")
                                    {
                                        if (game["allies"] == "american")
                                            self iprintlnbold("Joining American would result in an unbalanced number of players on that team. Try joining German.");
                                        else if (game["allies"] == "british")
                                            self iprintlnbold("Joining British would result in an unbalanced number of players on that team. Try joining German.");
                                        else if (game["allies"] == "russian")
                                            self iprintlnbold("Joining Russian would result in an unbalanced number of players on that team. Try joining German.");
                                    }
                                    else
                                    {
                                        if (game["allies"] == "american")
                                            self iprintlnbold("Joining German would result in an unbalanced number of players on that team. Try joining American.");
                                        else if (game["allies"] == "british")
                                            self iprintlnbold("Joining German would result in an unbalanced number of players on that team. Try joining British.");
                                        else if (game["allies"] == "russian")
                                            self iprintlnbold("Joining German would result in an unbalanced number of players on that team. Try joining Russian.");
                                    }
                                    break;
                                }
                            }
                        }
                        skipbalancecheck = undefined;
                        //------------------------------------------------------------------------------
                    }
                    
                    if(response != self.pers["team"] && self.sessionstate == "playing")
                        self suicide();
                    
                    if(level.gametype == "dm" || level.gametype == "tdm")
                    {
                        self notify("end_respawn");
                    }
                                
                    self.pers["team"] = response;
                    self.pers["weapon"] = undefined;
                    if(level.gametype == "sd" || level.gametype == "re")
                    {
                        self.pers["weapon1"] = undefined;
                        self.pers["weapon2"] = undefined;
                        self.pers["spawnweapon"] = undefined;
                    }
                    self.pers["savedmodel"] = undefined;

                    self setClientCvar("scr_showweapontab", "1");

                    if(self.pers["team"] == "allies")
                    {
                        self setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
                        self openMenu(game["menu_weapon_allies"]);
                    }
                    else
                    {
                        self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);
                        self openMenu(game["menu_weapon_axis"]);
                    }
                    break;

                case "spectator":
                    if(self.pers["team"] != "spectator")
                    {
                        if(level.gametype == "sd" || level.gametype == "re")
                        {
                            if(isalive(self))
                                self suicide();
                        }
                        
                        self.pers["team"] = "spectator";
                        self.pers["weapon"] = undefined;
                        if(level.gametype == "sd" || level.gametype == "re")
                        {
                            self.pers["weapon1"] = undefined;
                            self.pers["weapon2"] = undefined;
                            self.pers["spawnweapon"] = undefined;
                        }
                        else if(level.gametype == "bel")
                        {
                            self.pers["LastAxisWeapon"] = undefined;
                            self.pers["LastAlliedWeapon"] = undefined;
                        }
                        self.pers["savedmodel"] = undefined;
                        
                        self.sessionteam = "spectator";
                        self setClientCvar("g_scriptMainMenu", game["menu_team"]);
                        self setClientCvar("scr_showweapontab", "0");
                        if(level.gametype == "bel")
                        {
                            if (isdefined (self.blackscreen))
                                self.blackscreen destroy();
                            if (isdefined (self.blackscreentext))
                                self.blackscreentext destroy();
                            if (isdefined (self.blackscreentext2))
                                self.blackscreentext2 destroy();
                            if (isdefined (self.blackscreentimer))
                                self.blackscreentimer destroy();
                        }
                        spawnSpectator();
                        if(level.gametype == "bel")
                        {
                            maps\mp\gametypes\bel::CheckAllies_andMoveAxis_to_Allies();
                        }
                    }
                    break;
                
                case "weapon":
                    if(level.gametype == "bel")
                    {
                        if ( (self.pers["team"] == "axis") || (self.pers["team"] == "allies") )
                            self openMenu(game["menu_weapon_all"]);
                    }
                    else
                    {
                        if(self.pers["team"] == "allies")
                            self openMenu(game["menu_weapon_allies"]);
                        else if(self.pers["team"] == "axis")
                            self openMenu(game["menu_weapon_axis"]);
                    }
                    break;
                
                case "viewmap":
                    self openMenu(game["menu_viewmap"]);
                    break;
                
                case "callvote":
                    self openMenu(game["menu_callvote"]);
                    break;
            }
        }
        else if(level.gametype == "bel" && (menu == game["menu_weapon_all"] || menu == game["menu_weapon_allies_only"] || menu == game["menu_weapon_axis_only"]))
        {
            if(response == "team")
            {
                self openMenu(game["menu_team"]);
                continue;
            }
            else if(response == "viewmap")
            {
                self openMenu(game["menu_viewmap"]);
                continue;
            }
            else if(response == "callvote")
            {
                self openMenu(game["menu_callvote"]);
                continue;
            }
            
            if(!isdefined(self.pers["team"]) || (self.pers["team"] != "allies" && self.pers["team"] != "axis"))
                continue;
            
            weapon = self maps\mp\gametypes\_teams::restrict_anyteam(response);

            if(weapon == "restricted")
            {
                self openMenu(menu);
                continue;
            }
            
            axisweapon = false;
            if (response == "kar98k_mp")
                axisweapon = true;
            else if (response == "mp40_mp")
                axisweapon = true;
            else if (response == "mp44_mp")
                axisweapon = true;
            else if (response == "kar98k_sniper_mp")
                axisweapon = true;

            if(isdefined(self.pers["weapon"]) && self.pers["weapon"] == weapon)
                continue;

            if(!isdefined(self.pers["weapon"]))
            {
                if (axisweapon == true)
                    self.pers["LastAxisWeapon"] = weapon;
                else
                    self.pers["LastAlliedWeapon"] = weapon;

                if (self.respawnwait != true)
                {
                    if (self.pers["team"] == "allies")
                    {
                        if (axisweapon == true)
                        {
                            self openMenu(menu);
                            continue;
                        }
                        else
                        {
                            self.pers["weapon"] = weapon;
                            spawnPlayer();
                        }

                    }
                    else if (self.pers["team"] == "axis")
                    {
                        if (axisweapon != true)
                        {
                            self openMenu(menu);
                            continue;
                        }
                        else
                        {
                            self.pers["weapon"] = weapon;
                            spawnPlayer();
                        }
                    }
                }
            }
            else
            {
                if ( (self.sessionstate != "playing") && (self.respawnwait != true) )
                {
                    if (isdefined (self.pers["team"]))
                    {
                        if ( (self.pers["team"] == "allies") && (axisweapon != true) )
                            self.pers["LastAlliedWeapon"] = weapon;
                        else if ( (self.pers["team"] == "axis") && (axisweapon == true) )
                            self.pers["LastAxisWeapon"] = weapon;
                        else
                            continue;

                        self.pers["weapon"] = weapon;
                        spawnPlayer();
                    }
                }
                else
                {
                    weaponname = maps\mp\gametypes\_teams::getWeaponName(weapon);			
                    if (axisweapon == true)
                    {
                        self.pers["LastAxisWeapon"] = weapon;
                        if (maps\mp\gametypes\_teams::useAn(weapon))
                            self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_AXIS_WITH_AN", weaponname);
                        else
                            self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_AXIS_WITH_A", weaponname);
                    }
                    else
                    {
                        self.pers["LastAlliedWeapon"] = weapon;
                        if (maps\mp\gametypes\_teams::useAn(weapon))
                            self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_ALLIED_WITH_AN", weaponname);
                        else
                            self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_ALLIED_WITH_A", weaponname);
                    }

                    if ( (self.pers["team"] == "allies") && (axisweapon != true) )
                        self.pers["nextWeapon"] = weapon;
                    else if ( (self.pers["team"] == "axis") && (axisweapon == true) )
                        self.pers["nextWeapon"] = weapon;
                    else
                        continue;
                }

                if (isdefined (self.pers["team"]))
                {	
                    if (axisweapon != true)
                    {
                        self.pers["LastAlliedWeapon"] = weapon;
                        continue;
                    }
                    else if (axisweapon == true)
                    {
                        self.pers["LastAxisWeapon"] = weapon;
                        continue;
                    }
                }
                continue;
            }
        }
        else if(menu == game["menu_weapon_allies"] || menu == game["menu_weapon_axis"])
        {
            if(response == "team")
            {
                self openMenu(game["menu_team"]);
                continue;
            }
            else if(response == "viewmap")
            {
                self openMenu(game["menu_viewmap"]);
                continue;
            }
            else if(response == "callvote")
            {
                self openMenu(game["menu_callvote"]);
                continue;
            }

            if(!isdefined(self.pers["team"]) || (self.pers["team"] != "allies" && self.pers["team"] != "axis"))
                continue;
                
            weapon = self maps\mp\gametypes\_teams::restrict(response);

            if(weapon == "restricted")
            {
                self openMenu(menu);
                continue;
            }

            if(level.gametype == "sd" || level.gametype == "re")
            {
                if(isdefined(self.pers["weapon"]) && self.pers["weapon"] == weapon && !isdefined(self.pers["weapon1"]))
                    continue;
            }
            else if(level.gametype == "dm" || level.gametype == "tdm")
            {
                if(isdefined(self.pers["weapon"]) && self.pers["weapon"] == weapon)
                    continue;
            }

            if((level.gametype == "sd" || level.gametype == "re") && !game["matchstarted"])
            {
                self.pers["weapon"] = weapon;
                self.spawned = undefined;
                spawnPlayer();
                self thread printJoinedTeam(self.pers["team"]);
                if(level.gametype == "sd")
                {
                    level maps\mp\gametypes\sd::checkMatchStart();
                }
                else if(level.gametype == "re")
                {
                    level maps\mp\gametypes\re::checkMatchStart();
                }
            }
            else if((level.gametype == "sd" || level.gametype == "re") && !level.roundstarted)
            {
                if(isdefined(self.pers["weapon"]))
                {
                    self.pers["weapon"] = weapon;
                    self setWeaponSlotWeapon("primary", weapon);
                    self setWeaponSlotAmmo("primary", 999);
                    self setWeaponSlotClipAmmo("primary", 999);
                    self switchToWeapon(weapon);
                }
                else
                {			 	
                    self.pers["weapon"] = weapon;
                    if(!level.exist[self.pers["team"]])
                    {
                        self.spawned = undefined;
                        spawnPlayer();
                        self thread printJoinedTeam(self.pers["team"]);
                        if(level.gametype == "sd")
                        {
                            level maps\mp\gametypes\sd::checkMatchStart();
                        }
                        else if(level.gametype == "re")
                        {
                            level maps\mp\gametypes\re::checkMatchStart();
                        }
                    }
                    else
                    {
                        spawnPlayer();
                        self thread printJoinedTeam(self.pers["team"]);
                    }
                }
            }
            else
            {
                if(level.gametype == "sd" || level.gametype == "re")
                {
                    if(isdefined(self.pers["weapon"]))
                        self.oldweapon = self.pers["weapon"];
                    
                    self.pers["weapon"] = weapon;
                    self.sessionteam = self.pers["team"];

                    if(self.sessionstate != "playing")
                        self.statusicon = "gfx/hud/hud@status_dead.tga";
                    
                    if(self.pers["team"] == "allies")
                        otherteam = "axis";
                    else if(self.pers["team"] == "axis")
                        otherteam = "allies";
                    
                    // if joining a team that has no opponents, just spawn
                    if(!level.didexist[otherteam] && !level.roundended)
                    {
                        self.spawned = undefined;
                        spawnPlayer();
                        self thread printJoinedTeam(self.pers["team"]);
                    }
                    else if(!level.didexist[self.pers["team"]] && !level.roundended)
                    {
                        self.spawned = undefined;
                        spawnPlayer();
                        self thread printJoinedTeam(self.pers["team"]);
                        if(level.gametype == "sd")
                        {
                            level maps\mp\gametypes\sd::checkMatchStart();
                        }
                        else if(level.gametype == "re")
                        {
                            level maps\mp\gametypes\re::checkMatchStart();
                        }
                    }
                    else
                    {
                        weaponname = maps\mp\gametypes\_teams::getWeaponName(self.pers["weapon"]);

                        if(self.pers["team"] == "allies")
                        {
                            if(maps\mp\gametypes\_teams::useAn(self.pers["weapon"]))
                                self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_ALLIED_WITH_AN_NEXT_ROUND", weaponname);
                            else
                                self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_ALLIED_WITH_A_NEXT_ROUND", weaponname);
                        }
                        else if(self.pers["team"] == "axis")
                        {
                            if(maps\mp\gametypes\_teams::useAn(self.pers["weapon"]))
                                self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_AXIS_WITH_AN_NEXT_ROUND", weaponname);
                            else
                                self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_AXIS_WITH_A_NEXT_ROUND", weaponname);
                        }
                    }
                }
                else if(level.gametype == "dm" || level.gametype == "tdm")
                {
                    if(!isdefined(self.pers["weapon"]))
                    {
                        self.pers["weapon"] = weapon;
                        spawnPlayer();
                        if(level.gametype == "tdm")
                        {
                            self thread printJoinedTeam(self.pers["team"]);
                        }
                    }
                    else
                    {
                        self.pers["weapon"] = weapon;
                        
                        weaponname = maps\mp\gametypes\_teams::getWeaponName(self.pers["weapon"]);
                        
                        if(maps\mp\gametypes\_teams::useAn(self.pers["weapon"]))
                            self iprintln(&"MPSCRIPT_YOU_WILL_RESPAWN_WITH_AN", weaponname);
                        else
                            self iprintln(&"MPSCRIPT_YOU_WILL_RESPAWN_WITH_A", weaponname);
                    }
                }
            }

            if(level.gametype == "sd" || level.gametype == "re" || level.gametype == "tdm")
            {
                if (isdefined (self.autobalance_notify))
                    self.autobalance_notify destroy();
            }
        }
        else if(menu == game["menu_viewmap"])
        {
            switch(response)
            {
            case "team":
                self openMenu(game["menu_team"]);
                break;
            
            case "weapon":
                if(level.gametype == "bel")
                {
                    if ( (self.pers["team"] == "axis") || (self.pers["team"] == "allies") )
                        self openMenu(game["menu_weapon_all"]);
                }
                else
                {
                    if(self.pers["team"] == "allies")
                        self openMenu(game["menu_weapon_allies"]);
                    else if(self.pers["team"] == "axis")
                        self openMenu(game["menu_weapon_axis"]);
                }
                break;
            
            case "callvote":
                self openMenu(game["menu_callvote"]);
                break;
            }
        }
        else if(menu == game["menu_callvote"])
        {
            switch(response)
            {
            case "team":
                self openMenu(game["menu_team"]);
                break;
            
            case "weapon":
                if(level.gametype == "bel")
                {
                    if ( (self.pers["team"] == "axis") || (self.pers["team"] == "allies") )
                        self openMenu(game["menu_weapon_all"]);
                }
                else
                {
                    if(self.pers["team"] == "allies")
                        self openMenu(game["menu_weapon_allies"]);
                    else if(self.pers["team"] == "axis")
                        self openMenu(game["menu_weapon_axis"]);
                }
                break;
            
            case "viewmap":
                    self openMenu(game["menu_viewmap"]);
                    break;
            }
        }
        else if(menu == game["menu_quickcommands"])
            maps\mp\gametypes\_teams::quickcommands(response);
        else if(menu == game["menu_quickstatements"])
            maps\mp\gametypes\_teams::quickstatements(response);
        else if(menu == game["menu_quickresponses"])
            maps\mp\gametypes\_teams::quickresponses(response);
    }
}

playerDisconnect()
{
    iprintln(&"MPSCRIPT_DISCONNECTED", self);

    lpselfnum = self getEntityNumber();
    logPrint("Q;" + lpselfnum + ";" + self.name + "\n");

    if(level.gametype == "re")
    {
        if (isdefined (self.objs_held))
        {
            if (self.objs_held > 0)
            {
                for (i=0;i<(level.numobjectives + 1);i++)
                {
                    if (isdefined (self.hasobj[i]))
                    {
                        //if (self isonground())
                            self.hasobj[i] maps\mp\gametypes\re::drop_objective_on_disconnect_or_death(self);
                        //else
                        //	self.hasobj[i] drop_objective_on_disconnect_or_death(self, "trace");
                    }
                }
            }
        }

        self notify ("death");
    }
    else if(level.gametype == "bel")
    {
        self.pers["team"] = "spectator";
        self maps\mp\gametypes\bel::check_delete_objective();
        maps\mp\gametypes\bel::CheckAllies_andMoveAxis_to_Allies();
    }

    if(level.gametype == "sd" || level.gametype == "re")
    {
        if(game["matchstarted"])
        {
            if(level.gametype == "sd")
            {
                level thread maps\mp\gametypes\sd::updateTeamStatus();
            }
            else if(level.gametype == "re")
            {
                level thread maps\mp\gametypes\re::updateTeamStatus();
            }
        }
    }

    hud_playerInfo_destroy();
    hud_sprintBar_destroy();
}

playerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc)
{
    if(level.gametype == "bel")
    {
        if ( (isdefined (eAttacker)) && (isPlayer(eAttacker)) && (isdefined (eAttacker.god)) && (eAttacker.god == true) )
            return;

        if ( (self.sessionteam == "spectator") || (self.god == true) )
            return;
    }
    else
    {
        if(self.sessionteam == "spectator")
            return;
    }
    
    // Don't do knockback if the damage direction was not specified
    if(!isDefined(vDir))
        iDFlags |= level.iDFLAGS_NO_KNOCKBACK;
    
    if(level.gametype == "dm")
    {
        // Make sure at least one point of damage is done
        if(iDamage < 1)
            iDamage = 1;
    }

    if(level.gametype == "sd" || level.gametype == "re" || level.gametype == "tdm" || level.gametype == "bel")
    {
        // check for completely getting out of the damage
        if(!(iDFlags & level.iDFLAGS_NO_PROTECTION))
        {
            if(isPlayer(eAttacker) && (self != eAttacker) && (self.pers["team"] == eAttacker.pers["team"]))
            {
                if(getCvarInt("scr_friendlyfire") <= 0)
                    return;

                if(getCvarInt("scr_friendlyfire") == 2)
                    reflect = true;
            }
        }

        // Apply the damage to the player
        if(!isdefined(reflect))
        {
            // Make sure at least one point of damage is done
            if(iDamage < 1)
                iDamage = 1;

            self _finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);
        }
        else
        {
            eAttacker.reflectdamage = true;

            iDamage = iDamage * .5;

            // Make sure at least one point of damage is done
            if(iDamage < 1)
                iDamage = 1;

            eAttacker _finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);
            eAttacker.reflectdamage = undefined;
        }
    }

    // Do debug print if it's enabled
    if(getCvarInt("g_debugDamage"))
    {
        println("client:" + self getEntityNumber() + " health:" + self.health +
            " damage:" + iDamage + " hitLoc:" + sHitLoc);
    }

    if(level.gametype == "dm")
    {
        // Apply the damage to the player
        self _finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);            
    }

    if(self.sessionstate != "dead")
    {
        lpselfnum = self getEntityNumber();
        lpselfname = self.name;
        lpselfteam = self.pers["team"];
        lpattackerteam = "";

        if(isPlayer(eAttacker))
        {
            lpattacknum = eAttacker getEntityNumber();
            lpattackname = eAttacker.name;
            lpattackerteam = eAttacker.pers["team"];
        }
        else
        {
            lpattacknum = -1;
            lpattackname = "";
            lpattackerteam = "world";
        }

        if(isdefined(reflect))
        {
            lpattacknum = lpselfnum;
            lpattackname = lpselfname;
            lpattackerteam = lpattackerteam;
        }

        logPrint("D;" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");
    }
}

_finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc)
{
    if(getCvar("g_gametype") != "tdm")
    {
        if((isBoltActionRifle(sWeapon) || isPistol(sWeapon)) || sMeansOfDeath == "MOD_MELEE")
            iDamage = 100;
    }

    victim_will_die = false;
    if(self.health - iDamage <= 0)
        victim_will_die = true;
    
    if (isAlive(eAttacker) && self != eAttacker)
    {
        eAttacker thread hud_damageFeedback_create(iDamage, victim_will_die);
        if(victim_will_die)
            eAttacker.killstreak++;
    }
        
        
    if (victim_will_die)
    {
        primary = self getWeaponSlotWeapon("primary");
        primaryb = self getWeaponSlotWeapon("primaryb");
        pistol = self getWeaponSlotWeapon("pistol");
        grenade = self getWeaponSlotWeapon("grenade");
        if(isDefined(primary))
            self dropItem(primary);
        if(isDefined(primaryb))
            self dropItem(primaryb);
        if(isDefined(pistol))
            self dropItem(pistol);
        if(isDefined(grenade))
            self dropItem(grenade);
    }

    self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);
}

isBoltActionRifle(sWeapon)
{
    switch(sWeapon)
    {
        case "kar98k_mp":
        case "kar98k_sniper_mp":
        case "mosin_nagant_mp":
        case "mosin_nagant_sniper_mp":
        case "springfield_mp":
        case "enfield_mp":
            return true;
    }
    return false;
}
isPistol(sWeapon)
{
    switch(sWeapon)
    {
        case "luger_mp":
        case "colt_mp":
            return true;
    }
    return false;
}

playerKilled(eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc)
{
    self endon("spawned");
    if(level.gametype == "bel")
    {
        self notify ("Stop give points");
        
        self maps\mp\gametypes\bel::check_delete_objective();
        
        if ( (self.sessionteam == "spectator") || (self.god == true) )
            return;
    }
    else
    {
        if(self.sessionteam == "spectator")
            return;
    }

    // If the player was killed by a head shot, let players know it was a head shot kill
    if(sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE")
        sMeansOfDeath = "MOD_HEAD_SHOT";

    // send out an obituary message to all clients about the kill
    obituary(self, eAttacker, sWeapon, sMeansOfDeath);
    if(level.gametype == "re")
    {
        self notify ("death");

        if (isdefined (self.objs_held))
        {
            if (self.objs_held > 0)
            {
                for (i=0;i<(level.numobjectives + 1);i++)
                {
                    if (isdefined (self.hasobj[i]))
                    {
                        //if (self isonground())
                        //{
                        //	println ("PLAYER KILLED ON THE GROUND");
                            self.hasobj[i] thread maps\mp\gametypes\re::drop_objective_on_disconnect_or_death(self);
                        //}
                        //else
                        //{
                        //	println ("PLAYER KILLED NOT ON THE GROUND");
                        //	self.hasobj[i] thread drop_objective_on_disconnect_or_death(self.origin, "trace");
                        //}
                    }
                }
            }
        }
    }

    self.sessionstate = "dead";
    self.statusicon = "gfx/hud/hud@status_dead.tga";
    if(level.gametype != "dm")
    {
        self.headicon = "";
    }
    if (!isdefined (self.autobalance))
    {
        if(level.gametype == "sd" || level.gametype == "re")
        {
            self.pers["deaths"]++;
            self.deaths = self.pers["deaths"];
        }
        else
        {
            self.deaths++;        
        }
    }

    if(level.gametype == "bel")
    {
        body = self cloneplayer();
        self dropItem(self getcurrentweapon());
        self maps\mp\gametypes\bel::updateDeathArray();
    }

    lpselfnum = self getEntityNumber();
    lpselfname = self.name;
    if(level.gametype == "dm")
    {
        lpselfteam = "";
    }
    else
    {
        lpselfteam = self.pers["team"];
    }
    lpattackerteam = "";

    attackerNum = -1;
    if(level.gametype == "sd" || level.gametype == "re")
    {
        if(isPlayerNumber(eAttacker getEntityNumber()))
            level.playercam = eAttacker getEntityNumber();
    }

    if(isPlayer(eAttacker))
    {
        if(level.gametype == "bel")
        {
            lpattacknum = eAttacker getEntityNumber();
            lpattackname = eAttacker.name;
            lpattackerteam = eAttacker.pers["team"];
            logPrint("K;" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");                
        }

        if(eAttacker == self) // killed himself
        {
            if(level.gametype == "bel")
            {
                if(isdefined(eAttacker.reflectdamage))
                    clientAnnouncement(eAttacker, &"MPSCRIPT_FRIENDLY_FIRE_WILL_NOT"); 
                
                self.score--;
                if (self.pers["team"] == "allies")
                {
                    if (maps\mp\gametypes\bel::Number_On_Team("axis") < 1)
                        self thread maps\mp\gametypes\bel::respawn("auto");
                    else
                    {
                        self maps\mp\gametypes\bel::move_to_axis();
                        maps\mp\gametypes\bel::CheckAllies_andMoveAxis_to_Allies(undefined, self);
                        self thread maps\mp\gametypes\bel::respawn();
                    }
                }
                else
                    self thread maps\mp\gametypes\bel::respawn();
                return;
            }
            else
            {
                doKillcam = false;

                if(level.gametype == "sd" || level.gametype == "re" || level.gametype == "tdm")
                {
                    if(isdefined(eAttacker.reflectdamage))
                        clientAnnouncement(eAttacker, &"MPSCRIPT_FRIENDLY_FIRE_WILL_NOT");
                }
            }
        }
        else
        {
            if(level.gametype == "bel")
            {
                if(self.pers["team"] == eAttacker.pers["team"]) // player was killed by a friendly
                {
                    eAttacker.score--;
                    if (eAttacker.pers["team"] == "allies")
                    {
                        eAttacker maps\mp\gametypes\bel::move_to_axis();
                        maps\mp\gametypes\bel::CheckAllies_andMoveAxis_to_Allies();
                    }
                    self thread maps\mp\gametypes\bel::respawn();
                    return;
                }
                else
                {
                    attackerNum = eAttacker getEntityNumber();
                    if (self.pers["team"] == "allies") //Allied player was killed by an Axis
                    {
                        eAttacker.god = true;
                        iprintln (&"BEL_KILLED_ALLIED_SOLDIER",eAttacker);
                        
                        self thread killcam (attackerNum, 2, "allies to axis");
                        maps\mp\gametypes\bel::Set_Number_Allowed_Allies(maps\mp\gametypes\bel::Number_On_Team("axis"));
                        if (maps\mp\gametypes\bel::Number_On_Team("allies") < level.alliesallowed)
                            eAttacker maps\mp\gametypes\bel::move_to_allies(undefined, 2, "nodelay on respawn", 1);
                        else
                        {
                            eAttacker.god = false;
                            eAttacker thread maps\mp\gametypes\bel::client_print(&"BEL_WONTBE_ALLIED");
                        }
                        return;
                    }
                    else //Axis player was killed by Allies
                    {
                        eAttacker.score++;
                        eAttacker maps\mp\gametypes\bel::checkScoreLimit();
                    
                        // Stop thread if map ended on this death
                        if(level.mapended)
                            return;	
                    
                        self thread killcam (attackerNum, 2, "axis to axis");
                        return;
                    }
                }
            }
            else
            {
                attackerNum = eAttacker getEntityNumber();
                doKillcam = true;

                if(level.gametype == "dm")
                {
                    eAttacker.score++;
                    eAttacker maps\mp\gametypes\dm::checkScoreLimit();
                }
                else
                {
                    if(self.pers["team"] == eAttacker.pers["team"]) // killed by a friendly
                    {
                        if(level.gametype == "tdm")
                        {
                            eAttacker.score--;
                        }
                        else
                        {
                            eAttacker.pers["score"]--;
                            eAttacker.score = eAttacker.pers["score"];
                        }
                    }
                    else
                    {
                        if(level.gametype == "tdm")
                        {
                            eAttacker.score++;

                            teamscore = getTeamScore(eAttacker.pers["team"]);
                            teamscore++;
                            setTeamScore(eAttacker.pers["team"], teamscore);
                        
                            maps\mp\gametypes\tdm::checkScoreLimit();
                        }
                        else
                        {
                            eAttacker.pers["score"]++;
                            eAttacker.score = eAttacker.pers["score"];
                        }
                    }
                }
            }
        }

        lpattacknum = eAttacker getEntityNumber();
        lpattackname = eAttacker.name;
        if(level.gametype == "sd" || level.gametype == "re" || level.gametype == "tdm")
        {
            lpattackerteam = eAttacker.pers["team"];
        }
    }
    else
    {
        if(level.gametype == "bel") // Player wasn't killed by another player or themself (landmines, etc.)
        {
            lpattacknum = -1;
            lpattackname = "";
            lpattackerteam = "world";
            logPrint("K;" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");
            
            self.score--;
            if (self.pers["team"] == "allies")
            {
                if (maps\mp\gametypes\bel::Number_On_Team("axis") < 1)
                    self thread maps\mp\gametypes\bel::respawn("auto");
                else
                {
                    self maps\mp\gametypes\bel::move_to_axis();
                    maps\mp\gametypes\bel::CheckAllies_andMoveAxis_to_Allies(undefined, self);
                    self thread maps\mp\gametypes\bel::respawn();
                }
            }
            else
                self thread maps\mp\gametypes\bel::respawn();
            
            return;
        }
        else // If you weren't killed by a player, you were in the wrong place at the wrong time
        {
            doKillcam = false;

            if(level.gametype == "dm" || level.gametype == "tdm")
            {
                self.score--;
            }
            else
            {
                self.pers["score"]--;
                self.score = self.pers["score"];
            }

            lpattacknum = -1;
            lpattackname = "";
            if(level.gametype == "sd" || level.gametype == "re" || level.gametype == "tdm")
            {
                lpattackerteam = "world";
            }
        }
    }

    logPrint("K;" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");

    if(level.gametype == "dm" || level.gametype == "tdm")
    {
        // Stop thread if map ended on this death
        if(level.mapended)
            return;
        
        if(level.gametype == "dm")
        {
            //self updateDeathArray();
        }
    }

    // Make the player drop his weapon
    if (!isdefined (self.autobalance))
        self dropItem(self getcurrentweapon());

    if(level.gametype == "sd" || level.gametype == "re")
    {
        self.pers["weapon1"] = undefined;
        self.pers["weapon2"] = undefined;
        self.pers["spawnweapon"] = undefined;
    }

    if(level.gametype == "re")
    {
        //Remove HUD text if there is any
        for (i=1;i<16;i++)
        {
            if ( (isdefined (self.hudelem)) && (isdefined (self.hudelem[i])) )
                self.hudelem[i] destroy();
        }
        if (isdefined (self.progressbackground))
            self.progressbackground destroy();
        if (isdefined (self.progressbar))
            self.progressbar destroy();
    }

    if(level.gametype == "dm")
    {
        // Make the player drop health
        self maps\mp\gametypes\dm::dropHealth();            
    }
    else if(level.gametype == "tdm")
    {
        // Make the player drop health
        self maps\mp\gametypes\tdm::dropHealth();
    }

    if (!isdefined (self.autobalance))
        body = self cloneplayer();
    self.autobalance = undefined;

    if(level.gametype == "sd")
    {
        maps\mp\gametypes\sd::updateTeamStatus();
    }
    else if(level.gametype == "re")
    {
        maps\mp\gametypes\re::updateTeamStatus();
    }

    if(level.gametype == "sd" || level.gametype == "re")
    {
        // TODO: Add additional checks that allow killcam when the last player killed wouldn't end the round (bomb is planted)
        if(!level.exist[self.pers["team"]]) // If the last player on a team was just killed, don't do killcam
            doKillcam = false;
    }
    
    if(getCvar("g_gametype") != "tdm")
    {
        if(isPistol(sWeapon) && sMeansOfDeath != "MOD_MELEE")
        {
            // Pistol kill bullet reward
            currentSlotAmmo = eAttacker getWeaponSlotAmmo("pistol");
            eAttacker setWeaponSlotAmmo("pistol", currentSlotAmmo + 1);
        }
    }

    if (isPlayer(eAttacker) && isAlive(eAttacker))
    {
        // Air jump reward
        currentAirJumps = eAttacker getAirJumps();
        eAttacker setAirJumps(currentAirJumps + 1);
    }

    delay = 2;	// Delay the player becoming a spectator till after he's done dying
    wait delay;	// ?? Also required for Callback_PlayerKilled to complete before killcam can execute

    if (self isBot())
    {
        respawnBot();
        return;
    }

    if(level.gametype == "dm" || level.gametype == "tdm")
    {
        if(getCvarInt("scr_forcerespawn") > 0)
            doKillcam = false;
    }

    if((((level.gametype == "dm" || level.gametype == "tdm") && doKillcam)) || ((level.gametype == "sd" || level.gametype == "re") && doKillcam && !level.roundended))
    {
        self thread killcam(attackerNum, delay);
    }
    else
    {
        if(level.gametype == "dm")
        {
            self thread maps\mp\gametypes\dm::respawn();
        }
        else if(level.gametype == "tdm")
        {
            self thread maps\mp\gametypes\tdm::respawn();
        }
        else
        {
            currentorigin = self.origin;
            currentangles = self.angles;

            if(level.gametype == "sd" || level.gametype == "re")
            {
                self thread spawnSpectator(currentorigin + (0, 0, 60), currentangles);
            }
        }
    }

    hud_playerInfo_destroy();
    hud_sprintBar_destroy();
    self.killstreak = 0;
}
respawnBot()
{
    self.pers["team"] = "allies";
    self.pers["weapon"] = "mosin_nagant_mp";
    self spawnPlayer();
}

spawnPlayer()
{
    self notify("spawned");
    if(level.gametype == "dm" || level.gametype == "tdm" || level.gametype == "bel")
    {
        self notify("end_respawn");
    }
    if(level.gametype == "bel")
    {
        self notify("stop weapon timeout");
        self notify ("do_timer_cleanup");
    }

    resettimeout();

    if(level.gametype == "dm")
    {
        //if(isdefined(self.shocked))
        //{
        //	self stopShellshock();
        //	self.shocked = undefined;
        //}
    }

    if(level.gametype == "bel")
    {
        self.respawnwait = false;
    }
    if(level.gametype == "dm")
    {
        self.sessionteam = "none";
    }
    else
    {
        self.sessionteam = self.pers["team"];
    }
    if(level.gametype == "bel")
    {
        self.lastteam = self.pers["team"];
    }
    if(level.gametype == "dm" || level.gametype == "tdm" || level.gametype == "bel")
    {
        self.sessionstate = "playing";
    }
    if(level.gametype != "bel")
    {
        self.spectatorclient = -1;
        self.archivetime = 0;
    }
    if(level.gametype == "sd" || level.gametype == "re" || level.gametype == "tdm" || level.gametype == "bel")
    {
        self.reflectdamage = undefined;

        if(level.gametype == "sd" || level.gametype == "re" || level.gametype == "bel")
        {
            if(level.gametype == "bel")
            {
                if (isdefined(self.spawnMsg))
                    self.spawnMsg destroy();
            }
            else
            {
                if(isdefined(self.spawned))
                    return;
                
                self.sessionstate = "playing";
            }

            if(level.gametype == "bel")
            {
                spawnpointname = "mp_teamdeathmatch_spawn";
                spawnpoints = getEntArray(spawnpointname, "classname");

                spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_MiddleThird(spawnpoints);
            }
            else
            {
                if(self.pers["team"] == "allies")
                {
                    if(level.gametype == "sd")
                    {
                        spawnpointname = "mp_searchanddestroy_spawn_allied";
                    }
                    else if(level.gametype == "re")
                    {
                        spawnpointname = "mp_retrieval_spawn_allied";
                    }
                }
                else
                {
                    if(level.gametype == "sd")
                    {
                        spawnpointname = "mp_searchanddestroy_spawn_axis";
                    }
                    else if(level.gametype == "re")
                    {
                        spawnpointname = "mp_retrieval_spawn_axis";
                    }
                }

                spawnpoints = getEntArray(spawnpointname, "classname");
                spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);
            }
        }
        else if(level.gametype == "tdm")
        {
            spawnpointname = "mp_teamdeathmatch_spawn";
            spawnpoints = getEntArray(spawnpointname, "classname");
            spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam(spawnpoints);
        }
    }
    else if(level.gametype == "dm")
    {
        spawnpointname = "mp_deathmatch_spawn";
        spawnpoints = getEntArray(spawnpointname, "classname");
        spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_DM(spawnpoints);
    }
    
    if(isdefined(spawnpoint))
        self spawn(spawnpoint.origin, spawnpoint.angles);
    else
        maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");

    if(level.gametype == "re")
    {
        //Set their intro text
        /*REMOVED
        if(self.pers["team"] == "allies")
        {
            if (isdefined (game["re_attackers_intro_text"]))
                clientAnnouncement (self,game["re_attackers_intro_text"]);
        }
        else if(self.pers["team"] == "axis")
        {
            if (isdefined (game["re_defenders_intro_text"]))
                clientAnnouncement (self,game["re_defenders_intro_text"]);
        }
        */
    }

    if(level.gametype == "sd" || level.gametype == "re")
    {
        self.spawned = true;
    }
    self.statusicon = "";
    self.maxhealth = 100;
    self.health = self.maxhealth;
    if(level.gametype == "re")
    {
        self.objs_held = 0;
    }
    if(level.gametype == "bel")
    {
        self.pers["savedmodel"] = undefined;

        maps\mp\gametypes\_teams::model();

        maps\mp\gametypes\_teams::loadout();
        
        self setClientCvar("scr_showweapontab", "1");
        self setClientCvar("g_scriptMainMenu", game["menu_weapon_all"]);

        if (self.pers["team"] == "allies")
        {
            if (isdefined (self.pers["LastAlliedWeapon"]))
                self.pers["weapon"] = self.pers["LastAlliedWeapon"];
            else
            {
                if (isdefined (self.pers["nextWeapon"]))
                {
                    self.pers["weapon"] = self.pers["nextWeapon"];
                    self.pers["nextWeapon"] = undefined;
                }
            }
        }
        else if (self.pers["team"] == "axis")
        {
            if (isdefined (self.pers["LastAxisWeapon"]))
                self.pers["weapon"] = self.pers["LastAxisWeapon"];
            else
            {
                if (isdefined (self.pers["nextWeapon"]))
                {
                    self.pers["weapon"] = self.pers["nextWeapon"];
                    self.pers["nextWeapon"] = undefined;
                }
            }
        }

        self giveWeapon(self.pers["weapon"]);
        self giveMaxAmmo(self.pers["weapon"]);
        self setSpawnWeapon(self.pers["weapon"]);

        self.archivetime = 0;
        
        if(self.pers["team"] == "allies")
        {
            self thread maps\mp\gametypes\bel::make_obj_marker();
            self setClientCvar("cg_objectiveText", &"BEL_OBJ_ALLIED");
        }
        else if(self.pers["team"] == "axis")
            self setClientCvar("cg_objectiveText", &"BEL_OBJ_AXIS");
    }
    else
    {
        if(level.gametype == "sd")
        {
            maps\mp\gametypes\re::updateTeamStatus();
        }
        else if(level.gametype == "re")
        {
            maps\mp\gametypes\re::updateTeamStatus();
        }

        if(level.gametype == "sd" || level.gametype == "re")
        {
            if(!isdefined(self.pers["score"]))
                self.pers["score"] = 0;
            self.score = self.pers["score"];
            
            if(!isdefined(self.pers["deaths"]))
                self.pers["deaths"] = 0;
            self.deaths = self.pers["deaths"];
        }

        if(!isdefined(self.pers["savedmodel"]))
            maps\mp\gametypes\_teams::model();
        else
            maps\mp\_utility::loadModel(self.pers["savedmodel"]);
        
        maps\mp\gametypes\_teams::loadout();
    }

    if(level.gametype == "dm")
    {
        self giveWeapon(self.pers["weapon"]);
        self giveMaxAmmo(self.pers["weapon"]);
        self setSpawnWeapon(self.pers["weapon"]);
        
        self setClientCvar("cg_objectiveText", &"DM_KILL_OTHER_PLAYERS");
    }
    else
    {
        if(level.gametype == "sd" || level.gametype == "re")
        {
            if(isdefined(self.pers["weapon1"]) && isdefined(self.pers["weapon2"]))
            {
                self setWeaponSlotWeapon("primary", self.pers["weapon1"]);
                self setWeaponSlotAmmo("primary", 999);
                self setWeaponSlotClipAmmo("primary", 999);

                self setWeaponSlotWeapon("primaryb", self.pers["weapon2"]);
                self setWeaponSlotAmmo("primaryb", 999);
                self setWeaponSlotClipAmmo("primaryb", 999);

                self setSpawnWeapon(self.pers["spawnweapon"]);
            }
            else
            {
                self setWeaponSlotWeapon("primary", self.pers["weapon"]);
                self setWeaponSlotAmmo("primary", 999);
                self setWeaponSlotClipAmmo("primary", 999);

                self setSpawnWeapon(self.pers["weapon"]);
            }
        }
        else if(level.gametype == "tdm")
        {
            self giveWeapon(self.pers["weapon"]);
            self giveMaxAmmo(self.pers["weapon"]);
            self setSpawnWeapon(self.pers["weapon"]);
        }

        if(level.gametype == "sd")
        {
            if(self.pers["team"] == game["attackers"])
                self setClientCvar("cg_objectiveText", &"SD_OBJ_ATTACKERS");
            else if(self.pers["team"] == game["defenders"])
                self setClientCvar("cg_objectiveText", &"SD_OBJ_DEFENDERS");
        }
        else if(level.gametype == "re")
        {
            if(self.pers["team"] == game["re_attackers"])
                self setClientCvar("cg_objectiveText", game["re_attackers_obj_text"]);
            else if(self.pers["team"] == game["re_defenders"])
                self setClientCvar("cg_objectiveText", game["re_defenders_obj_text"]);
        }
        else if(level.gametype == "tdm")
        {
            if(self.pers["team"] == "allies")
                self setClientCvar("cg_objectiveText", &"TDM_KILL_AXIS_PLAYERS");
            else if(self.pers["team"] == "axis")
                self setClientCvar("cg_objectiveText", &"TDM_KILL_ALLIED_PLAYERS");
        }

        if(level.drawfriend)
        {
            if(self.pers["team"] == "allies")
            {
                self.headicon = game["headicon_allies"];
                self.headiconteam = "allies";
            }
            else
            {
                self.headicon = game["headicon_axis"];
                self.headiconteam = "axis";
            }
        }

        if(level.gametype == "bel")
        {
            self.god = false;
            wait 0.05;
            if (isdefined (self))
            {
                if (isdefined (self.blackscreen))
                    self.blackscreen destroy();
                if (isdefined (self.blackscreentext))
                    self.blackscreentext destroy();
                if (isdefined (self.blackscreentext2))
                    self.blackscreentext2 destroy();
                if (isdefined (self.blackscreentimer))
                    self.blackscreentimer destroy();
            }
        }
    }

    self setAirJumps(0);
    self.killstreak = 0;

    hud_playerInfo_create();
    thread hud_sprintBar_create();
}

spawnSpectator(origin, angles)
{
    self notify("spawned");
    if(level.gametype == "dm" || level.gametype == "tdm" || level.gametype == "bel")
    {
        self notify("end_respawn");
    }

    if(level.gametype == "bel")
    {
        self maps\mp\gametypes\bel::check_delete_objective();
    }

    resettimeout();

    if(level.gametype == "dm")
    {
        //if(isdefined(self.shocked))
        //{
        //	self stopShellshock();
        //	self.shocked = undefined;
        //}
    }

    self.sessionstate = "spectator";
    self.spectatorclient = -1;
    self.archivetime = 0;
    if(level.gametype == "sd" || level.gametype == "re" || level.gametype == "tdm" || level.gametype == "bel")
    {
        self.reflectdamage = undefined;
    }
    if(level.gametype == "bel")
    {
        self.pers["savedmodel"] = undefined;
        self.headicon = "";            
    }

    if(level.gametype != "bel")
    {
        if(self.pers["team"] == "spectator")
            self.statusicon = "";
    }

    if(isdefined(origin) && isdefined(angles))
        self spawn(origin, angles);
    else
    {
        if(level.gametype == "sd")
        {
            spawnpointname = "mp_searchanddestroy_intermission";
        }
        else if(level.gametype == "re")
        {
            spawnpointname = "mp_retrieval_intermission";
        }
        else if(level.gametype == "dm")
        {
            spawnpointname = "mp_deathmatch_intermission";
        }
        else if(level.gametype == "tdm" || level.gametype == "bel")
        {
            spawnpointname = "mp_teamdeathmatch_intermission";
        }
        spawnpoints = getEntArray(spawnpointname, "classname");
        spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

        if(isdefined(spawnpoint))
            self spawn(spawnpoint.origin, spawnpoint.angles);
        else
            maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
    }

    if(level.gametype == "sd")
    {
        maps\mp\gametypes\sd::updateTeamStatus();

        if(game["attackers"] == "allies")
            self setClientCvar("cg_objectiveText", &"SD_OBJ_SPECTATOR_ALLIESATTACKING");
        else if(game["attackers"] == "axis")
            self setClientCvar("cg_objectiveText", &"SD_OBJ_SPECTATOR_AXISATTACKING");
    }
    else if(level.gametype == "re")
    {
        maps\mp\gametypes\re::updateTeamStatus();

        //if(game["re_attackers"] == "allies")
        //	self setClientCvar("cg_objectiveText", &"RE_ALLIES", game["re_attackers_obj_text"]);
        //else if(game["re_attackers"] == "axis")
        //	self setClientCvar("cg_objectiveText", &"RE_AXIS", game["re_attackers_obj_text"]);
        self setClientCvar("cg_objectiveText", game["re_spectator_obj_text"]);
    }
    else if(level.gametype == "dm")
    {
        self setClientCvar("cg_objectiveText", &"DM_KILL_OTHER_PLAYERS");
    }
    else if(level.gametype == "tdm")
    {
        self setClientCvar("cg_objectiveText", &"TDM_ALLIES_KILL_AXIS_PLAYERS");
    }
    else if(level.gametype == "bel")
    {
        self setClientCvar("cg_objectiveText", &"BEL_SPECTATOR_OBJS");
    }

    hud_playerInfo_destroy();
    hud_sprintBar_destroy();
}

spawnIntermission()
{
    self notify("spawned");
    if(level.gametype == "dm" || level.gametype == "tdm" || level.gametype == "bel")
    {
        self notify("end_respawn");
    }

    resettimeout();

    if(level.gametype == "dm")
    {
        //if(isdefined(self.shocked))
        //{
        //	self stopShellshock();
        //	self.shocked = undefined;
        //}
    }

    self.sessionstate = "intermission";
    self.spectatorclient = -1;
    self.archivetime = 0;
    if(level.gametype == "sd" || level.gametype == "re" || level.gametype == "tdm" || level.gametype == "bel")
    {
        self.reflectdamage = undefined;
    }

    if(level.gametype == "sd")
    {
        spawnpointname = "mp_searchanddestroy_intermission";
    }
    else if(level.gametype == "re")
    {
        spawnpointname = "mp_retrieval_intermission";
    }
    else if(level.gametype == "dm")
    {
        spawnpointname = "mp_deathmatch_intermission";
    }
    else if(level.gametype == "tdm" || level.gametype == "bel")
    {
        spawnpointname = "mp_teamdeathmatch_intermission";
    }
    spawnpoints = getEntArray(spawnpointname, "classname");
    if(level.gametype == "bel")
    {
        spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_MiddleThird(spawnpoints);
    }
    else
    {
        spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);
    }

    if(isdefined(spawnpoint))
        self spawn(spawnpoint.origin, spawnpoint.angles);
    else
        maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
    
    if(level.gametype == "bel")
    {
        if (isdefined (self.blackscreen))
            self.blackscreen destroy();
        if (isdefined (self.blackscreentext))
            self.blackscreentext destroy();
        if (isdefined (self.blackscreentext2))
            self.blackscreentext2 destroy();
        if (isdefined (self.blackscreentimer))
            self.blackscreentimer destroy();            
    }
}

killcam(attackerNum, delay, option)
{
    self endon("spawned");

    if(level.gametype == "dm" || level.gametype == "tdm")
    {
        //previousorigin = self.origin;
        //previousangles = self.angles;
    }

    // killcam
    if(attackerNum < 0)
        return;
    
    if(level.gametype == "bel")
    {
        if (option == "axis to axis")
            wait 2;
        else if (option == "allies to axis")
        {
            self.pers["team"] = ("axis");
            self.sessionteam = ("axis");
            wait 2;
        }
    }

    self.sessionstate = "spectator";
    self.spectatorclient = attackerNum;
    self.archivetime = delay + 4;

    // wait till the next server frame to allow code a chance to update archivetime if it needs trimming
    wait 0.05;

    if(self.archivetime <= delay)
    {
        self.spectatorclient = -1;
        self.archivetime = 0;
        if(level.gametype == "dm" || level.gametype == "tdm")
        {
            self.sessionstate = "dead";

            if(level.gametype == "dm")
            {
                self thread maps\mp\gametypes\dm::respawn();
            }
            else if(level.gametype == "tdm")
            {
                self thread maps\mp\gametypes\tdm::respawn();
            }
        }
        else if(level.gametype == "bel")
        {
            if (option == "axis to axis")
            {
                if (!isalive (self))
                    self thread maps\mp\gametypes\bel::respawn("auto",0);
            }
            else if (option == "allies to axis")
                self maps\mp\gametypes\bel::move_to_axis(0,"nodelay on respawn");
        }

        return;
    }

    if(!isdefined(self.kc_topbar))
    {
        self.kc_topbar = newClientHudElem(self);
        self.kc_topbar.archived = false;
        self.kc_topbar.x = 0;
        self.kc_topbar.y = 0;
        self.kc_topbar.alpha = 0.5;
        self.kc_topbar setShader("black", 640, 112);
    }

    if(!isdefined(self.kc_bottombar))
    {
        self.kc_bottombar = newClientHudElem(self);
        self.kc_bottombar.archived = false;
        self.kc_bottombar.x = 0;
        self.kc_bottombar.y = 368;
        self.kc_bottombar.alpha = 0.5;
        self.kc_bottombar setShader("black", 640, 112);
    }

    if(!isdefined(self.kc_title))
    {
        self.kc_title = newClientHudElem(self);
        self.kc_title.archived = false;
        self.kc_title.x = 320;
        self.kc_title.y = 60;
        self.kc_title.alignX = "center";
        self.kc_title.alignY = "middle";
        self.kc_title.sort = 1; // force to draw after the bars
        self.kc_title.fontScale = 2.5;
    }
    self.kc_title setText(&"MPSCRIPT_KILLCAM");

    if(!isdefined(self.kc_skiptext))
    {
        self.kc_skiptext = newClientHudElem(self);
        self.kc_skiptext.archived = false;
        self.kc_skiptext.x = 320;
        self.kc_skiptext.y = self.kc_title.y + 30;
        self.kc_skiptext.alignX = "center";
        self.kc_skiptext.alignY = "middle";
        self.kc_skiptext.sort = 1; // force to draw after the bars
    }
    if(level.gametype == "dm" || level.gametype == "tdm" || level.gametype == "bel")
    {
        self.kc_skiptext setText(&"MPSCRIPT_PRESS_ACTIVATE_TO_RESPAWN");
    }
    else
    {
        self.kc_skiptext setText(&"MPSCRIPT_PRESS_ACTIVATE_TO_SKIP");
    }

    if(!isdefined(self.kc_timer))
    {
        self.kc_timer = newClientHudElem(self);
        self.kc_timer.archived = false;
        self.kc_timer.x = 320;
        self.kc_timer.y = 435;
        self.kc_timer.alignX = "center";
        self.kc_timer.alignY = "middle";
        self.kc_timer.fontScale = 2;
        self.kc_timer.sort = 1;
    }
    self.kc_timer setTenthsTimer(self.archivetime - delay);

    self thread spawnedKillcamCleanup();
    self thread waitSkipKillcamButton();
    self thread waitKillcamTime();
    self waittill("end_killcam");

    self removeKillcamElements();

    self.spectatorclient = -1;
    self.archivetime = 0;
    //if(level.gametype == "dm" || level.gametype == "tdm")
    //{
        //self.sessionstate = "dead";
    //}

    if(level.gametype == "dm")
    {
        //self thread spawnSpectator(previousorigin + (0, 0, 60), previousangles);
        self thread maps\mp\gametypes\dm::respawn();
    }
    else if(level.gametype == "tdm")
    {
        //self thread spawnSpectator(previousorigin + (0, 0, 60), previousangles);
        self thread maps\mp\gametypes\tdm::respawn();
    }
    else if(level.gametype == "bel")
    {
        if (option == "axis to axis")
        {
            if (!isalive (self))
                self thread maps\mp\gametypes\bel::respawn("auto",0);
        }
        else if (option == "allies to axis")
            self maps\mp\gametypes\bel::move_to_axis(0,"nodelay on respawn");
    }
}

waitKillcamTime()
{
    self endon("end_killcam");
    
    wait (self.archivetime - 0.05);
    self notify("end_killcam");
}

waitSkipKillcamButton()
{
    self endon("end_killcam");
    
    while(self useButtonPressed())
        wait .05;

    while(!(self useButtonPressed()))
        wait .05;
    
    self notify("end_killcam");	
}

removeKillcamElements()
{
    if(isdefined(self.kc_topbar))
        self.kc_topbar destroy();
    if(isdefined(self.kc_bottombar))
        self.kc_bottombar destroy();
    if(isdefined(self.kc_title))
        self.kc_title destroy();
    if(isdefined(self.kc_skiptext))
        self.kc_skiptext destroy();
    if(isdefined(self.kc_timer))
        self.kc_timer destroy();
}

spawnedKillcamCleanup()
{
    self endon("end_killcam");

    self waittill("spawned");
    self removeKillcamElements();
}

startGame()
{
    level.starttime = getTime();

    if (level.gametype == "sd" || level.gametype == "re")
    {
        thread startRound();        
    }
    else
    {
        if(level.timelimit > 0)
        {
            createClock();
        }
    }
    
    for(;;)
    {
        checkTimeLimit();
        wait 1;
    }
}

startRound()
{
    thread maps\mp\gametypes\_teams::sayMoveIn();

    createClock();

    if(game["matchstarted"])
    {
        level.clock.color = (0, 1, 0);

        if((level.roundlength * 60) > level.graceperiod)
        {
            wait level.graceperiod;

            level.roundstarted = true;
            if(!level.bombplanted)
                level.clock.color = (1, 1, 1);

            // Players on a team but without a weapon show as dead since they can not get in this round
            players = getEntArray("player", "classname");
            for(i = 0; i < players.size; i++)
            {
                player = players[i];

                if(player.sessionteam != "spectator" && !isdefined(player.pers["weapon"]))
                    player.statusicon = "gfx/hud/hud@status_dead.tga";
            }
        
            wait ((level.roundlength * 60) - level.graceperiod);
        }
        else
            wait (level.roundlength * 60);
    }
    else	
    {
        level.clock.color = (1, 1, 1);
        wait (level.roundlength * 60);
    }
    
    if(level.roundended)
        return;

    if (level.gametype == "sd")
    {
        if(level.bombplanted)
            return;

        if(!level.exist[game["attackers"]] || !level.exist[game["defenders"]])
        {
            level thread maps\mp\gametypes\sd::hud_announce(&"SD_TIMEHASEXPIRED");
            level thread endRound("draw", true);
            return;
        }

        level thread maps\mp\gametypes\sd::hud_announce(&"SD_TIMEHASEXPIRED");
        level thread endRound(game["defenders"], true);
    }
    else if (level.gametype == "re")
    {
        if(!level.exist[game["re_attackers"]] || !level.exist[game["re_defenders"]])
        {
            announcement(&"RE_TIMEEXPIRED");
            level thread endRound("draw",true);
            return;
        }

        announcement(&"RE_TIMEEXPIRED");
        level thread endRound(game["re_defenders"], true);
    }
}

createClock()
{
    level.clock = newHudElem();
    level.clock.x = 320;
    level.clock.y = 465;
    level.clock.alignX = "center";
    level.clock.alignY = "middle";
    level.clock.font = "bigfixed";
    if (level.gametype == "sd" || level.gametype == "re")
    {
        level.clock setTimer(level.roundlength * 60);
    }
    else
    {
        level.clock setTimer(level.timelimit * 60);
    }
}

roundcam_level(timeWaitedBeforeRoundcam, winningteam, videoDurationBeforeKill)
{
    if (!isdefined(level.kc_topbar))
    {
        level.kc_topbar = newHudElem();
        level.kc_topbar.archived = false;
        level.kc_topbar.x = 0;
        level.kc_topbar.y = 0;
        level.kc_topbar.alpha = 0.5;
        level.kc_topbar setShader("black", 640, 112);
    }

    if (!isdefined(level.kc_bottombar))
    {
        level.kc_bottombar = newHudElem();
        level.kc_bottombar.archived = false;
        level.kc_bottombar.x = 0;
        level.kc_bottombar.y = 368;
        level.kc_bottombar.alpha = 0.5;
        level.kc_bottombar setShader("black", 640, 112);
    }

    if (!isdefined(level.kc_title))
    {
        level.kc_title = newHudElem();
        level.kc_title.archived = false;
        level.kc_title.x = 320;
        level.kc_title.y = 60;
        level.kc_title.alignX = "center";
        level.kc_title.alignY = "middle";
        level.kc_title.sort = 1; // force to draw after the bars
        level.kc_title.fontScale = 2.5;
    }

    if(winningteam == "allies")
        level.kc_title setText(&"MPSCRIPT_ALLIES_WIN");
    else if(winningteam == "axis")
        level.kc_title setText(&"MPSCRIPT_AXIS_WIN");
    else
        level.kc_title setText(&"MPSCRIPT_ROUNDCAM");
    
    if (!isdefined(level.kc_skiptext))
    {
        level.kc_skiptext = newHudElem();
        level.kc_skiptext.archived = false;
        level.kc_skiptext.x = 320;
        level.kc_skiptext.y = level.kc_title.y + 30;
        level.kc_skiptext.alignX = "center";
        level.kc_skiptext.alignY = "middle";
        level.kc_skiptext.sort = 1; // force to draw after the bars
    }
    if(game["alliedscore"] < level.scorelimit && game["axisscore"] < level.scorelimit)
        level.kc_skiptext setText(&"MPSCRIPT_STARTING_NEW_ROUND");

    if (!isdefined(level.kc_timer))
    {
        level.kc_timer = newHudElem();
        level.kc_timer.archived = false;
        level.kc_timer.x = 320;
        level.kc_timer.y = 435;
        level.kc_timer.alignX = "center";
        level.kc_timer.alignY = "middle";
        level.kc_timer.fontScale = 2;
        level.kc_timer.sort = 1;
    }
    level.kc_timer setTenthsTimer(videoDurationBeforeKill);

    level thread spawnedKillcamCleanup_rc();
    wait (timeWaitedBeforeRoundcam + videoDurationBeforeKill);
    level removeKillcamElements_rc();

    level notify("roundcam_ended");
}
roundcam_client(timeWaitedBeforeRoundcam, videoDurationBeforeKill)
{
    spawnSpectator();

    if (level.gametype == "sd")
    {
        if(isdefined(level.bombcam))
            self thread spawnSpectator(level.bombcam.origin, level.bombcam.angles);
        else
            self.spectatorclient = level.playercam;
    }
    else if (level.gametype == "re")
    {
        if(isdefined(level.goalcam))
            self thread spawnSpectator(level.goalcam.origin, level.goalcam.angles);
        else
            self.spectatorclient = level.playercam;
    }

    self.archivetime = timeWaitedBeforeRoundcam + videoDurationBeforeKill;
    wait (self.archivetime);
    self.spectatorclient = -1;
    self.archivetime = 0;
}
removeKillcamElements_rc()
{
    if(isdefined(level.kc_topbar))
        level.kc_topbar destroy();
    if(isdefined(level.kc_bottombar))
        level.kc_bottombar destroy();
    if(isdefined(level.kc_title))
        level.kc_title destroy();
    if(isdefined(level.kc_skiptext))
        level.kc_skiptext destroy();
    if(isdefined(level.kc_timer))
        level.kc_timer destroy();
}
spawnedKillcamCleanup_rc()
{
    level waittill("roundcam_ended");
    level removeKillcamElements();
}

resetScores()
{
    players = getEntArray("player", "classname");
    for(i = 0; i < players.size; i++)
    {
        player = players[i];
        player.pers["score"] = 0;
        player.pers["deaths"] = 0;
    }

    game["alliedscore"] = 0;
    setTeamScore("allies", game["alliedscore"]);
    game["axisscore"] = 0;
    setTeamScore("axis", game["axisscore"]);
}

endRound(roundwinner, timeexpired)
{
    if(level.roundended)
        return;
    level.roundended = true;

    if(!isdefined(timeexpired))
        timeexpired = false;
    
    winners = "";
    losers = "";
    
    if(roundwinner == "allies")
    {
        game["alliedscore"]++;
        setTeamScore("allies", game["alliedscore"]);
        
        players = getEntArray("player", "classname");
        for(i = 0; i < players.size; i++)
        {
            if ( (isdefined (players[i].pers["team"])) && (players[i].pers["team"] == "allies") )
                winners = (winners + ";" + players[i].name);
            else if ( (isdefined (players[i].pers["team"])) && (players[i].pers["team"] == "axis") )
                losers = (losers + ";" + players[i].name);
            players[i] playLocalSound("MP_announcer_allies_win");
        }
        logPrint("W;allies" + winners + "\n");
        logPrint("L;axis" + losers + "\n");
    }
    else if(roundwinner == "axis")
    {
        game["axisscore"]++;
        setTeamScore("axis", game["axisscore"]);

        players = getEntArray("player", "classname");
        for(i = 0; i < players.size; i++)
        {
            if ( (isdefined (players[i].pers["team"])) && (players[i].pers["team"] == "axis") )
                winners = (winners + ";" + players[i].name);
            else if ( (isdefined (players[i].pers["team"])) && (players[i].pers["team"] == "allies") )
                losers = (losers + ";" + players[i].name);
            players[i] playLocalSound("MP_announcer_axis_win");
        }
        logPrint("W;axis" + winners + "\n");
        logPrint("L;allies" + losers + "\n");
    }
    else if(roundwinner == "draw")
    {
        players = getEntArray("player", "classname");
        for(i = 0; i < players.size; i++)
            players[i] playLocalSound("MP_announcer_round_draw");
    }

    if(roundwinner == "reset")
        if(isDefined(level.clock))
            level.clock destroy();

    if((getCvar("scr_roundcam") == "1") && (!timeexpired) && (game["matchstarted"]))
    {
        if(level.gametype == "sd" && ((isdefined(level.playercam) || isdefined(level.bombcam)) && roundwinner != "draw" && roundwinner != "reset")
            || level.gametype == "re" && ((isdefined(level.playercam) || isdefined(level.goalcam)) && roundwinner != "draw" && roundwinner != "reset"))
        {
            delay = 2;	// Delay the player becoming a spectator
            wait delay;

            delay_additional = 1;
            wait delay_additional;
            delay += delay_additional;


            timeWaitedBeforeRoundcam = delay;
            videoDurationBeforeKill = 5;
            
            players = getEntArray("player", "classname");
            if (players.size > 0)
            {
                savePlayerWeapons();
                level thread roundcam_level(timeWaitedBeforeRoundcam, roundwinner, videoDurationBeforeKill);
                for (i = 0; i < players.size; i++)
                {
                    players[i] thread roundcam_client(timeWaitedBeforeRoundcam, videoDurationBeforeKill);
                }
                level waittill("roundcam_ended");
            }
            else
            {
                wait 7;
            }
        }
        else
        {
            wait 5;
        }
    }
    else
    {
        wait 5;
    }

    if(game["matchstarted"])
    {
        checkScoreLimit();
        game["roundsplayed"]++;
        checkRoundLimit();
    }

    if(!game["matchstarted"] && roundwinner == "reset")
    {
        game["matchstarted"] = true;
        thread resetScores();
        game["roundsplayed"] = 0;
    }

    if(level.mapended)
        return;
    level.mapended = true;

    if(level.timelimit > 0)
    {
        timepassed = (getTime() - level.starttime) / 1000;
        timepassed = timepassed / 60.0;

        game["timeleft"] = level.timelimit - timepassed;
    }

    if ( (level.teambalance > 0) && (game["BalanceTeamsNextRound"]) )
    {
        level.lockteams = true;
        level thread maps\mp\gametypes\_teams::TeamBalance();
        level waittill ("Teams Balanced");
        wait 4;
    }
    map_restart(true);
}
savePlayerWeapons()
{
    // for all living players store their weapons
    players = getEntArray("player", "classname");
    for (i = 0; i < players.size; i++)
    {
        player = players[i];
        if (isdefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
        {
            primary = player getWeaponSlotWeapon("primary");
            primaryb = player getWeaponSlotWeapon("primaryb");

            // If a menu selection was made
            if (isdefined(player.oldweapon))
            {
                // If a new weapon has since been picked up (this fails when a player picks up a weapon the same as his original)
                if (player.oldweapon != primary && player.oldweapon != primaryb && primary != "none")
                {
                    player.pers["weapon1"] = primary;
                    player.pers["weapon2"] = primaryb;
                    player.pers["spawnweapon"] = player getCurrentWeapon();
                } // If the player's menu chosen weapon is the same as what is in the primaryb slot, swap the slots
                else if (player.pers["weapon"] == primaryb)
                {
                    player.pers["weapon1"] = primaryb;
                    player.pers["weapon2"] = primary;
                    player.pers["spawnweapon"] = player.pers["weapon1"];
                } // Give them the weapon they chose from the menu
                else
                {
                    player.pers["weapon1"] = player.pers["weapon"];
                    player.pers["weapon2"] = primaryb;
                    player.pers["spawnweapon"] = player.pers["weapon1"];
                }
            } // No menu choice was ever made, so keep their weapons and spawn them with what they're holding, unless it's a pistol or grenade
            else
            {
                if(primary == "none")
                    player.pers["weapon1"] = player.pers["weapon"];
                else
                    player.pers["weapon1"] = primary;
                    
                player.pers["weapon2"] = primaryb;

                spawnweapon = player getCurrentWeapon();
                if(!maps\mp\gametypes\_teams::isPistolOrGrenade(spawnweapon))
                    player.pers["spawnweapon"] = spawnweapon;
                else
                    player.pers["spawnweapon"] = player.pers["weapon1"];
            }
        }
    }
}

endMap()
{
    if(level.gametype == "bel")
    {
        level notify ("End of Round");
    }
    game["state"] = "intermission";
    level notify("intermission");

    hud_alivePlayers_destroy();
    hud_serverInfo_destroy();
    players = getEntArray("player", "classname");
    for (i = 0; i < players.size; i++)
    {
        players[i] hud_playerInfo_destroy();
        players[i] hud_sprintBar_destroy();
    }

    if(level.gametype == "sd" || level.gametype == "re")
    {
        if(level.gametype == "sd")
        {
            if(isdefined(level.bombmodel))
                level.bombmodel stopLoopSound();
        }
        
        if(game["alliedscore"] == game["axisscore"])
            text = &"MPSCRIPT_THE_GAME_IS_A_TIE";
        else if(game["alliedscore"] > game["axisscore"])
            text = &"MPSCRIPT_ALLIES_WIN";
        else
            text = &"MPSCRIPT_AXIS_WIN";
    }
    else if(level.gametype == "dm" || level.gametype == "bel")
    {
        players = getEntArray("player", "classname");
        for(i = 0; i < players.size; i++)
        {
            player = players[i];

            if(isdefined(player.pers["team"]) && player.pers["team"] == "spectator")
                continue;

            if(!isdefined(highscore))
            {
                highscore = player.score;
                playername = player;
                name = player.name;
                continue;
            }

            if(player.score == highscore)
                tied = true;
            else if(player.score > highscore)
            {
                tied = false;
                highscore = player.score;
                playername = player;
                name = player.name;
            }
        }
    }
    else if(level.gametype == "tdm")
    {
        alliedscore = getTeamScore("allies");
        axisscore = getTeamScore("axis");
        
        if(alliedscore == axisscore)
        {
            winningteam = "tie";
            losingteam = "tie";
            text = "MPSCRIPT_THE_GAME_IS_A_TIE";
        }
        else if(alliedscore > axisscore)
        {
            winningteam = "allies";
            losingteam = "axis";
            text = &"MPSCRIPT_ALLIES_WIN";
        }
        else
        {
            winningteam = "axis";
            losingteam = "allies";
            text = &"MPSCRIPT_AXIS_WIN";
        }
        
        if ( (winningteam == "allies") || (winningteam == "axis") )
        {
            winners = "";
            losers = "";
        }
    }

    players = getEntArray("player", "classname");
    for(i = 0; i < players.size; i++)
    {
        player = players[i];

        if(level.gametype == "tdm")
        {
            if ( (winningteam == "allies") || (winningteam == "axis") )
            {
                if ( (isdefined (player.pers["team"])) && (player.pers["team"] == winningteam) )
                        winners = (winners + ";" + player.name);
                else if ( (isdefined (player.pers["team"])) && (player.pers["team"] == losingteam) )
                        losers = (losers + ";" + player.name);
            }                
        }

        player closeMenu();
        player setClientCvar("g_scriptMainMenu", "main");
        if(level.gametype == "sd" || level.gametype == "re" || level.gametype == "tdm")
        {
            player setClientCvar("cg_objectiveText", text);
        }
        else if(level.gametype == "dm" || level.gametype == "bel")
        {
            if(isdefined(tied) && tied == true)
                player setClientCvar("cg_objectiveText", &"MPSCRIPT_THE_GAME_IS_A_TIE");
            else if(isdefined(playername))
                player setClientCvar("cg_objectiveText", &"MPSCRIPT_WINS", playername);
        }
        player spawnIntermission();
    }
    if(level.gametype == "dm" || level.gametype == "bel")
    {
        if (isdefined (name))
            logPrint("W;;" + name + "\n");
    }
    else if(level.gametype == "tdm")
    {
        if ( (winningteam == "allies") || (winningteam == "axis") )
        {
            logPrint("W;" + winningteam + winners + "\n");
            logPrint("L;" + losingteam + losers + "\n");
        }
    }

    wait 5;

    mapvote::start();
    
    exitLevel(false);
}

checkTimeLimit()
{
    if(level.timelimit <= 0)
        return;
    
    timepassed = (getTime() - level.starttime) / 1000;
    timepassed = timepassed / 60.0;

    if (level.gametype == "sd" || level.gametype == "re")
    {
        if(timepassed < game["timeleft"])
            return;
    }
    else
    {
        if(timepassed < level.timelimit)
            return;
    }
    
    if(level.mapended)
        return;
    level.mapended = true;

    if (level.gametype != "bel")
    {
        iprintln(&"MPSCRIPT_TIME_LIMIT_REACHED");
    }
    endMap();
}

checkScoreLimit()
{
    if(level.scorelimit <= 0)
        return;
    
    if(game["alliedscore"] < level.scorelimit && game["axisscore"] < level.scorelimit)
        return;

    if(level.mapended)
        return;
    level.mapended = true;

    iprintln(&"MPSCRIPT_SCORE_LIMIT_REACHED");
    endMap();
}

checkRoundLimit()
{
    if(level.roundlimit <= 0)
        return;
    
    if(game["roundsplayed"] < level.roundlimit)
        return;
    
    if(level.mapended)
        return;
    level.mapended = true;

    iprintln(&"MPSCRIPT_ROUND_LIMIT_REACHED");
    endMap();
}

printJoinedTeam(team)
{
    if(team == "allies")
        iprintln(&"MPSCRIPT_JOINED_ALLIES", self);
    else if(team == "axis")
        iprintln(&"MPSCRIPT_JOINED_AXIS", self);
}

//// hud_serverInfo
hud_serverInfo_create()
{
    serverStartTime = getServerStartTime();
    rebootDate = strftime(serverStartTime, "utc", "%m/%d/%Y %I:%M %p %Z");
    underCompass_text = "Last reboot: " + rebootDate;
    level.hud_serverInfo_rebootDate = newHudElem();
    level.hud_serverInfo_rebootDate.sort = -1;
    level.hud_serverInfo_rebootDate.x = 2;
    level.hud_serverInfo_rebootDate.y = 473;
    level.hud_serverInfo_rebootDate.fontScale = 0.62;
    underCompass_text_localized = makeLocalizedString(underCompass_text);
    level.hud_serverInfo_rebootDate setText(underCompass_text_localized);

    level.hud_serverInfo_g_speed = newHudElem();
    level.hud_serverInfo_g_speed.sort = -1;
    level.hud_serverInfo_g_speed.x = level.hud_sprint_bar_x;
    level.hud_serverInfo_g_speed.y = 470;
    level.hud_serverInfo_g_speed.fontScale = 0.7;
    level.hud_serverInfo_g_speed.label = &"g_speed: ";

    level.hud_serverInfo_sprint_scale = newHudElem();
    level.hud_serverInfo_sprint_scale.sort = -1;
    level.hud_serverInfo_sprint_scale.x = level.hud_serverInfo_g_speed.x + 60;
    level.hud_serverInfo_sprint_scale.y = level.hud_serverInfo_g_speed.y;
    level.hud_serverInfo_sprint_scale.fontScale = 0.7;
    level.hud_serverInfo_sprint_scale.label = &"Sprint scale: ";

    level.hud_serverInfo_score_limit = newHudElem();
    level.hud_serverInfo_score_limit.sort = -1;
    level.hud_serverInfo_score_limit.x = level.clock.x + 60;
    level.hud_serverInfo_score_limit.y = level.hud_serverInfo_g_speed.y;
    level.hud_serverInfo_score_limit.fontScale = 0.7;
    level.hud_serverInfo_score_limit.label = &"Score limit: ";
    
    thread hud_serverInfo_update();
}
hud_serverInfo_update()
{
    level endon("intermission");

    initDone = false;

    for(;;)
    {
        g_speed = getCvar("g_speed");
        player_sprintSpeedScale = getCvarFloat("player_sprintSpeedScale");

        if (!initDone
            || level.g_speed_backup != g_speed
            || level.player_sprintSpeedScale_backup != player_sprintSpeedScale
            || level.scorelimit_backup != level.scorelimit)
        {
            hud_serverInfo_setText(g_speed, player_sprintSpeedScale);
            if(!initDone)
                initDone = true;
        }

        wait .75;
        wait .05;
    }
}
hud_serverInfo_setText(g_speed, player_sprintSpeedScale)
{
    level.g_speed_backup = g_speed;
    level.hud_serverInfo_g_speed setValue(level.g_speed_backup);

    level.player_sprintSpeedScale_backup = player_sprintSpeedScale;
    level.hud_serverInfo_sprint_scale setValue(level.player_sprintSpeedScale_backup);

    level.scorelimit_backup = level.scorelimit;
    level.hud_serverInfo_score_limit setValue(level.scorelimit_backup);
}
hud_serverInfo_destroy()
{
    if(isDefined(level.hud_serverInfo_rebootDate))
        level.hud_serverInfo_rebootDate destroy();
    if(isDefined(level.hud_serverInfo_g_speed))
        level.hud_serverInfo_g_speed destroy();
    if(isDefined(level.hud_serverInfo_sprint_scale))
        level.hud_serverInfo_sprint_scale destroy();
    if(isDefined(level.hud_serverInfo_score_limit))
        level.hud_serverInfo_score_limit destroy();
}
////

//// hud_alivePlayers
hud_alivePlayers_create()
{
    level endon("intermission");
    
    hud_enemies_y = 8;
    hud_vs_y = hud_enemies_y + 18;
    hud_friends_y = hud_vs_y + 11;

    hud_enemies_color = (1, 0, 0);
    hud_friends_color = (0, 1, 0);

    hud_enemies_fontScale = 1.6;
    hud_friends_fontScale = 1.1;

    vs = &"VS";
    
    // Allies and Axis vs
    level.hud_alivePlayers_vs = [];
    level.hud_alivePlayers_vs[level.hud_alivePlayers_vs.size] = newTeamHudElem("allies");
    level.hud_alivePlayers_vs[level.hud_alivePlayers_vs.size] = newTeamHudElem("axis");
    for (i = 0; i < level.hud_alivePlayers_vs.size; i++)
    {
        level.hud_alivePlayers_vs[i].alignX = "center";
        level.hud_alivePlayers_vs[i].alignY = "middle";
        level.hud_alivePlayers_vs[i].x = 320;
        level.hud_alivePlayers_vs[i].y = hud_vs_y;
        level.hud_alivePlayers_vs[i].fontScale = 0.7;
        level.hud_alivePlayers_vs[i] setText(vs);
    }
    
    if (level.gametype != "dm")
    {
        // Spectator' vs
        level.hud_alivePlayers_spectator_vs = newTeamHudElem("spectator");
        level.hud_alivePlayers_spectator_vs.alignX = "center";
        level.hud_alivePlayers_spectator_vs.alignY = "middle";
        level.hud_alivePlayers_spectator_vs.x = 320;
        level.hud_alivePlayers_spectator_vs.y = 12;
        level.hud_alivePlayers_spectator_vs.fontScale = 0.8;
        level.hud_alivePlayers_spectator_vs setText(vs);

        // Spectator' allies
        level.hud_alivePlayers_spectator_allies = newTeamHudElem("spectator");
        level.hud_alivePlayers_spectator_allies.alignX = "left";
        level.hud_alivePlayers_spectator_allies.alignY = "middle";
        level.hud_alivePlayers_spectator_allies.x = level.hud_alivePlayers_spectator_vs.x - 80;
        level.hud_alivePlayers_spectator_allies.y = 12;
        level.hud_alivePlayers_spectator_allies.fontScale = 1.2;
        level.hud_alivePlayers_spectator_allies.label = &"Allies: ";

        // Spectator' axis
        level.hud_alivePlayers_spectator_axis = newTeamHudElem("spectator");
        level.hud_alivePlayers_spectator_axis.alignX = "right";
        level.hud_alivePlayers_spectator_axis.alignY = "middle";
        level.hud_alivePlayers_spectator_axis.x = level.hud_alivePlayers_spectator_vs.x + 80 - 6;
        level.hud_alivePlayers_spectator_axis.y = 12;
        level.hud_alivePlayers_spectator_axis.fontScale = 1.2;
        level.hud_alivePlayers_spectator_axis.label = &"Axis: ";
    }

    // Unable to retrieve hud team after creation, so do 1 by 1 for now
    
    // Allies' friends
    level.hud_alivePlayers_allies_allies = newTeamHudElem("allies");
    level.hud_alivePlayers_allies_allies.alignX = "center";
    level.hud_alivePlayers_allies_allies.alignY = "middle";
    level.hud_alivePlayers_allies_allies.x = 320;
    level.hud_alivePlayers_allies_allies.y = hud_friends_y;
    level.hud_alivePlayers_allies_allies.fontScale = hud_friends_fontScale;
    level.hud_alivePlayers_allies_allies.color = hud_friends_color;

    // Allies' enemies
    level.hud_alivePlayers_allies_axis = newTeamHudElem("allies");
    level.hud_alivePlayers_allies_axis.alignX = "center";
    level.hud_alivePlayers_allies_axis.alignY = "middle";
    level.hud_alivePlayers_allies_axis.x = 320;
    level.hud_alivePlayers_allies_axis.y = hud_enemies_y;
    level.hud_alivePlayers_allies_axis.fontScale = hud_enemies_fontScale;
    level.hud_alivePlayers_allies_axis.color = hud_enemies_color;

    // Axis' friends
    level.hud_alivePlayers_axis_axis = newTeamHudElem("axis");
    level.hud_alivePlayers_axis_axis.alignX = "center";
    level.hud_alivePlayers_axis_axis.alignY = "middle";
    level.hud_alivePlayers_axis_axis.x = 320;
    level.hud_alivePlayers_axis_axis.y = hud_friends_y;
    level.hud_alivePlayers_axis_axis.fontScale = hud_friends_fontScale;
    level.hud_alivePlayers_axis_axis.color = hud_friends_color;

    // Axis' enemies
    level.hud_alivePlayers_axis_allies = newTeamHudElem("axis");
    level.hud_alivePlayers_axis_allies.alignX = "center";
    level.hud_alivePlayers_axis_allies.alignY = "middle";
    level.hud_alivePlayers_axis_allies.x = 320;
    level.hud_alivePlayers_axis_allies.y = hud_enemies_y;
    level.hud_alivePlayers_axis_allies.fontScale = hud_enemies_fontScale;
    level.hud_alivePlayers_axis_allies.color = hud_enemies_color;

    for(;;)
    {
        aliveAllies = getTeamPlayersAlive("allies");
        aliveAxis = getTeamPlayersAlive("axis");
        
        level.hud_alivePlayers_allies_allies setValue(aliveAllies);
        level.hud_alivePlayers_allies_axis setValue(aliveAxis);

        level.hud_alivePlayers_axis_axis setValue(aliveAxis);
        level.hud_alivePlayers_axis_allies setValue(aliveAllies);

        if (level.gametype != "dm")
        {
            level.hud_alivePlayers_spectator_allies setValue(aliveAllies);
            level.hud_alivePlayers_spectator_axis setValue(aliveAxis);
        }

        wait .05;
    }
}
hud_alivePlayers_destroy()
{
    // Allies and Axis vs
    if(isDefined(level.hud_alivePlayers_vs))
        for(i = 0; i < level.hud_alivePlayers_vs.size; i++)
            if(isDefined(level.hud_alivePlayers_vs[i]))
                level.hud_alivePlayers_vs[i] destroy();

    // Spectator
    if(isDefined(level.hud_alivePlayers_spectator_vs))
        level.hud_alivePlayers_spectator_vs destroy();
    if(isDefined(level.hud_alivePlayers_spectator_allies))
        level.hud_alivePlayers_spectator_allies destroy();
    if(isDefined(level.hud_alivePlayers_spectator_axis))
        level.hud_alivePlayers_spectator_axis destroy();

    // Allies
    if(isDefined(level.hud_alivePlayers_allies_allies))
        level.hud_alivePlayers_allies_allies destroy();
    if(isDefined(level.hud_alivePlayers_allies_axis))
        level.hud_alivePlayers_allies_axis destroy();

    // Axis
    if(isDefined(level.hud_alivePlayers_axis_axis))
        level.hud_alivePlayers_axis_axis destroy();
    if(isDefined(level.hud_alivePlayers_axis_allies))
        level.hud_alivePlayers_axis_allies destroy();
}
////

//// hud_damageFeedback
hud_damageFeedback_create(iDamage, victim_will_die)
{
    self endon("spawned");
    hud_damageFeedback_destroy();

    if (victim_will_die)
    {
        color = (0.38, 1, 0.4);
    }
    else
    {
        self.hud_damageFeedback_value = newClientHudElem(self);
        self.hud_damageFeedback_value.x = 335;
        self.hud_damageFeedback_value.y = 225;
        self.hud_damageFeedback_value.alpha = 1;
        self.hud_damageFeedback_value.color = (0.98, 0.69, 0);
        self.hud_damageFeedback_value setValue(iDamage);
        self.hud_damageFeedback_value fadeOverTime(1);
        self.hud_damageFeedback_value.alpha = 0;
    }
    
    self.hud_damageFeedback = newClientHudElem(self);
    self.hud_damageFeedback.alignX = "center";
    self.hud_damageFeedback.alignY = "middle";
    self.hud_damageFeedback.x = 320;
    self.hud_damageFeedback.y = 240;
    self.hud_damageFeedback.alpha = 1;
    if(victim_will_die)
        self.hud_damageFeedback.color = color;
    self.hud_damageFeedback setShader("gfx/hud/damage_feedback.dds", 24, 24);

    self.hud_damageFeedback fadeOverTime(1);
    self.hud_damageFeedback.alpha = 0;

    wait 0.3;
    hud_damageFeedback_destroy();
}
hud_damageFeedback_destroy()
{
    if(isDefined(self.hud_damageFeedback))
        self.hud_damageFeedback destroy();
    if(isDefined(self.hud_damageFeedback_value))
        self.hud_damageFeedback_value destroy();
}
////

//// hud_playerInfo
hud_playerInfo_create()
{
    if(isDefined(self.hud_playerInfo_created))
        return;
    self.hud_playerInfo_created = true;

    self.hud_playerInfo_fps = newClientHudElem(self);
    self.hud_playerInfo_fps.sort = -1;
    self.hud_playerInfo_fps.x = 573;
    self.hud_playerInfo_fps.y = 30;
    self.hud_playerInfo_fps.fontScale = 0.8;
    self.hud_playerInfo_fps.label = &"FPS: ";

    self.hud_playerInfo_killstreak = newClientHudElem(self);
    self.hud_playerInfo_killstreak.sort = self.hud_playerInfo_fps.sort;
    self.hud_playerInfo_killstreak.x = self.hud_playerInfo_fps.x;
    self.hud_playerInfo_killstreak.y = self.hud_playerInfo_fps.y + 15;
    self.hud_playerInfo_killstreak.label = &"Killstreak: ";
    self.hud_playerInfo_killstreak.fontScale = self.hud_playerInfo_fps.fontScale;
    
    thread hud_playerInfo_update();
}
hud_playerInfo_update()
{
    level endon("intermission");
    self endon("hud_playerInfo_destroy");

    for(;;)
    {
        fps = self getFPS();
        hud_playerInfo_setText(fps);
        wait .05;
    }
}
hud_playerInfo_setText(fps)
{
    self.hud_playerInfo_fps setValue(fps);
    self.hud_playerInfo_killstreak setValue(self.killstreak);
}
hud_playerInfo_destroy()
{
    self notify("hud_playerInfo_destroy");
    if(isDefined(self.hud_playerInfo_fps))
        self.hud_playerInfo_fps destroy();
    if(isDefined(self.hud_playerInfo_killstreak))
        self.hud_playerInfo_killstreak destroy();
}
////

//// hud_sprint
hud_sprintBar_create()
{
    if(!getCvarInt("player_sprint"))
        return;

    level endon("intermission");
    self endon("hud_sprintBar_destroy");
        
    self.hud_sprint_bind_info = newClientHudElem(self);
    self.hud_sprint_bind_info.sort = -1;
    self.hud_sprint_bind_info.x = level.hud_sprint_bar_x;
    self.hud_sprint_bind_info.y = level.hud_sprint_bar_y - 14;
    self.hud_sprint_bind_info.fontScale = 0.85;
    self.hud_sprint_bind_info.label = &"/bind z sprint";
    
    self.hud_sprint_bar_background = newClientHudElem(self);
    self.hud_sprint_bar_background.sort = -3;
    self.hud_sprint_bar_background.x = level.hud_sprint_bar_x;
    self.hud_sprint_bar_background.y = level.hud_sprint_bar_y;
    self.hud_sprint_bar_background.color = (0, 0, 0);
    self.hud_sprint_bar_background.alpha = 0.45;
    self.hud_sprint_bar_background setShader("white", level.hud_sprint_bar_maxWidth, level.hud_sprint_bar_height);
    
    sprintMaxTime = getCvarFloat("player_sprintTime");
    sprintMaxTime *= 1000;
    sprintMinTime = getCvarFloat("player_sprintMinTime");
    sprintMinTime *= 1000;
    self.hud_sprint_bar_minTime = newClientHudElem(self);
    self.hud_sprint_bar_minTime.sort = -1;
    self.hud_sprint_bar_minTime.alpha = 0.85; // Didn't manage to make it disappear under hud_sprint_bar
    hud_sprint_bar_minTime_x = level.hud_sprint_bar_x + (int)((sprintMinTime / sprintMaxTime) * level.hud_sprint_bar_maxWidth);
    self.hud_sprint_bar_minTime.x = hud_sprint_bar_minTime_x;
    self.hud_sprint_bar_minTime.y = level.hud_sprint_bar_y;
    self.hud_sprint_bar_minTime.color = (1, 1, 1);
    self.hud_sprint_bar_minTime setShader("white", 2, level.hud_sprint_bar_height);
    
    self.hud_sprint_bar = newClientHudElem(self);
    self.hud_sprint_bar.sort = -1;
    self.hud_sprint_bar.x = level.hud_sprint_bar_x;
    self.hud_sprint_bar.y = level.hud_sprint_bar_y;
    self.hud_sprint_bar.color = (1, 1, 1);
    
    for(;;)
    {
        remainingSprintTime = self getSprintRemaining();
        bar_width = (remainingSprintTime * level.hud_sprint_bar_maxWidth) / sprintMaxTime;
        if (isDefined(self.hud_sprint_bar))
        {
            if (bar_width < 1)
            {
                // Setting width to 0 makes width positive for a short time, so hiding.
                self.hud_sprint_bar.alpha = 0;
            }
            else
                self.hud_sprint_bar.alpha = 0.85;
            self.hud_sprint_bar setShader("white", (int)bar_width, level.hud_sprint_bar_height);
        }
        wait .05;
    }
}
hud_sprintBar_destroy()
{
    self notify("hud_sprintBar_destroy");

    if(isDefined(self.hud_sprint_bar))
        self.hud_sprint_bar destroy();
    if(isDefined(self.hud_sprint_bar_background))
        self.hud_sprint_bar_background destroy();
    if(isDefined(self.hud_sprint_bar_minTime))
        self.hud_sprint_bar_minTime destroy();
    if(isDefined(self.hud_sprint_bind_info))
        self.hud_sprint_bind_info destroy();
}
////