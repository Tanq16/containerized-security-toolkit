FROM ubuntu:20.04

# ============================================================================================================
# ======================================================================== Environment and Installations =====
# ============================================================================================================

# Set environment variables
ENV RUNNING_IN_DOCKER true
ENV TERM xterm
ENV SHELL /bin/zsh

RUN apt update && apt upgrade -y

RUN DEBIAN_FRONTEND="noninteractive" \
    apt install -y --no-install-recommends \
    less openssl openssh-server openvpn vim curl bat fd-find
RUN DEBIAN_FRONTEND="noninteractive" \
    apt install -y --no-install-recommends \
    wget git tmux tree fzf php unzip p7zip-full
RUN DEBIAN_FRONTEND="noninteractive" \
    apt install -y --no-install-recommends \
    python3-setuptools python3-pip python3 ipython3 iproute2

# ============================================================================================================
# ============================================================================================================
# ============================================================================================================


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ============================================================================================================
# ============================================================================ Shell Customization Stuff =====
# ============================================================================================================

# Install zsh and tmux
RUN apt install -y --no-install-recommends zsh
RUN curl -L http://install.ohmyz.sh | sh
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k 2>/dev/null
RUN sed -i "s/robbyrussell/powerlevel10k\/powerlevel10k/" ~/.zshrc
RUN git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions 2>/dev/null
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting 2>/dev/null
RUN sed -i "s/plugins=/plugins=(git zsh-autosuggestions zsh-syntax-highlighting) #/" ~/.zshrc
RUN git clone https://github.com/seebi/dircolors-solarized.git dirco_for_script_color_option 2>/dev/null
RUN cp dirco_for_script_color_option/dircolors.256dark ~/.oh-my-zsh/dircolors.256dark
RUN rm -rf dirco_for_script_color_option/
RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm 2>/dev/null
RUN git clone https://github.com/jimeh/tmux-themepack.git ~/.tmux-themepack
RUN wget https://raw.githubusercontent.com/Tanq16/cli-productivity-suite/master/tmuxconf 2>/dev/null
RUN mv tmuxconf ~/.tmux.conf
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf 2>/dev/null
RUN wget https://raw.githubusercontent.com/Tanq16/cli-productivity-suite/master/add_to_rc 2>/dev/null
RUN cat add_to_rc >> ~/.zshrc
RUN rm add_to_rc
RUN cp ~/.zshrc temptemp
RUN cat temptemp | grep -vE "^#" | grep -vE "^$" > ~/.zshrc
RUN rm temptemp
RUN echo "export PATH=$PATH:/usr/local/go/bin/" >> ~/.zshrc
RUN chsh -s /usr/bin/zsh
RUN echo "[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh" >> ~/.zshrc
RUN wget https://github.com/Peltoche/lsd/releases/download/0.20.1/lsd_0.20.1_amd64.deb
RUN apt install -y ./lsd_0.20.1_amd64.deb && rm lsd_0.20.1_amd64.deb

# ============================================================================================================
# ============================================================================================================
# ============================================================================================================


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ============================================================================================================
# ========================================================================== External Tools Installation =====
# ============================================================================================================

# More tool installations
RUN wget https://golang.org/dl/go1.16.7.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.16.7.linux-amd64.tar.gz && rm go1.16.7.linux-amd64.tar.gz

RUN python3 -m pip install cryptography requests 

# For VS code to run smoothly for golang
RUN /usr/local/go/bin/go get github.com/uudashr/gopkgs/v2/cmd/gopkgs
RUN /usr/local/go/bin/go get github.com/ramya-rao-a/go-outline
RUN /usr/local/go/bin/go get github.com/cweill/gotests/gotests
RUN /usr/local/go/bin/go get github.com/fatih/gomodifytags
RUN /usr/local/go/bin/go get github.com/josharian/impl
RUN /usr/local/go/bin/go get github.com/haya14busa/goplay/cmd/goplay
RUN /usr/local/go/bin/go get honnef.co/go/tools/cmd/staticcheck
RUN /usr/local/go/bin/go get golang.org/x/tools/gopls

# Install of these may change
RUN /usr/local/go/bin/go get github.com/go-delve/delve/cmd/dlv
RUN /usr/local/go/bin/go get github.com/go-delve/delve/cmd/dlv@f95340ae1bf9
# Following is for installing dlv-dap manually, otherwise it takes a ton of time installing from VS code
RUN GOBIN=/tmp/ /usr/local/go/bin/go install github.com/go-delve/delve/cmd/dlv@master
RUN mv /tmp/dlv /root/go/bin/dlv-dap

# ============================================================================================================
# ============================================================================================================
# ============================================================================================================


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# Final steps for perfect run
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
RUN echo 'root:docker' | chpasswd 
COPY ./p10k.zsh .
RUN mv /p10k.zsh ~/.p10k.zsh
