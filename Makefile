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

clone-ges-eventsourcing:
	git clone git@github.com:reharik/ges-eventsourcing.git ../ges-eventsourcing


clone-all: clone-frontend clone-workflows clone-projections clone-api clone-data clone-ges-eventsourcing

##################
#build
##################

docker-build-nginx:	docker-build-api docker-build-front-end
	pwd
	docker build -t mf_nginx_proxy -f docker/Dockerfile .

##################
#kill
##################
kill-all-but-node:
	- docker rm -vf $$(docker ps -a -q) 2>/dev/null || echo "No more containers to remove."
	- docker rmi $$(docker images | grep -v -e ^mf_node | awk '{print $3}' | sed -n '1!p') 2>/dev/null || echo "No more containers to remove."
	- docker rmi -f $$(docker images | grep "<none>" | awk "{print \$$3}")
	- docker volume rm docker_eventstore

kill-workflows:  kill-orphans
	- docker rm -vf mf_workflows 2>/dev/null || echo "No more containers to remove."
	- docker rmi mf_workflows

kill-data:  kill-orphans
	- docker rm -vf mf_data 2>/dev/null || echo "No more containers to remove."
	- docker rmi mf_data

kill-projections:  kill-orphans
	- docker rm -vf mf_projections 2>/dev/null || echo "No more containers to remove."
	- docker rmi mf_projections

kill-api:  kill-orphans
	- docker rm -vf mf_api 2>/dev/null || echo "No more containers to remove."
	- docker rmi mf_api

kill-eventstore:  kill-orphans
	- docker rm -vf eventstore 2>/dev/null || echo "No more containers to remove."
	- docker rmi eventstore/eventstore
	- docker volume rm docker_eventstore

kill-postgres:  kill-orphans
	- docker rm -vf postgres 2>/dev/null || echo "No more containers to remove."
	- docker rmi postgres
	- docker volume rm docker_postgres_data

kill-front-end:  kill-orphans
	- docker rm -vf mf_frontend 2>/dev/null || echo "No more containers to remove."
	- docker rmi mf_frontend

kill-orphans:
	- docker rmi -f $$(docker images | grep "<none>" | awk "{print \$$3}")

down:
	docker-compose -f docker/docker-compose.yml -p methodfit down

down-local:
	docker-compose -f docker/docker-compose.yml -p methodfit down --rmi local --remove-orphans

down-data:
	docker-compose -f docker/docker-compose-data.yml -p methodfit down

down-data-local:
	docker-compose -f docker/docker-compose-data.yml -p methodfit down --rmi local --remove-orphans -v

##################
#run
##################

run:
	docker-compose -f docker/docker-compose.yml -p methodfit up

run-data:
	docker-compose -f docker/docker-compose-data.yml -p methodfit up

#run-vmmax
#	sudo sysctl -w vm.max_map_count=262144


run-seed:	docker-build-data
	docker-compose -f docker/docker-compose-seed.yml up

run-logging:
	docker-compose -f docker/docker-compose-logging.yml up

run-swagger:
	docker-compose -f docker/docker-compose-swagger-ui.yml up

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
	@echo ================GES-EVENTSOURCING==================
	@cd ../ges-eventsourcing && git pull origin master
	@cd ../mf_compose



#.PHONY: clean install docker-build run docker-clean docker-exec
