
-module(dirsize).





-export([
    from/1
]).





from(Where) ->

    case file:list_dir_all(Where) of
        
        { ok, List } ->
            { Where, [ from(Where ++ "/" ++ L) || L <- List, L =/= ok ] };

        { error, eio } ->  % this is not a directory
            { ok, { file_info, Size, _, _, _, _, _, _, _, _, _, _, _, _ } } = file:read_file_info(Where),
            Size;

        { error, eacces } ->
            ok;

        { error, enoent } ->
            { error, no_such_file }  % this is not a thing

    end.
