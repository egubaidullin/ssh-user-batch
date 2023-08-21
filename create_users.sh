#!/bin/bash

group_name="root"

# Enable debug mode 
#set -x 

# Logging function
function log {

  local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  
  echo "$timestamp - $1" >> "$log_file" || echo "Error writing to log"

}

# Check log file path
log_file="$(dirname "$0")/user_create.log"

# Call logging function  
log "Script execution started"  

# Check arguments
if [ $# -ne 4 ]; then

  log "Usage: $0 <server_file> <key_file> <new_username> <password>"
  
  exit 1
  
fi

# Read arguments
servers_file="$1" 
ssh_key_file="$2"
new_username="$3"
new_password="$4"

# Key path relative to script
key_path="./id_rsa"

# Enable debug mode
#set -x

# Check files
if [ ! -f "$servers_file" ]; then

  log "Server file not found"
  
  exit 1
  
fi

if [ ! -f "$ssh_key_file" ]; then

  log "SSH key file not found"
  
  exit 1
  
fi  

# Read key
ssh_key=$(cat "$ssh_key_file")

# Check servers.txt file availability  
if [ ! -f "$servers_file" ]; then

  log "Server file not found"
  
  exit 1
  
fi

# Loop through servers
while IFS=' ' read -r ip port user pass; do

  # Enable debug output for loop
  # set -x

  # Check empty line
  if [ -z "$ip$port$user$pass" ]; then

    log "Skipping empty line"
    
    continue
    
  fi

  # Connect via SSH 
  # sshpass -p "$pass" ssh -o StrictHostKeyChecking=no -p "$port" "$user@$ip" "echo Connected"

  # Check sudo access
  # cmd="sudo echo 'sudo check'"
  # sshpass -p "$pass" ssh -tt -p "$port" "$user@$ip" "export PATH=/usr/bin:/usr/sbin; $cmd" >> "$log_file" 2>&1

  # Create user account
  sshpass -p "$pass" ssh -tt -p "$port" "$user@$ip" "sudo useradd $new_username"

  # Add user to root group
  sshpass -p "$pass" ssh -tt -p "$port" "$user@$ip" "sudo usermod -aG $group_name $new_username"

  # Allow SSH login
  #sshpass -p "$pass" ssh -tt -p "$port" "$user@$ip" "echo ${new_username} | sudo tee -a /etc/ssh/sshd_config > /dev/null"

  # Reload SSH service
  #sshpass -p "$pass" ssh -tt -p "$port" "$user@$ip" "sudo service ssh reload" 

  # Set password
  #sshpass -p "$pass" ssh -tt -p "$port" "$ip" "echo ${new_password} | sudo -S passwd ${new_username}"

  # Create home dir
  sshpass -p "$pass" ssh -tt -p "$port" "$ip" "mkdir -p /home/$new_username && chown $new_username /home/$new_username"

  # Create .ssh dir
  sshpass -p "$pass" ssh -tt -p "$port" "$ip" "mkdir -p /home/$new_username/.ssh"

  # Set permissions
  result=$(sshpass -p "$pass" ssh -tt -p "$port" "$ip" "chown -R $new_username /home/$new_username/.ssh")

  # Add SSH key
  result=$(sshpass -p "$pass" ssh -tt -p "$port" "$ip" "echo ${ssh_key} >> /home/$new_username/.ssh/authorized_keys")

  # Test SSH access
  # ssh -i $ssh_key_file -p "$port" "${new_username}@${ip}" "echo 'Access OK'"

  # Disconnect 
  result=$(sshpass -p "$pass" ssh -tt -i id_rsa -o StrictHostKeyChecking=no -p "$port" "$user@$ip" "echo Connected successfully")

  log "$result"
  
  # Disable debug output
  set +x
  
done < "$servers_file"

# Script complete  
log "Script finished"
