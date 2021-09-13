read_input(File, N, C) :-
    open(File, read, Stream),
    read_line(Stream, N),
    read_line(Stream, C).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).

initial/1.
final/1.

qssorthelp(File, Answer) :- 
    read_input(File, _, C),
    assert(initial(C)),
    msort(C,F),
    assert(final(F)),
    solution(Temp),
    retract(initial(C)),
    retract(final(F)),
    empty(Temp, Temp1),
    atomics_to_string(Temp1, Answer). 

qssort(File, Answer) :-
    once(qssorthelp(File, Answer)).

addtoEnd(List, Item, Answer) :-
    reverse(List, Temp),
    Temp1 = [Item|Temp],
    reverse(Temp1, Answer).

move([Qhead|Qtail], Qcount, Sstate, "Q", Qtail, [Qhead|Sstate], NewQcount, N):-
    M is (N div 2),
    Qcount =< M,
    NewQcount is (Qcount + 1).
move([Qhead|Qtail], Qcount, [Shead|Stail], "S", NewQ, Stail, Qcount, _) :- 
    Qhead =\= Shead,
    addtoEnd([Qhead|Qtail], Shead, NewQ).

solution(State, _, [], [], _) :- final(State).
solution(QState, Qcount, Sstate, [Move|Moves], N) :-
    move(QState, Qcount, Sstate, Move, NewQState, NewSstate, NewQcount, N),
    solution(NewQState, NewQcount, NewSstate, Moves, N).

empty([],Answer) :- Answer = ["e","m","p","t","y"].
empty(List,List).   
  
solution(Answer) :-
    initial(Start),
    length(Answer,N),
    Nw is N mod 2,
    Nw == 0,
    solution(Start, 0, [], Answer, N).  
