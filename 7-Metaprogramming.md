# 7. Metaprogramming

- One of the underpinning ideas of logic programming.
- Metaprogramming allows us to:
  - manipulate programs we write to improve their behaviour.
  - simulate execution and developformal theories about programs (e.g. debugging).
- Prolog's homoiconicity turns metaprogramming into an easy & elegant endeavour.
  - i.e. code is treated as data
  - hence we can use terms (data) to _name_ clauses (programs)

## Representations

- On a syntactic level, everything in Prolog is a term.
- Yet these are distinct from _literals_, in that literals are programs that have a truth value associated with them.
- The **_name_** of any literal is the term that shares its functor.
  - > _"By using these names as data in another program, we are able to manipulate the program whose name that data is."_
- This distinction between program syntax and the name of a program, is the distinction between _object-_ and _meta-levels_ respectively.
- In general, we don't want to have to mess about with special representations, it would be preferable to let a term represent or name itself.

  There are two problems with this:

  1. We cannot manipulate the terms by unification alone.
  1. We have to use Prolog variables to represent variables, but we can never know their names from within the program.

  - We call this the **_non-ground_** representation; we represent a variable with a variable (i.e. a non-ground term).
  - The preferable alternative is the **_ground_** representation, where we use the ground term to represent each variable.
    - Though this representation is not straightforwardly available in Prolog.
  - One advantage of the non-ground representation is that we can let Prolog look after unification by default.
  - With ground representation, variable bindings have to be handled explicitly.

Here is an interpreter for Prolog with conjunction between literals and disjunction between clauses:

```prolog
% solve/1
% succeeds if its argument has a solution
solve( true ).
solve( Goal ) :-
    \+ Goal = ( _, _ ),
    clause( Goal, Body ),
    solve( Body ).
solve(( Goal1, Goal2 )) :-
    solve( Goal1 ),
    solve( Goal2 ).

% clause/2
% succeeds if its arguments are the head & body of a clause in the database
clause( Goal, Body ) :-
    functor( Goal, Name, Arity ),
    functor( Goal2, Name, Arity ),
    recorded( Goal2, Body ).
```

By changing a single clause, we can rewrite the interpreter to make our computation rule work right-most first:

```prolog
solve(( Goal1, Goal2 )) :-
    solve( Goal2 ),
    solve( Goal1 ).
```

The goal of metaprogramming is manipulating what a program does without changing what it means, ideally making it more efficient.

- Execution is what a program does.
- The mapping between its input & output is what a program means.

```prolog
solve( [] ).
solve( [true|T] ) :-
    solve( T ).
solve( [Goal|Rest] ) :-
    \+ Goal = ( _, _ ),
    clause( Goal, Body ),
    conj2list( Body, List ),
    append( Rest, List, New ),
    solve( New ).
solve( [( Goal1, Goal2 )|Rest] ) :-
    solve( [Goal1, Goal2|Rest] ).

conj2list( Term, [Term] ) :-
    \+ Term = ( _, _ ).
conj2list(( Term1, Term2 ), [Term1|Terms] ) :-
    conj2list( Term2, Terms ).
```

## Metalevel Identity Testing

- `==` succeeds when its arguments are equivalent.
- `=` unifies its arguments.

```prolog
?- f(X) == f(X).
true.

?- X == Y.
false.

?- X = 1, X == Y.
false.

?- X is 42^0, Y is 40 mod 13, X == Y.
X = Y, Y = 1.

?- X = 2, Y == X, X = Y.
false.

?- X = 1, when(nonvar(Y), X == Y), g(1) = g(Y).
X = Y, Y = 1.

?- _ == _.
false.

?- _X == _X.
true.
```
