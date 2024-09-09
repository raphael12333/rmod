CodeCallback_PlayerCommand(command_object)
{
    if((command_object[0] == "say" || command_object[0] == "say_team")
        && (isDefined(command_object[1]) && command_object[1][0] == level.chatCommand_prefix))
    {
        // Remove say/say_team
        for(i = 1; i < command_object.size; i++)
        {
            command_object[i-1] = command_object[i];
        }
        command_object[command_object.size - 1] = undefined;

        // Remove !
        index0 = "";
        for(i = 0; i < command_object[0].size; i++)
        {
            if(i == 0 && command_object[0][i] == level.chatCommand_prefix)
                continue;
            index0 += command_object[0][i];
        }
        command_object[0] = index0;

        if(command_object.size == 1 && command_object[0] == "")
            return;

        // Check if arguments were passed in a single string
        if(command_object.size == 1)
        {
            index0_splitted = strTok(command_object[0], " ");
            if(index0_splitted.size != 1)
                command_object = index0_splitted;
        }

        [[level.chatCommand_call]](command_object);
        return;
    }
    self processClientCommand();
}