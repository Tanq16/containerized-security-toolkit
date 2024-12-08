FROM golang AS go_builder
RUN mkdir /executables
RUN go install github.com/OJ/gobuster/v3@latest && \
    mv /go/bin/gobuster /executables
RUN go install github.com/insidersec/insider/cmd/insider@latest && \
    mv /go/bin/insider /executables
RUN go install github.com/Shopify/kubeaudit/cmd@latest && \
    mv /go/bin/cmd /executables/kubeaudit
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
RUN go install github.com/projectdiscovery/proxify/cmd/proxify@latest && \
    mv /go/bin/proxify /executables
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

FROM alpine
RUN mkdir /executables/
COPY --from=go_builder /executables/* /executables/
