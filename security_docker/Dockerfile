FROM gobuilder as gobuilder
FROM otherbuilder as otherbuilder
FROM ubuntu

# ============================================================================================================
# ==================================================================== Environment and APT Installations =====
# ============================================================================================================

ENV RUNNING_IN_DOCKER true
ENV TZ America/Chicago
ENV LANG enUS.utf-8
ENV SHELL /bin/zsh
ENV TERM xterm-256color

RUN DEBIAN_FRONTEND="noninteractive" apt update && \
    DEBIAN_FRONTEND="noninteractive" apt upgrade -y && \
    apt install -y locales && \
    sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
RUN DEBIAN_FRONTEND="noninteractive" apt install -y --no-install-recommends \
    apt-transport-https software-properties-common apt-utils openssl gpg-agent \
    openssh-server openvpn wget git tmux tree gnupg gnupg2 curl less file zsh
RUN DEBIAN_FRONTEND="noninteractive" apt install -y --no-install-recommends \
    bat fd-find htop jc jq make ugrep ripgrep groff hydra nmap ncat ntp php \
    gcc zip unzip tzdata yarnpkg nodejs npm locales language-pack-en perl
RUN DEBIAN_FRONTEND="noninteractive" apt install -y --no-install-recommends \    
    bsdmainutils dnsutils ruby-full xfonts-utils whois p7zip-full python3 \
    python3-dev python3-pip python3-setuptools ipython3 iproute2 python3-venv
RUN DEBIAN_FRONTEND="noninteractive" apt install -y --no-install-recommends \
    inetutils-ping inetutils-telnet inetutils-tools inetutils-traceroute inetutils-ftp && \
    mkdir /opt/executables

COPY --from=gobuilder /executables /opt/executables
COPY --from=otherbuilder /executables/noseyparker /opt/executables/noseyparker
COPY --from=otherbuilder /neovim-linux64.deb /neovim-linux64.deb
RUN DEBIAN_FRONTEND="noninteractive" apt install -y --no-install-recommends /neovim-linux64.deb && rm /neovim-linux64.deb

# ============================================================================================================
# =============================================================================== CLI Productivity Suite =====
# ============================================================================================================

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
    a=$(curl -L -s https://github.com/lsd-rs/lsd/releases/ | grep -oE "tag.+\"" | cut -d '/' -f2 | grep -vE "^[^v]" | cut -d "\"" -f1 | head -n 1) && \
    wget "https://github.com/lsd-rs/lsd/releases/download/$a/lsd-""$a""-x86_64-unknown-linux-gnu.tar.gz" && \
    tar -xvf "lsd-""$a""-x86_64-unknown-linux-gnu.tar.gz" && \
    mv "lsd-""$a""-x86_64-unknown-linux-gnu/lsd" /usr/bin/lsd && \
    rm -rf "lsd-""$a""-x86_64-unknown-linux-gnu.tar.gz" "lsd-""$a""-x86_64-unknown-linux-gnu" && \
    git clone https://github.com/NvChad/NvChad /root/.config/nvim --depth=1 && \
    sed -i "s/local input =/local input = \"N\" --/" /root/.config/nvim/lua/core/bootstrap.lua && \
    sed -i "s/dofile(vim.g/vim.cmd([[ set guicursor= ]])\ndofile(vim.g/" /root/.config/nvim/init.lua && \
    nvim --headless -c 'quitall' && \
    sed -i "s/autoload -Uz bracketed-paste-magic/#autoload -Uz bracketed-paste-magic/" /root/.oh-my-zsh/lib/misc.zsh && \
    sed -i "s/zle -N bracketed-paste bracketed-paste-magic/#zle -N bracketed-paste bracketed-paste-magic/" /root/.oh-my-zsh/lib/misc.zsh && \
    sed -i "s/autoload -Uz url-quote-magic/#autoload -Uz url-quote-magic/" /root/.oh-my-zsh/lib/misc.zsh && \
    sed -i "s/zle -N self-insert url-quote-magic/#zle -N self-insert url-quote-magic/" /root/.oh-my-zsh/lib/misc.zsh && \
    TMUX_PLUGIN_MANAGER_PATH=/root/.tmux/plugins /root/.tmux/plugins/tpm/bin/install_plugins

# ============================================================================================================
# ========================================================================== Tool Installations Part One =====
# ============================================================================================================

RUN mkdir /opt/lists/ && cd /opt/lists/ && \
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
    rm rockyou.txt.tar.gz && \
    cd / && \
    a=$(curl -s https://go.dev/dl/ | grep -oE "(/dl/go[\.0-9]{2,7}\.linux-amd64\.tar\.gz)" | head -n 1) && \
    echo $a && wget "https://golang.org$a" && \
    b=$(echo $a | cut -d "/" -f3) && \
    echo $b && tar -C /usr/local -xzf "$b" && \
    rm "$b" && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    aws/install && \
    rm awscliv2.zip && \
    rm -rf aws && \
    python3 -m pip install boto3 semgrep uploadserver && \
    mkdir /root/.aws && \
    touch /root/.aws/credentials && \
    touch /root/.aws/config && \
    echo '[default]\naws_access_key_id = \naws_secret_access_key = ' >> /root/.aws/credentials && \
    echo '[default]\nregion = us-east-1' >> /root/.aws/config && \
    cd /root && \
    wget $(curl -sL "https://cloud.google.com/sdk/docs/install" | grep -oE "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-.{2,20}-linux-x86_64.tar.gz") && \
    tar -xzf $(ls | grep "google.*\.tar\.gz") && \
    rm $(ls | grep "google.*\.tar\.gz") && \
    google-cloud-sdk/install.sh -q && \
    echo "[ -f /root/google-cloud-sdk/path.zsh.inc ] && source /root/google-cloud-sdk/path.zsh.inc" >> /root/.zshrc && \
    echo "[ -f /root/google-cloud-sdk/completion.zsh.inc ] && source /root/google-cloud-sdk/completion.zsh.inc" >> /root/.zshrc

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash && \
    cd / && \
    curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
    chmod 755 msfinstall && \
    ./msfinstall && \
    rm msfinstall && \
    git clone --depth=1 https://gitlab.com/exploit-database/exploitdb.git /opt/exploit-database && \
    ln -sf /opt/exploit-database/searchsploit /usr/local/bin/searchsploit

# ============================================================================================================
# ========================================================================== Tool Installations Part Two =====
# ============================================================================================================

RUN python3 -m pip install requests checkov prowler scoutsuite principalmapper kube-hunter && \
    sed -i 's/from collections import Mapping, MutableMapping, OrderedDict/from collections.abc import Mapping, MutableMapping\nfrom collections import OrderedDict/g' /usr/local/lib/python3.10/dist-packages/principalmapper/util/case_insensitive_dict.py && \
    a=$(curl -L -s https://github.com/aquasecurity/trivy/releases/latest | grep -oE "tag.+\"" | cut -d '/' -f2 | grep -vE "^[^v]" | cut -d "\"" -f1 | head -n 1) && \
    b=$(echo $a | tr -d "v") && \
    echo $a && echo $b && wget "https://github.com/aquasecurity/trivy/releases/download/$a/trivy_""$b""_Linux-64bit.tar.gz" && \
    tar -xzf "trivy_""$b""_Linux-64bit.tar.gz" && \
    mv trivy /opt/executables/ && \
    rm -rf "trivy_""$b""_Linux-64bit.tar.gz" LICENSE README.md contrib && \
    cd /opt && \
    git clone --depth 1 https://github.com/drwetter/testssl.sh.git

RUN python3 -m pip install --upgrade setuptools wheel pip && \
    cd /opt && \
    cd /opt/executables/ && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    a=$(curl -s https://github.com/PowerShell/PowerShell/releases/ | grep -oE "v.\..\.. " | head -n1 | tr -d " v") && \
    mkdir /opt/powershell && cd /opt/powershell && \
    wget "https://github.com/PowerShell/PowerShell/releases/download/v""$a""/powershell-""$a""-linux-x64.tar.gz" && \
    tar -xzf "powershell-""$a""-linux-x64.tar.gz" && \
    ln -s /opt/powershell/pwsh /usr/bin/pwsh

# ============================================================================================================
# ============================================================================================================
# ============================================================================================================

RUN python3 -m pip install --upgrade pip setuptools wheel && \
    DEBIAN_FRONTEND="noninteractive" apt autoclean -y && \
    DEBIAN_FRONTEND="noninteractive" apt autoremove -y && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    echo '! [ -z "$TMUX" ] && ! [ "$(ps -ocommand= -p $PPID | cut -d" " -f1)" = "script" ] & script -f $HOME/session-$(date +"%d-%b-%y_%H-%M-%S").log' >> /root/.zshrc && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
