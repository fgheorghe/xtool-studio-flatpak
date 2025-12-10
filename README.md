# xTool Studio Flatpak Builder

Scripts for creating xTool Studio Flatpak packages on Ubuntu, tested and verified working on Fedora Kinoite 43.

## Prerequisites

- A `.deb` xTool Studio package (e.g., `xTool-Studio-x64-1.2.11.deb`) in the current directory

## Installation

Install required dependencies:
```bash
sudo apt install flatpak flatpak-builder
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.freedesktop.Platform//23.08 org.freedesktop.Sdk//23.08
flatpak install flathub org.electronjs.Electron2.BaseApp//23.08
```

## Building

Build the Flatpak package:
```bash
make BRANCH=1.2.11
```

> **Note:** The `BRANCH` parameter must match the version number in your `.deb` filename.

## Example
```bash
# For xTool-Studio-x64-1.2.11.deb
make BRANCH=1.2.11

# For xTool-Studio-x64-2.0.5.deb
make BRANCH=2.0.5
```
