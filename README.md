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
* Note: The fastestmirror=1 modification can be counterproductive at times, use it at your own discretion. Set it to fastestmirror=0 if you are facing bad download speeds. Many users have reported better download speeds with the modification so it is there by default.

## RPM Fusion
* Fedora has disabled the repositories for a lot of free and non-free .rpm packages by default. Follow this if you want to use non-free software like Steam, Discord and some multimedia codecs etc. As a general rule of thumb its advised to do this get access to many mainstream useful programs.
* `sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm`
* also while you're at it, install app-stream metadata by
* `sudo dnf groupupdate core`

## Update 
* `sudo dnf -y upgrade --refresh`
* Reboot

## NVIDIA Drivers
* Only follow this if you have a NVIDIA gpu. Also, don't follow this if you have a gpu which has dropped support for newer driver releases i.e. anything earlier than nvidia GT/GTX 600, 700, 800, 900, 1000, 1600 and RTX 2000, 3000 series. Fedora comes preinstalled with NOUVEAU drivers which may or may not work better on those older GPUs. This should be followed by Desktop and Laptop users alike.
* `sudo dnf update` to make sure you're on the latest kernel
* Enable RPM Fusion Nvidia non-free repository in the app store and install from there 
* or alternatively
* `sudo dnf install akmod-nvidia`
* Install this if you use applications that use CUDA i.e. Davinci Resolve, Blender etc.
* `sudo dnf install xorg-x11-drv-nvidia-cuda`
* Wait for atleast 5 mins before rebooting, letting the kernel headers compile.
* `modinfo -F version nvidia` # check if the kernel headers are compiled.
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
* NVIDIA Optimus works OOTB on proprietary drivers but running nvidia-smi indicates that it uses 2w of power on idle. You might want to install install system76-power if you want to go further and save that extra 2w worth of battery life but it comes at the cost of having to switch to hybrid-graphics each time you want to use your discrete GPU. Its not worth installing if you use your gpu atleast once every boot. I mostly do basic web browsing so I have installed it and run it on integrated graphics most of the time. Choose accordingly.

### System76-Power[Optional]
* Works on non system76 systems just as well. Only laptops with a discrete GPU would like to install this to save power by turning off the dGPU to run on integrated graphic and switching to hybrid when they truly need the extra graphics horsepower. In case you do install this, do not install tlp but still mask power-profiles-daemon like instructed above. You can also also install this if optimus doesn't work and you still require GPU-Switching, one such case might be when you have a pre GTX 500 series GPU. NVIDIA Optimus works flawlessly OOTB on post GTX 1000 series GPUs.
````
sudo dnf copr enable szydell/system76
sudo dnf install system76-power
sudo systemctl enable system76-power system76-power-wake
git clone https://github.com/pop-os/gnome-shell-extension-system76-power.git
cd gnome-shell-extension-system76-power
sudo dnf install nodejs-typescript
make
make install
````

## Media Codecs
* Install these to get proper multimedia playback.
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
* On a new install: `sudo dnf install intel-media-driver`
</details>

<details>
<summary>AMD</summary>
 
* If you have an AMD chipset, after installing the packages above do:
* On a new install: `sudo dnf install --enablerepo=rpmfusion-free-updates-testing mesa-va-drivers-freeworld`
* If you're upgrading from fedora 36: `sudo dnf swap --enablerepo=rpmfusion-free-updates-testing mesa-va-drivers mesa-va-drivers-freeworld` 
</details>

<details>
<summary>NVIDIA</summary>
 
* If you have an Nvidia chipset, after installing the packages above do:
* On a new install: `sudo dnf install --enablerepo=rpmfusion-free-updates-testing mesa-vdpau-drivers-freeworld`
* If you're upgrading from fedora 36: `sudo dnf swap --enablerepo=rpmfusion-free-updates-testing mesa-vdpau-drivers mesa-vdpau-drivers-freeworld` 
</details>

### OpenH264 for Firefox
* Enhance H.264/MPEG-4 media playback by doing:
```
sudo dnf config-manager --set-enabled fedora-cisco-openh264
sudo dnf install -y gstreamer1-plugin-openh264 mozilla-openh264
```
* Then enable the OpenH264 plugin in Firefox by navigating through the settings.

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
* [Extensions Sync](https://extensions.gnome.org/extension/1486/extensions-sync/)
* [Gesture Improvements](https://extensions.gnome.org/extension/4245/gesture-improvements/)
* [User Themes](https://extensions.gnome.org/extension/19/user-themes/)
* [Just Perfection](https://extensions.gnome.org/extension/3843/just-perfection/)
* [Net Speed Simplified](https://extensions.gnome.org/extension/3724/net-speed-simplified/)
* [Dash to Dock](https://extensions.gnome.org/extension/307/dash-to-dock/)
* [GSconnect](https://extensions.gnome.org/extension/1319/gsconnect/)
* [Blur My Shell](https://extensions.gnome.org/extension/3193/blur-my-shell/)
* [Bluetooth Quick Connect](https://extensions.gnome.org/extension/1401/bluetooth-quick-connect/)
* [Input Output Device Chooser](https://github.com/mmalafaia/gse-sound-output-device-chooser/tree/patch-1)
* [Gnome Shell Extension Indicator](https://extensions.gnome.org/extension/615/appindicator-support/)
* [Clipboard Indicator](https://extensions.gnome.org/extension/779/clipboard-indicator/)

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
* `git clone https://github.com/EliverLara/firefox-nordic-theme && cd firefox-nordic-theme`
* `./scripts/install.sh -g -p *.default-release`

### Grub Theme
* https://github.com/vinceliuice/grub2-themes
