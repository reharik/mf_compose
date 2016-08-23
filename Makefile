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

clone-eventDispatcher:
	git clone git@github.com:reharik/core_eventDispatcher.git ../core_eventDispatcher

clone-eventHandlerBase:
	git clone git@github.com:reharik/core_eventHandlerBase.git ../core_eventHandlerBase

clone-eventRepository:
	git clone git@github.com:reharik/core_eventRepository.git ../core_eventRepository

clone-eventStore:
	git clone git@github.com:reharik/core_eventStore.git ../core_eventStore

clone-logger:
	git clone git@github.com:reharik/core_logger.git ../core_logger

clone-applicationFunctions:
	git clone git@github.com:reharik/core_applicationFunctions.git ../core_applicationFunctions

clone-readstoreRepository:
	git clone git@github.com:reharik/core_readstoreRepository.git ../core_readstoreRepository

clone-all: clone-frontend clone-workflows clone-projections clone-api clone-data clone-messagebinders clone-domain

##################
#build
##################

docker-build-node:
	docker build -t mf_node -f nodeDocker/Dockerfile ./nodeDocker

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

kill-eventstore:
	docker rm -vf eventstore 2>/dev/null || echo "No more containers to remove."
	docker rmi eventstore/eventstore

kill-postgres:
	docker rm -vf postgres 2>/dev/null || echo "No more containers to remove."
	docker rmi postgres

kill-orphans:
	docker rmi -f $$(docker images | grep "<none>" | awk "{print \$$3}")

kill-all-data: kill-eventstore kill-postgres

##################
#run
##################

run:	docker-build-workflows docker-build-projections docker-build-api docker-build-data
	docker-compose -f docker/docker-compose.yml up

run-moodle:	docker-build-moodle
	docker-compose -f docker/docker-compose-moodle.yml up

##################
#Other Docker Helpers
##################

exec:
	docker exec -it $(con) bash


#.PHONY: clean install docker-build run docker-clean docker-exec