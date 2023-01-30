# Definite Clause Grammars

- DCGs are a facility in Prolog which makes it easy to define languages according to grammar rules.
- Clause definitions use the `-->` operator instead of `:-`.
- We assume that the sequences of words we want to parse are stored as lists.
- Example:

  ```prolog
  startcommand --> [start, 1, player].
  startcommand --> [start], number_gt_one, [players].

  stopcommand --> [stop].

  savecommand --> [save], saveable_thing.

  saveable_thing --> [game].
  saveable_thing --> [player], number.

  number        --> [X], {integer( X ), X > 0}.
  number_gt_one --> [X], {integer( X ), X > 1}.
  ```

- Arbitrary bits of Prolog code can be included in DCGs by placing it in between braces.

- Making DCGs more useful:

  ```prolog
  command --> startcommand.
  command --> stopcommand.
  command --> savecommand.
  ```

- Now we can take a list of words, and test whether or not they are a command:

  ```prolog
  ?- command([the, fox, jumped, over, the, lazy, dog], []).
  false

  ?- command([save, player, 3], []).
  true
  ```

- Rule exansion:

  ```prolog
  a --> b, c.
  a( X, Z ) :- b( X, Y ),
               c( Y, Z ).
  ```

  - using the variable pair as a **_difference list_**, to avoid having to `append/3` things together.
  - These variables cannot be used directly in a program.

- Raw Prolog code, in `{}`, is inserted verbatim, resulting in the following expansion:

  ```prolog
  a --> b, {test( X )}, c.
  a(U, W) :- b( U, V ),
             test( X ),
             c( V, W ).
  ```

- Items in `[]` are processed using the built-in _`'C'` predicate_:

  ```prolog
  'C'( [Term|List], Term, List ).
  ```

- Hence a DCG rule including a constant expands as follows:

  ```prolog
  np --> [the], n.
  np( X, Z ) :- 'C'( X, the, Y ),
                n( Y, Z ).
  ```

- Using this `'C'` predicate, the earlier example ouwld come as the parser program:

  ```prolog
  command( Y, Z ) :- startcommand( Y, Z ).
  command( Y, Z ) :- stopcommand( Y, Z ).
  command( Y, Z ) :- savecommand( Y, Z ).

  startcommand( W, Z ) :- 'C'( W, start, X ),
                          'C'( X, 1, Y ),
                          'C'( Y, player, Z ).
  startcommand( W, Z ) :- 'C'( W, start, X ),
                          number_gt_one( X, Y ),
                          'C'( Y, players, Z ).

  stopcommand( Y, Z ) :- 'C'( Y, stop, Z ).

  savecommand( X, Z ) :- 'C'( X, save, Y ),
                         saveable_thing( Y, Z ).

  saveable_thing( Y, Z ) :- 'C'( Y, game, Z ).
  saveable_thing( X, Z ) :- 'C'( X, player, Y ),
                            number( Y, Z ).

  number( Y, Z )        :- 'C'( Y, X, Z ),
                           integer( X ),
                           X > 0.

  number_gt_one( Y, Z ) :- 'C'( Y, X, Z ),
                           integer( X ),
                           X > 1.
  ```
