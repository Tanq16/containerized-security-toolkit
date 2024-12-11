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
    apt-transport-https apt-utils openssl gpg-agent openssh-server openvpn wget git tmux tree vim gnupg gnupg2
RUN DEBIAN_FRONTEND="noninteractive" apt install -y --no-install-recommends \
    jc jq make ripgrep groff nmap ncat ntp php gcc zip unzip tzdata yarnpkg nodejs npm curl less file
RUN DEBIAN_FRONTEND="noninteractive" apt install -y --no-install-recommends \
    bsdmainutils dnsutils xfonts-utils whois p7zip-full python3 python3-dev python3-pip python3-setuptools python3-venv
RUN DEBIAN_FRONTEND="noninteractive" apt install -y --no-install-recommends \
    inetutils-ping inetutils-telnet inetutils-tools inetutils-traceroute inetutils-ftp iproute2
RUN mkdir /opt/executables && python3 -m venv /opt/pyenv && \
    . /opt/pyenv/bin/activate && \
    pip install --upgrade setuptools wheel pip
RUN git clone --depth 1 https://github.com/junegunn/fzf.git /root/.fzf && \
    /root/.fzf/install --all 1>/dev/null

COPY --from=intermediate_builder /executables /opt/executables
RUN chown -R root:root /opt/executables && chmod 755 /opt/executables/*

# ============================================================================================================
# ========================================================================== Tool Installations Part One =====
# ============================================================================================================

RUN a=$(curl -s https://go.dev/dl/ | grep -oE "(/dl/go[\.0-9]{2,7}\.linux-arm64\.tar\.gz)" | head -n 1) && \
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
    echo '[default]\nregion = us-east-1' >> /root/.aws/config && \
    cd /root && \
    gcurla="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-arm.tar.gz" && \
    gcurlb="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz" && \
    if [ "$(uname -m)" = "aarch64" ]; then wget "$gcurla"; else wget "$gcurlb"; fi && \
    tar -xzf $(ls | grep "google.*\.tar\.gz") && \
    rm $(ls | grep "google.*\.tar\.gz") && \
    google-cloud-sdk/install.sh -q && \
    echo "[ -f /root/google-cloud-sdk/path.zsh.inc ] && source /root/google-cloud-sdk/path.zsh.inc" >> /root/.zshrc && \
    echo "[ -f /root/google-cloud-sdk/completion.zsh.inc ] && source /root/google-cloud-sdk/completion.zsh.inc" >> /root/.zshrc && \
    curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# ============================================================================================================
# ========================================================================== Tool Installations Part Two =====
# ============================================================================================================

RUN . /opt/pyenv/bin/activate && \
    pip install requests boto3 semgrep && \
    pip3 install --user cloudsplaining && \
    cd /opt/ && \
    git clone --depth=1 https://github.com/nccgroup/ScoutSuite && cd ScoutSuite && \
    pip install --no-cache-dir -r requirements.txt && cd .. && \
    git clone --depth=1 https://github.com/nccgroup/PMapper && cd PMapper && \
    pip install --no-cache-dir -r requirements.txt && \
    sed -i 's/from collections import Mapping, MutableMapping, OrderedDict/from collections.abc import Mapping, MutableMapping\nfrom collections import OrderedDict/g' principalmapper/util/case_insensitive_dict.py && \
    sed -i 's/\#\!\/usr\/bin\/env python/\#\!\/usr\/bin\/env python3/g' pmapper.py && cd .. && \
    pip install --no-cache-dir checkov && \
    pip install --no-cache-dir prowler && \
    git clone --depth=1 https://github.com/aquasecurity/kube-hunter && cd kube-hunter && \
    pip install . && cd .. && \
    git clone --depth=1 https://github.com/cyberark/KubiScan && cd KubiScan && \
    pip install -r requirements.txt && cd .. && \
    git clone --depth=1 https://github.com/RhinoSecurityLabs/GCP-IAM-Privilege-Escalation && cd GCP-IAM-Privilege-Escalation/PrivEscScanner && \
    pip install -r requirements.txt

RUN cd /opt/executables/ && \
    kctlurla="https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl" && \
    kctlurlb="https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    if [ "$(uname -m)" = "aarch64" ]; then curl -LO "$kctlurla"; else curl -LO "$kctlurlb"; fi && \
    chmod +x kubectl && \
    a=$(curl -s https://api.github.com/repos/powershell/powershell/releases/latest | grep -E "browser_download_url.*" | grep -i "linux-arm64.tar.gz" | cut -d '"' -f4) && \
    b=$(curl -s https://api.github.com/repos/powershell/powershell/releases/latest | grep -E "browser_download_url.*" | grep -i "linux-x64.tar.gz" | cut -d '"' -f4) && \
    mkdir /opt/powershell && cd /opt/powershell && \
    if [ "$(uname -m)" = "aarch64" ]; then wget "$a" -O test.tar.gz; else wget "$b" -O test.tar.gz; fi && \
    tar -xzf test.tar.gz && \
    chmod +x /opt/powershell/pwsh && ln -s /opt/powershell/pwsh /usr/bin/pwsh

# ============================================================================================================
# ============================================================================================================
# ============================================================================================================

RUN DEBIAN_FRONTEND="noninteractive" apt autoclean -y && \
    DEBIAN_FRONTEND="noninteractive" apt autoremove -y && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "alias scout='/opt/ScoutSuite/scout.py'" >> /root/.bashrc && \
    echo "alias pmapper='/opt/PMapper/pmapper.py'" >> /root/.bashrc && \
    echo "alias kubiscan='python /opt/KubiScan/KubiScan.py'" >> /root/.bashrc && \
    echo "complete -C '/usr/local/bin/aws_completer' aws" >> /root/.bashrc && \
    echo "export PATH=$PATH:/opt/executables:/root/google-cloud-sdk/bin" >> /root/.bashrc
