FROM ubuntu:jammy AS executable_builder
RUN mkdir /executables && apt update -y && \
    apt install -y wget ninja-build gettext cmake unzip curl git file && \
    wget https://github.com/neovim/neovim/archive/refs/tags/stable.tar.gz && \
    tar -xvf stable.tar.gz && cd neovim-stable && \
    make CMAKE_BUILD_TYPE=RelWithDebInfo && \
    cd build && cpack -G DEB && \
    mv nvim-linux64.deb /

RUN mkdir /testingground && cd /testingground && \
    a=$(curl -s https://api.github.com/repos/praetorian-inc/noseyparker/releases/latest | grep -E "browser_download_url.*" | grep -i "linux-gnu" | grep -i "aarch64" | cut -d '"' -f4) && \
    b=$(curl -s https://api.github.com/repos/praetorian-inc/noseyparker/releases/latest | grep -E "browser_download_url.*" | grep -i "linux-gnu" | grep -i "x86_64" | cut -d '"' -f4) && \
    if [ "$(uname -m)" = "aarch64" ]; then wget "$a" -O test.tar.gz; else wget "$b" -O test.tar.gz; fi && \
    tar -xzf test.tar.gz && \
    mv bin/noseyparker /executables && cd .. && rm -rf testingground
RUN mkdir /testingground && cd /testingground && \
    a=$(curl -s https://api.github.com/repos/iknowjason/edge/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "arm64" | cut -d '"' -f4) && \
    b=$(curl -s https://api.github.com/repos/iknowjason/edge/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "x86_64" | cut -d '"' -f4) && \
    if [ "$(uname -m)" = "aarch64" ]; then wget "$a" -O test.tar.gz; else wget "$b" -O test.tar.gz; fi && \
    tar -xzf test.tar.gz && \
    if [ "$(uname -m)" = "aarch64" ]; then mv edge-arm64 /executables/edge; else mv edge-amd64 /executables/edge; fi && \
    cd .. && rm -rf testingground
RUN mkdir /testingground && cd /testingground && \
    a=$(curl -s https://api.github.com/repos/BloodHoundAD/AzureHound/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "arm64" | cut -d '"' -f4 | grep -v ".sha256") && \
    b=$(curl -s https://api.github.com/repos/BloodHoundAD/AzureHound/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "amd64" | cut -d '"' -f4 | grep -v ".sha256") && \
    if [ "$(uname -m)" = "aarch64" ]; then wget "$a" -O test.zip; else wget "$b" -O test.zip; fi && \
    unzip test.zip && \
    mv azurehound /executables && cd .. && rm -rf testingground
RUN mkdir /testingground && cd /testingground && \
    a=$(curl -s https://api.github.com/repos/aquasecurity/trivy/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "arm64" | grep -i "tar.gz" | grep -vE "sig|pem" | cut -d '"' -f4) && \
    b=$(curl -s https://api.github.com/repos/aquasecurity/trivy/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "64bit" | grep -i "tar.gz" | grep -vE "sig|pem" | cut -d '"' -f4) && \
    if [ "$(uname -m)" = "aarch64" ]; then wget "$a" -O test.tar.gz; else wget "$b" -O test.tar.gz; fi && \
    tar -xzf test.tar.gz && \
    mv trivy /executables && cd .. && rm -rf testingground

FROM golang AS go_builder_two
RUN mkdir /executables
RUN go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest && \
    mv /go/bin/nuclei /executables
RUN go install github.com/BishopFox/cloudfox@latest && \
    mv /go/bin/cloudfox /executables
RUN go install github.com/projectdiscovery/cloudlist/cmd/cloudlist@latest && \
    mv /go/bin/cloudlist /executables
RUN git clone --depth=1 https://github.com/hashicorp/terraform.git && \
    cd terraform && go get && go build && mv terraform /executables

FROM alpine
RUN mkdir /executables/
COPY --from=go_builder_two /executables/* /executables/
COPY --from=executable_builder /executables/* /executables/
COPY --from=executable_builder /nvim-linux64.deb /neovim-linux64.deb
