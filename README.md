# Dotfiles

## Install

``` bash
bash <(curl -s https://raw.githubusercontent.com/OliverKnights/.dots/master/install.sh)
```

## Gnome terminal

``` sh
dconf dump /org/gnome/terminal/ > gnome_terminal_settings_backup.txt
dconf reset -f /org/gnome/terminal/
dconf load /org/gnome/terminal/ < gnome_terminal_settings_backup.txt
```
