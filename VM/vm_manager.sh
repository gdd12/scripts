#!/bin/bash

# Input the path to where you want the Virtual Machine configuration file to be stored. Typically a .txt file
VM_FILE="/path/to/vm_file.txt"

# Input the path to where you have the private key file for the Virtual Machines (password-less authentication)
KEY_FILE="/path/to/private_key"

############## Do NOT change anything below this line ##############

display_vms() {
    echo "=============== Available VMs ==============="
    echo ""
    if [[ ! -s $VM_FILE ]]; then
        echo "No VMs available."
        return
    fi
    local count=1
    while IFS= read -r line; do
        printf "   %d. %s\n" "$count" "$line"
        ((count++))
    done < "$VM_FILE"
    echo ""
    echo "============================================="
}

add_vm() {
    read -p "Enter username: " username
    read -p "Enter IP address: " ip
    read -p "Enter a comment (optional): " comment
    if [[ -z "$comment" ]]; then
        echo "$username@$ip" >> "$VM_FILE"
    else
        echo "$username@$ip ($comment)" >> "$VM_FILE"
    fi
    echo "VM added successfully."
}

edit_vm() {
    echo "Enter the number of the VM you want to edit"
    read -p " > " vm_number
    if [[ "$vm_number" =~ ^[0-9]+$ ]] && (( vm_number > 0 )); then
        local line_to_edit=$(sed -n "${vm_number}p" "$VM_FILE")
        if [[ -n "$line_to_edit" ]]; then
            echo "Editing: $line_to_edit"
            read -p "Enter new username (leave blank to keep current): " new_username
            read -p "Enter new IP address (leave blank to keep current): " new_ip
            read -p "Enter new comment (leave blank to keep current): " new_comment
            
            current_username=$(echo "$line_to_edit" | cut -d'@' -f1)
            current_ip=$(echo "$line_to_edit" | cut -d'@' -f2 | cut -d' ' -f1)
            
            [[ -z "$new_username" ]] && new_username="$current_username"
            [[ -z "$new_ip" ]] && new_ip="$current_ip"
            [[ -z "$new_comment" ]] && new_comment=""
            
            if [[ -z "$new_comment" ]]; then
                new_line="$new_username@$new_ip"
            else
                new_line="$new_username@$new_ip ($new_comment)"
            fi
            
            sed -i.bak "${vm_number}s/.*/$new_line/" "$VM_FILE"
            echo "VM updated successfully."
        else
            echo "Invalid selection."
        fi
    else
        echo "Please enter a valid number."
    fi
}

delete_vm() {
    echo "Enter the number of the VM you want to delete"
    read -p " > " vm_number
    if [[ "$vm_number" =~ ^[0-9]+$ ]] && (( vm_number > 0 )); then
        local line_to_delete=$(sed -n "${vm_number}p" "$VM_FILE")
        if [[ -n "$line_to_delete" ]]; then
            sed -i.bak "${vm_number}d" "$VM_FILE"
            echo "Deleted: $line_to_delete"
        else
            echo "Invalid selection."
        fi
    else
        echo "Please enter a valid number."
    fi
}

while true; do
    display_vms
    echo "Would you like to (1) Connect, (2) Add, (3) Edit, (4) Delete, (Q) Quit"
    read -p " > " choice
    
    case $choice in
        1)
	    echo "Enter the numer of the VM you want to SSH into"
	    read -p " > " vm_number
            if [[ "$vm_number" =~ ^[0-9]+$ ]] && (( vm_number > 0 )); then
                ssh_line=$(sed -n "${vm_number}p" "$VM_FILE")
                if [[ -n "$ssh_line" ]]; then
                    ssh_command=$(echo "$ssh_line" | awk '{print $1}' | cut -d' ' -f1)
                    echo "Connecting to $ssh_command..."
                    ssh "$ssh_command" -i $KEY_FILE
		    exit 0
                else
                    echo "Invalid selection."
                fi
            else
                echo "Please enter a valid number."
            fi
            ;;
        2)
            add_vm
            ;;
        3)
            edit_vm
            ;;
        4)
            delete_vm
            ;;
        *)
            echo "Exiting."
            exit 0
            ;;
    esac
done
