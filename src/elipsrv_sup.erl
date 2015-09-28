%% @doc Main supervisor for the entire application.

-module(elipsrv_sup).
-behaviour(supervisor).

%% External exports
-export([start_link/0]).
-export([init/1]). 
-export([upgrade/0]).

%% @spec start_link() -> ServerRet
%% @doc API for starting the supervisor.
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% @spec init([]) -> SupervisorTree
%% @doc supervisor callback.
init([]) ->
    {ok,{{one_for_one, 10, 10}, []}}.
	
%% @spec upgrade() -> ok
%% @doc Add processes if necessary.
upgrade() ->

    {ok, {_, Specs}} = init([]),

    Old  = sets:from_list([Name || {Name, _, _, _} <- supervisor:which_children(?MODULE)]),
    New  = sets:from_list([Name || {Name, _, _, _, _, _} <- Specs]),
    Kill = sets:subtract(Old, New),

    sets:fold(fun (Id, ok) ->
                      supervisor:terminate_child(?MODULE, Id),
                      supervisor:delete_child(?MODULE, Id),
                      ok
              end, ok, Kill),

    [supervisor:start_child(?MODULE, Spec) || Spec <- Specs],
    ok.
	
