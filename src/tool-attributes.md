# Controlling Mutations through Attributes

Custom [tool attributes](https://doc.rust-lang.org/reference/attributes.html#tool-attributes) can be used to control where and how mutation operators are applied by mutest-rs when generating mutations. These can be used to optionally annotate your code for use with mutest-rs.

Note, that these attributes are only available when running `cargo mutest`, so they need to be wrapped in `#[cfg_attr(mutest, <MUTEST_ATTRIBUTE>)]` to ensure that they are only present when you are running mutest-rs. Otherwise, regular Cargo commands will not run. See [the prerequisites](./usage.md#using-cfgmutest) for using `#[cfg(mutest)]`.

## `#[mutest::skip]` { #mutest-skip}

Tells mutest-rs to skip the function when applying mutation operators. Useful for marking helper functions for tests (test cases themselves are automatically skipped), or critical functions.

This attribute can only be applied to function declarations:
```rust,ignore
#[cfg_attr(mutest, mutest::skip)]
fn perform_tests() {
#}
```

## `#[mutest::ignore]` { #mutest-ignore}

Tells mutest-rs to ignore the statement or expression, including any subexpressions, or function parameter, when applying mutation operators. Useful if mutest-rs is trying to apply mutations to a critical piece of code that might be causing problems.

This attribute can be applied to
* statements (note that expression statements might have to be wrapped in `{}`, [see this linked Rust issue](https://github.com/rust-lang/rust/issues/59144)):
  ```rust,ignore
  #[cfg_attr(mutest, mutest::ignore)]
  let buff_len = mem::size_of::<u16>() * 1024;
  ```
* expressions ([wherever the compiler supports attrbiutes on expressions](https://doc.rust-lang.org/reference/expressions.html#expression-attributes)):
  ```rust,ignore
    #fn foo() {
      #[cfg_attr(mutest, mutest::ignore)]
      Some(body)
  }
   ```
* and function parameters:
  ```rust,ignore
  fn foo(&self, #[cfg_attr(mutest, mutest::ignore)] experimental: bool) {
  #}
  ```
