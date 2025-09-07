#!/usr/bin/fish

# Exit on any error and show commands being executed
set -e
set -x

# Check if running as root
if test (id -u) -eq 0
    echo "Error: This script should not be run as root"
    exit 1
end

# Function to install packages with error handling
function install_packages
    if paru -S --needed --noconfirm $argv
        echo "Successfully installed: $argv"
    else
        echo "Failed to install: $argv" >&2
        return 1
    end
end

# Install paru if not present
if not type -q paru
    echo "Installing paru..."
    if not type -q git
        sudo pacman -S --noconfirm git
    end

    sudo pacman -S --needed --noconfirm base-devel
    set -l temp_dir (mktemp -d)
    git clone https://aur.archlinux.org/paru.git $temp_dir
    cd $temp_dir
    makepkg -si --noconfirm
    cd -
    rm -rf $temp_dir
end

# Update system and install packages
paru -Syu --noconfirm

# Organized package list with comments
set packages \
    # Audio
    alsa-firmware sof-firmware alsa-utils pipewire pipewire-audio \
    pipewire-pulse pipewire-jack wireplumber pavucontrol \
    # Bluetooth
    bluez bluez-utils blueman \
    # System utilities
    upower power-profiles-daemon pacman-contrib man-db man-pages texinfo \
    networkmanager sudo gvfs libgtop btop \
    # Hyprland ecosystem
    hyprland xdg-desktop-portal-hyprland grimblast-git wf-recorder-git \
    hyprpicker hyprsunset-git \
    # Applications
    kitty librewolf-bin thunar thunar-volman thunar-archive-plugin \
    thunar-media-tags-plugin wofi fastfetch bat lazygit eza \
    # Development tools
    fd ripgrep stow neovim unzip dart-sass fnm-bin direnv zoxide \
    # GUI components
    ags-hyprpanel-git aylurs-gtk-shell-git \
    # System tools
    wl-clipboard brightnessctl swww python python-gpustat matugen-bin \
    # Fonts
    ttf-firacode-nerd \
    # Display manager
    sddm sddm-silent-theme

install_packages $packages

# Set default applications
xdg-mime default thunar.desktop inode/directory
gio mime inode/directory thunar.desktop

set -l browser librewolf.desktop
for scheme in http https
    xdg-mime default $browser x-scheme-handler/$scheme
    gio mime x-scheme-handler/$scheme $browser
end

for mime in text/html application/xhtml+xml
    xdg-mime default $browser $mime
    gio mime $mime $browser
end

xdg-mime default kitty.desktop x-scheme-handler/terminal
gio mime x-scheme-handler/terminal kitty.desktop

# Enable services
systemctl --user enable --now pipewire pipewire-pulse wireplumber
sudo systemctl enable --now bluetooth NetworkManager sddm

# Setup flatpak
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
set -l flatpak_apps \
    org.vinegarhq.Sober \
    org.telegram.desktop \
    io.github.flattool.Warehouse \
    com.github.tchx84.Flatseal

if not flatpak install --user -y flathub $flatpak_apps
    echo "Flatpak installation failed - check parenta control settings" >&2
end

# Stow configuration files
stow --ignore='^(install\.sh|install\.fish)$' . -v --adopt

echo "[General]
InputMethod=qtvirtualkeyboard
GreeterEnvironment=QML2_IMPORT_PATH=/usr/share/sddm/themes/silent/components/,QT_IM_MODULE=qtvirtualkeyboard

[Theme]
Current=silent" | sudo tee /etc/sddm.conf >/dev/null

# Install GRUB theme
set -l grub_theme_dir "$HOME/.cache/elegant-grub"
git clone https://github.com/vinceliuice/Elegant-grub2-themes.git $grub_theme_dir
sudo $grub_theme_dir/install.sh -t mojave

echo "Installation completed successfully. A reboot is recommended."
read -l -P "Reboot now? [y/N] " confirm
if string match -q -i y "$confirm"
    sudo reboot
end
