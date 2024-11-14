# 2024-08-23 09:01:18 by RouterOS 7.15.1
# software id = C6Q6-X6JC
#
# model = CCR2004-16G-2S+
# serial number = HFH09FA4J0N
/interface bridge
add disabled=yes name=BR_ether1-WAN1-VNPT-1 port-cost-mode=short
add disabled=yes name=BR_ether3-WAN3-Pepwave-1 port-cost-mode=short
add disabled=yes name=ether4-WAN4-DCNET-181 port-cost-mode=short
/interface ethernet
set [ find default-name=ether1 ] mac-address=48:A9:8A:81:0C:F1 name=\
    ether1-WAN1-VNPT
set [ find default-name=ether2 ] mac-address=48:A9:8A:81:0C:F2 name=\
    ether2-WAN2-LeasedLine
set [ find default-name=ether3 ] mac-address=48:A9:8A:81:0C:F3 name=\
    ether3-WAN3-Pepwave
set [ find default-name=ether4 ] mac-address=48:A9:8A:81:0C:F4 name=\
    ether4-WAN4-VIA-SW
set [ find default-name=ether5 ] mac-address=48:A9:8A:81:0C:F5 name=\
    ether5-WAN5
set [ find default-name=ether6 ] mac-address=48:A9:8A:81:0C:F6 name=\
    ether6-WAN6
set [ find default-name=ether7 ] mac-address=48:A9:8A:81:0C:F7
set [ find default-name=ether8 ] mac-address=48:A9:8A:81:0C:F8
set [ find default-name=ether9 ] mac-address=48:A9:8A:81:0C:F9
set [ find default-name=ether10 ] mac-address=48:A9:8A:81:0C:FA
set [ find default-name=ether11 ] mac-address=48:A9:8A:81:0C:FB
set [ find default-name=ether12 ] mac-address=48:A9:8A:81:0C:FC
set [ find default-name=ether13 ] mac-address=48:A9:8A:81:0C:FD name=\
    ether13-BOND_WAN
set [ find default-name=ether14 ] mac-address=48:A9:8A:81:0C:FE name=\
    ether14-BOND_WAN
set [ find default-name=ether15 ] mac-address=48:A9:8A:81:0C:FF name=\
    ether15-BOND_LAN
set [ find default-name=ether16 ] mac-address=48:A9:8A:81:0D:00 name=\
    ether16-BOND_LAN
set [ find default-name=sfp-sfpplus1 ] auto-negotiation=no mac-address=\
    48:A9:8A:81:0D:02 speed=1G-baseX
set [ find default-name=sfp-sfpplus2 ] mac-address=48:A9:8A:81:0D:01
/interface wireguard
add listen-port=13231 name=WG_VPN
/interface bonding
add mode=active-backup name=Bond_LAN slaves=ether15-BOND_LAN,ether16-BOND_LAN
/interface vlan
add interface=Bond_LAN name=VLAN21 vlan-id=21
add interface=Bond_LAN name=VLAN22 vlan-id=22
add interface=Bond_LAN name=VLAN23 vlan-id=23
add interface=Bond_LAN name=VLAN24 vlan-id=24
add interface=Bond_LAN name=VLAN34 vlan-id=34
add interface=Bond_LAN name=VLAN100 vlan-id=100
add interface=Bond_LAN name=VLAN200 vlan-id=200
add interface=Bond_LAN name=VLAN300 vlan-id=300
add interface=Bond_LAN name=VLAN997 vlan-id=997
add interface=Bond_LAN name=VLAN999 vlan-id=999
add interface=Bond_LAN name=VLAN_ILL vlan-id=998
add interface=Bond_LAN name=VLAN_VRRP vlan-id=199
/interface vrrp
add interface=VLAN_VRRP name=VRRP_INTERFACE priority=200 vrid=199
add interface=VLAN997 name=vrrp997_pppoe-vnpt-87 priority=200 vrid=97
add interface=VLAN999 name=vrrp999_pppoe-dcnet-181 priority=200 vrid=99
/interface pppoe-client
add add-default-route=yes disabled=no interface=vrrp999_pppoe-dcnet-181 name=\
    PPPoE-DCNET-11.181 user=YCTK.TITAN.34BD@DCNET
add add-default-route=yes interface=vrrp997_pppoe-vnpt-87 name=\
    PPPoE-VNPT-53.87 user=cntitan2
/interface list
add name=Demo
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip firewall layer7-protocol
add name=Telegram regexp="\"^.+(telegram.org).*\\\$\""
/ip pool
add comment=Management name=dhcp_pool5 ranges=172.31.21.50-172.31.21.254
add comment="Floor 2" name=dhcp_pool6 ranges=172.31.22.50-172.31.22.254
add comment="Floor 3" name=dhcp_pool7 ranges=172.31.23.50-172.31.23.254
add name=dhcp_pool8 ranges=172.31.24.50-172.31.24.254
add name=dhcp_pool9 ranges=172.31.34.2-172.31.34.254
add name=dhcp_pool11 ranges=\
    172.31.1.3-172.31.1.49,172.31.1.51-172.31.1.99,172.31.1.110-172.31.1.199
/ip dhcp-server
add address-pool=dhcp_pool5 interface=VLAN21 lease-time=1w10m name=dhcp_21
add address-pool=dhcp_pool6 interface=VLAN22 lease-time=1w10m name=dhcp_22
add address-pool=dhcp_pool7 interface=VLAN23 lease-time=1w10m name=dhcp_23
add address-pool=dhcp_pool8 interface=VLAN24 lease-time=1w10m name=dhcp_24
add address-pool=dhcp_pool9 interface=VLAN34 lease-time=1w10m name=dhcp_34
/ip smb users
set [ find default=yes ] disabled=yes
/port
set 0 name=serial0
set 1 name=serial1
/queue type
add kind=pcq name=7m_up pcq-classifier=dst-address pcq-rate=10M \
    pcq-total-limit=10000KiB
add kind=pcq name=7m_down pcq-classifier=dst-address pcq-rate=15M \
    pcq-total-limit=15000KiB
add fq-codel-target=12ms kind=fq-codel name=default_fqcodel
/queue tree
add name=pcq_up_7m packet-mark=upload_7m parent=global queue=7m_up
add name=pcq_down_7m packet-mark=download_7m parent=global queue=7m_down
add max-limit=200M name=FQCodel_Global parent=global queue=default_fqcodel
add limit-at=25M max-limit=50M name=FQCodel_Helpdesk_Conn packet-mark=\
    management_traffic_pack parent=FQCodel_Global queue=default_fqcodel
add disabled=yes limit-at=25M max-limit=50M name=FQCodel_22.0_Conn \
    packet-mark=vlan22_traffic_pack parent=FQCodel_Global queue=\
    default_fqcodel
add disabled=yes limit-at=25M max-limit=50M name=FQCodel_23.0_Conn \
    packet-mark=vlan23_traffic_pack parent=FQCodel_Global queue=\
    default_fqcodel
/routing table
add disabled=no fib name=rt_leasedline_vtc
add disabled=no fib name=rt_pepwave
add disabled=no fib name=rt_vnpt
add disabled=no fib name=rt_dcnet2
add disabled=no fib name=rt_VPN_WG
/snmp community
add addresses=192.168.1.26/32,172.31.21.167/32 name=firewall
/system logging action
set 3 bsd-syslog=yes remote=172.31.21.250
add name=GrayLogServer remote=192.168.1.155 remote-port=20003 target=remote
/interface bridge port
add bridge=BR_ether1-WAN1-VNPT-1 comment=\
    "Attach VLAN to vInterface Bridge ether1-WAN1-VNPT1" interface=VLAN200 \
    internal-path-cost=10 path-cost=10
add bridge=BR_ether3-WAN3-Pepwave-1 comment=\
    "Attach VLAN 100  to vInterface Bridge ether3-WAN3-Pepwave1" interface=\
    VLAN100 internal-path-cost=10 path-cost=10
add bridge=ether4-WAN4-DCNET-181 comment=\
    "Attach VLAN 300 to vInterface Bridge ether4-WAN4-DCNET-2" interface=\
    VLAN300 internal-path-cost=10 path-cost=10
/ip firewall connection tracking
set udp-timeout=10s
/ip neighbor discovery-settings
set discover-interface-list=none
/ipv6 settings
set disable-ipv6=yes forward=no
/interface bridge vlan
add bridge=BR_ether1-WAN1-VNPT-1 vlan-ids=200
add bridge=BR_ether3-WAN3-Pepwave-1 vlan-ids=100
add bridge=ether4-WAN4-DCNET-181 disabled=yes vlan-ids=300
/interface wireguard peers
add allowed-address=0.0.0.0/0 endpoint-address=115.75.223.157 endpoint-port=\
    13231 interface=WG_VPN name=LS_PEER public-key=\
    "7nFuU+u0jsI4zvl/X8StWjjRrwrudlejoV7LBEcEvR4="
/ip address
add address=172.31.21.1/24 interface=VLAN21 network=172.31.21.0
add address=172.31.22.1/24 interface=VLAN22 network=172.31.22.0
add address=172.31.23.1/24 interface=VLAN23 network=172.31.23.0
add address=172.31.24.1/24 interface=VLAN24 network=172.31.24.0
add address=172.31.34.1/24 interface=VLAN34 network=172.31.34.0
add address=172.31.2.1/24 interface=VLAN200 network=172.31.2.0
add address=192.168.200.1/24 interface=ether11 network=192.168.200.0
add address=10.0.99.10/24 interface=VLAN999 network=10.0.99.0
add address=10.0.99.1/24 interface=vrrp999_pppoe-dcnet-181 network=10.0.99.0
add address=118.107.96.20/24 interface=VLAN_ILL network=118.107.96.0
add address=10.0.97.10/24 interface=VLAN997 network=10.0.97.0
add address=10.0.97.1/24 interface=vrrp997_pppoe-vnpt-87 network=10.0.97.0
add address=10.10.10.10/24 interface=VLAN_VRRP network=10.10.10.0
add address=10.10.10.1/24 interface=VRRP_INTERFACE network=10.10.10.0
add address=172.31.1.1/24 interface=VLAN100 network=172.31.1.0
add address=10.200.0.1/24 interface=WG_VPN network=10.200.0.0
/ip dhcp-server lease
add address=172.31.22.232 client-id=1:74:56:3c:1d:e4:c1 mac-address=\
    74:56:3C:1D:E4:C1 server=dhcp_22
add address=172.31.23.149 client-id=1:8a:9a:f9:63:38:24 mac-address=\
    8A:9A:F9:63:38:24 server=dhcp_23
add address=172.31.21.167 mac-address=E2:D4:8C:54:CC:E1 server=dhcp_21
/ip dhcp-server network
add address=172.31.1.0/24 dns-server=8.8.8.8,8.8.4.4 gateway=172.31.1.200
add address=172.31.21.0/24 dns-server=172.31.21.254,192.168.1.11 gateway=\
    172.31.21.1
add address=172.31.22.0/24 dns-server=172.31.21.254,192.168.1.11 gateway=\
    172.31.22.1
add address=172.31.23.0/24 dns-server=172.31.21.254,192.168.1.11 gateway=\
    172.31.23.1
add address=172.31.24.0/24 dns-server=192.168.1.11,192.168.1.12 gateway=\
    172.31.24.1
add address=172.31.34.0/24 dns-server=8.8.8.8,8.8.4.4 gateway=172.31.34.1
/ip dns
set servers=8.8.8.8,8.8.4.4
/ip firewall address-list
add address=172.31.1.0/24 list=Pepwave_Network
add address=172.31.21.0/24 list=Management_Network
add address=172.31.22.0/24 list=Users_Network
add address=172.31.23.0/24 list=Users_Network
add address=172.31.24.0/24 list=Users_Network
add address=172.31.21.248 list=RDP_LST
add address=172.31.2.0/24 list=Draytek_VNPT_Network
add address=172.31.21.31 list=CAM_LIST
add address=172.31.21.32 list=CAM_LIST
add address=172.31.21.33 list=CAM_LIST
add address=172.31.21.34 list=CAM_LIST
add address=172.31.21.35 list=CAM_LIST
add address=172.31.21.36 list=CAM_LIST
add address=172.31.21.37 list=CAM_LIST
add address=172.31.21.38 list=CAM_LIST
add address=172.31.21.39 list=CAM_LIST
add address=172.31.21.40 list=CAM_LIST
add address=172.31.21.41 list=CAM_LIST
add address=172.31.21.42 list=CAM_LIST
add address=172.31.21.43 list=CAM_LIST
add address=172.31.21.44 list=CAM_LIST
add address=172.31.21.45 list=CAM_LIST
add address=172.31.21.46 list=CAM_LIST
add address=172.31.34.0/24 list=Guest_Personal_Network
add address=172.16.16.109 list=Auto_QA_DL
add address=172.16.16.157 list=Auto_QA_DL
add address=172.31.23.145 list=RDP_LST
add address=172.31.23.231 list=RDP_LST
add address=172.31.22.212 list=RDP_LST
add address=172.31.23.241 list=RDP_LST
add address=172.31.23.177 list=RDP_LST
add address=172.31.23.221 list=RDP_LST
add address=172.31.22.207 list=RDP_LST
add address=172.31.23.154 list=RDP_LST
add address=172.31.22.217 list=RDP_LST
add address=172.31.23.192 list=RDP_LST
add address=172.31.23.83 list=RDP_LST
add address=172.31.22.187 list=RDP_LST
add address=172.31.23.180 list=RDP_LST
add address=172.31.23.179 list=RDP_LST
add address=172.31.22.218 list=RDP_LST
add address=172.31.23.159 list=RDP_LST
add address=172.31.22.205 list=RDP_LST
add address=172.31.22.182 list=RDP_LST
add address=172.31.22.224 list=RDP_LST
add address=172.31.22.126 list=RDP_LST
add address=172.31.22.190 disabled=yes list=RDP_LST
add address=172.31.22.186 list=RDP_LST
add address=172.31.22.204 list=RDP_LST
add address=172.31.22.206 list=RDP_LST
add address=172.31.22.229 list=RDP_LST
add address=172.31.22.193 list=RDP_LST
add address=172.31.23.181 list=RDP_LST
add address=172.31.22.213 list=RDP_LST
add address=172.31.22.176 list=RDP_LST
add address=172.31.22.178 list=RDP_LST
add address=172.31.22.180 disabled=yes list=RDP_LST
add address=172.31.22.177 list=RDP_LST
add address=172.31.22.181 list=RDP_LST
add address=172.31.22.208 list=RDP_LST
add address=172.31.22.219 list=RDP_LST
add address=172.31.23.147 list=RDP_LST
add address=172.31.23.151 list=RDP_LST
add address=172.31.23.125 list=RDP_LST
add address=172.31.23.196 list=RDP_LST
add address=172.31.23.226 list=RDP_LST
add address=172.31.23.250 list=RDP_LST
add address=172.31.23.170 list=RDP_LST
add address=172.31.23.189 list=RDP_LST
add address=172.31.23.193 disabled=yes list=RDP_LST
add address=172.31.23.223 list=RDP_LST
add address=172.31.23.82 list=RDP_LST
add address=172.31.23.199 list=RDP_LST
add address=172.31.23.120 list=RDP_LST
add address=172.31.23.140 list=RDP_LST
add address=172.31.3.0/24 list=Draytek_DCNet_Network
add address=172.31.23.158 disabled=yes list=RDP_LST
add address=172.31.23.86 list=RDP_LST
add address=172.31.23.126 list=RDP_LST
add address=172.31.23.160 disabled=yes list=RDP_LST
add address=172.31.23.213 disabled=yes list=RDP_LST
add address=172.31.23.197 disabled=yes list=RDP_LST
add address=172.31.23.209 list=RDP_LST
add address=172.31.23.166 list=RDP_LST
add address=172.31.22.230 list=RDP_LST
add address=172.31.23.162 list=RDP_LST
add address=172.31.23.168 list=RDP_LST
add address=172.31.23.106 list=RDP_LST
add address=172.31.23.163 list=RDP_LST
add address=172.31.23.207 list=RDP_LST
add address=172.31.23.104 list=RDP_LST
add address=172.31.23.249 list=RDP_LST
add address=172.31.21.232 list=RDP_LST
add address=172.31.22.237 list=RDP_LST
add address=172.31.22.233 list=RDP_LST
add address=172.31.22.203 list=RDP_LST
add address=172.31.22.231 list=RDP_LST
add address=172.31.23.206 list=RDP_LST
add address=172.31.23.198 list=RDP_LST
add address=172.31.23.169 disabled=yes list=RDP_LST
add address=172.31.22.254 list=RDP_LST
add address=172.31.22.200 list=RDP_LST
add address=172.31.23.235 disabled=yes list=RDP_LST
add address=172.31.23.186 list=RDP_LST
add address=172.31.22.220 list=RDP_LST
add address=172.31.23.182 list=RDP_LST
add address=172.31.23.171 list=RDP_LST
add address=172.31.23.156 list=RDP_LST
add address=172.31.23.208 list=RDP_LST
add address=172.31.23.243 list=RDP_LST
add address=172.31.22.212 list=Auto_QA_BD
add address=172.31.22.217 list=Auto_QA_BD
add address=172.31.22.221 list=Auto_QA_BD
add address=172.31.22.206 list=Auto_QA_BD
add address=172.31.22.197 list=Auto_QA_BD
add address=172.31.22.207 list=Auto_QA_BD
add address=172.31.23.128 list=RDP_LST
add address=172.31.22.192 disabled=yes list=RDP_LST
add address=172.31.22.153 list=RDP_LST
add address=172.31.22.189 list=RDP_LST
add address=172.31.23.150 list=RDP_LST
add address=172.31.22.209 list=RDP_LST
add address=172.31.23.143 list=RDP_LST
add address=172.31.23.251 list=RDP_LST
add address=172.31.22.150 list=RDP_LST
add address=172.31.23.194 list=RDP_LST
add address=172.31.23.111 list=RDP_LST
add address=172.31.23.71 list=RDP_LST
add address=172.31.23.148 list=RDP_LST
add address=172.31.22.146 disabled=yes list=RDP_LST
add address=172.31.21.237 list=RDP_LST
add address=172.31.23.184 list=RDP_LST
add address=172.31.23.232 list=RDP_LST
add address=172.31.23.237 list=RDP_LST
add address=172.31.22.190 list=FansMetrics
add address=172.31.22.189 list=FansMetrics
add address=172.31.22.153 list=FansMetrics
add address=172.31.22.190 list=RDP_LST
add address=172.31.23.100 list=RDP_LST
add address=172.31.22.129 list=RDP_LST
add address=172.31.23.190 list=RDP_LST
add address=172.31.23.200 list=RDP_LST
add address=172.31.23.62 list=RDP_LST
add address=172.31.23.73 list=RDP_LST
add address=172.16.12.63 list=RDP_LST
add address=172.31.23.183 list=RDP_LST
add address=172.31.22.122 list=RDP_LST
add address=172.31.22.174 list=RDP_LST
add address=172.31.23.70 list=RDP_LST
add address=172.31.23.134 list=RDP_LST
add address=172.31.22.232 list=RDP_LST
add address=172.31.23.195 list=RDP_LST
add address=172.31.23.75 list=RDP_LST
add address=172.31.23.67 list=RDP_LST
add address=172.31.22.167 list=RDP_LST
add address=172.31.23.175 list=RDP_LST
add address=172.31.23.84 list=RDP_LST
add address=172.31.21.171 list=RDP_LST
add address=172.31.23.81 list=RDP_LST
add address=172.31.23.218 list=RDP_LST
add address=172.31.23.79 list=RDP_LST
add address=172.31.22.113 list=RDP_LST
add address=172.31.22.113 list=Auto_QA_BD
add address=172.31.22.210 list=Auto_QA_BD
add address=172.31.22.122 list=Auto_QA_BD
add address=172.31.23.107 list=RDP_LST
add address=172.31.23.65 list=RDP_LST
add address=172.31.23.64 list=RDP_LST
add address=172.31.23.63 list=RDP_LST
add address=172.31.23.164 list=RDP_LST
add address=172.31.22.178 list=Auto_QA_BD
add address=203.167.11.181 list=IP_PUBLIC_BD
add address=203.167.11.151 list=IP_PUBLIC_BD
add address=118.107.96.20 list=IP_PUBLIC_BD
add address=222.253.53.117 list=IP_PUBLIC_BD
add address=222.253.53.87 list=IP_PUBLIC_BD
add address=172.31.22.193 list=Auto_QA_BD
add address=172.31.22.204 list=Auto_QA_BD
add address=172.31.23.52 list=RDP_LST
add address=172.31.22.114 list=Auto_QA_BD
add address=172.31.23.77 list=RDP_LST
/ip firewall filter
add action=drop chain=forward comment="Drop Telegram" dst-address=\
    149.154.167.99 src-address-list=""
add action=accept chain=forward comment=\
    "Allow: Users_network access basic apps/ports" dst-port=\
    80,443,3389,53,67,68,22,23,25,465,587,993,995,515,1433 protocol=tcp
add action=accept chain=forward dst-port=53,67,68,22,23,515,88,9993 protocol=\
    udp
add action=drop chain=forward comment=\
    "Block: Users_netwrok access to Dalat Network" dst-address=172.16.14.0/24 \
    src-address-list=Users_Network
add action=drop chain=forward dst-address=172.16.15.0/24 src-address-list=\
    Users_Network
add action=drop chain=forward disabled=yes dst-address=172.16.16.0/24 \
    src-address-list=Users_Network
add action=drop chain=forward dst-address=172.16.18.0/24 src-address-list=\
    Users_Network
add action=accept chain=forward dst-port=389,445,80 protocol=tcp
add action=drop chain=forward comment=\
    "Drop all TCP and UDP port and Allow basic ports" disabled=yes dst-port=\
    !80,443,3389,53,67,68,22,23,25,465,587,993,995,515,1433 protocol=tcp
/ip firewall mangle
add action=accept chain=prerouting comment=\
    "Allow subnet 21 reach to Mikrotik" dst-address=172.31.21.1 src-address=\
    172.31.21.0/24
add action=accept chain=prerouting comment=\
    "Allow subnet 21 reach to IP PUBLIC" dst-address-list=IP_PUBLIC_BD \
    src-address=172.31.21.0/24
add action=accept chain=prerouting comment=\
    "Allow subnet 21 reach to Mikrotik" dst-address=172.31.1.0/24 \
    src-address=172.31.21.0/24
add action=accept chain=prerouting disabled=yes dst-address=172.31.21.0/24 \
    src-address=172.31.1.0/24
add action=accept chain=prerouting comment="Allow subnet 21 reach to 2.0/24" \
    dst-address=172.31.2.0/24 src-address=172.31.21.0/24
add action=accept chain=prerouting dst-address=172.31.21.0/24 src-address=\
    172.31.2.0/24
add action=accept chain=prerouting comment="Allow subnet 21 reach to 3.0/24" \
    dst-address=172.31.3.0/24 src-address=172.31.21.0/24
add action=accept chain=prerouting dst-address=172.31.21.0/24 src-address=\
    172.31.3.0/24
add action=accept chain=prerouting comment=\
    "Allow Hai IT reach to 12.0 , 4.0 , 16.0" dst-address=172.16.12.0/24 \
    src-address=172.31.21.171
add action=accept chain=prerouting dst-address=192.168.4.0/24 src-address=\
    172.31.21.171
add action=accept chain=prerouting dst-address=172.16.16.0/24 src-address=\
    172.31.21.171
add action=accept chain=prerouting comment="Test changerequest tpm" \
    dst-address=192.168.4.0/24 src-address=172.31.21.0/24
add action=accept chain=prerouting dst-address=172.16.16.0/24 src-address=\
    172.31.21.0/24
add action=accept chain=prerouting comment=\
    "Allow subnet 21 reach to other subnets" dst-address-list=Users_Network \
    src-address-list=Management_Network
add action=accept chain=prerouting dst-address-list=Management_Network \
    src-address-list=Users_Network
add action=accept chain=prerouting comment="Allow Auto QC DL - Autotest" \
    dst-address=172.31.22.210 src-address-list=Auto_QA_DL
add action=accept chain=prerouting dst-address-list=Auto_QA_DL src-address=\
    172.31.22.210
add action=accept chain=prerouting comment="Allow Auto QC BD- LS" \
    dst-address-list=Auto_QA_BD src-address=192.168.4.0/24
add action=accept chain=prerouting dst-address=192.168.4.0/24 \
    src-address-list=Auto_QA_BD
add action=accept chain=prerouting comment=\
    "Allow Bao  IT access Users_Network on BD" dst-address-list=Users_Network \
    src-address=172.16.16.150
add action=accept chain=prerouting dst-address=172.16.16.150 \
    src-address-list=Users_Network
add action=accept chain=prerouting dst-address-list=Management_Network \
    src-address=172.16.16.150
add action=accept chain=prerouting dst-address=172.16.16.150 \
    src-address-list=Management_Network
add action=accept chain=prerouting comment=\
    "Allow CameraStorage Access Subnet 21.0" dst-address-list=\
    Management_Network src-address=172.16.15.250
add action=accept chain=prerouting dst-address=172.16.15.250 \
    src-address-list=Management_Network
add action=accept chain=prerouting comment="Allow 12.0 access 22.0" \
    dst-address=172.31.22.0/24 src-address=172.16.12.0/24
add action=accept chain=prerouting dst-address=172.16.12.0/24 src-address=\
    172.31.22.0/24
add action=accept chain=prerouting comment="Allow 192.168.4.0 access 23.0" \
    dst-address=172.31.23.0/24 src-address=192.168.4.0/24
add action=accept chain=prerouting dst-address=192.168.4.0/24 src-address=\
    172.31.23.0/24
add action=accept chain=prerouting comment="Allow 12.0 access 23.0" \
    dst-address=172.31.23.0/24 src-address=172.16.12.0/24
add action=accept chain=prerouting dst-address=172.16.12.0/24 src-address=\
    172.31.23.0/24
add action=accept chain=prerouting comment=\
    "Allow 12.106 access 21.0 ( Tam devops)" dst-address=172.31.21.0/24 \
    src-address=172.16.12.87
add action=accept chain=prerouting dst-address=172.16.12.87 src-address=\
    172.31.21.0/24
add action=accept chain=prerouting comment=\
    "Allow 10.128 access 21.251 ( Son devops)" dst-address=172.31.21.0/24 \
    src-address=172.16.10.128
add action=accept chain=prerouting dst-address=172.16.10.128 src-address=\
    172.31.21.0/24
add action=accept chain=prerouting comment=\
    "Allow 12.87 access 21.0 ( Phong devops)" dst-address=172.31.21.0/24 \
    src-address=172.16.12.106
add action=accept chain=prerouting dst-address=172.16.12.106 src-address=\
    172.31.21.0/24
add action=accept chain=prerouting comment=\
    "Allow 12.87 access 22.0 ( Phong devops)" dst-address=172.31.22.0/24 \
    src-address=172.16.12.106
add action=accept chain=prerouting dst-address=172.16.12.106 src-address=\
    172.31.22.0/24
add action=mark-routing chain=prerouting comment=\
    "Prerouting to separate FTTH Lines" new-routing-mark=rt_pepwave \
    passthrough=yes src-address=172.31.34.0/24
add action=mark-routing chain=prerouting new-routing-mark=rt_pepwave \
    passthrough=yes src-address=172.31.24.0/24
add action=mark-routing chain=prerouting new-routing-mark=rt_pepwave \
    passthrough=yes src-address=172.31.23.0/25
add action=mark-routing chain=prerouting new-routing-mark=rt_pepwave \
    passthrough=yes src-address=172.31.23.128/25
add action=mark-routing chain=prerouting new-routing-mark=rt_pepwave \
    passthrough=yes src-address=172.31.22.0/24
add action=mark-routing chain=prerouting new-routing-mark=rt_pepwave \
    passthrough=yes src-address=172.31.21.0/24
add action=mark-routing chain=prerouting comment="172.31.21.221 to 3.100" \
    dst-address=192.168.3.100 new-routing-mark=rt_VPN_WG passthrough=yes \
    src-address=172.31.21.221
add action=mark-routing chain=prerouting comment="10.200.0.2 to rt_VPN_WG" \
    new-routing-mark=rt_VPN_WG passthrough=no src-address=10.200.0.2
add action=mark-routing chain=prerouting comment="Prerouting for BD Bastion" \
    new-routing-mark=rt_pepwave passthrough=yes src-address=172.31.21.100
add action=mark-routing chain=prerouting disabled=yes new-routing-mark=\
    rt_dcnet2 passthrough=yes src-address=172.31.21.101
add action=mark-routing chain=prerouting disabled=yes new-routing-mark=\
    rt_vnpt passthrough=yes src-address=172.31.21.102
add action=mark-routing chain=prerouting new-routing-mark=rt_leasedline_vtc \
    passthrough=yes src-address=172.31.21.103
add action=mark-routing chain=prerouting disabled=yes new-routing-mark=\
    rt_pepwave passthrough=yes src-address=172.31.21.104
add action=mark-connection chain=prerouting comment=\
    "Declare: Prerouting with Mark Connection as rdp_connection" dst-address=\
    118.107.96.20 dst-port=43899,33333-33736 new-connection-mark=\
    rdp_connection passthrough=yes protocol=tcp
add action=mark-routing chain=prerouting comment="Declare: Prerouting with Mar\
    k Routing any package mark_connection as rdp_connection will choose route_\
    table rt_leasedline_vtc" connection-mark=rdp_connection new-routing-mark=\
    rt_leasedline_vtc passthrough=yes protocol=tcp src-address-list=RDP_LST \
    src-port=3389,33333-33736
add action=mark-connection chain=prerouting comment=\
    "Declare: Prerouting with Mark Connection as cam_connection" dst-address=\
    118.107.96.20 dst-port=23679-23694 log=yes new-connection-mark=\
    cam_connection passthrough=yes protocol=tcp
add action=mark-routing chain=prerouting comment="Declare: Prerouting with Mar\
    k Routing any package mark_connection as cam_connection will choose route_\
    table rt_leasedline_vtc" connection-mark=cam_connection log=yes \
    new-routing-mark=rt_leasedline_vtc passthrough=yes protocol=tcp \
    src-address-list=CAM_LIST src-port=23679-23694
add action=mark-connection chain=prerouting comment="Declare: Prerouting with \
    Mark Connection as rdp_connection2 via 172.31.3.1 ( test remote with dcnet\
    )" disabled=yes dst-address=172.31.3.1 dst-port=33465 \
    new-connection-mark=rdp_connection_2 passthrough=yes protocol=tcp
add action=mark-routing chain=prerouting comment="Declare: Prerouting with Mar\
    k Routing any package mark_connection as rdp_connection_2 will choose rout\
    e_table rt_dcnet2 ( test remote with dcnet)" connection-mark=\
    rdp_connection_2 disabled=yes new-routing-mark=rt_dcnet2 passthrough=yes \
    protocol=tcp src-address-list=RDP_LST src-port=33465
add action=mark-packet chain=prerouting comment="Limit Bandwidth" disabled=\
    yes in-interface=BR_ether1-WAN1-VNPT-1 new-packet-mark=download_7m \
    passthrough=yes
add action=mark-packet chain=prerouting disabled=yes in-interface=\
    BR_ether3-WAN3-Pepwave-1 new-packet-mark=download_7m passthrough=yes
add action=mark-packet chain=prerouting disabled=yes in-interface=\
    ether2-WAN2-LeasedLine new-packet-mark=download_7m passthrough=yes
add action=mark-packet chain=prerouting disabled=yes in-interface=\
    ether4-WAN4-DCNET-181 new-packet-mark=download_7m passthrough=yes
add action=mark-packet chain=prerouting disabled=yes in-interface=*1F \
    new-packet-mark=upload_7m passthrough=yes
/ip firewall nat
add action=masquerade chain=srcnat comment="NAT Outsite" out-interface=\
    VLAN200
add action=masquerade chain=srcnat out-interface=VLAN_ILL
add action=masquerade chain=srcnat out-interface=VLAN100
add action=masquerade chain=srcnat out-interface=PPPoE-DCNET-11.181
add action=masquerade chain=srcnat comment="Test out internet via WG_VPN" \
    disabled=yes out-interface=WG_VPN
add action=dst-nat chain=dstnat comment="NAT Inside for camera" dst-address=\
    118.107.96.20 dst-port=23679 protocol=tcp to-addresses=172.31.21.31 \
    to-ports=23679
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=23680 \
    protocol=tcp to-addresses=172.31.21.32 to-ports=23680
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=23681 \
    protocol=tcp to-addresses=172.31.21.33 to-ports=23681
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=23682 \
    protocol=tcp to-addresses=172.31.21.34 to-ports=23682
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=23683 log=\
    yes protocol=tcp to-addresses=172.31.21.35 to-ports=23683
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=23684 \
    protocol=tcp to-addresses=172.31.21.36 to-ports=23684
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=23685 \
    protocol=tcp to-addresses=172.31.21.37 to-ports=23685
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=23686 \
    protocol=tcp to-addresses=172.31.21.38 to-ports=23686
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=23687 \
    protocol=tcp to-addresses=172.31.21.39 to-ports=23687
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=23688 \
    protocol=tcp to-addresses=172.31.21.40 to-ports=23688
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=23689 \
    protocol=tcp to-addresses=172.31.21.41 to-ports=23689
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=23690 \
    protocol=tcp to-addresses=172.31.21.42 to-ports=23690
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=23691 \
    protocol=tcp to-addresses=172.31.21.43 to-ports=23691
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=23692 \
    protocol=tcp to-addresses=172.31.21.44 to-ports=23692
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=23693 \
    protocol=tcp to-addresses=172.31.21.45 to-ports=23693
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=23694 \
    protocol=tcp to-addresses=172.31.21.46 to-ports=23694
add action=dst-nat chain=dstnat comment="NAT Inside for remote" dst-address=\
    118.107.96.20 dst-port=43899 log=yes protocol=tcp to-addresses=\
    172.31.21.248 to-ports=3389
add action=dst-nat chain=dstnat comment="NAT Inside for remote" dst-address=\
    118.107.96.20 dst-port=33522 protocol=tcp to-addresses=172.31.23.107 \
    to-ports=33522
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33345 \
    protocol=tcp to-addresses=172.31.23.156 to-ports=33345
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33409 \
    protocol=tcp to-addresses=172.31.23.241 to-ports=33409
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33549 \
    protocol=tcp to-addresses=172.31.23.231 to-ports=33549
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33418 \
    protocol=tcp to-addresses=172.31.22.113 to-ports=33418
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33638 \
    protocol=tcp to-addresses=172.31.23.221 to-ports=33638
add action=dst-nat chain=dstnat disabled=yes dst-address=118.107.96.20 \
    dst-port=9993 protocol=udp to-addresses=172.31.22.126 to-ports=9993
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33422 \
    protocol=tcp to-addresses=172.31.22.207 to-ports=33422
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33358 \
    protocol=tcp to-addresses=172.31.23.63 to-ports=33358
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33622 \
    protocol=tcp to-addresses=172.31.23.192 to-ports=33622
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33421 \
    protocol=tcp to-addresses=172.31.23.83 to-ports=33421
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33399 \
    protocol=tcp to-addresses=172.31.22.187 to-ports=33399
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33590 \
    protocol=tcp to-addresses=172.31.23.180 to-ports=33590
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33395 \
    protocol=tcp to-addresses=172.31.23.179 to-ports=33395
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33416 \
    protocol=tcp to-addresses=172.31.22.218 to-ports=33416
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33460 \
    protocol=tcp to-addresses=172.31.23.218 to-ports=33460
add action=dst-nat chain=dstnat disabled=yes dst-address=118.107.96.20 \
    dst-port=33578 protocol=tcp to-addresses=172.31.22.205 to-ports=33578
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33594 \
    protocol=tcp to-addresses=172.31.22.182 to-ports=33594
add action=dst-nat chain=dstnat disabled=yes dst-address=118.107.96.20 \
    dst-port=33435 protocol=tcp to-addresses=172.31.22.225 to-ports=33435
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33653 \
    protocol=tcp to-addresses=172.31.22.191 to-ports=33653
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33490 \
    protocol=tcp to-addresses=172.31.22.186 to-ports=33490
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33442 \
    protocol=tcp to-addresses=172.31.22.206 to-ports=33442
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33347 \
    protocol=tcp to-addresses=172.31.22.229 to-ports=33347
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33467 \
    protocol=tcp to-addresses=172.31.22.193 to-ports=33467
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33436 \
    protocol=tcp to-addresses=172.31.23.181 to-ports=33436
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33613 \
    protocol=tcp to-addresses=172.31.22.213 to-ports=33613
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33526 \
    protocol=tcp to-addresses=172.31.22.167 to-ports=33526
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33580 \
    protocol=tcp to-addresses=172.31.22.178 to-ports=33580
add action=dst-nat chain=dstnat disabled=yes dst-address=118.107.96.20 \
    dst-port=33535 protocol=tcp to-addresses=172.31.22.150 to-ports=33535
add action=dst-nat chain=dstnat disabled=yes dst-address=118.107.96.20 \
    dst-port=33521 protocol=tcp to-addresses=172.31.22.180 to-ports=33521
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33539 \
    protocol=tcp to-addresses=172.31.22.177 to-ports=33539
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33412 \
    protocol=tcp to-addresses=172.31.22.181 to-ports=33412
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33472 \
    protocol=tcp to-addresses=172.31.22.208 to-ports=33472
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33353 \
    protocol=tcp to-addresses=172.31.22.219 to-ports=33353
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33343 \
    protocol=tcp to-addresses=172.31.23.147 to-ports=33343
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33514 \
    protocol=tcp to-addresses=172.31.23.151 to-ports=33514
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33449 \
    protocol=tcp to-addresses=172.31.23.125 to-ports=33449
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33428 \
    protocol=tcp to-addresses=172.31.23.196 to-ports=33428
add action=dst-nat chain=dstnat disabled=yes dst-address=118.107.96.20 \
    dst-port=33608 protocol=tcp to-addresses=172.31.23.226 to-ports=33608
add action=dst-nat chain=dstnat disabled=yes dst-address=118.107.96.20 \
    dst-port=33513 protocol=tcp to-addresses=172.31.23.250 to-ports=33513
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33597 \
    protocol=tcp to-addresses=172.31.23.170 to-ports=33597
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33389 \
    protocol=tcp to-addresses=172.31.23.189 to-ports=33389
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33397 \
    protocol=tcp to-addresses=172.31.23.223 to-ports=33397
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33551 \
    protocol=tcp to-addresses=172.31.23.82 to-ports=33551
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33628 \
    protocol=tcp to-addresses=172.31.23.66 to-ports=33628
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33453 \
    protocol=tcp to-addresses=172.31.23.65 to-ports=33453
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33576 \
    protocol=tcp to-addresses=172.31.23.79 to-ports=33576
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33556 \
    protocol=tcp to-addresses=172.31.23.140 to-ports=33556
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33390 \
    protocol=tcp to-addresses=172.31.23.158 to-ports=33390
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33414 \
    protocol=tcp to-addresses=172.31.23.86 to-ports=33414
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33398 \
    protocol=tcp to-addresses=172.31.23.77 to-ports=33398
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33507 \
    protocol=tcp to-addresses=172.31.23.160 to-ports=33507
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33352 \
    protocol=tcp to-addresses=172.31.23.213 to-ports=33352
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33424 \
    protocol=tcp to-addresses=172.31.23.197 to-ports=33424
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33440 \
    protocol=tcp to-addresses=172.31.23.64 to-ports=33440
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33544 \
    protocol=tcp to-addresses=172.31.23.166 to-ports=33544
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33434 \
    protocol=tcp to-addresses=172.31.22.217 to-ports=33434
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33664 \
    protocol=tcp to-addresses=172.31.22.230 to-ports=33664
add action=dst-nat chain=dstnat disabled=yes dst-address=118.107.96.20 \
    dst-port=33602 protocol=tcp to-addresses=172.31.23.162 to-ports=33602
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33562 \
    protocol=tcp to-addresses=172.31.23.168 to-ports=33562
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33577 \
    protocol=tcp to-addresses=172.31.23.163 to-ports=33577
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33621 \
    protocol=tcp to-addresses=172.31.23.157 to-ports=33621
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33464 \
    protocol=tcp to-addresses=172.31.22.181 to-ports=33464
add action=dst-nat chain=dstnat dst-address=172.31.3.1 dst-port=33465 \
    protocol=tcp to-addresses=172.31.21.165 to-ports=33465
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33647 \
    protocol=tcp to-addresses=172.31.22.237 to-ports=33647
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33404 \
    protocol=tcp to-addresses=172.31.22.203 to-ports=33404
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33659 \
    protocol=tcp to-addresses=172.31.22.231 to-ports=33659
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33417 \
    protocol=tcp to-addresses=172.31.23.206 to-ports=33417
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33564 \
    protocol=tcp to-addresses=172.31.23.198 to-ports=33564
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33373 \
    protocol=tcp to-addresses=172.31.23.169 to-ports=33373
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33690 \
    protocol=tcp to-addresses=172.31.22.200 to-ports=33690
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33505 \
    protocol=tcp to-addresses=172.31.23.81 to-ports=33505
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33348 \
    protocol=tcp to-addresses=172.31.22.220 to-ports=33348
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33581 \
    protocol=tcp to-addresses=172.31.23.182 to-ports=33581
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33456 \
    protocol=tcp to-addresses=172.31.23.171 to-ports=33456
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33709 \
    protocol=tcp to-addresses=172.31.21.232 to-ports=33712
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33712 \
    protocol=tcp to-addresses=172.31.21.232 to-ports=33712
add action=dst-nat chain=dstnat disabled=yes dst-address=118.107.96.20 \
    dst-port=33632 protocol=tcp to-addresses=172.31.23.208 to-ports=33632
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33571 \
    protocol=tcp to-addresses=172.31.23.232 to-ports=33571
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33504 \
    protocol=tcp to-addresses=172.31.23.243 to-ports=33504
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33355 \
    protocol=tcp to-addresses=172.31.23.84 to-ports=33355
add action=dst-nat chain=dstnat disabled=yes dst-address=118.107.96.20 \
    dst-port=33340 protocol=tcp to-addresses=172.31.22.192 to-ports=33340
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33338 \
    protocol=tcp to-addresses=172.31.22.153 to-ports=33338
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33342 \
    protocol=tcp to-addresses=172.31.22.189 to-ports=33342
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33635 \
    protocol=tcp to-addresses=172.31.23.150 to-ports=33635
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33661 \
    protocol=tcp to-addresses=172.31.22.209 to-ports=33661
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33365 \
    protocol=tcp to-addresses=172.31.23.251 to-ports=33365
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33539 \
    protocol=tcp to-addresses=172.31.22.177 to-ports=33539
add action=dst-nat chain=dstnat disabled=yes dst-address=118.107.96.20 \
    dst-port=33613 protocol=tcp to-addresses=172.31.22.213 to-ports=33613
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33514 \
    protocol=tcp to-addresses=172.31.23.151 to-ports=33514
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33413 \
    protocol=tcp to-addresses=172.31.22.204 to-ports=33413
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33355 \
    protocol=tcp to-addresses=172.31.23.128 to-ports=33355
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33714 \
    protocol=tcp to-addresses=172.31.23.111 to-ports=33714
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33393 \
    protocol=tcp to-addresses=172.31.23.71 to-ports=33393
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33700 \
    protocol=tcp to-addresses=172.31.23.148 to-ports=33700
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33350 \
    protocol=tcp to-addresses=172.31.22.146 to-ports=33350
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33655 \
    protocol=tcp to-addresses=172.31.21.237 to-ports=33655
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33667 \
    protocol=tcp to-addresses=172.31.23.184 to-ports=33667
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33349 \
    protocol=tcp to-addresses=172.31.23.232 to-ports=33349
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33346 \
    protocol=tcp to-addresses=172.31.23.237 to-ports=33346
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33624 \
    protocol=tcp to-addresses=172.31.23.100 to-ports=33624
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33462 \
    protocol=tcp to-addresses=172.31.22.129 to-ports=33462
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33595 \
    protocol=tcp to-addresses=172.31.23.190 to-ports=33595
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33696 \
    protocol=tcp to-addresses=172.31.23.200 to-ports=33696
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33335 \
    protocol=tcp to-addresses=172.31.23.52 to-ports=33335
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33649 \
    protocol=tcp to-addresses=172.31.23.73 to-ports=33649
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33591 \
    protocol=tcp to-addresses=172.31.23.183 to-ports=33591
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33569 \
    protocol=tcp to-addresses=172.31.22.122 to-ports=33569
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33479 \
    protocol=tcp to-addresses=172.31.22.174 to-ports=33479
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33555 \
    protocol=tcp to-addresses=172.31.23.70 to-ports=33555
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33485 \
    protocol=tcp to-addresses=172.31.23.134 to-ports=33485
add action=dst-nat chain=dstnat disabled=yes dst-address=118.107.96.20 \
    dst-port=33663 protocol=tcp to-addresses=172.31.22.232 to-ports=33663
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33548 \
    protocol=tcp to-addresses=172.31.23.195 to-ports=33548
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33375 \
    protocol=tcp to-addresses=172.31.23.75 to-ports=33375
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33697 \
    protocol=tcp to-addresses=172.31.23.67 to-ports=33697
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33623 \
    protocol=tcp to-addresses=172.31.23.175 to-ports=33623
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33480 \
    protocol=tcp to-addresses=172.31.21.171 to-ports=33480
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33628 \
    protocol=tcp to-addresses=172.31.23.216 to-ports=33628
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33546 \
    protocol=tcp to-addresses=172.31.23.164 to-ports=33546
/ip route
add check-gateway=arp comment="Allow line Pepwave go to Internet" disabled=no \
    distance=2 dst-address=0.0.0.0/0 gateway=172.31.1.200 pref-src="" \
    routing-table=main scope=30 suppress-hw-offload=no target-scope=10
add check-gateway=arp disabled=no distance=1 dst-address=0.0.0.0/0 gateway=\
    172.31.1.200 pref-src="" routing-table=rt_pepwave scope=30 \
    suppress-hw-offload=no target-scope=10
add distance=1 dst-address=192.168.1.0/24 gateway=172.31.1.200 routing-table=\
    main scope=30
add disabled=no distance=1 dst-address=172.16.12.0/24 gateway=172.31.1.200 \
    pref-src="" routing-table=main scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=172.16.10.0/24 gateway=172.31.1.200 \
    pref-src="" routing-table=main scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=172.16.11.0/24 gateway=172.31.1.200 \
    pref-src="" routing-table=main scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=172.16.16.0/24 gateway=172.31.1.200 \
    pref-src="" routing-table=main scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=0.0.0.0/0 gateway=172.31.2.200 \
    pref-src="" routing-table=rt_vnpt scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=13.78.32.151/32 gateway=118.107.96.1 \
    pref-src="" routing-table=main scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=20.39.143.91/32 gateway=118.107.96.1 \
    pref-src="" routing-table=main scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=20.39.136.45/32 gateway=118.107.96.1 \
    pref-src="" routing-table=main scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=52.156.27.196/32 gateway=118.107.96.1 \
    pref-src="" routing-table=main scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=yes distance=1 dst-address=13.107.42.20/32 gateway=118.107.96.1 \
    pref-src="" routing-table=main scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=yes distance=1 dst-address=13.107.42.18/32 gateway=118.107.96.1 \
    pref-src="" routing-table=main scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=20.71.64.218/32 gateway=118.107.96.1 \
    pref-src="" routing-table=main scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=20.46.124.22/32 gateway=118.107.96.1 \
    pref-src="" routing-table=main scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=13.107.138.8/32 gateway=118.107.96.1 \
    pref-src="" routing-table=main scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=20.151.56.123/32 gateway=118.107.96.1 \
    pref-src="" routing-table=main scope=30 suppress-hw-offload=no \
    target-scope=10
add comment="Allow LeasedLine go out Internet" disabled=no distance=1 \
    dst-address=0.0.0.0/0 gateway=118.107.96.1 pref-src="" routing-table=main \
    scope=30 suppress-hw-offload=no target-scope=10
add check-gateway=arp disabled=no distance=1 dst-address=0.0.0.0/0 gateway=\
    118.107.96.1 pref-src="" routing-table=rt_leasedline_vtc scope=30 \
    suppress-hw-offload=no target-scope=10
add comment="Allow line VNPT go to internet" disabled=yes distance=2 \
    dst-address=0.0.0.0/0 gateway=172.31.2.200 pref-src="" routing-table=main \
    scope=30 suppress-hw-offload=no target-scope=10
add disabled=no distance=1 dst-address=192.168.1.0/24 gateway=172.31.1.200 \
    pref-src="" routing-table=rt_vnpt scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=192.168.1.0/24 gateway=172.31.1.200 \
    pref-src="" routing-table=rt_pepwave scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=192.168.1.0/24 gateway=172.31.1.200 \
    pref-src="" routing-table=rt_leasedline_vtc scope=30 suppress-hw-offload=\
    no target-scope=10
add disabled=no distance=1 dst-address=13.78.32.151/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_pepwave scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=yes distance=1 dst-address=13.107.42.18/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_pepwave scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=yes distance=1 dst-address=13.107.42.20/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_pepwave scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=13.107.138.8/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_pepwave scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=20.39.136.45/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_pepwave scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=20.39.143.91/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_pepwave scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=20.46.124.22/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_pepwave scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=20.71.64.218/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_pepwave scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=20.151.56.123/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_pepwave scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=52.156.27.196/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_pepwave scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=13.78.32.151/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_vnpt scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=yes distance=1 dst-address=13.107.42.18/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_vnpt scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=yes distance=1 dst-address=13.107.42.20/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_vnpt scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=13.107.138.8/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_vnpt scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=20.39.136.45/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_vnpt scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=20.39.143.91/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_vnpt scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=20.46.124.22/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_vnpt scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=20.71.64.218/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_vnpt scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=20.151.56.123/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_vnpt scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=52.156.27.196/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_vnpt scope=30 suppress-hw-offload=no \
    target-scope=10
add comment="Allow line DCNET-2 go to internet" disabled=yes distance=2 \
    dst-address=0.0.0.0/0 gateway=172.31.3.200 pref-src="" routing-table=main \
    scope=30 suppress-hw-offload=no target-scope=10
add disabled=no distance=1 dst-address=0.0.0.0/0 gateway=PPPoE-DCNET-11.181 \
    pref-src="" routing-table=rt_dcnet2 scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=192.168.1.0/24 gateway=172.31.1.200 \
    pref-src="" routing-table=rt_dcnet2 scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=72.28.80.187/32 gateway=118.107.96.1 \
    pref-src="" routing-table=main scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=72.28.80.187/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_pepwave scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=72.28.80.187/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_vnpt scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=20.44.111.66/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_pepwave scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=20.44.111.66/32 gateway=118.107.96.1 \
    pref-src="" routing-table=main scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=20.44.111.66/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_vnpt scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=13.78.32.151/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_dcnet2 scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=yes distance=1 dst-address=13.107.42.18/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_dcnet2 scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=yes distance=1 dst-address=13.107.42.20/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_dcnet2 scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=13.107.138.8/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_dcnet2 scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=yes distance=1 dst-address=20.39.136.45/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_dcnet2 scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=20.39.143.91/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_dcnet2 scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=20.44.111.66/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_dcnet2 scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=20.46.124.22/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_dcnet2 scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=20.71.64.218/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_dcnet2 scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=20.151.56.123/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_dcnet2 scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=yes distance=1 dst-address=52.156.27.196/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_dcnet2 scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=72.28.80.187/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_dcnet2 scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=20.39.136.45/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_dcnet2 scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=192.168.4.0/24 gateway=172.31.1.200 \
    pref-src="" routing-table=main scope=30 suppress-hw-offload=no \
    target-scope=10
add comment="Allow line DCNET-2 go to internet via PPPoE-DCNET-11.181" \
    disabled=yes distance=2 dst-address=0.0.0.0/0 gateway=PPPoE-DCNET-11.181 \
    pref-src="" routing-table=main scope=30 suppress-hw-offload=no \
    target-scope=10
add comment="Allow line VNPT-87 go to internet via PPPoE-VNPT-53.87" \
    disabled=yes distance=2 dst-address=0.0.0.0/0 gateway=PPPoE-VNPT-53.87 \
    pref-src="" routing-table=main scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=yes distance=1 dst-address=0.0.0.0/0 gateway=PPPoE-VNPT-53.87 \
    pref-src="" routing-table=rt_vnpt scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=172.31.1.0/24 gateway=172.31.1.1 \
    pref-src="" routing-table=rt_leasedline_vtc scope=30 suppress-hw-offload=\
    no target-scope=10
add disabled=no distance=1 dst-address=52.156.27.66/32 gateway=118.107.96.1 \
    pref-src="" routing-table=main scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=52.156.27.66/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_pepwave scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=52.156.27.66/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_vnpt scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=no distance=1 dst-address=52.156.27.66/32 gateway=118.107.96.1 \
    pref-src="" routing-table=rt_dcnet2 scope=30 suppress-hw-offload=no \
    target-scope=10
add disabled=yes distance=1 dst-address=14.225.199.147/32 gateway=\
    118.107.96.1 pref-src="" routing-table=rt_dcnet2 scope=30 \
    suppress-hw-offload=no target-scope=10
add disabled=yes distance=1 dst-address=14.225.199.147/32 gateway=\
    118.107.96.1 pref-src="" routing-table=rt_vnpt scope=30 \
    suppress-hw-offload=no target-scope=10
add comment="Access Subnet VPN" disabled=no distance=1 dst-address=\
    192.168.3.0/24 gateway=10.200.0.2 routing-table=rt_VPN_WG scope=30 \
    suppress-hw-offload=no target-scope=10
add comment="Out Internet" disabled=no distance=1 dst-address=0.0.0.0/0 \
    gateway=PPPoE-DCNET-11.181 pref-src="" routing-table=rt_VPN_WG scope=30 \
    suppress-hw-offload=no target-scope=10
add disabled=no distance=1 dst-address=172.16.15.0/24 gateway=172.31.1.200 \
    pref-src="" routing-table=main scope=30 suppress-hw-offload=no \
    target-scope=10
/ip service
set telnet disabled=yes
set ftp disabled=yes
set www disabled=yes
set ssh disabled=yes
set api disabled=yes
set winbox port=28291
set api-ssl disabled=yes
/ip smb shares
set [ find default=yes ] directory=/pub
/ip traffic-flow
set cache-entries=512k
/snmp
set contact=it@titancorpvn.com enabled=yes
/system clock
set time-zone-name=Asia/Bangkok
/system identity
set name=BD-MASTER
/system logging
add action=remote disabled=yes topics=info
add action=remote disabled=yes topics=error
add action=GrayLogServer topics=info,firewall
add action=GrayLogServer topics=info,system,account
add action=GrayLogServer topics=info,system
add action=GrayLogServer topics=dhcp,info
add action=GrayLogServer topics=error
add action=GrayLogServer topics=critical
add action=GrayLogServer topics=info
add action=GrayLogServer topics=warning
/system note
set show-at-login=no
/system routerboard settings
set enter-setup-on=delete-key
/system scheduler
add interval=1d name=Disable_Queue_Tree on-event=\
    "queue/tree disable 0\r\
    \nqueue/tree disable 1\r\
    \n" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=2023-08-11 start-time=19:00:00
add interval=1d name=Enable_Queue_Tree on-event=\
    "queue/tree enable 0\r\
    \nqueue/tree enable 1\r\
    \n" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=2023-08-12 start-time=07:00:00
add disabled=yes interval=1d name=schedule-enable-pcq_trees on-event=\
    enable-pcq_trees policy=read,write,test,password,sniff,sensitive,romon \
    start-date=2023-08-14 start-time=06:00:00
add disabled=yes interval=1d name=schedule-disable-pcq_trees on-event=\
    disable-pcq_trees policy=read,write,test,password,sniff,sensitive,romon \
    start-date=2023-08-14 start-time=22:00:00
/tool bandwidth-server
set enabled=no
/tool mac-server ping
set enabled=no
/user group
set read policy="local,telnet,ssh,read,test,winbox,password,web,sniff,sensitiv\
    e,api,romon,rest-api,!ftp,!reboot,!write,!policy"
set write policy="local,telnet,ssh,read,write,test,winbox,password,web,sniff,s\
    ensitive,api,romon,rest-api,!ftp,!reboot,!policy"
