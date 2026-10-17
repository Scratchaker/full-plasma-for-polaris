#!/usr/bin/env bash
set -e

trap 'cleanup' EXIT
cleanup() {
    systemctl --user restart xdg-document-portal xdg-desktop-portal
}

# Get resolution
PLASMA_WIDTH=${POLARIS_CLIENT_WIDTH:-1920}
PLASMA_HEIGHT=${POLARIS_CLIENT_HEIGHT:-1080}

# Write wrapper
mkdir -p "$XDG_RUNTIME_DIR/nested-plasma"

cat > "$XDG_RUNTIME_DIR/nested-plasma/kwin_wayland_wrapper" <<EOF
#!/usr/bin/env bash
exec /usr/bin/kwin_wayland_wrapper \
    --width "$PLASMA_WIDTH" \
    --height "$PLASMA_HEIGHT" \
    --no-lockscreen "\$@"
EOF
chmod +x "$XDG_RUNTIME_DIR/nested-plasma/kwin_wayland_wrapper"

# pkexec management
cat > "$XDG_RUNTIME_DIR/nested-plasma/zenity-askpass" <<'EOF'
#!/usr/bin/env bash
exec zenity --password --title="Authentication Required"
EOF
chmod +x "$XDG_RUNTIME_DIR/nested-plasma/zenity-askpass"

export SUDO_ASKPASS="$XDG_RUNTIME_DIR/nested-plasma/zenity-askpass"

cat > "$XDG_RUNTIME_DIR/nested-plasma/pkexec" <<'EOF'
#!/usr/bin/env bash
while [ $# -gt 0 ]; do
    case "$1" in
        --disable-internal-agent|--keep-cwd)
            shift
            ;;
        --)
            shift
            break
            ;;
        -*)
            echo "pkexec shim: unsupported flag '$1'" >&2
            exit 1
            ;;
        *)
            break
            ;;
    esac
done

if [ $# -eq 0 ]; then
    echo "pkexec shim: no command given" >&2
    exit 1
fi
exec sudo -k -A "$@"
EOF
chmod +x "$XDG_RUNTIME_DIR/nested-plasma/pkexec"

# Chromium-based browsers: disable GPU compositing
for browser in "chromium" "google-chrome-stable" "google-chrome" "brave" "brave-browser" "microsoft-edge-stable" "vivaldi-stable"; do
    real="/usr/bin/$browser"
    [ -x "$real" ] || continue
    cat > "$XDG_RUNTIME_DIR/nested-plasma/$browser" <<EOF
#!/usr/bin/env bash
exec "$real" --disable-gpu-compositing "\$@"
EOF
    chmod +x "$XDG_RUNTIME_DIR/nested-plasma/$browser"
done

# Path
export PATH="$XDG_RUNTIME_DIR/nested-plasma:$PATH"

# Exports
export XDG_SESSION_DESKTOP=KDE
export DESKTOP_SESSION=plasma
export XDG_SEAT=seat0
export XDG_SESSION_CLASS=user

# Run Plasma
dbus-run-session startplasma-wayland &

