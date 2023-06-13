#!/bin/bash
USER="alex"

prep_stage=(
    qt5-wayland
    qt5ct
    qt6-wayland
    qt6ct
    #cpio
    linux-headers
)

#software for GPU only
gpu_drivers_stage=(
    #mesa-git
    #xf86-video-nouveau
    #libva-git
    #libva-mesa-driver
    #mesa-vdpau
    #libva-vdpau-driver-vp9-git
    #libva-utils-git
    #lib32-mesa-git
    #nouveau-fw
)

install_hypr_prog=(
    gdb
    ninja
    gcc
    gcc12
    cmake
    meson
    libxcb
    xcb-proto
    xcb-util
    xcb-util-keysyms
    libxfixes
    libx11
    libxcomposite
    xorg-xinput
    libxrender
    pixman
    wayland-protocols
    cairo
    pango
    seatd
    libxkbcommon
    xcb-util-wm
    xorg-xwayland
    libinput
    libliftoff
    libdisplay-info
    xdg-desktop-portal-hyprland
)

#the main packages
install_prog=(
    hyprpaper-git
    kitty 
    mako 
    waybar-hyprland-git 
    workstyle-git
    #swww 
    swaylock-effects 
    wofi 
    wlogout
    wpaperd # Wallpaper daemon for Wayland
    cliphist # wayland clipboard manager
    swappy # A Wayland native snapshot editing tool
    grim # Screenshot utility for Wayland
    slurp # Select a region in a Wayland compositor
    nemo
    nemo-fileroller 
    nemo-preview
    # thunar 
    btop # A monitor of system resources, bpytop ported to C++
    # firefox
    # thunderbird
    mpv # a free, open source, and cross-platform media player
    pamixer # Pulseaudio command-line mixer like amixer
    pavucontrol # PulseAudio Volume Control
    #brightnessctl 
    bluez 
    bluez-utils 
    blueman 
    network-manager-applet 
    gvfs # Virtual filesystem implementation for GIO
    # thunar-archive-plugin 
    # file-roller
    #starship 
    papirus-icon-theme 
    ttf-jetbrains-mono-nerd 
    noto-fonts-emoji 
    #lxappearance # Feature-rich GTK+ theme switcher of the LXDE Desktop
    #xfce4-settings
    nwg-look-bin
    sddm-git 
    sddm-sugar-dark
    gnome-calculator
    gsimplecal # calculator
    pqiv # image viewer
    zsh
    visual-studio-code-bin
    yandex-browser
    timeshift-bin
    polkit-gnome
)

# set some colors
CNT="[\e[1;36mNOTE\e[0m]"
COK="[\e[1;32mOK\e[0m]"
CER="[\e[1;31mERROR\e[0m]"
CAT="[\e[1;37mATTENTION\e[0m]"
CWR="[\e[1;35mWARNING\e[0m]"
CAC="[\e[1;33mACTION\e[0m]"
INSTLOG="install.log"

######
# functions go here

# function that would show a progress bar to the user
show_progress() {
    while ps | grep $1 &> /dev/null;
    do
        echo -n "."
        sleep 2
    done
    echo -en "Done!\n"
    sleep 2
}

# function that will test for a package and if not found it will attempt to install it
install_software() {
    # First lets see if the package is there
    if yay -Q $1 &>> /dev/null ; then
        echo -e "$COK - $1 is already installed."
    else
        # no package found so installing
        echo -en "$CNT - Now installing $1 ."
        yay -S --devel --noconfirm $1 &>> $INSTLOG &
        show_progress $!
        
        sleep 2
    
        # test to make sure package installed
        if yay -Q $1 &>> /dev/null ; then
            echo -e "\e[1A\e[K$COK - $1 was installed."
        else
            yay -S --devel --noconfirm $1
            echo
            sleep 2

            # test to make sure package installed
            if yay -Q $1 &>> /dev/null ; then
                echo -e "\e[1A\e[K$COK - $1 was installed."
            else
                # if this is hit then a package is missing, exit to review log
                echo -e "\e[1A\e[K$CER - $1 install had failed, please check the install.log"
                exit
            fi
        fi
    fi
}

sudo -v

#### Check for package manager ####
if [ ! -f /sbin/yay ]; then  
    echo -en "$CNT - Configuering yay."
    git clone https://aur.archlinux.org/yay.git &>> $INSTLOG
    cd yay
    makepkg -si --noconfirm
    show_progress $!
    if [ -f /sbin/yay ]; then
        echo -e "\e[1A\e[K$COK - yay configured"
        cd ..
        
        # update the yay database
        echo -en "$CNT - Updating yay."
        yay -Suy --noconfirm
        show_progress $!
        echo -e "\e[1A\e[K$COK - yay updated."
    else
        # if this is hit then a package is missing, exit to review log
        echo -e "\e[1A\e[K$CER - yay install failed, please check the install.log"
        exit
    fi
fi

# Prep Stage - Bunch of needed items
echo -e "$CNT - Prep Stage - Installing needed components, this may take a while..."
for SOFTWR in ${prep_stage[@]}; do
    install_software $SOFTWR 
done

echo -e "$CNT - GPU drivers setup stage, this may take a while..."
for SOFTWR in ${gpu_drivers_stage[@]}; do
    install_software $SOFTWR
done

# Stage 1 - main components
echo -e "$CNT - Installing main components, this may take a while..."
for SOFTWR in ${install_hypr_prog[@]}; do
    install_software $SOFTWR 
done

# update config
# sudo sed -ni 's/MODULES=(/ { s/)/ nouveau)/ }' /etc/mkinitcpio.conf
# sudo mkinitcpio --config /etc/mkinitcpio.conf --generate /boot/initramfs-custom.img


# Install hyprland
echo -e "$CNT - Installing Hyprland, this may take a while..."

# git clone --recursive https://github.com/hyprwm/Hyprland
# cd Hyprland
# sudo make install
install_software hyprland-git

#fix needed for waybar-hyprland
export CC=gcc-12 CXX=g++-12

# Stage 2 - main components
echo -e "$CNT - Installing programs, this may take a while..."
for SOFTWR in ${install_prog[@]}; do
    install_software $SOFTWR 
done

# Start the bluetooth service
#echo -e "$CNT - Starting the Bluetooth Service..."
#sudo systemctl enable --now bluetooth.service
#sleep 2

# Enable the sddm login manager service
echo -e "$CNT - Enabling the SDDM Service..."
sudo systemctl enable sddm
sleep 2

# Clean out other portals
echo -e "$CNT - Cleaning out conflicting xdg portals..."
yay -R --noconfirm xdg-desktop-portal-gnome xdg-desktop-portal-gtk

# Copy the SDDM theme
echo -e "$CNT - Setting up the login screen."
sudo cp -R Extras/sdt /usr/share/sddm/themes/
sudo chown -R $USER:$USER /usr/share/sddm/themes/sdt
sudo mkdir /etc/sddm.conf.d
echo -e "[Theme]\nCurrent=sdt" | sudo tee -a /etc/sddm.conf.d/10-theme.conf &>> $INSTLOG
WLDIR=/usr/share/wayland-sessions
if [ -d "$WLDIR" ]; then
    echo -e "$COK - $WLDIR found"
else
    echo -e "$CWR - $WLDIR NOT found, creating..."
    sudo mkdir $WLDIR
fi 

# stage the .desktop file
sudo cp Extras/hyprland.desktop /usr/share/wayland-sessions/

# setup the first look and feel as dark
# xfconf-query -c xsettings -p /Net/ThemeName -s "Adwaita-dark"
# xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus-Dark"
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
cp -f Extras/wallpaper.jpg /usr/share/sddm/themes/sdt/wallpaper.jpg

sudo usermod -aG seat ${USER}
sudo groups ${USER}
sudo systemctl enable seatd
sudo systemctl start seatd
sudo systemctl status seatd

### Script is done ###
echo -e "$CNT - Script had completed!"
