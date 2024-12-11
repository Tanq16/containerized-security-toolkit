FROM ubuntu:jammy AS executable_builder
RUN mkdir /executables && apt update -y && \
    apt install -y wget ninja-build gettext cmake unzip curl git file && \
    mkdir /testingground && cd /testingground && \
    a=$(curl -s https://api.github.com/repos/praetorian-inc/noseyparker/releases/latest | grep -E "browser_download_url.*" | grep -i "linux-gnu" | grep -i "aarch64" | cut -d '"' -f4) && \
    b=$(curl -s https://api.github.com/repos/praetorian-inc/noseyparker/releases/latest | grep -E "browser_download_url.*" | grep -i "linux-gnu" | grep -i "x86_64" | cut -d '"' -f4) && \
    if [ "$(uname -m)" = "aarch64" ]; then wget "$a" -O test.tar.gz; else wget "$b" -O test.tar.gz; fi && \
    tar -xzf test.tar.gz && \
    mv bin/noseyparker /executables && cd .. && rm -rf testingground
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

FROM golang AS go_builder
RUN mkdir /executables
RUN go install github.com/OJ/gobuster/v3@latest && \
    mv /go/bin/gobuster /executables
RUN go install github.com/insidersec/insider/cmd/insider@latest && \
    mv /go/bin/insider /executables
RUN go install github.com/praetorian-inc/fingerprintx/cmd/fingerprintx@latest && \
    mv /go/bin/fingerprintx /executables
RUN go install -v github.com/owasp-amass/amass/v4/...@master && \
    mv /go/bin/amass /executables
RUN go install github.com/lc/gau/v2/cmd/gau@latest && \
    mv /go/bin/gau /executables/getallurls
RUN go install github.com/ffuf/ffuf/v2@latest && \
    mv /go/bin/ffuf /executables
RUN go install github.com/mikefarah/yq/v4@latest && \
    mv /go/bin/yq /executables
RUN go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest && \
    mv /go/bin/grpcurl /executables
RUN go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest && \
    mv /go/bin/subfinder /executables
RUN go install github.com/projectdiscovery/httpx/cmd/httpx@latest && \
    mv /go/bin/httpx /executables
RUN go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest && \
    mv /go/bin/dnsx /executables
RUN go install github.com/projectdiscovery/simplehttpserver/cmd/simplehttpserver@latest && \
    mv /go/bin/simplehttpserver /executables
RUN go install github.com/tomnomnom/gron@latest && \
    mv /go/bin/gron /executables
RUN go install github.com/neilotoole/sq@latest && \
    mv /go/bin/sq /executables
RUN go install github.com/hakluke/hakrawler@latest && \
    mv /go/bin/hakrawler /executables
RUN go install github.com/hakluke/hakrevdns@latest && \
    mv /go/bin/hakrevdns /executables
RUN go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest && \
    mv /go/bin/nuclei /executables

FROM alpine
RUN mkdir /executables/
COPY --from=go_builder /executables/* /executables/
COPY --from=executable_builder /executables/* /executables/
