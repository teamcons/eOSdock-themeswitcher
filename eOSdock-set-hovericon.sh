#!/bin/bash
set -euo pipefail

echo "no"
exit

# Icon up
# Icon-shy-rotate
# Icon-brightness
# Launchner-glow
# broken zoom


# Clean up first. Do a version of gtk.css without a eOSdock override
cat ~/.config/gtk-4.0/gtk.css \
| grep -v "eOSdock-set-transparency" \
> ~/.config/gtk-4.0/gtk1.css

# Replace current gtk version with the temporary gtk.css
cat ~/.config/gtk-4.0/gtk1.css > ~/.config/gtk-4.0/gtk.css

# Then remove temporary one
rm -f ~/.config/gtk-4.0/gtk1.css

# User defined opacity between 0 and 1. Thats valid. Add a eOSdock override
if [[ "$1" =~ ^-?[0-9]+$  ]] && (( 0 <= "$1" <= 100 )) ; then
    decimal=$(bc -l <<< "scale=2 ; $1 / 100")
      echo "Setting opacity override"
      echo "dock{background: alpha(@bg_color,$decimal);}/\*Set by eOSdock-set-transparency\*/"	\ >>  ~/.config/gtk-4.0/gtk.css
fi

# If the script does it, gala crashes
echo "you may want to log anew or run killall io.elementary.dock to see the changes take effect"
