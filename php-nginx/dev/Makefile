config:
	docker-compose config
build-dev:
	@echo "build dev\n-------------------------------" 
	bash -c " \
	source .envrc && \
	docker-compose -f docker-compose.yml config && \
	docker-compose -f docker-compose.yml build"
build: build-dev
	@make status
status:
	@echo "Status\n-------------------------------" 
	docker images bolchetech/*
.DEFAULT_GOAL := build
