FROM tanq16/tool_docker:main AS tool_builder
FROM ubuntu

# ============================================================================================================
# ======================================================================== Environment and Installations =====
# ============================================================================================================

# Set environment variables
ENV RUNNING_IN_DOCKER true
ENV TZ America/Chicago
ENV LANG enUS.utf-8
ENV SHELL /bin/zsh
ENV TERM xterm-256color

# Install packages using APT
RUN DEBIAN_FRONTEND="noninteractive" apt update && \
    DEBIAN_FRONTEND="noninteractive" apt upgrade -y && \
    apt install -y locales && \
    sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
RUN DEBIAN_FRONTEND="noninteractive" apt install -y --no-install-recommends \
    strace ltrace wget apt-transport-https apt-utils openssl gpg-agent openssh-server make ntp zip unzip tzdata \
    openvpn git tmux tree gnupg2 curl less file zsh bat fd-find htop jc jq nmap ncat ncdu groff whois gnupg
RUN DEBIAN_FRONTEND="noninteractive" apt install -y --no-install-recommends \    
    dnsutils locales language-pack-en bsdmainutils ugrep ripgrep xfonts-utils python3-setuptools python3-pip \
    python3 python3-dev ipython3 iproute2 python3-venv inetutils-ping inetutils-telnet inetutils-tools \
    inetutils-traceroute inetutils-ftp
COPY --from=tool_builder /debs/* /
RUN DEBIAN_FRONTEND="noninteractive" apt install -y --no-install-recommends ./nvim-linux64.deb

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
    echo $a && wget "https://github.com/Peltoche/lsd/releases/download/$a/lsd_""$a""_amd64.deb" && \
    apt install -y "./lsd_""$a""_amd64.deb" && \
    rm "lsd_""$a""_amd64.deb" && \
    # cd /root && \
    # curl -sLf https://spacevim.org/install.sh | bash && \
    # mkdir /root/.SpaceVim.d/ && \
    # wget https://raw.githubusercontent.com/Tanq16/cli-productivity-suite/master/spacevim_config && \
    # mv spacevim_config /root/.SpaceVim.d/init.toml && \
    git clone https://github.com/NvChad/NvChad /root/.config/nvim --depth=1 && \
    # sed -i "s/dofile(vim.g/vim.cmd([[ set guicursor=n:ver25 ]])\nvim.cmd([[ set guicursor= ]])\ndofile(vim.g/" /root/.config/nvim/init.lua && \
    # mkdir /root/.config/nvim/lua/custom && \
    # echo "---@type ChadrcConfig\n local M = {}\n M.ui = {theme = 'nord'}\n return M" > /root/.config/nvim/lua/custom/chadrc.lua && \
    sed -i "s/autoload -Uz bracketed-paste-magic/#autoload -Uz bracketed-paste-magic/" /root/.oh-my-zsh/lib/misc.zsh && \
    sed -i "s/zle -N bracketed-paste bracketed-paste-magic/#zle -N bracketed-paste bracketed-paste-magic/" /root/.oh-my-zsh/lib/misc.zsh && \
    sed -i "s/autoload -Uz url-quote-magic/#autoload -Uz url-quote-magic/" /root/.oh-my-zsh/lib/misc.zsh && \
    sed -i "s/zle -N self-insert url-quote-magic/#zle -N self-insert url-quote-magic/" /root/.oh-my-zsh/lib/misc.zsh && \
    TMUX_PLUGIN_MANAGER_PATH=/root/.tmux/plugins /root/.tmux/plugins/tpm/bin/install_plugins

# ============================================================================================================
# ========================================================================== External Tools Installation =====
# ============================================================================================================

# install kubectl golang and aws cliv2 with python libraries
RUN a=$(curl -s https://go.dev/dl/ | grep -oE "(/dl/go[\.0-9]{2,7}\.linux-amd64\.tar\.gz)" | head -n 1) && \
    echo $a && wget "https://golang.org$a" && \
    b=$(echo $a | cut -d "/" -f3) && \
    echo $b && tar -C /usr/local -xzf "$b" && \
    rm "$b" && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    aws/install && \
    rm awscliv2.zip && \
    rm -rf aws && \
    python3 -m pip install boto3 requests && \
    mkdir /root/.aws && \
    touch /root/.aws/credentials && \
    touch /root/.aws/config && \
    echo '[default]\naws_access_key_id = \naws_secret_access_key = ' >> /root/.aws/credentials && \
    echo '[default]\nregion = us-east-1' >> /root/.aws/config && \
    mkdir /opt/executables && \
    cd /opt/executables/ && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl

COPY --from=tool_builder /executables/* /opt/executables/

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
