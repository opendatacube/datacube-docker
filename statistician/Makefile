.PHONY: test dkr

NAME          := opendatacube/datacube-statistician
TAG           := $$(cat version.txt)
VCS_REF       := $$(git describe --tags --always)
IMG           := ${NAME}:${TAG}
LATEST        := ${NAME}:latest
BUILD_DATE    := $$(date -u +'%Y-%m-%dT%H:%M:%SZ')
STATS_VERSION := $$(awk '/odc-stats/ {split($$0,a,"=="); print a[2]}' requirements.txt)

dkr:
	@docker build -t ${IMG} --build-arg BUILD_DATE=${BUILD_DATE} --build-arg VCS_REF=${VCS_REF} --build-arg STATS_VERSION=${STATS_VERSION} .
#	@docker tag ${IMG} ${LATEST}

test:
	./test_statistician.sh
