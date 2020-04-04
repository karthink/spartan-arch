#!/bin/bash

# This will be ran from the chrooted env.

user=$1
password=$2
fast=$3

# setup mirrors
if [ "$fast" -eq "1"]
then
    echo 'Setting up mirrors'
    cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
    sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.backup
    rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
else
    echo 'Skipping mirror ranking because fast'
fi

# setup timezone
echo 'Setting up timezone'
timedatectl set-ntp true
ln -s /usr/share/zoneinfo/America/New_York /etc/localtime
timedatectl set-timezone America/New_York
hwclock --systohc

# setup locale
echo 'Setting up locale'
sed -i 's/^#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf

# setup hostname
echo 'Setting up hostname'
echo 'arch-virtualbox' > /etc/hostname

# build
echo 'Building'
mkinitcpio -p linux

# install bootloader
echo 'Installing bootloader'
pacman -S grub --noconfirm
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# install Xorg
echo 'Installing Xorg'
pacman -S --noconfirm xorg xorg-xinit xterm

# install virtualbox guest modules
echo 'Installing VB-guest-modules'
pacman -S --noconfirm virtualbox-guest-modules-arch virtualbox-guest-utils

# vbox modules
echo 'vboxsf' > /etc/modules-load.d/vboxsf.conf

# install req for pacaur & cower
# echo 'Installing dependencies'
# pacman -S --noconfirm expac fakeroot yajl openssl

# user mgmt
echo 'Setting up user'
read -t 1 -n 1000000 discard      # discard previous input
echo 'root:'$password | chpasswd
useradd -m -G wheel -s /bin/bash $user
touch /home/$user/.bashrc
chown $user:$user /home/$user/.bashrc
mkdir /home/$user/Documents
chown $user:$user /home/$user/Documents
# mkdir /home/$user/workspace
# chown $user:$user /home/$user/workspace
echo $user:$password | chpasswd
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

# enable services
systemctl enable ntpdate.service

# preparing post install
wget https://raw.githubusercontent.com/karthink/spartan-arch/master/post-install.sh -O /home/$user/post-install.sh
chown $user:$user /home/$user/post-install.sh

echo 'Done'
