# Cloud Variant Tools

The Cloud variant extends the General variant with specialized tools for cloud security assessment and operations. It includes tools for major cloud providers and cloud-native technologies.

## Cloud Provider Tools

### Multi-Cloud Tools

- **CloudFox**: Cloud security assessment tool
  - Location: `/opt/executables/cloudfox`
  - Usage: Cloud service enumeration and security assessment

- **CloudList**: Cloud asset enumeration
  - Location: `/opt/executables/cloudlist`
  - Usage: Multi-cloud asset discovery

### AWS Tools

- **AWS CLI v2**: Official AWS command line interface
  - Location: System PATH
  - Usage: AWS service interaction and management

- **Prowler**: AWS security assessment tool
  - Location: Python environment
  - Usage: AWS security best practice assessment

### Azure Tools

- **Azure CLI**: Official Azure command line interface
  - Location: System PATH
  - Usage: Azure service management and interaction

- **AzureHound**: Azure security assessment tool
  - Location: `/opt/executables/azurehound`
  - Usage: Azure AD privilege escalation paths

### GCP Tools

- **Google Cloud SDK**: Official GCP command line tools
  - Location: `/root/google-cloud-sdk/`
  - Usage: GCP service interaction and management

## Container Security Tools

- **Trivy**: Container vulnerability scanner
  - Location: `/opt/executables/trivy`
  - Usage: Container and filesystem vulnerability scanning

- **Peirates**: Kubernetes penetration testing tool
  - Location: `/opt/executables/peirates`
  - Usage: Kubernetes security assessment

## Infrastructure as Code Security

- **Terraform**: Infrastructure as code tool
  - Location: `/opt/executables/terraform`
  - Usage: Infrastructure deployment and assessment

- **Checkov**: IaC security scanner
  - Location: Python environment
  - Usage: Infrastructure as Code security scanning

## Security Assessment Tools

### Reconnaissance

- Same tools as General variant:
  - Subfinder
  - HTTPx
  - DNSx
  - Nuclei

### Web Security

- Standard web testing tools from General variant:
  - FFuf
  - Gobuster
  - Hakrawler

## Python Security Tools

Located in Python virtual environment at `/opt/pyenv/`:
- **ScoutSuite**: Multi-cloud security auditing tool
  - Usage: `/opt/ScoutSuite/scout.py`
  - Purpose: Cloud security posture assessment

- **PMapper**: AWS IAM evaluation tool
  - Usage: `/opt/PMapper/pmapper.py`
  - Purpose: AWS IAM analysis

- **KubiScan**: Kubernetes security scanning tool
  - Usage: `/opt/KubiScan/KubiScan.py`
  - Purpose: Kubernetes security assessment

## Additional Resources

- Kubernetes tools:
  - `kubectl`: Kubernetes CLI
  - `kube-hunter`: Kubernetes penetration testing
  - `kubeaudit`: Kubernetes security auditing

- GCP security tools:
  - GCP IAM Privilege Escalation scanner
  - GCP security assessment tools

## Development Environment

Includes standard development tools:
- Python 3 with specialized libraries
- Go language environment
- PowerShell Core
