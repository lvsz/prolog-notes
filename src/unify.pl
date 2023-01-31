flatten( [], [] ).
flatten( [pair( A, B )|Pairs], Ans ) :-
    flatten( Pairs, Rest ),
    append( [A,B], Rest, Ans ).

:- meta_predicate solve( + ).

solve( [] ).
solve( [true|T] ) :-
    solve( T ).
solve( [Goal|Rest] ) :-
    \+ Goal = ( _, _ ),
    klause( Goal, Body ),
    conj2list( Body, List ),
    append( Rest, List, New ),
    solve( New ).
solve( [( Goal1, Goal2 )|Rest] ) :-
    solve( [Goal1, Goal2|Rest] ).

klause( Goal, Body ) :-
    \+ predicate_property( Goal, foreign ),
    clause( Goal, Body ).
klause( Goal, _ ) :-
    predicate_property( Goal, foreign ),
    call( Goal ).
    

conj2list( Term, [Term] ) :-
    \+ Term = ( _, _ ).
conj2list(( Term1, Term2 ), [Term1|Terms] ) :-
    conj2list( Term2, Terms ).

append( [], List, List ).
append( [A|As], Bs, [A|Cs] ) :-
    append(As, Bs, Cs).
% usage: append( [a,b|X]-X, [x,y,z|Y]-Y, Ans ).
append( As-Bs, Bs-Cs, As-Cs ).

mklist( N, L ) :-
    once( mklist_( N, N, L ) ).
mklist_( _, 0, [] ).
mklist_( N, I, [_|R] ) :-
    J is I - 1,
    mklist_( N, J, R ).

len( Xs, N ) :-
    nonvar( N ),
    once(len_( Xs, N )),
    !.
len(Xs, N) :-
    var(N),
    var(Xs),
    infl(Xs, N).
len(Xs, N) :-
    var(N),
    len_(Xs, N).

len_( [], 0 ) :- !.
len_( [_|Xs], N ) :-
    nonvar( Xs ),
    !,
    len_( Xs, M ),
    N is M + 1.
len_( Xs, N ) :-
    nonvar( N ),
    mklist( N, Xs ).
    %nonvar( N ),
    %len_( Xs, N ).
len_( [_|Xs], N ) :-
    var(N), var(Xs),
    infl(Xs,M),
    succ(M, N).

infl([],0).
infl([_|X],N) :-
    infl(X,M),
    succ(M, N).

% unify/3
unify( T1, T2, Binds ) :-
    unify( T1, T2, [], Binds ).


% unify/4
unify( T1, T2, Bin, Bout ) :-
    is_term( T1, F, Args1 ),
    is_term( T2, F, Args2 ),
    unify_args( Args1, Args2, Bin, Bout ).

unify( Var, Var, Bin, Bin ) :-
    is_var( Var ).

unify( Var, Any, Bin, Bout ) :-
    \+ ( Var = Any ),
    is_var( Var ),
    binds( Var, Bin, T ),
    unify( T, Any, Bin, Bout ).

unify( T, Var, Bin, Bout ) :-
    is_var( Var ),
    is_term( T, _, _ ),
    binds( Var, Bin, X ),
    unify( T, X, Bin, Bout ).

unify( Var, Any, Bin, [Var=Any|Bin] ) :-
    \+ ( Var = Any ),
    is_var( Var ),
    \+ binds( Var, Bin, _ ),
    \+ unified( Var, Bin, _, Any ).

unify( Var, Any, Bin, Bin ) :-
    \+ ( Var = Any ),
    is_var( Var ),
    \+ binds( Var, Bin, _ ),
    unified( Var, Bin, _, Any ).

unify( T, Var, Bin, [Var=T|Bin] ) :-
    \+ ( Var = T ),
    is_var( Var ),
    is_term( T, _, _ ),
    \+ binds( Var, Bin, _ ).
    

% unify_args/4
unify_args( [], [], Bin, Bin ).
unify_args( [X|Xs], [Y|Ys], Bin, Bout ) :-
    unify( X, Y, Bin, Mid ),
    unify_args( Xs, Ys, Mid, Bout ).


% binds/3
binds( Var, Bin, T ) :-
    is_term( T, _, _ ),
    unified( Var, Bin, _, T ).
binds( Var, Bin, X ) :-
    is_var( Y ),
    unified( Var, Bin, Rest, Y ),
    binds( Y, Rest, X ).


% unified/4
unified( Var, [Var=X|Bin], Bin, X ).
unified( Var, [X=Var|Bin], Bin, X ).
unified( Var, [B|Bin], [B|Rest], X ) :-
    unified( Var, Bin, Rest, X ).


% is_term/3
is_term( F-[], F, [] ).
is_term( F-[X|Xs], F, [X|Xs] ).


% is_var/1
is_var( +_Atom ).
