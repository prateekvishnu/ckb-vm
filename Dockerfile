# Build Stage
FROM ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake clang curl
RUN curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN ${HOME}/.cargo/bin/rustup default nightly
RUN ${HOME}/.cargo/bin/cargo install -f cargo-fuzz

## Add source code to the build stage.
ADD . /ckb-vm
WORKDIR /ckb-vm

RUN cd fuzz && ${HOME}/.cargo/bin/cargo +nightly fuzz build

# Package Stage
FROM ubuntu:20.04

COPY --from=builder ckb-vm/fuzz/target/x86_64-unknown-linux-gnu/release/asm /




