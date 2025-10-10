# This script depends on `functions' .
# This is NOT a script for execution, but for loading functions, so NOT need execution permission or shebang.
# NOTE that you NOT need to `cd ..' because the `$0' is NOT this file, but the script file which will source this file.

# The script that use this file should have two lines on its top as follows:
# cd "$(dirname "$0")"
# export base="$(pwd)"

build-hyprland() {
  echo -e "\e[34m[$0]: Starting hyprland ecosystem build...\e[0m"

  echo -e "\e[34m[$0]: Building Aquamarine (Hyprland's window management library)...\e[0m"
  x build-aquamarine

  echo -e "\e[34m[$0]: Building Hyprlang (configuration language library)...\e[0m"
  x build-hyprlang

  echo -e "\e[34m[$0]: Building Hyprcursor (cursor theme library)...\e[0m"
  x build-hyprcursor

  echo -e "\e[34m[$0]: Building Hyprutils (utility library)...\e[0m"
  x build-hyprutils

  echo -e "\e[34m[$0]: Building Hyprgraphics (graphics rendering library)...\e[0m"
  x build-hyprgraphics

  echo -e "\e[34m[$0]: Building Hyprwayland-scanner (Wayland protocol scanner)...\e[0m"
  x build-hyprwayland-scanner

  echo -e "\e[34m[$0]: Building Hyprland-protocols (Wayland protocols)...\e[0m"
  x build-hyprland-protocols

  echo -e "\e[34m[$0]: Building Hypridle (idle management daemon)...\e[0m"
  x build-hypridle

  echo -e "\e[34m[$0]: Building Hyprland Qt support (Qt6 integration)...\e[0m"
  x build-hyprland-qt-support

  echo -e "\e[34m[$0]: Building Hyprland Qt utilities (Qt6 tools)...\e[0m"
  x build-hyprland-qtutils

  echo -e "\e[34m[$0]: Building Hyprlock (screen locker)...\e[0m"
  x build-hyprlock

  echo -e "\e[34m[$0]: Building Hyprpicker (color picker)...\e[0m"
  x build-hyprpicker

  echo -e "\e[34m[$0]: Building XDG Desktop Portal Hyprland (desktop integration)...\e[0m"
  x build-xdg-desktop-portal-hyprland

  echo -e "\e[34m[$0]: Building Hyprsunset (blue light filter)...\e[0m"
  x build-hyprsunset

  echo -e "\e[34m[$0]: Building Hyprshot (screenshot utility)...\e[0m"
  x build-hyprshot

  echo -e "\e[34m[$0]: Installing wl-clipboard (Wayland clipboard utility)...\e[0m"
  x sudo apt update
  x sudo apt install -y wl-clipboard

  echo -e "\e[34m[$0]: Hyprland ecosystem build completed successfully!\e[0m"
}

function build-aquamarine {
  local VERSION="0.9.5"
  local DOWNLOAD_URL="https://github.com/hyprwm/aquamarine/archive/refs/tags/v${VERSION}.tar.gz"
  local TARBALL="aquamarine-${VERSION}.tar.gz"
  local EXTRACT_DIR="aquamarine-${VERSION}"

  echo -e "\e[34m[$0]: Starting aquamarine build...\e[0m"

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

  # Extract the tarball
  if [[ -d "$EXTRACT_DIR" ]]; then
    echo -e "\e[33m[$0]: Directory already exists, skipping extraction.\e[0m"
  else
    x tar -xzf "$TARBALL"
  fi

  # Change to the extracted directory and build
  x pushd "$EXTRACT_DIR"

  # Build the project
  x cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
  x cmake --build ./build --config Release --target all -j$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)

  # Return to original directory
  x popd

  echo -e "\e[34m[$0]: aquamarine build completed successfully!\e[0m"
}

function build-hyprlang {
  local VERSION="0.6.4"
  local DOWNLOAD_URL="https://github.com/hyprwm/hyprlang/archive/refs/tags/v${VERSION}.tar.gz"
  local TARBALL="hyprlang-${VERSION}.tar.gz"
  local EXTRACT_DIR="hyprlang-${VERSION}"

  echo -e "\e[34m[$0]: Starting hyprlang build...\e[0m"

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

  # Extract the tarball
  if [[ -d "$EXTRACT_DIR" ]]; then
    echo -e "\e[33m[$0]: Directory already exists, skipping extraction.\e[0m"
  else
    x tar -xzf "$TARBALL"
  fi

  # Change to the extracted directory and build
  x pushd "$EXTRACT_DIR"

  # Build the project
  x cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
  x cmake --build ./build --config Release --target hyprlang -j$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)

  # Install with sudo
  x sudo cmake --install ./build

  # Return to original directory
  x popd

  echo -e "\e[34m[$0]: hyprlang build and installation completed successfully!\e[0m"
}

function build-hyprcursor {
  local VERSION="0.1.13"
  local DOWNLOAD_URL="https://github.com/hyprwm/hyprcursor/archive/refs/tags/v${VERSION}.tar.gz"
  local TARBALL="hyprcursor-${VERSION}.tar.gz"
  local EXTRACT_DIR="hyprcursor-${VERSION}"

  echo -e "\e[34m[$0]: Starting hyprcursor build...\e[0m"

  # Install build dependencies
  echo -e "\e[34m[$0]: Installing build dependencies for hyprcursor...\e[0m"
  x sudo apt update
  x sudo apt install -y libcairo2-dev libzip-dev librsvg2-dev libtomlplusplus-dev

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

  # Extract the tarball
  if [[ -d "$EXTRACT_DIR" ]]; then
    echo -e "\e[33m[$0]: Directory already exists, skipping extraction.\e[0m"
  else
    x tar -xzf "$TARBALL"
  fi

  # Change to the extracted directory and build
  x pushd "$EXTRACT_DIR"

  # Build the project
  x cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
  x cmake --build ./build --config Release --target all -j$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)

  # Install with sudo
  x sudo cmake --install ./build

  # Return to original directory
  x popd

  echo -e "\e[34m[$0]: hyprcursor build and installation completed successfully!\e[0m"
}

function build-hyprutils {
  local VERSION="0.10.0"
  local DOWNLOAD_URL="https://github.com/hyprwm/hyprutils/archive/refs/tags/v${VERSION}.tar.gz"
  local TARBALL="hyprutils-${VERSION}.tar.gz"
  local EXTRACT_DIR="hyprutils-${VERSION}"

  echo -e "\e[34m[$0]: Starting hyprutils build...\e[0m"

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

  # Extract the tarball
  if [[ -d "$EXTRACT_DIR" ]]; then
    echo -e "\e[33m[$0]: Directory already exists, skipping extraction.\e[0m"
  else
    x tar -xzf "$TARBALL"
  fi

  # Change to the extracted directory and build
  x pushd "$EXTRACT_DIR"

  # Build the project
  x cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
  x cmake --build ./build --config Release --target all -j$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)

  # Install with sudo
  x sudo cmake --install ./build

  # Return to original directory
  x popd

  echo -e "\e[34m[$0]: hyprutils build and installation completed successfully!\e[0m"
}

function build-hyprgraphics {
  local VERSION="0.2.0"
  local DOWNLOAD_URL="https://github.com/hyprwm/hyprgraphics/archive/refs/tags/v${VERSION}.tar.gz"
  local TARBALL="hyprgraphics-${VERSION}.tar.gz"
  local EXTRACT_DIR="hyprgraphics-${VERSION}"

  echo -e "\e[34m[$0]: Starting hyprgraphics build...\e[0m"

  # Install build dependencies
  echo -e "\e[34m[$0]: Installing build dependencies for hyprgraphics...\e[0m"
  x sudo apt update
  x sudo apt install -y libpixman-1-dev libjpeg-dev libwebp-dev libmagic-dev libpng-dev librsvg2-dev

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

  # Extract the tarball
  if [[ -d "$EXTRACT_DIR" ]]; then
    echo -e "\e[33m[$0]: Directory already exists, skipping extraction.\e[0m"
  else
    x tar -xzf "$TARBALL"
  fi

  # Change to the extracted directory and build
  x pushd "$EXTRACT_DIR"

  # Build the project
  x cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
  x cmake --build ./build --config Release --target all -j$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)

  # Install with sudo
  x sudo cmake --install ./build

  # Return to original directory
  x popd

  echo -e "\e[34m[$0]: hyprgraphics build and installation completed successfully!\e[0m"
}

function build-hyprwayland-scanner {
  local VERSION="0.4.5"
  local DOWNLOAD_URL="https://github.com/hyprwm/hyprwayland-scanner/archive/refs/tags/v${VERSION}.tar.gz"
  local TARBALL="hyprwayland-scanner-${VERSION}.tar.gz"
  local EXTRACT_DIR="hyprwayland-scanner-${VERSION}"

  echo -e "\e[34m[$0]: Starting hyprwayland-scanner build...\e[0m"

  # Install build dependencies
  echo -e "\e[34m[$0]: Installing build dependencies for hyprwayland-scanner...\e[0m"
  x sudo apt update
  x sudo apt install -y libpugixml-dev

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

  # Extract the tarball
  if [[ -d "$EXTRACT_DIR" ]]; then
    echo -e "\e[33m[$0]: Directory already exists, skipping extraction.\e[0m"
  else
    x tar -xzf "$TARBALL"
  fi

  # Change to the extracted directory and build
  x pushd "$EXTRACT_DIR"

  # Build the project
  x cmake -DCMAKE_INSTALL_PREFIX=/usr -B build
  x cmake --build build -j $(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)

  # Install with sudo
  x sudo cmake --install build

  # Return to original directory
  x popd

  echo -e "\e[34m[$0]: hyprwayland-scanner build and installation completed successfully!\e[0m"
}

function build-hyprland-protocols {
  local VERSION="0.7.0"
  local DOWNLOAD_URL="https://github.com/hyprwm/hyprland-protocols/archive/refs/tags/v${VERSION}.tar.gz"
  local TARBALL="hyprland-protocols-${VERSION}.tar.gz"
  local EXTRACT_DIR="hyprland-protocols-${VERSION}"

  echo -e "\e[34m[$0]: Starting hyprland-protocols build...\e[0m"

  # Install meson if not available
  if ! command -v meson &>/dev/null; then
    echo -e "\e[33m[$0]: Meson not found, installing...\e[0m"
    x sudo apt update
    x sudo apt install -y meson ninja-build
  fi

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

  # Extract the tarball
  if [[ -d "$EXTRACT_DIR" ]]; then
    echo -e "\e[33m[$0]: Directory already exists, skipping extraction.\e[0m"
  else
    x tar -xzf "$TARBALL"
  fi

  # Change to the extracted directory and build
  x pushd "$EXTRACT_DIR"

  # Build and install
  x meson setup build
  x sudo meson install -C build

  # Return to original directory
  x popd

  echo -e "\e[34m[$0]: hyprland-protocols build and installation completed successfully!\e[0m"
}

function build-hypridle {
  local VERSION="0.1.7"
  local DOWNLOAD_URL="https://github.com/hyprwm/hypridle/archive/refs/tags/v${VERSION}.tar.gz"
  local TARBALL="hypridle-${VERSION}.tar.gz"
  local EXTRACT_DIR="hypridle-${VERSION}"

  echo -e "\e[34m[$0]: Starting hypridle build...\e[0m"

  # Install build dependencies
  echo -e "\e[34m[$0]: Installing build dependencies for hypridle...\e[0m"
  x sudo apt update
  x sudo apt install -y libwayland-dev wayland-protocols libsdbus-c++-dev

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

  # Extract the tarball
  if [[ -d "$EXTRACT_DIR" ]]; then
    echo -e "\e[33m[$0]: Directory already exists, skipping extraction.\e[0m"
  else
    x tar -xzf "$TARBALL"
  fi

  # Change to the extracted directory and build
  x pushd "$EXTRACT_DIR"

  # Build the project
  x cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
  x cmake --build ./build --config Release --target all -j$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)

  # Install with sudo
  x sudo cmake --install ./build

  # Return to original directory
  x popd

  echo -e "\e[34m[$0]: hypridle build and installation completed successfully!\e[0m"
}

function build-hyprland-qt-support {
  local VERSION="0.1.0"
  local DOWNLOAD_URL="https://github.com/hyprwm/hyprland-qt-support/archive/refs/tags/v${VERSION}.tar.gz"
  local TARBALL="hyprland-qt-support-${VERSION}.tar.gz"
  local EXTRACT_DIR="hyprland-qt-support-${VERSION}"

  echo -e "\e[34m[$0]: Starting hyprland-qt-support build...\e[0m"

  # Install Qt6 dependencies
  echo -e "\e[34m[$0]: Installing Qt6 dependencies...\e[0m"
  x sudo apt update
  x sudo apt install -y qt6-base-dev qt6-declarative-dev

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

  # Extract the tarball
  if [[ -d "$EXTRACT_DIR" ]]; then
    echo -e "\e[33m[$0]: Directory already exists, skipping extraction.\e[0m"
  else
    x tar -xzf "$TARBALL"
  fi

  # Change to the extracted directory and build
  x pushd "$EXTRACT_DIR"

  # Build with the specific QML installation prefix
  x cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -DINSTALL_QML_PREFIX=/lib/qt6/qml -S . -B ./build
  x cmake --build ./build --config Release --target all -j$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)

  # Install with sudo
  x sudo cmake --install ./build

  # Return to original directory
  x popd

  echo -e "\e[34m[$0]: hyprland-qt-support build and installation completed successfully!\e[0m"
}

function build-hyprland-qtutils {
  local VERSION="0.1.5"
  local DOWNLOAD_URL="https://github.com/hyprwm/hyprland-qtutils/archive/refs/tags/v${VERSION}.tar.gz"
  local TARBALL="hyprland-qtutils-${VERSION}.tar.gz"
  local EXTRACT_DIR="hyprland-qtutils-${VERSION}"

  echo -e "\e[34m[$0]: Starting hyprland-qtutils build...\e[0m"

  # Install Qt6 dependencies (if not already installed from hyprland-qt-support)
  echo -e "\e[34m[$0]: Installing Qt6 dependencies...\e[0m"
  x sudo apt update
  x sudo apt install -y qt6-base-dev qt6-declarative-dev

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

  # Extract the tarball
  if [[ -d "$EXTRACT_DIR" ]]; then
    echo -e "\e[33m[$0]: Directory already exists, skipping extraction.\e[0m"
  else
    x tar -xzf "$TARBALL"
  fi

  # Change to the extracted directory and build
  x pushd "$EXTRACT_DIR"

  # Build the project
  x cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
  x cmake --build ./build --config Release --target all -j$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)

  # Install with sudo
  x sudo cmake --install ./build

  # Return to original directory
  x popd

  echo -e "\e[34m[$0]: hyprland-qtutils build and installation completed successfully!\e[0m"
}

function build-hyprlock {
  local VERSION="0.9.2"
  local DOWNLOAD_URL="https://github.com/hyprwm/hyprlock/archive/refs/tags/v${VERSION}.tar.gz"
  local TARBALL="hyprlock-${VERSION}.tar.gz"
  local EXTRACT_DIR="hyprlock-${VERSION}"

  echo -e "\e[34m[$0]: Starting hyprlock build...\e[0m"

  # Install build dependencies
  echo -e "\e[34m[$0]: Installing build dependencies for hyprlock...\e[0m"
  x sudo apt update
  x sudo apt install -y \
    libgbm-dev \
    libdrm-dev \
    libglvnd-dev \
    libpam0g-dev \
    libpango1.0-dev \
    libsdbus-c++-dev \
    libwayland-dev \
    libxkbcommon-dev

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

  # Extract the tarball
  if [[ -d "$EXTRACT_DIR" ]]; then
    echo -e "\e[33m[$0]: Directory already exists, skipping extraction.\e[0m"
  else
    x tar -xzf "$TARBALL"
  fi

  # Change to the extracted directory and build
  x pushd "$EXTRACT_DIR"

  # Build the project with specific target
  x cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -S . -B ./build
  x cmake --build ./build --config Release --target hyprlock -j$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)

  # Install with sudo
  x sudo cmake --install ./build

  # Return to original directory
  x popd

  echo -e "\e[34m[$0]: hyprlock build and installation completed successfully!\e[0m"
}

function build-hyprpicker {
  local VERSION="0.4.5"
  local DOWNLOAD_URL="https://github.com/hyprwm/hyprpicker/archive/refs/tags/v${VERSION}.tar.gz"
  local TARBALL="hyprpicker-${VERSION}.tar.gz"
  local EXTRACT_DIR="hyprpicker-${VERSION}"

  echo -e "\e[34m[$0]: Starting hyprpicker build...\e[0m"

  # Install pkg-config if not available
  if ! command -v pkg-config &>/dev/null; then
    echo -e "\e[33m[$0]: pkg-config not found, installing...\e[0m"
    x sudo apt update
    x sudo apt install -y pkg-config
  fi

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

  # Extract the tarball
  if [[ -d "$EXTRACT_DIR" ]]; then
    echo -e "\e[33m[$0]: Directory already exists, skipping extraction.\e[0m"
  else
    x tar -xzf "$TARBALL"
  fi

  # Change to the extracted directory and build
  x pushd "$EXTRACT_DIR"

  # Build the project with specific target
  x cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
  x cmake --build ./build --config Release --target hyprpicker -j$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)

  # Install with sudo
  x sudo cmake --install ./build

  # Return to original directory
  x popd

  echo -e "\e[34m[$0]: hyprpicker build and installation completed successfully!\e[0m"
}

function build-xdg-desktop-portal-hyprland {
  local VERSION="1.3.10"
  local DOWNLOAD_URL="https://github.com/hyprwm/xdg-desktop-portal-hyprland/archive/refs/tags/v${VERSION}.tar.gz"
  local TARBALL="xdg-desktop-portal-hyprland-${VERSION}.tar.gz"
  local EXTRACT_DIR="xdg-desktop-portal-hyprland-${VERSION}"

  echo -e "\e[34m[$0]: Starting xdg-desktop-portal-hyprland build...\e[0m"

  # Install remaining build dependencies
  echo -e "\e[34m[$0]: Installing build dependencies for xdg-desktop-portal-hyprland...\e[0m"
  x sudo apt update
  x sudo apt install -y libpipewire-0.3-dev libspa-0.2-dev

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

  # Extract the tarball
  if [[ -d "$EXTRACT_DIR" ]]; then
    echo -e "\e[33m[$0]: Directory already exists, skipping extraction.\e[0m"
  else
    x tar -xzf "$TARBALL"
  fi

  # Change to the extracted directory and build
  x pushd "$EXTRACT_DIR"

  # Remove vendored sdbus-cpp source to prevent build failures:cite[5]
  x rm -rf subprojects/sdbus-cpp

  # Build the project:cite[5]
  x cmake -DCMAKE_INSTALL_LIBEXECDIR=/usr/lib -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -B build
  x cmake --build build

  # Install with sudo
  x sudo cmake --install build

  # Return to original directory
  x popd

  echo -e "\e[34m[$0]: xdg-desktop-portal-hyprland build and installation completed successfully!\e[0m"
}

function build-hyprsunset {
  local VERSION="0.3.3" # Check https://github.com/hyprwm/hyprsunset/releases for the latest:cite[2]
  local DOWNLOAD_URL="https://github.com/hyprwm/hyprsunset/archive/refs/tags/v${VERSION}.tar.gz"
  local TARBALL="hyprsunset-${VERSION}.tar.gz"
  local EXTRACT_DIR="hyprsunset-${VERSION}"

  echo -e "\e[34m[$0]: Starting hyprsunset build...\e[0m"

  # Install build dependencies
  echo -e "\e[34m[$0]: Installing build dependencies for hyprsunset...\e[0m"
  x sudo apt update
  x sudo apt install -y cmake ninja-build pkgconf libwayland-dev wayland-protocols

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

  # Extract the tarball
  if [[ -d "$EXTRACT_DIR" ]]; then
    echo -e "\e[33m[$0]: Directory already exists, skipping extraction.\e[0m"
  else
    x tar -xzf "$TARBALL"
  fi

  # Change to the extracted directory and build
  x pushd "$EXTRACT_DIR"

  # Build the project
  x cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
  x cmake --build ./build --config Release --target all -j$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)

  # Install with sudo
  x sudo cmake --install ./build

  # Return to original directory
  x popd

  echo -e "\e[34m[$0]: hyprsunset build and installation completed successfully!\e[0m"
}

function build-hyprshot {
  local VERSION="1.3.0"
  local DOWNLOAD_URL="https://github.com/Gustash/Hyprshot/archive/refs/tags/${VERSION}.tar.gz"
  local TARBALL="hyprshot-${VERSION}.tar.gz"
  local EXTRACT_DIR="Hyprshot-${VERSION}"

  echo -e "\e[34m[$0]: Installing hyprshot...\e[0m"

  # Install dependencies
  echo -e "\e[34m[$0]: Installing hyprshot dependencies...\e[0m"
  x sudo apt update
  x sudo apt install -y jq grim slurp wl-clipboard libnotify-bin

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

  # Extract the tarball
  if [[ -d "$EXTRACT_DIR" ]]; then
    echo -e "\e[33m[$0]: Directory already exists, skipping extraction.\e[0m"
  else
    x tar -xzf "$TARBALL"
  fi

  # Change to the extracted directory
  x pushd "$EXTRACT_DIR"

  # Make the script executable and install it
  x chmod +x hyprshot
  x sudo cp hyprshot /usr/local/bin/

  # Return to original directory
  x popd

  echo -e "\e[34m[$0]: hyprshot installed successfully!\e[0m"
  echo -e "\e[34m[$0]: Usage: hyprshot [mode] [option]"
  echo -e "\e[34m[$0]: Modes: -r (region), -w (window), -m (monitor)"
  echo -e "\e[34m[$0]: Options: -s (save to file), -c (copy to clipboard)\e[0m"
}

function build-quickshell-git {
  local VERSION="0.2.0"
  local DOWNLOAD_URL="https://github.com/quickshell-mirror/quickshell/archive/refs/tags/v${VERSION}.tar.gz"
  local TARBALL="quickshell-git-${VERSION}.tar.gz"
  local EXTRACT_DIR="quickshell-${VERSION}"

  echo -e "\e[34m[$0]: Starting quickshell-git build...\e[0m"

  # Install build dependencies
  echo -e "\e[34m[$0]: Installing build dependencies for quickshell-git...\e[0m"
  x sudo apt update
  x sudo apt install -y \
    qt6-declarative-dev \
    qt6-base-dev \
    libjemalloc-dev \
    qt6-svg-dev \
    libpipewire-0.3-dev \
    qt6-wayland-dev \
    libxcb1-dev \
    libwayland-dev \
    libdrm-dev \
    libgbm-dev \
    mesa-common-dev \
    spirv-tools \
    qt6-shadertools-dev \
    wayland-protocols \
    libcli11-dev \
    ninja-build \
    cmake \
    git

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

  # Extract the tarball
  if [[ -d "$EXTRACT_DIR" ]]; then
    echo -e "\e[33m[$0]: Directory already exists, skipping extraction.\e[0m"
  else
    x tar -xzf "$TARBALL"
  fi

  # Change to the extracted directory and build
  x pushd "$EXTRACT_DIR"

  # Build the project with specific CMake flags for packaging
  x cmake -GNinja -B build \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DDISTRIBUTOR="Manual Build (Debian)" \
    -DDISTRIBUTOR_DEBUGINFO_AVAILABLE=NO \
    -DINSTALL_QML_PREFIX=lib/qt6/qml

  x cmake --build build

  # Install with sudo
  x sudo cmake --install build

  # Return to original directory
  x popd

  echo -e "\e[34m[$0]: quickshell-git build and installation completed successfully!\e[0m"
}
