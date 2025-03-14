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
   apt update && apt upgrade -y
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

## 🛠️ **Installation Guide (Proxmox LXC Container)**  

### **1️⃣ Create a Proxmox LXC Container**
1. Open **Proxmox Web Interface** → Click on **"Create CT"**  
2. **General Settings**:  
   - Name: `Minecraft-LXC`  
   - Set a **password** for the Root-User  

3. **Template Selection**:  
   - Choose a **Debian 11/12** or **Ubuntu 22.04** template.  

4. **Resources:**  
   - **🖥️ CPU:** Minimum **2 vCPUs**, recommended **4 vCPUs**  
   - **💾 RAM:** Minimum **4GB**, recommended **8GB**  
   - **💾 Disk Storage:** Minimum **10GB**, recommended **20GB**  

5. **Network Settings:**  
   - **🌐 Network Device:** `eth0`  
   - **🌉 Bridge:** `vmbr0` *(adjust if needed)*  
   - **IPv4:** Static  
   - **IPv4/CIDR:** `192.168.0.222/24` *(ensure correct CIDR for Fritzbox, e.g. `/24`)*  
   - **🚪 Gateway (IPv4):** `192.168.0.1` *(Fritzbox default gateway)*  
   - **🛡️ Firewall:** Enable (Optional)  
   
   **If IPv6 is required:**  
   - **IPv6:** Static or SLAAC  
   - **IPv6/CIDR:** Set appropriate address if needed  

6. **Advanced Settings:**  
   - ✅ Enable **"Nesting"** under Features (required for Java & Systemd services)  
   - ❌ Disable **"Unprivileged Container"** if applications require elevated privileges  

7. **Finalize and start the container.**  

### **2️⃣ Install Required Dependencies**
After the container is created, log in and install necessary packages:
```bash
apt update && apt upgrade -y
apt install -y curl wget nano screen unzip git openjdk-17-jre-headless
```

### **3️⃣ Run the LXC Setup Script**
```bash
wget https://raw.githubusercontent.com/TimInTech/minecraft-server-Proxmox/main/setup_minecraft_lxc.sh
chmod +x setup_minecraft_lxc.sh
./setup_minecraft_lxc.sh
```

🔹 **For manual installation, see [Manual Installation](#manual-installation)**

---

## 🔧 **Manual Installation**
For those who prefer a manual setup instead of using the installation script, follow these steps:

### **Manual Steps for VM & LXC**
1. **Install Dependencies:**
   ```bash
   apt update && apt upgrade -y
   apt install -y curl wget nano screen unzip git openjdk-17-jre-headless
   ```

2. **Create Minecraft Server Directory:**
   ```bash
   mkdir -p /opt/minecraft && cd /opt/minecraft
   ```

3. **Download Minecraft Server (PaperMC):**
   ```bash
   wget -O server.jar https://api.papermc.io/v2/projects/paper/versions/1.20.4/builds/259/downloads/paper-1.20.4-259.jar
   ```

4. **Accept EULA:**
   ```bash
   echo "eula=true" > eula.txt
   ```

5. **Create a Start Script:**
   ```bash
   cat <<EOF > start.sh
   #!/bin/bash
   java -Xms2G -Xmx4G -jar server.jar nogui
   EOF
   chmod +x start.sh
   ```

6. **Start Server in Screen Session:**
   ```bash
   screen -dmS minecraft ./start.sh
   ```

7. **Check Logs:**
   ```bash
   tail -f /opt/minecraft/logs/latest.log
   ```

8. **To Stop Server:**
   ```bash
   systemctl stop minecraft
   ```

---

## 🤝 **Contribute**
- Found a bug? **🐛 Open an Issue**  
- Want to improve the script? **⚙️ Submit a Pull Request**  

🚀 Happy gaming! 🎮
