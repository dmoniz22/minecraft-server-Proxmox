# 🖥️ Minecraft Server on Proxmox


![Minecraft Server Setup](https://github.com/TimInTech/minecraft-server-Proxmox/blob/main/minecraft-setup.png?raw=true)
This repository provides a guide and an automated script to set up a **Minecraft server** on **Proxmox** using either a **Virtual Machine (VM) or an LXC container**.

---

## 📌 **Features**
✅ Automated installation of Minecraft Java/Bedrock servers  
✅ Works with Proxmox VM or LXC container  
✅ Performance optimizations included  
✅ Customizable settings

  

---
## 🚀 **Installation Guide (Proxmox VM)**  

---

### **1️⃣ Create a Proxmox VM**

1. **Open Proxmox Web Interface** → Click on **"Create VM"**  
2. **General Settings**:  
   - Name: `Minecraft-Server`  

3. **OS Selection**:  
   - Use a **Debian 11/12** or **Ubuntu 22.04** ISO image.  

4. **System Configuration**:  
   - BIOS: **OVMF (UEFI) or SeaBIOS**  
   - Machine Type: **q35** (recommended)  

5. **Disk & Storage**:  
   - **20GB+ Storage** (depending on world size)  
   - Storage Type: **`virtio` (for best performance)**  

6. **CPU & RAM**:  
   - **2 vCPUs (4 recommended)**  
   - **4GB RAM (8GB recommended)**  

7. **Network**:  
   - Model: **VirtIO (paravirtualized)**  
   - Enable **QEMU Guest Agent** after installation  

8. **Finalize the installation and run:**  
   ```bash
   apt update && apt install -y qemu-guest-agent
   ```



### **2️⃣ Run the Minecraft Server Setup Script**
```bash
wget https://raw.githubusercontent.com/TimInTech/minecraft-server-Proxmox/main/setup_minecraft.sh
chmod +x setup_minecraft.sh
./setup_minecraft.sh
```

---

## 🛠️ **Installation Guide (Proxmox LXC Container)**  

### **1️⃣ Create a Proxmox LXC Container**
1. Open **Proxmox Web Interface** → Click on **"Create CT"**  
2. **General Settings**:  
   - Name: `Minecraft-LXC`  

3. **Template Selection**:  
   - Choose a **Debian 11/12** template.  

4. **CPU & RAM**:  
   - **4GB RAM (8GB recommended)**  
   - **2 vCPUs (4 recommended)**  

5. **Disk & Storage**:  
   - **10GB+ Storage**  
   - Storage Type: **`ext4` (recommended for LXC)**  

6. **Advanced Settings**:  
   - Enable **"Nestling"** under Features (for Java support)  

7. **Finalize and start the container.**  

### **2️⃣ Run the LXC Setup Script**
```bash
wget https://raw.githubusercontent.com/TimInTech/minecraft-server-Proxmox/main/setup_minecraft_lxc.sh
chmod +x setup_minecraft_lxc.sh
./setup_minecraft_lxc.sh
```

---

## 🔧 **Configuration & Server Management**
- **Edit Server Properties:**  
  ```bash
  nano /opt/minecraft/server.properties
  ```

- **Start/Stop the Server:**  
  ```bash
  systemctl start minecraft
  systemctl stop minecraft
  ```

- **Check Logs:**  
  ```bash
  tail -f /opt/minecraft/logs/latest.log
  ```

---

## 🌐 **Port Forwarding for External Access**
To allow external players to connect, open port **25565** on your firewall:

```bash
ufw allow 25565/tcp
```

For **LXC containers**, use NAT forwarding:

```bash
iptables -t nat -A PREROUTING -i vmbr0 -p tcp --dport 25565 -j DNAT --to-destination 192.168.1.100:25565
```

---

## 🎮 **Bedrock Server (Windows & Console Support)**
If you want to run a **Minecraft Bedrock Server** (for Windows, Xbox, and mobile players), use the following script:

```bash
wget https://raw.githubusercontent.com/TimInTech/minecraft-server-Proxmox/main/setup_bedrock.sh
chmod +x setup_bedrock.sh
./setup_bedrock.sh
```

---

## 🤝 **Contribute**
- Found a bug? **Open an Issue**  
- Want to improve the script? **Submit a Pull Request**  

🚀 Happy gaming! 🎮  
```
