config:
	docker-compose config
build:
	@echo "build\n-------------------------------" 
	docker-compose -f docker-compose.yml config
	sleep 2
	docker-compose -f docker-compose.yml build
	@make status
status:
	@echo "Status\n-------------------------------" 
	docker images bolchetech/*
.DEFAULT_GOAL := build
