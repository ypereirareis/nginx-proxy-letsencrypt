composer=docker-compose -f docker-compose-$(PROJECT_ENV).yml

start: remove
	@$(composer) up -d
	@docker network connect bridge michel || true

remove: stop
	@$(composer) rm -f

stop:
	@$(composer) stop

install: remove start
