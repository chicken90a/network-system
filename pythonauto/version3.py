import difflib
import os
import paramiko


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

    if not removed_lines:
        for added_line in added_lines:
            print(f"Added: {added_line}")
            #excuse_command(host, username, password, added_line)

    elif not added_lines:
        for removed_line in removed_lines:
            print(f"Removed: {removed_line}")
            remove_command = print_nat_ids_with_port(host, username, password, removed_line)
            print(remove_command)
            #excuse_command(host, username, password, remove_command)
    else:
        print("vô đây")
        matched_removed_lines = set()
        for removed_line in removed_lines:
            found_match = False
            command = removed_line
            for added_line in added_lines:
                command = added_line
                similarity = calculate_similarity(removed_line, added_line)

                if similarity > 50:
                    found_match = True
                    matched_removed_lines.add(removed_line)
                    removed_unique, added_unique = get_changed_parts(removed_line, added_line)
                    print(f"Match found: \nRemoved: {removed_line} \nAdded: {added_line} \nSimilarity: {similarity:.2f}%\n")
                    print(f"Changed parts:\nRemoved unique: {removed_unique}\nAdded unique: {added_unique}\n")
                    command = print_nat_ids_with_port(host, username, password, removed_line)
                    print(f"command set {command}")
                    added_unique_str = " ".join(added_unique)
                    updated_command = command.replace("remove", "set") + " " + added_unique_str
                    print(f"update command set: {updated_command}")
                    #excuse_command(host, username, password, updated_command)
                
                # else:
                #     print("hihihii")
                #     print(f"Added: {added_line}")
                #     #print(f"Removed: {removed_line}")
                #     #excuse_command(host, username, password, command)
            if not found_match:
                print(f"Removed: {removed_line}")
                command = print_nat_ids_with_port(host, username, password, removed_line)
                print(command)
                #excuse_command(host, username, password, command)\

        for added_line in added_lines:
            if not any(calculate_similarity(removed_line, added_line) > 50 for removed_line in matched_removed_lines):
                print(f"Added: {added_line}")
                #excuse_command(host, username, password, command)
                

def get_changed_parts(removed_line, added_line):
    removed_parts = removed_line.split()
    added_parts = added_line.split()

    # Create sets for easier comparison
    removed_set = set(removed_parts)
    added_set = set(added_parts)

    # Identify unique parts in each line
    removed_unique = removed_set - added_set
    added_unique = added_set - removed_set

    return removed_unique, added_unique

def calculate_similarity(removed_line, added_line):
    # Split the lines into sets of words
    removed_words = set(removed_line.split())
    added_words = set(added_line.split())
    
    # Calculate the number of common words
    common_words = removed_words.intersection(added_words)
    total_words = len(removed_words.union(added_words))

    # Calculate similarity percentage
    if total_words == 0:  # Avoid division by zero
        return 0.0
    
    similarity_percentage = (len(common_words) / total_words) * 100
    return similarity_percentage

def read_lines(file_path):
    with open(file_path, 'r') as file:
        return file.readlines()
    
def get_last_command(lines, index):
    for i in range(index - 1, -1, -1):
        if lines[i].startswith('/'):
            return lines[i].strip()
    return None

def is_variable_line(line):
    return 'list=' in line or 'address=' in line or 'name=' in line or 'vlan-id=' in line

def print_nat_ids_with_port(host, username, password, command):
    try:
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        client.connect(host, username=username, password=password)
        
        address = None
        list_name = None
        src_address = None
        dst_address_list = None
        to_addresses = None
        to_ports = None
        dst_address = None
        gateway = None
        delete = None
        network = None
        name = None
        id = None
        ranges = None
        vrid = None
        parts = command.split(' ')
        print(parts)
        
        if parts[2] == "address-list" and "add" in parts:
            
            addresses = next((part for part in parts if part.startswith("address=")), None)
            address = addresses.split('=')[1]
            print(address)

            list_names = next((part for part in parts if part.startswith("list=")), None)
            list_name = list_names.split('=')[1]
            print(list_name)

            command = parts[0] + " " + parts[1] + " "  + parts[2] + " " + "print"
            print(command)
        
        #mangle delete
        elif parts[2] == "mangle" and "add" in parts:
            src_address = next((part for part in parts if part.startswith("src-address=") or part.startswith("dst-address=")) , None)
            print (src_address)

            dst_address_list = next((part for part in parts if part.startswith("dst-address-list=") or part.startswith("src-address-list=")), None)
            print(dst_address_list)

            command = parts[0] + " " + parts[1] + " "  + parts[2] + " " + "print"
            print(command)

        #nat delete
        elif parts[2] == "nat" and "add" in parts:
            to_addresses = next((part for part in parts if part.startswith("to-addresses=")), None)
            print(to_addresses)
            
            to_ports = next((part for part in parts if part.startswith("to-ports=")), None)
            print(to_ports)
            
            command = parts[0] + " " + parts[1] + " "  + parts[2] + " " + "print"
            print(command)
        
        #filter delete
        elif parts[2] == "filter" and "add" in parts:
            delete = next((part for part in parts if part.startswith("src-address-list=") or part.startswith("dst-address=") or part.startswith("comment=") or part.startswith("protocol=") or part.startswith("dst-port=")) , None) #or part.startswith("comment=")
            print(delete)
            if  delete.startswith("comment="): #delete is not None:# and
                for part in parts[parts.index(delete) + 1:]:
                    if part.startswith("dst-address-list=") or part.startswith("dst-address=") or part.startswith("protocol="):
                        break
                    delete += ' ' + part
                    delete = delete.strip()
                    delete = delete.split('=')[1]
                    delete = delete.strip('"')
                    print(delete)
            
            command = parts[0] + " " + parts[1] + " "  + parts[2] + " " + "print"
            print(command)
        
        #ip route
        elif parts[1] == "route" and "add" in parts:
            dst_addresses = next((part for part in parts if part.startswith("dst-address=")), None)
            if dst_addresses is not None:
                dst_address = dst_addresses.split('=')[1]
                print(dst_address)

            gateways = next((part for part in parts if part.startswith("gateway=")), None)
            if gateways is not None:
                gateway = gateways.split('=')[1]
                print(gateway)

            command = parts[0] + " " + parts[1] + " " + "print"
            print(command)

        #ip address
        elif parts[0] == "/ip" or parts[1] == "address" and "add" in parts:
            addresses = next((part for part in parts if part.startswith("address=")), None)
            if addresses is not None:
                address = addresses.split('=')[1]
                print(address)

            networks = next((part for part in parts if part.startswith("network=")), None)
            if networks is not None:
                network = networks.split('=')[1]
                print(network)
            
            command = parts[0] + " " + parts[1] + " " + "print"
            print(command)

        #interface vlan delete
        elif parts[0] == "/interface" and parts[1] == "vlan" and "add" in parts:
            vlan_name = next((part for part in parts if part.startswith("name=")), None)
            name = vlan_name.split('=')[1]
            print(name)

            vlan_id = next((part for part in parts if part.startswith("vlan-id=")), None)
            id = vlan_id.split('=')[1]
            print(id)

            command = parts[0] + " " + parts[1] + " " + "print"
            print(command)

        #interface vrrp delte
        elif parts[0] == "/interface" and parts[1] == "vrrp" and "add" in parts:
            names = next((part for part in parts if part.startswith("name=")), None)
            name = names.split('=')[1]
            print(name)

            vrids = next((part for part in parts if part.startswith("vrid=")), None)
            vrid = vrids.split('=')[1]
            print(vrid)

            command = parts[0] + " " + parts[1] + " " + "print"
            print(command)
        
        #ip pools delete
        if parts[0] == "/ip" and parts[1] == "pool" and "add" in parts:
            names = next((part for part in parts if part.startswith("name=")), None)
            name = names.split('=')[1]
            print(name)
            
            rangess = next((part for part in parts if part.startswith("ranges=")), None)
            ranges = rangess.split('=')[1]
            print(ranges)

            command = parts[0] + " " + parts[1] + " " + "print"
            print(command)

        stdin, stdout, stderr = client.exec_command(command)
        output = stdout.read().decode().strip()

        lines = output.split('\n')
        #print(output)
        combined_line = ""

        #remove addresses-list
        if command == "/ip firewall address-list print":
            data_lines = lines[2:]
            ids = []
            
            for line in data_lines:
                parts = line.split()
                if f"{address}" == parts[2] in line:
                    id = parts[0]
                    print(f"ID: {id}")
                    #print(f"/ip firewall address-list set {id} {addresses} {list_names}")
                    return f"/ip firewall address-list remove {id}"
        
        #remove ip rôute
        if command == "/ip route print":
            data_lines = lines[2:]
            ids = []
            
            for line in data_lines:
                parts = line.split()
                print(parts)
                if f"{dst_address}" == parts[2] and f"{gateway}" == parts[3] in line:
                    id = parts[0]
                    print(f"ID: {id}")
                    return f"/ip route remove {id}"
        
        #remove ip address
        if command == "/ip address print":
            data_lines = lines[2:]
            ids = []
            
            for line in data_lines:
                #print(line)
                parts = line.split()
                #print(parts)
                if f"{address}" == parts[1] or f"{address}" == parts[2] and f"{network}" == parts[2] or f"{network}" == parts[3] in line:
                    id = parts[0]
                    print(f"ID: {id}")
                    return f"/ip address remove {id}"
        
        # remove interface vlan
        if command == "/interface vlan print":
            data_lines = lines[2:]
            ids = []
            
            for line in data_lines:
                parts = line.split()
                if f"{name}" == parts[1] or f"{name}" == parts[2] and f"{id}" == parts[4] or f"{id}" == parts[5] in line:
                    id = parts[0]
                    print(f"ID: {id}")
                    return f"/interface vlan remove {id}"
        
        # remove vrrp interfaces
        if command == "/interface vrrp print":
            data_lines = lines[2:]
            ids = []
            
            for line in data_lines:
                print(line)
                parts = line.split()
                print(parts)
                if len(parts) > 4:
                    if f"{name}" == parts[1] or f"{name}" == parts[2] and f"{vrid}" == parts[4] or f"{vrid}" == parts[5] in line:
                        id = parts[0]
                        print(f"ID: {id}")
                        return f"/interface vrrp remove {id}"
        
        # remove ip pool
        if command == "/ip pool print":
            data_lines = lines[2:]
            ids = []
            
            for line in data_lines:
                #print(line)
                parts = line.split()
                #print(parts)
                if f"{name}" == parts[1] in line:
                    id = parts[0]
                    print(f"ID: {id}")
                    return f"/ip pool remove {id}"
            
        for line in lines:
            line = line.strip()
            if not line:
                continue
            
            if line[0].isdigit():
                if combined_line:
                    #check detete ip firewall mangle
                    if f"{src_address}" and f"{dst_address_list}" in combined_line:
                        id_part = combined_line.split()[0]
                        print(f"ID: {id_part} - {combined_line}")
                        return f"/ip firewall mangle remove {id_part}"
                    
                    #check id delte ip firewall nat
                    elif f"{to_addresses}" and f"{to_ports}" in combined_line:
                        id_part = combined_line.split()[0]
                        print(f"ID: {id_part} - {combined_line}")
                        return f"/ip firewall nat remove {id_part}"
                    
                    elif f"{delete}" in combined_line:
                        id_part = combined_line.split()[0]
                        print(f"ID: {id_part} - {combined_line}")
                        return f"/ip firewall filter remove {id_part}"

                combined_line = line
            else:
                combined_line += " " + line
        
        if combined_line and f"{src_address}" and f"{dst_address_list}" in combined_line:
            id_part = combined_line.split()[0]
            print(f"ID: {id_part} - Line: {combined_line}")
            return f"/ip firewall mangle remove {id_part}"

        elif combined_line and f"{to_addresses}" and f"{to_ports}" in combined_line:
            id_part = combined_line.split()[0]
            print(f"ID: {id_part} - Line: {combined_line}")
            return f"/ip firewall nat remove {id_part}"
        
        elif combined_line and f"{delete}" in combined_line:
            id_part = combined_line.split()[0]
            print(f"ID: {id_part} - Line: {combined_line}")
            return f"/ip firewall filter remove {id_part}"
        
    except Exception as e:
        print(f"Error: {e}")
        
    finally:
        client.close()

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
    file_path = 'mikrotik.txt'  # Path to the first text file (reference)
    file2_path = 'latest_file.txt'  # Path to the second text file (comparison)
    host = '192.168.4.221'
    username = 'admin'
    password = '12345678@Tt'
    
    # Get configuration from the MikroTik device
    get_config_prod(host, username, password, file_path)
    # Compare the two files
    compare_files(file_path, file2_path)