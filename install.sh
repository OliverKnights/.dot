#!/bin/bash

set -euo pipefail

# Versions
go_version="1.16.6"
docker_compose_version=1.29.2
tig_version=2.3.3

dotfiles_dir="$HOME/.dots"

# Increase sudo timeout and use single sudo cache across all ttys:
sudo_conf=/etc/sudoers.d/mycustomconf
if [[ ! -f "$sudo_conf" ]]; then 
  echo "Defaults:$USER '!tty_tickets', timestamp_timeout=480" | sudo tee -a "$sudo_conf"
fi

function binary_exists() {
  local binary
  binary="$1"
  if [[ -x "$(which "$binary")" ]]; then
    return 0
  fi

  return 1
}

function ask_user() {
  question="$1"
  echo "$question"
  read -n1 -rp "[y|n]? " optional
  if [[ "$optional" =~ y ]]; then
    return 0
  fi

  return 1
}

os="$(grep '^NAME' < /etc/os-release)"
if [[ "$os" =~ "Ubuntu" ]]; then
  sudo apt update && sudo apt upgrade -y
  sudo apt install -y git
  if [[ ! -d "$dotfiles_dir" ]]; then
    git clone https://github.com/OliverKnights/.dots "$dotfiles_dir"
  fi

  sudo apt install -y \
    stow \
    curl \
    tmux \
    tree \
    wget \
    vim \
    make 

  pushd "$dotfiles_dir"

  if [[ -f "$HOME/.bashrc" ]]; then
    mv ~/.bashrc ~/.bashrc.bak
  fi

  for dir in bash emacs gpg nvim readline scripts tmux vim zsh; do
    stow --dotfiles "$dir"
  done

  mkdir -p ~/.vim
  ln -sf ~/.dots/nvim/.config/nvim/init.vim ~/.vim/vimrc
  ln -sf ~/.dots/nvim/.config/nvim/after/ ~/.vim/after

  mkdir -p "$HOME/.local/share/nvim/session"

  if ask_user "Minimal install?"; then
    exit 0
  fi

  sudo apt install -y \
    zsh \
    tig \
    entr \
    shellcheck \
    build-essential \
    ca-certificates \
    make \
    cmake \
    direnv \
    jq \
    ncdu \
    mysql-client \
    python3 \
    python3-pip \
    nnn \
    software-properties-common \
    tcpdump \
    xclip \
    apt-transport-https \
    gnupg \
    lsb-release

  optional_packages="network-manager-openvpn \
    gnome-tweak-tool \
    tlp \
    g++ \
    pandoc \
    htop \
    texlive-full \
    newsboat \
    meld \
    mutt"
      if ask_user "Do you require the following optional packages: $optional_packages"; then
        sudo apt install -y "$optional_packages"
      fi

    # Neovim
    if ! binary_exists nvim; then
      pushd /tmp && \
        curl -LO https://github.com/neovim/neovim/releases/download/v0.5.0/nvim.appimage.sha256sum && \
        curl -LO https://github.com/neovim/neovim/releases/download/v0.5.0/nvim.appimage && \
        sha256sum -c nvim.appimage.sha256sum | grep OK && \
        sudo mv nvim.appimage /usr/local/bin/nvim && \
        sudo chmod +x /usr/local/bin/nvim && \
        popd
    fi

    pip3 install neovim neovim-remote

    # Gh
    if ! binary_exists gh && ask_user "Do you require github client?"; then
      curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
      sudo apt update
      sudo apt install gh
    fi

    # Docker
    if ! binary_exists docker; then
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg 
      echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
              sudo apt update
              sudo apt install -y docker-ce
              sudo usermod -aG docker "${USER}"
    fi

    # Docker Compose
    if binary_exists docker-compose; then
      sudo curl -L "https://github.com/docker/compose/releases/download/${docker_compose_version}/docker-compose-$(uname -s)-$(uname -m)" \
        -o /usr/local/bin/docker-compose
              sudo chmod +x /usr/local/bin/docker-compose
    fi

    # Go
    if ! binary_exists go; then
      pushd /tmp
      wget https://golang.org/dl/go${go_version}.linux-amd64.tar.gz
      sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go${go_version}.linux-amd64.tar.gz
      popd
    fi

    GO111MODULE=on go get golang.org/x/tools/gopls@latest
    go get -u github.com/jstemmer/gotags

    # FZF
    if ! binary_exists fzf; then
      git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
      "$HOME/.fzf/install"
    fi
    ! source "$HOME/.bashrc"

    if ! binary_exists node && ask_user "Do you require node?"; then 
      pushd /tmp
      curl -sL https://deb.nodesource.com/setup_14.x -o nodesource_setup.sh
      sudo bash nodesource_setup.sh
      sudo apt install nodejs
      popd

      mkdir -p "$HOME/.npm-global"
      npm config set prefix "$HOME/.npm-global"
    fi

    if ! binary_exists tig; then
      pushd /tmp
      wget https://github.com/jonas/tig/releases/download/tig-${tig_version}/tig-${tig_version}.tar.gz
      sudo tar -xzf tig-${tig_version}.tar.gz
      pushd tig-${tig_version}
      make
      sudo make install
      popd 
      popd
    fi
fi

