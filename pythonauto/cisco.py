import paramiko
import os
import sys
import time
import yaml

host = '172.31.21.20'
username = 'it-ansible'
password = '2024@TiTan'
file_config = "cisco.txt"

def change_vlan(host, username, password,file_config):
    try:
        # client = paramiko.SSHClient()
        # client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

        # print(f"Connecting to {host}...")
        # client.connect(host, username=username, password=password)
        # command = f"show running-config" #f"show interfaces status"
        # stdin, stdout, stderr = client.exec_command(command)
        # output = stdout.read().decode()
        # #print(output)

        # with open('file_path.txt', 'w') as file:
        #    file.write(output)
        
        #file config previous latest
        with open('cisco-1.txt', 'r') as old_file:
            old_config = old_file.readlines()
        
        #file config latest
        with open(file_config, 'r') as new_file:
            new_config = new_file.readlines()
        
        changes = []
        current_interface = None

        for old_line, new_line in zip(old_config, new_config):
            if old_line.strip().startswith("interface"):
                current_interface = old_line.strip()

            if "switchport access vlan" in old_line and "switchport access vlan" in new_line:
                old_vlan = old_line.strip().split()[-1]
                new_vlan = new_line.strip().split()[-1]

                if old_vlan != new_vlan and current_interface:
                    changes.append((current_interface, old_vlan, new_vlan))
        
        # edit file variable ansible
        if changes:
            #change_vlan_data = []
            for interface, old_vlan, new_vlan in changes:
                print(f"{interface} changed: {old_vlan} -> {new_vlan}")
                #print(f"{interface}")
                
                interface_number = interface.split("GigabitEthernet")[-1].strip()
                formatted_interface = f"gi{interface_number}"
                print(formatted_interface)
                commands = [
                    f"interface {formatted_interface}",
                    "switchport mode access",
                    f"switchport access vlan {new_vlan}",
                    "exit"
                ]
                
                print(commands)
                for command in commands:
                    print(f"excuse command: {command}")
                    #stdin, stdout, stderr = client.exec_command(command)
                    #output = stdout.read().decode()
                    #print(output)note
        else:
            print("dont change")
        
    except Exception as e:
        print(f"An error occurred: {e}")

#run function
change_vlan(host, username, password, file_config)
