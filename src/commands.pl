% code from 6-DCGs.pl made consultable

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

% ?- command([the, fox, jumped, over, the, lazy, dog], []).
% false
% 
% ?- command([save, player, 3], []).
% true
