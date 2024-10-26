FROM ubuntu:jammy AS executable_builder
RUN mkdir /executables && apt update -y && \
    apt install -y wget ninja-build gettext cmake unzip curl git file && \
    wget https://github.com/neovim/neovim/archive/refs/tags/stable.tar.gz && \
    tar -xvf stable.tar.gz && cd neovim-stable && \
    make CMAKE_BUILD_TYPE=RelWithDebInfo && \
    cd build && cpack -G DEB && \
    mv nvim-linux64.deb /
RUN mkdir /testingground && cd /testingground && \
    a=$(curl -s https://api.github.com/repos/OJ/gobuster/releases/latest | grep "browser_download_url" | grep -i "linux" | grep -i "arm64" | cut -d '"' -f4) && \
    wget "$a" -O test.tar.gz && tar -xzf test.tar.gz && \
    mv gobuster /executables && cd .. && rm -rf testingground
# Insider Sec - Insider - No ARM support
# RUN mkdir /testingground && cd /testingground && \
#     a=$(curl -s https://api.github.com/repos/insidersec/insider/releases/latest | grep "browser_download_url" | grep -i "linux" | grep -i "x86_64" | cut -d '"' -f4) && \
#     wget "$a" -O test.tar.gz && tar -xzf test.tar.gz && \
#     mv insider /executables && cd .. && rm -rf testingground
RUN mkdir /testingground && cd /testingground && \
    a=$(curl -s https://api.github.com/repos/Shopify/kubeaudit/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "arm64" | cut -d '"' -f4) && \
    wget "$a" -O test.tar.gz && tar -xzf test.tar.gz && \
    mv kubeaudit /executables && cd .. && rm -rf testingground
RUN mkdir /testingground && cd /testingground && \
    a=$(curl -s https://api.github.com/repos/praetorian-inc/fingerprintx/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "arm64" | cut -d '"' -f4) && \
    wget "$a" -O test.tar.gz && tar -xzf test.tar.gz && \
    mv fingerprintx /executables && cd .. && rm -rf testingground
RUN mkdir /testingground && cd /testingground && \
    a=$(curl -s https://api.github.com/repos/praetorian-inc/noseyparker/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "aarch64" | cut -d '"' -f4) && \
    wget "$a" -O test.tar.gz && tar -xzf test.tar.gz && \
    mv bin/noseyparker /executables && cd .. && rm -rf testingground
RUN mkdir /testingground && cd /testingground && \
    a=$(curl -s https://api.github.com/repos/owasp-amass/amass/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "arm64" | grep -i "zip" | cut -d '"' -f4) && \
    wget "$a" -O test.zip && unzip test.zip && \
    mv amass*/amass /executables && cd .. && rm -rf testingground
RUN mkdir /testingground && cd /testingground && \
    a=$(curl -s https://api.github.com/repos/lc/gau/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "arm64" | cut -d '"' -f4) && \
    wget "$a" -O test.tar.gz && tar -xzf test.tar.gz && \
    mv gau /executables/getallurls && cd .. && rm -rf testingground
RUN mkdir /testingground && cd /testingground && \
    a=$(curl -s https://api.github.com/repos/iknowjason/edge/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "arm64" | cut -d '"' -f4) && \
    wget "$a" -O test.tar.gz && tar -xzf test.tar.gz && \
    mv edge-arm64 /executables/edge && cd .. && rm -rf testingground
RUN mkdir /testingground && cd /testingground && \
    a=$(curl -s https://api.github.com/repos/ffuf/ffuf/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "arm64" | cut -d '"' -f4) && \
    wget "$a" -O test.tar.gz && tar -xzf test.tar.gz && \
    mv ffuf /executables && cd .. && rm -rf testingground
RUN mkdir /testingground && cd /testingground && \
    a=$(curl -s https://api.github.com/repos/mikefarah/yq/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "arm64" | grep -v "tar.gz" | cut -d '"' -f4) && \
    wget "$a" && mv yq_linux_arm64 /executables/yq && cd .. && rm -rf testingground
RUN mkdir /testingground && cd /testingground && \
    a=$(curl -s https://api.github.com/repos/fullstorydev/grpcurl/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "arm64" | grep "tar.gz" | cut -d '"' -f4) && \
    wget "$a" -O test.tar.gz && tar -xzf test.tar.gz && \
    mv grpcurl /executables && cd .. && rm -rf testingground
RUN mkdir /testingground && cd /testingground && \
    a=$(curl -s https://api.github.com/repos/projectdiscovery/subfinder/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "arm64" | cut -d '"' -f4) && \
    wget "$a" -O test.zip && unzip test.zip && \
    mv subfinder /executables && cd .. && rm -rf testingground
# Project Discovery - Naabu - No ARM support for Linux
# RUN mkdir /testingground && cd /testingground && \
#     a=$(curl -s https://api.github.com/repos/projectdiscovery/naabu/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "arm64" | cut -d '"' -f4) && \
#     wget "$a" -O test.zip && unzip test.zip && \
#     mv naabu /executables && cd .. && rm -rf testingground
RUN mkdir /testingground && cd /testingground && \
    a=$(curl -s https://api.github.com/repos/projectdiscovery/httpx/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "arm64" | cut -d '"' -f4) && \
    wget "$a" -O test.zip && unzip test.zip && \
    mv httpx /executables && cd .. && rm -rf testingground
RUN mkdir /testingground && cd /testingground && \
    a=$(curl -s https://api.github.com/repos/projectdiscovery/dnsx/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "arm64" | cut -d '"' -f4) && \
    wget "$a" -O test.zip && unzip test.zip && \
    mv dnsx /executables && cd .. && rm -rf testingground
RUN mkdir /testingground && cd /testingground && \
    a=$(curl -s https://api.github.com/repos/projectdiscovery/mapcidr/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "arm64" | cut -d '"' -f4) && \
    wget "$a" -O test.zip && unzip test.zip && \
    mv mapcidr /executables && cd .. && rm -rf testingground
RUN mkdir /testingground && cd /testingground && \
    a=$(curl -s https://api.github.com/repos/projectdiscovery/proxify/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "arm64" | cut -d '"' -f4) && \
    wget "$a" -O test.zip && unzip test.zip && \
    mv proxify /executables && cd .. && rm -rf testingground
RUN mkdir /testingground && cd /testingground && \
    a=$(curl -s https://api.github.com/repos/projectdiscovery/nuclei/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "arm64" | cut -d '"' -f4) && \
    wget "$a" -O test.zip && unzip test.zip && \
    mv nuclei /executables && cd .. && rm -rf testingground
RUN mkdir /testingground && cd /testingground && \
    a=$(curl -s https://api.github.com/repos/projectdiscovery/cloudlist/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "arm64" | cut -d '"' -f4) && \
    wget "$a" -O test.zip && unzip test.zip && \
    mv cloudlist /executables && cd .. && rm -rf testingground
RUN mkdir /testingground && cd /testingground && \
    a=$(curl -s https://api.github.com/repos/projectdiscovery/uncover/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "arm64" | cut -d '"' -f4) && \
    wget "$a" -O test.zip && unzip test.zip && \
    mv uncover /executables && cd .. && rm -rf testingground
RUN mkdir /testingground && cd /testingground && \
    a=$(curl -s https://api.github.com/repos/projectdiscovery/katana/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "arm64" | cut -d '"' -f4) && \
    wget "$a" -O test.zip && unzip test.zip && \
    mv katana /executables && cd .. && rm -rf testingground
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
# TomNomNom - HTTProbe - No ARM support
# RUN mkdir /testingground && cd /testingground && \
#     a=$(curl -s https://api.github.com/repos/tomnomnom/httprobe/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "amd64" | cut -d '"' -f4) && \
#     wget "$a" -O test.tar.gz && tar -xzf test.tar.gz && \
#     mv httprobe /executables && cd .. && rm -rf testingground
# BishopFox - CloudFox - No ARM support
# RUN mkdir /testingground && cd /testingground && \
#     a=$(curl -s https://api.github.com/repos/BishopFox/cloudfox/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "amd64" | cut -d '"' -f4) && \
#     wget "$a" -O test.zip && unzip test.zip && \
#     mv cloudfox/cloudfox /executables && cd .. && rm -rf testingground
RUN mkdir /testingground && cd /testingground && \
    a=$(curl -s https://api.github.com/repos/BloodHoundAD/AzureHound/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "arm64" | cut -d '"' -f4 | grep -v ".sha256") && \
    wget "$a" -O test.zip && unzip test.zip && \
    mv azurehound /executables && cd .. && rm -rf testingground
RUN mkdir /testingground && cd /testingground && \
    a=$(curl -s https://api.github.com/repos/aquasecurity/trivy/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "arm64" | grep -i "tar.gz" | grep -vE "sig|pem" | cut -d '"' -f4) && \
    wget "$a" -O test.tar.gz && tar -xzf test.tar.gz && \
    mv trivy /executables && cd .. && rm -rf testingground
RUN mkdir /testingground && cd /testingground && \
    a=$(curl -s https://api.github.com/repos/neilotoole/sq/releases/latest | grep "browser_download_url" | grep -i "linux" | grep -i "arm64.deb" | cut -d '"' -f4) && \
    wget "$a" -O sq.deb && mv sq.deb /

FROM golang AS go_builder
RUN mkdir /executables
RUN git clone --depth=1 https://github.com/hashicorp/terraform.git && \
    cd terraform && go get && go build && mv terraform /executables
RUN git clone --depth=1 https://github.com/hakluke/hakrawler && \
    cd hakrawler && go get && go build && mv hakrawler /executables
RUN git clone --depth=1 https://github.com/hakluke/hakrevdns && \
    cd hakrevdns && go mod init hakrevdns && go mod tidy && go get && go build && mv hakrevdns /executables
RUN git clone --depth=1 https://github.com/hakluke/haktldextract && \
    cd haktldextract && go get && go build && mv haktldextract /executables
RUN git clone --depth=1 https://github.com/tomnomnom/assetfinder && \
    cd assetfinder && go mod init assetfinder && go mod tidy && go get && go build && mv assetfinder /executables

# Projects that did not work for executable builder because of lack of ARM support
RUN git clone --depth=1 https://github.com/insidersec/insider && \
    cd insider/cmd/insider && go get && go build && mv insider /executables
RUN git clone --depth=1 https://github.com/projectdiscovery/naabu && \
    apt update -y && apt install -y libpcap-dev && \
    cd naabu/v2/cmd/naabu && go get && go build && mv naabu /executables
RUN git clone --depth=1 https://github.com/tomnomnom/httprobe && \
    cd httprobe && go get && go build && mv httprobe /executables
RUN git clone --depth=1 https://github.com/BishopFox/cloudfox && \
    cd cloudfox && go get && go build && mv cloudfox /executables

FROM alpine
RUN mkdir /executables/
COPY --from=go_builder /executables/* /executables/
COPY --from=executable_builder /executables/* /executables/
COPY --from=executable_builder /nvim-linux64.deb /neovim-linux64.deb
COPY --from=executable_builder /sq.deb /sq.deb
