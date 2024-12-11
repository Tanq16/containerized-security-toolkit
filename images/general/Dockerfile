FROM intermediate_builder as intermediate_builder
FROM ubuntu:jammy

# ============================================================================================================
# ==================================================================== Environment and APT Installations =====
# ============================================================================================================

RUN DEBIAN_FRONTEND="noninteractive" apt update && \
    DEBIAN_FRONTEND="noninteractive" apt upgrade -y && \
    apt install -y locales && \
    sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
RUN DEBIAN_FRONTEND="noninteractive" apt install -y --no-install-recommends \
    apt-transport-https software-properties-common apt-utils openssl gpg-agent openssh-server openvpn wget git tmux tree
RUN DEBIAN_FRONTEND="noninteractive" apt install -y --no-install-recommends \
    jc jq make ripgrep groff hydra nmap ncat ntp php gcc zip unzip tzdata yarnpkg nodejs npm perl gnupg gnupg2 curl less file
RUN DEBIAN_FRONTEND="noninteractive" apt install -y --no-install-recommends \
    bsdmainutils dnsutils ruby-full xfonts-utils whois p7zip-full python3 python3-dev python3-pip python3-setuptools python3-venv
RUN DEBIAN_FRONTEND="noninteractive" apt install -y --no-install-recommends \
    inetutils-ping inetutils-telnet inetutils-tools inetutils-traceroute inetutils-ftp iproute2
RUN mkdir /opt/executables && python3 -m venv /opt/pyenv && \
    . /opt/pyenv/bin/activate && \
    pip install --upgrade setuptools wheel pip && \
    pip install requests semgrep
RUN git clone --depth 1 https://github.com/junegunn/fzf.git /root/.fzf && \
    /root/.fzf/install --all 1>/dev/null

COPY --from=intermediate_builder /executables /opt/executables
RUN chown -R root:root /opt/executables && chmod 755 /opt/executables/*

# ============================================================================================================
# ========================================================================== Tool Installations Part One =====
# ============================================================================================================

RUN mkdir /opt/lists/ && cd /opt/lists/ && \
    wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/DNS/subdomains-top1million-110000.txt -O subdomains_top_110000.txt && \
    wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Infrastructure/common-router-ips.txt -O common_router_ips.txt && \
    wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Infrastructure/common-http-ports.txt -O common_http_ports.txt && \
    wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/SNMP/snmp.txt -O snmp.txt && \
    wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Variables/secret-keywords.txt -O secret_keywords.txt && \
    wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/directory-list-lowercase-2.3-medium.txt -O directory_brute_medium.txt && \
    wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/oauth-oidc-scopes.txt -O oauth_oidc_scopes.txt && \
    wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/common.txt -O directory_brute_common.txt && \
    wget https://github.com/danielmiessler/SecLists/raw/master/Passwords/Leaked-Databases/rockyou.txt.tar.gz && \
    tar -xzf rockyou.txt.tar.gz && \
    rm rockyou.txt.tar.gz && \
    cd / && \
    a=$(curl -s https://go.dev/dl/ | grep -oE "(/dl/go[\.0-9]{2,7}\.linux-arm64\.tar\.gz)" | head -n 1) && \
    b=$(curl -s https://go.dev/dl/ | grep -oE "(/dl/go[\.0-9]{2,7}\.linux-amd64\.tar\.gz)" | head -n 1) && \
    if [ "$(uname -m)" = "aarch64" ]; then wget "https://golang.org$a"; else wget "https://golang.org$b"; fi && \
    if [ "$(uname -m)" = "aarch64" ]; then c=$(echo $a | cut -d "/" -f3); else c=$(echo $b | cut -d "/" -f3); fi && \
    tar -C /usr/local -xzf "$c" && \
    rm "$c" && \
    awsurla="https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" && \
    awsurlb="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" && \
    if [ "$(uname -m)" = "aarch64" ]; then curl "$awsurla" -o "awscliv2.zip"; else curl "$awsurlb" -o "awscliv2.zip"; fi && \
    unzip awscliv2.zip && \
    aws/install && \
    rm awscliv2.zip && \
    rm -rf aws && \
    mkdir /root/.aws && \
    touch /root/.aws/credentials && \
    touch /root/.aws/config && \
    echo '[default]\naws_access_key_id = \naws_secret_access_key = ' >> /root/.aws/credentials && \
    echo '[default]\nregion = us-east-1' >> /root/.aws/config

# ============================================================================================================
# ========================================================================== Tool Installations Part Two =====
# ============================================================================================================

RUN mkdir /opt/powershell && cd /opt/powershell && \
    if [ "$(uname -m)" = "aarch64" ]; then wget "$a" -O test.tar.gz; else wget "$b" -O test.tar.gz; fi && \
    tar -xzf test.tar.gz && \
    chmod +x /opt/powershell/pwsh && ln -s /opt/powershell/pwsh /usr/bin/pwsh

# ============================================================================================================
# ============================================================================================================
# ============================================================================================================

RUN DEBIAN_FRONTEND="noninteractive" apt autoclean -y && \
    DEBIAN_FRONTEND="noninteractive" apt autoremove -y && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "export PATH=$PATH:/opt/executables" >> /root/.bashrc
