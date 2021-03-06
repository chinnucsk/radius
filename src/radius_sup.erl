-module(radius_sup).

-behaviour(supervisor).

%% API
-export([start_link/0, start_child/1]).

%% supervisor callbacks
-export([init/1]).

-define(TABLES, [
        {radius_service, []}, % stores requests/answers records
        {radius_dict_attrs, [{keypos, 2}, {read_concurrency, true}]},
        {radius_dict_values, [{read_concurrency, true}]}
]).
-define(SERVICE, radius_service).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

start_child([Name, IP, Port, Callback]) ->
    Spec = {Name, {?SERVICE, start_link, [Name, IP, Port, Callback]},
        permanent, brutal_kill, worker, [?SERVICE]},
    supervisor:start_child(?MODULE, Spec).

init([]) ->
    create_table(?TABLES),
    {ok, {{one_for_one, 5, 10}, []}}.

create_table(Tables) when is_list(Tables) ->
    lists:foreach(fun create_table/1, Tables);
create_table({Table, Options}) ->
    ets:new(Table, [named_table, public | Options]).
