# WhiteHat Linux Server 1.0 🇧🇷

**Base:** pacotes do Fedora Server 45 | **Init:** systemd | **Interface:** 100% CLI | **Licença:** GNU GPL v3.0

Port do [WhiteHat Linux](https://github.com/mbastida43/whitehat) para o conjunto de pacotes do Fedora Server
(`@core`, `@standard`, `@server-product`, `@headless-management`): NetworkManager, firewalld, OpenSSH, Cockpit e SELinux.
O `init` artesanal do WhiteHat original foi substituído pelo systemd e pelo login padrão (PAM).

## 🔨 Compilação

Em um host Fedora (ou outro com `dnf`):

```bash
sudo dnf install -y squashfs-tools xorriso mtools grub2-tools-extra grub2-pc-modules grub2-efi-x64-modules
sudo ./build.sh all     # ou: wsl | iso
```

Saída: `WhiteHatServer-1.0.wsl` e `WhiteHatServer-1.0-x86_64.iso`. Para um build limpo, apague `rootfs/`.

## 🚀 WSL2

```powershell
wsl --install --from-file WhiteHatServer-1.0.wsl
```

Na primeira inicialização o sistema pede o nome e a senha do usuário padrão (com `sudo`).
Com `wsl --import` esse assistente não roda: crie o usuário manualmente com `whitehat-adduser`.

## 💿 ISO

1. Grave a ISO em um pendrive ou carregue em uma VM. A sessão live entra como `root` no tty1, sem senha.
2. Para instalar no disco: `whitehat-install` (apaga o disco escolhido, cria o usuário padrão e instala o GRUB).
3. No sistema instalado a conta `root` fica bloqueada; use o usuário criado e `sudo`.

**Limitações atuais:** o instalador grava apenas boot BIOS/Legacy (MBR, uma partição ext4), e o disco instalado
inicializa sempre o kernel que veio na ISO, mesmo após `dnf update`.

---

# WhiteHat Linux Server 1.0 🇺🇸

**Base:** Fedora Server 45 packages | **Init:** systemd | **Interface:** 100% CLI | **License:** GNU GPL v3.0

Port of [WhiteHat Linux](https://github.com/mbastida43/whitehat) to the Fedora Server package set
(`@core`, `@standard`, `@server-product`, `@headless-management`): NetworkManager, firewalld, OpenSSH, Cockpit and SELinux.
The hand-written `init` of the original WhiteHat is replaced by systemd and the standard login (PAM).

## 🔨 Build

On a Fedora host (or any other with `dnf`):

```bash
sudo dnf install -y squashfs-tools xorriso mtools grub2-tools-extra grub2-pc-modules grub2-efi-x64-modules
sudo ./build.sh all     # or: wsl | iso
```

Output: `WhiteHatServer-1.0.wsl` and `WhiteHatServer-1.0-x86_64.iso`. For a clean build, delete `rootfs/`.

## 🚀 WSL2

```powershell
wsl --install --from-file WhiteHatServer-1.0.wsl
```

On first launch the system asks for the default user's name and password (with `sudo`).
`wsl --import` skips that wizard: create the user manually with `whitehat-adduser`.

## 💿 ISO

1. Flash the ISO to a USB drive or load it into a VM. The live session logs in as `root` on tty1, no password.
2. To install to disk: `whitehat-install` (wipes the chosen disk, creates the default user and installs GRUB).
3. On the installed system the `root` account is locked; use the created user and `sudo`.

**Current limitations:** the installer only writes BIOS/Legacy boot (MBR, a single ext4 partition), and the installed
disk always boots the kernel shipped on the ISO, even after `dnf update`.
