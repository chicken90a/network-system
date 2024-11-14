import paramiko
import os
import time
import difflib
import re
import yaml

host = '192.168.4.221'
username = 'admin'
password = '12345678@Tt'
backup_file = f"backup_{time.strftime('%Y%m%d')}.rsc"
file_path = 'mikrotik.txt'
latest_file = 'latest_file.txt'
file_yaml = "open_remote/defaults/main.yml"


def mikrotik_backup(host, username, password, file_path, latest_file, file_yaml):
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

        # Determine if any lines were added or modified
        if added_lines:
            print("The following lines were added:")
            open_remote_data = []
            for line in added_lines:
                #print(line)
                if "add action" in line:

                    source_ip_match = re.search(r"dst-address=([\d\.]+)", line)
                    port_match = re.search(r"dst-port=(\d+)", line)
                    dest_match = re.search(r"to-addresses=([\d\.]+)", line)

                    if source_ip_match and port_match and dest_match:
                        source = source_ip_match.group(1)
                        port = port_match.group(1)
                        dest = dest_match.group(1)

                        # print ip
                        print(f"Source IP: {source}")
                        print(f"Port: {port}")
                        print(f"Destination IP: {dest}")
                        
                        with open(f'{file_yaml}', 'r') as file:
                            yaml_data = yaml.safe_load(file)
                        
                        open_remote_data.append({
                            "ip_source": source,
                            "ip_dest": dest,
                            "port": int(port)
                        })
                        yaml_data = {"open_remote": open_remote_data}
                        with open(file_yaml, 'w') as file:
                            yaml.safe_dump(yaml_data, file, default_flow_style=False)

                    else:
                        print("Dont match")
                else:
                    print(line)

        if modified_lines:
            print("\nThe following lines were modified:")
            for line in modified_lines:
                print(line)
                

        # If no changes or additions were found
        if not added_lines and not modified_lines:
            print("No new lines or modifications were found.")

    except Exception as e:
        print(f"An error occurred: {e}")

#run function
mikrotik_backup(host, username, password, file_path, latest_file, file_yaml)