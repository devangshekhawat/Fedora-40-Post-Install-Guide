# Fedora-35-Post-Install-Guide
Things to do after installing Fedora 35
### Dnf-Conf

* `echo 'fastestmirror=1' | sudo tee -a /etc/dnf/dnf.conf echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf echo 'deltarpm=true' | sudo tee -a /etc/dnf/dnf.conf`

### RPM Fusion release

* `sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E%fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfreerelease-$(rpm -E %fedora).noarch.rpm`
* 'sudo dnf update -y'


### Nvidia Drivers (must be on latest kernel)

* `modinfo -F version nvidia`
* `sudo dnf update -y`
* `sudo dnf install akmod-nvidia`
* `sudo dnf install xorg-x11-drv-nvidia-cuda`
* `sudo dnf install -y xorg-x11-drv-nvidia-cuda-libs`
* `sudo dnf install xorg-x11-drv-nvidia-power`
* `sudo dnf install -y vulkan`
* `sudo systemctl enable nvidia-{suspend,resume,hibernate}`
* reboot
* to check which gpu is running-

  `glxinfo|egrep "OpenGL vendor|OpenGL renderer`
   and
   '/sbin/lspci | grep -e 3D'

### Set Hostname

* `hostnamectl set-hostname fedora`


### Media Codecs

* `sudo dnf groupupdate sound-and-video sudo dnf install -y libdvdcss`
* `sudo dnf install -y gstreamer1-plugins-{bad-*,good-*,ugly-*,base} gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel ffmpeg gstreamer-ffmpeg `
* `sudo dnf install -y lame* --exclude=lame-devel `
* `sudo dnf group upgrade --with-optional Multimedia`
* `sudo dnf config-manager --set-enabled fedora-cisco-openh264`
* `sudo dnf install -y gstreamer1-plugin-openh264 mozilla-openh264`


### Atom

* sudo rpm -Uvh atom.rpm
* Packages

├── atom-beautify@0.33.4
├── atom-ide-ui@0.13.0
├── delete-lines@0.5.0
├── file-icons@2.1.43
├── ide-css@0.3.5
├── ide-html@0.6.2
├── ide-json@0.2.1
├── ide-python@1.5.0
├── markdown-preview-enhanced@0.18.5
├── markdown-toc@0.4.2
└── minimap@4.29.9

### Lutris
* install Lutris
* 'sudo dnf config-manager --add-repo https://dl.winehq.org/wine-builds/fedora/35/winehq.repo'
* 'sudo dnf install winehq-stable'
### Theming

* \

### Gnome Extensions

* [User Themes](https://extensions.gnome.org/extension/19/user-themes/)
* [Just Perfection](https://extensions.gnome.org/extension/3843/just-perfection/)
* [Net Speed Simplified](https://extensions.gnome.org/extension/3724/net-speed-simplified/)
* [Dash to Dock](https://extensions.gnome.org/extension/307/dash-to-dock/)
* [Gsconnect](https://extensions.gnome.org/extension/1319/gsconnect/)
* [Bluetooth Quick Connect](https://extensions.gnome.org/extension/1401/bluetooth-quick-connect/)


