#!/bin/bash
# Constroi o WhiteHat Linux Server a partir dos pacotes do Fedora Server.
# Uso: sudo ./build.sh [wsl|iso|all]      (host: Fedora, ou outro com dnf)
# Build limpo: apague rootfs/ antes.
set -euo pipefail
cd "$(dirname "$0")"

TARGET=${1:-all}
RELEASEVER=45
VERSION=1.0
ROOT=$PWD/rootfs
ISO=$PWD/temp/iso

case "$TARGET" in
    wsl|iso|all) ;;
    *) echo "Uso: sudo $0 [wsl|iso|all]"; exit 1 ;;
esac
[ "$(id -u)" -eq 0 ] || { echo "[ERRO] Execute como root: sudo $0 $TARGET"; exit 1; }

# Host mais antigo que o Fedora $RELEASEVER nao tem a chave GPG dele: usa a do distribution-gpg-keys.
GPGOPT=()
if [ ! -e "/etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-$RELEASEVER-primary" ]; then
    KEY=/usr/share/distribution-gpg-keys/fedora/RPM-GPG-KEY-fedora-$RELEASEVER-primary
    [ -e "$KEY" ] || { echo "[ERRO] Chave GPG do Fedora $RELEASEVER ausente: sudo dnf install distribution-gpg-keys"; exit 1; }
    GPGOPT=(--setopt="fedora.gpgkey=file://$KEY" --setopt="updates.gpgkey=file://$KEY")
fi

dnfroot() { dnf --installroot="$ROOT" --releasever="$RELEASEVER" --use-host-config "${GPGOPT[@]}" -y "$@"; }

umount_root() {
    for m in dev sys proc; do
        if mountpoint -q "$ROOT/$m"; then umount "$ROOT/$m"; fi
    done
}
trap umount_root EXIT

build_base() {
    echo "==> Instalando a base Fedora Server $RELEASEVER em $ROOT"
    mkdir -p "$ROOT"
    # Mesmos grupos do ambiente "Fedora Server Edition".
    dnfroot install fedora-release-server @core @standard @server-product @headless-management

    # ponytail: uma atualizacao do pacote fedora-release restaura o os-release do Fedora;
    #           empacotar um whitehat-release.rpm quando isso incomodar.
    install -m 644 config/os-release "$ROOT/usr/lib/os-release"
    echo "whitehat-server" > "$ROOT/etc/hostname"
    install -m 755 scripts/whitefetch "$ROOT/usr/local/bin/whitefetch"
    install -m 755 scripts/whitehat-adduser "$ROOT/usr/local/bin/whitehat-adduser"
    : > "$ROOT/etc/machine-id"   # cada instalacao gera o seu no primeiro boot
}

build_wsl() {
    local out="WhiteHatServer-$VERSION.wsl"
    if [ -e "$ROOT/boot/vmlinuz-whitehat" ]; then
        echo "[ERRO] rootfs/ ja contem o kernel da ISO; apague rootfs/ para gerar o .wsl."
        exit 1
    fi
    echo "==> Gerando $out"
    install -m 644 config/wsl.conf config/wsl-distribution.conf "$ROOT/etc/"
    tar --numeric-owner -czpf "$out" -C "$ROOT" .
    rm "$ROOT/etc/wsl.conf" "$ROOT/etc/wsl-distribution.conf"
}

build_iso() {
    local out="WhiteHatServer-$VERSION-x86_64.iso" kver
    echo "==> Instalando kernel e bootloader"
    dnfroot install kernel dracut-live grub2-pc grub2-tools parted
    install -D -m 644 config/autologin.conf "$ROOT/etc/systemd/system/getty@tty1.service.d/autologin.conf"
    install -m 755 scripts/whitehat-install "$ROOT/usr/local/bin/whitehat-install"

    # Initramfs generico: inicializa tanto a ISO live quanto o disco instalado.
    kver=$(ls "$ROOT/lib/modules" | sort -V | tail -n 1)
    for m in proc sys dev; do mount --bind "/$m" "$ROOT/$m"; done
    chroot "$ROOT" dracut --force --no-hostonly --add dmsquash-live /boot/initramfs-whitehat.img "$kver"
    umount_root
    cp "$ROOT/lib/modules/$kver/vmlinuz" "$ROOT/boot/vmlinuz-whitehat"

    echo "==> Gerando $out"
    rm -rf "$ISO"
    mkdir -p "$ISO/LiveOS"
    cp -r iso/. "$ISO/"
    cp "$ROOT/boot/vmlinuz-whitehat" "$ISO/boot/vmlinuz"
    cp "$ROOT/boot/initramfs-whitehat.img" "$ISO/boot/initrd.img"
    mksquashfs "$ROOT" "$ISO/LiveOS/squashfs.img" -noappend -comp zstd
    # O volid precisa bater com root=live:CDLABEL= em iso/boot/grub/grub.cfg.
    grub2-mkrescue -o "$out" "$ISO" -- -volid WHITEHAT_SRV
}

build_base
# O .wsl sai antes da ISO de proposito: assim ele nao carrega kernel nem bootloader.
if [ "$TARGET" != iso ]; then build_wsl; fi
if [ "$TARGET" != wsl ]; then build_iso; fi
echo "==> Concluido."
