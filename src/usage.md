# Usage

To run mutest-rs on any Cargo package or workspace, use the `cargo mutest run` subcommand with the usual Cargo targeting options (see [Cargo Package Selection](https://doc.rust-lang.org/cargo/commands/cargo-test.html#package-selection), [Cargo Target Selection](https://doc.rust-lang.org/cargo/commands/cargo-test.html#target-selection), and [Cargo Feature Selection](https://doc.rust-lang.org/cargo/commands/cargo-test.html#feature-selection)):

```sh
cargo mutest -p example-package run
```

It is recommended to specify specific Cargo test targets to start with, using the standard `--lib`, `--bin <BIN>`, `--test <TEST>`, and `--example <EXAMPLE>` targeting options, alongside the `-p <PACKAGE>` option.

## Prerequisites

The main `cargo mutest` subcommand provides a Cargo-compatible interface to mutest-rs for Cargo packages and workspaces. Generally speaking, as long as `cargo test` works for your package, then `cargo mutest run` will run the same test suite under mutation analysis.

### Using `cfg(mutest)`

When running `cargo mutest`, the `mutest` cfg is set. This can be used to detect if code is running under mutest-rs, and enable conditional compilation based on it.

Starting with Rust 1.80, cfgs are checked against a known set of config names and values. If your Cargo package is checked with a regular Cargo command, it will warn you about the "unexpected" `mutest` cfg. To [let rustc know that this custom cfg is expected](https://blog.rust-lang.org/2024/05/06/check-cfg.html#expecting-custom-cfgs), ensure that `cfg(mutest)` is present in the `[lints.rust.unexpected_cfgs.check-cfg]` array in the package's `Cargo.toml`, like so:

```toml
[lints.rust]
unexpected_cfgs = { level = "warn", check-cfg = ["cfg(mutest)"] }
```
