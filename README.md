#  Basic Attack Simulation and Detection Lab using CI/CD and IaC

Welcome to this cybersecurity project that combines offensive and defensive strategies within a fully automated Azure environment.

---

## 🛠️ [Part 1: Building the Cyber Lab Environment](README_PART1.md)
Deploy a virtual lab in Azure using:
- **Terraform** (IaC)
- **Ansible** (configuration)
- **GitHub Actions** (CI/CD)

---

## ⚔️ [Part 2: Simulating Attacks and Analyzing Traffic](README_PART2.md)
Execute and monitor attacks using:
- **Kali Linux (as the attacker)** with Hydra, arpspoof, dns2tcp, etc.
- **Ubuntu (as the victim)** with Zeek, tshark and tcpdump for traffic analysis

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
├── .gitignore                 # Ignore key.pem
├── README_PART1.md            # Part 1: Cyber Lab Setup
├── README_PART2.md            # Part 2: Attack Simulation and Traffic Analysis
└── README.md

```
