FROM golang AS go_builder
RUN git clone https://github.com/OJ/gobuster.git && \
    cd gobuster && go get && go build
RUN git clone https://github.com/insidersec/insider && \
    cd insider/cmd/insider && go get && go build
RUN git clone https://github.com/s0md3v/Smap && \
    cd Smap/cmd/smap && go get && go build
RUN git clone https://github.com/hahwul/dalfox && \
    cd dalfox && go get && go build
RUN git clone https://github.com/Shopify/kubeaudit && \
    cd kubeaudit/cmd && go get && go build && mv cmd kubeaudit

FROM golang AS projectdiscovery_builder
RUN apt update && apt install git libpcap-dev -y && \
    git clone https://github.com/projectdiscovery/subfinder && \
    cd subfinder/v2/cmd/subfinder && go get && go build
RUN git clone https://github.com/projectdiscovery/naabu && \
    cd naabu/v2/cmd/naabu && go get && go build
RUN git clone https://github.com/projectdiscovery/httpx && \
    cd httpx/cmd/httpx && go get && go build
RUN git clone https://github.com/projectdiscovery/dnsx && \
    cd dnsx/cmd/dnsx && go get && go build
RUN git clone https://github.com/projectdiscovery/mapcidr && \
    cd mapcidr/cmd/mapcidr && go get && go build
RUN git clone https://github.com/projectdiscovery/proxify && \
    cd proxify/cmd/proxify && go get && go build
RUN git clone https://github.com/projectdiscovery/nuclei && \
    cd nuclei/v2/cmd/nuclei && go get && go build
RUN git clone https://github.com/projectdiscovery/cloudlist && \
    cd cloudlist/cmd/cloudlist && go get && go build
RUN git clone https://github.com/projectdiscovery/uncover && \
    cd uncover/cmd/uncover && go get && go build

FROM golang AS terraform_builder
RUN git clone https://github.com/hashicorp/terraform.git && \
    cd terraform && go get && go build

FROM golang AS gron_builder
RUN git clone https://github.com/tomnomnom/gron && \
    cd gron && go get && go build

# ============================================================================================================
# ======================================================================= FINAL IMAGE Post Builder Stage =====
# ============================================================================================================

FROM ubuntu

# ============================================================================================================
# ======================================================================== Environment and Installations =====
# ============================================================================================================

# Set environment variables
ENV RUNNING_IN_DOCKER true
ENV TZ America/Chicago
ENV LANG enUS.utf-8
ENV SHELL /bin/zsh
ENV TERM xterm

# Install packages using APT
RUN DEBIAN_FRONTEND="noninteractive" apt update && \
    DEBIAN_FRONTEND="noninteractive" apt upgrade -y && \
    DEBIAN_FRONTEND="noninteractive" \
    apt install -y --no-install-recommends \
    apt-transport-https openssl gpg-agent openssh-server openvpn git gdb tmux tree gnupg2 ruby-full vim curl bat fd-find p7zip-full make
RUN DEBIAN_FRONTEND="noninteractive" \
    apt install -y --no-install-recommends \
    strace ltrace wget ntp locales hexedit john tshark gcc nasm unzip zip fcrackzip tzdata perl php yarnpkg less file htop ncdu gnupg jq
RUN DEBIAN_FRONTEND="noninteractive" \
    apt install -y --no-install-recommends \
    python3-setuptools python3-pip python3 python3-dev ipython3 iproute2 python3-venv nginx nmap ncat nikto hydra dnsutils binwalk groff
RUN DEBIAN_FRONTEND="noninteractive" \
    apt install -y --no-install-recommends \
    inetutils-ping inetutils-telnet inetutils-tools inetutils-traceroute inetutils-ftp zsh language-pack-en nodejs npm bsdmainutils ripgrep

# ============================================================================================================
# =============================================================================== CLI Productivity Suite =====
# ============================================================================================================

# Install oh my zsh and tmux
RUN curl -L http://install.ohmyz.sh | sh && \
    git clone https://github.com/spaceship-prompt/spaceship-prompt.git "/root/.oh-my-zsh/custom/themes/spaceship-prompt" --depth=1 && \
    ln -s "/root/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme" "/root/.oh-my-zsh/custom/themes/spaceship.zsh-theme" && \
    sed -i "s/robbyrussell/spaceship/" /root/.zshrc && \
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git /root/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
    git clone --depth=1  https://github.com/zsh-users/zsh-syntax-highlighting.git /root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
    sed -i "s/plugins=/plugins=(git zsh-autosuggestions zsh-syntax-highlighting) #/" /root/.zshrc && \
    git clone --depth=1  https://github.com/tmux-plugins/tpm /root/.tmux/plugins/tpm

# Append conf files tmux conf and zsh rc
RUN wget https://raw.githubusercontent.com/Tanq16/cli-productivity-suite/master/tmuxconf && \
    mv tmuxconf /root/.tmux.conf && \
    wget https://raw.githubusercontent.com/Tanq16/cli-productivity-suite/master/add_to_rc && \
    cat add_to_rc >> /root/.zshrc && \
    rm add_to_rc && \
    cp /root/.zshrc temptemp && \
    cat temptemp | grep -vE "^#" | grep -vE "^$" > /root/.zshrc && \
    rm temptemp && \
    echo "export PATH=$PATH:/usr/local/go/bin/:/opt/executables/" >> /root/.zshrc && \
    chsh -s /usr/bin/zsh

# Setup fzf and colored ls (lsd)
RUN git clone --depth 1 https://github.com/junegunn/fzf.git /root/.fzf && \
    /root/.fzf/install --all 1>/dev/null && \
    a=$(curl -L -s https://github.com/Peltoche/lsd/releases/latest | grep -oE "tag.+\"" | cut -d '/' -f2 | grep -vE "^[^0-9]" | cut -d "\"" -f1 | head -n 1) && \
    wget "https://github.com/Peltoche/lsd/releases/download/$a/lsd_""$a""_amd64.deb" && \
    apt install -y "./lsd_""$a""_amd64.deb" && \
    rm "lsd_""$a""_amd64.deb" && \
    cd /root && \
    curl -sLf https://spacevim.org/install.sh | bash && \
    mkdir /root/.SpaceVim.d/

# ============================================================================================================
# ========================================================================== External Tools Installation =====
# ============================================================================================================

# Tool installations

# pwndbg msf edb and select seclists
RUN git clone --depth=1  https://github.com/pwndbg/pwndbg /opt/pwndbg && \
    cd /opt/pwndbg && \
    ./setup.sh && \
    cd / && \
    curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
    chmod 755 msfinstall && \
    ./msfinstall && \
    rm msfinstall && \
    git clone --depth=1  https://github.com/offensive-security/exploitdb.git /opt/exploit-database && \
    ln -sf /opt/exploit-database/searchsploit /usr/local/bin/searchsploit && \
    mkdir /opt/lists/ && cd /opt/lists/ && \
    wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/DNS/subdomains-top1million-110000.txt -O subdomains_top_110000.txt && \
    wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Infrastructure/common-router-ips.txt -O common_router_ips.txt && \
    wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Infrastructure/common-http-ports.txt -O common_http_ports.txt && \
    wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/SNMP/snmp.txt -O snmp.txt && \
    wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Variables/secret-keywords.txt -O secret_keywords.txt && \
    wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/directory-list-lowercase-2.3-big.txt -O directory_brute_big.txt && \
    wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/directory-list-lowercase-2.3-medium.txt -O directory_brute_medium.txt && \
    wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/directory-list-lowercase-2.3-small.txt -O directory_brute_small.txt && \
    wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/oauth-oidc-scopes.txt -O oauth_oidc_scopes.txt && \
    wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/common.txt -O directory_brute_common.txt && \
    wget https://github.com/danielmiessler/SecLists/raw/master/Passwords/Leaked-Databases/rockyou.txt.tar.gz && \
    tar -xzf rockyou.txt.tar.gz && \
    rm rockyou.txt.tar.gz

# install golang semgrep rich aws cliv2 and gcloud
RUN a=$(curl -s https://go.dev/dl/ | grep -oE "(/dl/go[\.0-9]{2,7}\.linux-amd64\.tar\.gz)" | head -n 1) && \
    wget "https://golang.org$a" && \
    b=$(echo $a | cut -d "/" -f3) && \
    tar -C /usr/local -xzf "$b" && \
    rm "$b" && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    aws/install && \
    rm awscliv2.zip && \
    rm -rf aws && \
    python3 -m pip install boto3 rich rich-cli semgrep && \
    mkdir /root/.aws && \
    touch /root/.aws/credentials && \
    touch /root/.aws/config && \
    echo '[default]\naws_access_key_id = \naws_secret_access_key = ' >> /root/.aws/credentials && \
    echo '[default]\nregion = us-east-1' >> /root/.aws/config && \
    cd /root && \
    eval $(curl -sL "https://cloud.google.com/sdk/docs/install" | grep -oE "curl -O https://dl.google.com/dl/cloudsdk/channels/.+\.tar\.gz" | grep x86_64) && \
    tar -xzf $(ls | grep "google.*\.tar\.gz") && \
    rm $(ls | grep "google.*\.tar\.gz") && \
    google-cloud-sdk/install.sh -q

RUN mkdir /opt/executables

COPY --from=go_builder /go/gobuster/gobuster /opt/executables/
COPY --from=go_builder /go/insider/cmd/insider/insider /opt/executables/
COPY --from=go_builder /go/Smap/cmd/smap/smap /opt/executables/
COPY --from=go_builder /go/dalfox/dalfox /opt/executables/
COPY --from=go_builder /go/kubeaudit/cmd/kubeaudit /opt/executables/

COPY --from=projectdiscovery_builder /go/subfinder/v2/cmd/subfinder/subfinder /opt/executables/
COPY --from=projectdiscovery_builder /go/naabu/v2/cmd/naabu/naabu /opt/executables/
COPY --from=projectdiscovery_builder /go/httpx/cmd/httpx/httpx /opt/executables/
COPY --from=projectdiscovery_builder /go/dnsx/cmd/dnsx/dnsx /opt/executables/
COPY --from=projectdiscovery_builder /go/mapcidr/cmd/mapcidr/mapcidr /opt/executables/
COPY --from=projectdiscovery_builder /go/proxify/cmd/proxify/proxify /opt/executables/
COPY --from=projectdiscovery_builder /go/nuclei/v2/cmd/nuclei/nuclei /opt/executables/
COPY --from=projectdiscovery_builder /go/cloudlist/cmd/cloudlist/cloudlist /opt/executables/
COPY --from=projectdiscovery_builder /go/uncover/cmd/uncover/uncover /opt/executables/

COPY --from=terraform_builder /go/terraform/terraform /opt/executables/
COPY --from=gron_builder /go/gron/gron /opt/executables/

# ============================================================================================================
# ====================================================================== Miscellaneous apt Installations =====
# ============================================================================================================

# All other installations go here to benefit from layer caching of other installs

# wpscan trivy testssl and sqlmap
RUN git clone --depth=1 https://github.com/wpscanteam/wpscan.git /opt/wp-scan && \
    cd /opt/wp-scan && \
    gem install wpscan && \
    cd / && \
    rm -rf /opt/wp-scan && \
    a=$(curl -L -s https://github.com/aquasecurity/trivy/releases/latest | grep -oE "tag.+\"" | cut -d '/' -f2 | grep -vE "^[^v]" | cut -d "\"" -f1 | head -n 1) && \
    b=$(echo $a | tr -d "v") && \
    wget "https://github.com/aquasecurity/trivy/releases/download/$a/trivy_""$b""_Linux-64bit.tar.gz" && \
    tar -xzf "trivy_""$b""_Linux-64bit.tar.gz" && \
    mv trivy /opt/executables/ && \
    rm -rf "trivy_""$b""_Linux-64bit.tar.gz" LICENSE README.md contrib && \
    git clone --depth=1 https://github.com/sqlmapproject/sqlmap /opt/sqlmap && \
    cd /opt && \
    git clone --depth 1 https://github.com/drwetter/testssl.sh.git

# ============================================================================================================
# ======================================================================== Cloud Security Specific Tools =====
# ============================================================================================================

# install scoutsuite checkov and kubectl
RUN python3 -m pip install --upgrade setuptools wheel pip && \
    cd /opt && \
    git clone --depth=1 https://github.com/nccgroup/ScoutSuite scoutsuite && \
    cd /opt/scoutsuite && \
    python3 -m venv .scoutsuite_env && \
    . .scoutsuite_env/bin/activate && \
    python3 -m pip install -r requirements.txt && \
    deactivate && \
    cd /opt/executables/ && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    cd /opt && \
    python3 -m venv .checkov_env && \
    . .checkov_env/bin/activate && \
    python3 -m pip install checkov && \
    deactivate

# install cloudsploit and pmapper
RUN cd /opt && \
    git clone --depth=1 https://github.com/aquasecurity/cloudsploit && \
    cd /opt/cloudsploit && \
    npm install && \
    chmod a+x ./index.js && \
    cd /opt && \
    python3 -m venv .pmapper_env && \
    . .pmapper_env/bin/activate && \
    python3 -m pip install pydot graphviz && \
    git clone https://github.com/nccgroup/PMapper.git && \
    cd PMapper && \
    python3 -m pip install .

# ============================================================================================================
# ============================================================================================================
# ============================================================================================================

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Final steps for perfect run
RUN python3 -m pip install --upgrade pip setuptools wheel && \
    DEBIAN_FRONTEND="noninteractive" apt autoclean -y && \
    DEBIAN_FRONTEND="noninteractive" apt autoremove -y && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo 'root:docker' | chpasswd 
COPY ./init.toml .
RUN mv /init.toml /root/.SpaceVim.d/init.toml
