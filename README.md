# Full Plasma for Polaris
Launch a full KDE Pasma session with polaris's Private Stream (https://github.com/papi-ux/polaris)

# Installation
### Dependencies
- Polaris
- labwc
- KDE Plasma Wayland
- xwayland
- dbus
- zenity

### Installation steps
1. [Install polaris](https://github.com/papi-ux/polaris) and all dependencies.
2. Enable linger for your user: `loginctl enable-linger`.
3. Setup polaris for headless acess: `sudo -H polaris --setup-host --enable-kms --enable-headless-boot`.
4. Enable polaris service `systemctl --user enable --now polaris`.
5. Reboot.
6. Go to `https://localhost:47990/` and create an account.
7. Select `Private Stream` from `Polaris Web UI > Settings > Audio/Video`.
8. Save `plasma.sh`(from the repo) and make it executable.
9. Add `plasma.sh` as an app in `Polaris Web UI > Library > Add New`.
    1. Set `Application Name` to `Plasma`.
    2. Set `Command` to the full path to `plasma.sh`.
    3. Set `Working Directory` to `$HOME`.
10. Add a Moonlight/Nova client from `Polaris Web UI > Devices`.
11. Open the `Plasma` app from your client.
# Troublesooting
### Mouse capture

Some games that capture the mouse for in-game camera movement may not capture it correctly, preventing the camera from moving. This is a known issue that we are currently working to fix.

**Temporary workaround:** When a game needs to capture the mouse, press the **Right Ctrl** key while the stream is focused.
