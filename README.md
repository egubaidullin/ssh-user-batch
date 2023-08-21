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

### Server List Format for the Script

To use the script, you need to prepare a `servers.txt` file with the following format:
```
xxx.xxx.xxx.xxx port login password
```

- `xxx.xxx.xxx.xxx`: The IP address of the remote server.
- `port`: The SSH port number for the server.
- `login`: The username for authentication.
- `password`: The password for the user account.

Each line in the `server_list` file should correspond to a remote server you want to manage with the script. Make sure to replace the placeholders with actual server details.
This format allows the script to read and process server information efficiently, enabling batch user management on multiple remote servers with the specified credentials.


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
