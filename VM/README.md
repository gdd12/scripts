# Virtual Machine Manager Script (vm_manager.sh)

This script allows you to manage your virtual machines (VMs) in a simple, text-based interface. You can add, edit, delete, and connect to VMs via SSH. It is designed to work on Unix-like systems (Linux, macOS).

## Prerequisites

- A Unix-like system (Linux, macOS).
- SSH keys set up for password-less SSH login (optional but recommended).
- Bash 3.0+ (should work on most modern systems).

---
## Example layout
```bash
=============== Available VMs ===============

1. user@192.168.1.10
2. admin@192.168.1.15 (Backup Server)

=============================================
Would you like to (1) Connect, (2) Add, (3) Edit, (4) Delete (Q) Quit
 > 1
Enter the number of the VM you want to SSH into
 > 1
Connecting to user@192.168.1.10...
```
---

### Setup Instructions

Follow these steps to set up and use the script:

#### 1. Clone the repository
```bash
git clone https://github.com/gdd12/scripts.git
```
#### 2. Change to the scripts directory
```bash
cd /scripts/VM
```
#### 3. Configure the vm_manager.sh file
```bash
nano vm_manager.sh
```
Edit the VM_FILE variable to /Users/<your-user>/vm_file.txt

Edit the KEY_FILE variable: If you want to use SSH keys for password-less authentication, specify the full path of your private key file in the KEY_FILE variable.
#### 4. Save the changes and make the script executable
```bash
chmod +x vm_manager.sh
```

#### 5. (Optional) Set up an alias
To run the script from anywhere, you can set up an alias. Open your shell configuration file (e.g., .bashrc, .zshrc, .zprofile) and add the following line:
```bash
alias vmmanager='/path/to/scripts/VM/vm_manager.sh'
```
After saving the changes, reload the shell configuration:
```bash
source ~/.bashrc   # For bash users
source ~/.zshrc    # For zsh users
source ~/.zprofile    # For profile users
```
Now, you can run the script from anywhere by simply typing ```vmmanager```
