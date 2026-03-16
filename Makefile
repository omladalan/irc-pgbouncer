IMAGE_NAME?=omladalan/irc-pgbouncer
IMAGE_VERSION?=latest

docker-x86:
	docker build \
		-t $(IMAGE_NAME):$(IMAGE_VERSION) \
		-f ./Dockerfile \
		.

push: 
	docker push $(IMAGE_NAME):$(IMAGE_VERSION)