# Fedora 37 Post Install Guide
Things to do after installing Fedora 37

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
* Note: The `fastestmirror=1` plugin can be counterproductive at times, use it at your own discretion. Set it to `fastestmirror=0` if you are facing bad download speeds. Many users have reported better download speeds with the plugin enables so it is there by default.

## RPM Fusion
* Fedora has disabled the repositories for a lot of free and non-free .rpm packages by default. Follow this if you want to use non-free software like Steam, Discord and some multimedia codecs etc. As a general rule of thumb its advised to do this get access to many mainstream useful programs.
* `sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm`
* also while you're at it, install app-stream metadata by
* `sudo dnf groupupdate core`

## Update 
* `sudo dnf -y upgrade --refresh`
* Reboot

## Firmware
* If your system supports firmware update delivery through lvfs, update your device firmware by:
```
sudo fwupdmgr get-devices 
sudo fwupdmgr refresh --force 
sudo fwupdmgr get-updates 
sudo fwupdmgr update
```

## NVIDIA Drivers
* Only follow this if you have a NVIDIA gpu. Also, don't follow this if you have a gpu which has dropped support for newer driver releases i.e. anything earlier than nvidia GT/GTX 600, 700, 800, 900, 1000, 1600 and RTX 2000, 3000 series. Fedora comes preinstalled with NOUVEAU drivers which may or may not work better on those older GPUs. This should be followed by Desktop and Laptop users alike.
* Disable Secure Boot.
* `sudo dnf update` #To make sure you're on the latest kernel and then reboot.
* Enable RPM Fusion Nvidia non-free repository in the app store and install from there,
* or alternatively
* `sudo dnf install akmod-nvidia`
* Install this if you use applications that use CUDA i.e. Davinci Resolve, Blender etc.
* `sudo dnf install xorg-x11-drv-nvidia-cuda`
* Wait for atleast 5 mins before rebooting, to let the kermel module get built.
* `modinfo -F version nvidia` #Check if the kernel module is built.
* Reboot

## Battery Life
* Follow this if you have a Laptop.
* power-profiles-daemon works great on many systems but in case you're facing sub-optimal battery backup try installing tlp by:
* `sudo dnf install tlp tlp-rdw`
* and mask power-profiles-daemon by:
* `sudo systemctl mask power-profiles-daemon`
* Also install powertop by:
* `sudo dnf install powertop`
* `sudo powertop --auto-tune`

## Media Codecs
* Install these to get proper multimedia playback. (Note: You can skip this if you plan on installing ffmpeg.) 
````
sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
sudo dnf groupupdate sound-and-video
sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel ffmpeg gstreamer-ffmpeg
sudo dnf install lame\* --exclude=lame-devel
sudo dnf group upgrade --with-optional Multimedia
````

## H/W Video Acceleration
* Helps decrease load on the CPU when watching videos online by alloting the rendering to the dGPU/iGPU. Quite helpful in increasing battery backup on laptops.

### H/W Video Decoding with VA-API 
* `sudo dnf install ffmpeg ffmpeg-libs libva libva-utils`

<details>
<summary>Intel</summary>
 
* If you have an intel chipset after installing the packages above., Do:
* `sudo dnf install intel-media-driver`
</details>

<details>
<summary>AMD</summary>
 
* If you have an AMD chipset, after installing the packages above do:
 ```
sudo dnf remove mesa-va-drivers
sudo dnf install --enablerepo=rpmfusion-free-updates-testing mesa-va-drivers-freeworld`
```
</details>

### OpenH264 for Firefox
* Enable the OpenH264 Plugin in Firefox's settings.

## Update Flatpak
* `flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo`
* `flatpak update`

## Set Hostname
* `hostnamectl set-hostname YOUR_HOSTNAME`

## Speed Boost
* Allow you to squeeze out a little bit more performance from your system. Do not follow this if you share services and files through your network or are using fedora in a VM.
* Install Grub Customizer to implement these tweaks by
* `sudo dnf install grub-customizer` 

### Disable Mitigations 
* Increases performance in multithreaded systems. The more core count you have the greater the performance gain. Not advised for host systems on some networks for increased security vulnerabilities, using it on daily driver systems won't fetch any problems. 5-30% performance gain varying upon systems.
* Add `mitigations=off` in Kernel Parameters under General Settings in Grub Customizer and click save.

### Zswap (for systems with <16 gigs of RAM)
* Acts as virtual memory. Useful for sytems with <16 gigs of ram.
* Add `zswap.enabled=1` in Kernel Parameters under General Settings in Grub Customizer and click save.

## Gnome Extensions
* Don't install these if you are using a different spin of Fedora.
* Pop Shell - `sudo dnf install -y gnome-shell-extension-pop-shell xprop`
* [GSconnect](https://extensions.gnome.org/extension/1319/gsconnect/) - do `sudo dnf install nautilus-python` for full support.
* [Gesture Improvements](https://extensions.gnome.org/extension/4245/gesture-improvements/)
* [User Themes](https://extensions.gnome.org/extension/19/user-themes/)
* [Just Perfection](https://extensions.gnome.org/extension/3843/just-perfection/)
* [Dash to Dock](https://extensions.gnome.org/extension/307/dash-to-dock/)
* [Quick Settings Tweaker](https://extensions.gnome.org/extension/5446/quick-settings-tweaker/)
* [Blur My Shell](https://extensions.gnome.org/extension/3193/blur-my-shell/)
* [Bluetooth Quick Connect](https://extensions.gnome.org/extension/1401/bluetooth-quick-connect/)
* [App Indicator Support](https://extensions.gnome.org/extension/615/appindicator-support/)
* [Clipboard Indicator](https://extensions.gnome.org/extension/779/clipboard-indicator/)
* [Legacy (GTK3) Theme Scheme Auto Switcher](https://extensions.gnome.org/extension/4998/legacy-gtk3-theme-scheme-auto-switcher/)
* [Caffeine](https://extensions.gnome.org/extension/517/caffeine/)
* [Coverflow Alt-Tab](https://extensions.gnome.org/extension/97/coverflow-alt-tab/)
* [Vitals](https://extensions.gnome.org/extension/1460/vitals/)

## Apps [Optional]
* Packages for Rar and 7z compressed files support:
 `sudo dnf install -y unzip p7zip p7zip-plugins unrar`
* These are Some Packages that I use and would recommend:
```
Ferdium
Books 
Ulauncher 
Blanket
Krita
Deja Dup Backups
Blender
Logseq
Joplin
Transmission
yt-dlp
Celluloid
Pika backup 
Amberol
News flash
Foliate
Tangram
VS Codium
Blanket
Easyeffects
```

## Theming [Optional]

### GTK Themes
* Don't install these if you are using a different spin of Fedora.
* https://github.com/lassekongo83/adw-gtk3
* https://github.com/vinceliuice/Colloid-gtk-theme
* https://github.com/EliverLara/Nordic
* https://github.com/vinceliuice/Orchis-theme
* https://github.com/vinceliuice/Graphite-gtk-theme

### Use themes in Flatpaks
* `sudo flatpak override --filesystem=$HOME/.themes`
* `sudo flatpak override --env=GTK_THEME=my-theme` 

### Icon Packs
* https://github.com/vinceliuice/Tela-icon-theme
* https://github.com/vinceliuice/Colloid-gtk-theme/tree/main/icon-theme

### Wallpaper
* https://github.com/manishprivet/dynamic-gnome-wallpapers

### Firefox Theme
* Install Firefox Gnome theme by: `curl -s -o- https://raw.githubusercontent.com/rafaelmardojai/firefox-gnome-theme/master/scripts/install-by-curl.sh | bash`

### Grub Theme
* https://github.com/vinceliuice/grub2-themes
