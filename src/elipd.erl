%% @doc Contains functions used to control the application

-module(elipd).

-export([start/0]).
-export([stop/1]).

%% @spec ensure_started(App) -> ok
%% @doc Ensure the specified application is started. Start the specified application if not already started.
ensure_started(App) ->
    case application:start(App) of
        ok ->
            ok;
        {error, {already_started, App}} ->
            ok
    end.

%% @spec start() -> ok
%% @doc Start the server.
start() ->

	error_logger:info_msg("Starting ~p...~n", [?MODULE]),
	
	%% Start crypto
	ensure_started(crypto),	
	
	%% Start our application
    application:start(?MODULE).

%% @spec stop() -> ok
%% @doc Stop the server.
stop([Node]) ->

    io:format("Stopping: ~p~n",[Node]),
	
    case net_adm:ping(Node) of
	pong -> 
		rpc:cast(Node, init, stop, []),
		init:stop(),
		io:format("Stopped: ~p~n",[Node]),
		ok;
	Result ->
		error_logger:info_msg("Node ~p does not respond to ping! (~p)", [Node, Result])
    end.
