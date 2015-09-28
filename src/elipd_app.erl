%% @doc Callbacks for the application.
%% Contains application start and stop functions.

-module(elipd_app).
-behaviour(application).

%% API.
-export([start/2]).
-export([stop/1]).

%% @spec start(Type, Args) -> ServerRet
%% @doc application start callback.
start(Type, Args) ->

	%% Log start arguments
	error_logger:info_msg("[~p]: Start type: ~p Start Args = ~p~n", [?MODULE, Type, Args]),

	%% Start server main supervisor
    case elipd_sup:start_link() of
		{ok, Pid} ->
	    	{ok, Pid};
		Error ->
	    	Error
    end.

%% @spec stop(State) -> ServerRet
%% @doc application stop callback.
stop(_State) ->
	ok.



