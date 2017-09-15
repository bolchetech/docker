config:
	docker-compose config
build-prod:
	@echo "build prod\n-------------------------------" 
	docker-compose -f docker-compose.yml config && \
	docker-compose -f docker-compose.yml build
build: build-prod
	@make status
status:
	@echo "Status\n-------------------------------" 
	docker images bolchetech/*
.DEFAULT_GOAL := build
