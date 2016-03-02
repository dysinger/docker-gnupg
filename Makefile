gnupg.tar:
	@docker ps --no-trunc -aq | xargs docker rm || true
	@docker images -f "dangling=true" -q | xargs docker rmi || true
	@docker build -t gnupg .
	@docker run --detach=true --name=gnupg gnupg sleep 10
	@docker cp gnupg:/gnupg.tar .
	@docker kill gnupg
	@docker rm gnupg
