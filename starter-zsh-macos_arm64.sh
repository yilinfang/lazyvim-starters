#!/bin/bash

# Set up directories
PREFIX="$HOME/.nvim-starter"

# Create the prefix directory if it doesn't exist
mkdir -p "$PREFIX"

INSTALL_DIR="$PREFIX/bin"
TEMP_DIR="$PREFIX/tmp"
NEOVIM_DIR="$PREFIX/neovim"
NODEJS_DIR="$PREFIX/nodejs"
NVIM_CONFIG_DIR="$HOME/.config/nvim"
TMUX_CONFIG_DIR="$HOME/.config/tmux"
ZELLIJ_CONFIG_DIR="$HOME/.config/zellij"

# URLs for tools
NEOVIM_URL="https://github.com/neovim/neovim/releases/download/v0.10.4/nvim-macos-arm64.tar.gz"
NODEJS_URL="https://nodejs.org/dist/v22.14.0/node-v22.14.0-darwin-arm64.tar.gz"
ZELLIJ_URL="https://github.com/zellij-org/zellij/releases/download/v0.41.2/zellij-aarch64-apple-darwin.tar.gz"
FD_URL="https://github.com/sharkdp/fd/releases/download/v10.2.0/fd-v10.2.0-aarch64-apple-darwin.tar.gz"
RG_URL="https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep-14.1.1-aarch64-apple-darwin.tar.gz"
BAT_URL="https://github.com/sharkdp/bat/releases/download/v0.25.0/bat-v0.25.0-aarch64-apple-darwin.tar.gz"
FZF_URL="https://github.com/junegunn/fzf/releases/download/v0.60.2/fzf-0.60.2-darwin_arm64.tar.gz"
LAZYGIT_URL="https://github.com/jesseduffield/lazygit/releases/download/v0.47.2/lazygit_0.47.2_Darwin_arm64.tar.gz"

# Configuration repositories
NVIM_CONFIG_REPO="https://github.com/yilinfang/nvim.git"
TMUX_CONFIG_REPO="https://github.com/yilinfang/tmux.git"
ZELLIJ_CONFIG_REPO="https://github.com/yilinfang/zellij.git"

# Installation tracking variables
INSTALLED_TOOL=0

# Function to display menu and get user selection
show_menu() {
  echo "Select tools to install (enter numbers separated by space, or 'a' for all):"
  echo "1. Neovim"
  echo "2. Node.js"
  echo "3. Zellij"
  echo "4. fd"
  echo "5. ripgrep"
  echo "6. bat"
  echo "7. fzf"
  echo "8. lazygit"
  echo "9. Neovim config"
  echo "10. tmux config"
  echo "11. Zellij config"
  echo "a. Install all"

  read -p "Your choice: " CHOICE
}

# Installation functions
install_neovim() {
  echo "Installing Neovim..."
  rm -rf "$NEOVIM_DIR"
  mkdir -p "$NEOVIM_DIR"
  curl -L "$NEOVIM_URL" -o "$TEMP_DIR/nvim.tar.gz"
  tar -xzf "$TEMP_DIR/nvim.tar.gz" -C "$NEOVIM_DIR" --strip-components=1

  # Create a wrapper script to launch Neovim with the isolated Node.js environment
  tee "$INSTALL_DIR/nvim" <<EOF
#!/bin/zsh
export PATH=$NODEJS_DIR/bin:\$PATH
exec $NEOVIM_DIR/bin/nvim "\$@"
EOF

  chmod +x "$INSTALL_DIR/nvim"
  echo "Created wrapper script for Neovim at $INSTALL_DIR/nvim"
  INSTALLED_TOOL=1
}

install_nodejs() {
  echo "Installing Node.js..."
  rm -rf "$NODEJS_DIR"
  mkdir -p "$NODEJS_DIR"
  curl -L "$NODEJS_URL" -o "$TEMP_DIR/node.tar.xz"
  tar -xf "$TEMP_DIR/node.tar.xz" -C "$NODEJS_DIR" --strip-components=1
  echo "Node.js installed in $NODEJS_DIR. It will not be added to the system PATH. You have to do it own, if you need."
  INSTALLED_TOOL=1
}

install_zellij() {
  echo "Installing Zellij..."
  curl -L "$ZELLIJ_URL" -o "$TEMP_DIR/zellij.tar.gz"
  tar -xzf "$TEMP_DIR/zellij.tar.gz" -C "$TEMP_DIR"
  mv "$TEMP_DIR/zellij" "$INSTALL_DIR/zellij"
  INSTALLED_TOOL=1
}

install_fd() {
  echo "Installing fd..."
  curl -L "$FD_URL" -o "$TEMP_DIR/fd.tar.gz"
  tar -xzf "$TEMP_DIR/fd.tar.gz" -C "$TEMP_DIR"
  FD_BINARY=$(find "$TEMP_DIR" -type f -name "fd" | head -n 1)
  if [ -n "$FD_BINARY" ]; then
    mv "$FD_BINARY" "$INSTALL_DIR/fd"
    INSTALLED_TOOL=1
  else
    echo "Error: fd binary not found in the extracted files."
  fi
}

install_ripgrep() {
  echo "Installing ripgrep..."
  curl -L "$RG_URL" -o "$TEMP_DIR/rg.tar.gz"
  tar -xzf "$TEMP_DIR/rg.tar.gz" -C "$TEMP_DIR"
  RG_BINARY=$(find "$TEMP_DIR" -type f -name "rg" | head -n 1)
  if [ -n "$RG_BINARY" ]; then
    mv "$RG_BINARY" "$INSTALL_DIR/rg"
    INSTALLED_TOOL=1
  else
    echo "Error: ripgrep binary not found in the extracted files."
  fi
}

install_bat() {
  echo "Installing bat..."
  curl -L "$BAT_URL" -o "$TEMP_DIR/bat.tar.gz"
  tar -xzf "$TEMP_DIR/bat.tar.gz" -C "$TEMP_DIR"
  BAT_BINARY=$(find "$TEMP_DIR" -type f -name "bat" | head -n 1)
  if [ -n "$BAT_BINARY" ]; then
    mv "$BAT_BINARY" "$INSTALL_DIR/bat"
    INSTALLED_TOOL=1
  else
    echo "Error: bat binary not found in the extracted files."
  fi
}

install_fzf() {
  echo "Installing fzf..."
  curl -L "$FZF_URL" -o "$TEMP_DIR/fzf.tar.gz"
  tar -xzf "$TEMP_DIR/fzf.tar.gz" -C "$TEMP_DIR"
  mv "$TEMP_DIR/fzf" "$INSTALL_DIR/fzf"
  INSTALLED_TOOL=1
}

install_lazygit() {
  echo "Installing lazygit..."
  curl -L "$LAZYGIT_URL" -o "$TEMP_DIR/lazygit.tar.gz"
  tar -xzf "$TEMP_DIR/lazygit.tar.gz" -C "$TEMP_DIR"
  mv "$TEMP_DIR/lazygit" "$INSTALL_DIR/lazygit"
  INSTALLED_TOOL=1
}

install_nvim_config() {
  echo "Installing Neovim configuration..."
  rm -rf "$NVIM_CONFIG_DIR"
  git clone "$NVIM_CONFIG_REPO" "$NVIM_CONFIG_DIR"
}

install_tmux_config() {
  echo "Installing tmux configuration..."
  rm -rf "$TMUX_CONFIG_DIR"
  git clone "$TMUX_CONFIG_REPO" "$TMUX_CONFIG_DIR"
  ln -s "$TMUX_CONFIG_DIR/.tmux.conf" "$TMUX_CONFIG_DIR/tmux.conf"
  ln -s "$TMUX_CONFIG_DIR/.tmux.conf.local" "$TMUX_CONFIG_DIR/tmux.conf.local"
}

install_zellij_config() {
  echo "Installing Zellij configuration..."
  rm -rf "$ZELLIJ_CONFIG_DIR"
  git clone "$ZELLIJ_CONFIG_REPO" "$ZELLIJ_CONFIG_DIR"
}

# Clean up and create fresh directories
rm -rf "$TEMP_DIR"
mkdir -p "$INSTALL_DIR" "$TEMP_DIR"

# Show menu and process selection
show_menu

# Process user selection
if [[ "$CHOICE" == "a" ]]; then
  install_neovim
  install_nodejs
  install_zellij
  install_fd
  install_ripgrep
  install_bat
  install_fzf
  install_lazygit
  install_nvim_config
  install_tmux_config
  install_zellij_config
else
  for num in $CHOICE; do
    case $num in
    1) install_neovim ;;
    2) install_nodejs ;;
    3) install_zellij ;;
    4) install_fd ;;
    5) install_ripgrep ;;
    6) install_bat ;;
    7) install_fzf ;;
    8) install_lazygit ;;
    9) install_nvim_config ;;
    10) install_tmux_config ;;
    11) install_zellij_config ;;
    *) echo "Invalid option: $num" ;;
    esac
  done
fi

# Update shell configuration based on installed components
if [ -f "$HOME/.zshrc" ]; then
  # Add PATH only if any tool was installed
  if [ $INSTALLED_TOOL -eq 1 ] && ! grep -q "export PATH=$INSTALL_DIR:\$PATH" "$HOME/.zshrc"; then
    echo "export PATH=$INSTALL_DIR:\$PATH" >>"$HOME/.zshrc"
  fi
fi

# Clean up
rm -rf "$TEMP_DIR"

echo "Installation complete!"
if [ $INSTALLED_TOOL -eq 1 ]; then
  echo "Please run 'source ~/.zshrc' or restart your shell to update the PATH."
fi
