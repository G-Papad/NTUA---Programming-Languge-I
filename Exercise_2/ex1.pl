min(A, B, A) :- A=<B.
min(A, B, B) :- A>B.

max(A, B, A) :- A>B.
max(A, B, B) :- A=<B.

addto([], _, []).
addto([Head | Tail], Add_number, [X | AddtoList]) :- 
    X is Head + Add_number,
    addto(Tail, Add_number, AddtoList).
    
prefix([], _, []).
prefix([Head | Tail], Sum, [X | PrefixList]) :-
    X is Sum + Head,
    prefix(Tail, X, PrefixList).
    
%leftMax().
leftMax([], _, []).
leftMax([Head | Tail], Max, [X | LeftMaxList]) :-
    max(Head, Max, X),
    leftMax(Tail, X, LeftMaxList).
%rightMin().
rightMinHelp([], _, []).
rightMinHelp([Head | Tail], Min, [X | RightMinList]) :-
    min(Head, Min, X),
    rightMinHelp(Tail, X, RightMinList).
    
rightMin(List, Answer) :-
    reverse(List, [H|T]),
    rightMinHelp([H|T], H, Temp),
    reverse(Temp, Answer).
%longestSpan().
longestSpan(_, [], I, J, _, Current_res, Answer) :-
    X is J-I,
    max(X, Current_res, Answer).
longestSpan([], _, I, J, _, Current_res, Answer) :-
    X is J-I,
    max(X, Current_res, Answer).
longestSpan([Rhead | Rtail], [Lhead | Ltail], I, J, Flag, Current_res, Answer) :-
    Y is J-I,
    max(Current_res, Y, Res), 
    Rhead =< Lhead -> ((I=:=0, Flag =:= 1) -> NewJ is J+1, NewCurrent_res is Res+1, longestSpan(Rtail, [Lhead | Ltail], I, NewJ, Flag, NewCurrent_res, Answer) ; NewJ is J+1, longestSpan(Rtail, [Lhead | Ltail], I, NewJ, Flag, Res, Answer)) ; NewI is I+1, longestSpan([Rhead | Rtail], Ltail, NewI, J, Flag, Current_res, Answer). 

%solution
solution([H|T], N, Answer) :- 
    addto([H|T], N, Temp1),
    prefix(Temp1, 0, [Head | Tail]),
    rightMin([Head|Tail], Temp2),
    leftMax([Head|Tail], Head, Temp3),
    Y is H+N,
    (Y =< 0 -> (Flag is 1, longestSpan(Temp2,Temp3,0,0,Flag,0,Answer)) 
    ; (Flag is 0, longestSpan(Temp2,Temp3,0,0,Flag,0,Answer))).
    
%read_input().
read_input(File, N, K, C) :-
    open(File, read, Stream),
    read_line(Stream, [N, K]),
    read_line(Stream, C).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).

%longest
longest(File, Answer) :-
    read_input(File, _, K, C),
    solution(C, K, Answer).
