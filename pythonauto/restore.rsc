/disk
set slot1 slot=slot1 type=hardware
set slot2 slot=slot2 type=hardware
set slot3 slot=slot3 type=hardware
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
/ip address
add address=192.168.88.55/24 interface=ether1 network=192.168.88.0
/ip dhcp-client
add interface=ether1