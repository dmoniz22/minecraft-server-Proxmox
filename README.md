# 🧱 **Minecraft Server on Proxmox** 🌍

![⛏️ Minecraft Server Setup](https://github.com/TimInTech/minecraft-server-Proxmox/blob/main/minecraft-setup.png?raw=true)

This repository provides a guide and automated scripts to set up a **Minecraft server** on **Proxmox** using either a **Virtual Machine (VM)** or an **LXC container**.

---

## 🔗 **Support This Project** 💎  
If you find this guide helpful, consider purchasing through this affiliate link:  
**⛏️ [NiPoGi AK1PLUS Mini PC – Intel Alder Lake-N N100](https://amzn.to/3FvH4GX)**  
Using this link supports the project at no additional cost to you. Thank you! 🙌

---

## 📌 **Features** 🗺️  
✅ **Automated installation** of Minecraft Java/Bedrock servers  
✅ Works with **Proxmox VM** or **LXC container**  
✅ **Performance optimizations** included (RAM allocation, CPU prioritization)  
✅ Customizable settings (world generation, plugins, mods)  
✅ **Troubleshooting guide included** for common issues  

---

## 💎 **Installation Guide (Proxmox VM)** 🖥️

### **1️⃣ Create a Proxmox VM** 🛠️  
- Open Proxmox Web Interface → Click on **"Create VM"**  
- **General Settings**:  
  - Name: `Minecraft-Server`  
- **OS Selection**:  
  - Use a **Debian 11/12** or **Ubuntu 24.04** ISO image  
- **System Configuration**:  
  - BIOS: **OVMF (UEFI) or SeaBIOS**  
  - Machine Type: **q35** (recommended)  
- **Disk & Storage**:  
  - **20GB+ Storage** (depending on world size)  
  - Storage Type: **`virtio`** (recommended)  
- **CPU & RAM**:  
  - 2 vCPUs (recommended: 4)  
  - 4GB RAM (recommended: 8GB)  
- **Network**:  
  - Model: **VirtIO**  
  - Enable **QEMU Guest Agent** after installation  

### **2️⃣ Install Dependencies** ⚙️  
```bash
apt update && apt upgrade -y  
apt install -y curl wget nano screen unzip git openjdk-21-jre-headless
```

### **3️⃣ Run the Minecraft Server Setup Script** ⛏️  
```bash
wget https://raw.githubusercontent.com/TimInTech/minecraft-server-Proxmox/main/setup_minecraft.sh  
chmod +x setup_minecraft.sh  
./setup_minecraft.sh
```

---

## 🛠️ **Installation Guide (Proxmox LXC Container)** 📦  

### **1️⃣ Create a Proxmox LXC Container** 🧱  
- Open Proxmox Web Interface → Click on **"Create CT"**  
- **General Settings**:  
  - Name: `Minecraft-LXC`  
  - Set root user **password**  
- **Template Selection**:  
  - Choose a **Debian 11/12** or **Ubuntu 24.04** template  
- **Resources**:  
  - CPU: 2 vCPUs (recommended: 4)  
  - RAM: 4GB (recommended: 8GB)  
  - Disk Storage: 10GB (recommended: 20GB)  
- **Network Settings**:  
  - Network Device: `eth0`  
  - Bridge: `vmbr0` *(adjust as needed)*  
  - IPv4: Static (e.g. `192.168.0.222/24`)  
  - Gateway (IPv4): typically `192.168.0.1`  
  - Firewall: Enable (optional)  
- **Advanced Settings**:  
  - Enable **"Nesting"** (required for Java & systemd)  
  - Disable **"Unprivileged Container"** if needed  

### **2️⃣ Install Required Dependencies** ⚒️  
Log into the container and install:  
```bash
apt update && apt upgrade -y  
apt install -y curl wget nano screen unzip git openjdk-21-jre-headless
```

### **3️⃣ Run the LXC Setup Script** 🧰  
```bash
wget https://raw.githubusercontent.com/TimInTech/minecraft-server-Proxmox/main/setup_minecraft_lxc.sh  
chmod +x setup_minecraft_lxc.sh  
./setup_minecraft_lxc.sh
```

---

## 🔍 **Troubleshooting & Solutions** 🛑

### **1️⃣ Java Version Error (Unsupported Class Version)** 🚫  
**Error:** `org/bukkit/craftbukkit/Main has been compiled by a more recent version of the Java Runtime.`  
#### **Solution:** Install the correct Java version  
```bash
apt install -y openjdk-21-jre-headless
```
Restart the server:  
```bash
systemctl restart minecraft
```

### **2️⃣ Server Not Starting (`start.sh` missing)** ⚠️  
```bash
cd /opt/minecraft
nano start.sh
```
Paste:
```bash
#!/bin/bash
java -Xms2G -Xmx4G -jar server.jar nogui
```
Then:
```bash
chmod +x start.sh
./start.sh
```

### **3️⃣ Firewall Issues (`ufw` inactive)** 🔥  
```bash
ufw allow 25565/tcp  
ufw allow 25565/tcp6  
ufw enable
```

---

## 🤝 **Contribute** 🌟  
- Found a bug? 🐛 **Open an Issue**  
- Want to improve the script? ⚙️ **Submit a Pull Request**  

 💎 **Happy crafting!** 🎮  

