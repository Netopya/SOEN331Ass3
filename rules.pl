:- [database].

%Rules

%1
is_loop(Event, Guard) :- transition(Initial, Next, Event, Guard, _), is_loop_helper(Initial, Next, []).
is_loop_helper(Initial, Next, Visited) :- Initial = Next.
is_loop_helper(Initial, Next, Visited) :- transition(Next, Afterwards, _, _, _), not(member(Afterwards, Visited)), append(Visited, [Afterwards], NewVisited), is_loop_helper(Initial, Afterwards, NewVisited).

%2
all_loops(Set) :- findall([Event, Guard], is_loop(Event, Guard), List), list_to_set(List, Set).

%3
is_edge(Event, Guard) :- transition(_, _, Event, Guard, _).

%4
size(Length) :- findall([Event, Guard], is_edge(Event, Guard), List), length(List, Length).

%5
is_link(Event, Guard) :- transition(_, _, Event, Guard, _).

%6
all_superstates(Set) :- findall(Supersate, superstate(Supersate, _), List), list_to_set(List, Set).

%7
ancestor(Ancestor, Descendant) :- transition(Ancestor, Descendant, _, _, _).

%8
inheritss_transitions(State, List) :- inherits_transitions_helper(State, List, []).
inherits_transitions_helper(State, List, Collection) :- superstate(Superstate, State), not(superstate(_, Superstate)), findall([Event, Guard], transition(Superstate, _, Event, Guard, _), Elements), append(Collection, Elements, List).
inherits_transitions_helper(State, List, Collection) :- superstate(Supersate, State), findall([Event, Guard], transition(Supersate, _, Event, Guard, _), Elements), append(Collection, Elements, NewList), inherits_transitions_helper(Supersate, List, NewList).

%9
all_states(L) :- findall(State, state(State), L).

%10
all_init_states(L) :- findall(State, initial_state(State, _), L).

path(State1,State2) :- transition(State1,State2,_,_,_).
path(State1,State2) :- transition(State1,X,_,_,_),path(X,State2).

%11
get_starting_state(State) :- initial_state(State,null).

%12
state_is_reflexive(State) :- path(State,State).

%13
graph_is_reflexive :- initial_state(State,null), state_is_reflexive(State).

%14
get_guards(Ret) :- findall(X,(transition(_,_,_,X,_),X \= null),Lst),list_to_set(Lst,Ret).

%15
get_events(Ret) :- findall(X,(transition(_,_,X,_,_),X \= null),Lst),list_to_set(Lst,Ret).

%16
get_actions(Ret) :- findall(X,(transition(_,_,_,_,X),X \= null),Lst),list_to_set(Lst,Ret).

%17
get_only_guarded(Ret) :- transition(State1,State2,_,X,_), X \= null, Ret = [State1,State2].

%18
legal_events_of(State, L) :- (transition(State,_,Event,Guard,_);transition(_,State,Event,Guard,_)), Guard \= null, L = [Event,Guard].
