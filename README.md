# Fedora 36 Post Install Guide
Things to do after installing Fedora 36

## Faster Updates
* `sudo nano /etc/dnf/dnf.conf` 
* Copy and replace the text with the following:
```
[main] 
gpgcheck=1 
installonly_limit=3 
clean_requirements_on_remove=True 
best=False 
skip_if_unavailable=True 
fastestmirror=1 
max_parallel_downloads=10 
deltarpm=true 
```

## RPM Fusion release
* Fedora has disabled the repositories for non-free .rpm software by default. Follow this if you use non-free software like discord and some multimedia codecs etc. As a general rule of thumb its advised to do this unless you absolutely don't want any non-free software on your system.
* `sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm`
* also while you're at it, install app-stream metadata by
* `sudo dnf groupupdate core`

## Update 
* `sudo dnf -y upgrade --refresh`
* Reboot

## NVIDIA Drivers
* Only follow this if you have a NVIDIA gpu. Also, don't follow this if you have a gpu which has dropped support for newer driver releases i.e. anything earlier than nvidia GT/GTX 600, 700, 800, 900, 1000, 1600 and RTX 2000, 3000 series. Fedora comes preinstalled with NOUVEAU drivers which may or may not work better on those GPUs older GPUs. This should be followed by Desktop and Laptop users alike.
* `sudo dnf update -y` # to make sure you're on the latest kernel
* Enable RPM Fusion Nvidia non-free repository in the app store and install from there 
* or alternatively
* `sudo dnf install akmod-nvidia`
* Wait for atleast 5 mins before rebooting in order to let the kernel headers compile.
* `modinfo -F version nvidia` # check if the kernel is compiled.
* Reboot

### NVIDIA Cuda
* Install this if you use applications that use CUDA i.e. Davinci Resolve, Blender etc.
* `sudo dnf install xorg-x11-drv-nvidia-cuda`
* Wait for atleast 5 mins before rebooting in order to let the kernel headers to compile.
* `modinfo -F version nvidia` # check if the kernel modules are compiled.
* reboot

## Battery Life
* Follow this if you have a Laptop.
* power-profiles-daemon works great on many systems but in case you're facing sub-optimal battery backup try installing tlp by:
* `sudo dnf install tlp tlp-rdw`
* and mask power-profiles-daemon by
* `sudo systemctl mask power-profiles-daemon`
* NVIDIA Optimus works OOTB on proprietary drivers but running nvidia-smi indicates that it uses 2w of power on idle. You might want to install install system76-power if you want to go further and save that extra 2w worth of battery life but it comes at the cost of having to switch to hybrid-graphics each time you want to use your discrete GPU. Its not worth installing if you use your gpu atleast once every boot. I mostly do basic web browsing so I have installed it and run it on integrated graphics most of the time. Choose accordingly.

## System76-Power:
* Works on non system76 systems just as well. Only laptops with a discrete GPU would like to install this to save power by turning off the dGPU, running on integrated and switching to hybrid when they truly need the extra graphics power. In case you do install this, do not install tlp but still mask power-profiles-daemon like instructed above. You can also also install this if optimus doesn't work and you still require GPU-Switching, one such case might be when you have a pre GTX 500 series GPU.
* `sudo dnf copr enable szydell/system76`
* `sudo dnf install system76-driver`
* `sudo dnf install system76-power`
* `sudo systemctl enable system76-power system76-power-wake`
* `git clone https://github.com/pop-os/gnome-shell-extension-system76-power.git`
* `cd gnome-shell-extension-system76-power`
* `sudo dnf install nodejs-typescript`
* `make`
* `make install`

## Media Codecs
* Install these to get proper video playback.
* `sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin`
* `sudo dnf groupupdate sound-and-video`

## Firefox H/W Video Acceleration:
* Helps decrease load on the CPU when watching videos on youtube by alloting the rendering to the dGPU/iGPU. Quite helpful in increasing battery backup on laptops.
* Change the following setting in about:config
* `media.ffmpeg.vaapi.enabled  true`
* `gfx.webrender.all           true`
* `media.ffvpx.enabled         false`

## Update Flatpak
* `flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo`
* `flatpak update`

## Set Hostname
* `hostnamectl set-hostname YOUR_HOSTNAME`

## Theming [Optional]

### GTK Themes
* Don't install these if you aren't using GNOME
* https://github.com/vinceliuice/Colloid-gtk-theme (currently using)
* https://github.com/EliverLara/Nordic
* https://github.com/vinceliuice/Orchis-theme
* https://github.com/vinceliuice/Graphite-gtk-theme

### Use themes in Flatpaks
* `sudo flatpak override --filesystem=$HOME/.themes`
* `sudo flatpak override --env=GTK_THEME=my-theme` 

### Icon Packs
* https://github.com/vinceliuice/Tela-icon-theme
* https://github.com/vinceliuice/Colloid-gtk-theme/tree/main/icon-theme

### Firefox Theme
* `git clone https://github.com/EliverLara/firefox-nordic-theme && cd firefox-nordic-theme`
* `./scripts/install.sh -g -p *.default-release`

### Grub Theme
* https://github.com/vinceliuice/grub2-themes

## Gnome Extensions
* [Extensions Sync](https://extensions.gnome.org/extension/1486/extensions-sync/)
* [Gesture Improvements](https://extensions.gnome.org/extension/4245/gesture-improvements/)
* [User Themes](https://extensions.gnome.org/extension/19/user-themes/)
* [Just Perfection](https://extensions.gnome.org/extension/3843/just-perfection/)
* [Net Speed Simplified](https://extensions.gnome.org/extension/3724/net-speed-simplified/)
* [Dash to Dock](https://extensions.gnome.org/extension/307/dash-to-dock/)
* [Gsconnect](https://extensions.gnome.org/extension/1319/gsconnect/)
* [Bluetooth Quick Connect](https://extensions.gnome.org/extension/1401/bluetooth-quick-connect/)
* [Input Output Device Chooser](https://github.com/mmalafaia/gse-sound-output-device-chooser/tree/patch-1)
* [Gnome Shell Extension Indicator](https://extensions.gnome.org/extension/615/appindicator-support/)
* [Clipboard Indicator](https://extensions.gnome.org/extension/779/clipboard-indicator/)
