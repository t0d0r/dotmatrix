# Offline regression test for cve_monitor (called from tests/security/run.sh).
# Usage: HOME=<scratch dir> python3 test_cve_monitor.py <path to cve-monitor>
import importlib.machinery, importlib.util, os, stat, sys, io, contextlib
loader = importlib.machinery.SourceFileLoader('cvem', sys.argv[1])
spec = importlib.util.spec_from_loader('cvem', loader); m = importlib.util.module_from_spec(spec); loader.exec_module(m)

def vuln(i, sev='HIGH', desc='linux kernel bug'):
    return {'cve': {'id': f'CVE-X-{i}', 'descriptions': [{'value': desc}],
            'metrics': {'cvssMetricV31': [{'cvssData': {'baseSeverity': sev, 'baseScore': 7.5}}]},
            'references': [{'url': 'https://e.x/\x1b]0;evil\x07', 'source': 's'}]}}
pages = [[vuln(i) for i in range(2)], [vuln(2, 'MEDIUM', 'linux \x1b[2Jclear')]]
calls = []
def fake(self, params):
    calls.append(params); i = params['startIndex']
    return {'totalResults': 3, 'vulnerabilities': pages[0] if i == 0 else pages[1]}
m.CVEMonitor._make_nvd_request = fake
mon = m.CVEMonitor()
assert stat.S_IMODE(os.stat(mon.config_path).st_mode) == 0o600, 'config not 0600'
mon.config['notify_command'] = None
mon.config['severity_filter'] = ['CRITICAL', 'HIGH']
out = io.StringIO()
with contextlib.redirect_stdout(out): r = mon.monitor(days_back=7, force_refresh=True)
assert len(calls) == 2, 'pagination'
assert len(r) == 2
assert '\x1b' not in out.getvalue() .replace('\033[0;31m','').replace('\033[0m',''), 'escape leaked'
# cache must still hold MEDIUM so a broader later run is correct
mon.config['severity_filter'] = ['CRITICAL', 'HIGH', 'MEDIUM']
with contextlib.redirect_stdout(io.StringIO()): r = mon.monitor(days_back=7)
assert len(calls) == 2 and len(r) == 3, 'cache severity'
# different window -> refetch
with contextlib.redirect_stdout(io.StringIO()): mon.monitor(days_back=14)
assert len(calls) == 4, 'cache window'
# fail loudly
def boom(self, p): raise m.NVDError('HTTP 503')
m.CVEMonitor._make_nvd_request = boom
try:
    with contextlib.redirect_stdout(io.StringIO()): mon.monitor(days_back=3, force_refresh=True)
    raise SystemExit('should have raised')
except m.NVDError: pass
try: mon.fetch_recent_cves(365); raise SystemExit('range')
except m.NVDError: pass
print('cve-monitor tests passed')
