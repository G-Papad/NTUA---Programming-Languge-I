%reading input
read_input(File, N, K, C) :-
    open(File, read, Stream),
    read_line(Stream, [N, K]),
    read_line(Stream, C).
    
read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).   

%initialize an Array with N zeros		
init(0,[]).		
init(N,[0|T]):-
    NN is N-1,
    init(NN,T).

%convert carList to CityList
nctc([],C,C).		
nctc([H|T], CityList,A):-
    nth0(H, CityList, Prev, Rest),
    New is Prev+1,
    nth0(H, NCityList, New, Rest),
    nctc(T,NCityList,A).

double(Array1, Array2, Answer):-
    reverse(Array1, Temp),
    double_help(Temp,Array2, Answer).
    
double_help([], Array, Array).
double_help([H|T], Array, Answer):- double_help(T, [H|Array], Answer).
    
findMaxDif(N, MaxDifIter, Iter, MaxDif):-
    (Iter >= MaxDifIter -> MaxDif is (Iter-MaxDifIter)
    ; MaxDif is (N-MaxDifIter+Iter)
    ).

iter_help([H|T], Iter, N, Answer):-
    (H =\= 0 -> 
        Answer is (Iter mod N)
    ;
        (
         NIter is Iter+1,
         iter_help(T, NIter, N, Answer)
        )
    ).
    
findMaxDifIter(Iter, MaxDifIter, [_|T], N, Answer):-
    (Iter == MaxDifIter -> 
        (
         NMIter is MaxDifIter+1,
         iter_help(T, NMIter, N, Answer)
        )
    ;Answer = MaxDifIter
    ).

init_sum(_, _, [], Sum, Sum).
init_sum(N, Iter, [H|T], Sum, Answer):-
    Nsum is (Sum+(N-Iter)*H),
    NIter is Iter+1,
    init_sum(N, NIter, T, Nsum, Answer).
    
solve(_,_,_,[],_,_,_,_,Moves,FinalCity, Moves, FinalCity).
solve(N, K, CityArray, [H|T], [DH|DT], Iter, MaxDifIter, Sum, Moves, FinalCity, M, C):- 
    findMaxDifIter(Iter, MaxDifIter, [DH|DT], N, NMaxDifIter),
    findMaxDif(N, NMaxDifIter, Iter, MaxDif),
    NSum is (Sum+K-N*H),
    Check is (2*MaxDif-1),
    NIter is Iter+1,
    (NSum >= Check ->
        (Moves > NSum ->
            solve(N, K, CityArray, T, DT, NIter, NMaxDifIter, NSum, NSum, Iter, M, C)
        ;
            solve(N, K, CityArray, T, DT, NIter, NMaxDifIter, NSum, Moves, FinalCity, M, C)
        )
    ;
        %check circle
        solve(N, K, CityArray, T, DT, NIter, NMaxDifIter, NSum, Moves, FinalCity, M, C)
    ).

mostCars([],_,_,City,City).
mostCars([H|T], Cars, I, City, Answer):-
    NI is I+1,
    (Cars < H -> mostCars(T,H,NI,I,Answer)
    ;mostCars(T,Cars,NI,City,Answer)
    ).

circleList([], [X], X).
circleList([H|T], [H|NT], X):- circleList(T,NT,X).

isAdjacent([_], Ret, Ret).
isAdjacent([H1,H2|T], _, Answer):-
    H1 =\= 0,
    H2 =\= 0,
    isAdjacent([H2|T], true, Answer).
isAdjacent([_|T], Temp, Answer):- isAdjacent(T,Temp,Answer).

isAdj([_,H2|_],0,true):-
    H2 =\= 0.
isAdj([_,H2|_],0,false):-
    H2 == 0.
isAdj([_|T],City,Answer):-
    NC is City-1,
    isAdj(T, NC, Answer).

circleSum([], _, _, _, Sum, Sum).
circleSum([H|T], N, I, TargetCity, Sum, Answer):-
    I=<TargetCity,
    Nsum is (Sum+(TargetCity-I)*H),
    NI is I+1,
    circleSum(T, N, NI, TargetCity, Nsum, Answer).
circleSum([H|T], N, I, TargetCity, Sum, Answer):-
    I > TargetCity,
    Nsum is (Sum+(N-I+TargetCity)*H),
    NI is I+1,
    circleSum(T,N,NI,TargetCity,Nsum,Answer).

circle([H|T], N, Moves, TargetCity):-
    mostCars([H|T], 0, 0, -1, TargetCity),
    circleSum([H|T], N, 0, TargetCity, 0, Sum),
    circleList([H|T], L, H),
    %isAdjacent(L, false, Adjacent),
    isAdj(L, TargetCity, Adjacent),
    (Adjacent ->
        Moves is (Sum+N)
    ;
        Moves is (Sum+2*N)
    ).

min(A,B,A):- A=<B.
min(A,B,B):- B<A.

round(File, M,C):-
    read_input(File, N, K, CarList),
    once(init(N,I)),
    nctc(CarList, I,[CityArray|T]),
    double([CityArray|T], [CityArray|T], Double),
    init_sum(N, 1, T, 0, InitSum),
    findMaxDifIter(0, 0, Double, N, NMaxDifIter),
    findMaxDif(N, NMaxDifIter, 0, MaxDif),
    Check is (2*MaxDif-1),
    (InitSum >= Check -> Init = InitSum
    ; %circle
      Init = 100000000000
    ),	 
    solve(N,K, T, T, Double, 1, 1, InitSum, Init, 0, TM, TC),
    circle([CityArray|T], N, CM, CC),
    min(TM, CM, M),
    (M==TM -> C = TC
    ;C = CC).
