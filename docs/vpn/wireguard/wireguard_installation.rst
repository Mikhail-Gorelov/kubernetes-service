==============
Wireguard installation
==============

1. Create a server with open ssh ports and a port for wireguard (which we will install in the instructions below).
The port for wireguard should be of the UDP type

2. Log in and update the server:
  * apt update && apt upgrade -y

3. Installing wireguard:
  * apt install -y wireguard

4. Generate server keys:
  * wg genkey | tee /etc/wireguard/privatekey | wg pubkey | tee /etc/wireguard/publickey

5. Setting the private key rights:
  * chmod 600 /etc/wireguard/privatekey

6. Check what your network interface is called:
  * ifconfig

7. Most likely your network interface is eth0, but you may have another interface such as ens3 or something else.
This interface name is used further in the /etc/wireguard/wg0.conf which we will now create:
  * vim /etc/wireguard/wg0.conf
  * "[Interface]"
    "PrivateKey = <privatekey>"
    "Address = 10.0.0.1/24"
    "ListenPort = 51830"
    "PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE"
    "PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE"
  * Note - the PostUp and PostDown lines use the network interface eth0.
    If you have a different one, replace eth0 with yours.
  * Replace <privatekey> with the contents of /etc/wireguard/privatekey

8. Set up IP forwarding:
  * echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
  * sysctl -p

9. Activate the systemd daemon with wireguard:
  * systemctl enable wg-quick@wg0.service
  * systemctl start wg-quick@wg0.service
  * systemctl status wg-quick@wg0.service

10. Create client keys:
  * wg genkey | tee /etc/wireguard/gorelov_privatekey | wg pubkey | tee /etc/wireguard/gorelov_publickey

11. Add to the client server config:
  * vim /etc/wireguard/wg0.conf
  * "[Peer]"
    "PublicKey = <gorelov_publickey>"
    "AllowedIPs = 10.0.0.2/32"
  * Replace <gorelov_publickey> with the contents of /etc/wireguard/gorelov_publickey

12. Reboot the systemd service with wireguard:
  * systemctl restart wg-quick@wg0.service
  * systemctl status wg-quick@wg0.service

13. On the local machine (e.g. laptop), create a text file with the client config:
  * vim new_wg.conf
  * - [Interface]
      PrivateKey = <CLIENT-PRIVATE-KEY>
      Address = 10.0.0.2/32
      DNS = 8.8.8.8

    - [Peer]
      PublicKey = <SERVER-PUBKEY>
      Endpoint = <SERVER-IP>:51830
      AllowedIPs = 0.0.0.0/0
      PersistentKeepalive = 20
  * Here <CLIENT-PRIVATE-KEY> replace with the client private key,
    that is the content of /etc/wireguard/gorelov_privatekey on the server.
    <SERVER-PUBKEY> replace with the public key of the server,
    i.e. the content of /etc/wireguard/publickey on the server.
    <SERVER-IP> change to the server IP.
  * Open this file in the Wireguard client (available for all operating systems, including mobile ones)
    - and press the connect button in the client.