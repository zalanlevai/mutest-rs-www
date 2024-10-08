# Usage

To run mutest-rs on any Cargo package, use the `cargo mutest run` subcommand with the usual Cargo targeting options (see [Cargo Package Selection](https://doc.rust-lang.org/cargo/commands/cargo-test.html#package-selection), [Cargo Target Selection](https://doc.rust-lang.org/cargo/commands/cargo-test.html#target-selection), and [Cargo Feature Selection](https://doc.rust-lang.org/cargo/commands/cargo-test.html#feature-selection)):

```sh
cargo mutest -p example-package --lib run
```

> **NOTE**: Currently, running the tool requires manually specifying the `MUTEST_SEARCH_PATH` environment variable to point to the local mutest-rs build artifacts (see [Installation](./installation.md)).

## Prerequisites

The main `cargo mutest` subcommand provides a Cargo-compatible interface to mutest-rs for Cargo packages and workspaces. Generally speaking, as long as `cargo test` works for your package, then `cargo mutest run` will run the same test suite under mutation analysis.

### Using `cfg(mutest)`

When running `cargo mutest`, the `mutest` cfg is set. This can be used to detect if code is running under mutest-rs, and enable conditional compilation based on it.

Starting with Rust 1.80, cfgs are checked against a known set of config names and values. If your Cargo package is checked with a regular Cargo command, it will warn you about the "unexpected" `mutest` cfg. To [let rustc know that this custom cfg is expected](https://blog.rust-lang.org/2024/05/06/check-cfg.html#expecting-custom-cfgs), ensure that `cfg(mutest)` is present in the `[lints.rust.unexpected_cfgs.check-cfg]` array in the package's `Cargo.toml`, like so:

```toml
[lints.rust]
unexpected_cfgs = { level = "warn", check-cfg = ["cfg(mutest)"] }
```

### mutest-rs and Integration Tests { #integration-tests }

Currently, mutest-rs does not support mutating integration tests (i.e. tests in a separate `tests/` directory), and is unlikely to support mutating program code while evaluating an integration test. This is because `rustc`, and by extension `cargo test`, operates on a [per-crate basis](https://doc.rust-lang.org/book/ch11-03-test-organization.html#integration-tests), meaning that all compilation and analysis is done separately for integration test cases.

If you would like to incorporate integration tests into the mutation analysis, then you have to integrate them into the program crate. This is not too difficult to do in most cases. By moving the tests from the `tests/` directory into a new `src/tests/` directory, and creating a new `src/tests.rs` module listing the test files, you can include the following lines in your `src/lib.rs` to retain similar functionality to before:

```rust,ignore
#[cfg(test)]
mod tests;
```

You may also have to add the following line to each of the moved integration test modules, or resolve path changes manually:

```rust,ignore
use crate as <crate_name>;
```

However, this workaround is admittedly not great.
