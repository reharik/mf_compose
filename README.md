### Getting Started
Assuming that the repos have not been clone.
If they have been cloned make sure `sls_frontend` is on branch `sls_dev` then skip to step 2.

#### 1) Clone
    make clone-repos

#### 2) Make it run
    make run
      ...
      (build and download)
      ...
    localhost:10080


### Overview

SLS Compose is an orchestration script that builds docker containers for `sls_frontend`
and `sls_course_builder_api`. It downloads all the necessary dependancies per container and severs
the app via `nginx`.


### Make commands

Being an orchestration script the `Makefile` contains commands that help manage the lifecycle of
the application. The following commands are made accessible:

##### Build App
  * `run`

##### Clone Repos
  * `clone-course-builder`
  * `clone-front-end`
  * `clone-repos` (clones ALL repos)

##### Build Containers
* `docker-build-node`
* `docker-build-course-builder`
* `docker-build-front-end`
* `docker-build-nginx`

##### Remove ALL containers and images
  * `kill-all`

##### Remove SELECT containers and images
  * `kill-all-but-bases`
  * `kill-all-but-node`
  * `kill-nginx`
  * `kill-course-builder`
  * `kill-front-end`

##### exec into a container
  * `exec con=[mycontainer]`
