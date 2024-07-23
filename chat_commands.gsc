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

    /*command_register(3, "test", ::cmd_test);
    command_register(4, "dummy1111111", ::cmd_dummy, "Do dummy ok.");
    command_register(5, "dummy2", ::cmd_dummy, "Do dummy ok.", "<none>");*/


    
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

/*
message_player(message)
{
    sendCommandToClient(self getEntityNumber(), "i \"" + message + "\"");
}*/
showUsage()
{
    usage = level.chatCommands[self.lastChatCmd]["usage"];
    if(isDefined(usage))
        self iPrintLn("usage: " + level.chatCommand_prefix + self.lastChatCmd + " " + usage);
}

/*
cmd_dummy(args)
{
}
cmd_test(args)
{
}*/

spaces(amount)
{
    spaces = "";
    for(i = 0; i < amount; i++)
        spaces += " ";
    return spaces;
}
cmd_help(args)
{
    self iPrintLn("See output in console");
    wait .05;
    self connectionlessPacketToClient("print\n\n" + "Available commands:" + "\n\n");
    for(i = 0; i < level.chatCommands_help.size; i++)
    {
        commandName = level.chatCommands_help[i]["name"];
        if(commandName == "help")
            continue;
        if(userHasPermission(self, level.chatCommands[commandName]["permId"]))
        {
            message_line = "-" + commandName;
            message_line_end = "\n";
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
            if(i == level.chatCommands_help.size - 1)
                message_line_end += "\n";
            self connectionlessPacketToClient("print\n" + message_line + message_line_end);
        }
    }
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





