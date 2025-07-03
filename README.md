# 🛡️ Basic Attack Simulation and Detection Lab

This project provisions a basic cybersecurity lab in Azure using Terraform, configures it with Ansible, and deploys it automatically via GitHub Actions (CI/CD).

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

## 🚀 What It Does

- Creates a resource group, virtual network, subnet, 2 public IPs, and 2 Linux VMs (Kali and Ubuntu) in Azure
- Uses SSH key authentication (no passwords)
- Kali: installs penetration tools (nmap, hping3, hydra)
- Ubuntu: installs monitoring tools (wireshark, tcpdump, zeek)
- Inventory file is generated dynamically
- GitHub Actions workflow orchestrates everything automatically

---

## 🔑 Prerequisites

- Azure subscription
- A service principal with Contributor role
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

## 📄 License

MIT License

---

Built with ❤️ for learning and experimentation in cloud cybersecurity
