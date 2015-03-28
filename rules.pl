:- [database].

path(State1,State2) :- transition(State1,State2,_,_,_).
path(State1,State2) :- transition(State1,X,_,_,_),path(X,State2).

get_starting_state(State) :- initial_state(State,null).

state_is_reflexive(State) :- path(State,State).

get_guards(Ret) :- transition(_,_,_,Ret,_), Ret \= null.

get_events(Ret) :- transition(_,_,Ret,_,_), Ret \= null.

get_actions(Ret) :- transition(_,_,_,_,Ret), Ret \= null.

/*
get_only_guarded(Ret) :-
legal_events_of(State, L) :-
*/