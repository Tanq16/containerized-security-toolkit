# General Variant Tools

The General variant provides a comprehensive set of security and utility tools. Each tool is installed in a specific location and serves a particular purpose in security operations.

## Core System Tools

The base system includes essential utilities installed via apt:

- `curl`, `wget`: Network data transfer
- `git`: Version control
- `tmux`: Terminal multiplexer
- `openssl`: Cryptographic toolkit
- `openssh-server`: SSH connectivity
- `openvpn`: VPN client
- Network utilities: `ping`, `telnet`, `traceroute`, `ftp`
- Development tools: `gcc`, `make`, `python3`, `nodejs`, `npm`

## Security Assessment Tools

### Web Application Security

- **Gobuster**: Directory/file enumeration tool
    - Location: `/opt/executables/gobuster`
    - Usage: Web application directory brute forcing

- **FFuf**: Web fuzzer
    - Location: `/opt/executables/ffuf`
    - Usage: Web fuzzing, directory discovery, parameter fuzzing

- **Hakrawler**: Web crawler
    - Location: `/opt/executables/hakrawler`
    - Usage: Web crawling and asset discovery

### Network Security

- **Fingerprintx**: Service identification tool
    - Location: `/opt/executables/fingerprintx`
    - Usage: Service and version detection

- **Nuclei**: Vulnerability scanner
    - Location: `/opt/executables/nuclei`
    - Usage: Automated vulnerability scanning

- **Subfinder**: Subdomain discovery tool
    - Location: `/opt/executables/subfinder`
    - Usage: Subdomain enumeration

### Infrastructure Security

- **Trivy**: Container vulnerability scanner
  - Location: `/opt/executables/trivy`
  - Usage: Container and filesystem scanning

### Reconnaissance Tools

- **Amass**: Attack surface mapping tool
    - Location: `/opt/executables/amass`
    - Usage: Network mapping and asset discovery

- **DNSx**: DNS toolkit
    - Location: `/opt/executables/dnsx`
    - Usage: DNS enumeration and discovery

- **HTTPx**: HTTP toolkit
    - Location: `/opt/executables/httpx`
    - Usage: HTTP probe and analyzer

### Utility Tools

- **YQ**: YAML processor
    - Location: `/opt/executables/yq`
    - Usage: YAML/JSON processing

- **GRPCurl**: gRPC testing tool
    - Location: `/opt/executables/grpcurl`
    - Usage: gRPC API testing

- **Gron**: JSON flattening utility
    - Location: `/opt/executables/gron`
    - Usage: Make JSON greppable

## Wordlists and Resources

Located in `/opt/lists/`:

- SubDomains: `subdomains_top_110000.txt`
- Infrastructure: `common_router_ips.txt`, `common_http_ports.txt`
- Web Content: `directory_brute_medium.txt`, `directory_brute_common.txt`
- Passwords: `rockyou.txt`
- SNMP: `snmp.txt`
- Variables: `secret_keywords.txt`

## Python Environment

A dedicated Python virtual environment is available at `/opt/pyenv/` with:

- Requests: HTTP library
- Semgrep: Pattern-based code scanning

## Development Tools

- Go language environment
- AWS CLI v2
- PowerShell Core
