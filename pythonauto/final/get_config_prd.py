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



    file_path = 'latest_file.txt'  # Path to the first text file (reference)
    file2_path = 'latest_file.txt'  # Path to the second text file (comparison)
    host = '192.168.4.221'
    username = 'admin'
    password = '12345678@Tt'
    
    # Get configuration from the MikroTik device
    get_config_prod(host, username, password, file_path)