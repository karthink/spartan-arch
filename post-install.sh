#!/bin/bash

# Run install.sh first or this will fail due to missing dependencies

# install dev envt.
echo 'Installing dev environment'
# pacman -S --noconfirm git emacs zsh nodejs npm vim wget perl make gcc grep tmux i3 dmenu
# pacman -S --noconfirm chromium curl autojump openssh sudo mlocate the_silver_searcher
# pacman -S --noconfirm ttf-hack lxterminal nitrogen ntp dhclient keychain
# pacman -S --noconfirm python-pip go go-tools pkg-config
pacman -S --noconfirm vim wget perl make gcc grep tmux i3
pacman -S --noconfirm curl autojump openssh sudo mlocate the_silver_searcher
pacman -S --noconfirm ttf-hack feh dhclient keychain rxvt-unicode
pacman -S --noconfirm python-pip pkg-config
pacman -S --noconfirm --needed bash
# npm install -g jscs jshint bower grunt
pip install pipenv bpython ipython

# network on boot?
read -t 1 -n 1000000 discard      # discard previous input
sudo dhclient enp0s3
echo 'Waiting for internet connection'


# xinitrc
cd
head -n -5 /etc/X11/xinit/xinitrc > ~/.xinitrc
echo 'exec VBoxClient --clipboard -d &' >> ~/.xinitrc
echo 'exec VBoxClient --display -d &' >> ~/.xinitrc
echo 'exec i3 &' >> ~/.xinitrc
# echo 'exec nitrogen --restore &' >> ~/.xinitrc
# echo 'exec emacs' >> ~/.xinitrc

# emacs config
# git clone https://github.com/abrochard/emacs-config.git
# echo '(load-file "~/emacs-config/bootstrap.el")' > ~/.emacs
# echo '(server-start)' >> ~/.emacs

## cower & pacaur
# mkdir Downloads
# cd ~/Downloads
# wget https://aur.archlinux.org/cgit/aur.git/snapshot/cower-git.tar.gz
# tar -xvf cower-git.tar.gz
# cd cower-git
# makepkg PKGBUILD
# read -t 1 -n 1000000 discard      # discard previous input
# sudo pacman -U cower-*.pkg.tar.xz --noconfirm

# cd ~/Downloads
# wget https://aur.archlinux.org/cgit/aur.git/snapshot/pacaur.tar.gz
# tar -xvf pacaur.tar.gz
# cd pacaur
# makepkg PKGBUILD
# read -t 1 -n 1000000 discard      # discard previous input
# sudo pacman -U pacaur-*.pkg.tar.xz --noconfirm

# git first time setup
git config --global user.name $(whoami)
git config --global user.email $(whoami)@$(hostname)
git config --global code.editor emacsclient
echo '    AddKeysToAgent yes' >> ~/.ssh/config

# Install trizen
cd ~/Downloads
git clone https://aur.archlinux.org/trizen.git
cd trizen
makepkg PKGBUILD
# wget https://aur.archlinux.org/cgit/aur.git/snapshot/pacaur.tar.gz
# tar -xvf pacaur.tar.gz
# cd pacaur
# makepkg PKGBUILD
read -t 1 -n 1000000 discard      # discard previous input
sudo pacman -U trizen-*.pkg.tar.xz --noconfirm
makepkg --clean

# Install my build of st
cd ~/Downloads
mkdir st
cd st
wget https://raw.githubusercontent.com/karthink/st/extras/PKGBUILD -O PKGBUILD
makepkg PKGBUILD
read -t 1 -n 1000000 discard      # discard previous input
sudo pacman -U st-*.pkg.tar.xz --noconfirm
makepkg --clean

# xterm setup
# echo 'XTerm*background:black' > ~/.Xdefaults
# echo 'XTerm*foreground:white' >> ~/.Xdefaults
# echo 'UXTerm*background:black' >> ~/.Xdefaults
# echo 'UXTerm*foreground:white' >> ~/.Xdefaults

# Get my dotfiles
cd
git clone https://github.com/karthink/dotfiles.git
cd dotfiles
git checkout thinkpad

## tmux setup like emacs
# cd
# echo 'unbind C-b' > ~/.tmux.conf
# echo 'set -g prefix C-x' >> ~/.tmux.conf
# echo 'bind C-x send-prefix' >> ~/.tmux.conf
# echo 'bind 2 split-window' >> ~/.tmux.conf
# echo 'bind 3 split-window -h' >> ~/.tmux.conf

## oh-my-zsh
# cd
# rm ~/.zshrc -f
# git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
# cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
# sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="bira"/' ~/.zshrc
# sed -i 's/plugins=(git)/plugins=(git compleat sudo archlinux emacs autojump common-aliases)/' ~/.zshrc

# environment variable
echo 'export EDITOR=emacsclient' >> ~/.bashrc
echo 'export TERMINAL=st' >> ~/.bashrc

# i3status
if [ ! -d ~/.config ]; then
    mkdir ~/.config
fi
mkdir ~/.config/i3status
cp /etc/i3status.conf ~/.config/i3status/config
sed -i 's/^order += "ipv6"/#order += "ipv6"/' ~/.config/i3status/config
sed -i 's/^order += "run_watch VPN"/#order += "run_watch VPN"/' ~/.config/i3status/config
sed -i 's/^order += "wireless _first_"/#order += "wireless _first_"/' ~/.config/i3status/config
sed -i 's/^order += "battery 0"/#order += "battery 0"/' ~/.config/i3status/config

# if there are ssh key
# if [ -d ~/workspace/ssh ]; then
#     if [ -d ~/.ssh ]; then
#         rm -rf ~/.ssh
#     fi
#     ln -s ~/workspace/ssh ~/.ssh
# fi

# wallpaper setup
# cd
# mkdir Pictures
# cd Pictures
# wget https://github.com/abrochard/spartan-arch/blob/master/wallpaper.jpg?raw=true -O wallpaper.jpg
# cd ~/.config/
# mkdir nitrogen
# cd nitrogen
# echo '[xin_-1]' > bg-saved.cfg
# echo "file=/home/$(whoami)/Pictures/wallpaper.jpg" >> bg-saved.cfg
# echo 'mode=0' >> bg-saved.cfg
# echo 'bgcolor=#000000' >> bg-saved.cfg

# golang setup
# mkdir ~/go
# GOPATH=$HOME/go
# echo 'export GOPATH=$GOPATH' >> ~/.zshrc
# echo 'export PATH=$PATH:$HOME/go/bin' >> ~/.zshrc
# go get -u github.com/nsf/gocode
# go get -u github.com/rogpeppe/godef
# go get -u golang.org/x/tools/cmd/goimports
# go get -u github.com/jstemmer/gotags


# temporary workaround
cd
wget https://raw.githubusercontent.com/karthink/spartan-arch/master/startx.sh -O startx.sh
chmod +x startx.sh
echo 'alias startx=~/startx.sh' >> ~/.bashrc

echo 'Done'
~/startx.sh
