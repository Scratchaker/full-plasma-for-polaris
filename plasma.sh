#!/usr/bin/env bash
set -e

PLASMA_WIDTH=${POLARIS_CLIENT_WIDTH:-1920}
PLASMA_HEIGHT=${POLARIS_CLIENT_HEIGHT:-1080}

mkdir -p "$XDG_RUNTIME_DIR/nested-plasma"

cat > "$XDG_RUNTIME_DIR/nested-plasma/kwin_wayland_wrapper" <<EOF
#!/bin/sh
exec /usr/bin/kwin_wayland_wrapper \
    --width "$PLASMA_WIDTH" \
    --height "$PLASMA_HEIGHT" \
    --no-lockscreen "\$@"
EOF
chmod +x "$XDG_RUNTIME_DIR/nested-plasma/kwin_wayland_wrapper"

cat > "$XDG_RUNTIME_DIR/nested-plasma/zenity-askpass" <<'EOF'
#!/bin/sh
exec zenity --password --title="Authentication Required"
EOF
chmod +x "$XDG_RUNTIME_DIR/nested-plasma/zenity-askpass"

export SUDO_ASKPASS="$XDG_RUNTIME_DIR/nested-plasma/zenity-askpass"

cat > "$XDG_RUNTIME_DIR/nested-plasma/pkexec" <<'EOF'
#!/bin/sh
case "$1" in
    -*)
        echo "pkexec shim: unsupported flag '$1'" >&2
        exit 1
        ;;
esac
exec sudo -k -A "$@"
EOF
chmod +x "$XDG_RUNTIME_DIR/nested-plasma/pkexec"

export PATH="$XDG_RUNTIME_DIR/nested-plasma:$PATH"


dbus-run-session startplasma-wayland &
