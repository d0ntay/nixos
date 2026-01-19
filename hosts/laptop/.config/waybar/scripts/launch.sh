#!/bin/sh


kill $(pgrep waybar)


waybar -c ~/.config/waybar/config & -s ~/.config/waybar/style.css
