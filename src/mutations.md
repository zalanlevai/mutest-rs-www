# Mutations

Mutations are the individual faults we inject into the program. Think of an accidental multiplication instead of an addition, a negated boolean expression, or something more complex. When a mutation is applied to the valid program, it effectively creates a mutant program, with slightly different behavior. These are used to evaluate the test suite, by seeing whether the test suite is able to *"detect"* this difference in behavior.

Mutations in mutest-rs are generated upfront, and combined into a single executable program for efficiency, alongside the generic mutation test harness (contained in the `mutest-runtime` crate).

The mutations mutest-rs produces can be controlled in various ways:

* by changing the mutation depth, the depth in the call graph up to which mutest-rs attempts to generate mutations, using the `-d`, or `--depth` argument (default: 3);
* by changing the set of [mutation operators](./mutation-operators.md) during the invocation of mutest-rs, changing the set of transformation rules applied to the program;
* by applying [tool attributes](./tool-attributes.md) to individual code elements (e.g. functions, statements, expressions), giving you fine-grained control over where and how mutation operators are applied.

Mutations in mutest-rs have a unique safety property, matching [Rust's notion of safety](https://doc.rust-lang.org/nomicon/safe-unsafe-meaning.html). Depending on the nature of your codebase, you may relax the safety requirements mutest-rs operates on, which influences how mutations are generated and evaluated. For more information, see [Mutation Safety](./mutation-safety.md).

In addition to controlling the generation of mutations, mutest-rs also implements novel techniques for improving the efficiency of evaluating these mutations. By [batching mutations](./batching-mutations.md), mutest-rs is able to improve the parallelism of mutation-related test case evaluation.
