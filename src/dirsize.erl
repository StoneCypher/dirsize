
-module(dirsize).





-export([

    basic_tree/1,
    from/1

]).





basic_tree(Where) ->

    case file:list_dir_all(Where) of
        
        { ok, List } ->
            { Sizes, Dirs } = lists:partition(fun erlang:is_integer/1, [ basic_tree(Where ++ "/" ++ L) || L <- List, L =/= ok ]),
            { Where, lists:sum(Sizes), Dirs };

        { error, eio } ->  % this is not a directory
            { ok, { file_info, Size, _, _, _, _, _, _, _, _, _, _, _, _ } } = file:read_file_info(Where),
            Size;

        { error, eacces } ->
            ok;

        { error, enoent } ->
            { error, no_such_file }  % this is not a thing

    end.





from(Where) ->

    dive(basic_tree(Where)).





idisi(L, R) ->

%   io:format("idisi: ~p, ~p~n", [L,R]),
    L+R.





close(I) when is_integer(I) ->

    I;





close(List) when is_list(List) ->

    lists:sum([ close(L) || L <- List ]);





close(X) ->

    io:format("Warning: unhandled in close <~p> ~p ~n", [sc:type_of(X), X]),
    X.




dive({ Dir, DirSize, DirConts }) ->

    Dive     = [ dive(Cont) || Cont <- DirConts ],
    SizeCont = [ idisi(close(IDirSize), close(case ISizeCont of [] -> 0; X -> X end)) || { _Dir, IDirSize, ISizeCont, _Dive } <- Dive ],
    { Dir, close(DirSize), close(SizeCont), Dive }.
