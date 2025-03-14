# 🖥️ Minecraft Server on Proxmox

![🛠️ Minecraft Server Setup](https://github.com/TimInTech/minecraft-server-Proxmox/blob/main/minecraft-setup.png?raw=true)
This repository provides a guide and an automated script to set up a **Minecraft server** on **Proxmox** using either a **Virtual Machine (VM) or an LXC container**.

---

## 🔗 **Support This Project**
If you find this guide helpful and want to support the project, consider purchasing through this affiliate link:  
**🖥️ [NiPoGi AK1PLUS Mini PC – Intel Alder Lake-N N100](https://amzn.to/3FvH4GX)**  
By using this link, you support the project at no additional cost to you. Thank you! 🙌

---

## 📌 **Features**
✅ 🏗️ Automated installation of Minecraft Java/Bedrock servers  
✅ 🖥️ Works with Proxmox VM or LXC container  
✅ ⚡ Performance optimizations included  
✅ 🎛️ Customizable settings  
✅ ⛏️ Uses official Minecraft Bedrock Emojis where applicable  

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
   - **💾 20GB+ Storage** (depending on world size)  
   - Storage Type: **`virtio` (for best performance)**  

6. **CPU & RAM**:  
   - **🖥️ 2 vCPUs (4 recommended)**  
   - **💾 4GB RAM (8GB recommended)**  

7. **Network**:  
   - Model: **VirtIO (paravirtualized)**  
   - Enable **QEMU Guest Agent** after installation  

8. **Finalize the installation and update the system:**  
   ```bash
   apt update && apt full-upgrade -y
   apt install -y curl wget nano screen unzip git openjdk-17-jre-headless
   ```

### **2️⃣ Run the Minecraft Server Setup Script**
```bash
wget https://raw.githubusercontent.com/TimInTech/minecraft-server-Proxmox/main/setup_minecraft.sh
chmod +x setup_minecraft.sh
./setup_minecraft.sh
```

🔹 **For manual installation, see [Manual Installation](#manual-installation)**

---

## 🔍 **Troubleshooting & Solutions**

### **1️⃣ Minecraft server did not start because no Systemd service exists**
**Error:** `Unit minecraft.service could not be found.`

#### **Solution: Create the service manually**
Create a Systemd service file for the Minecraft server:
```bash
nano /etc/systemd/system/minecraft.service
```
Insert the following content:
```ini
[Unit]
Description=Minecraft Server
After=network.target

[Service]
User=root
WorkingDirectory=/opt/minecraft
ExecStart=/bin/bash /opt/minecraft/start.sh
Restart=always

[Install]
WantedBy=multi-user.target
```
Save with `CTRL + X`, `Y`, `ENTER`.

Then enable and start the service:
```bash
systemctl daemon-reload
systemctl enable minecraft
systemctl start minecraft
systemctl status minecraft
```

### **2️⃣ `server.jar` is empty**
**Error:** `ls -l /opt/minecraft/` shows that the file is 0 bytes:
```bash
-rw-r--r-- 1 root root  0 Mar 14 00:27 server.jar
```

#### **Solution: Download a valid `server.jar` and replace the empty file**
For PaperMC:
```bash
wget -O /opt/minecraft/server.jar https://api.papermc.io/v2/projects/paper/versions/1.20.4/builds/450/downloads/paper-1.20.4-450.jar
```
For Vanilla Minecraft:
```bash
wget -O /opt/minecraft/server.jar https://www.minecraft.net/en-us/download/server
```
(Check the official [Minecraft website](https://www.minecraft.net/en-us/download/server) for the latest version.)

Then restart the server:
```bash
systemctl restart minecraft
```

### **3️⃣ `ufw` is inactive**
**Solution:** If using a firewall, open the Minecraft port:
```bash
ufw allow 25565/tcp
ufw allow 25565/tcp6
ufw enable
```

---

## 🤝 **Contribute**
- Found a bug? **🐛 Open an Issue**  
- Want to improve the script? **⚙️ Submit a Pull Request**  

🚀 Happy gaming! 🎮
