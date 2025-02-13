/ip firewall address-list
add address=192.0.34.166 list=drop_traffic
add address=192.0.34.177 list=drop_traffic
add address=172.31.22.14 list=RDP_LST
add address=172.31.22.16 list=RDP_LST
add address=172.31.22.17 list=RDP_LST
add address=172.31.22.18 list=RDP_LST
add address=172.31.22.33 list=RDP_LST
add address=172.31.22.35 list=RDP_LST
add address=172.31.22.76 list=RDP_LST
add address=172.31.22.77 list=RDP_LST
add address=172.31.22.111 list=RDP_LST
add address=172.31.22.12 list=RDP_LST
add address=172.31.22.11 list=RDP_LST
/ip firewall nat
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=33539 \
    protocol=tcp to-addresses=172.31.22.177 to-ports=33539
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=12345 \
    protocol=tcp to-addresses=172.31.22.177 to-ports=12345
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=12345 \
    protocol=tcp to-addresses=172.31.22.177 to-ports=12345
add action=dst-nat chain=dstnat dst-address=118.107.96.22 dst-port=12123 \
    protocol=tcp to-addresses=172.31.22.109 to-ports=12123
add action=dst-nat chain=dstnat dst-address=118.107.96.22 dst-port=55555 \
    protocol=tcp to-addresses=172.31.22.12 to-ports=55555
add action=dst-nat chain=dstnat dst-address=118.107.96.22 dst-port=55556 \
    protocol=tcp to-addresses=172.31.22.13 to-ports=55556
add action=dst-nat chain=dstnat dst-address=118.107.96.22 dst-port=55557 \
    protocol=tcp to-addresses=172.31.22.14 to-ports=55557
add action=dst-nat chain=dstnat dst-address=118.107.96.55 dst-port=55558 \
    protocol=tcp to-addresses=172.31.22.16 to-ports=55558
add action=dst-nat chain=dstnat dst-address=118.107.96.56 dst-port=55559 \
    protocol=tcp to-addresses=172.31.22.17 to-ports=55559
add action=dst-nat chain=dstnat dst-address=118.107.96.56 dst-port=55123 \
    protocol=tcp to-addresses=172.31.22.33 to-ports=55123
add action=dst-nat chain=dstnat dst-address=118.107.96.56 dst-port=55125 \
    protocol=tcp to-addresses=172.31.22.35 to-ports=55125
add action=dst-nat chain=dstnat dst-address=118.107.96.56 dst-port=55126 \
    protocol=tcp to-addresses=172.31.22.35 to-ports=55126
add action=dst-nat chain=dstnat dst-address=118.107.96.56 dst-port=55127 \
    protocol=tcp to-addresses=172.31.22.35 to-ports=55127
add action=dst-nat chain=dstnat dst-address=118.107.96.56 dst-port=55126 \
    protocol=tcp to-addresses=172.31.22.35 to-ports=55126
add action=dst-nat chain=dstnat dst-address=118.107.96.56 dst-port=55125 \
    protocol=tcp to-addresses=172.31.22.35 to-ports=55125
add action=dst-nat chain=dstnat dst-address=118.107.96.56 dst-port=55126 \
    protocol=tcp to-addresses=172.31.22.35 to-ports=55126
add action=dst-nat chain=dstnat dst-address=118.107.96.56 dst-port=55125 \
    protocol=tcp to-addresses=172.31.22.35 to-ports=55125
add action=dst-nat chain=dstnat dst-address=118.107.96.56 dst-port=55126 \
    protocol=tcp to-addresses=172.31.22.35 to-ports=55126
add action=dst-nat chain=dstnat dst-address=118.107.96.56 dst-port=55126 \
    protocol=tcp to-addresses=172.31.22.35 to-ports=55126
add action=dst-nat chain=dstnat dst-address=118.107.96.56 dst-port=55126 \
    protocol=tcp to-addresses=172.31.22.35 to-ports=55126
add action=dst-nat chain=dstnat dst-address=118.107.96.56 dst-port=55126 \
    protocol=tcp to-addresses=172.31.22.35 to-ports=55126
add action=dst-nat chain=dstnat dst-address=118.107.96.56 dst-port=55126 \
    protocol=tcp to-addresses=172.31.22.35 to-ports=55126
add action=dst-nat chain=dstnat dst-address=118.107.96.56 dst-port=55126 \
    protocol=tcp to-addresses=172.31.22.35 to-ports=55126
add action=dst-nat chain=dstnat dst-address=118.107.96.56 dst-port=55512 \
    protocol=tcp to-addresses=172.31.22.76 to-ports=55512
add action=dst-nat chain=dstnat dst-address=118.107.96.56 dst-port=55513 \
    protocol=tcp to-addresses=172.31.22.77 to-ports=55513
add action=dst-nat chain=dstnat dst-address=118.107.96.90 dst-port=33333 \
    protocol=tcp to-addresses=172.31.22.111 to-ports=33333
add action=dst-nat chain=dstnat dst-address=118.107.96.90 dst-port=44444 \
    protocol=tcp to-addresses=172.31.22.12 to-ports=44444
add action=dst-nat chain=dstnat dst-address=118.107.96.90 dst-port=33333 \
    protocol=tcp to-addresses=172.31.22.111 to-ports=33333
add action=dst-nat chain=dstnat dst-address=118.107.96.90 dst-port=44444 \
    protocol=tcp to-addresses=172.31.22.12 to-ports=44444
add action=dst-nat chain=dstnat dst-address=118.107.96.20 dst-port=11111 \
    protocol=tcp to-addresses=172.31.22.11 to-ports=11111
/system note
set show-at-login=no
