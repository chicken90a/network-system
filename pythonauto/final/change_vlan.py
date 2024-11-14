import paramiko
import os
import sys
import time
import yaml

host = '172.31.21.20'
username = 'it-ansible'
password = '2024@TiTan'
file_yaml = "//mnt//c//Users//tam.tranp//Desktop//script//Project-auto//network-devices//roles//change_vlan//defaults//main.yml"


def mikrotik_backup(host, username, password):
    try:
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

        print(f"Connecting to {host}...")
        client.connect(host, username=username, password=password)
        command = f"show running-config"#f"show interfaces status"
        stdin, stdout, stderr = client.exec_command(command)
        output = stdout.read().decode()
        #print(output)

        #file_path = r'C:\Users\tam.tranp\Desktop\script\New folder\output.txt'
        with open('file_path.txt', 'w') as file:
           file.write(output)
        
        #file config previous latest
        #file = r'C:\Users\tam.tranp\Desktop\script\test-script\output.txt'
        with open('file_path.txt', 'r') as old_file:
            old_config = old_file.readlines()
        
        #file config latest
        with open('output.txt', 'r') as new_file:
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
                    #interface = old_config[old_config.index(old_line) - 1].strip()
                    changes.append((current_interface, old_vlan, new_vlan))

        if changes:
            change_vlan_data = []
            for interface, old_vlan, new_vlan in changes:
                print(f"{interface} changed: {old_vlan} -> {new_vlan}")
                print(f"{interface}")

                with open(f'{file_yaml}', 'r') as file:
                    yaml_data = yaml.safe_load(file)
                
                interface_number = interface.split("GigabitEthernet")[-1].strip()
                formatted_interface = f"gi{interface_number}"
                change_vlan_data.append({
                    "interface": formatted_interface,
                    "vlan": int(new_vlan)
                })
                
                yaml_data = {"change_vlan": change_vlan_data}
                
                with open(file_yaml, 'w') as file:
                    yaml.safe_dump(yaml_data, file, default_flow_style=False)
        else:
            print("dont change")
        
    except Exception as e:
        print(f"An error occurred: {e}")

#run function
mikrotik_backup(host, username, password)