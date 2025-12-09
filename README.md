Script to create XTool Studio Flatpak on Ubuntu. Tested and works without issue on Fedora Kinoite 43.

```
sudo apt install flatpak flatpak-builder
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.freedesktop.Platform//23.08 org.freedesktop.Sdk//23.08
flatpak install flathub org.electronjs.Electron2.BaseApp//23.08

cat > com.xtool.Studio.yml << 'EOF'
app-id: com.xtool.Studio
runtime: org.freedesktop.Platform
runtime-version: '23.08'
sdk: org.freedesktop.Sdk
base: org.electronjs.Electron2.BaseApp
base-version: '23.08'
command: xtool-studio

finish-args:
  - --share=ipc
  - --socket=x11
  - --socket=wayland
  - --socket=pulseaudio
  - --share=network
  - --device=all
  - --filesystem=home
  - --talk-name=org.freedesktop.Notifications
  - --env=ELECTRON_NO_SANDBOX=1  # Disable sandbox in flatpak

modules:
  - name: xtool-studio
    buildsystem: simple
    build-commands:
      # Extract deb
      - ar x xTool-Studio-x64-*.deb
      - tar -I zstd -xf data.tar.zst
      
      # Install to flatpak directory
      - mkdir -p /app/bin /app/lib/xtool-studio
      - cp -r usr/lib/xtool-studio/* /app/lib/xtool-studio/
      
      # Remove chrome-sandbox (flatpak provides its own sandboxing)
      - rm -f /app/lib/xtool-studio/chrome-sandbox
      
      # Create wrapper script with no-sandbox flag
      - |
        cat > /app/bin/xtool-studio << 'WRAPPER'
        #!/bin/bash
        cd /app/lib/xtool-studio
        exec "./xTool Studio" --no-sandbox "$@"
        WRAPPER
      - chmod +x /app/bin/xtool-studio
      
      # Install desktop file and icon
      - mkdir -p /app/share/applications /app/share/icons/hicolor/256x256/apps
      - install -Dm644 usr/share/applications/xtool-studio.desktop /app/share/applications/com.xtool.Studio.desktop
      - install -Dm644 usr/share/pixmaps/xtool-studio.png /app/share/icons/hicolor/256x256/apps/com.xtool.Studio.png
      
      # Fix desktop file
      - desktop-file-edit --set-key=Exec --set-value=xtool-studio /app/share/applications/com.xtool.Studio.desktop
      - desktop-file-edit --set-key=Icon --set-value=com.xtool.Studio /app/share/applications/com.xtool.Studio.desktop
    
    sources:
      - type: file
        path: xTool-Studio-x64-1.1.10.deb
EOF

 flatpak-builder --force-clean build-dir com.xtool.Studio.yml
 flatpak-builder --run build-dir com.xtool.Studio.yml xtool-studio
 flatpak-builder --repo=repo --force-clean build-dir com.xtool.Studio.yml
 flatpak build-bundle repo xtool-studio.flatpak com.xtool.Studio
```
