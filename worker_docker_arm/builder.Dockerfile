FROM ubuntu AS executable_builder
RUN mkdir /executables && apt update -y && \
    apt install -y wget ninja-build gettext cmake unzip curl git file && \
    wget https://github.com/neovim/neovim/archive/refs/tags/stable.tar.gz && \
    tar -xvf stable.tar.gz && cd neovim-stable && \
    make CMAKE_BUILD_TYPE=RelWithDebInfo && \
    cd build && cpack -G DEB && \
    mv nvim-linux64.deb /
RUN mkdir /testingground && cd /testingground && \
    a=$(curl -s https://api.github.com/repos/mikefarah/yq/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "arm64" | grep -v "tar.gz" | cut -d '"' -f4) && \
    wget "$a" && mv yq_linux_arm64 /executables/yq && cd .. && rm -rf testingground
RUN mkdir /testingground && cd /testingground && \
    a=$(curl -s https://api.github.com/repos/projectdiscovery/httpx/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "arm64" | cut -d '"' -f4) && \
    wget "$a" -O test.zip && unzip test.zip && \
    mv httpx /executables && cd .. && rm -rf testingground
RUN mkdir /testingground && cd /testingground && \
    a=$(curl -s https://api.github.com/repos/projectdiscovery/dnsx/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "arm64" | cut -d '"' -f4) && \
    wget "$a" -O test.zip && unzip test.zip && \
    mv dnsx /executables && cd .. && rm -rf testingground
RUN mkdir /testingground && cd /testingground && \
    a=$(curl -s https://api.github.com/repos/projectdiscovery/aix/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "arm64" | cut -d '"' -f4) && \
    wget "$a" -O test.zip && unzip test.zip && \
    mv aix /executables && cd .. && rm -rf testingground
RUN mkdir /testingground && cd /testingground && \
    a=$(curl -s https://api.github.com/repos/projectdiscovery/simplehttpserver/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "arm64" | cut -d '"' -f4) && \
    wget "$a" -O test.zip && unzip test.zip && \
    mv simplehttpserver /executables && cd .. && rm -rf testingground
RUN mkdir /testingground && cd /testingground && \
    a=$(curl -s https://api.github.com/repos/tomnomnom/gron/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "arm64" | cut -d '"' -f4) && \
    wget "$a" -O test.tar.gz && tar -xzf test.tar.gz && \
    mv gron /executables && cd .. && rm -rf testingground

FROM golang AS go_builder
RUN mkdir /executables
RUN git clone --depth=1 https://github.com/hashicorp/terraform.git && \
    cd terraform && go get && go build && mv terraform /executables

FROM alpine
RUN mkdir /executables/
COPY --from=go_builder /executables/* /executables/
COPY --from=executable_builder /executables/* /executables/
COPY --from=executable_builder /nvim-linux64.deb /neovim-linux64.deb
