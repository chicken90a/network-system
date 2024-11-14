import paramiko
import difflib
import re
import time

host = '192.168.4.221'
username = 'admin'
password = '12345678@Tt'
file_path = 'mikrotik-1.txt'
latest_file = "latest_file.txt"

def mikrotik_backup(host, username, password, file_path, latest_file):
    try:
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

        print(f"Connecting to {host}...")
        client.connect(host, username=username, password=password)

        # Export configuration
        command = "export"
        stdin, stdout, stderr = client.exec_command(command)
        output = stdout.read().decode()

        with open(file_path, 'w') as file:
            file.write(output)

        # Modify output from MikroTik
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

        # Open the exported file and compare with the latest file
        with open(file_path, 'r') as old_file:
            old_config = old_file.readlines()

        with open(latest_file, 'r') as new_file:
            new_config = new_file.readlines()

        old_lines = [line.strip() for line in old_config]
        new_lines = [line.strip() for line in new_config]

        modified_lines = set()  # Use a set to avoid duplicates
        added_lines = []

        # Use Differ to compare the files line by line
        differ = difflib.Differ()
        diff = list(differ.compare(old_lines, new_lines))

        for line in diff:
            if line.startswith("+ ") and not line.startswith("+ #"):
                added_lines.append(line[2:])
            elif line.startswith("- ") and not line.startswith("- #"):
                old_line = line[2:]  
                # Check if the old line is in new lines
                for new_line in new_lines:
                    if old_line in new_line and old_line != new_line:
                        modified_lines.add(f"{old_line} -> {new_line}")  # Add to set to avoid duplicates
                        break  

        # Remove any added lines that were also modified
        added_lines = [line for line in added_lines if not any(line in modified for modified in modified_lines)]

        # Check for changes and find the nearest section header
        if modified_lines or added_lines:
            print_changes_with_section(old_lines, modified_lines, added_lines)

        # If no changes or additions were found
        if not added_lines and not modified_lines:
            print("No new lines or modifications were found.")

    except Exception as e:
        print(f"An error occurred: {e}")

def print_changes_with_section(old_lines, modified_lines, added_lines):
    for change in modified_lines:
        old_line = change.split(" -> ")[0]
        section = find_nearest_section(old_lines, old_line)
        if section:
            print(f"\nChanges detected in section: {section}")
            print(f"Modified: {change}")
            pattern = r'->\s*(.+)'
            match = re.search(pattern, change)
            if match:

                change = match.group(1)
                print(f"{section} {change}")
                command = f"{section} {change}"
                #excuse_command(host, username, password,command)
                verify_and_execute(host, username, password, command)
        else:
            print(f"\nCould not find section for modified line: {old_line}")

    for line in added_lines: 
        section = find_last_line_with_slash(latest_file, line)
        if section:
            print(f"\nChanges detected in section: {section}")
            print(f"Added: {line}")
            print(f"{section} {line}")
            command = f"{section} {line}"
            #excuse_command(host, username, password,command)
            verify_and_execute(host, username, password, command)

def find_last_line_with_slash(latest_file, target_line):
    with open(latest_file, 'r') as file:
        lines = file.readlines()

    target_index = -1

    for index, line in enumerate(lines):
        if target_line in line:
            target_index = index
            break

    if target_index == -1:
        print("dont see target line")
        return

    for i in range(target_index - 1, -1, -1):
        if lines[i].startswith('/'):
            return lines[i].strip()

    print("not found")

def find_nearest_section(lines, line):
    try:
        line_index = lines.index(line.strip())
        for i in range(line_index, -1, -1):
            if lines[i].startswith('/'):
                return lines[i].strip()
    except ValueError:
        # Line not found in the list
        return None
    return None


def excuse_command(host, username, password, command):
    try:
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

        print(f"Connecting to {host}...")
        client.connect(host, username=username, password=password)

        print("Executing Command...")
        stdin, stdout, stderr = client.exec_command(command)
        output = stdout.read().decode()
        error = stderr.read().decode()

        if error:
            raise Exception(f"Error executing command: {error.strip()}")
        else:
            print("Command executed successfully:")
            print(output.strip())

    except Exception as e:
        print(f"An error occurred: {e}")

def generate_check_command(command):
    parts = command.split(' ')
    print(parts)

    if parts[2] == "address-list" and "add" in parts:
        address = next((part for part in parts if part.startswith("address=")), None)
        print(address)
        list_name = next((part for part in parts if part.startswith("list=")), None)
        print(list_name)
        
        if address and list_name:
            return f"/ip firewall address-list print detail where {address} and {list_name}"


    elif parts[2] == "nat" in parts:
        dst_address = next((part for part in parts if part.startswith("dst-address=")), None)
        dst_port = next((part for part in parts if part.startswith("dst-port=")), None)

        if dst_address and dst_port:
            return f"/ip firewall nat print detail where dst-address={dst_address.split('=')[1]} and dst-port={dst_port.split('=')[1]}"


    return None  
def verify_and_execute(host, username, password, command):
    try:
        check_command = generate_check_command(command)
        
        if check_command:
            excuse_command(host, username, password, check_command)
            print(f"Command already exists: {command}")
        else:
            print("Unable to generate check command.")
    except Exception:

        print(f"Executing command: {command}")
        excuse_command(host, username, password, command)

# Run function
mikrotik_backup(host, username, password, file_path, latest_file)