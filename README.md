
# eOSdock-themeswitcher

To use with eOS new dock<br>
I am still working on cool themes:

- Stellas Special: My own take. Close to default
- Plank-Classic: the old Plank look
- Princess Eyebleed : Something horribly pastel
- Aqua : Something more MacOS-y

THE SCRIPT WORKS; BUT EVERYTHING IN THIS REPO IS BRAND NEW AND THERES VERY LITTLE YET<br>
Not even really example scripts


### Usage:

To set theme.css as the current dock theme
```bash
$ eOSdock-themeswitcher.sh ./themes/theme.css
```

No argument, to revert to default
```bash
$ eOSdock-themeswitcher.sh</td></tr></table>
```

login-logout for change to take effect, or do
```bash
$ killall io.elementary.dock</td></tr></table>
```

The file doesnt overwrite gtk.css, and reverts to default without leaving anything else.<br>
This is per user, and does not require sudo

i would do the killall in the script if somehow that didnt crash my session everytime i tried

Application.css is the default. It is taken from the source code itself:
https://github.com/elementary/dock/blob/main/data/Application.css

Please if you have a cool theme send it to me
