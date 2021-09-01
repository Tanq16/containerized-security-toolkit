FROM ubuntu

# ============================================================================================================
# ======================================================================== Environment and Installations =====
# ============================================================================================================

# Set environment variables
ENV RUNNING_IN_DOCKER true
ENV SHELL /bin/zsh
ENV TERM xterm
ENV LANG enUS.utf-8

RUN apt update && apt upgrade -y

# Install packages using APT
RUN DEBIAN_FRONTEND="noninteractive" \
    apt install -y \
    build-essential libssl-dev zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libreadline-dev libffi-dev
RUN DEBIAN_FRONTEND="noninteractive" \
    apt install -y \
    apt-transport-https software-properties-common openssl gpg-agent openssh-server openvpn
RUN DEBIAN_FRONTEND="noninteractive" \
    apt install -y \
    nmap ncat gobuster nikto dirb netdiscover hydra less file binwalk p7zip-full
RUN DEBIAN_FRONTEND="noninteractive" \
    apt install -y \
    vim curl strace ltrace bat fd-find wget gdb git tmux tree php ntp sqlmap locales
RUN DEBIAN_FRONTEND="noninteractive" \
    apt install -y \
    default-jre default-jdk john wireshark gcc-multilib nasm unzip fcrackzip ncdu htop
RUN DEBIAN_FRONTEND="noninteractive" \
    apt install -y \
    python3-pkg-resources python3-setuptools python3-pip python3 python3-dev ipython3 iproute2
RUN DEBIAN_FRONTEND="noninteractive" \
    apt install -y \
    inetutils-ping inetutils-telnet inetutils-inetd inetutils-ftpd inetutils-telnetd inetutils-talkd
RUN DEBIAN_FRONTEND="noninteractive" \
    apt install -y \
    inetutils-tools inetutils-syslogd inetutils-talk inetutils-traceroute inetutils-ftp

# ============================================================================================================
# ============================================================================================================
# ============================================================================================================


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ============================================================================================================
# =============================================================================== CLI Productivity Suite =====
# ============================================================================================================

# Install zsh and tmux
RUN apt install -y zsh
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
RUN wget https://raw.githubusercontent.com/Tanq16/cli-productivity-suite/master/add_to_rc 2>/dev/null
RUN cat add_to_rc >> ~/.zshrc
RUN rm add_to_rc
RUN cp ~/.zshrc temptemp
RUN cat temptemp | grep -vE "^#" | grep -vE "^$" > ~/.zshrc
RUN rm temptemp
RUN echo "export PATH=$PATH:/usr/local/go/bin/" >> ~/.zshrc
RUN chsh -s /usr/bin/zsh
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf 2>/dev/null
RUN ~/.fzf/install --all 1>/dev/null 2>/dev/null
RUN echo "[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh" >> ~/.zshrc
RUN wget https://github.com/Peltoche/lsd/releases/download/0.20.1/lsd_0.20.1_amd64.deb
RUN apt install -y ./lsd_0.20.1_amd64.deb && rm lsd_0.20.1_amd64.deb

# Install vim extensions
RUN git clone https://github.com/itchyny/lightline.vim ~/.vim/pack/plugins/start/lightline
RUN git clone https://github.com/jiangmiao/auto-pairs.git ~/auto_pairs_vim
RUN mkdir -p ~/.vim/plugin
RUN cp ~/auto_pairs_vim/plugin/auto-pairs.vim ~/.vim/plugin/
RUN rm -rf ~/auto_pairs_vim
RUN mkdir -p ~/.vim/pack/plugins/start
RUN git clone --depth=1 https://github.com/ervandew/supertab.git ~/.vim/pack/plugins/start/supertab
RUN wget https://raw.githubusercontent.com/dylnmc/novum.vim/master/colors/novum.vim
RUN mkdir -p ~/.vim/colors
RUN mv novum.vim ~/.vim/colors/novum.vim
RUN wget https://raw.githubusercontent.com/Tanq16/cli-productivity-suite/master/.vimrcfile
RUN mv .vimrcfile ~/.vimrc
RUN sleep 2

# ============================================================================================================
# ============================================================================================================
# ============================================================================================================


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ============================================================================================================
# ========================================================================== External Tools Installation =====
# ============================================================================================================

# More tool installations
RUN git clone https://github.com/pwndbg/pwndbg /opt/pwndbg
RUN cd /opt/pwndbg && ./setup.sh

RUN curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall && ./msfinstall
RUN rm msfinstall

RUN git clone https://github.com/rbsec/sslscan.git /opt/sslscan
RUN cd /opt/sslscan && make static

RUN git clone https://github.com/offensive-security/exploitdb.git /opt/exploit-database
RUN ln -sf /opt/exploit-database/searchsploit /usr/local/bin/searchsploit

RUN git clone https://github.com/danielmiessler/SecLists.git /opt/SecLists

RUN wget https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt
RUN mv rockyou.txt /opt/SecLists/rockyou.txt

RUN wget https://golang.org/dl/go1.16.7.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.16.7.linux-amd64.tar.gz && rm go1.16.7.linux-amd64.tar.gz

RUN python3 -m pip install jupyterlab cryptography requests

# ============================================================================================================
# ============================================================================================================
# ============================================================================================================


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ============================================================================================================
# ====================================================================== Miscellaneous apt Installations =====
# ============================================================================================================

# All other installations go here to benefit from layer caching of other installs
RUN DEBIAN_FRONTEND="noninteractive" apt install ruby-full -y
RUN git clone https://github.com/wpscanteam/wpscan.git /opt/wp-scan
RUN cd /opt/wp-scan && gem install wpscan

# ============================================================================================================
# ============================================================================================================
# ============================================================================================================


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# Final steps for perfect run
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
RUN echo 'root:docker' | chpasswd 
COPY ./p10k.zsh .
RUN mv /p10k.zsh ~/.p10k.zsh
