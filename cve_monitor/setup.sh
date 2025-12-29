#!/usr/bin/env bash
# CVE Monitor Setup Script
# Helps configure automated CVE monitoring

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CVE_MONITOR="$SCRIPT_DIR/cve-monitor"
CONFIG_DIR="$HOME/.config/cve-monitor"

echo "CVE Monitor Setup Utility"
echo "========================="
echo

# Check if cve-monitor exists
if [ ! -f "$CVE_MONITOR" ]; then
    echo "Error: cve-monitor script not found at $CVE_MONITOR"
    exit 1
fi

# Ensure executable
chmod +x "$CVE_MONITOR"

# Function to setup cron job
setup_cron() {
    echo "Setting up daily cron job..."
    echo
    echo "Recommended cron schedule:"
    echo "  Daily at 9 AM:     0 9 * * * $CVE_MONITOR --severity CRITICAL HIGH"
    echo "  Twice daily:       0 9,17 * * * $CVE_MONITOR"
    echo "  Weekly on Monday:  0 9 * * 1 $CVE_MONITOR --days 7"
    echo
    read -p "Add daily 9 AM job? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        (crontab -l 2>/dev/null; echo "0 9 * * * $CVE_MONITOR --severity CRITICAL HIGH") | crontab -
        echo "✓ Cron job added"
    fi
}

# Function to setup macOS LaunchAgent
setup_macos_launchd() {
    echo "Setting up macOS LaunchAgent for daily monitoring..."

    PLIST="$HOME/Library/LaunchAgents/com.user.cve-monitor.plist"

    cat > "$PLIST" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.cve-monitor</string>
    <key>ProgramArguments</key>
    <array>
        <string>$CVE_MONITOR</string>
        <string>--severity</string>
        <string>CRITICAL</string>
        <string>HIGH</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>9</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
    <key>StandardOutPath</key>
    <string>$HOME/Library/Logs/cve-monitor.log</string>
    <key>StandardErrorPath</key>
    <string>$HOME/Library/Logs/cve-monitor-error.log</string>
</dict>
</plist>
EOF

    launchctl unload "$PLIST" 2>/dev/null || true
    launchctl load "$PLIST"

    echo "✓ LaunchAgent installed and loaded"
    echo "  Logs: $HOME/Library/Logs/cve-monitor.log"
}

# Function to setup systemd timer (Linux)
setup_systemd() {
    echo "Setting up systemd timer for daily monitoring..."

    SYSTEMD_DIR="$HOME/.config/systemd/user"
    mkdir -p "$SYSTEMD_DIR"

    # Service file
    cat > "$SYSTEMD_DIR/cve-monitor.service" << EOF
[Unit]
Description=CVE Security Monitor
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=$CVE_MONITOR --severity CRITICAL HIGH
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=default.target
EOF

    # Timer file
    cat > "$SYSTEMD_DIR/cve-monitor.timer" << EOF
[Unit]
Description=Daily CVE Security Monitor
Requires=cve-monitor.service

[Timer]
OnCalendar=daily
OnCalendar=09:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

    systemctl --user daemon-reload
    systemctl --user enable cve-monitor.timer
    systemctl --user start cve-monitor.timer

    echo "✓ Systemd timer installed and started"
    echo "  Status: systemctl --user status cve-monitor.timer"
    echo "  Logs: journalctl --user -u cve-monitor"
}

# Function to configure NVD API key
setup_api_key() {
    echo
    echo "NVD API Key Setup"
    echo "-----------------"
    echo "An API key is recommended for better rate limits:"
    echo "  Without key: 5 requests per 30 seconds"
    echo "  With key: 50 requests per 30 seconds"
    echo
    echo "Get a free key at: https://nvd.nist.gov/developers/request-an-api-key"
    echo
    read -p "Do you have an NVD API key? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        read -p "Enter your API key: " api_key
        "$CVE_MONITOR" --api-key "$api_key"
        echo "✓ API key configured"
    else
        echo "ℹ You can add it later with: cve-monitor --api-key YOUR_KEY"
    fi
}

# Function to configure notifications
setup_notifications() {
    echo
    echo "Notification Setup"
    echo "-----------------"

    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        echo "For macOS notifications, we can use osascript"
        read -p "Enable macOS notifications? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # Create wrapper script for notifications
            NOTIFY_SCRIPT="$HOME/.config/cve-monitor/notify.sh"
            mkdir -p "$(dirname "$NOTIFY_SCRIPT")"

            cat > "$NOTIFY_SCRIPT" << 'EOF'
#!/bin/bash
osascript -e "display notification \"$2\" with title \"$1\""
EOF
            chmod +x "$NOTIFY_SCRIPT"

            # Update config
            python3 << PYEOF
import json
from pathlib import Path

config_file = Path.home() / '.config/cve-monitor/config.json'
if config_file.exists():
    with open(config_file, 'r') as f:
        config = json.load(f)
    config['notify_command'] = str(Path.home() / '.config/cve-monitor/notify.sh')
    with open(config_file, 'w') as f:
        json.dump(config, f, indent=2)
PYEOF
            echo "✓ macOS notifications enabled"
        fi
    elif command -v notify-send &> /dev/null; then
        # Linux with notify-send
        echo "Detected notify-send for desktop notifications"
        read -p "Enable desktop notifications? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            python3 << PYEOF
import json
from pathlib import Path

config_file = Path.home() / '.config/cve-monitor/config.json'
if config_file.exists():
    with open(config_file, 'r') as f:
        config = json.load(f)
    config['notify_command'] = 'notify-send'
    with open(config_file, 'w') as f:
        json.dump(config, f, indent=2)
PYEOF
            echo "✓ Desktop notifications enabled"
        fi
    else
        echo "ℹ No notification system detected"
        echo "You can manually configure notify_command in config.json"
    fi
}

# Function to test the setup
test_monitor() {
    echo
    echo "Testing CVE Monitor..."
    echo "====================="
    echo "Running a quick test (last 3 days, CRITICAL/HIGH only)..."
    echo
    "$CVE_MONITOR" --days 3 --severity CRITICAL HIGH
    echo
    echo "✓ Test complete"
}

# Main menu
main() {
    echo "What would you like to configure?"
    echo
    echo "1) Configure NVD API key"
    echo "2) Setup automated monitoring"
    echo "3) Configure notifications"
    echo "4) Test CVE monitor"
    echo "5) Full setup (all of the above)"
    echo "6) Exit"
    echo
    read -p "Select option (1-6): " -n 1 -r option
    echo

    case $option in
        1)
            setup_api_key
            ;;
        2)
            if [[ "$OSTYPE" == "darwin"* ]]; then
                setup_macos_launchd
            elif systemctl --user &> /dev/null; then
                setup_systemd
            else
                setup_cron
            fi
            ;;
        3)
            setup_notifications
            ;;
        4)
            test_monitor
            ;;
        5)
            setup_api_key
            if [[ "$OSTYPE" == "darwin"* ]]; then
                setup_macos_launchd
            elif systemctl --user &> /dev/null; then
                setup_systemd
            else
                setup_cron
            fi
            setup_notifications
            test_monitor
            ;;
        6)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option"
            exit 1
            ;;
    esac

    echo
    echo "Setup complete!"
    echo
    echo "Next steps:"
    echo "  - Run manually: $CVE_MONITOR"
    echo "  - View config: $CVE_MONITOR --config-show"
    echo "  - Edit config: $CVE_MONITOR --config-edit"
    echo "  - View documentation: cat $SCRIPT_DIR/README.md"
}

# Run main
main
