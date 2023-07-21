set -g fish_user_paths "/usr/local/opt/postgresql@11/bin" $fish_user_paths
fish_add_path /usr/local/sbin
fish_add_path '/Applications/Visual Studio Code.app/Contents/Resources/app/bin'
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/t0d0r/work/google-cloud-sdk/path.fish.inc' ]; . '/Users/t0d0r/work/google-cloud-sdk/path.fish.inc'; end
