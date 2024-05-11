FROM intermediate_builder as intermediate_builder
FROM ubuntu

# ============================================================================================================
# ==================================================================== Environment and APT Installations =====
# ============================================================================================================

RUN DEBIAN_FRONTEND="noninteractive" apt update && \
    DEBIAN_FRONTEND="noninteractive" apt upgrade -y && \
    apt install -y locales && \
    sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
RUN DEBIAN_FRONTEND="noninteractive" apt install -y --no-install-recommends \
    apt-transport-https software-properties-common apt-utils openssl gpg-agent \
    openssh-server openvpn wget git tmux tree gnupg gnupg2 curl less file zsh
RUN DEBIAN_FRONTEND="noninteractive" apt install -y --no-install-recommends \
    bat fd-find htop jc jq make ugrep ripgrep groff ncat gcc zip unzip tzdata \
    locales language-pack-en bsdmainutils dnsutils ntp xfonts-utils whois
RUN DEBIAN_FRONTEND="noninteractive" apt install -y --no-install-recommends \
    p7zip-full python3 python3-pip python3-setuptools iproute2 python3-venv python3-dev \
    inetutils-ping inetutils-telnet inetutils-tools inetutils-traceroute inetutils-ftp && \
    mkdir /opt/executables && python3 -m venv /opt/pyenv && \
    . /opt/pyenv/bin/activate && pip install --upgrade setuptools wheel pip

COPY --from=intermediate_builder /executables /opt/executables
COPY --from=intermediate_builder /neovim-linux64.deb /neovim-linux64.deb
RUN DEBIAN_FRONTEND="noninteractive" apt install -y --no-install-recommends /neovim-linux64.deb && rm /neovim-linux64.deb
RUN chown -R root:root /opt/executables && chmod 755 /opt/executables/*

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
    wget https://raw.githubusercontent.com/Tanq16/cli-productivity-suite/master/linux.rcfile && \
    cat linux.rcfile >> /root/.zshrc && \
    rm linux.rcfile && \
    cp /root/.zshrc temptemp && \
    cat temptemp | grep -vE "^#" | grep -vE "^$" > /root/.zshrc && \
    rm temptemp && \
    chsh -s /usr/bin/zsh && \
    git clone --depth 1 https://github.com/junegunn/fzf.git /root/.fzf && \
    /root/.fzf/install --all 1>/dev/null && \
    a=$(curl -s https://api.github.com/repos/lsd-rs/lsd/releases/latest | grep -E "browser_download_url.*" | grep -i "linux" | grep -i "x86_64" | grep -i "gnu" | cut -d '"' -f4) && \
    wget "$a" -O test.tar.gz && tar -xzf test.tar.gz && \
    mv lsd-*/lsd /usr/bin/lsd && \
    rm -rf lsd-* test.tar.gz && \
    git clone https://github.com/NvChad/starter /root/.config/nvim && \
    nvim --headless -c 'quitall' && \
    sed -i "s/autoload -Uz bracketed-paste-magic/#autoload -Uz bracketed-paste-magic/" /root/.oh-my-zsh/lib/misc.zsh && \
    sed -i "s/zle -N bracketed-paste bracketed-paste-magic/#zle -N bracketed-paste bracketed-paste-magic/" /root/.oh-my-zsh/lib/misc.zsh && \
    sed -i "s/autoload -Uz url-quote-magic/#autoload -Uz url-quote-magic/" /root/.oh-my-zsh/lib/misc.zsh && \
    sed -i "s/zle -N self-insert url-quote-magic/#zle -N self-insert url-quote-magic/" /root/.oh-my-zsh/lib/misc.zsh && \
    TMUX_PLUGIN_MANAGER_PATH=/root/.tmux/plugins /root/.tmux/plugins/tpm/bin/install_plugins

# ============================================================================================================
# ========================================================================== Tool Installations Part One =====
# ============================================================================================================

RUN cd / && \
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
    mkdir /root/.aws && \
    touch /root/.aws/credentials && \
    touch /root/.aws/config && \
    echo '[default]\naws_access_key_id = \naws_secret_access_key = ' >> /root/.aws/credentials && \
    echo '[default]\nregion = us-east-1' >> /root/.aws/config

# ============================================================================================================
# ========================================================================== Tool Installations Part Two =====
# ============================================================================================================

RUN . /opt/pyenv/bin/activate && \
    pip install boto3 requests

# ============================================================================================================
# ============================================================================================================
# ============================================================================================================

RUN DEBIAN_FRONTEND="noninteractive" apt autoclean -y && \
    DEBIAN_FRONTEND="noninteractive" apt autoremove -y && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
