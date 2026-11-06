#!/usr/bin/env bash
#
# sync-multiboot.sh: Synchronize ESP bootloader entries, kernels, and ZFS hostid across distributions
#

set -euo pipefail

POOL="${ZFS_POOL:-zpool}"
TARGET="/mnt/chroot"
HOSTID_HEX="d83be86e"
ESP_UUID="7E8B-C715"
ESP_MNT="/boot"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
log_ok() { echo -e "${GREEN}[OK]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_err() { echo -e "${RED}[ERROR]${NC} $*" >&2; }

if [[ $EUID -ne 0 ]]; then
	log_err "This script requires root privileges. Please run with sudo: sudo $0"
	exit 1
fi

show_esp_space() {
	echo -e "${BOLD}--- EFI Partition (/boot) Space ---${NC}"
	df -h "$ESP_MNT"
	echo ""
	echo -e "${BOLD}Top directories on /boot:${NC}"
	du -h -d 2 "$ESP_MNT" 2>/dev/null | sort -hr | head -n 10
	echo ""
	local free_mb
	free_mb=$(df -BM "$ESP_MNT" | awk 'NR==2 {gsub("M",""); print $4}')
	if [[ "$free_mb" -lt 100 ]]; then
		echo -e "${RED}${BOLD}[WARNING]${NC} Only ${free_mb}MB free on ${ESP_MNT}."
	fi
}

mount_zfs() {
	local dataset="$1"
	local mountpoint="$2"
	mkdir -p "$mountpoint"
	if ! mountpoint -q "$mountpoint"; then
		mount -t zfs -o zfsutil "$dataset" "$mountpoint" 2>/dev/null || mount -t zfs "$dataset" "$mountpoint"
	fi
}

unmount_safe() {
	local mountpoint="$1"
	if mountpoint -q "$mountpoint"; then
		umount -R "$mountpoint" 2>/dev/null || umount -R -l "$mountpoint" 2>/dev/null || true
	fi
	rmdir "$mountpoint" 2>/dev/null || true
}

sync_hostid() {
	local distro="$1"
	local mnt="${TARGET}/${distro}"

	if ! zfs list -H -o name "${POOL}/${distro}/root" >/dev/null 2>&1; then
		return 0
	fi

	log_info "Syncing hostid to ${distro}..."
	mount_zfs "${POOL}/${distro}/root" "$mnt"
	if [[ -f /etc/hostid ]]; then
		cp -f /etc/hostid "${mnt}/etc/hostid"
		log_ok "Synced /etc/hostid (${HOSTID_HEX}) to ${distro}"
	fi
	unmount_safe "$mnt"
}

if [[ "${1:-}" == "status" || "${1:-}" == "space" || "${1:-}" == "-s" ]]; then
	show_esp_space
	exit 0
fi

echo -e "${BOLD}======================================================${NC}"
echo -e "${BOLD}   Multiboot ZFS & Bootloader Synchronization Tool    ${NC}"
echo -e "${BOLD}======================================================${NC}"
echo "Target ZFS Host ID: 0x${HOSTID_HEX}"
echo "ESP Mount:          ${ESP_MNT}"
echo ""

# -------------------------------------------------------------
# 1. Unify Host ID across distros
# -------------------------------------------------------------
for d in arch rhel fedora ubuntu nixos; do
	sync_hostid "$d"
done

# -------------------------------------------------------------
# 2. Sync systemd-boot loader entry options (spl.spl_hostid)
# -------------------------------------------------------------
if [[ -d "${ESP_MNT}/loader/entries" ]]; then
	for entry in "${ESP_MNT}"/loader/entries/*.conf; do
		[[ -f "$entry" ]] || continue
		if ! grep -q "spl.spl_hostid" "$entry"; then
			sed -i "/^options / s/$/ spl.spl_hostid=0x${HOSTID_HEX} spl_hostid=0x${HOSTID_HEX}/" "$entry"
			log_ok "Added ZFS hostid flags to $(basename "$entry")"
		fi
	done
fi

# -------------------------------------------------------------
# 3. Synchronize Ubuntu (Shim + GRUB + Kernel/Initrd on ESP)
# -------------------------------------------------------------
if zfs list -H -o name "${POOL}/ubuntu/root" >/dev/null 2>&1; then
	echo ""
	log_info "Synchronizing Ubuntu boot files..."
	UBUNTU_MNT="${TARGET}/ubuntu"
	mount_zfs "${POOL}/ubuntu/root" "$UBUNTU_MNT"

	ESP_UBUNTU="${ESP_MNT}/EFI/ubuntu"
	mkdir -p "$ESP_UBUNTU"

	# Find latest vmlinuz and initrd in Ubuntu
	VMLINUZ_SRC=""
	INITRD_SRC=""

	for candidate in \
		"${UBUNTU_MNT}/boot"/vmlinuz* \
		"${UBUNTU_MNT}"/vmlinuz* \
		"${UBUNTU_MNT}/usr/lib/modules"/*/vmlinuz; do
		if [[ -e "$candidate" && "$candidate" != "${ESP_UBUNTU}/vmlinuz" ]]; then
			VMLINUZ_SRC="$candidate"
			break
		fi
	done

	for candidate in \
		"${UBUNTU_MNT}/boot"/initrd.img* \
		"${UBUNTU_MNT}"/initrd.img* \
		"${UBUNTU_MNT}/boot"/initramfs*; do
		if [[ -e "$candidate" && "$candidate" != "${ESP_UBUNTU}/initrd.img" ]]; then
			INITRD_SRC="$candidate"
			break
		fi
	done

	if [[ -n "$VMLINUZ_SRC" && -e "$VMLINUZ_SRC" ]]; then
		cp -L "$VMLINUZ_SRC" "${ESP_UBUNTU}/vmlinuz"
		log_ok "Updated Ubuntu kernel on ESP: $(basename "$VMLINUZ_SRC")"
	fi

	if [[ -n "$INITRD_SRC" && -e "$INITRD_SRC" ]]; then
		cp -L "$INITRD_SRC" "${ESP_UBUNTU}/initrd.img"
		log_ok "Updated Ubuntu initrd on ESP: $(basename "$INITRD_SRC")"
	fi

	# Copy shim and grub if missing
	if [[ ! -f "${ESP_UBUNTU}/shimx64.efi" ]]; then
		SHIM_SRC=$(find "${UBUNTU_MNT}/usr/lib/shim" "${UBUNTU_MNT}/boot" -name "shimx64.efi.signed" -o -name "shimx64.efi" 2>/dev/null | head -n 1)
		if [[ -n "$SHIM_SRC" && -f "$SHIM_SRC" ]]; then
			cp "$SHIM_SRC" "${ESP_UBUNTU}/shimx64.efi"
			log_ok "Copied shimx64.efi to ESP"
		fi
	fi

	if [[ ! -f "${ESP_UBUNTU}/grubx64.efi" ]]; then
		GRUB_SRC=$(find "${UBUNTU_MNT}/usr/lib/grub" "${UBUNTU_MNT}/boot" -name "grubx64.efi.signed" -o -name "grubx64.efi" 2>/dev/null | head -n 1)
		if [[ -n "$GRUB_SRC" && -f "$GRUB_SRC" ]]; then
			cp "$GRUB_SRC" "${ESP_UBUNTU}/grubx64.efi"
			log_ok "Copied grubx64.efi to ESP"
		fi
	fi

	# Ensure custom grub.cfg exists
	if [[ ! -f "${ESP_UBUNTU}/grub.cfg" ]]; then
		cat <<EOF >"${ESP_UBUNTU}/grub.cfg"
set default=0
set timeout=2

menuentry "Ubuntu Linux (ZFS)" {
    search --no-floppy --set=root --fs-uuid ${ESP_UUID}
    linux /EFI/ubuntu/vmlinuz root=ZFS=${POOL}/ubuntu/root ro boot=zfs spl.spl_hostid=0x${HOSTID_HEX} spl_hostid=0x${HOSTID_HEX} quiet splash
    initrd /EFI/ubuntu/initrd.img
}
EOF
		log_ok "Created ${ESP_UBUNTU}/grub.cfg"
	fi

	# Ensure systemd-boot entry exists
	mkdir -p "${ESP_MNT}/loader/entries"
	if [[ ! -f "${ESP_MNT}/loader/entries/ubuntu.conf" ]]; then
		cat <<EOF >"${ESP_MNT}/loader/entries/ubuntu.conf"
title Ubuntu
efi   /EFI/ubuntu/shimx64.efi
EOF
		log_ok "Created ${ESP_MNT}/loader/entries/ubuntu.conf"
	fi

	unmount_safe "$UBUNTU_MNT"
fi

# -------------------------------------------------------------
# 4. Synchronize Fedora (Kernel/Initramfs on ESP + Loader Entry)
# -------------------------------------------------------------
if zfs list -H -o name "${POOL}/fedora/root" >/dev/null 2>&1; then
	echo ""
	log_info "Synchronizing Fedora boot files..."
	FEDORA_MNT="${TARGET}/fedora"
	mount_zfs "${POOL}/fedora/root" "$FEDORA_MNT"

	ESP_FEDORA="${ESP_MNT}/EFI/fedora"
	mkdir -p "$ESP_FEDORA"

	FEDORA_VMLINUZ=""
	FEDORA_INITRD=""

	for candidate in \
		"${FEDORA_MNT}/boot"/vmlinuz* \
		"${FEDORA_MNT}/usr/lib/modules"/*/vmlinuz; do
		if [[ -e "$candidate" && "$candidate" != "${ESP_FEDORA}/vmlinuz" ]]; then
			FEDORA_VMLINUZ="$candidate"
			break
		fi
	done

	for candidate in \
		"${FEDORA_MNT}/boot"/initramfs*.img \
		"${FEDORA_MNT}/usr/lib/modules"/*/initramfs.img; do
		if [[ -e "$candidate" && "$candidate" != "${ESP_FEDORA}/initramfs.img" ]]; then
			FEDORA_INITRD="$candidate"
			break
		fi
	done

	if [[ -n "$FEDORA_VMLINUZ" && -e "$FEDORA_VMLINUZ" ]]; then
		cp -L "$FEDORA_VMLINUZ" "${ESP_FEDORA}/vmlinuz"
		log_ok "Updated Fedora kernel on ESP: $(basename "$FEDORA_VMLINUZ")"
	fi

	if [[ -n "$FEDORA_INITRD" && -e "$FEDORA_INITRD" ]]; then
		cp -L "$FEDORA_INITRD" "${ESP_FEDORA}/initramfs.img"
		log_ok "Updated Fedora initramfs on ESP: $(basename "$FEDORA_INITRD")"
	fi

	mkdir -p "${ESP_MNT}/loader/entries"
	if [[ ! -f "${ESP_MNT}/loader/entries/fedora.conf" ]]; then
		cat <<EOF >"${ESP_MNT}/loader/entries/fedora.conf"
title Fedora Linux
linux /EFI/fedora/vmlinuz
initrd /EFI/fedora/initramfs.img
options root=ZFS=${POOL}/fedora/root ro boot=zfs spl.spl_hostid=0x${HOSTID_HEX} spl_hostid=0x${HOSTID_HEX} quiet splash
EOF
		log_ok "Created ${ESP_MNT}/loader/entries/fedora.conf"
	fi

	unmount_safe "$FEDORA_MNT"
fi

echo ""
echo -e "${GREEN}${BOLD}Synchronization complete!${NC}"
echo ""
show_esp_space
