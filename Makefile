NAME := $(or $(NAME),$(NAME),gsfraley)
VERSION := $(or $(VERSION),$(VERSION),3.141.59-dubnium)
NAMESPACE := $(or $(NAMESPACE),$(NAMESPACE),$(NAME))
AUTHORS := $(or $(AUTHORS),$(AUTHORS),gsfraley)
PLATFORM := $(shell uname -s)
BUILD_ARGS := $(BUILD_ARGS)
MAJOR := $(word 1,$(subst ., ,$(VERSION)))
MINOR := $(word 2,$(subst ., ,$(VERSION)))
MAJOR_MINOR_PATCH := $(word 1,$(subst -, ,$(VERSION)))

all: hub chromium firefox

generate_all:	\
	generate_hub \
	generate_nodebase \
	generate_chromium \
	generate_firefox

build: all

ci: build test

base:
	cd ./Base && docker build $(BUILD_ARGS) -t $(NAME)/rpi-sel-base:$(VERSION) .

generate_hub:
	cd ./Hub && ./generate.sh $(VERSION) $(NAMESPACE) $(AUTHORS)

hub: base generate_hub
	cd ./Hub && docker build $(BUILD_ARGS) -t $(NAME)/rpi-sel-hub:$(VERSION) .

generate_nodebase:
	cd ./NodeBase && ./generate.sh $(VERSION) $(NAMESPACE) $(AUTHORS)

nodebase: base generate_nodebase
	cd ./NodeBase && docker build $(BUILD_ARGS) -t $(NAME)/rpi-sel-node-base:$(VERSION) .

generate_chromium:
	cd ./NodeChromium && ./generate.sh $(VERSION) $(NAMESPACE) $(AUTHORS)

chromium: nodebase generate_chromium
	cd ./NodeChromium && docker build $(BUILD_ARGS) -t $(NAME)/rpi-sel-node-chromium:$(VERSION) .

generate_firefox:
	cd ./NodeFirefox && ./generate.sh $(VERSION) $(NAMESPACE) $(AUTHORS)

firefox: nodebase generate_firefox
	cd ./NodeFirefox && docker build $(BUILD_ARGS) -t $(NAME)/rpi-sel-node-firefox:$(VERSION) .

tag_latest:
	docker tag $(NAME)/rpi-sel-base:$(VERSION) $(NAME)/rpi-sel-base:latest
	docker tag $(NAME)/rpi-sel-hub:$(VERSION) $(NAME)/rpi-sel-hub:latest
	docker tag $(NAME)/rpi-sel-node-base:$(VERSION) $(NAME)/rpi-sel-node-base:latest
	docker tag $(NAME)/rpi-sel-node-chromium:$(VERSION) $(NAME)/rpi-sel-node-chromium:latest
	docker tag $(NAME)/rpi-sel-node-firefox:$(VERSION) $(NAME)/rpi-sel-node-firefox:latest

release_latest:
	docker push $(NAME)/rpi-sel-base:latest
	docker push $(NAME)/rpi-sel-hub:latest
	docker push $(NAME)/rpi-sel-node-base:latest
	docker push $(NAME)/rpi-sel-node-chromium:latest
	docker push $(NAME)/rpi-sel-node-firefox:latest

tag_major_minor:
	docker tag $(NAME)/rpi-sel-base:$(VERSION) $(NAME)/rpi-sel-base:$(MAJOR)
	docker tag $(NAME)/rpi-sel-hub:$(VERSION) $(NAME)/rpi-sel-hub:$(MAJOR)
	docker tag $(NAME)/rpi-sel-node-base:$(VERSION) $(NAME)/rpi-sel-node-base:$(MAJOR)
	docker tag $(NAME)/rpi-sel-node-chromium:$(VERSION) $(NAME)/rpi-sel-node-chromium:$(MAJOR)
	docker tag $(NAME)/rpi-sel-node-firefox:$(VERSION) $(NAME)/rpi-sel-node-firefox:$(MAJOR)
	docker tag $(NAME)/rpi-sel-base:$(VERSION) $(NAME)/rpi-sel-base:$(MAJOR).$(MINOR)
	docker tag $(NAME)/rpi-sel-hub:$(VERSION) $(NAME)/rpi-sel-hub:$(MAJOR).$(MINOR)
	docker tag $(NAME)/rpi-sel-node-base:$(VERSION) $(NAME)/rpi-sel-node-base:$(MAJOR).$(MINOR)
	docker tag $(NAME)/rpi-sel-node-chromium:$(VERSION) $(NAME)/rpi-sel-node-chromium:$(MAJOR).$(MINOR)
	docker tag $(NAME)/rpi-sel-node-firefox:$(VERSION) $(NAME)/rpi-sel-node-firefox:$(MAJOR).$(MINOR)
	docker tag $(NAME)/rpi-sel-base:$(VERSION) $(NAME)/rpi-sel-base:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/rpi-sel-hub:$(VERSION) $(NAME)/rpi-sel-hub:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/rpi-sel-node-base:$(VERSION) $(NAME)/rpi-sel-node-base:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/rpi-sel-node-chromium:$(VERSION) $(NAME)/rpi-sel-node-chromium:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/rpi-sel-node-firefox:$(VERSION) $(NAME)/rpi-sel-node-firefox:$(MAJOR_MINOR_PATCH)

release: tag_major_minor
	@if ! docker images $(NAME)/rpi-sel-base | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/rpi-sel-base version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/rpi-sel-hub | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/rpi-sel-hub version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/rpi-sel-node-base | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/rpi-sel-node-base version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/rpi-sel-node-chromium | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/rpi-sel-node-chromium version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/rpi-sel-node-firefox | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/rpi-sel-node-firefox version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker push $(NAME)/rpi-sel-base:$(VERSION)
	docker push $(NAME)/rpi-sel-hub:$(VERSION)
	docker push $(NAME)/rpi-sel-node-base:$(VERSION)
	docker push $(NAME)/rpi-sel-node-chromium:$(VERSION)
	docker push $(NAME)/rpi-sel-node-firefox:$(VERSION)
	docker push $(NAME)/rpi-sel-base:$(MAJOR)
	docker push $(NAME)/rpi-sel-hub:$(MAJOR)
	docker push $(NAME)/rpi-sel-node-base:$(MAJOR)
	docker push $(NAME)/rpi-sel-node-chromium:$(MAJOR)
	docker push $(NAME)/rpi-sel-node-firefox:$(MAJOR)
	docker push $(NAME)/rpi-sel-base:$(MAJOR).$(MINOR)
	docker push $(NAME)/rpi-sel-hub:$(MAJOR).$(MINOR)
	docker push $(NAME)/rpi-sel-node-base:$(MAJOR).$(MINOR)
	docker push $(NAME)/rpi-sel-node-chromium:$(MAJOR).$(MINOR)
	docker push $(NAME)/rpi-sel-node-firefox:$(MAJOR).$(MINOR)
	docker push $(NAME)/rpi-sel-base:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/rpi-sel-hub:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/rpi-sel-node-base:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/rpi-sel-node-chromium:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/rpi-sel-node-firefox:$(MAJOR_MINOR_PATCH)

test: test_chromium \
 test_firefox


test_chromium:
	VERSION=$(VERSION) NAMESPACE=$(NAMESPACE) ./tests/bootstrap.sh NodeChromium

test_firefox:
	VERSION=$(VERSION) NAMESPACE=$(NAMESPACE) ./tests/bootstrap.sh NodeFirefox


.PHONY: \
	all \
	base \
	build \
	chromium \
	ci \
	firefox \
	generate_all \
	generate_hub \
	generate_nodebase \
	generate_chromium \
	generate_firefox \
	hub \
	nodebase \
	release \
	tag_latest \
	test
