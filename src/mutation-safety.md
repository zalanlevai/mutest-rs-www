# Mutation Safety

[Rust's notion of safety](https://doc.rust-lang.org/nomicon/safe-unsafe-meaning.html) is reflected in mutest-rs through a unique safety property that mutations have. In mutest-rs, we distinguish between safe and unsafe mutations, based on the safety of scope that they are introduced in, and the safety flag used to invoke mutest-rs with (see [Safety Flags](#safety-flags)).

To illustrate how we have to take safety into account when producing program mutations, let's use two valid, but incorrect example programs. This first one uses the unsafe `get_unchecked` function to perform an unchecked array lookup into an array `xs` of length 3. The index `i` comes from safe code, but its value of 100 will trigger undefined behavior in the unsafe code following it. If we imagine that the original program did not have this rogue value, but instead we introduced this behavior with a program mutation instead, then we would have generated a mutation that *introduced* undefined behavior into this program. Thus, we can see that modifying safe code in the context of unsafe code *may* lead to the introduction of undefined behavior.

```rust,ignore
let xs = [0; 3];
let i = 100;
let el = unsafe { xs.get_unchecked(i) };
```

Similarly, in this second example, we see the same scenario play out but with the incorrect out-of-bounds index coming from a safe function called form within the unsafe scope. Thus, we can see that modifying the body of a safe function *may* lead to the introduction of undefined behavior if the function is called from unsafe code.

```rust,ignore
fn size() -> usize {
    100
}

let xs = [0; 3];
let el = unsafe {
    let i = size() - 1;
    xs.get_unchecked(i)
};
```

To ensure safety of the mutated program, mutest-rs does two things when analysing the program and generating mutations:

* treats these possibly unsafe contexts as unsafe, and
* propagates potential unsafety through the call graph.

While this ensures safety in all contexts, depending on your codebase and use of unsafe, this behavior might be too eager. In addition, evaluating these unsafe mutations might be extremely valuable for uncovering inadequacies in the testing of unsafe code. As such, mutest-rs provides safety flags that relax some of the rules around which mutations are deemed safe, which context are mutations generated in, and whether unsafe mutations are evaluated.

## Safety Flags in mutest-rs { #safety-flags }

The following table describes how each of the safety flags (default: `--safe`) influences what contexts mutations get generated in, and what safety the mutations in that scope get assigned. In the table, the `^` symbol signifies the place of the mutation, and `M` refers to a mutation in that scope.

| Safety Flag  | `unsafe { ^ }` | `{ ^ unsafe {} }` | `{ unsafe {} ^ }` | `{ ^ }` |
| ------------ | :------------: | :---------------: | :---------------: | :-----: |
| `--safe`     |    &mdash;     |      &mdash;      |      &mdash;      |    M    |
| `--cautious` |    &mdash;     |     unsafe M      |     unsafe M      |    M    |
| `--risky`    |    &mdash;     |         M         |         M         |    M    |
| `--unsafe`   |    unsafe M    |         M         |         M         |    M    |
