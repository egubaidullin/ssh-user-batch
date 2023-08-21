## Script to Create New Service Users on Remote Servers

This Bash script automates creating new service user accounts with SSH key authentication across multiple remote servers.

**Important notes:**

- The script creates users with the same SSH public key on all servers. This can be convenient but is less secure.
- The users are created in a programmatic way and intended for service accounts rather than individual logins.

## Usage 

The script accepts four command line arguments:

```
./create_users.sh servers.txt id_rsa newusername passphrase
```

- `servers.txt` - List of servers
- `id_rsa` - SSH private key for new users 
- `newusername` - New user to create
- `passphrase` - Passphrase for SSH key

## Functionality

- Assumes password SSH auth for the admin user 
- Connects to each server via SSH 
- Creates new user account
- Adds user to specific group (configurable)
- Sets up SSH key auth for new user
- Tests login with new account

Key points:

- New users get same SSH key on all servers
- Intended for service accounts over individual logins
- Admin user needs password SSH auth to connect

Let me know if this provides a clearer overview of what the script does! I'm happy to explain or modify the description further.
