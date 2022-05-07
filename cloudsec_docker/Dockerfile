FROM golang AS go_builder
RUN git clone https://github.com/hashicorp/terraform.git && \
    cd terraform && go get && go build

# Space for Multi-Stage Builds

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

RUN DEBIAN_FRONTEND="noninteractive" apt update && \
    DEBIAN_FRONTEND="noninteractive" apt upgrade -y && \
    DEBIAN_FRONTEND="noninteractive" apt install -y --no-install-recommends \
    less openssl openssh-server openvpn vim curl bat fd-find nodejs npm zsh wget git tmux tree php unzip zip \
    jq p7zip-full ncdu htop tzdata gcc php nginx python3-setuptools python3-pip python3 ipython3 iproute2 \
    python3-venv python3-dev language-pack-en file

# ============================================================================================================
# =============================================================================== CLI Productivity Suite =====
# ============================================================================================================

# Install oh my zsh and tmux
RUN curl -L http://install.ohmyz.sh | sh && \
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k && \
    sed -i "s/robbyrussell/powerlevel10k\/powerlevel10k/" ~/.zshrc && \
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
    git clone --depth=1  https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
    sed -i "s/plugins=/plugins=(git zsh-autosuggestions zsh-syntax-highlighting) #/" ~/.zshrc && \
    git clone --depth=1  https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && \
    git clone --depth=1  https://github.com/jimeh/tmux-themepack.git ~/.tmux-themepack

# Append conf files tmux conf and zsh rc
RUN wget https://raw.githubusercontent.com/Tanq16/cli-productivity-suite/master/tmuxconf && \
    mv tmuxconf ~/.tmux.conf && \
    wget https://raw.githubusercontent.com/Tanq16/cli-productivity-suite/master/add_to_rc && \
    cat add_to_rc >> ~/.zshrc && \
    rm add_to_rc && \
    cp ~/.zshrc temptemp && \
    cat temptemp | grep -vE "^#" | grep -vE "^$" > ~/.zshrc && \
    rm temptemp && \
    echo "export PATH=$PATH:/usr/local/go/bin/" >> ~/.zshrc && \
    chsh -s /usr/bin/zsh

# Setup fzf and colored ls (lsd)
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
    ~/.fzf/install --all 1>/dev/null && \
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

# install aws cli v2 rich and make base aws config
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    aws/install && \
    rm awscliv2.zip && \
    rm -rf aws && \
    python3 -m pip install boto3 rich rich-cli && \
    mkdir ~/.aws && \
    touch ~/.aws/credentials && \
    touch ~/.aws/config && \
    echo '[default]\naws_access_key_id = \naws_secret_access_key = ' >> ~/.aws/credentials && \
    echo '[default]\nregion = us-east-1' >> ~/.aws/config

# install scoutsuite trivy and kubectl
RUN a=$(curl -L -s https://github.com/aquasecurity/trivy/releases/latest | grep -oE "tag.+\"" | cut -d '/' -f2 | cut -d "\"" -f1 | head -n 1) && \
    b=$(echo $a | tr -d "v") && \
    wget "https://github.com/aquasecurity/trivy/releases/download/$a/trivy_""$b""_Linux-64bit.tar.gz" && \
    tar -xzf "trivy_""$b""_Linux-64bit.tar.gz" && \
    mv trivy /opt && \
    rm -rf "trivy_""$b""_Linux-64bit.tar.gz" LICENSE README.md contrib && \
    python3 -m pip install --upgrade setuptools wheel pip && \
    cd /opt && \
    git clone --depth=1 https://github.com/nccgroup/ScoutSuite scoutsuite && \
    cd /opt/scoutsuite && \
    python3 -m venv .scoutsuite_env && \
    . .scoutsuite_env/bin/activate && \
    python3 -m pip install -r requirements.txt && \
    cd /opt && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"


# install cloudsploit and pmapper
RUN cd /opt && \
    git clone --depth=1 https://github.com/aquasecurity/cloudsploit && \
    cd /opt/cloudsploit && \
    npm install && \
    chmod a+x ./index.js && \
    cd /opt && \
    python3 -m venv .pmapper_venv && \
    . .pmapper_venv/bin/activate && \
    python3 -m pip install pydot graphviz && \
    git clone https://github.com/nccgroup/PMapper.git && \
    cd PMapper && \
    python3 -m pip install .

COPY --from=go_builder /go/terraform/terraform /opt/

# ============================================================================================================
# ====================================================================== Miscellaneous apt Installations =====
# ============================================================================================================

# Other installations go here to benefit from layer caching if something needs to be added later on.

# ============================================================================================================
# ============================================================================================================
# ============================================================================================================

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Final steps for perfect run
RUN DEBIAN_FRONTEND="noninteractive" apt autoclean -y && \
    DEBIAN_FRONTEND="noninteractive" apt autoremove -y && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo 'root:docker' | chpasswd
COPY ./p10k.zsh .
RUN mv /p10k.zsh ~/.p10k.zsh