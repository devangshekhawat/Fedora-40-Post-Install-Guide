#!/bin/bash
# To Run This Script Use This Commands 
# chmod +x setup_fedora.sh
# ./setup_fedora.sh
# Self-elevate to sudo
if [ "$EUID" -ne 0 ]; then
    echo "Switching to sudo mode..."
    sudo "$0" "$@"
    exit $?
fi

# Function to prompt user for installation
prompt_install() {
    read -p "Do you want to install $1? (y/n): " choice
    case "$choice" in 
        y|Y ) echo "Installing $1..."; eval $2;;
        n|N ) echo "Skipping $1.";;
        * ) echo "Invalid choice. Skipping $1.";;
    esac
}

# Function to configure DNF
configure_dnf() {
    echo "Configuring DNF..."
    sudo tee /etc/dnf/dnf.conf > /dev/null << 'EOF'
[main]
gpgcheck=True
installonly_limit=3
clean_requirements_on_remove=True
best=False
skip_if_unavailable=True
fastestmirror=1
max_parallel_downloads=10
deltarpm=true
defaultyes=True
keepcache=True
EOF
    echo "DNF configuration updated."
}

# Update the System
prompt_install "system updates" "sudo dnf update -y"

# Install Essential Packages
prompt_install "essential packages (vim, git, curl, wget, htop)" "sudo dnf install -y vim git curl wget htop"

# Enable RPM Fusion Repositories
prompt_install "RPM Fusion Repositories" "
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm &&
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

# Install Multimedia Codecs
prompt_install "multimedia codecs" "
sudo dnf groupupdate multimedia --setop='install_weak_deps=False' --exclude=PackageKit-gstreamer-plugin &&
sudo dnf groupupdate sound-and-video"

# Install GNOME Tweaks
prompt_install "GNOME Tweaks" "sudo dnf install -y gnome-tweaks"

# Customize GNOME Shell Extensions
prompt_install "GNOME Shell Extensions" "sudo dnf install -y gnome-shell-extension-user-theme gnome-shell-extension-topicons-plus"

# Change the Hostname
prompt_install "hostname change" "
read -p 'Enter new hostname: ' hostname &&
sudo hostnamectl set-hostname \$hostname"

# Install Additional Fonts
prompt_install "additional fonts" "sudo dnf install -y google-roboto-fonts google-noto-fonts-common"

# Enable the fastest mirror and parallel downloads
prompt_install "fastest mirror and parallel downloads" "
sudo dnf config-manager --save --setopt=fastestmirror=True &&
sudo dnf config-manager --save --setopt=max_parallel_downloads=10"

# Install and Enable Preload
prompt_install "Preload" "sudo dnf install -y preload && sudo systemctl enable --now preload"

# Optimize Swappiness
prompt_install "optimize swappiness" "
sudo sysctl vm.swappiness=10 &&
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf"

# Set Up a Firewall
prompt_install "firewall setup" "
sudo dnf install -y firewalld &&
sudo systemctl enable --now firewalld &&
sudo firewall-cmd --permanent --add-service=http &&
sudo firewall-cmd --permanent --add-service=https &&
sudo firewall-cmd --reload"

# Install and Configure Fail2Ban
prompt_install "Fail2Ban" "
sudo dnf install -y fail2ban &&
sudo systemctl enable --now fail2ban"

# Enable SELinux
prompt_install "SELinux" "
sudo setenforce 1 &&
sudo sed -i 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config"

# Install Development Tools
prompt_install "development tools" "
sudo dnf groupinstall -y 'Development Tools' &&
sudo dnf groupinstall -y 'C Development Tools and Libraries'"

# Install Docker
prompt_install "Docker" "
sudo dnf install -y dnf-plugins-core &&
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo &&
sudo dnf install -y docker-ce docker-ce-cli containerd.io &&
sudo systemctl start docker &&
sudo systemctl enable docker &&
sudo usermod -aG docker \$USER"

# Install Timeshift for Backup
prompt_install "Timeshift" "sudo dnf install -y timeshift"

# Clean Up the System
prompt_install "system cleanup" "sudo dnf autoremove -y && sudo dnf clean all"

# Install Snap and Flatpak
prompt_install "Snap and Flatpak" "
sudo dnf install -y snapd &&
sudo ln -s /var/lib/snapd/snap /snap &&
sudo dnf install -y flatpak &&
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo"

# Install Wine for Windows Applications
prompt_install "Wine" "sudo dnf install -y wine"

# Schedule Automatic Updates
prompt_install "automatic updates" "
sudo dnf install -y dnf-automatic &&
sudo systemctl enable --now dnf-automatic-install.timer"

# Enable Night Light
prompt_install "Night Light" "gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true"

# Install VirtualBox
prompt_install "VirtualBox" "
sudo dnf install -y @development-tools &&
sudo dnf install -y kernel-devel kernel-headers dkms qt5-qtx11extras elfutils-libelf-devel &&
sudo dnf install -y VirtualBox &&
sudo usermod -aG vboxusers \$USER"

# Install QEMU/KVM
prompt_install "QEMU/KVM" "
sudo dnf install -y @virtualization &&
sudo systemctl enable --now libvirtd &&
sudo usermod -aG libvirt \$USER"

# Install Lutris
prompt_install "Lutris" "sudo dnf install -y lutris"

# Install Steam
prompt_install "Steam" "sudo dnf install -y steam"

# Install VLC Media Player
prompt_install "VLC Media Player" "sudo dnf install -y vlc"

# Install GIMP
prompt_install "GIMP" "sudo dnf install -y gimp"

# Install LibreOffice
prompt_install "LibreOffice" "sudo dnf install -y libreoffice"

# Install OpenVPN
prompt_install "OpenVPN" "sudo dnf install -y openvpn"

# Install NetworkManager OpenVPN Plugin
prompt_install "NetworkManager OpenVPN Plugin" "sudo dnf install -y NetworkManager-openvpn NetworkManager-openvpn-gnome"

# Configure SSH Server
prompt_install "SSH Server" "
sudo dnf install -y openssh-server &&
sudo systemctl enable --now sshd"

# Install System Monitoring Tools
prompt_install "Glances" "sudo dnf install -y glances"
prompt_install "bmon" "sudo dnf install -y bmon"

# Install Disk Usage Analyzer (baobab)
prompt_install "Disk Usage Analyzer (baobab)" "sudo dnf install -y baobab"

# Install Syncthing
prompt_install "Syncthing" "
sudo dnf install -y syncthing &&
sudo systemctl enable --now syncthing@\$USER"

# Install Nextcloud Client
prompt_install "Nextcloud Client" "sudo dnf install -y nextcloud-client"

# Install Node.js and npm
prompt_install "Node.js and npm" "sudo dnf install -y nodejs npm"

# Install Python Development Tools
prompt_install "Python Development Tools" "sudo dnf install -y python3 python3-pip python3-virtualenv"

# Install Java Development Kit (OpenJDK)
prompt_install "Java Development Kit (OpenJDK)" "sudo dnf install -y java-latest-openjdk"

# Install Rust
prompt_install "Rust" "sudo dnf install -y rust cargo"

# Install Zsh and Oh My Zsh
prompt_install "Zsh and Oh My Zsh" "
sudo dnf install -y zsh &&
chsh -s \$(which zsh) &&
sh -c '$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)'"

# Install Powerlevel10k Theme
prompt_install "Powerlevel10k Theme" "
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \${ZSH_CUSTOM:-\$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

# Install zsh-syntax-highlighting Plugin
prompt_install "zsh-syntax-highlighting Plugin" "
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

# Install zsh-autosuggestions Plugin
prompt_install "zsh-autosuggestions Plugin" "
git clone https://github.com/zsh-users/zsh-autosuggestions \${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

# Install autojump
prompt_install "autojump" "sudo dnf install -y autojump-zsh"

# Configure .zshrc
prompt_install ".zshrc Configuration" "
cat << 'EOF' > ~/.zshrc
# If you come from bash you might have to change your \$PATH.
export PATH=\$HOME/bin:\$HOME/.local/bin:/usr/local/bin:\$PATH

# Path to your Oh My Zsh installation.
export ZSH=\"\$HOME/.oh-my-zsh\"

# Set a modern and cool theme. Powerlevel10k is a popular choice.
ZSH_THEME=\"powerlevel10k/powerlevel10k\"

# Enable case-insensitive and hyphen-insensitive completion.
CASE_SENSITIVE=\"false\"
HYPHEN_INSENSITIVE=\"true\"

# Enable auto-updates for Oh My Zsh.
zstyle ':omz:update' mode auto  # update automatically without asking

# Enable command auto-correction.
ENABLE_CORRECTION=\"true\"

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS=\"true\"

# Show command execution time in history.
HIST_STAMPS=\"yyyy-mm-dd\"

# Load additional plugins. Here are some recommended ones.
plugins=(
  git
  zsh-syntax-highlighting  # Highlights command syntax
  zsh-autosuggestions      # Suggests commands as you type based on history
  autojump                 # A faster way to navigate directories
  command-not-found        # Suggests package installations
  colored-man-pages        # Adds color to man pages
  sudo                     # Makes it easier to re-execute the last command with sudo
  history                  # Adds history-related functions
  vi-mode                  # Vim keybindings for Zsh
  web-search               # Search the web from your terminal
  themes                   # Theme management functions
  docker                   # Docker command completion
  npm                      # NPM command completion
  yarn                     # Yarn command completion
  node                     # Node.js command completion
  python                   # Python command completion
  pip                      # Pip command completion
  virtualenv               # Virtualenv command completion
  pyenv                    # Pyenv command completion
  golang                   # Go command completion
  rust                     # Rust command completion
  kubectl                  # Kubectl command completion
  terraform                # Terraform command completion
  aws                      # AWS CLI command completion
)

# Source Oh My Zsh.
source \$ZSH/oh-my-zsh.sh

# User configuration

# Preferred editor for local and remote sessions
if [[ -n \$SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='code'  # Use VSCode for local editing
fi

# Compilation flags
export ARCHFLAGS=\"-arch x86_64\"

# Set personal aliases, overriding those provided by Oh My Zsh libs, plugins, and themes.
# Custom aliases can be placed here.
alias zshconfig=\"code ~/.zshrc\"  # Use VSCode to edit the zsh configuration
alias ohmyzsh=\"code ~/.oh-my-zsh\"  # Use VSCode to open Oh My Zsh installation folder
alias l=\"ls -lah\"  # Better ls command
alias grep=\"grep --color=auto\"  # Colored grep output
alias updateall=\"sudo dnf update -y && sudo dnf upgrade -y\"  # Update all packages (Fedora)
alias please=\"sudo\"  # Alias for sudo
alias c=\"clear\"  # Clear the terminal
alias ..=\"cd ..\"  # Go up one directory
alias ...=\"cd ../..\"  # Go up two directories
alias ....=\"cd ../../..\"  # Go up three directories
alias ~=\"cd ~\"  # Go to the home directory

# Customize prompt if using powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
POWERLEVEL9K_INSTANT_PROMPT=quiet

# Load zsh-syntax-highlighting and zsh-autosuggestions plugins
source \$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source \$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Enable autojump
. /usr/share/autojump/autojump.sh

# Make sure you have the necessary fonts installed for the chosen theme
# For powerlevel10k, you can find the instructions here: https://github.com/romkatv/powerlevel10k#fonts

# To apply changes, reload the .zshrc file
source ~/.zshrc
EOF"

# Install Nerd Fonts
prompt_install "Nerd Fonts" "
mkdir -p ~/.local/share/fonts &&
cd ~/.local/share/fonts &&
curl -fLo 'MesloLGS NF Regular.ttf' https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/L/Regular/MesloLGS%20NF%20Regular.ttf &&
curl -fLo 'MesloLGS NF Bold.ttf' https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/L/Bold/MesloLGS%20NF%20Bold.ttf &&
curl -fLo 'MesloLGS NF Italic.ttf' https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/L/Italic/MesloLGS%20NF%20Italic.ttf &&
curl -fLo 'MesloLGS NF Bold Italic.ttf' https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/L/Bold-Italic/MesloLGS%20NF%20Bold%20Italic.ttf &&
fc-cache -fv"

# Restart Terminal or Source .zshrc
prompt_install "source .zshrc" "source ~/.zshrc"

# Configure Powerlevel10k
prompt_install "Powerlevel10k configuration" "p10k configure"

# Configure DNF
prompt_install "configure DNF" "configure_dnf"
