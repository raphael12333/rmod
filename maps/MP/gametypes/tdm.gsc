/*
    Team Deathmatch
    Objective: 	Score points for your team by eliminating players on the opposing team
    Map ends:	When one team reaches the score limit, or time limit is reached
    Respawning:	No wait / Near teammates

    Level requirements
    ------------------
        Spawnpoints:
            classname		mp_teamdeathmatch_spawn
            All players spawn from these. The spawnpoint chosen is dependent on the current locations of teammates and enemies
            at the time of spawn. Players generally spawn behind their teammates relative to the direction of enemies. 

        Spectator Spawnpoints:
            classname		mp_teamdeathmatch_intermission
            Spectators spawn from these and intermission is viewed from these positions.
            Atleast one is required, any more and they are randomly chosen between.

    Level script requirements
    -------------------------
        Team Definitions:
            game["allies"] = "american";
            game["axis"] = "german";
            This sets the nationalities of the teams. Allies can be american, british, or russian. Axis can be german.
    
        If using minefields or exploders:
            maps\mp\_load::main();
        
    Optional level script settings
    ------------------------------
        Soldier Type and Variation:
            game["american_soldiertype"] = "airborne";
            game["american_soldiervariation"] = "normal";
            game["german_soldiertype"] = "wehrmacht";
            game["german_soldiervariation"] = "normal";
            This sets what models are used for each nationality on a particular map.
            
            Valid settings:
                american_soldiertype		airborne
                american_soldiervariation	normal, winter
                
                british_soldiertype		airborne, commando
                british_soldiervariation	normal, winter
                
                russian_soldiertype		conscript, veteran
                russian_soldiervariation	normal, winter
                
                german_soldiertype		waffen, wehrmacht, fallschirmjagercamo, fallschirmjagergrey, kriegsmarine
                german_soldiervariation		normal, winter

        Layout Image:
            game["layoutimage"] = "yourlevelname";
            This sets the image that is displayed when players use the "View Map" button in game.
            Create an overhead image of your map and name it "hud@layout_yourlevelname".
            Then move it to main\levelshots\layouts. This is generally done by taking a screenshot in the game.
            Use the outsideMapEnts console command to keep models such as trees from vanishing when noclipping outside of the map.
*/

/*QUAKED mp_teamdeathmatch_spawn (0.0 0.0 1.0) (-16 -16 0) (16 16 72)
Players spawn away from enemies and near their team at one of these positions.
*/

/*QUAKED mp_teamdeathmatch_intermission (1.0 0.0 1.0) (-16 -16 -16) (16 16 16)
Intermission is randomly viewed from one of these positions.
Spectators spawn randomly at one of these positions.
*/

main()
{
    centralizer::main();
}

Callback_StartGameType()
{
    centralizer::startGameType();
}

Callback_PlayerConnect()
{
    centralizer::playerConnect();
}

Callback_PlayerDisconnect()
{
    centralizer::playerDisconnect();
}

Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc)
{
    centralizer::playerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);
}

Callback_PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc)
{
    centralizer::playerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc);
}

spawnPlayer()
{
    centralizer::spawnPlayer();
}

spawnSpectator(origin, angles)
{
    centralizer::spawnSpectator(origin, angles);
}

spawnIntermission()
{
    centralizer::spawnIntermission();
}

respawn()
{
    if(!isdefined(self.pers["weapon"]))
        return;

    self endon("end_respawn");
    
    if(getcvarint("scr_forcerespawn") > 0)
    {
        self thread waitForceRespawnTime();
        self thread waitRespawnButton();
        self waittill("respawn");
    }
    else
    {
        self thread waitRespawnButton();
        self waittill("respawn");
    }
    
    self thread spawnPlayer();
}

waitForceRespawnTime()
{
    self endon("end_respawn");
    self endon("respawn");
    
    wait getcvarint("scr_forcerespawn");
    self notify("respawn");
}

waitRespawnButton()
{
    self endon("end_respawn");
    self endon("respawn");
    
    wait 0; // Required or the "respawn" notify could happen before it's waittill has begun

    self.respawntext = newClientHudElem(self);
    self.respawntext.alignX = "center";
    self.respawntext.alignY = "middle";
    self.respawntext.x = 320;
    self.respawntext.y = 70;
    self.respawntext.archived = false;
    self.respawntext setText(&"MPSCRIPT_PRESS_ACTIVATE_TO_RESPAWN");

    thread removeRespawnText();
    thread waitRemoveRespawnText("end_respawn");
    thread waitRemoveRespawnText("respawn");

    while(self useButtonPressed() != true)
        wait .05;
    
    self notify("remove_respawntext");

    self notify("respawn");	
}

removeRespawnText()
{
    self waittill("remove_respawntext");

    if(isdefined(self.respawntext))
        self.respawntext destroy();
}

waitRemoveRespawnText(message)
{
    self endon("remove_respawntext");

    self waittill(message);
    self notify("remove_respawntext");
}

killcam(attackerNum, delay)
{
    centralizer::killcam(attackerNum, delay);
}

endMap()
{
    centralizer::endMap();
}

checkScoreLimit()
{
    if(level.scorelimit <= 0)
        return;
    
    if(getTeamScore("allies") < level.scorelimit && getTeamScore("axis") < level.scorelimit)
        return;

    if(level.mapended)
        return;
    level.mapended = true;

    iprintln(&"MPSCRIPT_SCORE_LIMIT_REACHED");
    endMap();
}

updateScriptCvars()
{
    for(;;)
    {
        timelimit = getcvarfloat("scr_tdm_timelimit");
        if(level.timelimit != timelimit)
        {
            if(timelimit > 1440)
            {
                timelimit = 1440;
                setcvar("scr_tdm_timelimit", "1440");
            }
            
            level.timelimit = timelimit;
            level.starttime = getTime();
            
            if(level.timelimit > 0)
            {
                if(!isdefined(level.clock))
                {
                    level.clock = newHudElem();
                    level.clock.x = 320;
                    level.clock.y = 440;
                    level.clock.alignX = "center";
                    level.clock.alignY = "middle";
                    level.clock.font = "bigfixed";
                }
                level.clock setTimer(level.timelimit * 60);
            }
            else
            {
                if(isdefined(level.clock))
                    level.clock destroy();
            }
            
            centralizer::checkTimeLimit();
        }

        scorelimit = getcvarint("scr_tdm_scorelimit");
        if(level.scorelimit != scorelimit)
        {
            level.scorelimit = scorelimit;
            checkScoreLimit();
        }

        drawfriend = getcvarfloat("scr_drawfriend");
        if(level.drawfriend != drawfriend)
        {
            level.drawfriend = drawfriend;
            
            if(level.drawfriend)
            {
                // for all living players, show the appropriate headicon
                players = getentarray("player", "classname");
                for(i = 0; i < players.size; i++)
                {
                    player = players[i];
                    
                    if(isdefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
                    {
                        if(player.pers["team"] == "allies")
                        {
                            player.headicon = game["headicon_allies"];
                            player.headiconteam = "allies";
                        }
                        else
                        {
                            player.headicon = game["headicon_axis"];
                            player.headiconteam = "axis";
                        }
                    }
                }
            }
            else
            {
                players = getentarray("player", "classname");
                for(i = 0; i < players.size; i++)
                {
                    player = players[i];
                    
                    if(isdefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
                        player.headicon = "";
                }
            }
        }

        allowvote = getcvarint("g_allowvote");
        if(level.allowvote != allowvote)
        {
            level.allowvote = allowvote;
            setcvar("scr_allow_vote", allowvote);
        }

        wait 1;
    }
}

dropHealth()
{
    if(isdefined(level.healthqueue[level.healthqueuecurrent]))
        level.healthqueue[level.healthqueuecurrent] delete();
    
    level.healthqueue[level.healthqueuecurrent] = spawn("item_health", self.origin + (0, 0, 1));
    level.healthqueue[level.healthqueuecurrent].angles = (0, randomint(360), 0);

    level.healthqueuecurrent++;
    
    if(level.healthqueuecurrent >= 16)
        level.healthqueuecurrent = 0;
}

addBotClients()
{
    wait 5;
    
    for(;;)
    {
        if(getCvarInt("scr_numbots") > 0)
            break;
        wait 1;
    }
    
    iNumBots = getCvarInt("scr_numbots");
    for(i = 0; i < iNumBots; i++)
    {
        ent[i] = addtestclient();
        wait 0.5;

        if(isPlayer(ent[i]))
        {
            if(i & 1)
            {
                ent[i] notify("menuresponse", game["menu_team"], "axis");
                wait 0.5;
                ent[i] notify("menuresponse", game["menu_weapon_axis"], "kar98k_mp");
            }
            else
            {
                ent[i] notify("menuresponse", game["menu_team"], "allies");
                wait 0.5;
                ent[i] notify("menuresponse", game["menu_weapon_allies"], "springfield_mp");
            }
        }
    }
}