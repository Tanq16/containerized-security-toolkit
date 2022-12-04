FROM golang AS go_builder
RUN mkdir /executables
RUN git clone --depth=1 https://github.com/OJ/gobuster.git && \
    cd gobuster && go get && go build && mv gobuster /executables && \
    cd /go && rm -rf gobuster
RUN git clone --depth=1 https://github.com/insidersec/insider && \
    cd insider/cmd/insider && go get && go build && mv insider /executables && \
    cd /go && rm -rf insider
RUN git clone --depth=1 https://github.com/s0md3v/Smap && \
    cd Smap/cmd/smap && go get && go build && mv smap /executables && \
    cd /go && rm -rf Smap
RUN git clone --depth=1 https://github.com/hahwul/dalfox && \
    cd dalfox && go get && go build && mv dalfox /executables && \
    cd /go && rm -rf dalfox
RUN git clone --depth=1 https://github.com/Shopify/kubeaudit && \
    cd kubeaudit/cmd && go get && go build && mv cmd /executables/kubeaudit && \
    cd /go && rm -rf kubeaudit
RUN git clone --depth=1 https://github.com/praetorian-inc/fingerprintx && \
    cd fingerprintx/cmd/fingerprintx && go get && go build && mv fingerprintx /executables && \
    cd /go && rm -rf fingerprintx
RUN git clone --depth=1 https://github.com/hashicorp/terraform.git && \
    cd terraform && go get && go build && mv terraform /executables && \
    cd /go && rm -rf terraform
RUN git clone --depth=1 https://github.com/OWASP/amass.git && \
    cd amass/cmd/amass && go get && go build && mv amass /executables && \
    cd /go && rm -rf amass
RUN git clone --depth=1 https://github.com/j3ssie/metabigor && \
    cd metabigor && go get && go build && mv metabigor /executables && \
    cd /go && rm -rf metabigor

FROM golang AS projectdiscovery_builder
RUN mkdir /executables
RUN apt update && apt install git libpcap-dev -y && \
    git clone --depth=1 https://github.com/projectdiscovery/subfinder && \
    cd subfinder/v2/cmd/subfinder && go get && go build && mv subfinder /executables && \
    cd /go && rm -rf subfinder
RUN git clone --depth=1 https://github.com/projectdiscovery/naabu && \
    cd naabu/v2/cmd/naabu && go get && go build && mv naabu /executables && \
    cd /go && rm -rf naabu
RUN git clone --depth=1 https://github.com/projectdiscovery/httpx && \
    cd httpx/cmd/httpx && go get && go build && mv httpx /executables && \
    cd /go && rm -rf httpx
RUN git clone --depth=1 https://github.com/projectdiscovery/dnsx && \
    cd dnsx/cmd/dnsx && go get && go build && mv dnsx /executables && \
    cd /go && rm -rf dnsx
RUN git clone --depth=1 https://github.com/projectdiscovery/mapcidr && \
    cd mapcidr/cmd/mapcidr && go get && go build && mv mapcidr /executables && \
    cd /go && rm -rf mapcidr
RUN git clone --depth=1 https://github.com/projectdiscovery/proxify && \
    cd proxify/cmd/proxify && go get && go build && mv proxify /executables && \
    cd /go && rm -rf proxify
RUN git clone --depth=1 https://github.com/projectdiscovery/nuclei && \
    cd nuclei/v2/cmd/nuclei && go get && go build && mv nuclei /executables && \
    cd /go && rm -rf nuclei
RUN git clone --depth=1 https://github.com/projectdiscovery/cloudlist && \
    cd cloudlist/cmd/cloudlist && go get && go build && mv cloudlist /executables && \
    cd /go && rm -rf cloudlist
RUN git clone --depth=1 https://github.com/projectdiscovery/uncover && \
    cd uncover/cmd/uncover && go get && go build && mv uncover /executables && \
    cd /go && rm -rf uncover

FROM golang AS hakluke_builder
RUN mkdir /executables
RUN git clone --depth=1 https://github.com/hakluke/hakrawler && \
    cd hakrawler && go get && go build && mv hakrawler /executables && \
    cd /go && rm -rf hakrawler
RUN git clone --depth=1 https://github.com/hakluke/hakrevdns && \
    cd hakrevdns && go mod init hakrevdns && go mod tidy && go get && go build && mv hakrevdns /executables && \
    cd /go && rm -rf hakrevdns
RUN git clone --depth=1 https://github.com/hakluke/haktldextract && \
    cd haktldextract && go get && go build && mv haktldextract /executables && \
    cd /go && rm -rf haktldextract

FROM golang AS tomnomnom_builder
RUN mkdir /executables
RUN git clone --depth=1 https://github.com/tomnomnom/gron && \
    cd gron && go get && go build && mv gron /executables && \
    cd /go && rm -rf gron
RUN git clone --depth=1 https://github.com/tomnomnom/assetfinder && \
    cd assetfinder && go mod init assetfinder && go mod tidy && go get && go build && mv assetfinder /executables && \
    cd /go && rm -rf assetfinder
RUN git clone --depth=1 https://github.com/tomnomnom/httprobe && \
    cd httprobe && go get && go build && mv httprobe /executables && \
    cd /go && rm -rf httprobe

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
    DEBIAN_FRONTEND="noninteractive" apt install -y --no-install-recommends \
    strace ltrace wget apt-transport-https openssl gpg-agent openssh-server make jc jq \
    openvpn git gdb tmux tree gnupg2 ruby-full vim curl less file zsh bat fd-find htop
RUN DEBIAN_FRONTEND="noninteractive" apt install -y --no-install-recommends \    
    ntp gcc zip unzip perl php tzdata yarnpkg gnupg nginx nmap ncat nikto hydra ncdu jc \
    dnsutils nodejs npm locales language-pack-en bsdmainutils whois ugrep ripgrep groff
RUN DEBIAN_FRONTEND="noninteractive" apt install -y --no-install-recommends \
    python3-setuptools python3-pip python3 python3-dev ipython3 iproute2 python3-venv \
    inetutils-ping inetutils-telnet inetutils-tools inetutils-traceroute inetutils-ftp
RUN DEBIAN_FRONTEND="noninteractive" apt install -y --no-install-recommends \
    p7zip-full hexedit john fcrackzip binwalk

# ============================================================================================================
# =============================================================================== CLI Productivity Suite =====
# ============================================================================================================

# Install oh my zsh and tmux; Append conf files tmux conf and zsh rc; Setup fzf and colored ls (lsd)
RUN curl -L http://install.ohmyz.sh | sh && \
    git clone https://github.com/spaceship-prompt/spaceship-prompt.git "/root/.oh-my-zsh/custom/themes/spaceship-prompt" --depth=1 && \
    ln -s "/root/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme" "/root/.oh-my-zsh/custom/themes/spaceship.zsh-theme" && \
    sed -i "s/robbyrussell/spaceship/" /root/.zshrc && \
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git /root/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
    git clone --depth=1  https://github.com/zsh-users/zsh-syntax-highlighting.git /root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
    sed -i "s/plugins=/plugins=(git zsh-autosuggestions zsh-syntax-highlighting) #/" /root/.zshrc && \
    git clone --depth=1  https://github.com/tmux-plugins/tpm /root/.tmux/plugins/tpm && \
    wget https://raw.githubusercontent.com/Tanq16/cli-productivity-suite/master/tmuxconf && \
    mv tmuxconf /root/.tmux.conf && \
    wget https://raw.githubusercontent.com/Tanq16/cli-productivity-suite/master/add_to_rc && \
    cat add_to_rc >> /root/.zshrc && \
    rm add_to_rc && \
    cp /root/.zshrc temptemp && \
    cat temptemp | grep -vE "^#" | grep -vE "^$" > /root/.zshrc && \
    rm temptemp && \
    echo "export PATH=$PATH:/usr/local/go/bin/:/opt/executables/" >> /root/.zshrc && \
    chsh -s /usr/bin/zsh && \
    git clone --depth 1 https://github.com/junegunn/fzf.git /root/.fzf && \
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
RUN git clone --depth=1 https://github.com/pwndbg/pwndbg /opt/pwndbg && \
    cd /opt/pwndbg && \
    ./setup.sh && \
    cd / && \
    curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
    chmod 755 msfinstall && \
    ./msfinstall && \
    rm msfinstall && \
    git clone --depth=1 https://gitlab.com/exploit-database/exploitdb.git /opt/exploit-database && \
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

# install golang semgrep rich aws cliv2 and gcloud; create executables
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
    google-cloud-sdk/install.sh -q && \
    echo "[ -f /root/google-cloud-sdk/path.zsh.inc ] && source /root/google-cloud-sdk/path.zsh.inc" >> /root/.zshrc && \
    echo "[ -f /root/google-cloud-sdk/completion.zsh.inc ] && source /root/google-cloud-sdk/completion.zsh.inc" >> /root/.zshrc

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash && \
    mkdir /opt/executables

COPY --from=go_builder /executables/gobuster /opt/executables/
COPY --from=go_builder /executables/insider /opt/executables/
COPY --from=go_builder /executables/smap /opt/executables/
COPY --from=go_builder /executables/dalfox /opt/executables/
COPY --from=go_builder /executables/kubeaudit /opt/executables/
COPY --from=go_builder /executables/fingerprintx /opt/executables/
COPY --from=go_builder /executables/terraform /opt/executables/
COPY --from=go_builder /executables/metabigor /opt/executables/
COPY --from=go_builder /executables/amass /opt/executables/

COPY --from=projectdiscovery_builder /executables/subfinder /opt/executables/
COPY --from=projectdiscovery_builder /executables/naabu /opt/executables/
COPY --from=projectdiscovery_builder /executables/httpx /opt/executables/
COPY --from=projectdiscovery_builder /executables/dnsx /opt/executables/
COPY --from=projectdiscovery_builder /executables/mapcidr /opt/executables/
COPY --from=projectdiscovery_builder /executables/proxify /opt/executables/
COPY --from=projectdiscovery_builder /executables/nuclei /opt/executables/
COPY --from=projectdiscovery_builder /executables/cloudlist /opt/executables/
COPY --from=projectdiscovery_builder /executables/uncover /opt/executables/

COPY --from=hakluke_builder /executables/hakrawler /opt/executables/
COPY --from=hakluke_builder /executables/hakrevdns /opt/executables/
COPY --from=hakluke_builder /executables/haktldextract /opt/executables/

COPY --from=tomnomnom_builder /executables/gron /opt/executables/
COPY --from=tomnomnom_builder /executables/httprobe /opt/executables/
COPY --from=tomnomnom_builder /executables/assetfinder /opt/executables/

# ============================================================================================================
# ===================================================================== Miscellaneous Tool Installations =====
# ============================================================================================================

# All other installations go here to benefit from layer caching of other installs

# install requests trivy testssl and sqlmap
RUN python3 -m pip install requests && \
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

# install scoutsuite cloudenum kubectl and cloudsploit
RUN python3 -m pip install --upgrade setuptools wheel pip && \
    cd /opt && \
    git clone --depth=1 https://github.com/nccgroup/ScoutSuite scoutsuite && \
    git clone --depth=1 https://github.com/initstring/cloud_enum && \
    python3 -m venv cloudenumvenv && \
    . cloudenumvenv/bin/activate && \
    cd cloud_enum && \
    python3 -m pip install -r requirements.txt && \
    deactivate && \
    cd /opt/executables/ && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    cd /opt && \
    git clone --depth=1 https://github.com/aquasecurity/cloudsploit && \
    cd /opt/cloudsploit && \
    npm install && \
    chmod a+x ./index.js

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
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
COPY ./init.toml .
RUN mv /init.toml /root/.SpaceVim.d/init.toml
