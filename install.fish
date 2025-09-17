#!/usr/bin/env fish
# originals: https://github.com/caelestia-dots/shell https://github.com/caelestia-dots/caelestia

argparse -n 'install.fish' -X 0 \
    h/help \
    noconfirm \
    yay \
    -- $argv
or exit

# Print help
if set -q _flag_h
    echo 'usage: ./install.sh [-h] [--noconfirm] [--yay]'
    echo
    echo 'options:'
    echo '  -h, --help                  show this help message and exit'
    echo '  --noconfirm                 do not confirm package installation'
    echo '  --yay                       use yay instead of paru as AUR helper'

    exit
end

# Helper funcs
function _out -a colour text
    set_color $colour
    # Pass arguments other than text to echo
    echo $argv[3..] -- ":: $text"
    set_color normal
end

function log -a text
    _out cyan $text $argv[2..]
end

function input -a text
    _out blue $text $argv[2..]
end

function confirm-overwrite -a path
    if test -e $path -o -L $path
        # No prompt if noconfirm
        if set -q noconfirm
            input "$path already exists. Overwrite? [Y/n]"
            log 'Removing...'
            rm -rf $path
        else
            # Prompt user
            read -l -p "input '$path already exists. Overwrite? [Y/n] ' -n" confirm || exit 1

            if test "$confirm" = n -o "$confirm" = N
                log 'Skipping...'
                return 1
            else
                log 'Removing...'
                rm -rf $path
            end
        end
    end

    return 0
end

# Variables
set -q _flag_noconfirm && set noconfirm --noconfirm
set -q _flag_paru && set -l aur_helper yay || set -l aur_helper paru
set -q XDG_CONFIG_HOME && set -l config $XDG_CONFIG_HOME || set -l config $HOME/.config
set -q XDG_STATE_HOME && set -l state $XDG_STATE_HOME || set -l state $HOME/.local/state

# Startup prompt
set_color magenta
echo '╭─────────────────────────────────────────────────╮'
echo '│      ______           __          __  _         │'
echo '│     / ____/___ ____  / /__  _____/ /_(_)___ _   │'
echo '│    / /   / __ `/ _ \/ / _ \/ ___/ __/ / __ `/   │'
echo '│   / /___/ /_/ /  __/ /  __(__  ) /_/ / /_/ /    │'
echo '│   \____/\__,_/\___/_/\___/____/\__/_/\__,_/     │'
echo '│                                                 │'
echo '╰─────────────────────────────────────────────────╯'
set_color normal
log 'Welcome to the Caelestia dotfiles installer!'
log 'Before continuing, please ensure you have made a backup of your config directory.'

# Prompt for backup
if ! set -q _flag_noconfirm
    log '[1] Two steps ahead of you!  [2] Make one for me please!'
    read -l -p "input '=> ' -n" choice || exit 1

    if contains -- "$choice" 1 2
        if test $choice = 2
            log "Backing up $config..."

            if test -e $config.bak -o -L $config.bak
                read -l -p "input 'Backup already exists. Overwrite? [Y/n] ' -n" overwrite || exit 1

                if test "$overwrite" = n -o "$overwrite" = N
                    log 'Skipping...'
                else
                    rm -rf $config.bak
                    cp -r $config $config.bak
                end
            else
                cp -r $config $config.bak
            end
        end
    else
        log 'No choice selected. Exiting...'
        exit 1
    end
end

# Install AUR helper if not already installed
if ! pacman -Q $aur_helper &>/dev/null
    log "$aur_helper not installed. Installing..."

    # Install
    sudo pacman -S --needed git base-devel $noconfirm
    cd /tmp
    git clone https://aur.archlinux.org/$aur_helper.git
    cd $aur_helper
    makepkg -si
    cd ..
    rm -rf $aur_helper

    # Setup
    $aur_helper -Y --gendb
    $aur_helper -Y --devel --save
end

# Install metapackage for deps
log 'Installing metapackage...'
$aur_helper -S --needed caelestia-meta $noconfirm

# Cd into dir
cd (dirname (status filename)) || exit 1

# Install hypr* configs
if confirm-overwrite $config/hypr
    log 'Installing hypr* configs...'
    ln -s (realpath hypr) $config/hypr
    hyprctl reload
end

# Starship
if confirm-overwrite $config/starship.toml
    log 'Installing starship config...'
    ln -s (realpath starship.toml) $config/starship.toml
end

# Foot
if confirm-overwrite $config/foot
    log 'Installing foot config...'
    ln -s (realpath foot) $config/foot
end

# Fish
if confirm-overwrite $config/fish
    log 'Installing fish config...'
    ln -s (realpath fish) $config/fish
end

# Fastfetch
if confirm-overwrite $config/fastfetch
    log 'Installing fastfetch config...'
    ln -s (realpath fastfetch) $config/fastfetch
end

# Uwsm
if confirm-overwrite $config/uwsm
    log 'Installing uwsm config...'
    ln -s (realpath uwsm) $config/uwsm
end

# Btop
if confirm-overwrite $config/btop
    log 'Installing btop config...'
    ln -s (realpath btop) $config/btop
end

# Nvim
if confirm-overwrite $config/nvim
    log 'Installing nvim config...'
    ln -s (realpath nvim) $config/nvim
end

log 'Installing librewolf...'
$aur_helper -S --needed librewolf-bin hunspell-en_US speech-dispatcher $noconfirm

# Install native app
set -l hosts $HOME/.mozilla/native-messaging-hosts
set -l lib $HOME/.local/lib/caelestia

if confirm-overwrite $hosts/caelestiafox.json
    log 'Installing zen native app manifest...'
    mkdir -p $hosts
    cp zen/native_app/manifest.json $hosts/caelestiafox.json
    sed -i "s|{{ \$lib }}|$lib|g" $hosts/caelestiafox.json
end

if confirm-overwrite $lib/caelestiafox
    log 'Installing zen native app...'
    mkdir -p $lib
    ln -s (realpath zen/native_app/app.fish) $lib/caelestiafox
end

# Prompt user to install extension
log 'Please install the CaelestiaFox extension from https://addons.mozilla.org/en-US/firefox/addon/caelestiafox if you have not already done so.'

# Generate scheme stuff if needed
if ! test -f $state/caelestia/scheme.json
    caelestia scheme set -n shadotheme
    sleep .5
    hyprctl reload
end

log 'Installing caelestia optional plugins...'
$aur_helper -S --needed nemo nemo-fileroller gvfs udisks2 tumbler nemo-media-columns gvfs-afc gvfs-mtp gvfs-gphoto2 gvfs-nfs gvfs-smb $noconfirm
$aur_helper -S --needed todoist-appimage $noconfirm
$aur_helper -S --needed uwsm $noconfirm
$aur_helper -S --needed gnome-keyring $noconfirm
$aur_helper -S --needed polkit-gnome $noconfirm

log 'Installing audio packages...'
$aur_helper -S --needed alsa-firmware sof-firmware alsa-utils pipewire pipewire-alsa pipewire-audio pipewire-pulse pipewire-jack wireplumber pavucontrol $noconfirm

log 'Installing bluetooth packages...'
$aur_helper -S --needed bluez bluez-utils $noconfirm

log 'Installing dev packages...'
$aur_helper -S --needed ripgrep fd bat eza lazygit fnm-bin direnv zoxide $noconfirm

log 'Installing font...'
$aur_helper -S --needed ttf-firacode-nerd $noconfirm

log 'Installing code editor and help pages...'
$aur_helper -S --needed neovim man-pages man-db man-pages-ru $noconfirm

log 'Installing flatpak...'
$aur_helper -S --needed flatpak $noconfirm

log 'Setup flatpak...'
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
set -l flatpak_apps \
    org.vinegarhq.Sober \
    org.telegram.desktop \
    io.github.flattool.Warehouse \
    com.github.tchx84.Flatseal

if not flatpak install --user -y flathub $flatpak_apps
    echo "Flatpak installation failed - check parenta control settings or usually it gets solved after reboot" >&2
end

log 'Installing sddm login page and required plugins for the theme...'
$aur_helper -S --needed sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg $noconfirm

sudo git clone -b master --depth 1 https://github.com/keyitdev/sddm-astronaut-theme.git /usr/share/sddm/themes/sddm-astronaut-theme
sudo cp -r /usr/share/sddm/themes/sddm-astronaut-theme/Fonts/* /usr/share/fonts/
echo "[Theme]
Current=sddm-astronaut-theme" | sudo tee /etc/sddm.conf
echo "[General]
InputMethod=qtvirtualkeyboard" | sudo tee /etc/sddm.conf.d/virtualkbd.conf

log 'Enabling audio services...'
systemctl --user enable --now pipewire pipewire-pulse wireplumber
log 'Enabling network, bluetooth and sddm services...'
sudo systemctl enable --now bluetooth NetworkManager sddm

# Start the shell
#caelestia shell -d >/dev/null

log 'Done!'
