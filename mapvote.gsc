// Max hudelem archived = 31
// Max hudelem non archived = 31

init()
{
    precacheShader("white");

    level.mapvote_instruction = &"Shoot/Melee to scroll";
    level.mapvote_titleVotes = &"Votes";

    level.vote_over = false;
    level.mapvotetime = 12;
    level.delay_scoreboardToMapvote = 0.45;
    level.delay_mapvoteToResult = 0.3;
    level.delay_resultToExit = 2;

    level.mapvote_minchoices = 2;
    level.mapvote_maxchoices = 10;
    level.mapvote_currentchoices = 0;
    level.mapvote_randomMapRotation = [];
    level.mapvote_list = [];
    level.mapvote_hud_mapnames = [];
    level.mapvote_hud_counts = [];
}

start()
{
    if (!prepareMaps())
        return;
    
    setupHud();
    thread runMapVote();

    level waittill("voting_complete");
    destroyHud();
}

prepareMaps()
{
    level.mapvote_currentchoices = 2; // random + replay
    level.mapvote_list[0] = "Random";

    mapRotation = getCvar("sv_mapRotation");
    if (mapRotation == "")
    {
        printLn("mapvote: sv_mapRotation cvar is empty");
        return false;
    }
    mapRotation = strTok(mapRotation, " ");

    _tmp = [];
    lastgt = getCvar("g_gametype");
    for(i = 0; i < mapRotation.size; )
    {
        switch(mapRotation[i])
        {
            case "gametype":
                if((i + 1) < mapRotation.size)
                    lastgt = mapRotation[i + 1];
                i += 2;
            break;

            case "map":
                if((i + 1) < mapRotation.size && (lastgt != getCvar("g_gametype") || mapRotation[i + 1] != getCvar("mapname")))
                {
                    _tmp[_tmp.size]["gametype"] = lastgt;
                    _tmp[_tmp.size - 1]["map"]  = mapRotation[i + 1];
                }
                i += 2;
            break;

            default:
                printLn("mapvote: error in sv_mapRotation");
                return false;
            break;
        }
    }
    
    level.mapvote_randomMapRotation = array_shuffle(_tmp);
    for(i = 0; i < level.mapvote_randomMapRotation.size; i++)
    {
        if(level.mapvote_currentchoices == level.mapvote_maxchoices)
            break;
        
        switch(level.mapvote_randomMapRotation[i]["gametype"])
        {
            case "sd":
                gametypeColor = "^2";
            break;

            case "dm":
                gametypeColor = "^1";
            break;

            case "tdm":
                gametypeColor = "^4";
            break;

            case "bel":
                gametypeColor = "^3";
            break;

            case "re":
                gametypeColor = "^6";
            break;

            default:
                gametypeColor = "^7";
            break;
        }
        gametypeDisplay = "(" + gametypeColor + level.mapvote_randomMapRotation[i]["gametype"] + "^7)";
        
        level.mapvote_list[level.mapvote_list.size] = getShortMapname(level.mapvote_randomMapRotation[i]["map"]) + " " + gametypeDisplay;
        level.mapvote_currentchoices++;
    }
    level.mapvote_list[level.mapvote_list.size] = "Replay";
    return true;
}

setupHud()
{
    if(isDefined(level.clock))
        level.clock destroy();

    players = getEntArray("player", "classname");
    for(i = 0; i < players.size; i++)
        players[i].sessionstate = "spectator";

    wait level.delay_scoreboardToMapvote;
    
    // Offsets
    // id Tech 3 base resolution = 640*480
    level.screen_middle_x = 640/2; //320
    screen_middle_y = 480/2; //240
    level.background_width = 220;
    level.distance_between_mapnames = 21;
    level.mapNames_y = screen_middle_y - 75;

    // Header background
    level.vote_header = newHudElem();
    level.vote_header.alpha = 0;
    level.vote_header.alignX = "center";
    level.vote_header.x = level.screen_middle_x;
    level.vote_header.y = level.mapNames_y - 33;
    level.vote_header.color = (0.37, 0.37, 0.16);
    level.vote_header setShader("white", level.background_width, 19);
    level.vote_header.sort = 1;
    thread fadeDisplayHud(level.vote_header);

    // Instructions title
    level.vote_instruction = newHudElem();
    level.vote_instruction.alpha = 0;
    level.vote_instruction.x = level.vote_header.x - 99;
    level.vote_instruction.y = level.vote_header.y + 3;
    level.vote_instruction.fontscale = 1.1;
    level.vote_instruction.label = level.mapvote_instruction;
    level.vote_instruction.sort = 2;
    thread fadeDisplayHud(level.vote_instruction);

    // Vote count title
    level.vote_votes = newHudElem();
    level.vote_votes.alpha = 0;
    level.vote_votes.x = level.vote_instruction.x + 163;
    level.vote_votes.y = level.vote_instruction.y;
    level.vote_votes.fontscale = level.vote_instruction.fontscale;
    level.vote_votes.label = level.mapvote_titleVotes;
    level.vote_votes.sort = level.vote_instruction.sort;
    thread fadeDisplayHud(level.vote_votes);
    
    // Main background
    level.vote_hud_bgnd = newHudElem();
    level.vote_hud_bgnd.alpha = 0;
    level.vote_hud_bgnd.alignX = "center";
    level.vote_hud_bgnd.x = level.vote_header.x;
    level.vote_hud_bgnd.y = level.vote_header.y + 19;
    
    background_height = (level.mapvote_currentchoices * 21) + 10;

    level.vote_hud_bgnd setShader("black", level.background_width, background_height);
    level.vote_hud_bgnd.sort = 1;
    thread fadeDisplayHud(level.vote_hud_bgnd);

    level.voteTimer = newHudElem();
    level.voteTimer.alpha = 0;
    level.voteTimer.alignX = "left";
    level.voteTimer.alignY = "middle";
    level.voteTimer.x = (320 - (level.background_width / 2.0));
    level.voteTimer.y = level.vote_hud_bgnd.y + background_height + 5;
    level.voteTimer setShader("white", 0, 10);
    level.voteTimer.color = (0.42, 0, 0.47);
    level.voteTimer scaleOverTime(level.mapvotetime, level.background_width, 10);
    thread fadeDisplayHud(level.voteTimer);
    thread countdown();

    mapNames_x = level.vote_hud_bgnd.x - 93;
    votes_x = mapNames_x + 172;

    // Map names
    mapNames_x = level.vote_hud_bgnd.x - 24;
    for(i = 0; i < level.mapvote_currentchoices; i++)
    {
        level.mapvote_hud_mapnames[i] = newHudElem();
        level.mapvote_hud_mapnames[i].alpha = 0;
        level.mapvote_hud_mapnames[i].alignX = "center";
        level.mapvote_hud_mapnames[i].alignY = "middle";
        level.mapvote_hud_mapnames[i].x = mapNames_x;
        if(i == 0)
            level.mapvote_hud_mapnames[i].y = level.mapNames_y;
        else
            level.mapvote_hud_mapnames[i].y = level.mapvote_hud_mapnames[i-1].y + level.distance_between_mapnames;

        mapname = level.mapvote_list[i];
        mapname_localized = makeLocalizedString(mapname);
        level.mapvote_hud_mapnames[i] setText(mapname_localized);

        level.mapvote_hud_mapnames[i].sort = 4;

        if(mapname == "Random" || mapname == "Replay")
            level.mapvote_hud_mapnames[i].color = (0, 1, 1);
        
        thread fadeDisplayHud(level.mapvote_hud_mapnames[i]);
    }
    
    // Votes counts
    for(i = 0; i < level.mapvote_currentchoices; i++)
    {
        level.mapvote_hud_counts[i] = newHudElem();
        level.mapvote_hud_counts[i].alpha = 0;
        level.mapvote_hud_counts[i].alignX = "center";
        level.mapvote_hud_counts[i].alignY = "middle";
        level.mapvote_hud_counts[i].x = votes_x;
        if(i == 0)
            level.mapvote_hud_counts[i].y = level.mapNames_y;
        else
            level.mapvote_hud_counts[i].y = level.mapvote_hud_counts[i-1].y + level.distance_between_mapnames;
        level.mapvote_hud_counts[i] setValue(0);
        level.mapvote_hud_counts[i].sort = 4;

        thread fadeDisplayHud(level.mapvote_hud_counts[i]);
    }
}
fadeDisplayHud(hudElem)
{
    hudElem fadeOverTime(0.1);
    if((isDefined(level.vote_header) && hudElem == level.vote_header)
        || isDefined(level.vote_hud_bgnd) && hudElem == level.vote_hud_bgnd)
        hudElem.alpha = .9;
    else
        hudElem.alpha = 1;
}
destroyHud()
{
    level.voteTimer destroy();
    level.vote_instruction destroy();
    level.vote_votes destroy();
    level.vote_header destroy();
    level.vote_hud_bgnd destroy();

    for(i = 0; i < level.mapvote_currentchoices; i++)
        level.mapvote_hud_mapnames[i] destroy();
    for(i = 0; i < level.mapvote_currentchoices; i++)
        level.mapvote_hud_counts[i] destroy();
    
    players = getEntArray("player", "classname");
    for(i = 0; i < players.size; i++)
        if(isDefined(players[i].vote_indicator))
            players[i].vote_indicator destroy();
}

countdown()
{
    wait level.mapvotetime;
    level notify("vote_over");
    level.vote_over = true;
}

runMapVote()
{
    mapCandidateIndex = 0;

    randMap = randomInt(level.mapvote_randomMapRotation.size);
    level.mapcandidate[mapCandidateIndex]["mapname"] = level.mapvote_randomMapRotation[randMap]["map"];
    level.mapcandidate[mapCandidateIndex]["mapname_display"] = "Random";
    level.mapcandidate[mapCandidateIndex]["gametype"] = level.mapvote_randomMapRotation[randMap]["gametype"];
    level.mapcandidate[mapCandidateIndex]["votes"] = 0;

    mapCandidateIndex++;
    
    for(i = 0; i < level.mapvote_randomMapRotation.size; i++)
    {
        if(!isDefined(level.mapvote_randomMapRotation[i]))
        {
            printLn("####### runMapVote() error");
            break;
        }

        level.mapcandidate[mapCandidateIndex]["mapname"] = level.mapvote_randomMapRotation[i]["map"];
        level.mapcandidate[mapCandidateIndex]["mapname_display"] = level.mapvote_randomMapRotation[i]["map"];
        level.mapcandidate[mapCandidateIndex]["gametype"] = level.mapvote_randomMapRotation[i]["gametype"];
        level.mapcandidate[mapCandidateIndex]["votes"] = 0;

        mapCandidateIndex++;
    }
    
    lastChoiceIndex = level.mapvote_currentchoices - 1;
    level.mapcandidate[lastChoiceIndex]["mapname"] = getCvar("mapname");
    level.mapcandidate[lastChoiceIndex]["mapname_display"] = "Replay";
    level.mapcandidate[lastChoiceIndex]["gametype"] = getCvar("g_gametype");
    level.mapcandidate[lastChoiceIndex]["votes"] = 0;
    
    players = getEntArray("player", "classname");
    for(i = 0; i < players.size; i++)
        players[i] thread playerVote();
    
    thread voteLogic();
}

voteLogic()
{
    for(;;)
    {
        // Count votes
        for(i = 0; i < level.mapvote_currentchoices; i++)
            level.mapcandidate[i]["votes"] = 0;

        players = getEntArray("player", "classname");
        for(i = 0; i < players.size; i++)
            if(isDefined(players[i].votechoice))
                level.mapcandidate[players[i].votechoice]["votes"]++;
        
        // Display updated count
        for(i = 0; i < level.mapvote_currentchoices; i++)
            level.mapvote_hud_counts[i] setValue(level.mapcandidate[i]["votes"]);
        
        if(level.vote_over)
            break;
        
        wait .05;
    }

    nextmapnum  = 0;
    topvotes = 0;
    for(i = 0; i < level.mapvote_currentchoices; i++)
    {
        if(level.mapcandidate[i]["votes"] > topvotes)
        {
            nextmapnum = i;
            topvotes = level.mapcandidate[i]["votes"];
        }
    }
    setMapWinner(nextmapnum);
}

setMapWinner(val)
{
    mapname = level.mapcandidate[val]["mapname"];
    mapname_display	= level.mapcandidate[val]["mapname_display"];
    gametype = level.mapcandidate[val]["gametype"];

    setCvar("sv_mapRotationCurrent", "gametype " + gametype + " map " + mapname);

    fadeOverTime_delay = 0.25;

    level.voteTimer fadeOverTime(fadeOverTime_delay);
    level.vote_instruction fadeOverTime(fadeOverTime_delay);
    level.vote_votes fadeOverTime(fadeOverTime_delay);
    level.vote_header fadeOverTime(fadeOverTime_delay);
    level.vote_hud_bgnd fadeOverTime(fadeOverTime_delay);
    for(i = 0; i < level.mapvote_currentchoices; i++)
        level.mapvote_hud_mapnames[i] fadeOverTime(fadeOverTime_delay);
    for(i = 0; i < level.mapvote_currentchoices; i++)
        level.mapvote_hud_counts[i] fadeOverTime(fadeOverTime_delay);
    level.voteTimer.alpha = 0;
    level.vote_instruction.alpha = 0;
    level.vote_votes.alpha = 0;
    level.vote_header.alpha = 0;
    level.vote_hud_bgnd.alpha = 0;
    for(i = 0; i < level.mapvote_currentchoices; i++)
        level.mapvote_hud_mapnames[i].alpha = 0;
    for(i = 0; i < level.mapvote_currentchoices; i++)
        level.mapvote_hud_counts[i].alpha = 0;

    players = getEntArray("player", "classname");
    for(i = 0; i < players.size; i++)
    {
        if(isDefined(players[i].vote_indicator))
        {
            players[i].vote_indicator fadeOverTime(fadeOverTime_delay);
            players[i].vote_indicator.alpha = 0;
        }
    }

    wait level.delay_mapvoteToResult;

    if(mapname_display == "Replay")
    {
        iPrintLnBold("^2" + mapname_display);
    }
    else
    {
        iPrintLnBold("^2" + getShortMapname(mapname));
        iPrintLnBold(getFullGametypeName(gametype));
    }

    wait level.delay_resultToExit;
    level notify("voting_complete");
}

playerVote()
{
    level endon("vote_over");
    self endon("disconnect");

    self.vote_indicator = newClientHudElem(self);
    self.vote_indicator.archived = false;
    self.vote_indicator.alignX = "center";
    self.vote_indicator.alignY = "middle";
    self.vote_indicator.x = level.screen_middle_x;
    self.vote_indicator.alpha = 0;
    self.vote_indicator.color = (0.20, 1, 0.76);
    self.vote_indicator setShader("white", level.background_width - 8, 17);
    self.vote_indicator.sort = 3;

    hasVoted = false;

    for(;;)
    {
        if(self attackButtonPressed() || self meleeButtonPressed())
        {
            if(self attackButtonPressed())
            {
                if(!hasVoted)
                {
                    self.vote_indicator.alpha = 0.3;
                    self.votechoice = 0;
                    hasVoted = true;
                }
                else
                    self.votechoice++;
            }
            else if(self meleeButtonPressed())
            {
                if(!hasVoted)
                {
                    self.vote_indicator.alpha = 0.3;
                    self.votechoice = level.mapvote_currentchoices -1;
                    hasVoted = true;
                }
                else
                    self.votechoice--;
            }

            if(self.votechoice >= level.mapvote_currentchoices)
                self.votechoice = 0;
            else if(self.votechoice < 0)
                self.votechoice = level.mapvote_currentchoices - 1;
            
            if(level.mapcandidate[self.votechoice]["mapname_display"] == "Replay" || level.mapcandidate[self.votechoice]["mapname_display"] == "Random")
            {
                self iPrintLn("Voting for: " + level.mapcandidate[self.votechoice]["mapname_display"]);
            }
            else
            {
                self iPrintLn("Voting for: " + getShortMapname(level.mapcandidate[self.votechoice]["mapname"]) + " (" + level.mapcandidate[self.votechoice]["gametype"] + ")");
            }

            self.vote_indicator.y = (level.mapNames_y + 2) + (self.votechoice * level.distance_between_mapnames);

            while(self attackButtonPressed() || self meleeButtonPressed())
                wait .05;
        }
        wait .05;
    }
}

getFullGametypeName(gametype)
{
    switch(gametype)
    {
        case "dm":
            fullGametypeName = "Deathmatch";
        break;

        case "tdm":
            fullGametypeName = "Team Deathmatch";
        break;

        case "sd":
            fullGametypeName = "Search and Destroy";
        break;

        case "re":
            fullGametypeName = "Retrieval";
        break;

        case "bel":
            fullGametypeName = "Behind Enemy Lines";
        break;

        default:
            fullGametypeName = gametype;
        break;
    }
    return fullGametypeName;
}
getShortMapname(mapname)
{
    switch(mapname)
    {
        case "mp_brecourt":
            shortMapname = "Brecourt";
        break;

        case "mp_carentan":
            shortMapname = "Carentan";
        break;

        case "mp_chateau":
            shortMapname = "Chateau";
        break;

        case "mp_dawnville":
            shortMapname = "Dawnville";
        break;

        case "mp_depot":
            shortMapname = "Depot";
        break;

        case "mp_harbor":
            shortMapname = "Harbor";
        break;

        case "mp_hurtgen":
            shortMapname = "Hurtgen";
        break;

        case "mp_pavlov":
            shortMapname = "Pavlov";
        break;

        case "mp_powcamp":
            shortMapname = "Powcamp";
        break;

        case "mp_railyard":
            shortMapname = "Railyard";
        break;

        case "mp_rocket":
            shortMapname = "Rocket";
        break;

        case "mp_ship":
            shortMapname = "Ship";
        break;

        default:
            shortMapname = mapname;
        break;
    }
    return shortMapname;
}

array_shuffle(arr)
{
    if(!isDefined(arr))
        return undefined;
    for(i = 0; i < arr.size; i++)
    {
        _tmp = arr[i]; // Store the current array element in a variable
        rN = randomInt(arr.size); // Generate a random number
        arr[i] = arr[rN]; // Replace the current with the random
        arr[rN] = _tmp; // Replace the random with the current
    }
    return arr;
}