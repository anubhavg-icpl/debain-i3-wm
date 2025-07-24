# i3 Setup Updates - EndeavourOS Style

## 🎯 Key Changes Made

### 1. **Terminal Updated**
- **Old**: gnome-terminal 
- **New**: **Alacritty** (modern GPU-accelerated terminal)
- Keybinding: `Super+Return` launches Alacritty

### 2. **Focus Keys (EndeavourOS Style)**
- **Old**: `j`, `k`, `l`, `;` (QWERTY right-hand side)
- **New**: `j`, `k`, `b`, `o` (QWERTY comfortable positions)
  - `Super+j` = Focus left
  - `Super+k` = Focus down  
  - `Super+b` = Focus up
  - `Super+o` = Focus right

### 3. **Window Management**
- **Kill Window**: `Super+q` (instead of `Alt+F4`)
- **Window Switcher**: `Super+t` (new Rofi window menu)
- **Lock Screen**: `Super+l` (added i3lock support)

### 4. **Application Shortcuts**
- **New EndeavourOS Style**:
  - `Super+w` = Firefox
  - `Super+n` = Thunar file manager
  - `Super+p` = Audio control (PulseAudio)
- **Legacy shortcuts still work**:
  - `Super+i` = Firefox
  - `Alt+e` = Thunar

### 5. **Layout Controls**
- **Tabbed Layout**: `Super+g` (instead of `Super+w`)
- All other layout controls remain the same

### 6. **Help System**
- **F1**: Show keybinding help via Rofi
- **Super+F1**: Edit keybindings reference file with nano
- Added comprehensive keybindings reference file

### 7. **Resize Mode**
- Updated to use `j`, `k`, `b`, `o` keys (matching focus keys)
- Arrow keys still work as alternatives

## 📦 Package Updates

### Added Packages:
- **alacritty** - Modern terminal emulator
- **nano** - Text editor for keybindings editing
- **xfce4-terminal** - Backup terminal for editing configs

### All Original Features Preserved:
- ✅ i3-gaps with configurable gaps
- ✅ URxvt terminal with extensions  
- ✅ Custom color schemes
- ✅ Wallpaper management with feh
- ✅ Audio/brightness controls
- ✅ Network manager integration
- ✅ Auto-startup applications

## 🎨 Visual & UX Improvements

- **Consistent keybinding scheme** following EndeavourOS conventions
- **Rofi integration** for application launcher AND window switcher
- **Built-in help system** with F1 key
- **Easy config editing** with Super+F1
- **Modern terminal** with GPU acceleration

## 🚀 Installation

The **Complete Setup Script** now includes all these updates automatically. Just run:

```bash
chmod +x setup-i3.sh
./setup-i3.sh
```

## 📚 Quick Reference

After installation, press **F1** in i3 to see all keybindings, or **Super+F1** to edit the keybindings reference file.

### Most Important New Shortcuts:
- `Super+Return` - Terminal (Alacritty)
- `Super+q` - Close window
- `Super+t` - Window switcher  
- `Super+w` - Firefox
- `Super+n` - File manager
- `Super+l` - Lock screen
- `F1` - Help menu

All changes maintain backwards compatibility with the original Debian setup while adding modern EndeavourOS-style improvements!
