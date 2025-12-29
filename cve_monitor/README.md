# CVE Security Monitoring Agent

Monitors and reports recent CVE releases affecting Linux services using the National Vulnerability Database (NVD) API.

## Features

- Real-time CVE monitoring from NVD API v2.0
- Monitors 60+ Linux services (kernel, systemd, nginx, docker, postgresql, mongodb, etc.)
- Severity filtering (CRITICAL, HIGH, MEDIUM, LOW)
- Smart caching (6-hour default)
- JSON or human-readable output
- Notification support (macOS/Linux)

## Quick Start

```bash
cd ~/work/github/dotmatrix/cve_monitor

# Interactive setup
./setup.sh

# Or run directly
./cve-monitor                          # Last 7 days
./cve-monitor --days 30                # Last 30 days
./cve-monitor -s CRITICAL HIGH         # High severity only
./cve-monitor --json                   # JSON output
./cve-monitor --refresh                # Force refresh cache
```

## Installation

```bash
# Make executable
chmod +x ~/work/github/dotmatrix/cve_monitor/cve-monitor

# Optional: Add to PATH
export PATH="$HOME/work/github/dotmatrix/cve_monitor:$PATH"

# Or symlink to ~/bin
ln -s ~/work/github/dotmatrix/cve_monitor/cve-monitor ~/bin/cve-monitor
```

## Configuration

Config stored in `~/.config/cve-monitor/config.json`

```bash
cve-monitor --config-show    # View config
cve-monitor --config-edit    # Edit config
```

### Key Settings

```json
{
  "api_key": null,                   // NVD API key (recommended)
  "days_back": 7,                    // Days to look back
  "severity_filter": ["CRITICAL", "HIGH", "MEDIUM", "LOW"],
  "linux_keywords": [...],           // Services to monitor
  "max_results": 2000,               // Max CVEs to fetch
  "cache_duration_hours": 6,         // Cache duration
  "notify_command": null             // Notification command
}
```

**Important:** Get a free NVD API key at https://nvd.nist.gov/developers/request-an-api-key
- Without key: 5 requests/30 sec
- With key: 50 requests/30 sec

Set API key:
```bash
cve-monitor --api-key "your-key-here"
```

## Monitored Services

**Core:** Linux kernel, systemd, glibc, bash, sudo, polkit, PAM, SELinux, AppArmor
**Web:** Apache, Nginx
**Databases:** PostgreSQL, MySQL, MariaDB, MongoDB, Redis
**Containers:** Docker, Kubernetes, containerd
**Security:** OpenSSH, OpenSSL, GnuTLS, Kerberos
**Mail:** Postfix, Dovecot
**File:** Samba, NFS
**Logging:** rsyslog, journald
**Desktop:** GNOME, KDE, Xorg, Wayland
**Dev:** Git, Vim, Emacs

See full list in `config.json` or `config.example.json`

## Usage Examples

### Basic Usage

```bash
# Check last 7 days (default)
./cve-monitor

# Check specific time ranges
./cve-monitor --days 1      # Yesterday's CVEs
./cve-monitor --days 15     # Last 2 weeks
./cve-monitor --days 30     # Last month

# Filter by severity
./cve-monitor -s CRITICAL                    # Critical only
./cve-monitor -s CRITICAL HIGH               # Critical and High
./cve-monitor -s HIGH MEDIUM LOW             # Exclude Critical

# Force fresh data (bypass cache)
./cve-monitor --refresh

# Combine options
./cve-monitor --refresh --days 10 -s CRITICAL HIGH
```

### Daily Security Monitoring

```bash
# Morning security check - critical/high from yesterday
./cve-monitor --days 1 -s CRITICAL HIGH

# Weekly security review
./cve-monitor --days 7 -s CRITICAL HIGH > weekly_report.txt
```

### Automation & Scheduling

```bash
# Crontab - daily at 9 AM
0 9 * * * cd ~/work/github/dotmatrix/cve_monitor && ./cve-monitor -s CRITICAL HIGH

# Save to log file
0 9 * * * cd ~/work/github/dotmatrix/cve_monitor && ./cve-monitor --json > ~/logs/cve-$(date +\%Y\%m\%d).json

# Email critical/high CVEs
0 9 * * * cd ~/work/github/dotmatrix/cve_monitor && ./cve-monitor -s CRITICAL HIGH | mail -s "Daily CVE Report" security@example.com
```

### Monitoring Specific Services

```bash
# Edit config to monitor only your stack
./cve-monitor --config-edit

# Example config for web stack:
{
  "linux_keywords": [
    "nginx", "apache", "postgresql", "redis",
    "docker", "kubernetes", "linux", "kernel", "openssl"
  ]
}

# Example config for database servers:
{
  "linux_keywords": [
    "postgresql", "mysql", "mariadb", "mongodb", "redis",
    "linux", "kernel", "systemd", "openssh"
  ]
}
```

### JSON Output for Scripting

```bash
# Get JSON output
./cve-monitor --json -s CRITICAL HIGH

# Count critical CVEs
./cve-monitor --json -s CRITICAL | python3 -c "import json,sys; print(len(json.load(sys.stdin)))"

# Extract CVE IDs only
./cve-monitor --json | python3 -c "import json,sys; print('\n'.join([c['cve_id'] for c in json.load(sys.stdin)]))"

# Filter for specific service (e.g., MongoDB)
./cve-monitor --json | python3 -c "import json,sys; [print(c['cve_id'], c['description'][:100]) for c in json.load(sys.stdin) if 'mongodb' in c['description'].lower()]"
```

### Real-World Scenarios

```bash
# Scenario 1: New server deployment - check last 30 days for your stack
./cve-monitor --days 30 -s CRITICAL HIGH

# Scenario 2: Security audit - comprehensive report
./cve-monitor --refresh --days 90 > security_audit_$(date +%Y%m%d).txt

# Scenario 3: Emergency response - check if specific CVE affects you
./cve-monitor --days 30 | grep -i "CVE-2025-14847"

# Scenario 4: Daily standup - quick critical check
./cve-monitor --days 1 -s CRITICAL

# Scenario 5: Weekly team report with counts
echo "CVE Report for week of $(date)"
echo "Critical: $(./cve-monitor --days 7 -s CRITICAL --json | python3 -c 'import json,sys; print(len(json.load(sys.stdin)))')"
echo "High: $(./cve-monitor --days 7 -s HIGH --json | python3 -c 'import json,sys; print(len(json.load(sys.stdin)))')"
```

## Output Formats

**Human-readable (default):**
```
[CRITICAL] CVE-2025-1234 - CVSS: 9.8
  Published: 2025-12-28T10:30:00.000
  Description: Critical vulnerability in OpenSSH...
  References:
    - https://nvd.nist.gov/vuln/detail/CVE-2025-1234
```

**JSON:**
```bash
cve-monitor --json
```

## Performance

- **API rate limits:** ~6 sec/request without key, faster with key
- **Fetching 2000 CVEs:** Several minutes without API key
- **Cache:** Instant for queries within 6 hours
- **Best practices:**
  - Use API key for production
  - Daily checks: `--days 1-2`
  - Weekly reviews: `--days 7`
  - Use `--refresh` only when needed

## Troubleshooting

**Rate limiting (HTTP 429):**
```bash
cve-monitor --api-key "your-key"
```

**No CVEs found:**
- Check `severity_filter` in config
- Increase `days_back`
- Use `--refresh` to bypass cache
- Verify `linux_keywords` match your services

**Clear cache:**
```bash
rm -rf ~/.config/cve-monitor/cache/
cve-monitor --refresh
```

## Integration Examples

**Slack/Discord:**
```bash
#!/bin/bash
CVES=$(cve-monitor --json -s CRITICAL HIGH)
[ -n "$CVES" ] && curl -X POST -H 'Content-type: application/json' \
  --data "{\"text\":\"New CVEs: $CVES\"}" YOUR_WEBHOOK_URL
```

**Email:**
```bash
cve-monitor --days 7 | mail -s "Weekly CVE Report" security@example.com
```

**Desktop notifications (Linux):**
```json
{"notify_command": "notify-send"}
```

**macOS notifications:**
```json
{"notify_command": "osascript -e 'display notification \"CVE Alert\" with title \"Security\"'"}
```

## Data Source

- NVD API v2.0: https://nvd.nist.gov/
- API Docs: https://nvd.nist.gov/developers/vulnerabilities
- Free API key: https://nvd.nist.gov/developers/request-an-api-key

## Limitations

- Requires NVD API availability
- CVE publication may be delayed
- Keyword matching may miss some CVEs
- Rate limits without API key
