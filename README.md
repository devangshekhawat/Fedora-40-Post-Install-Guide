# Fedora-36-Post-Install-Guide
Things to do after installing Fedora 36

## Dnf-Conf
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
* `sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm`

## Update 
* `sudo dnf -y upgrade --refresh`
* Reboot

## NVIDIA Drivers
* `sudo dnf update -y` # to make sure you're on the latest kernel
* Enable RPM Fusion Nvidia non-free repository and install from there
* or alternatively
* `sudo dnf install akmod-nvidia`
* Wait for atleast 5 mins before rebooting in order to let the kernel headers compile.
* `modinfo -F version nvidia` # check if the kernel is compiled.
* Reboot

### NVIDIA Cuda
* `sudo dnf install xorg-x11-drv-nvidia-cuda`
* Wait for atleast 5 mins before rebooting in order to let the kernel headers to compile.
* `modinfo -F version nvidia` # check if the kernel is compiled.
* reboot

## Battery Life
* power-profiles-daemon works great on many systems but in case you're facing sub-optimal battery backup try installing tlp by:
* `sudo dnf install tlp tlp-rdw`
* `sudo systemctl mask power-profiles-daemon`
* You might want to use NVIDIA Optimus if you have a gaming laptop with an NVIDIA gpu to get better battery life:
Update: Optimus works OOTB on xorg and am still trying to figure out how to get it working under wayland. (running nvidia-smi indicates that 2w of power is still being used even on idle, you might want to look at system76's power module in order completely derail the gpu off of the PCIe lane)

## System76-Power:
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
* sudo dnf groupupdate sound-and-video sudo dnf install -y libdvdcss
* sudo dnf install -y gstreamer1-plugins-{bad-*,good-*,ugly-*,base} gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel ffmpeg gstreamer-ffmpeg
* sudo dnf install -y lame* --exclude=lame-devel
* sudo dnf group upgrade --with-optional Multimedia
* sudo dnf install -y gstreamer1-plugin-openh264 mozilla-openh264
* sudo dnf config-manager --set-enabled fedora-cisco-openh264
* sudo dnf install -y gstreamer1-plugin-openh264 mozilla-openh264

## Set Hostname
* `hostnamectl set-hostname YOUR_HOSTNAME`

## Flatpak
* `flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo`
* `flatpak update`

## Theming

### GTK Themes
* https://Li
* https://github.com/vinceliuice/Colloid-gtk-theme (currently using)
* https://github.com/EliverLara/Nordic
* https://github.com/vinceliuice/Orchis-theme
* https://github.com/vinceliuice/Graphite-gtk-theme

### Use themes in Flatpaks
* `sudo flatpak override --filesystem=$HOME/.themes`
* `sudo flatpak override --env=GTK_THEME=my-theme` 

### Icons
* https://github.com/vinceliuice/Tela-icon-theme
* https://github.com/vinceliuice/Colloid-gtk-theme/tree/main/icon-theme

### Firefox Theme
* `git clone https://github.com/EliverLara/firefox-nordic-theme && cd firefox-nordic-theme`
* `./scripts/install.sh -g -p *.default-release`
* also set: media.ffmpeg.vaapi.enabled: true layers.acceleration.force-enabled : true

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
