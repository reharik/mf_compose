#IMAGENAME=sls_course_builder_api
#CONTAINERNAME=sls_course_builder_api

##################
#clone
##################

clone-frontend:
	git clone git@github.com:reharik/mf_frontend.git ../mf_frontend

clone-workflows:
	git clone git@github.com:reharik/mf_workflows.git ../mf_workflows

clone-projections:
	git clone git@github.com:reharik/mf_projections.git ../mf_projections

clone-api:
	git clone git@github.com:reharik/mf_api.git ../mf_api

clone-data:
	git clone git@github.com:reharik/mf_data.git ../mf_data

clone-messagebinders:
	git clone git@github.com:reharik/mf_messagebinders.git ../mf_messagebinders

clone-domain:
	git clone git@github.com:reharik/mf_domain.git ../mf_domain

clone-ges-eventsourcing:
	git clone git@github.com:reharik/ges-eventsourcing.git ../ges-eventsourcing


clone-all: clone-frontend clone-workflows clone-projections clone-api clone-data clone-messagebinders clone-domain clone-ges-eventsourcing

##################
#build
##################

docker-build-node:
	docker build -t mf_node -f nodeDocker/Dockerfile ./nodeDocker

docker-build-front-end:	docker-build-node
	cd ../mf_frontend && $(MAKE) docker-build
	cd ../mf_compose

docker-build-workflows:	docker-build-node
	cd ../mf_workflows && $(MAKE) docker-build
	cd ../mf_compose

docker-build-projections:	docker-build-node
	cd ../mf_projections && $(MAKE) docker-build
	cd ../mf_compose

docker-build-api:	docker-build-node
	cd ../mf_api && $(MAKE) docker-build
	cd ../mf_compose

docker-build-data:	docker-build-node
	cd ../mf_data && $(MAKE) docker-build
	cd ../mf_compose

docker-build-nginx:	docker-build-api docker-build-front-end
	pwd
	docker build -t mf_nginx_proxy -f docker/Dockerfile .

##################
#kill
##################

kill-all:
	docker rm -vf $$(docker ps -a -q) 2>/dev/null || echo "No more containers to remove."
	docker rmi $$(docker images -a -q) || echo "No more containers to remove."

kill-all-but-bases:
	docker rm -vf $$(docker ps -a -q) 2>/dev/null || echo "No more containers to remove."
	docker rmi $$(docker images | grep -v -e ^mf -e ^nginx_container -e ^richarvey -e ^postgres -e ^mf_swagger_ui | awk '{print $3}' | sed -n '1!p') 2>/dev/null || echo "No more containers to remove."

kill-all-but-node:
	docker rm -vf $$(docker ps -a -q) 2>/dev/null || echo "No more containers to remove."
	docker rmi $$(docker images | grep -v -e ^mf_node | awk '{print $3}' | sed -n '1!p') 2>/dev/null || echo "No more containers to remove."

kill-workflows:
	docker rm -vf mf_workflows 2>/dev/null || echo "No more containers to remove."
	docker rmi workflows/dispatcher

kill-api:
	docker rm -vf mf_api 2>/dev/null || echo "No more containers to remove."
	docker rmi api

kill-eventstore:
	docker rm -vf eventstore 2>/dev/null || echo "No more containers to remove."
	docker rmi eventstore/eventstore

kill-postgres:
	docker rm -vf postgres 2>/dev/null || echo "No more containers to remove."
	docker rmi postgres

kill-front-end:
	docker rm -vf mf_frontend 2>/dev/null || echo "No more containers to remove."
	docker rmi mf_frontend

kill-orphans:
	docker rmi -f $$(docker images | grep "<none>" | awk "{print \$$3}")

kill-all-data: kill-eventstore kill-postgres

##################
#run
##################

run:	docker-build-workflows docker-build-projections docker-build-api docker-build-data docker-build-workflows docker-build-front-end
	docker-compose -f docker/docker-compose.yml up

run-no-data:	docker-build-workflows docker-build-projections docker-build-api
	docker-compose -f docker/docker-compose-no-data.yml up

run-api:	docker-build-api
	cd ../mf_api && docker-compose -f docker/docker-compose.yml up
	cd ../mf_compose

##################
#Other Docker Helpers
##################

exec:
	docker exec -it $(con) bash

##################
#GIT Helpers
##################

get-statuses:
	@echo ================COMPOSE==================
	@git fetch origin && git status
	@echo ================FRONTEND==================
	@cd ../mf_frontend && git fetch origin &&  git status
	@cd ../mf_compose
	@echo ================WORKFLOW==================
	@cd ../mf_workflows && git fetch origin && git status
	@cd ../mf_compose
	@echo ================PROJECTIONS==================
	@cd ../mf_projections && git fetch origin && git status
	@cd ../mf_compose
	@echo ================API==================
	@cd ../mf_api && git fetch origin && git status
	@cd ../mf_compose
	@echo ================DATA==================
	@cd ../mf_data && git fetch origin && git status
	@cd ../mf_compose
	@echo ================MESSAGEBINDERS==================
	@cd ../mf_messagebinders && git fetch origin && git status
	@cd ../mf_compose
	@echo ================DOMAIN==================
	@cd ../mf_domain && git fetch origin && git status
	@cd ../mf_compose
	@echo ================GES-EVENTSOURCING==================
	@cd ../ges-eventsourcing && git fetch origin && git status
	@cd ../mf_compose

pull-repos:
	@echo ================COMPOSE==================
	@git pull origin master
	@echo ================FRONTEND==================
	@cd ../mf_frontend && git pull origin master
	@cd ../mf_compose
	@echo ================WORKFLOW==================
	@cd ../mf_workflows && git pull origin master
	@cd ../mf_compose
	@echo ================PROJECTIONS==================
	@cd ../mf_projections && git pull origin master
	@cd ../mf_compose
	@echo ================API==================
	@cd ../mf_api && git pull origin master
	@cd ../mf_compose
	@echo ================DATA==================
	@cd ../mf_data && git pull origin master
	@cd ../mf_compose
	@echo ================MESSAGEBINDERS==================
	@cd ../mf_messagebinders && git pull origin master
	@cd ../mf_compose
	@echo ================DOMAIN==================
	@cd ../mf_domain && git pull origin master
	@cd ../mf_compose
	@echo ================GES-EVENTSOURCING==================
	@cd ../ges-eventsourcing && git pull origin master
	@cd ../mf_compose



#.PHONY: clean install docker-build run docker-clean docker-exec
