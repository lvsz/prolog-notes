# 4. Debugging

We think of each predicate in a program as having four ways in & out:

1. `Call`

   where control goes in on the _first_ attempt to prove a goal

1. `Succeed`

   where control comes out when the goal succeeds

1. `Retry`

   where control goes in on _subsequent_ attempts to prove a goal

1. `Fail`

   where control comes out when the goal fail

Some systems define a 5th port:

- `Exception`

  where control comes out on an error (e.g. instantiation error)

## Tracing

Several options can be applied:

- `c` / _Creep_

  take one proof step to the next port

- `s` / _Skip_

  jump to the next exit port (`Succeed` or `Fail`) from this invocation of the predicate

- `a` / _Abort_

  drop out of the execution and return to the Prolog prompt

- `n` / _Nodebug_

  switch off tracing and proceed as for normal execution

- `r` / _Retry_

  go back to the call whose invocation number is given

- `?` / _Help_

  print out a list of available commands

To be continued...
