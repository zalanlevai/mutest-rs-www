# Installation

To install mutest-rs from source, first clone the source code repository at <https://github.com/zalanlevai/mutest-rs>.

```sh
git clone https://github.com/zalanlevai/mutest-rs
```

Then, build the `mutest-runtime` crate in release mode.

```sh
cargo build --release -p mutest-runtime
```

Finally, install `mutest-driver` and the Cargo subcommand `cargo-mutest` locally.

```sh
cargo install --force --path mutest-driver
cargo install --force --path cargo-mutest
```

Please make note of the directory where you checked out mutest-rs. When using mutest-rs, make sure that the `MUTEST_SEARCH_PATH` environment variable is set to point to the `target/release` directory inside. This is to ensure correct linking with the runtime crate. The easiest solution is to add the following to your shell's init script (replacing `<PATH_TO_MUTEST_RS_SRC_REPO>` with a path pointing to your local mutest-rs repository):

```sh
export MUTEST_SEARCH_PATH=<PATH_TO_MUTEST_RS_SRC_REPO>/target/release
```

Currently, the only option to install and use mutest-rs is to compile it yourself.
