# WhiteHat Linux Server 1.0 🇧🇷

[![Download Oficial ISO](https://img.shields.io/badge/Download_Oficial-ISO-238636?style=for-the-badge&logo=linux&logoColor=white)](https://github.com/mbastida43/whitehatserver/releases/download/v1.0/WhiteHatServer-1.0-x86_64.iso)

**Base:** Fedora Server 45 | **Interface:** 100% CLI | **Licença:** GNU GPL v3.0

Distribuição Linux em modo texto construída com o conjunto de pacotes do Fedora Server 45 (systemd, NetworkManager, firewalld, OpenSSH, Cockpit e SELinux). Consulte abaixo as instruções para inicialização via ISO ou o empacotamento para WSL2 (`.wsl`).

---

## 💿 Inicialização e Uso via ISO

1. **Download:** Baixe a imagem `WhiteHatServer-1.0-x86_64.iso` clicando no botão acima ou na aba [Releases](https://github.com/mbastida43/whitehatserver/releases).
2. **Inicialização (Boot):** Grave a ISO em um pendrive ou carregue em uma máquina virtual (VirtualBox, QEMU/KVM, VMware). Reserve pelo menos 3 GB de RAM para a sessão live.
3. **Acesso ao Sistema (Login):**
   * **Sessão live:** entra automaticamente como `root`, sem senha.
   * **Sistema instalado:** o usuário e a senha são os que você definir durante o `whitehat-install`. A conta `root` fica bloqueada; use `sudo`.
4. **Instalação no disco:** Execute `whitehat-install`. Ele apaga o disco escolhido, copia o sistema, cria o usuário padrão e instala o GRUB.

> **Limitações do instalador:** grava apenas boot BIOS/Legacy (MBR, uma partição ext4), e o disco instalado inicializa sempre o kernel que veio na ISO, mesmo após `dnf update`.

---

## 📦 Empacotamento para WSL2 (.wsl) e ISO

Para compilar e gerar as imagens do WhiteHat Linux Server 1.0, você precisará estar em um ambiente host Fedora (ou outra distribuição compatível com o gerenciador de pacotes `dnf`). No WSL, compile dentro do sistema de arquivos do Linux, não em `/mnt/c`.

### Instruções de Compilação

**1. Clonar o repositório:**
```bash
git clone https://github.com/mbastida43/whitehatserver.git
cd whitehatserver
```

**2. Instalar as ferramentas do host:**
As quatro últimas só são necessárias para gerar a ISO.
```bash
sudo dnf install -y distribution-gpg-keys squashfs-tools xorriso mtools grub2-tools-extra grub2-pc-modules grub2-efi-x64-modules
```

**3. Compilar:**
O `build.sh` instala o sistema base em `rootfs/` com `dnf --installroot` (grupos `@core`, `@standard`, `@server-product` e `@headless-management`), aplica as configurações do WhiteHat e gera as imagens.
```bash
sudo ./build.sh all     # ou: wsl | iso
```

**4. Resultado:**
* `WhiteHatServer-1.0.wsl`: formato nativo reconhecido pelo Windows para importação.
* `WhiteHatServer-1.0-x86_64.iso`: imagem live inicializável.

Para um build limpo, apague a pasta `rootfs/` antes de compilar.

---

## 🚀 Importação e Instalação no Windows

Após gerar o arquivo `WhiteHatServer-1.0.wsl`, mova-o para o sistema de arquivos do Windows (ex: copiando do WSL para `/mnt/c/Downloads/`).

Abra o **PowerShell** no Windows e execute os comandos abaixo para instalar a distribuição:

```powershell
# 1. Instalar a partir do arquivo .wsl
wsl --install --from-file C:\Downloads\WhiteHatServer-1.0.wsl

# 2. Iniciar a sua nova distribuição
wsl -d WhiteHatServer
```

Na primeira inicialização o sistema pede o nome e a senha do usuário padrão (com `sudo`). Se você usar `wsl --import`, esse assistente não roda: crie o usuário manualmente com `whitehat-adduser`.

<br>

---

<br>

# WhiteHat Linux Server 1.0 🇺🇸

[![Official ISO Download](https://img.shields.io/badge/Official_Download-ISO-238636?style=for-the-badge&logo=linux&logoColor=white)](https://github.com/mbastida43/whitehatserver/releases/download/v1.0/WhiteHatServer-1.0-x86_64.iso)

**Base:** Fedora Server 45 | **Interface:** 100% CLI | **License:** GNU GPL v3.0

Text-mode Linux distribution built from the Fedora Server 45 package set (systemd, NetworkManager, firewalld, OpenSSH, Cockpit and SELinux). Check below for the ISO boot guide or the WSL2 packaging (`.wsl`) instructions.

---

## 💿 ISO Boot and Usage

1. **Download:** Get the `WhiteHatServer-1.0-x86_64.iso` image using the button above or from the [Releases](https://github.com/mbastida43/whitehatserver/releases) page.
2. **Boot:** Flash the ISO to a USB drive or load it into a virtual machine (VirtualBox, QEMU/KVM, VMware). Give the live session at least 3 GB of RAM.
3. **System Access (Login):**
   * **Live session:** logs in automatically as `root`, no password.
   * **Installed system:** the username and password are the ones you set during `whitehat-install`. The `root` account is locked; use `sudo`.
4. **Install to disk:** Run `whitehat-install`. It wipes the chosen disk, copies the system, creates the default user and installs GRUB.

> **Installer limitations:** it only writes BIOS/Legacy boot (MBR, a single ext4 partition), and the installed disk always boots the kernel shipped on the ISO, even after `dnf update`.

---

## 📦 Packaging for WSL2 (.wsl) and ISO

To compile and generate the WhiteHat Linux Server 1.0 images, you will need to be in a Fedora host environment (or another distribution compatible with the `dnf` package manager). On WSL, build inside the Linux file system, not under `/mnt/c`.

### Build Instructions

**1. Clone the repository:**
```bash
git clone https://github.com/mbastida43/whitehatserver.git
cd whitehatserver
```

**2. Install the host tools:**
The last four are only needed to generate the ISO.
```bash
sudo dnf install -y distribution-gpg-keys squashfs-tools xorriso mtools grub2-tools-extra grub2-pc-modules grub2-efi-x64-modules
```

**3. Build:**
`build.sh` installs the base system into `rootfs/` with `dnf --installroot` (groups `@core`, `@standard`, `@server-product` and `@headless-management`), applies the WhiteHat configuration and generates the images.
```bash
sudo ./build.sh all     # or: wsl | iso
```

**4. Output:**
* `WhiteHatServer-1.0.wsl`: the native format recognized by Windows for import.
* `WhiteHatServer-1.0-x86_64.iso`: bootable live image.

For a clean build, delete the `rootfs/` folder before building.

---

## 🚀 Import and Installation on Windows

After generating the `WhiteHatServer-1.0.wsl` file, move it to the Windows file system (e.g., copying from WSL to `/mnt/c/Downloads/`).

Open **PowerShell** on Windows and run the commands below to install the distribution:

```powershell
# 1. Install from the .wsl file
wsl --install --from-file C:\Downloads\WhiteHatServer-1.0.wsl

# 2. Start your new distribution
wsl -d WhiteHatServer
```

On first launch the system asks for the default user's name and password (with `sudo`). If you use `wsl --import`, that wizard does not run: create the user manually with `whitehat-adduser`.
