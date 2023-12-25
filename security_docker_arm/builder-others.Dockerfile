FROM rust AS noseyparker_builder
RUN mkdir /executables && \
    apt update -y && apt install -y cmake ninja-build git
RUN git clone --depth=1 https://github.com/praetorian-inc/noseyparker && \
    cd noseyparker && cargo build --release && mv target/release/noseyparker-cli /executables/noseyparker

FROM ubuntu AS nvim_builder
RUN apt update -y && \
    apt install -y wget ninja-build gettext cmake unzip curl git file && \
    wget https://github.com/neovim/neovim/archive/refs/tags/stable.tar.gz && \
    tar -xvf stable.tar.gz && \
    cd neovim-stable && make CMAKE_BUILD_TYPE=RelWithDebInfo && \
    cd build && cpack -G DEB
RUN mv neovim-stable/build/nvim-linux64.deb /

FROM alpine
RUN mkdir /executables/
COPY --from=nvim_builder /nvim-linux64.deb /neovim-linux64.deb
COPY --from=noseyparker_builder /executables/noseyparker /executables/noseyparker
