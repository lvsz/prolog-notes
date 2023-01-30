# 1. Non- & Metalogical Features of Prolog

## 1.1. Input/Output

- Inherently sequential.
- Output:  
  we cannot give a truth value to the _action_ of printing something.
- Input:  
  we could, perhaps, view input as coming from a changing Prolog database, but this does not help one understand a program's semantics.
- Problems get worse when introducing flexible computation rules.
- There are ways to tell a declarative story about I/O that won't get covered in this course.
  - _monads?_

### File-based

- Based on the idea of a _"current file"_ (possibly the terminal).
- Can have several files open, but only read from or write to one at a time.
- Each file has a pointer, marking where the last operation took place.
  - So when swiching between files, you continue where you left off.
- Also known as _Edinburgh-style I/O_.
  - Old-fashioned approach, but still in use.
- Basic commands:
  - `see/1`
  - `seeing/1`
  - `seen/0`
  - `read/1`
  - `tell/1`
  - `telling/1`
  - `told/0`
  - `write/1`
  - `append/1`
  - `ln/0`

### Stream-based

- Associate each open file with an explicit pointer, with which we refer to it subsequently.
- Basic stream handling predicates:
  - `open(+File, +Mode, -Ptr)`
  - `close(+Ptr)`
  - `current_input(?Ptr)`
  - `set_input(+Ptr)`
  - `read(+Ptr, ?Term)`
  - `write(+Ptr, ?Term)`

Most reading & writing predicates come in two versions:

- to the current stream _(e.g. `write/1`)_
- to the named stream _(e.g. `write/2`)_

## Arithmetic

- Because `=/2` means _"unify"_, arithmetic is done using `is/2`.
- `is(?Number, +Expression)` computes the values of the arithmetic expression in its second argument.
- Arithmetic predicates include:
  - `>=/2`
  - `>/2`
  - `=:=/2`
  - `=\=/2`
  - `=</2`
  - `</2`

## Meta-Predicates

> _"Predicates that work on data beyond the logic of Prolog."_

- Meta-level >< Object-level

### When to Metaprogram

1. If you have to use a meta-predicate, and you're not sure why, there is something wrong.
2. If you have to use a meta-predicate and your data is not (part of) a program clause, there is something wrong.
   - i.e. when you're using it on an ordinary Prolog value.
3. Do not ever use meta-predicates to control the run-time behaviour of Prolog, because:
   - it messes up the logic of the program.
   - it makes your program very hard to analyse automatically.
   - it makes the compiler work sub-optimally.
   - there are much better ways to do it.

### Safe-To-Use Meta-Predicates

These are three meta-predicates which are useful and mostly safe logically, all concerned with finding multiple solutions to queries:

- `findall/3`
  - Differs from the other two in its treatment of uninstantiated variables in its goal which are not named in the first argument.
  - It assumed that all variables exclusive to the goal are _existentially quantified_.
  - This means they can take any _(i.e. more than one)_ value, while the answers are generated.
- `bagof/3`
  - Requires explicit existential quantification with the `^` operator.
  - Otherwise, each of the free variables takes a fixed value, with the predicate backtracking to produce all the possible answers.
- `setof/3`
  - Like `bagof/3`, but as a _set_ instead of a _multiset_.

For example, these queries produce the same answers (not necessarily in the same order):

```prolog
findall( X, p( X, Y ), L ).
bagof( X, Y^p( X, Y ), L ).
```

These queries may have different answers:

```prolog
findall( X, p( X, Y ), L ).
bagof( X, Y^p( X, Y ), L ).
```

Note that if `Y` is already ground at call-time, there is no difference in any of the behaviours.

## Illogical Predicates to Avoid

Prolog has two _commit_ operators:

- `!` / _Cut_
  - _Green cut_
    - Can be removed without changing the _logical_ behaviour of the program.
    - Effect is purely prodedural, optimising efficiency:
      - `max( X, Y, X ) :- X > Y, !.`
      - `max( X, Y, Y ) :- X =< Y.`
  - _Red cut_
    - Cannot be removed without changing the logical behaviour of the program.
    - Removing `!` can lead to an incorrect result on backtracking:
      - `max( X, Y, X ) :- X > Y, !.`
      - `max( X, Y, Y ).`
- `->` / _"Implies"_
  - Only corresponds to the logical implication if its left argument is fully instantiated.

### Negation as Failure

With `!`, we can implement NAF:

```prolog
\+ Goal :- call( Goal ),
           !,
           fail.
\+ _Goal.
```

If `call( Goal )` succeeds, `!` will prevent Prolog from backtracking to `\+`'s second clause, thus avoiding unintended results.
