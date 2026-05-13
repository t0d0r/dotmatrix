function opencode
	docker run --rm -it \
		-v "$PWD:/workspace" \
		-w /workspace \
		-v "$HOME/.config/opencode:/home/opencode/.config/opencode" \
		-v "$HOME/.local/share/opencode:/home/opencode/.local/share/opencode" \
		-e HOST_PWD=$(pwd) \
		ghcr.io/anomalyco/opencode:latest $argv
end
