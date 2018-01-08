# Chinese Painting Theme for Sddm

This repo aims at making a Chinese style theme for [sddm](https://github.com/sddm/sddm), and it's based on [sddm-deepin](https://github.com/Match-Yang/sddm-deepin).

## Features

* Use a part of the famous Chinese painting *[清明上河图](https://en.wikipedia.org/wiki/Along_the_River_During_the_Qingming_Festival)* as the default background.
* Provide indivial icons for 10+ desktop environments and window managers.

![screenshot](/doc/screenshot.jpg)

![screenshot1](/doc/screenshot1.jpg)

## Install

### Archlinux
```
$ yaourt -S sddm-chinese-painting-theme
```
### Others
1. Install **qt5-graphicaleffects** package.
2. `git clone https://github.com/fralonra/sddm-chinese-painting-theme`.
3. `cd` to the theme folder and run `./install.sh`.

To make the theme default for sddm, set the `Current` value in `/etc/sddm.conf` as `Current=chinese-painting`, or just run `sudo sed -i "s/^Current=.*/Current=chinese-painting/g" /etc/sddm.conf`.

## Basic Configure
Edit the `theme.conf` file in the theme folder, or create a `theme.conf.user` file to override it.
* `background`: the background image
* `timeFormat`: time format, default: `hh:mm` (show in the top-right corner)
* `dateFormat`: date format, default: `dddd yyyy-MM-dd` (show in the top-right corner)
* `frameHeight`: height for power-frame and session-frame, default: 120
* `buttonSpacing`: space between icon buttons, default: 20
* `iconSmall`: size for small icons in bottom-left corner, default: 30
* `iconLarge`: size for large icons (useravatar, most icon buttons), default: 60
* `fontMedium`: size for medium fonts (except time text), default: 12
* `fontBig`: size for big fonts (currently only time text), default: 20
* `colorText`: text color, default `#edededff`
* `colorBackgroundDark`: color for dark background (background of power-frame, session-frame, current useravatar and password-input), default: `#55000000`

## Todo
1. Easily configure via `theme.conf`, without editing qml files.
2. More suitable paintings for background choice.
3. Icons redesign.
