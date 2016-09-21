composer=docker-compose

start: remove
	@$(composer) up -d
	@docker network connect bridge michel

remove: stop
	@$(composer) rm -f

stop:
	@$(composer) stop

install: remove start
