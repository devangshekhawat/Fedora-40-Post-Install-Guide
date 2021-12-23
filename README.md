# Fedora-35-Post-Install-Guide
Things to do after installing Fedora 35
## Dnf-Conf

* `echo 'fastestmirror=1' | sudo tee -a /etc/dnf/dnf.conf`
`echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf`
`echo 'deltarpm=true' | sudo tee -a /etc/dnf/dnf.conf`
`cat /etc/dnf/dnf.conf`
* Output should match this
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
## Update 
* `sudo dnf -y upgrade --refresh`

## RPM Fusion release

* `sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm`
* then
```
sudo dnf upgrade --refresh
sudo dnf groupupdate core
sudo dnf install -y rpmfusion-free-release-tainted
sudo dnf install -y rpmfusion-nonfree-release-tainted 
sudo dnf install -y dnf-plugins-core
sudo dnf install -y *-firmware
```

## Nvidia Drivers (must be on latest kernel)

* `modinfo -F version nvidia`
* `sudo dnf update -y`
* `sudo dnf install akmod-nvidia`
* `sudo dnf install xorg-x11-drv-nvidia-cuda`
* `xorg-x11-drv-nvidia-libs`
* `sudo dnf install xorg-x11-drv-nvidia-power`
* `sudo systemctl enable nvidia-{suspend,resume,hibernate}`
* WAIT FOR ATLEAST 5 Mins before REBOOTING. THIS IS VERY CRUCIAL.
* reboot
* to check which gpu is running-
```
glxinfo|egrep "OpenGL vendor|OpenGL renderer"
```
and
```
/sbin/lspci | grep -e 3D
```
## Set Hostname

* `hostnamectl set-hostname fedora`

## Media Codecs

* `sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel`
* `sudo dnf install lame\* --exclude=lame-devel`
* `sudo dnf group upgrade --with-optional Multimedia` 
* `sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin`
* `sudo dnf groupupdate sound-and-video`
* `sudo dnf config-manager --set-enabled fedora-cisco-openh264`
* `sudo dnf install -y gstreamer1-plugin-openh264 mozilla-openh264`
* `sudo dnf install -y ffmpeg-libs`
* Hardware Video Acceleration - https://wiki.archlinux.org/title/Hardware_video_acceleration
* https://wiki.archlinux.org/title/firefox#Hardware_video_acceleration
* media.ffmpeg.vaapi.enabled  true
* gfx.webrender.all           true
* media.ffvpx.enabled         false

## Battery Life
* Fedora 35 comes pre-installed with power-profiles-daemon which works amazing. Auto-cpufreq is just trash, tlp(heavily configured) is good but to my testing PPD gave half an hour worth of extra battery life and it comes preinstalled so why bother? only downside is that it only works with systemd installed so if you dont like systemd and want to change it no luck sorry. For me personally, I would rather use endeavour if I wanted to swap such critical parts of the system, Fedora just works great OTB.
* System76-power is awesome and even better than ppd but might not work but still worth trying.

## System-76 Power
* `sudo dnf copr enable szydell/system76`
* `sudo dnf install system76-driver`
* `sudo dnf install system76-power`
* `sudo systemctl enable system76-power system76-power-wake`
* `git clone https://github.com/pop-os/gnome-shell-extension-system76-power.git`
* `cd gnome-shell-extension-system76-power`
* `sudo dnf install nodejs-typescript`
* `make`
* `make install`
 
## Flatpak

* `flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo`
* `flatpak update`

## Theming

### GTK Themes
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
