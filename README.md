# Fedora-35-Post-Install-Guide
Things to do after installing Fedora 35
### Dnf-Conf

* `echo 'fastestmirror=1' | sudo tee -a /etc/dnf/dnf.conf echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf echo 'deltarpm=true' | sudo tee -a /etc/dnf/dnf.conf`

### RPM Fusion release

* `sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E%fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfreerelease-$(rpm -E %fedora).noarch.rpm`
* `sudo dnf update -y`


### Nvidia Drivers (must be on latest kernel)

* `modinfo -F version nvidia`
* `sudo dnf update -y`
* `sudo dnf install akmod-nvidia`
* `sudo dnf install xorg-x11-drv-nvidia-cuda`
* WAIT FOR ATLEASE 5 Mins before REBOOTING
* `sudo dnf install xorg-x11-drv-nvidia-cuda-libs`
* `sudo dnf install xorg-x11-drv-nvidia-power`
* `sudo systemctl enable nvidia-{suspend,resume,hibernate}`
* reboot
* to check which gpu is running-

  `glxinfo|egrep "OpenGL vendor|OpenGL renderer"`
   and
  `/sbin/lspci | grep -e 3D`

### Set Hostname

* `hostnamectl set-hostname fedora`

### Media Codecs

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

### Battery Life
* Fedora 35 comes pre-installed with power-profiles-daemon which works amazing. Auto-cpufreq is just trash, tlp(heavily configured) is good but to my testing PPD gave half an hour worth of extra battery life and it comes preinstalled so why bother? only downside is that it only works with systemd installed so if you dont like systemd and want to change it no luck sorry. For me personally, I would rather use endeavour if I wanted to swap such critical parts of the system, Fedora just works great OTB.
* This post previously also had system76-power to turn off the dGPU entirely to save battery life in case you never use it but on many systems it doesnt play good with PPD and the added battery life comes with many gimmicks like html5 video playback on all browsers. So I advise you to not use it, atleast on Fedora.
 
### Flatpak

* `flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo`
* `flatpak update`

### Theming

* https://github.com/EliverLara/Nordic
* `git clone https://github.com/vinceliuice/Tela-icon-theme`
  `cd Tela-icon-theme`
  `./install.sh`
* https://vsthemes.org/uploads/posts/2020-04/1586853771_daniel-leone-v7datklzzaw-unsplash-modded.jpg

### Gnome Extensions

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

