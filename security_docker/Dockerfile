FROM ubuntu AS builder
RUN apt update && apt upgrade -y && \
    apt install build-essential git zlib1g-dev openssl -y && \
    git clone https://github.com/rbsec/sslscan && cd sslscan && make static

FROM golang AS go_builder
RUN git clone https://github.com/OJ/gobuster.git && \
    cd gobuster && go get && go build
RUN git clone https://github.com/insidersec/insider && \
    cd insider/cmd/insider && go get && go build
RUN git clone https://github.com/s0md3v/Smap && \
    cd Smap/cmd/smap && go get && go build
RUN git clone https://github.com/hahwul/dalfox && \
    cd dalfox/ && go get && go build

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
    apt-transport-https openssl gpg-agent openssh-server openvpn git gdb tmux tree gnupg2 ruby-full vim curl bat fd-find p7zip-full
RUN DEBIAN_FRONTEND="noninteractive" \
    apt install -y --no-install-recommends \
    strace ltrace wget ntp locales hexedit john tshark gcc nasm unzip zip fcrackzip tzdata perl php yarnpkg less file htop ncdu gnupg
RUN DEBIAN_FRONTEND="noninteractive" \
    apt install -y --no-install-recommends \
    python3-setuptools python3-pip python3 python3-dev ipython3 iproute2 python3-venv make nginx nmap ncat nikto hydra dnsutils jq
RUN DEBIAN_FRONTEND="noninteractive" \
    apt install -y --no-install-recommends \
    inetutils-ping inetutils-telnet inetutils-tools inetutils-traceroute inetutils-ftp zsh language-pack-en nodejs npm binwalk groff

# ============================================================================================================
# =============================================================================== CLI Productivity Suite =====
# ============================================================================================================

# Install oh my zsh and tmux
RUN curl -L http://install.ohmyz.sh | sh && \
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k 2>/dev/null && \
    sed -i "s/robbyrussell/powerlevel10k\/powerlevel10k/" ~/.zshrc && \
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions 2>/dev/null && \
    git clone --depth=1  https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting 2>/dev/null && \
    sed -i "s/plugins=/plugins=(git zsh-autosuggestions zsh-syntax-highlighting) #/" ~/.zshrc && \
    git clone --depth=1  https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm 2>/dev/null && \
    git clone --depth=1  https://github.com/jimeh/tmux-themepack.git ~/.tmux-themepack

# Append conf files tmux conf and zsh rc
RUN wget https://raw.githubusercontent.com/Tanq16/cli-productivity-suite/master/tmuxconf 2>/dev/null && \
    mv tmuxconf ~/.tmux.conf && \
    wget https://raw.githubusercontent.com/Tanq16/cli-productivity-suite/master/add_to_rc 2>/dev/null && \
    cat add_to_rc >> ~/.zshrc && \
    rm add_to_rc && \
    cp ~/.zshrc temptemp && \
    cat temptemp | grep -vE "^#" | grep -vE "^$" > ~/.zshrc && \
    rm temptemp && \
    echo "export PATH=$PATH:/usr/local/go/bin/" >> ~/.zshrc && \
    chsh -s /usr/bin/zsh

# Setup fzf and colored ls (lsd)
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf 2>/dev/null && \
    ~/.fzf/install --all 1>/dev/null 2>/dev/null && \
    echo "[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh" >> ~/.zshrc && \
    a=$(curl -L -s https://github.com/Peltoche/lsd/releases/latest | grep -oE "tag.+\"" | cut -d '/' -f2 | cut -d "\"" -f1 | head -n 1) && \
    wget "https://github.com/Peltoche/lsd/releases/download/$a/lsd_""$a""_amd64.deb" && \
    apt install -y "./lsd_""$a""_amd64.deb" && \
    rm "lsd_""$a""_amd64.deb"

# Install vim extensions
RUN git clone --depth=1  https://github.com/itchyny/lightline.vim ~/.vim/pack/plugins/start/lightline && \
    git clone --depth=1  https://github.com/jiangmiao/auto-pairs.git ~/auto_pairs_vim && \
    mkdir -p ~/.vim/plugin && \
    cp ~/auto_pairs_vim/plugin/auto-pairs.vim ~/.vim/plugin/ && \
    rm -rf ~/auto_pairs_vim && \
    mkdir -p ~/.vim/pack/plugins/start && \
    git clone --depth=1 https://github.com/ervandew/supertab.git ~/.vim/pack/plugins/start/supertab && \
    wget https://raw.githubusercontent.com/dylnmc/novum.vim/master/colors/novum.vim && \
    mkdir -p ~/.vim/colors && \
    mv novum.vim ~/.vim/colors/novum.vim && \
    wget https://raw.githubusercontent.com/Tanq16/cli-productivity-suite/master/.vimrcfile && \
    mv .vimrcfile ~/.vimrc

# ============================================================================================================
# ========================================================================== External Tools Installation =====
# ============================================================================================================

# More tool installations

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

# install golang and aws cliv2
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
    python3 -m pip install boto3

COPY --from=builder /sslscan/sslscan /opt/
COPY --from=go_builder /go/gobuster/gobuster /opt/
COPY --from=go_builder /go/insider/cmd/insider/insider /opt/
COPY --from=go_builder /go/Smap/cmd/smap/smap /opt/
COPY --from=go_builder /go/dalfox/dalfox /opt/

COPY --from=projectdiscovery_builder /go/subfinder/v2/cmd/subfinder/subfinder /opt/
COPY --from=projectdiscovery_builder /go/naabu/v2/cmd/naabu/naabu /opt/
COPY --from=projectdiscovery_builder /go/httpx/cmd/httpx/httpx /opt/
COPY --from=projectdiscovery_builder /go/dnsx/cmd/dnsx/dnsx /opt/
COPY --from=projectdiscovery_builder /go/mapcidr/cmd/mapcidr/mapcidr /opt/
COPY --from=projectdiscovery_builder /go/proxify/cmd/proxify/proxify /opt/
COPY --from=projectdiscovery_builder /go/nuclei/v2/cmd/nuclei/nuclei /opt/

# ============================================================================================================
# ====================================================================== Miscellaneous apt Installations =====
# ============================================================================================================

# All other installations go here to benefit from layer caching of other installs

# wpscan trivy and sqlmap
RUN git clone --depth=1 https://github.com/wpscanteam/wpscan.git /opt/wp-scan && \
    cd /opt/wp-scan && \
    gem install wpscan && \
    cd / && \
    rm -rf /opt/wp-scan && \
    a=$(curl -L -s https://github.com/aquasecurity/trivy/releases/latest | grep -oE "tag.+\"" | cut -d '/' -f2 | cut -d "\"" -f1 | head -n 1) && \
    b=$(echo $a | tr -d "v") && \
    wget "https://github.com/aquasecurity/trivy/releases/download/$a/trivy_""$b""_Linux-64bit.tar.gz" && \
    tar -xzf "trivy_""$b""_Linux-64bit.tar.gz" && \
    mv trivy /opt && \
    rm "trivy_""$b""_Linux-64bit.tar.gz" && \
    git clone --depth=1 https://github.com/sqlmapproject/sqlmap /opt/sqlmap

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
COPY ./p10k.zsh .
RUN mv /p10k.zsh ~/.p10k.zsh
