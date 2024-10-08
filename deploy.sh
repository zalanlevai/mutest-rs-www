#!/bin/bash

# Install the latest mdbook from source with only the required features for deployment.
cargo install mdbook --no-default-features --features search --vers "^0.4" --locked

# Build mdbook book.
mdbook build
