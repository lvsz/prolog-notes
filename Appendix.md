# Prolog Glossary

## 1. Glossary of Terms

<!-- :%s/,,(\w+),(\w*)/[\1\2][#\1]/g -->

### argument

- Arguments are [terms](#term) that appear in a [compound](#compound) term.

### atom

- A textual constant.
- An _atomic_ [term](#term) is one that is [bound](#binding) and has an arity of zero.

### backtracking

- Search process used by Prolog, based on depth-first search.
- If a [predicate](#predicate) offers multiple [clauses](#clause), they are tried one-by-one until one succeeds.
  - [Binds](#binding) [variables](#variable) in the process.
- If a subsequent part of the proof is unsatisfied with the resulting [variable](#variable) [binding](#binding), it may ask for an alternative [solution](#solution).
  - Causes Prolog to reject the previouslu chosen [clause](#clause), and try the next one.

### binding

- Association of a [variable](#variable) name and a value.

### clause

- Either a [fact](#fact) or a head, followed by a neck & body
- Prolog's equivalent of a _'sentence'_, ending with a period.

### compound

- A [term](#term) consisting of a name and one or more [arguments](#argument).
- Also known as a _structure_.

### fact

- A [clause](#clause) that's all head, no body.

### fail

- A [goal](#goal) fails if it cannot be [proven](#prove).

### functor

- Combination of a name and arity of an [atom](#atom) or a [compound](#compound) term.
  - `foo/0` is a functor referring to the [atom](#atom) `foo`.
  - `foo(a,b,c)` is a [term](#term) belonging to the _functor_ `foo/3`.

### goal

- A question stated to the Prolog engine.
- A goal is either an [atom](#atom) or a [compound](#compound) term.
  - [Compound](#compound) terms can include conjunctions & disjunctions, using (sub)goals as arguments.
- It succeeds if it can be proven, resulting in a [solution](#solution).
- Otherwise it [fails](#fail).
- Also known as a [query](#query).

### literal

- > _"Literals form individual goals to which a truth value can be assigned."_

### predicate

- A collection of [clauses](#clause) with the same [functor](#functor).
- Associated with a truth value.
- > _"Something which is about another something."_

### prove

- Process in which Prolog attempts to [bind](#binding) [variables](#variable) in a [query](#query).
- Scans over the available [predicates](#predicate) to find matching heads.
- Uses [unification](#unify) and [backtracking](#backtracking) to arrive to a [solution](#solution).

### query

- Synonym for [goal](#goal).

### solution

- A collection of [variable](#variable) names, associated with values, that allowed a [goal](#goal) to succeed.
- Also known as a _unifier_.

### term

- A value in Prolog, either a [variable](#variable), [atom](#atom), or [compound](#compound).
- A unit of data.
- > _"A description of something."_
- > _"Terms are values in themselves and do not have a truth value."_
- > _"Every single piece of data in Prolog, without exceptions, is a term."_

### unify

- Process to make two terms equal by [binding](#binding) [variables](#variable) in one term to values at the corresponding location of the other term.

### variable

- A value that is not yet bound.

---

## 2. Argument Mode Indicators (simplified)

### \+

- Argument must be instantiated at call-time.
- Input value.

### \-

- Argument may not be bound at call-time.
- Output value.

### ?

- Argument may instantiated, partially instantiated, or uninstantiated at call-time.
