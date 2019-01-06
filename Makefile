NAME := $(or $(NAME),$(NAME),gsfraley)
VERSION := $(or $(VERSION),$(VERSION),3.141.59-dubnium)
NAMESPACE := $(or $(NAMESPACE),$(NAMESPACE),$(NAME))
AUTHORS := $(or $(AUTHORS),$(AUTHORS),gsfraley)
PLATFORM := $(shell uname -s)
BUILD_ARGS := $(BUILD_ARGS)
MAJOR := $(word 1,$(subst ., ,$(VERSION)))
MINOR := $(word 2,$(subst ., ,$(VERSION)))
MAJOR_MINOR_PATCH := $(word 1,$(subst -, ,$(VERSION)))

all: hub chromium firefox chromium_debug firefox_debug standalone_chromium standalone_firefox standalone_chromium_debug standalone_firefox_debug

generate_all:	\
	generate_hub \
	generate_nodebase \
	generate_chromium \
	generate_firefox \
	generate_chromium_debug \
	generate_firefox_debug \
	generate_standalone_firefox \
	generate_standalone_chromium \
	generate_standalone_firefox_debug \
	generate_standalone_chromium_debug

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

generate_standalone_firefox:
	cd ./Standalone && ./generate.sh StandaloneFirefox rpi-sel-node-firefox Firefox $(VERSION) $(NAMESPACE) $(AUTHORS)

standalone_firefox: firefox generate_standalone_firefox
	cd ./StandaloneFirefox && docker build $(BUILD_ARGS) -t $(NAME)/rpi-sel-standalone-firefox:$(VERSION) .

generate_standalone_firefox_debug:
	cd ./StandaloneDebug && ./generate.sh StandaloneFirefoxDebug rpi-sel-node-firefox-debug Firefox $(VERSION) $(NAMESPACE) $(AUTHORS)

standalone_firefox_debug: firefox_debug generate_standalone_firefox_debug
	cd ./StandaloneFirefoxDebug && docker build $(BUILD_ARGS) -t $(NAME)/rpi-sel-standalone-firefox-debug:$(VERSION) .

generate_standalone_chromium:
	cd ./Standalone && ./generate.sh StandaloneChromium rpi-sel-node-chromium Chromium $(VERSION) $(NAMESPACE) $(AUTHORS)

standalone_chromium: chromium generate_standalone_chromium
	cd ./StandaloneChromium && docker build $(BUILD_ARGS) -t $(NAME)/rpi-sel-standalone-chromium:$(VERSION) .

generate_standalone_chromium_debug:
	cd ./StandaloneDebug && ./generate.sh StandaloneChromiumDebug rpi-sel-node-chromium-debug Chromium $(VERSION) $(NAMESPACE) $(AUTHORS)

standalone_chromium_debug: chromium_debug generate_standalone_chromium_debug
	cd ./StandaloneChromiumDebug && docker build $(BUILD_ARGS) -t $(NAME)/rpi-sel-standalone-chromium-debug:$(VERSION) .

generate_chromium_debug:
	cd ./NodeDebug && ./generate.sh NodeChromiumDebug rpi-sel-node-chromium Chromium $(VERSION) $(NAMESPACE) $(AUTHORS)

chromium_debug: generate_chromium_debug chromium
	cd ./NodeChromiumDebug && docker build $(BUILD_ARGS) -t $(NAME)/rpi-sel-node-chromium-debug:$(VERSION) .

generate_firefox_debug:
	cd ./NodeDebug && ./generate.sh NodeFirefoxDebug rpi-sel-node-firefox Firefox $(VERSION) $(NAMESPACE) $(AUTHORS)

firefox_debug: generate_firefox_debug firefox
	cd ./NodeFirefoxDebug && docker build $(BUILD_ARGS) -t $(NAME)/rpi-sel-node-firefox-debug:$(VERSION) .

tag_latest:
	docker tag $(NAME)/rpi-sel-base:$(VERSION) $(NAME)/rpi-sel-base:latest
	docker tag $(NAME)/rpi-sel-hub:$(VERSION) $(NAME)/rpi-sel-hub:latest
	docker tag $(NAME)/rpi-sel-node-base:$(VERSION) $(NAME)/rpi-sel-node-base:latest
	docker tag $(NAME)/rpi-sel-node-chromium:$(VERSION) $(NAME)/rpi-sel-node-chromium:latest
	docker tag $(NAME)/rpi-sel-node-firefox:$(VERSION) $(NAME)/rpi-sel-node-firefox:latest
	docker tag $(NAME)/rpi-sel-node-chromium-debug:$(VERSION) $(NAME)/rpi-sel-node-chromium-debug:latest
	docker tag $(NAME)/rpi-sel-node-firefox-debug:$(VERSION) $(NAME)/rpi-sel-node-firefox-debug:latest
	docker tag $(NAME)/rpi-sel-standalone-chromium:$(VERSION) $(NAME)/rpi-sel-standalone-chromium:latest
	docker tag $(NAME)/rpi-sel-standalone-firefox:$(VERSION) $(NAME)/rpi-sel-standalone-firefox:latest
	docker tag $(NAME)/rpi-sel-standalone-chromium-debug:$(VERSION) $(NAME)/rpi-sel-standalone-chromium-debug:latest
	docker tag $(NAME)/rpi-sel-standalone-firefox-debug:$(VERSION) $(NAME)/rpi-sel-standalone-firefox-debug:latest

release_latest:
	docker push $(NAME)/rpi-sel-base:latest
	docker push $(NAME)/rpi-sel-hub:latest
	docker push $(NAME)/rpi-sel-node-base:latest
	docker push $(NAME)/rpi-sel-node-chromium:latest
	docker push $(NAME)/rpi-sel-node-firefox:latest
	docker push $(NAME)/rpi-sel-node-chromium-debug:latest
	docker push $(NAME)/rpi-sel-node-firefox-debug:latest
	docker push $(NAME)/rpi-sel-standalone-chromium:latest
	docker push $(NAME)/rpi-sel-standalone-firefox:latest
	docker push $(NAME)/rpi-sel-standalone-chromium-debug:latest
	docker push $(NAME)/rpi-sel-standalone-firefox-debug:latest

tag_major_minor:
	docker tag $(NAME)/rpi-sel-base:$(VERSION) $(NAME)/rpi-sel-base:$(MAJOR)
	docker tag $(NAME)/rpi-sel-hub:$(VERSION) $(NAME)/rpi-sel-hub:$(MAJOR)
	docker tag $(NAME)/rpi-sel-node-base:$(VERSION) $(NAME)/rpi-sel-node-base:$(MAJOR)
	docker tag $(NAME)/rpi-sel-node-chromium:$(VERSION) $(NAME)/rpi-sel-node-chromium:$(MAJOR)
	docker tag $(NAME)/rpi-sel-node-firefox:$(VERSION) $(NAME)/rpi-sel-node-firefox:$(MAJOR)
	docker tag $(NAME)/rpi-sel-node-chromium-debug:$(VERSION) $(NAME)/rpi-sel-node-chromium-debug:$(MAJOR)
	docker tag $(NAME)/rpi-sel-node-firefox-debug:$(VERSION) $(NAME)/rpi-sel-node-firefox-debug:$(MAJOR)
	docker tag $(NAME)/rpi-sel-standalone-chromium:$(VERSION) $(NAME)/rpi-sel-standalone-chromium:$(MAJOR)
	docker tag $(NAME)/rpi-sel-standalone-firefox:$(VERSION) $(NAME)/rpi-sel-standalone-firefox:$(MAJOR)
	docker tag $(NAME)/rpi-sel-standalone-chromium-debug:$(VERSION) $(NAME)/rpi-sel-standalone-chromium-debug:$(MAJOR)
	docker tag $(NAME)/rpi-sel-standalone-firefox-debug:$(VERSION) $(NAME)/rpi-sel-standalone-firefox-debug:$(MAJOR)
	docker tag $(NAME)/rpi-sel-base:$(VERSION) $(NAME)/rpi-sel-base:$(MAJOR).$(MINOR)
	docker tag $(NAME)/rpi-sel-hub:$(VERSION) $(NAME)/rpi-sel-hub:$(MAJOR).$(MINOR)
	docker tag $(NAME)/rpi-sel-node-base:$(VERSION) $(NAME)/rpi-sel-node-base:$(MAJOR).$(MINOR)
	docker tag $(NAME)/rpi-sel-node-chromium:$(VERSION) $(NAME)/rpi-sel-node-chromium:$(MAJOR).$(MINOR)
	docker tag $(NAME)/rpi-sel-node-firefox:$(VERSION) $(NAME)/rpi-sel-node-firefox:$(MAJOR).$(MINOR)
	docker tag $(NAME)/rpi-sel-node-chromium-debug:$(VERSION) $(NAME)/rpi-sel-node-chromium-debug:$(MAJOR).$(MINOR)
	docker tag $(NAME)/rpi-sel-node-firefox-debug:$(VERSION) $(NAME)/rpi-sel-node-firefox-debug:$(MAJOR).$(MINOR)
	docker tag $(NAME)/rpi-sel-standalone-chromium:$(VERSION) $(NAME)/rpi-sel-standalone-chromium:$(MAJOR).$(MINOR)
	docker tag $(NAME)/rpi-sel-standalone-firefox:$(VERSION) $(NAME)/rpi-sel-standalone-firefox:$(MAJOR).$(MINOR)
	docker tag $(NAME)/rpi-sel-standalone-chromium-debug:$(VERSION) $(NAME)/rpi-sel-standalone-chromium-debug:$(MAJOR).$(MINOR)
	docker tag $(NAME)/rpi-sel-standalone-firefox-debug:$(VERSION) $(NAME)/rpi-sel-standalone-firefox-debug:$(MAJOR).$(MINOR)
	docker tag $(NAME)/rpi-sel-base:$(VERSION) $(NAME)/rpi-sel-base:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/rpi-sel-hub:$(VERSION) $(NAME)/rpi-sel-hub:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/rpi-sel-node-base:$(VERSION) $(NAME)/rpi-sel-node-base:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/rpi-sel-node-chromium:$(VERSION) $(NAME)/rpi-sel-node-chromium:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/rpi-sel-node-firefox:$(VERSION) $(NAME)/rpi-sel-node-firefox:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/rpi-sel-node-chromium-debug:$(VERSION) $(NAME)/rpi-sel-node-chromium-debug:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/rpi-sel-node-firefox-debug:$(VERSION) $(NAME)/rpi-sel-node-firefox-debug:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/rpi-sel-standalone-chromium:$(VERSION) $(NAME)/rpi-sel-standalone-chromium:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/rpi-sel-standalone-firefox:$(VERSION) $(NAME)/rpi-sel-standalone-firefox:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/rpi-sel-standalone-chromium-debug:$(VERSION) $(NAME)/rpi-sel-standalone-chromium-debug:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/rpi-sel-standalone-firefox-debug:$(VERSION) $(NAME)/rpi-sel-standalone-firefox-debug:$(MAJOR_MINOR_PATCH)

release: tag_major_minor
	@if ! docker images $(NAME)/rpi-sel-base | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/rpi-sel-base version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/rpi-sel-hub | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/rpi-sel-hub version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/rpi-sel-node-base | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/rpi-sel-node-base version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/rpi-sel-node-chromium | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/rpi-sel-node-chromium version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/rpi-sel-node-firefox | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/rpi-sel-node-firefox version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/rpi-sel-node-chromium-debug | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/rpi-sel-node-chromium-debug version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/rpi-sel-node-firefox-debug | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/rpi-sel-node-firefox-debug version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/rpi-sel-standalone-chromium | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/rpi-sel-standalone-chromium version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/rpi-sel-standalone-firefox | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/rpi-sel-standalone-firefox version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/rpi-sel-standalone-chromium-debug | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/rpi-sel-standalone-chromium-debug version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/rpi-sel-standalone-firefox-debug | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/rpi-sel-standalone-firefox-debug version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker push $(NAME)/rpi-sel-base:$(VERSION)
	docker push $(NAME)/rpi-sel-hub:$(VERSION)
	docker push $(NAME)/rpi-sel-node-base:$(VERSION)
	docker push $(NAME)/rpi-sel-node-chromium:$(VERSION)
	docker push $(NAME)/rpi-sel-node-firefox:$(VERSION)
	docker push $(NAME)/rpi-sel-node-chromium-debug:$(VERSION)
	docker push $(NAME)/rpi-sel-node-firefox-debug:$(VERSION)
	docker push $(NAME)/rpi-sel-standalone-chromium:$(VERSION)
	docker push $(NAME)/rpi-sel-standalone-firefox:$(VERSION)
	docker push $(NAME)/rpi-sel-standalone-chromium-debug:$(VERSION)
	docker push $(NAME)/rpi-sel-standalone-firefox-debug:$(VERSION)
	docker push $(NAME)/rpi-sel-base:$(MAJOR)
	docker push $(NAME)/rpi-sel-hub:$(MAJOR)
	docker push $(NAME)/rpi-sel-node-base:$(MAJOR)
	docker push $(NAME)/rpi-sel-node-chromium:$(MAJOR)
	docker push $(NAME)/rpi-sel-node-firefox:$(MAJOR)
	docker push $(NAME)/rpi-sel-node-chromium-debug:$(MAJOR)
	docker push $(NAME)/rpi-sel-node-firefox-debug:$(MAJOR)
	docker push $(NAME)/rpi-sel-standalone-chromium:$(MAJOR)
	docker push $(NAME)/rpi-sel-standalone-firefox:$(MAJOR)
	docker push $(NAME)/rpi-sel-standalone-chromium-debug:$(MAJOR)
	docker push $(NAME)/rpi-sel-standalone-firefox-debug:$(MAJOR)
	docker push $(NAME)/rpi-sel-base:$(MAJOR).$(MINOR)
	docker push $(NAME)/rpi-sel-hub:$(MAJOR).$(MINOR)
	docker push $(NAME)/rpi-sel-node-base:$(MAJOR).$(MINOR)
	docker push $(NAME)/rpi-sel-node-chromium:$(MAJOR).$(MINOR)
	docker push $(NAME)/rpi-sel-node-firefox:$(MAJOR).$(MINOR)
	docker push $(NAME)/rpi-sel-node-chromium-debug:$(MAJOR).$(MINOR)
	docker push $(NAME)/rpi-sel-node-firefox-debug:$(MAJOR).$(MINOR)
	docker push $(NAME)/rpi-sel-standalone-chromium:$(MAJOR).$(MINOR)
	docker push $(NAME)/rpi-sel-standalone-firefox:$(MAJOR).$(MINOR)
	docker push $(NAME)/rpi-sel-standalone-chromium-debug:$(MAJOR).$(MINOR)
	docker push $(NAME)/rpi-sel-standalone-firefox-debug:$(MAJOR).$(MINOR)
	docker push $(NAME)/rpi-sel-base:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/rpi-sel-hub:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/rpi-sel-node-base:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/rpi-sel-node-chromium:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/rpi-sel-node-firefox:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/rpi-sel-node-chromium-debug:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/rpi-sel-node-firefox-debug:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/rpi-sel-standalone-chromium:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/rpi-sel-standalone-firefox:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/rpi-sel-standalone-chromium-debug:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/rpi-sel-standalone-firefox-debug:$(MAJOR_MINOR_PATCH)

test: test_chromium \
 test_firefox \
 test_chromium_debug \
 test_firefox_debug \
 test_chromium_standalone \
 test_firefox_standalone \
 test_chromium_standalone_debug \
 test_firefox_standalone_debug


test_chromium:
	VERSION=$(VERSION) NAMESPACE=$(NAMESPACE) ./tests/bootstrap.sh NodeChromium

test_chromium_debug:
	VERSION=$(VERSION) NAMESPACE=$(NAMESPACE) ./tests/bootstrap.sh NodeChromiumDebug

test_chromium_standalone:
	VERSION=$(VERSION) NAMESPACE=$(NAMESPACE) ./tests/bootstrap.sh StandaloneChromium

test_chromium_standalone_debug:
	VERSION=$(VERSION) NAMESPACE=$(NAMESPACE) ./tests/bootstrap.sh StandaloneChromiumDebug

test_firefox:
	VERSION=$(VERSION) NAMESPACE=$(NAMESPACE) ./tests/bootstrap.sh NodeFirefox

test_firefox_debug:
	VERSION=$(VERSION) NAMESPACE=$(NAMESPACE) ./tests/bootstrap.sh NodeFirefoxDebug

test_firefox_standalone:
	VERSION=$(VERSION) NAMESPACE=$(NAMESPACE) ./tests/bootstrap.sh StandaloneFirefox

test_firefox_standalone_debug:
	VERSION=$(VERSION) NAMESPACE=$(NAMESPACE) ./tests/bootstrap.sh StandaloneFirefoxDebug


.PHONY: \
	all \
	base \
	build \
	chromium \
	chromium_debug \
	ci \
	firefox \
	firefox_debug \
	generate_all \
	generate_hub \
	generate_nodebase \
	generate_chromium \
	generate_firefox \
	generate_chromium_debug \
	generate_firefox_debug \
	generate_standalone_chromium \
	generate_standalone_firefox \
	generate_standalone_chromium_debug \
	generate_standalone_firefox_debug \
	hub \
	nodebase \
	release \
	standalone_chromium \
	standalone_firefox \
	standalone_chromium_debug \
	standalone_firefox_debug \
	tag_latest \
	test
