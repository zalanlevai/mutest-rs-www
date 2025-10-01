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

Please ensure that you retain the checked out copy of mutest-rs. This is to ensure correct linking with the runtime crate and related compilation artifacts.

Alternatively, you may consider building `mutest-driver` with the runtime embedding option, which will compile and install a self-contained executable.

```sh
cargo install --force --path mutest-driver --features embed-runtime
```

Currently, the only option to install and use mutest-rs is to compile it yourself.
