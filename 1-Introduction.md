# 1. Introduction

Broadly 2 kinds of programming languages:

- Procedural
- Declarative

Declarative languages also subdivided in 2 kinds:

- Functional
- Logical

Prolog is a declarative, logical, programming languages.

## 1.1. Basic Elements

We give a database of **facts**:

- some are always true
- some are dependent from others

To run a program, we ask questions about the given facts.

## 1.2. Anatomy

- Prolog programs consist of **_predicate definitions_**
  - like `parent/2`
- Predicate definitions consist of _one or more_ **_clauses_**
  - `parent( P1, P2 ) :- mother( P1, P2 ).` is one clause.
- A clause always has a **_head_**: `parent( P1, P2 )`
  - Possibly has a **_body_**: `mother( P1, P2 )`
  - Always end with a period.
- A clause head has a **_predicate name_** and possibly one or more **_arguments_**.
- The body is a collection of **_literals_**, which match clause heads.
- Arguments consist of **_terms_**, which are similar in form to literals.

## 1.3. Proof Strategy

- To prove a goal true:
  1. Start at the top of the database.
  1. Scan down for a clause whose head can be unified with the goal.
     - If no such clause can be found, backtrack to the _last clause chosen_ and try to find an alternative further down the database.
  1. Proceed to the next unproven goal when the clause has no body.
     - If there is a body:
       - substitute the goal with the body,
       - instantiate any variables following the unification,
       - and start again _(recurse)_ with the first goal.
  1. Stop when there are no more unproven goals.
- If a query succeeds, it returns a **_unifier_**.
  - This is collection of variables which occured in the query, associated with values which allows the query to succeed.

This is the default strategy, but it is possible to override it.

<details>
  <summary>Previous explanation.</summary>
  - Prolog solves questions by attempting to **_prove_** them.
  - To do this, it starts at the top of the database to look for matching predicates.
  - Then it looks at each clause, and tries to **_unify_** its head with the goal.
  - Once unification is complete, try to prove the literals in the body, in order of appearance.
</details>

## 1.4. Unification

- Unification works by comparing the structure of literals:
  - First compare the predicate name _(functor)_;
  - Then for each pair of respective arguments:
    - If one is a variable, let it be identical to the other.
    - Continue if both are identical.
    - Otherwise, unification fails.
- This differs from the proof strategy, in that proof recurses over _literals_, whereas unification recurses over _terms_.
- This approximation of the algorithm is unsound in one particular situation, when a variable is unified with a term strictly containing itself:
  - `X = f(X)`
  - `g(X) = g(p(X,Y))`

## 1.5. Negation

- Negation in Prolog works by
  1. trying to prove the negated goal;
  1. if the goals succeeds, fail the current proof;
  1. if it fails, then proceed to the next goal, _as though it had succeeded_.

> Known as **_Negation As Failure_** _(NAF)_.

### 1.5.1. Floundering

- Consider these goals:
  - `X = 5, \+ ( X = 2 ).`
  - `\+ ( X = 2 ), X = 5.`
- Logically equivalent; both ought to succeed, with `X = 5`.

> _However_, these are not the same in (old-fashioned) Prolog, because the **_logical semantics_** (meaning) diverges from the **_procedural semantics_** (way of running the program) at this point.

## 1.6. Atoms & Compound Terms

> _"Knowledge is knowing what is true."_

- Each compound term belongs to a functor.
- Compound terms have arguments.
- Each arguments is a term.

- Eamples of terms:

  - `simple_term`
  - `dog(bonzo)`
  - `fat(X)`
  - `lots(a,D,2,f(X,g))`
  - `'a string'( 'EVEN capitals!' )`

- Not terms:
  - `2(X)` (cannot start with a number).
  - `X(2)` (cannot start with an uppercase letter, i.e. cannot be a variable).

Difference between _literals_ and _terms_:

- Literals form individual goals, have a truth value.
- Terms are values in themselves, lack a truth value.

## 1.7. Lists

Two ways to represent lists in Prolog:

- internal representation
- _syntactic sugar_

Internal representation uses 2 symbols:

- `.` (dot, a functor)
- `[]` (empty list, an atom)

`.` connects a left term to a right list.

The last list to be connectexd to any list is `[]`.

```prolog
[]
.(a,[])
.(1,(2,[]))
.(.(a,[]),.(.(b,.(c,[])),[]))
```

Insteaf of `.`, we can write `[A|B]`,

- with `A` is the term _(head)_
- and `B` is the list _(tail)_.

```prolog
[]
[a|[]]
[1|[2|[]]]
[[a|[]]|[[b|[c|[]]]]]
```

This can be further simplified using `,`, so we get:

```prolog
[]
[a]
[1,2]
[[a],[b,c]]
```

Lists are important because:

- they enable us to deal with collections of items.
- they enable us to control recursive programs.
