import difflib
import os
import paramiko
import re

def get_config_prod(host, username, password, file_path):
    try:
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

        print(f"Connecting to {host}...")
        client.connect(host, username=username, password=password)

        # Export configuration
        command = "export"
        stdin, stdout, stderr = client.exec_command(command)
        output = stdout.read().decode()
        #print(output)
        if output is not None:
            print("Export sucessfully & comparing ....")
        else:
            print("Error")

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
    except Exception as e:
        print(f"An error occurred: {e}")

def compare_files(file_path, file2_path):

    if not os.path.isfile(file_path):
        print(f"Error: The file '{file_path}' does not exist.")
        return
    if not os.path.isfile(file2_path):
        print(f"Error: The file '{file2_path}' does not exist.")
        return

    # Read the contents of both files
    file1_lines = read_lines(file_path)
    file2_lines = read_lines(file2_path)

    # Generate the differences using difflib
    diff = difflib.unified_diff(
        file1_lines,
        file2_lines,
        fromfile=os.path.basename(file_path),
        tofile=os.path.basename(file2_path),
        lineterm=''
    )

    # Initialize lists to store added and removed lines
    added_lines = []
    removed_lines = []

    # Process the diff output
    for line in diff:
        if line.startswith('+') and not line.startswith('+++'):
            # Added lines
            added_line = line[1:].strip()
            if is_variable_line(added_line):  # Check if the added line has a variable
                index = file2_lines.index(added_line + '\n')  # Find the index in the second file
                last_command = get_last_command(file2_lines, index)  # Get the last command line
                if last_command:
                    added_lines.append(f"{last_command} {added_line}")  # Combine command with added line
        elif line.startswith('-') and not line.startswith('---'):
            # Removed lines
            removed_line = line[1:].strip()
            if is_variable_line(removed_line):  # Check if the removed line has a variable
                index = file1_lines.index(removed_line + '\n')  # Find the index in the first file
                last_command = get_last_command(file1_lines, index)  # Get the last command line
                if last_command:
                    removed_lines.append(f"{last_command} {removed_line}")  # Combine command with removed line

    for line in removed_lines:
        print(f"Removed: {line}")
        command = line
        verify_command(host, username, password, command)

    for line in added_lines:
        print(f"Added: {line}")
        #excuse_command(host, username, password, line)


def read_lines(file_path):
    with open(file_path, 'r') as file:
        return file.readlines()
    
def get_last_command(lines, index):
    for i in range(index - 1, -1, -1):
        if lines[i].startswith('/'):
            return lines[i].strip()
    return None

def is_variable_line(line):
    return 'list=' in line or 'address=' in line

def check_remove_command(command):
    parts = command.split(' ')
    print(parts)
    if parts[2] == "address-list" and "add" in parts:
        address = next((part for part in parts if part.startswith("address=")), None)
        print(address)
        list_name = next((part for part in parts if part.startswith("list=")), None)
        print(list_name)
        
        if address and list_name:
            command = f"/ip firewall address-list remove [find address={address} list={list_name}]"
            print(f"Executing: {command}")
            return f"/ip firewall address-list remove [find address={address} list={list_name}]"
    
    elif parts[2] == "mangle" and "add" in parts:
        comment = next((part for part in parts if part.startswith("comment=")), None)
        if comment:
            full_comment = comment
            for part in parts[parts.index(comment) + 1:]:
                if part.startswith("dst-address-list="):
                    break
                full_comment += ' ' + part
                comment_full = full_comment.strip()
            print(comment_full)
        
        dst_address_list = next((part for part in parts if part.startswith("dst-address-list=")), None)
        print(dst_address_list)

        src_address = next((part for part in parts if part.startswith("src-address=")), None)
        print(src_address)

        if comment_full and dst_address_list and src_address:
            command = f"/ip firewall mangle remove [find action=accept chain=prerouting comment={comment_full} dst-address-list={dst_address_list} src-address={src_address}]"
            print(command)
            return command

        #/ip firewall mangle remove [find action=accept chain=prerouting comment="hihihi chi la test thoi ma" dst-address-list=Auto_QA_BD src-address=192.168.4.199]

        #print(comment)
        
def verify_command(host, username, password, command):
    try:
        check_command = check_remove_command(command)
        print (check_command)
        if check_command:
            excuse_command(host, username, password, check_command)
        else:
            print("Unable to generate check command.")
    except Exception as e:
        print("error")


#excuse command
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

if __name__ == "__main__":
    # Specify the paths to the text files you want to compare
    file_path = 'mikrotik.txt'  # Path to the first text file (reference)
    file2_path = 'latest_file.txt'  # Path to the second text file (comparison)
    host = '192.168.4.221'
    username = 'admin'
    password = '12345678@Tt'
    
    # Get configuration from the MikroTik device
    get_config_prod(host, username, password, file_path)
    
    # Compare the two files
    compare_files(file_path, file2_path)
