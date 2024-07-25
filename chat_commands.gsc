init()
{
    level.chatCommand_prefix = "!";
    level.chatCommand_call = ::command_call;
    level.chatCommands = [];
    level.chatCommands_help = [];

    level.groups = [];
    level.users = [];
    level.perms = [];
    if(getCvar("scr_chatcommands_groups") != "")
    {
        strTok_param1 = getCvar("scr_chatcommands_groups");
        level.groups = strTok(strTok_param1, ";");
    }
    for(i = 0; i < level.groups.size; i++)
    {
        if(getCvar("scr_chatcommands_users_" + level.groups[i]) != "")
        {
            strTok_param1 = getCvar("scr_chatcommands_users_" + level.groups[i]);
            level.users[level.groups[i]] = strTok(strTok_param1, " ");
        }
        
        if(getCvar("scr_chatcommands_perms_" + level.groups[i]) != "")
        {
            strTok_param1 = getCvar("scr_chatcommands_perms_" + level.groups[i]);
            level.perms[level.groups[i]] = strTok(strTok_param1, ":");
        }
    }

    command_register(0, "help", ::cmd_help);
    command_register(1, "login", ::cmd_login, undefined, "<username> <password>");
    command_register(2, "logout", ::cmd_logout);
    command_register(3, "status", ::cmd_status, "List connected players.");
    command_register(4, "who", ::cmd_who, "List logged in users.");
    command_register(5, "kick", ::cmd_kick, undefined, "<client number> <reason>");
}
command_register(permId, name, function, description, usage)
{
    level.chatCommands[name]["permId"] = permId;
    level.chatCommands[name]["function"] = function;
    level.chatCommands[name]["description"] = description;
    level.chatCommands[name]["usage"] = usage;
    level.chatCommands_help[level.chatCommands_help.size]["name"] = name;
}
command_call(command_object)
{
    if(isDefined(level.chatCommands[command_object[0]]))
    {
        permId = level.chatCommands[command_object[0]]["permId"];
        if(!userHasPermission(self, permId))
        {
            self iPrintLn("Access denied");
            return;
        }
        self.lastChatCmd = command_object[0];
        self thread [[level.chatCommands[command_object[0]]["function"]]](command_object);
    }
    else
    {
        self iPrintLn("Unknown chat command " + command_object[0]);
    }
}

userHasPermission(user, permId)
{
    groupName = user.pers["chatcommands_group"];
    if(!isDefined(groupName))
        groupName = "default";
    permsList = level.perms[groupName];
    if(groupName != "default")
    {
        // Include default permissions for logged in user
        mergedArray = level.perms["default"];
        for(i = 0; i < level.perms[groupName].size; i++)
            mergedArray[mergedArray.size] = level.perms[groupName][i];
        permsList = mergedArray;
    }

    if(!isDefined(permsList))
        return false;

    for(i = 0; i < permsList.size; i++)
    {
        if(permsList[i] == "*")
            return true;
        else if(permsList[i] == ("" + permId))
            return true;
        else
        {
            range = strTok(permsList[i], "-");
            if(range.size == 2)
            {
                hi = (int)range[1];
                lo = (int)range[0];
                if(lo >= hi || hi < lo)
                    continue;
                if(permId >= lo && permId <= hi)
                    return true;
            }
        }
    }
    return false;
}

removeCommandNameFromObject(object)
{
    for(i = 1; i < object.size; i++)
    {
        object[i-1] = object[i];
    }
    object[object.size - 1] = undefined;
    return object;
}

showUsage()
{
    usage = level.chatCommands[self.lastChatCmd]["usage"];
    if(isDefined(usage))
        self iPrintLn("usage: " + level.chatCommand_prefix + self.lastChatCmd + " " + usage);
}
informOutputLocation()
{
    self iPrintLn("See output in console");    
}

spaces(amount)
{
    spaces = "";
    for(i = 0; i < amount; i++)
        spaces += " ";
    return spaces;
}
numDigits(num)
{
    return (num + "").size;
}
isInteger(input)
{
    input += "";
    for(i = 0; i < input.size; i++)
    {
        switch(input[i])
        {
            case "0": case "1": case "2":
            case "3": case "4": case "5":
            case "6": case "7": case "8":
            case "9":
            break;
            case "-":
                if(i == 0 && input.size > 1)
                    break;
            default:
                return false;
        }
    }
    return true;
}

cmd_help(args)
{
    informOutputLocation();
    wait .05;
    self connectionlessPacketToClient("print\n\n" + "Send \"" + level.chatCommand_prefix + "\" + <command>" + "\n");
    self connectionlessPacketToClient("print\n" + "E.g.: " + level.chatCommand_prefix + "status" + "\n");
    self connectionlessPacketToClient("print\n\n" + "Available commands:" + "\n\n");
    for(i = 0; i < level.chatCommands_help.size; i++)
    {
        commandName = level.chatCommands_help[i]["name"];
        if(commandName == "help")
            continue;
        if(userHasPermission(self, level.chatCommands[commandName]["permId"]))
        {
            message_line = "-" + commandName;
            description = level.chatCommands[commandName]["description"];
            usage = level.chatCommands[commandName]["usage"];
            if(isDefined(description) || isDefined(usage))
            {
                spc = spaces(15 - commandName.size);
                message_line += spc;
            }
            if(isDefined(description))
                message_line += description;
            if(isDefined(usage))
            {
                if(isDefined(description))
                    message_line += " ";
                message_line += "Usage: " + level.chatCommand_prefix + commandName + " " + usage;
            }
            self connectionlessPacketToClient("print\n" + message_line + "\n");
        }
    }
    self connectionlessPacketToClient("print\n\n");
}

cmd_login(args)
{
    args = removeCommandNameFromObject(args);
    if(args.size != 2)
    {
        showUsage();
        return;
    }

    input_username = args[0];
    input_password = args[1];
    for(i = 0; i < level.groups.size; i++)
    {
        group = level.groups[i];
        users = level.users[group];
        if(isDefined(users))
        {
            for(u = 0; u < users.size; u++)
            {
                user = strTok(users[u], ":");
                if(user.size == 2)
                {
                    if(user[0] == input_username && user[1] == input_password)
                    {
                        self.pers["chatcommands_group"] = group;
                        self.pers["chatcommands_user"] = user[0];
                        self iPrintLn("Logged in");
                        return;
                    }
                }
            }
        }
    }

    self iPrintLn("Incorrect username/password");
}
cmd_logout(args)
{
    if(isDefined(self.pers["chatcommands_group"]))
    {
        self.pers["chatcommands_group"] = undefined;
        self.pers["chatcommands_user"] = undefined;
        self iPrintLn("Logged out");
    }
}

cmd_status(args)
{
    informOutputLocation();
    wait .05;
    self connectionlessPacketToClient("print\n\n" + "Connected players:" + "\n\n");
    self connectionlessPacketToClient("print\n" + "num score ping name" + "\n");
    self connectionlessPacketToClient("print\n" + "--- ----- ---- ---------------" + "\n");

    maxClients = getCvarInt("sv_maxclients");
    for(i = 0; i < maxclients; i++)
    {
        player = getEntByNum(i);
        if(isDefined(player))
        {
            message_line = "";

            playerEntityNumber = player getEntityNumber();
            numDigits = numDigits(playerEntityNumber);
            padding = 3 - numDigits;
            for(j = 0; j < padding; j++)
            {
                message_line += " ";
            }
            message_line += playerEntityNumber;
            message_line += " ";

            numDigits = numDigits(player.score);
            padding = 5 - numDigits;
            for(j = 0; j < padding; j++)
            {
                message_line += " ";
            }
            message_line += player.score;
            message_line += " ";

            playerPing = player getPing();
            numDigits = numDigits(playerPing);
            padding = 4 - numDigits;
            for(j = 0; j < padding; j++)
            {
                message_line += " ";
            }
            message_line += playerPing;
            message_line += " ";

            message_line += player.name;
            
            self connectionlessPacketToClient("print\n" + message_line + "\n");
        }
    }
    self connectionlessPacketToClient("print\n\n");
}
cmd_who(args)
{
    informOutputLocation();
    wait .05;
    self connectionlessPacketToClient("print\n\n" + "Logged in users:" + "\n\n");
    self connectionlessPacketToClient("print\n" + "num group         user           player" + "\n");
    self connectionlessPacketToClient("print\n" + "--- ------------- -------------- -------------------" + "\n");

    maxClients = getCvarInt("sv_maxclients");
    for(i = 0; i < maxclients; i++)
    {
        player = getEntByNum(i);
        if(isDefined(player))
        {
            if(isDefined(player.pers["chatcommands_group"]))
            {
                message_line = "";

                playerEntityNumber = player getEntityNumber();
                numDigits = numDigits(playerEntityNumber);
                padding = 3 - numDigits;
                for(j = 0; j < padding; j++)
                {
                    message_line += " ";
                }
                message_line += playerEntityNumber;
                message_line += " ";
                
                message_line += player.pers["chatcommands_group"];
                numChargs = player.pers["chatcommands_group"].size;
                padding = 13 - numChargs;
                for(j = 0; j < padding; j++)
                {
                    message_line += " ";
                }
                message_line += " ";

                message_line += player.pers["chatcommands_user"];
                numChargs = player.pers["chatcommands_user"].size;
                padding = 14 - numChargs;
                for(j = 0; j < padding; j++)
                {
                    message_line += " ";
                }
                message_line += " ";
                
                message_line += player.name;
                
                self connectionlessPacketToClient("print\n" + message_line + "\n");
            }
        }
    }
    self connectionlessPacketToClient("print\n\n");
}

cmd_kick(args)
{
    args = removeCommandNameFromObject(args);
    if(args.size < 1 || !isInteger(args[0]))
    {
        showUsage();
        return;
    }

    if(args.size >= 2)
    {
        args[1] = "Reason: " + args[1];
        for(i = 2; i < args.size; i++)
        {
            args[1] += " " + args[i];
        }
    }
    
    clientNum = args[0];
    reason = args[1];
    entity = getEntByNum(clientNum);
    if(!isPlayer(entity))
    {
        self iPrintLn("Player not found");
        return;
    }

    if(!isDefined(reason))
        reason = "EXE_PLAYERKICKED";
    else
        iPrintLn(entity.name + " Kicked");
    entity dropClient(reason);
}