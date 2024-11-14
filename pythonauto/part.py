import paramiko
import os
import time
import difflib
import re
import yaml

host = '192.168.4.221'
username = 'admin'
password = '12345678@Tt'
file_path = 'oldfile.txt'
latest_file = "newfile.txt"
#file_yaml = "roles/open_remote/defaults/main.yml"
backup_file = "backup.rsc"


def mikrotik_backup(host, username, password, backup_file):
    try:
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

        print(f"Connecting to {host}...")
        client.connect(host, username=username, password=password)

        print(f"Creating backup file: {backup_file}...")
        #command = f"/system backup save name={backup_file}"
        command = f"export file={backup_file}"
        stdin, stdout, stderr = client.exec_command(command)
        time.sleep(5)

        #print backup file
        stdin, stdout, stderr = client.exec_command("/file print")
        output = stdout.read().decode()
        print(output)

        #download file to host
        scp = paramiko.SFTPClient.from_transport(client.get_transport())
        local_path = f"./{backup_file}"
        #remote_path = f"/{backup_file}.backup"
        remote_path = f"/{backup_file}"

        print(f"Downloading backup file to {local_path}...")
        scp.get(remote_path, local_path)
        print("Backup completed successfully.")
    except Exception as e:
        print(f"An error occurred: {e}")


def check_change_config(host, username, password, file_path, latest_file):
    try:
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

        print(f"Connecting to {host}...")
        client.connect(host, username=username, password=password)
        #command = f"/system backup save name={backup_file}"
        command = f"export"
        stdin, stdout, stderr = client.exec_command(command)
        output = stdout.read().decode()
        #print(output)
        with open(file_path, 'w') as file:
           file.write(output)

        #modify output from mikrotik
        with open(file_path, 'r') as f:
            lines = f.readlines()
        with open(file_path, 'w') as f:
            buffer = ""

            for line in lines:
                if line.rstrip().endswith('\\'):
                    buffer += line.rstrip()[:-1] + ' '
                else:
                    buffer += line.strip() + '\n'
                    buffer = buffer.replace(' ' * 7, ' ')
                    f.write(buffer)
                    buffer = ""
            if buffer:
                buffer = buffer.replace(' ' * 7, ' ')
                f.write(buffer.strip() + '\n')


        #open the file exported from mikrotik and compare
        with open(file_path, 'r') as old_file:
            old_config = old_file.readlines()

        #open file config on gitlab and compare with file mikrotik above
        with open(latest_file, 'r') as new_file:
            new_config = new_file.readlines()

        old_lines = [line.strip() for line in old_config]
        new_lines = [line.strip() for line in new_config]


        modified_lines = []
        added_lines = []

        # Use Differ to compare the files line by line
        differ = difflib.Differ()
        diff = list(differ.compare(old_lines, new_lines))

        for line in diff:
            # Check for added lines in new config
            if line.startswith("+ ") and not line.startswith("+ #"):
                # Check if it's truly an added line, not a modification
                if line[2:] not in old_lines:  # If it's not in the old lines, it's truly added
                    added_lines.append(line[2:])

            # Check for modified lines
            elif line.startswith("- ") and not line.startswith("- #"):
                old_line = line[2:]  
                # Search for the corresponding new line
                found_match = False
                for new_line in new_lines:
                    if old_line in new_line and old_line != new_line:
                        modified_lines.append(f"{old_line} -> {new_line}")
                        found_match = True
                        break  
        if modified_lines or added_lines:
            print("Changes detected:")
            if added_lines:
                print("Added lines:")
                for added in added_lines:
                    print(f"+ {added}")
            if modified_lines:
                print("Modified lines:")
                for modified in modified_lines:
                    print(modified)
            # Stop further execution
            #raise Exception("Configuration changes detected. Stopping execution.")
            return modified_lines, added_lines
        else:
            print("No changes detected.")
    except Exception as e:
        print(f"An error occurred: {e}")

#run function


def restore_backup(host, username, password, backup_file):
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

    print(f"Connecting to {host} to restore backup...")
    client.connect(host, username=username, password=password)
    restore_command = f"/system backup load name={os.path.basename(backup_file)}"
    sftp = client.open_sftp()
    sftp.put(backup_file, os.path.basename(backup_file))
    sftp.close()


    # Execute the restore command
    stdin, stdout, stderr = client.exec_command(restore_command)
    restore_output = stdout.read().decode()
    error_output = stderr.read().decode()

    print("Restore output:")
    print(restore_output)
    if error_output:
        print("Error during restore:")
        print(error_output)

    client.close()

mikrotik_backup(host, username, password, backup_file)
modified_lines, added_line = check_change_config(host, username, password, file_path, latest_file)

if not modified_lines and not added_line:
    print("No changes detected. Restoring backup...")
    restore_backup(host, username, password, backup_file)
else:
    raise Exception("Configuration changes detected. Stopping execution.")