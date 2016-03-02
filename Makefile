gnupg.tar:
	@docker build -t gnupg .
	@(docker rm gnupg || true) >/dev/null 2>&1
	@docker run --name gnupg --detach=true --name=gnupg gnupg sleep 10
	@docker cp gnupg:/gnupg.tar .
	@docker kill gnupg
	@(docker rm gnupg || true) >/dev/null 2>&1
