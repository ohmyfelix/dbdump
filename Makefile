DOCKER_IMAGE=dockette/dbdump
VERSION?=mariadb-11-8
DOCKER_TAG?=${VERSION}
VERSIONS=mariadb-10-2 mariadb-10-4 mariadb-10-6 mariadb-10-11 mariadb-11-1 mariadb-11-2 mariadb-11-4 mariadb-11-5 mariadb-11-7 mariadb-11-8

.PHONY: build test run build-all test-all ${VERSIONS}

build:
	docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ${VERSION}/

test:
	docker run --rm ${DOCKER_IMAGE}:${DOCKER_TAG} mysqldump --version
	docker run --rm ${DOCKER_IMAGE}:${DOCKER_TAG} mariadb-dump --version
	docker run --rm ${DOCKER_IMAGE}:${DOCKER_TAG} mariadb --version

run:
	docker run --rm -it ${DOCKER_IMAGE}:${DOCKER_TAG}

build-all:
	for version in ${VERSIONS}; do ${MAKE} VERSION=$$version DOCKER_TAG=$$version build; done

test-all:
	for version in ${VERSIONS}; do ${MAKE} VERSION=$$version DOCKER_TAG=$$version test; done

${VERSIONS}:
	${MAKE} VERSION=$@ DOCKER_TAG=$@ build test
