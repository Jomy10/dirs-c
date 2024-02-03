# Dirs C

C bindings to the [dirs library](https://github.com/dirs-dev/dirs-rs).

## Download

Libraries and header file can be found in the [releases](https://github.com/Jomy10/dirs-c/releases)

## Building

Requires [rust](https://www.rust-lang.org/tools/install)

```sh
# Build the library: output in target/release
cargo build --release
# Generate header
bash generate_header.sh > dirs.h
```

## License

MIT/Apache-2.0 (see [original library](https://crates.io/crates/dirs))

