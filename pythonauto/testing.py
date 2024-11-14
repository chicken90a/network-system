# Đọc nội dung của file cũ và file mới
with open('output.txt', 'r') as old_file:
    old_config = old_file.readlines()

with open('file_path.txt', 'r') as new_file:
    new_config = new_file.readlines()

# So sánh hai file và tìm sự thay đổi VLAN
changes = []
for old_line, new_line in zip(old_config, new_config):
    if old_line.strip().startswith("interface") and new_line.strip().startswith("interface"):
        continue  # Bỏ qua các dòng interface
    if "switchport access vlan" in old_line and "switchport access vlan" in new_line:
        old_vlan = old_line.strip().split()[-1]
        new_vlan = new_line.strip().split()[-1]
        if old_vlan != new_vlan:
            interface = old_config[old_config.index(old_line) - 1].strip()  # Lấy dòng interface
            changes.append((interface, old_vlan, new_vlan))

# In ra kết quả
if changes:
    for interface, old_vlan, new_vlan in changes:
        print(f"{interface}: VLAN đã thay đổi từ {old_vlan} sang {new_vlan}")
else:
    print("Không phát hiện thay đổi nào.")
