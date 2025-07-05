# 🛡️ Basic Attack Simulation and Detection Lab

This project provisions a basic cybersecurity lab in Azure using Terraform to create the VMs, configures it with Ansible, and deploys it automatically via GitHub Actions (CI/CD).
- **Part 1:** Creating the infrastructure using a CI/CD pipeline or workflow.
- **Part 2:** Running basic attacks and documenting our findings.

---

## 📁 Project Structure

```
.
├── .github/
│   └── workflows/
│       └── deploy.yml         # GitHub Actions workflow
├── terraform/
│   ├── main.tf                # Main Terraform infrastructure definition
│   ├── outputs.tf             # Terraform output variables
│   ├── terraform.tfvars       # Values for Terraform variables
│   └── variables.tf           # Terraform variable declarations
├── ansible/
│   ├── kali-playbook.yml      # Ansible playbook for Kali VM
│   ├── ubuntu-playbook.yml    # Ansible playbook for Ubuntu VM
│   └── inventory.ini          # Populated dynamically by GitHub Actions
├── .gitignore                 # Recommended: ignore key.pem
└── README.md
```

---
## Part 1: Infrastructure and CI/CD workflow

### 🔧 What are Terraform, Ansible, and CI/CD?

- **Terraform** is an Infrastructure as Code (IaC) tool that lets you define, create, and manage infrastructure on cloud platforms like Azure using simple configuration files.
- **Ansible** is an automation tool used for configuring systems, installing software, and executing tasks across remote machines using playbooks (YAML files).
- **CI/CD (Continuous Integration/Continuous Deployment)** is a software development practice that automates the integration and delivery of code and infrastructure, allowing for consistent, repeatable, and fast deployments. Here, GitHub Actions serves as our CI/CD orquestrator.

---

### 🚀 What happens when the workflow gets triggered?

This project builds a fully functional cybersecurity lab in Azure consisting of a Kali Linux machine (for offensive tools) and an Ubuntu server (for monitoring tools). Here's a breakdown:

### 🧱 Azure Infrastructure

- **Resource Group:** A container that holds related Azure resources such as VMs, virtual networks, and public IPs. It's useful for managing permissions, billing, and cleanup.
- **Virtual Network (VNet):** Provides an isolated and secure network environment in Azure where our VMs can communicate.
- **Subnet:** A sub-section of a virtual network that allows you to segment the network logically. This is necessary to define IP ranges for VMs.
- **Public IPs:** Each VM is assigned a dynamic public IP to be accessible remotely via SSH.
- **Linux Virtual Machines:** One Kali and one Ubuntu VM, each with their own network interface and SSH access.

### 🔒 Secure Authentication

SSH key-based login is used.

🔐**What Are SSH Key Pairs?**

An SSH key pair consists of two linked cryptographic files:

- Public key (e.g., id_rsa.pub): This is placed on the server (Azure VM).

- Private key (e.g., id_rsa): This stays on your computer. You never share it.

They work together like a lock and key:

- The server “locks” access with the public key.

- Only your private key can “unlock” and log in.

In our CI/CD setup:

- We need a key pair. See here how to generate an SSH Key Pair.
- Store the private key securely in GitHub Secrets (SSH_PRIVATE_KEY).
- Repalce the public key in `terraform.tfvars` with the new matching key.
- Use Ansible and GitHub Actions to SSH into the VMs without exposing passwords.

### ⚙️ VM Configuration with Ansible

- **Kali VM:** Installs tools like `nmap`, `hping3`, and `hydra`
- **Ubuntu VM:** Installs monitoring tools like `wireshark`, `tcpdump`, and `zeek`

### 🔄 Automation Pipeline

The GitHub Actions workflow performs the following:
1. Initializes and applies Terraform to create infrastructure
2. Retrieves public IPs from Terraform output
3. Dynamically generates an Ansible inventory file
4. Runs Ansible playbooks to configure both VMs
5. Cleans up temporary SSH key from the runner


---

## 🔑 Prerequisites

- Azure subscription
- A service principal with Contributor role. See here how to generate a service principal on Azure.
- An SSH Key Pair. See here how to generate an SSH Key Pair.
- GitHub repository with the following secrets:

  - `ARM_CLIENT_ID`
  - `ARM_CLIENT_SECRET`
  - `ARM_SUBSCRIPTION_ID`
  - `ARM_TENANT_ID`
  - `SSH_PRIVATE_KEY` (the private key matching the public key in `terraform.tfvars`)

---

## 🧪 Run the Lab

1. Fork this repository
2. Add the GitHub Secrets listed above
3. (Optional) Review or edit `terraform.tfvars` to adjust region, username, VM size, etc.
4. Go to GitHub → Actions tab → Run the Deploy workflow manually

---

## ⚙️ CI/CD Pipeline Flow

1. Checkout repo
2. Setup Terraform and run terraform init/apply
3. Extract public IPs of both VMs using terraform output
4. Generate ansible/inventory.ini dynamically
5. Run Ansible playbooks to configure each VM
6. Clean up SSH key from runner

---

## 🧰 Tools Installed

### Kali
- nmap
- hping3
- hydra

### Ubuntu
- wireshark
- tcpdump
- zeek

---

## 🔐 Security Notes

- SSH key is handled securely via GitHub Secrets
- Password authentication is disabled
- Don't commit key.pem or sensitive files

---

## 🛠 Future Improvements

- Add NSG/firewall rules
- Configure Zeek/Suricata with logging and dashboards
- Enable alerts or logs shipping to a SIEM (like ELK)

---

