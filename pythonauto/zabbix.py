from pyzabbix import ZabbixAPI

# Kết nối đến Zabbix server
zabbix_url = "http://ovh-zabbix.rtbsuperhub.com:8080/"
zabbix_user = "hung.ngo"
zabbix_password = "tit$an123"

# Kết nối đến Zabbix API
zapi = ZabbixAPI(zabbix_url)
zapi.login(zabbix_user, zabbix_password)

# Lấy danh sách tất cả các host
hosts = zapi.host.get({
    'output': ['hostid', 'host'],  # Chỉ lấy hostid và host name
})

# Khởi tạo một set để chứa các template id duy nhất
unique_templates = set()

# Duyệt qua từng host và lấy template của nó
for host in hosts:
    host_id = host['hostid']
    # Lấy tất cả các template mà host đang sử dụng
    templates = zapi.host.get({
        'output': ['templateid'],
        'hostids': host_id,
        'selectParentTemplates': 'extend',  # Lấy thông tin template cha
    })
    
    for template in templates:
        # Thêm template id vào set (set sẽ tự động loại bỏ trùng lặp)
        unique_templates.add(template['templateid'])

# Lấy thông tin chi tiết về các template đã loại bỏ trùng lặp
templates_details = zapi.template.get({
    'templateids': list(unique_templates),
    'output': ['templateid', 'host'],
})

# In ra danh sách các template duy nhất
print("Danh sách các template duy nhất từ các host:")
for template in templates_details:
    print(f"Template ID: {template['templateid']}, Template Name: {template['host']}")

