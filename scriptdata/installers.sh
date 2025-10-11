# This script depends on `functions' .
# This is NOT a script for execution, but for loading functions, so NOT need execution permission or shebang.
# NOTE that you NOT need to `cd ..' because the `$0' is NOT this file, but the script file which will source this file.

# The script that use this file should have two lines on its top as follows:
# cd "$(dirname "$0")"
# export base="$(pwd)"

source ./scriptdata/builders.sh

# Only for Arch(based) distro.
install-yay() {
  x sudo pacman -S --needed --noconfirm base-devel
  x git clone https://aur.archlinux.org/yay-bin.git /tmp/buildyay
  x cd /tmp/buildyay
  x makepkg -o
  x makepkg -se
  x makepkg -i --noconfirm
  x cd $base
  rm -rf /tmp/buildyay
}

# Not for Arch(based) distro.
install-agsv1() {
  x mkdir -p $base/cache/agsv1
  x cd $base/cache/agsv1
  try git init -b main
  try git remote add origin https://github.com/Aylur/ags.git
  x git pull origin main && git submodule update --init --recursive
  x git fetch --tags
  x git checkout v1.9.0
  x npm install
  x meson setup build # --reconfigure
  x meson install -C build
  x sudo mv /usr/local/bin/ags{,v1}
  x cd $base
}

# Not for Arch(based) distro.
install-Rubik() {
  x mkdir -p $base/cache/Rubik
  x cd $base/cache/Rubik
  try git init -b main
  try git remote add origin https://github.com/googlefonts/rubik.git
  x git pull origin main && git submodule update --init --recursive
  x sudo mkdir -p /usr/local/share/fonts/TTF/
  x sudo cp fonts/variable/Rubik*.ttf /usr/local/share/fonts/TTF/
  x sudo mkdir -p /usr/local/share/licenses/ttf-rubik/
  x sudo cp OFL.txt /usr/local/share/licenses/ttf-rubik/LICENSE
  x fc-cache -fv
  x gsettings set org.gnome.desktop.interface font-name 'Rubik 11'
  x cd $base
}

# Not for Arch(based) distro.
install-Gabarito() {
  x mkdir -p $base/cache/Gabarito
  x cd $base/cache/Gabarito
  try git init -b main
  try git remote add origin https://github.com/naipefoundry/gabarito.git
  x git pull origin main && git submodule update --init --recursive
  x sudo mkdir -p /usr/local/share/fonts/TTF/
  x sudo cp fonts/ttf/Gabarito*.ttf /usr/local/share/fonts/TTF/
  x sudo mkdir -p /usr/local/share/licenses/ttf-gabarito/
  x sudo cp OFL.txt /usr/local/share/licenses/ttf-gabarito/LICENSE
  x fc-cache -fv
  x cd $base
}

# Not for Arch(based) distro.
install-OneUI() {
  x mkdir -p $base/cache/OneUI4-Icons
  x cd $base/cache/OneUI4-Icons
  try git init -b main
  try git remote add origin https://github.com/end-4/OneUI4-Icons.git
  # try git remote add origin https://github.com/mjkim0727/OneUI4-Icons.git
  x git pull origin main && git submodule update --init --recursive
  x sudo mkdir -p /usr/local/share/icons
  x sudo cp -r OneUI /usr/local/share/icons
  x sudo cp -r OneUI-dark /usr/local/share/icons
  x sudo cp -r OneUI-light /usr/local/share/icons
  x cd $base
}

# Not for Arch(based) distro.
install-bibata() {
  x mkdir -p $base/cache/bibata-cursor
  x cd $base/cache/bibata-cursor
  name="Bibata-Modern-Classic"
  file="$name.tar.xz"
  # Use axel because `curl -O` always downloads a file with 0 byte size, idk why
  x axel https://github.com/ful1e5/Bibata_Cursor/releases/latest/download/$file
  tar -xf $file
  x sudo mkdir -p /usr/local/share/icons
  x sudo cp -r $name /usr/local/share/icons
  x cd $base
}

# Not for Arch(based) distro.
install-MicroTeX() {
  x mkdir -p $base/cache/MicroTeX
  x cd $base/cache/MicroTeX
  try git init -b master
  try git remote add origin https://github.com/NanoMichael/MicroTeX.git
  x git pull origin master && git submodule update --init --recursive
  x mkdir -p build
  x cd build
  x cmake ..
  x make -j32
  x sudo mkdir -p /opt/MicroTeX
  x sudo cp ./LaTeX /opt/MicroTeX/
  x sudo cp -r ./res /opt/MicroTeX/
  x cd $base
}

# Not for Arch(based) distro.
install-uv() {
  x bash <(curl -LJs "https://astral.sh/uv/install.sh")
}

# Both for Arch(based) and other distros.
install-python-packages() {
  UV_NO_MODIFY_PATH=1
  ILLOGICAL_IMPULSE_VIRTUAL_ENV=$XDG_STATE_HOME/quickshell/.venv
  x mkdir -p $(eval echo $ILLOGICAL_IMPULSE_VIRTUAL_ENV)
  # we need python 3.12 https://github.com/python-pillow/Pillow/issues/8089
  x uv venv --prompt .venv $(eval echo $ILLOGICAL_IMPULSE_VIRTUAL_ENV) -p 3.12
  x source $(eval echo $ILLOGICAL_IMPULSE_VIRTUAL_ENV)/bin/activate
  x uv pip install -r scriptdata/requirements.txt
  x deactivate # We don't need the virtual environment anymore
}

# Only for Arch(based) distro.
install-drivers-arch() {
  drivers=(mesa-utils libva-utils vulkan-tools vulkan-headers)

  # Add kernel headers
  kernel_version=$(uname -r)
  case "$kernel_version" in
  *-zen*) drivers+=(linux-zen-headers) ;;
  *-lts*) drivers+=(linux-lts-headers) ;;
  *-cachyos*) drivers+=(linux-cachyos-headers) ;;
  *) drivers+=(linux-headers) ;;
  esac

  # Detect GPU and add drivers
  gpu_info=$(lspci -nn | grep -Ei "VGA|3D|Display")

  if [[ $gpu_info == *"NVIDIA"* ]]; then
    drivers+=(libva-nvidia-driver nvidia-utils nvidia-settings nvidia-prime opencl-nvidia)
    # Choose NVIDIA driver variant
    if echo "$gpu_info" | grep -q -E "RTX [2-9][0-9]|GTX 16"; then
      drivers+=("nvidia-open-dkms")
    else
      drivers+=("nvidia-dkms")
    fi
    # Skip DKMS for CachyOS
    if [[ "$kernel_version" == *"-cachyos"* ]]; then
      drivers=("${drivers[@]/nvidia*-dkms/}")
    fi
  fi

  [[ $gpu_info == *"AMD/ATI"* ]] && drivers+=(xf86-video-amdgpu vulkan-radeon libva-mesa-driver mesa-vdpau)
  [[ $gpu_info == *"Intel"* ]] && drivers+=(libva-intel-driver intel-media-driver vulkan-intel)

  x yay -S --needed --noconfirm ${drivers[@]}
}

# Only for Arch(based) distro.
handle-deprecated-dependencies() {
  printf "\e[36m[$0]: Removing deprecated dependencies:\e[0m\n"
  for i in illogical-impulse-{microtex,pymyc-aur,ags,agsv1} {hyprutils,hyprpicker,hyprlang,hypridle,hyprland-qt-support,hyprland-qtutils,hyprlock,xdg-desktop-portal-hyprland,hyprcursor,hyprwayland-scanner,hyprland}-git; do try sudo pacman --noconfirm -Rdd $i; done
  # Convert old dependencies to non explicit dependencies so that they can be orphaned if not in meta packages
  remove_bashcomments_emptylines ./scriptdata/previous_dependencies.conf ./cache/old_deps_stripped.conf
  readarray -t old_deps_list <./cache/old_deps_stripped.conf
  pacman -Qeq >./cache/pacman_explicit_packages
  readarray -t explicitly_installed <./cache/pacman_explicit_packages

  echo "Attempting to set previously explicitly installed deps as implicit..."
  for i in "${explicitly_installed[@]}"; do for j in "${old_deps_list[@]}"; do
    [ "$i" = "$j" ] && yay -D --asdeps "$i"
  done; done

  return 0
}

# Only for Arch(based) distro.
# https://github.com/end-4/dots-hyprland/issues/581
# yay -Bi is kinda hit or miss, instead cd into the relevant directory and manually source and install deps
install-local-pkgbuild() {
  local location=$1

  x pushd $location

  source ./PKGBUILD
  x yay -S --needed --noconfirm --asdeps "${depends[@]}"
  x makepkg -Asi --noconfirm

  x popd
}

install-dependencies-arch() {
  # Install core dependencies from the meta-packages
  metapkgs=(./arch-packages/illogical-impulse-{audio,backlight,basic,fonts-themes,kde,portal,python,screencapture,toolkit,widgets})
  metapkgs+=(./arch-packages/illogical-impulse-hyprland)
  metapkgs+=(./arch-packages/illogical-impulse-microtex-git)
  # metapkgs+=(./arch-packages/illogical-impulse-oneui4-icons-git)
  [[ -f /usr/share/icons/Bibata-Modern-Classic/index.theme ]] ||
    metapkgs+=(./arch-packages/illogical-impulse-bibata-modern-classic-bin)

  for i in "${metapkgs[@]}"; do
    x install-local-pkgbuild "$i"
  done
}

function install-adw-gtk3-theme {
  local VERSION="2024-10-25"
  local DOWNLOAD_URL="https://github.com/ronny-rentner/adwaita-gtk3-gtk4-theme/releases/download/nightly-${VERSION}/adw-gtk3-gtk4-${VERSION}.tgz"
  local TARBALL="adw-gtk3-gtk4-${VERSION}.tgz"

  echo -e "\e[34m[$0]: Installing ADW-GTK3 theme...\e[0m"

  # Download the tarball
  if [[ -f "$TARBALL" ]]; then
    echo -e "\e[33m[$0]: Tarball already exists, skipping download.\e[0m"
  else
    if command -v wget &>/dev/null; then
      x wget -O "$TARBALL" "$DOWNLOAD_URL"
    elif command -v curl &>/dev/null; then
      x curl -L -o "$TARBALL" "$DOWNLOAD_URL"
    else
      echo -e "\e[31mError: Neither wget nor curl found. Please install one of them.\e[0m"
      return 1
    fi
  fi

  # Extract and install
  x tar -xzf "$TARBALL"

  # Create themes directory
  x mkdir -p ~/.local/share/themes

  # Copy both light and dark themes
  echo -e "\e[34m[$0]: Installing ADW-GTK3 light theme...\e[0m"
  x cp -r adw-gtk3/ ~/.local/share/themes/

  echo -e "\e[34m[$0]: Installing ADW-GTK3 dark theme...\e[0m"
  x cp -r adw-gtk3-dark/ ~/.local/share/themes/

  echo -e "\e[34m[$0]: ADW-GTK3 theme installed successfully!\e[0m"
}

function install-darkly-theme {
  local VERSION="0.5.23"
  local DOWNLOAD_URL="https://github.com/Bali10050/Darkly/archive/refs/tags/v${VERSION}.tar.gz"
  local TARBALL="darkly-${VERSION}.tar.gz"
  local EXTRACT_DIR="Darkly-${VERSION}"

  echo -e "\e[34m[$0]: Installing Darkly theme...\e[0m"

  echo -e "\e[34m[$0]: Installing build dependencies (ECM, Qt5, Qt6)...\e[0m"
  x sudo apt install -y extra-cmake-modules cmake qt6-base-dev qt6-declarative-dev qt5-default qtdeclarative5-dev

  # Download the tarball
  if [[ -f "$TARBALL" ]]; then
    echo -e "\e[33m[$0]: Tarball already exists, skipping download.\e[0m"
  else
    if command -v wget &>/dev/null; then
      x wget -O "$TARBALL" "$DOWNLOAD_URL"
    elif command -v curl &>/dev/null; then
      x curl -L -o "$TARBALL" "$DOWNLOAD_URL"
    else
      echo -e "\e[31mError: Neither wget nor curl found. Please install one of them.\e[0m"
      return 1
    fi
  fi

  # Extract and install
  x tar -xzf "$TARBALL"
  x pushd "$EXTRACT_DIR"
  x ./install.sh
  x popd

  echo -e "\e[34m[$0]: Darkly theme installed successfully!\e[0m"
}

function install-nerd-fonts-jetbrains-mono {
  local VERSION="3.4.0"
  local DOWNLOAD_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v${VERSION}/JetBrainsMono.tar.xz"
  local TARBALL="JetBrainsMono-${VERSION}.tar.xz"

  echo -e "\e[34m[$0]: Installing JetBrains Mono Nerd Font...\e[0m"

  # Download the tarball
  if [[ -f "$TARBALL" ]]; then
    echo -e "\e[33m[$0]: Tarball already exists, skipping download.\e[0m"
  else
    if command -v wget &>/dev/null; then
      x wget -O "$TARBALL" "$DOWNLOAD_URL"
    elif command -v curl &>/dev/null; then
      x curl -L -o "$TARBALL" "$DOWNLOAD_URL"
    else
      echo -e "\e[31mError: Neither wget nor curl found. Please install one of them.\e[0m"
      return 1
    fi
  fi

  # Extract to fonts directory
  x mkdir -p ~/.local/share/fonts
  x tar -xf "$TARBALL" -C ~/.local/share/fonts
  x fc-cache -fv

  echo -e "\e[34m[$0]: JetBrains Mono Nerd Font installed successfully!\e[0m"
}

function install-kde-material-you-colors {
  echo -e "\e[34m[$0]: Installing KDE Material You Colors...\e[0m"

  # Install pipx if not available
  if ! command -v pipx &>/dev/null; then
    echo -e "\e[33m[$0]: pipx not found, installing...\e[0m"
    x sudo apt update
    x sudo apt install -y pipx
    x pipx ensurepath
  fi

  # Install dependencies
  echo -e "\e[34m[$0]: Installing build dependencies...\e[0m"
  x sudo apt install -y gcc python3-dbus libglib2.0-dev python3-dev libdbus-1-dev libdbus-glib-1-dev

  # Install the package
  x pipx install kde-material-you-colors
  x pipx inject kde-material-you-colors pywal16

  echo -e "\e[34m[$0]: KDE Material You Colors installed successfully!\e[0m"
}

function install-matugen {
  echo -e "\e[34m[$0]: Installing Matugen...\e[0m"

  # Install Rust if not available
  if ! command -v cargo &>/dev/null; then
    echo -e "\e[33m[$0]: Rust/Cargo not found, installing...\e[0m"
    x sudo apt update
    x sudo apt install -y rustup
    x rustup default stable
  fi

  # Install matugen
  x cargo install matugen

  echo -e "\e[34m[$0]: Matugen installed successfully!\e[0m"
}

function install-translate-shell {
  echo -e "\e[34m[$0]: Installing translate-shell...\e[0m"

  # Install recommended dependencies for full functionality
  echo -e "\e[34m[$0]: Installing recommended dependencies for translate-shell...\e[0m"
  x sudo apt update
  x sudo apt install -y \
    curl \
    libfribidi-dev \
    mplayer \
    mpv \
    mpg123 \
    espeak \
    less \
    rlwrap \
    aspell \
    aspell-en \
    hunspell \
    hunspell-en-us

  # Download the self-contained executable
  echo -e "\e[34m[$0]: Downloading translate-shell executable...\e[0m"
  if command -v wget &>/dev/null; then
    x wget -O trans "https://git.io/trans"
  elif command -v curl &>/dev/null; then
    x curl -L -o trans "https://git.io/trans"
  else
    echo -e "\e[31mError: Neither wget nor curl found. Please install one of them.\e[0m"
    return 1
  fi

  # Make executable and install system-wide
  x chmod +x trans
  x sudo mv trans /usr/local/bin/

  echo -e "\e[34m[$0]: translate-shell installed successfully!\e[0m"
  echo -e "\e[34m[$0]: Usage: trans 'Hello world' -t es\e[0m"
}

install-dependencies-debian() {
  echo -e "\e[34m[$0]: Starting Debian dependencies installation...\e[0m"

  echo -e "\e[34m[$0]: Updating package lists...\e[0m"
  x sudo apt update

  echo -e "\e[34m[$0]: Installing audio dependencies (cava, pavucontrol-qt, wireplumber, libdbusmenu-gtk3-4, playerctl)...\e[0m"
  x sudo apt install -y cava pavucontrol-qt wireplumber libdbusmenu-gtk3-4 playerctl

  echo -e "\e[34m[$0]: Installing backlight dependencies (geoclue, brightnessctl, ddcutil)...\e[0m"
  x sudo apt install -y geoclue-2.0 brightnessctl ddcutil

  echo -e "\e[34m[$0]: Installing basic dependencies (axel, bc, coreutils, cliphist, cmake, curl, rsync, wget, ripgrep, jq, meson, xdg-user-dirs)...\e[0m"
  x sudo apt install -y axel bc coreutils cliphist cmake curl rsync wget ripgrep jq meson xdg-user-dirs

  echo -e "\e[34m[$0]: Installing font and theme base packages (breeze, eza, fish, fontconfig, kitty, starship)...\e[0m"
  x sudo apt install -y breeze eza fish fontconfig kitty starship

  echo -e "\e[34m[$0]: Installing ADW-GTK3 theme...\e[0m"
  x install-adw-gtk3-theme

  echo -e "\e[34m[$0]: Installing Darkly theme...\e[0m"
  x install-darkly-theme

  echo -e "\e[34m[$0]: Installing JetBrains Mono Nerd Font...\e[0m"
  x install-nerd-fonts-jetbrains-mono

  echo -e "\e[34m[$0]: Installing KDE Material You Colors...\e[0m"
  x install-kde-material-you-colors

  echo -e "\e[34m[$0]: Installing Matugen...\e[0m"
  x install-matugen

  echo -e "\e[34m[$0]: Installing KDE dependencies (bluedevil, gnome-keyring, network-manager, plasma-nm, polkit-kde-agent-1, dolphin, systemsettings)...\e[0m"
  x sudo apt install -y bluedevil gnome-keyring network-manager plasma-nm polkit-kde-agent-1 dolphin systemsettings

  echo -e "\e[34m[$0]: Installing portal dependencies (xdg-desktop-portal, xdg-desktop-portal-kde, xdg-desktop-portal-gtk)...\e[0m"
  x sudo apt install -y xdg-desktop-portal xdg-desktop-portal-kde xdg-desktop-portal-gtk

  echo -e "\e[34m[$0]: Installing Python and development dependencies (clang, GTK4, libadwaita, libsoup3, libportal-gtk4, gobject-introspection, sassc, python3-opencv)...\e[0m"
  x sudo apt install -y clang libgtk-4-dev libadwaita-1-dev libsoup-3.0-dev libportal-gtk4-dev gobject-introspection libgirepository1.0-dev sassc python3-opencv

  echo -e "\e[34m[$0]: Installing uv (Python package manager)...\e[0m"
  x curl -LsSf https://astral.sh/uv/install.sh | sh

  echo -e "\e[34m[$0]: Installing screencapture dependencies (slurp, swappy, tesseract-ocr, tesseract-ocr-eng, wf-recorder)...\e[0m"
  x sudo apt install -y slurp swappy tesseract-ocr tesseract-ocr-eng wf-recorder

  echo -e "\e[34m[$0]: Installing toolkit dependencies (kdialog, Qt6 components, syntax-highlighting, upower, wtype, ydotool)...\e[0m"
  x sudo apt install -y kdialog qt6-5compat-dev qt6-avif-image-plugin qt6-base-dev qt6-declarative-dev qt6-image-formats-plugins qt6-multimedia-dev qt6-positioning-dev qt6-quicktimeline-dev qt6-sensors-dev qt6-svg-dev qt6-tools-dev qt6-translations qt6-virtualkeyboard-dev qt6-wayland-dev libkf6syntaxhighlighting-dev upower wtype ydotool

  echo -e "\e[34m[$0]: Installing widget dependencies (network-manager-applet, fuzzel, glib2, wlogout)...\e[0m"
  x sudo apt install -y network-manager-applet fuzzel libglib2.0-bin wlogout

  echo -e "\e[34m[$0]: Installing translate-shell...\e[0m"
  x install-translate-shell

  echo -e "\e[34m[$0]: Building Hyprland and all components...\e[0m"
  x build-hyprland

  echo -e "\e[34m[$0]: Debian dependencies installation completed successfully!\e[0m"
}
