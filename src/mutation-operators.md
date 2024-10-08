# Mutation Operators

Mutation operators are the rules that match patterns of program code, and produce corresponding mutations.

The active set of mutation operators can be controlled using the `--mutation-operators` argument (default: `all`), by specifying a comma-seperated list of mutation operator names.

```sh
cargo mutest --mutation-operators call_delete,call_value_default_shadow run
```

The following list of mutation operators is currently implemented in mutest-rs, with detailed descriptions and examples below:

| Mutation Operator                                         | Short Description                                                      |
| --------------------------------------------------------- | ---------------------------------------------------------------------- |
| [`arg_default_shadow`](#arg_default_shadow)               | Ignore argument by shadowing it with `Default::default()`.             |
| [`bit_op_or_and_swap`](#bit_op_or_and_swap)               | Swap bitwise OR for bitwise AND and vice versa.                        |
| [`bit_op_or_xor_swap`](#bit_op_or_xor_swap)               | Swap bitwise OR for bitwise XOR and vice versa.                        |
| [`bit_op_shift_dir_swap`](#bit_op_shift_dir_swap)         | Swap the direction of bitwise shift operator.                          |
| [`bit_op_xor_and_swap`](#bit_op_xor_and_swap)             | Swap bitwise XOR for bitwise AND and vice versa.                       |
| [`bool_expr_negate`](#bool_expr_negate)                   | Negate boolean expression.                                             |
| [`call_delete`](#call_delete)                             | Delete call and replace it with `Default::default()`.                  |
| [`call_value_default_shadow`](#call_value_default_shadow) | Ignore return value of call by shadowing it with `Default::default()`. |
| [`continue_break_swap`](#continue_break_swap)             | Swap continue for break and vice versa.                                |
| [`eq_op_invert`](#eq_op_invert)                           | Invert equality check.                                                 |
| [`logical_op_and_or_swap`](#logical_op_and_or_swap)       | Swap logical *and* for logical *or* and vice versa.                    |
| [`math_op_add_mul_swap`](#math_op_add_mul_swap)           | Swap addition for multiplication and vice versa.                       |
| [`math_op_add_sub_swap`](#math_op_add_sub_swap)           | Swap addition for subtraction and vice versa.                          |
| [`math_op_div_rem_swap`](#math_op_div_rem_swap)           | Swap division for modulus and vice versa.                              |
| [`math_op_mul_div_swap`](#math_op_mul_div_swap)           | Swap multiplication for division and vice versa.                       |
| [`range_limit_swap`](#range_limit_swap)                   | Swap limit (inclusivity) of range expression.                          |
| [`relational_op_eq_swap`](#relational_op_eq_swap)         | Include or remove the boundary (equality) of relational operator.      |
| [`relational_op_invert`](#relational_op_invert)           | Invert relation operator.                                              |

> **NOTE**: The following replacements are illustrative and are meant to show how code behaviour effectively changes with each mutation.

## `arg_default_shadow`

Replace the provided arguments of functions with `Default::default()` to check if each parameter is tested with meaningful values.

This is done by rebinding parameters at the beginning of the function.

> Replaces
> ```rust,ignore
> fn foo(hash: u64) {
> ```
> with
> ```rust,ignore
> fn foo(hash: u64) {
>     let hash: u64 = Default::default();
> ```

## `bit_op_or_and_swap`

Swap bitwise OR for bitwise AND and vice versa.

> Replaces
> ```rust,ignore
> byte & (0x1 << 2)
> ```
> with
> ```rust,ignore
> byte | (0x1 << 2)
> ```

## `bit_op_or_xor_swap`

Swap bitwise OR for bitwise XOR and vice versa.

> Replaces
> ```rust,ignore
> bytes[i] |= 0x1 << 3
> ```
> with
> ```rust,ignore
> bytes[i] ^= 0x1 << 3
> ```

## `bit_op_shift_dir_swap`

Swap the direction of bitwise shift operators.

> Replaces
> ```rust,ignore
> byte & (0x1 << i)
> ```
> with
> ```rust,ignore
> byte & (0x1 >> i)
> ```

## `bit_op_xor_and_swap`

Swap bitwise XOR for bitwise AND and vice versa.

> Replaces
> ```rust,ignore
> byte & (0x1 << 2)
> ```
> with
> ```rust,ignore
> byte ^ (0x1 << 2)
> ```

## `bool_expr_negate`

Negate boolean expressions.

> Replaces
> ```rust,ignore
> if !handle.is_active() {
>     drop(handle);
> ```
> with
> ```rust,ignore
> if handle.is_active() {
>     drop(handle);
> ```

## `call_delete`

Delete function calls and replace them with `Default::default()` to test whether inner calls are meaningfully tested, without retaining any side-effects of the callees.

> Replaces
> ```rust,ignore
> let existing = map.insert(Id(123), 0);
> ```
> with
> ```rust,ignore
> let existing: Option<usize> = Default::default();
> ```

## `call_value_default_shadow`

Replace the return value of function calls with `Default::default()` to test whether the return values of inner calls are meaningfully tested, while retaining expected side-effects of the callees.

> Replaces
> ```rust,ignore
> let existing = map.insert(Id(123), 0);
> ```
> with
> ```rust,ignore
> let existing: Option<usize> = {
>     let _existing = map.insert(Id(123), 0);
>     Default::default()
> };
> ```

## `continue_break_swap`

Swap continue expressions for break expressions and vice versa.

> Replaces
> ```rust,ignore
> for other in mutations {
>     if conflicts.contains(&(mutation, other)) { continue; }
> ```
> with
> ```rust,ignore
> for other in mutations {
>     if conflicts.contains(&(mutation, other)) { break; }
> ```

## `eq_op_invert`

Invert equality checks.

> Replaces
> ```rust,ignore
> if buffer.len() == 0 {
>     buffer.reserve(1024);
> ```
> with
> ```rust,ignore
> if buffer.len() != 0 {
>     buffer.reserve(1024);
> ```

## `logical_op_and_or_swap`

Swap logical `&&` for logical `||` and vice versa.

> Replaces
> ```rust,ignore
> self.len() <= other.len() && self.iter().all(|v| other.contains(v))
> ```
> with
> ```rust,ignore
> self.len() <= other.len() || self.iter().all(|v| other.contains(v))
> ```

## `math_op_add_mul_swap`

Swap addition for multiplication and vice versa.

> Replaces
> ```rust,ignore
> let offset = size_of::<DeclarativeEnvironment>() * index;
> ```
> with
> ```rust,ignore
> let offset = size_of::<DeclarativeEnvironment>() + index;
> ```

## `math_op_add_sub_swap`

Swap addition for subtraction and vice versa.

> Replaces
> ```rust,ignore
> let center = Point::new(x + (width / 2), y + (height / 2));
> ```
> with
> ```rust,ignore
> let center = Point::new(x - (width / 2), y + (height / 2));
> ```

## `math_op_div_rem_swap`

Swap division for modulus and vice versa.

> Replaces
> ```rust,ignore
> let evens = 0..100.filter(|v| v % 2 == 0);
> ```
> with
> ```rust,ignore
> let evens = 0..100.filter(|v| v / 2 == 0);
> ```

## `math_op_mul_div_swap`

Swap multiplication for division and vice versa.

> Replaces
> ```rust,ignore
> let v = f64::sin(t * freq) * magnitude;
> ```
> with
> ```rust,ignore
> let v = f64::sin(t / freq) * magnitude;
> ```

## `range_limit_swap`

Invert the limits (inclusivity) of range expressions.

> Replaces
> ```rust,ignore
> for i in 0..buffer.len() {
> ```
> with
> ```rust,ignore
> for i in 0..=buffer.len() {
> ```

## `relational_op_eq_swap`

Include or remove the boundary (equality) of relational operators.

> Replaces
> ```rust,ignore
> if self.len() <= other.len() {
> ```
> with
> ```rust,ignore
> if self.len() < other.len() {
> ```

## `relational_op_invert`

Completely invert relation operators.

> Replaces
> ```rust,ignore
> while i < buffer.len() {
> ```
> with
> ```rust,ignore
> while i >= buffer.len() {
> ```
