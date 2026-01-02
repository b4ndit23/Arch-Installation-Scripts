## Synopsis:

- `Wayland`, `Hyperland`, `Waybar` riced with `py-wal`
- Custom aliases and functions.
- Custom Scripts
- `Yubikey CLI` integration for `sudo`.
- `AppArmor` enabled.
- Unlocks `blackarch` library.
- Uses dark theme.
  
![Screenshot](screenshot1.png)

## Details:

| Category               | Software               
|------------------------|------------------------|
| Window Manager         | Hyprland               |
| Terminal Manager       | Alacritty              |
| Clipboard Manager      | Cliphist               |
| File Manager           | Yazi                   |
| Status Bar             | Waybar                 |
| Launcher               | Wofi                   |
| Shell                  | Zsh                    |
| Browser                | Librewolf              |
| Text Editor            | Codium                 |

### Waybar:

- Interactive modules.
- Custom module to see available updates.
- Custom module that shows your public ip.
- Custom module to display `cmus` status.
- Fully `pywal` integration with nerdfont icons.

  
### Prefered Bloat:

`yay`  `atool` `exa`  `bat`  `wireshark`  `virtualbox`  `obsidian`  `signal`  `python`  `rust`  `go`  `scrub`  `sxiv`  `apparmor`  `whois`  `tcpdump`  `net-tools` `tinyxxd`  `strace` `lsof` `fwupd` `geckodriver`  `ncurses`  `cmake`  `pngquant`  `oxipng`  `mkcert`  `cmus`  `vlc`  `steam`  `proton-vpn` `timeshift`  `qemu`   `exiftool`   `firejail`   `docker-compose`   `dosfstools`   `macchanger`   `zoxide`   `resvg`   `fd`   `ripgrep`  `gimp`  `ibreoffice`  `zathura`  `obs`  `xpad`  `youtube-music`  `cursor`

### Zsh Plugings, Aliases and Functions:

- `ohmyzsh` and `pywal` integration.
-  Handy aliases and functions.
- `cheat.sh` implemented on a function to use as `cheat <argument>`
- `zsh` plugins.

### Custom Scripts:

- Waybar reset for troubleshooting.
- Theme Change.
- Screenshot and edition.
- Cache management.
- Cmus Status for Waybar
- Spawn floating windows on the cursor position (`Alacritty`,`xpad` and `Youtube-Music`)
### Cybersecurity features:

- `yubikey` integration for passwordless `sudo`.
- `blackarch` library.
- `AppArmor` profiles.

## Installation:

- Make sure you have a `USB` ready to use with a verified Arch `ISO`
- You can use `rufus` or `dd` command in linux:
```bash
# Lookup for your USB drive
sudo fdisk -l
# Lookup for the path of your ISO file
realpath isofile
# Create the bootable USB
sudo dd bs=4M if=/home/shutter/Documents/ISOs/archlinux-2023.10.14-x86_64.iso of=/dev/sdb
```
- Once you booted the `USB` and accessed the Arch `ISO` you may need to connect to your `wifi`
```bash
# Start iwctl
iwctl
# list devices
device list
# Interface set to scan
station wlan0 scan
# Scan for networks
station wlan0 get-networks
# Connect to a network
station wlan0 connect networkname
```
- First, update the `keyring` to avoid issues:
```
pacman -Sy archlinux-keyring
```
- Just run the `archinstall` script. This are the only relevant steps that you need to follow for this build:
  - Use `ext4` file type for your system.
  - `Systemd-bootloader` can give you problems with encryptation, in that case just use `GRUB`
  - Choose `NetworkManager`
  - Extra libraries for `32bit` support.
  - Once is done reboot your system.
  
- Edit `pacman.conf`
```bash
nano /etc/pacman.conf
# Uncoment Color
# Set ParallelDownloads = 5
# Add "ILoveCandy"
```
- Now you should need to connect to the internet, this time use `NetworkManager` from your system:
```bash
# Check if Networkmanager is running
sudo systemctl status NetworkManager.service
sudo systemctl start NetworkManager.service
# Connect to wifi
nmcli device wifi list
nmcli device wifi connect SSID_or_BSSID password password
# Different interface
nmcli device wifi connect SSID_or_BSSID password password ifname wlan1 profile_name
# Hidden network
nmcli device wifi connect SSID_or_BSSID password password hidden yes
```
- And download this repository:
```bash
git clone https://github.com/b0llull0s/Arch-Installation-Script.git
```
- Some application doesnt accept relatives paths and you will have to change those to your own home folder.
- You may also want to create a new directory with your desired profile name on `Wireshark/profile` and move the files inside.
- You may want to add your wallpapers to the `w4llp4p3rs` folder or just change the name and path on the script as you want.
- If you experience problems with `py-wal`, make sure that all the paths inside the config files match with your system files.
### Yubikey:
- To integrate your `yubikey` for passwordless sudo:
```bash
# Introduce this command, if it generates a hash is all good
pamu2fcfg
# Create the directory for the config files
mkdir -p ~/.config/Yubico
# Now register the hash in the config file
pamu2fcfg -o pam://me -i pam://me > ~/.config/Yubico/u2f_keys
```
- Now configure `PAM`. 
> [!CAUTION]
> **Don't close the `PAM` file until you make it work if you want to avoid pain!!!**
```bash
sudo nano /etc/pam.d/sudo
```
- Make sure the file looks like this:
```bash
#%PAM-1.0
account         include         system-auth
session         include         system-auth
auth            sufficient      pam_u2f.so cue origin=pam://me appid=pam://me
```
- Without closing the `PAM` file test to see if it works:
```bash
sudo echo "SUCCESS"
```
### AppArmor:
- Add the kernel parameters to your bootloader:
```bash
# For GRUB:
sudo nano /etc/default/grub
# Edit this line so it looks like this:
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet lsm=landlock,lockdown,yama,apparmor,bpf"
# Now run this command:
grub-mkconfig -o /boot/grub/grub.cfg
# Enable the service:
sudo systemctl enable apparmor.service
# Reboot your system and check if AppArmor enabled:
aa-enabled
# Now parse the profiles
sudo apparmor_parser /usr/share/apparmor/extra-profiles
```
### Pywalfox
- For `Librewolf` you need to run this command:
```bash
pywalfox install --browser librewolf
```
- And then get the addon like you would normally do

![Screenshot](screenshot.png)

## Tips:

- Sometimes you may enconter an error retrieving the `blackarch.db` while updating the system, this error is normally related to a mirror having an expired certificate, simply comment that mirror and uncomment another one
```bash
sudo nano /etc/pacman.d/blackarch-mirrorlist
``` 
- In case you need to generate a new `py-wal` template just use the alias `walup`:
```bash
# For a specific file
wal -i ~/Downloads/w4llp4p3rs/1.jpg
```
- In case you need to make zsh your default shell:
```bash
usermod --shell /usr/bin/zsh username
```
- Refresh your system data base:
```bash
sudo updatedb
``` 
- To implement plugings use locate to find the path of the plugin file and add it to your source file:
```bash
# use this command:
locate zsh-autosuggestions
# Copy the .zsh entry and add it as source in the config file:
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
```
- Type `alias`to check the list of aliases.
- Nowdays with `Steam` using `proton` you dont need to install the `graphical drivers` yourself, the correct drivers for your system will be install when installing `proton` from `Steam`.
- Use `atool` to compress and uncompress files, worth to have a look at the `Arch Manual pages`.
- Once you have apparmor ready you may want to have a look to the `snap store`.
- I dont use `xwayland` but in case you do, the `env` paths are commented on `hyprland.conf`.
- At some point your pacman cache may grow more than it should, clear old libraries and cache to release space
```sh
sudo pacman -Scc
```
- Same for `Yay`:
```sh
yay -Y --clean
```
- You can also use this command to delete core dump files
```sh
find / -xdev -name core -ls -o  -path "/lib*" -prune
```
- Install `flatpak` applications using your home folder instead of root:
```sh
flatpak install --user appName.flatpak
``` 
> [!CAUTION]
>- Currently Virtualbox Can't Use Fullscreen Mode On Wayland by default.
>- To fix this, go to "User Interface" on the "Settings" from your VM and uncheck "Show in Full-screen/Seamless".
>- This shoud fix the issue, after just adapt the display resolution inside the VM to match the size you are using with your compositor.
## Mouse Bindings:

| Combination                          | Action                  |
|--------------------------------------|-------------------------|
| `Super + RIGHT CLICK`                | Resize Window           |
| `Super + LEFT CLICK`                 | Drag Window             |

## Key Bindings:

| Combination                          | Action                  |
|--------------------------------------|-------------------------|
| `Super + Enter`                      | Alacritty               |
| `Super + E`                          | Librewolf               |
| `Super + K`                          | Kill Window             |
| `Super + D`                          | Wofi                     |
| `Super + [1-9]`                      | Switch Workspace        |
| `Super + [SHIFT] + [1-9]`            | Move Window to Workspace|
| `Super + [SHIFT] + [ARROW]`          | Resize Window           |
| `Super + [CTRL] + [ARROW]`           | Move Window             |
| `Super + [ARROW]`                    | Move within Windows     |
| `Super + P`                          | Toggle Split            |
| `Super + O`                          | Toggle Float            |
| `Super + I`                          | Swap Horizontal/Verical |
| `Super + U`                          | Full screen             |
| `Super + [PRINTSCRN]`                | Screenshot              |
| `Super + C`                          | Codium                  |
| `Super + F`                          | Obsidian                |
| `Super + S`                          | Signal                  |
| `Super + B`                          | Reset waybar            |
| `Super + W`                          | Changes theme           |
| `Super + Q`                          | Volume Up               |
| `Super + A`                          | Volume Down             |
| `Super + R`                          | Clear cache             |
| `Super + M`                          | Youtube-Music           |
| `Super + N`                          | Xpad                    |
| `Super + V`                          | Clipboard               |

## Credits and appreciations 

- Credit to **_Stephan Raabe_** for the base idea behind the custom scripts and all the `pywal` integration without his youtube channel would have been way harder.
- Credit to **_s4vitar_** for the `rmk` function.
- Credit to the **_annonymous_** user who posted the `waybar` custom module to see your public ip.
- Credit to **_Alan Moore_** and **_Dave Gibbons_** for `image1` and The band **_Sleep_** for `image2`
- Wallpaper by **_Wenqing Yan_**. ;) 

![Screenshot](image3.png)
