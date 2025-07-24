#!/bin/bash

echo "===========================================" 
echo "Complete i3 Setup for Ubuntu"
echo "==========================================="

# Create necessary directories
mkdir -p ~/.config/i3
mkdir -p ~/.config/i3status
mkdir -p ~/.urxvt/ext
mkdir -p ~/Pictures

# Function to prompt user
ask_user() {
    while true; do
        read -p "$1 (y/n): " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

echo ""
echo "This script will:"
echo "1. Install i3 window manager and dependencies"
echo "2. Install i3-gaps (enhanced i3 with gaps)"
echo "3. Configure URxvt terminal with extensions"
echo "4. Set up wallpaper with feh"
echo "5. Create i3 and i3status configurations"
echo ""

if ask_user "Do you want to proceed?"; then
    echo "Starting installation..."
else
    echo "Installation cancelled."
    exit 0
fi

# Update system
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install base packages
echo "Installing i3 and essential packages..."
sudo apt install -y \
    i3 i3status i3lock xorg lightdm rofi firefox gnome-terminal \
    thunar network-manager-gnome cups xfce4-power-manager conky-all \
    htop pulseaudio pavucontrol alsa-utils xbindkeys arandr \
    xbacklight feh compton snapd numlockx unclutter cmus ufw \
    rxvt-unicode xclip curl wget git pasystray paprefs pavumeter \
    pulseaudio-module-zeroconf playerctl

# Install i3-gaps dependencies
echo "Installing i3-gaps dependencies..."
sudo apt install -y \
    libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev \
    libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev \
    libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev \
    libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf \
    libxcb-xrm0 libxcb-xrm-dev automake make gcc libxcb-shape0-dev \
    meson ninja-build

# Build and install i3-gaps
if ask_user "Do you want to install i3-gaps (enhanced i3 with gaps support)?"; then
    echo "Building i3-gaps..."
    cd /tmp
    git clone https://www.github.com/Airblader/i3 i3-gaps
    cd i3-gaps
    meson build
    ninja -C build
    sudo ninja -C build install
    echo "i3-gaps installed successfully!"
fi

# Setup URxvt
if ask_user "Do you want to setup URxvt terminal with extensions?"; then
    echo "Setting up URxvt..."
    git clone https://github.com/muennich/urxvt-perls /tmp/urxvt-perls
    cd /tmp/urxvt-perls
    cp keyboard-select ~/.urxvt/ext/
    cp deprecated/clipboard ~/.urxvt/ext/
    cp deprecated/url-select ~/.urxvt/ext/
    
    # Create .Xresources
    cat > ~/.Xresources << 'EOF'
!! Colorscheme
*.foreground: #93a1a1
*.background: #141c21
*.cursorColor: #afbfbf

! black
*.color0: #263640
*.color8: #4a697d

! red
*.color1: #d12f2c
*.color9: #fa3935

! green
*.color2: #819400
*.color10: #a4bd00

! yellow
*.color3: #b08500
*.color11: #d9a400

! blue
*.color4: #2587cc
*.color12: #2ca2f5

! magenta
*.color5: #696ebf
*.color13: #8086e8

! cyan
*.color6: #289c93
*.color14: #33c5ba

! white
*.color7: #bfbaac
*.color15: #fdf6e3

!! URxvt Appearance
URxvt.font: xft:DejaVu Sans Mono:size=11
URxvt.boldFont: xft:DejaVu Sans Mono:bold:size=11
URxvt.letterSpace: 0
URxvt.lineSpace: 0
URxvt.geometry: 92x24
URxvt.internalBorder: 24
URxvt.cursorBlink: true
URxvt.saveline: 2048
URxvt.scrollBar: false
URxvt.urgentOnBell: true
URxvt.depth: 24
URxvt.iso14755: false

!! Extensions and keybinds
URxvt.perl-ext-common: default,clipboard,url-select,keyboard-select
URxvt.copyCommand: xclip -i -selection clipboard
URxvt.pasteCommand: xclip -o -selection clipboard
URxvt.keysym.M-c: perl:clipboard:copy
URxvt.keysym.M-v: perl:clipboard:paste
URxvt.keysym.M-Escape: perl:keyboard-select:activate
URxvt.keysym.M-u: perl:url-select:select_next
URxvt.urlLauncher: firefox
URxvt.underlineURLs: true
EOF
    xrdb ~/.Xresources
    echo "URxvt setup complete!"
fi

# Setup wallpaper
if ask_user "Do you want to setup wallpaper?"; then
    echo "Setting up wallpaper..."
    cd ~/Pictures
    wget -O ghost2.jpg "https://github.com/elithrade/manjaro-i3/raw/master/wallpapers/ghost2.jpg" || \
    wget -O ghost2.jpg "https://w.wallhaven.cc/full/28/wallhaven-28j39o.jpg"
    ln -sf ghost2.jpg wallpaper.jpg
    feh --bg-scale ~/Pictures/wallpaper.jpg
    echo "Wallpaper set!"
fi

# Create i3 config
echo "Creating i3 configuration..."
cat > ~/.config/i3/config << 'EOF'
# i3 config file (v4) for Ubuntu
set $mod Mod4
set $alt Mod1

font pango:DejaVu Sans Mono 10
floating_modifier $mod

# Keybindings
bindsym $mod+Return exec gnome-terminal
bindsym $alt+F4 kill
bindsym $mod+d exec --no-startup-id rofi -show run

# Focus
bindsym $mod+j focus left
bindsym $mod+k focus down
bindsym $mod+l focus up
bindsym $mod+semicolon focus right
bindsym $mod+Left focus left
bindsym $mod+Down focus down
bindsym $mod+Up focus up
bindsym $mod+Right focus right

# Move windows  
bindsym $mod+Shift+j move left
bindsym $mod+Shift+k move down
bindsym $mod+Shift+l move up
bindsym $mod+Shift+semicolon move right
bindsym $mod+Shift+Left move left
bindsym $mod+Shift+Down move down
bindsym $mod+Shift+Up move up
bindsym $mod+Shift+Right move right

# Layout
bindsym $mod+h split h
bindsym $mod+v split v
bindsym $mod+f fullscreen toggle
bindsym $mod+s layout stacking
bindsym $mod+w layout tabbed
bindsym $mod+e layout toggle split

# Floating
bindsym $mod+Shift+space floating toggle
bindsym $mod+space focus mode_toggle

# Workspaces
set $ws1 "1"
set $ws2 "2" 
set $ws3 "3"
set $ws4 "4"
set $ws5 "5"
set $ws6 "6"
set $ws7 "7"
set $ws8 "8"
set $ws9 "9"
set $ws10 "10"

bindsym $mod+1 workspace $ws1
bindsym $mod+2 workspace $ws2
bindsym $mod+3 workspace $ws3
bindsym $mod+4 workspace $ws4
bindsym $mod+5 workspace $ws5
bindsym $mod+6 workspace $ws6
bindsym $mod+7 workspace $ws7
bindsym $mod+8 workspace $ws8
bindsym $mod+9 workspace $ws9  
bindsym $mod+0 workspace $ws10

bindsym $mod+Shift+1 move container to workspace $ws1
bindsym $mod+Shift+2 move container to workspace $ws2
bindsym $mod+Shift+3 move container to workspace $ws3
bindsym $mod+Shift+4 move container to workspace $ws4
bindsym $mod+Shift+5 move container to workspace $ws5
bindsym $mod+Shift+6 move container to workspace $ws6
bindsym $mod+Shift+7 move container to workspace $ws7
bindsym $mod+Shift+8 move container to workspace $ws8
bindsym $mod+Shift+9 move container to workspace $ws9
bindsym $mod+Shift+0 move container to workspace $ws10

# System
bindsym $mod+Shift+c reload
bindsym $mod+Shift+r restart
bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'Exit i3?' -B 'Yes' 'i3-msg exit'"

# Resize mode
mode "resize" {
    bindsym j resize shrink width 10 px or 10 ppt
    bindsym k resize grow height 10 px or 10 ppt
    bindsym l resize shrink height 10 px or 10 ppt
    bindsym semicolon resize grow width 10 px or 10 ppt
    bindsym Left resize shrink width 10 px or 10 ppt
    bindsym Down resize grow height 10 px or 10 ppt
    bindsym Up resize shrink height 10 px or 10 ppt
    bindsym Right resize grow width 10 px or 10 ppt
    bindsym Return mode "default"
    bindsym Escape mode "default"
}
bindsym $mod+r mode "resize"

# Media keys
bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%
bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5%
bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle
bindsym XF86MonBrightnessUp exec --no-startup-id xbacklight -inc 10
bindsym XF86MonBrightnessDown exec --no-startup-id xbacklight -dec 10

# App shortcuts
bindsym $mod+i exec firefox
bindsym $alt+e exec thunar

# Status bar
bar {
    position top
    status_command i3status
    font pango:DejaVu Sans Mono 10
}

# Startup programs
exec --no-startup-id nm-applet
exec --no-startup-id xfce4-power-manager
exec --no-startup-id pasystray
exec --no-startup-id unclutter
exec --no-startup-id compton -b
exec --no-startup-id numlockx on
exec_always --no-startup-id feh --bg-scale ~/Pictures/wallpaper.jpg

# Window rules
for_window [class="^.*"] border pixel 2
assign [class="Firefox"] $ws2

# i3-gaps
gaps inner 10
gaps outer 5
smart_gaps on
smart_borders on
EOF

# Create i3status config
echo "Creating i3status configuration..."
cat > ~/.config/i3status/config << 'EOF'
general {
    colors = true
    interval = 5
}

order += "cpu_usage"
order += "memory"
order += "disk /"
order += "battery all"
order += "wireless _first_"
order += "ethernet _first_"
order += "volume master"
order += "tztime local"

wireless _first_ {
    format_up = "WiFi: %ip (%quality)"
    format_down = "WiFi: down"
}

ethernet _first_ {
    format_up = "Eth: %ip"
    format_down = "Eth: down"
}

cpu_usage {
    format = "CPU: %usage"
}

memory {
    format = "RAM: %used"
    threshold_degraded = "1G"
}

battery all {
    format = "%status %percentage"
    status_chr = "⚡"
    status_bat = "🔋"
    status_full = "☻"
    low_threshold = 10
}

disk "/" {
    format = "Disk: %avail"
}

volume master {
    format = "♪: %volume"
    format_muted = "♪: muted"
    device = "pulse"
}

tztime local {
    format = "%Y-%m-%d %H:%M"
}
EOF

# Final steps
echo "Configuring audio..."
pactl set-sink-mute @DEFAULT_SINK@ false 2>/dev/null || true
pactl set-sink-volume @DEFAULT_SINK@ 50% 2>/dev/null || true

echo ""
echo "==========================================="
echo "Setup Complete!"
echo "==========================================="
echo ""
echo "To use your new i3 setup:"
echo "1. Reboot your system: sudo reboot"
echo "2. At login screen, select 'i3' session"
echo "3. After login, press Super+Enter for terminal"
echo ""
echo "Key shortcuts:"
echo "• Super+d: Application launcher (rofi)"
echo "• Super+i: Firefox"  
echo "• Alt+e: File manager (Thunar)"
echo "• Super+Enter: Terminal"
echo "• Super+1-10: Switch workspaces"
echo "• Super+Shift+1-10: Move window to workspace"
echo "• Super+r: Resize mode"
echo "• Alt+F4: Close window"
echo ""
echo "URxvt shortcuts (if installed):"
echo "• Alt+c: Copy"
echo "• Alt+v: Paste"
echo ""

if ask_user "Do you want to reboot now?"; then
    sudo reboot
else
    echo "Please reboot manually when ready!"
fi
