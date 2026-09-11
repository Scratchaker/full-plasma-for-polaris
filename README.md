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
<details>
<summary><strong>Mouse capture.</strong></summary>

Some games that capture the mouse for in-game camera movement may not capture it correctly, preventing the camera from moving. This is a known issue that we are currently working to fix.

**Temporary workaround:** When a game needs to capture the mouse, press the **Right Ctrl** key while the stream is focused.
</details>
<details>
<summary><strong>Fullscreen Video Unfullscreening on Chromium browsers.</strong></summary>

When watching videos in Chromium based browser through the stream, toggling fullscreen immediately unfullscreens the video again. This does not happen when GPU acceleration is disabled entirely, and is fixed by disabling GPU compositing with `--disable-gpu-compositing`.

1. **Set the flag via config file (try first).**

    **Chromium:** `echo '--disable-gpu-compositing' >> ~/.config/chromium-flags.conf`
   
    **Google Chrome:** `echo '--disable-gpu-compositing' >> ~/.config/chrome-flags.conf`
   
    **Brave:** `echo '--disable-gpu-compositing' >> ~/.config/brave-flags.conf`

2. **Check if it worked.**

   Restart the browser fully (quit all windows/processes).
   
   Open the browser's internal GPU page and confirm the flag is active:

   Go to `chrome://gpu`

   Check "Graphics Feature Status" for GPU compositing showing as disabled/software only.

4. **If it didn't work: edit the `.desktop` file for your browser.**

    Some distro packaging doesn't source the `*-flags.conf` file automatically. In that case, edit the launcher's `Exec=` line directly.

    First, copy the relevant `.desktop` file to your local overrides directory (editing the one in `/usr/share/applications/` directly will get overwritten on package updates):

    ```
    mkdir -p ~/.local/share/applications
    cp /usr/share/applications/chromium.desktop ~/.local/share/applications/
    # or: brave-browser.desktop / google-chrome.desktop, depending on which browser
    ```

    Then edit the `Exec=` line in the copied file to include the flag before `%U`, for example:

    ```
    Exec=/usr/bin/chromium --disable-gpu-compositing %U
    ```

    Save, then re-run the check in Step 2.
</details>
