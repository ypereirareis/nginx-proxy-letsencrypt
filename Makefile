composer=docker-compose


build:
	@echo $(bin)
	@$(composer) build

state:
	@$(composer) ps

start: remove
	@$(composer) up -d
	@docker network connect bridge michel || true

remove: stop
	@$(composer) rm -f

stop:
	@$(composer) stop

install: remove build start
