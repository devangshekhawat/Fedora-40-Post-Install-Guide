 # Fedora 40 Post Install Guide
Things to do after installing Fedora 40

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
max_parallel_downloads=10 
``` 
* Note: The `fastestmirror=1` and `deltarpm=true` arguments were removed. Avoid using these even if you find them in other guides. They are counterproductive at best.

## RPM Fusion
* Fedora has disabled the repositories for a lot of free and non-free .rpm packages by default. Follow this if you want to use non-free software like Steam, Discord and some multimedia codecs etc. As a general rule of thumb it is advised to do this to get access to many mainstream useful programs.
* If you forgot to enable third party repositories during the initial setup window, enable them by pasting the following into the terminal: 
* `sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm`
* also while you're at it, install app-stream metadata by
* `sudo dnf group update core`

## Update 
* Go into the software center and click on update. Alternatively, you can use the following commands:
* `sudo dnf -y update`
* `sudo dnf -y upgrade --refresh`
* Reboot

## Firmware
* If your system supports firmware update delivery through lvfs, update your device firmware by:
```
sudo fwupdmgr refresh --force
sudo fwupdmgr get-devices # Lists devices with available updates.
sudo fwupdmgr get-updates # Fetches list of available updates.
sudo fwupdmgr update
```
## Flatpak
* Fedora doesn't include all non-free flatpaks by default. The command below enables access to all the flathub flatpaks. Particularly useful for users of Fedora KDE and other spins since they do not get the "Enable Third Party Repositories" option on initial boot.
* `flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo`

## NVIDIA Drivers
* Only follow this if you have a NVIDIA gpu. Also, don't follow this if you have a gpu which has dropped support for newer driver releases i.e. anything earlier than nvidia GT/GTX 600, 700, 800, 900, 1000, 1600 and RTX 2000, 3000, 4000 series. Fedora comes preinstalled with NOUVEAU drivers which may or may not work better on those remaining older GPUs. This should be followed by Desktop and Laptop users alike.
* Disable Secure Boot.
* `sudo dnf update` #To make sure you're on the latest kernel and then reboot.
* Enable RPM Fusion Nvidia non-free repository in the app store and install it from there,
* or alternatively
* `sudo dnf install akmod-nvidia`
* Install this if you use applications that can utilise CUDA i.e. Davinci Resolve, Blender etc.
* `sudo dnf install xorg-x11-drv-nvidia-cuda`
* Wait for atleast 5 mins before rebooting, to let the kermel module get built.
* `modinfo -F version nvidia` #Check if the kernel module is built.
* Reboot

## ~~Battery Life (Deprecated)~~
* ~~Follow this if you have a Laptop and are facing sub optimal battery backup.~~
* ~~power-profiles-daemon which come pre-configured on fedora works well on a great majority of systems but still in case you're facing sub-optimal battery backup you try installing tlp by:~~
* ~~`sudo dnf install tlp tlp-rdw`~~
* ~~and mask power-profiles-daemon by:~~
* ~~`sudo systemctl mask power-profiles-daemon`~~
* ~~Also install powertop by:~~
* ~~`sudo dnf install powertop`~~
* ~~`sudo powertop --auto-tune`~~
* Edit: Fedora comes preinstalled with PPD(power-profiles-daemon) which works well on its own now and all the aforementioned changes are now unnecessary. Just follow [HW video acceleration](https://github.com/devangshekhawat/Fedora-40-Post-Install-Guide/blob/main/README.md#hw-video-acceleration) for better battery backup. 

## Media Codecs
* Install these to get proper multimedia playback.
````
sudo dnf swap 'ffmpeg-free' 'ffmpeg' --allowerasing # Switch to full FFMPEG.
sudo dnf group install Multimedia
sudo dnf update @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin # Installs gstreamer components. Required if you use Gnome Videos and other dependent applications.
sudo dnf update @sound-and-video # Installs useful Sound and Video complement packages.
````

## H/W Video Acceleration
* Helps decrease load on the CPU when watching videos online by alloting the rendering to the dGPU/iGPU. Quite helpful in increasing battery backup on laptops.

### H/W Video Decoding with VA-API 
* `sudo dnf install ffmpeg ffmpeg-libs libva libva-utils`

<details>
<summary>Intel</summary>
 
* If you have a recent Intel chipset (5th Gen and above) after installing the packages above., Do:
* `sudo dnf swap libva-intel-media-driver intel-media-driver --allowerasing`
</details>

<details>
<summary>AMD</summary>No need to do this for intel integrated graphics. Mesa drivers are for AMD graphics, who lost support for h264/h245 in the fedora repositories in f38 due to legal concerns.
 
* If you have an AMD chipset, after installing the packages above do:
```
sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld
sudo dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
```
</details>

### OpenH264 for Firefox
* `sudo dnf config-manager --set-enabled fedora-cisco-openh264`
* `sudo dnf install -y openh264 gstreamer1-plugin-openh264 mozilla-openh264`
* After this enable the OpenH264 Plugin in Firefox's settings.

## Set Hostname
* `hostnamectl set-hostname YOUR_HOSTNAME`

## Custom DNS Servers
* For people that want to setup custom DNS servers for better privacy
```
sudo mkdir -p '/etc/systemd/resolved.conf.d' && sudo -e '/etc/systemd/resolved.conf.d/99-dns-over-tls.conf'

[Resolve]
DNS=1.1.1.2#security.cloudflare-dns.com 1.0.0.2#security.cloudflare-dns.com 2606:4700:4700::1112#security.cloudflare-dns.com 2606:4700:4700::1002#security.cloudflare-dns.com
DNSOverTLS=yes
```
## Set UTC Time
* Used to counter time inconsistencies in dual boot systems
* `sudo timedatectl set-local-rtc '0'`

## Optimizations
* The tips below can allow you to squeeze out a little bit more performance from your system. 

### Disable Mitigations 
* Increases performance in multithreaded systems. The more cores you have in your cpu the greater the performance gain. 5-30% performance gain varying upon systems. Do not follow this if you share services and files through your network or are using fedora in a VM. 
* Modern intel CPUs (above 10th gen) do not gain noticeable performance improvements upon disabling mitigations. Hence, disabling mitigations can present some security risks against various attacks, however, it still _might_ increase the CPU performance of your system.
* `sudo grubby --update-kernel=ALL --args="mitigations=off"`

### Enable nvidia-modeset 
* Useful if you have a laptop with an Nvidia GPU. Necessary for some PRIME-related interoperability features.
* `sudo grubby --update-kernel=ALL --args="nvidia-drm.modeset=1"`

### Disable `NetworkManager-wait-online.service`
* Disabling it can decrease the boot time by at least ~15s-20s:
* `sudo systemctl disable NetworkManager-wait-online.service`

### Disable Gnome Software from Startup Apps
* Gnome software autostarts on boot for some reason, even though it is not required on every boot unless you want it to do updates in the background, this takes at least 100MB of RAM upto 900MB (as reported anecdotically). You can stop it from autostarting by:
* `sudo rm /etc/xdg/autostart/org.gnome.Software.desktop`

## Gnome Extensions
* Don't install these if you are using a different spin of Fedora.
* Pop Shell - run `sudo dnf install -y gnome-shell-extension-pop-shell xprop` to install it.
* [GSconnect](https://extensions.gnome.org/extension/1319/gsconnect/) - run `sudo dnf install nautilus-python` for full support. then `sudo firewall-cmd --permanent --zone=public --add-service=kdeconnect`
* [Gesture Improvements](https://extensions.gnome.org/extension/4245/gesture-improvements/)
* [Quick Settings Tweaker](https://github.com/qwreey75/quick-settings-tweaks)
* [User Themes](https://extensions.gnome.org/extension/19/user-themes/)
* [Compiz Windows Effect](https://extensions.gnome.org/extension/3210/compiz-windows-effect/)
* [Just Perfection](https://extensions.gnome.org/extension/3843/just-perfection/)
* [Rounded Windows Corners](https://extensions.gnome.org/extension/5237/rounded-window-corners/)
* [Dash to Dock](https://extensions.gnome.org/extension/307/dash-to-dock/)
* [Quick Settings Tweaker](https://extensions.gnome.org/extension/5446/quick-settings-tweaker/)
* [Blur My Shell](https://extensions.gnome.org/extension/3193/blur-my-shell/)
* [Bluetooth Quick Connect](https://extensions.gnome.org/extension/1401/bluetooth-quick-connect/)
* [App Indicator Support](https://extensions.gnome.org/extension/615/appindicator-support/)
* [Clipboard Indicator](https://extensions.gnome.org/extension/779/clipboard-indicator/)
* [Legacy (GTK3) Theme Scheme Auto Switcher](https://extensions.gnome.org/extension/4998/legacy-gtk3-theme-scheme-auto-switcher/)
* [Caffeine](https://extensions.gnome.org/extension/517/caffeine/)
* [Vitals](https://extensions.gnome.org/extension/1460/vitals/)
* [Wireless HID](https://extensions.gnome.org/extension/4228/wireless-hid/)
* [Logo Menu](https://extensions.gnome.org/extension/4451/logo-menu/)
* [Space Bar](https://github.com/christopher-l/space-bar)

## Apps [Optional]
* Packages for Rar and 7z compressed files support:
 `sudo dnf install -y unzip p7zip p7zip-plugins unrar`
* These are Some Packages that I use and would recommend:
```
Amberol
Blanket
Builder
Brave 
Blender
Discord
Drawing
Deja Dup Backups
Endeavour 
Easyeffects
Extension Manager
Flatseal
Foliate
Footage
GIMP
Gnome Tweaks
Gradience
Handbrake
Iotas
Joplin
Khronos
Krita
Logseq
lm_sensors
Onlyoffice
Overskride
Parabolic
Pcloud
PDF Arranger
Planify
Pika backup 
Snapshot
Solanum
Sound Recorder
Tangram
Transmission
Ulauncher
Upscaler
Video Trimmer
VS Codium
yt-dlp
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

### Starship (terminal theme)
* Configure starship to make your terminal look good (refer https://starship.rs)

### Grub Theme
* https://github.com/vinceliuice/grub2-themes
