FROM golang AS go_builder
RUN mkdir /executables
RUN git clone --depth=1 https://github.com/OJ/gobuster.git && \
    cd gobuster && go get && go build && mv gobuster /executables
RUN git clone --depth=1 https://github.com/insidersec/insider && \
    cd insider/cmd/insider && go get && go build && mv insider /executables
RUN git clone --depth=1 https://github.com/Shopify/kubeaudit && \
    cd kubeaudit/cmd && go get && go build && mv cmd /executables/kubeaudit
RUN git clone --depth=1 https://github.com/praetorian-inc/fingerprintx && \
    cd fingerprintx/cmd/fingerprintx && go get && go build && mv fingerprintx /executables
RUN git clone --depth=1 https://github.com/hashicorp/terraform.git && \
    cd terraform && go get && go build && mv terraform /executables
RUN git clone --depth=1 https://github.com/OWASP/amass.git && \
    cd amass/cmd/amass && go get && go build && mv amass /executables
RUN git clone --depth=1 https://github.com/lc/gau && \
    cd gau/cmd/gau && go get && go build -o getallurls && mv getallurls /executables
RUN git clone --depth=1 https://github.com/iknowjason/edge.git && \
    cd edge && go get && go build edge.go && mv edge /executables
RUN git clone --depth=1 https://github.com/ffuf/ffuf.git && \
    cd ffuf && go get && go build && mv ffuf /executables
RUN git clone --depth=1 https://github.com/mikefarah/yq && \
    cd yq && go get && go build && mv yq /executables

FROM golang AS projectdiscovery_builder
RUN mkdir /executables
RUN apt update && apt install git libpcap-dev -y && \
    git clone --depth=1 https://github.com/projectdiscovery/subfinder && \
    cd subfinder/v2/cmd/subfinder && go get && go build && mv subfinder /executables
RUN git clone --depth=1 https://github.com/projectdiscovery/naabu && \
    cd naabu/v2/cmd/naabu && go get && go build && mv naabu /executables
RUN git clone --depth=1 https://github.com/projectdiscovery/httpx && \
    cd httpx/cmd/httpx && go get && go build && mv httpx /executables
RUN git clone --depth=1 https://github.com/projectdiscovery/dnsx && \
    cd dnsx/cmd/dnsx && go get && go build && mv dnsx /executables
RUN git clone --depth=1 https://github.com/projectdiscovery/mapcidr && \
    cd mapcidr/cmd/mapcidr && go get && go build && mv mapcidr /executables
RUN git clone --depth=1 https://github.com/projectdiscovery/proxify && \
    cd proxify/cmd/proxify && go get && go build && mv proxify /executables
RUN git clone --depth=1 https://github.com/projectdiscovery/nuclei && \
    cd nuclei/v2/cmd/nuclei && go get && go build && mv nuclei /executables
RUN git clone --depth=1 https://github.com/projectdiscovery/cloudlist && \
    cd cloudlist/cmd/cloudlist && go get && go build && mv cloudlist /executables
RUN git clone --depth=1 https://github.com/projectdiscovery/uncover && \
    cd uncover/cmd/uncover && go get && go build && mv uncover /executables
RUN git clone --depth=1 https://github.com/projectdiscovery/katana.git && \
    cd katana/cmd/katana && go get && go build && mv katana /executables
RUN git clone --depth=1 https://github.com/projectdiscovery/aix && \
    cd aix/cmd/aix && go get && go build && mv aix /executables

FROM golang AS other_builder
RUN mkdir /executables
RUN git clone --depth=1 https://github.com/hakluke/hakrawler && \
    cd hakrawler && go get && go build && mv hakrawler /executables
RUN git clone --depth=1 https://github.com/hakluke/hakrevdns && \
    cd hakrevdns && go mod init hakrevdns && go mod tidy && go get && go build && mv hakrevdns /executables
RUN git clone --depth=1 https://github.com/hakluke/haktldextract && \
    cd haktldextract && go get && go build && mv haktldextract /executables
RUN git clone --depth=1 https://github.com/tomnomnom/gron && \
    cd gron && go get && go build && mv gron /executables
RUN git clone --depth=1 https://github.com/tomnomnom/assetfinder && \
    cd assetfinder && go mod init assetfinder && go mod tidy && go get && go build && mv assetfinder /executables
RUN git clone --depth=1 https://github.com/tomnomnom/httprobe && \
    cd httprobe && go get && go build && mv httprobe /executables
RUN git clone --depth=1 https://github.com/BishopFox/cloudfox && \
    cd cloudfox && go get && go build && mv cloudfox /executables

FROM alpine
RUN mkdir /executables/
COPY --from=projectdiscovery_builder /executables/* /executables/
COPY --from=go_builder /executables/* /executables/
COPY --from=other_builder /executables/* /executables/
