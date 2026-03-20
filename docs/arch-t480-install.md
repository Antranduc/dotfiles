# Arch Linux Installation — ThinkPad T480

## Pre-install

### BIOS settings (F1 at boot)
- Disable Secure Boot
- Set boot mode to UEFI (not Legacy/CSM)
- Boot from USB (F12 for one-time boot menu)

### Live environment setup
- Set console font for readability: `setfont ter-132b`
- Default keyboard layout is `us` — no need to run `loadkeys`

## Connect to Wi-Fi

```bash
iwctl
station wlan0 scan
station wlan0 get-networks
station wlan0 connect "NetworkName"
exit
ping -c 3 archlinux.org
```

## Partitioning

Using GPT partition table on `/dev/nvme0n1`:

| Partition | Size | Type | Filesystem |
|-----------|------|------|------------|
| nvme0n1p1 | 512M | EFI System | FAT32 |
| nvme0n1p2 | 4G | Linux swap | swap |
| nvme0n1p3 | Remainder | Linux filesystem | ext4 |

```bash
fdisk /dev/nvme0n1
# g    — new GPT table
# n    — +512M (EFI)
# n    — +4G (swap)
# n    — default (root)
# t 1  — type 1 (EFI System)
# t 2  — type 19 (Linux swap)
# w    — write
```

## Format and mount

```bash
mkfs.fat -F 32 /dev/nvme0n1p1
mkswap /dev/nvme0n1p2
mkfs.ext4 /dev/nvme0n1p3

mount /dev/nvme0n1p3 /mnt
mount --mkdir /dev/nvme0n1p1 /mnt/boot
swapon /dev/nvme0n1p2
```

## Install base system

```bash
pacstrap -K /mnt base linux linux-firmware vim
```

## Generate fstab

```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

## Configure system

```bash
arch-chroot /mnt
```

### Timezone (Boston / US Eastern)

```bash
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc
```

### Locale

Edit `/etc/locale.gen`, uncomment `en_US.UTF-8 UTF-8`, then:

```bash
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
```

### Hostname

```bash
echo "yourhostname" > /etc/hostname
```

### Root password

```bash
passwd
```

### Bootloader (systemd-boot)

```bash
bootctl install
chmod 700 /boot
```

Create `/boot/loader/entries/arch.conf`:

```
title Arch Linux
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
options root=PARTUUID=xxxx-xxxx-xxxx rw
```

Create `/boot/loader/entries/arch-fallback.conf`:

```
title Arch Linux (fallback)
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux-fallback.img
options root=PARTUUID=xxxx-xxxx-xxxx rw
```

Get your PARTUUID with `blkid /dev/nvme0n1p3`.

Create `/boot/loader/loader.conf`:

```
default arch.conf
timeout 3
```

## Reboot

```bash
exit
umount -R /mnt
reboot
```

Remove USB drive.

## Post-install

### User setup

```bash
useradd -m -G wheel yourusername
passwd yourusername
pacman -S sudo
EDITOR=vim visudo
# Uncomment: %wheel ALL=(ALL:ALL) ALL
```

### Networking

```bash
pacman -S networkmanager
systemctl enable --now NetworkManager
nmcli device wifi connect "NetworkName" password "yourpassword"
```

### GPU drivers (Intel UHD 620)

```bash
pacman -S mesa intel-media-driver
```

### Intel microcode

```bash
pacman -S intel-ucode
```

Already referenced in boot entries above.

### Window manager (Sway)

```bash
pacman -S sway swaybg swaylock swayidle wmenu ghostty
```

Copy default config and set terminal:

```bash
mkdir -p ~/.config/sway
cp /etc/sway/config ~/.config/sway/config
# Edit: set $term ghostty
sway
```

### Audio (PipeWire)

```bash
pacman -S pipewire pipewire-pulse wireplumber
systemctl --user enable --now pipewire pipewire-pulse wireplumber
```

### Power management

```bash
pacman -S tlp
systemctl enable --now tlp
```

### Firmware updates

```bash
pacman -S fwupd udisks2
fwupdmgr get-devices
fwupdmgr refresh
fwupdmgr get-updates
fwupdmgr update
```

Keep laptop plugged in during firmware updates.

#### Updated firmware versions (March 2026)
- Intel Management Engine: 184.96.4657
- Thunderbolt Host Controller: 23.9
- UEFI: 2023
- UEFI dbx: 20250902

### Thunderbolt device management (optional)

```bash
pacman -S bolt
```
