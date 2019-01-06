NAME := $(or $(NAME),$(NAME),gsfraley)
VERSION := $(or $(VERSION),$(VERSION),3.141.59-dubnium)
NAMESPACE := $(or $(NAMESPACE),$(NAMESPACE),$(NAME))
AUTHORS := $(or $(AUTHORS),$(AUTHORS),gsfraley)
PLATFORM := $(shell uname -s)
BUILD_ARGS := $(BUILD_ARGS)
MAJOR := $(word 1,$(subst ., ,$(VERSION)))
MINOR := $(word 2,$(subst ., ,$(VERSION)))
MAJOR_MINOR_PATCH := $(word 1,$(subst -, ,$(VERSION)))

all: hub chrome firefox chrome_debug firefox_debug standalone_chrome standalone_firefox standalone_chrome_debug standalone_firefox_debug

generate_all:	\
	generate_hub \
	generate_nodebase \
	generate_chrome \
	generate_firefox \
	generate_chrome_debug \
	generate_firefox_debug \
	generate_standalone_firefox \
	generate_standalone_chrome \
	generate_standalone_firefox_debug \
	generate_standalone_chrome_debug

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

generate_chrome:
	cd ./NodeChrome && ./generate.sh $(VERSION) $(NAMESPACE) $(AUTHORS)

chrome: nodebase generate_chrome
	cd ./NodeChrome && docker build $(BUILD_ARGS) -t $(NAME)/rpi-sel-node-chrome:$(VERSION) .

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

generate_standalone_chrome:
	cd ./Standalone && ./generate.sh StandaloneChrome rpi-sel-node-chrome Chrome $(VERSION) $(NAMESPACE) $(AUTHORS)

standalone_chrome: chrome generate_standalone_chrome
	cd ./StandaloneChrome && docker build $(BUILD_ARGS) -t $(NAME)/rpi-sel-standalone-chrome:$(VERSION) .

generate_standalone_chrome_debug:
	cd ./StandaloneDebug && ./generate.sh StandaloneChromeDebug rpi-sel-node-chrome-debug Chrome $(VERSION) $(NAMESPACE) $(AUTHORS)

standalone_chrome_debug: chrome_debug generate_standalone_chrome_debug
	cd ./StandaloneChromeDebug && docker build $(BUILD_ARGS) -t $(NAME)/rpi-sel-standalone-chrome-debug:$(VERSION) .

generate_chrome_debug:
	cd ./NodeDebug && ./generate.sh NodeChromeDebug rpi-sel-node-chrome Chrome $(VERSION) $(NAMESPACE) $(AUTHORS)

chrome_debug: generate_chrome_debug chrome
	cd ./NodeChromeDebug && docker build $(BUILD_ARGS) -t $(NAME)/rpi-sel-node-chrome-debug:$(VERSION) .

generate_firefox_debug:
	cd ./NodeDebug && ./generate.sh NodeFirefoxDebug rpi-sel-node-firefox Firefox $(VERSION) $(NAMESPACE) $(AUTHORS)

firefox_debug: generate_firefox_debug firefox
	cd ./NodeFirefoxDebug && docker build $(BUILD_ARGS) -t $(NAME)/rpi-sel-node-firefox-debug:$(VERSION) .

tag_latest:
	docker tag $(NAME)/rpi-sel-base:$(VERSION) $(NAME)/rpi-sel-base:latest
	docker tag $(NAME)/rpi-sel-hub:$(VERSION) $(NAME)/rpi-sel-hub:latest
	docker tag $(NAME)/rpi-sel-node-base:$(VERSION) $(NAME)/rpi-sel-node-base:latest
	docker tag $(NAME)/rpi-sel-node-chrome:$(VERSION) $(NAME)/rpi-sel-node-chrome:latest
	docker tag $(NAME)/rpi-sel-node-firefox:$(VERSION) $(NAME)/rpi-sel-node-firefox:latest
	docker tag $(NAME)/rpi-sel-node-chrome-debug:$(VERSION) $(NAME)/rpi-sel-node-chrome-debug:latest
	docker tag $(NAME)/rpi-sel-node-firefox-debug:$(VERSION) $(NAME)/rpi-sel-node-firefox-debug:latest
	docker tag $(NAME)/rpi-sel-standalone-chrome:$(VERSION) $(NAME)/rpi-sel-standalone-chrome:latest
	docker tag $(NAME)/rpi-sel-standalone-firefox:$(VERSION) $(NAME)/rpi-sel-standalone-firefox:latest
	docker tag $(NAME)/rpi-sel-standalone-chrome-debug:$(VERSION) $(NAME)/rpi-sel-standalone-chrome-debug:latest
	docker tag $(NAME)/rpi-sel-standalone-firefox-debug:$(VERSION) $(NAME)/rpi-sel-standalone-firefox-debug:latest

release_latest:
	docker push $(NAME)/rpi-sel-base:latest
	docker push $(NAME)/rpi-sel-hub:latest
	docker push $(NAME)/rpi-sel-node-base:latest
	docker push $(NAME)/rpi-sel-node-chrome:latest
	docker push $(NAME)/rpi-sel-node-firefox:latest
	docker push $(NAME)/rpi-sel-node-chrome-debug:latest
	docker push $(NAME)/rpi-sel-node-firefox-debug:latest
	docker push $(NAME)/rpi-sel-standalone-chrome:latest
	docker push $(NAME)/rpi-sel-standalone-firefox:latest
	docker push $(NAME)/rpi-sel-standalone-chrome-debug:latest
	docker push $(NAME)/rpi-sel-standalone-firefox-debug:latest

tag_major_minor:
	docker tag $(NAME)/rpi-sel-base:$(VERSION) $(NAME)/rpi-sel-base:$(MAJOR)
	docker tag $(NAME)/rpi-sel-hub:$(VERSION) $(NAME)/rpi-sel-hub:$(MAJOR)
	docker tag $(NAME)/rpi-sel-node-base:$(VERSION) $(NAME)/rpi-sel-node-base:$(MAJOR)
	docker tag $(NAME)/rpi-sel-node-chrome:$(VERSION) $(NAME)/rpi-sel-node-chrome:$(MAJOR)
	docker tag $(NAME)/rpi-sel-node-firefox:$(VERSION) $(NAME)/rpi-sel-node-firefox:$(MAJOR)
	docker tag $(NAME)/rpi-sel-node-chrome-debug:$(VERSION) $(NAME)/rpi-sel-node-chrome-debug:$(MAJOR)
	docker tag $(NAME)/rpi-sel-node-firefox-debug:$(VERSION) $(NAME)/rpi-sel-node-firefox-debug:$(MAJOR)
	docker tag $(NAME)/rpi-sel-standalone-chrome:$(VERSION) $(NAME)/rpi-sel-standalone-chrome:$(MAJOR)
	docker tag $(NAME)/rpi-sel-standalone-firefox:$(VERSION) $(NAME)/rpi-sel-standalone-firefox:$(MAJOR)
	docker tag $(NAME)/rpi-sel-standalone-chrome-debug:$(VERSION) $(NAME)/rpi-sel-standalone-chrome-debug:$(MAJOR)
	docker tag $(NAME)/rpi-sel-standalone-firefox-debug:$(VERSION) $(NAME)/rpi-sel-standalone-firefox-debug:$(MAJOR)
	docker tag $(NAME)/rpi-sel-base:$(VERSION) $(NAME)/rpi-sel-base:$(MAJOR).$(MINOR)
	docker tag $(NAME)/rpi-sel-hub:$(VERSION) $(NAME)/rpi-sel-hub:$(MAJOR).$(MINOR)
	docker tag $(NAME)/rpi-sel-node-base:$(VERSION) $(NAME)/rpi-sel-node-base:$(MAJOR).$(MINOR)
	docker tag $(NAME)/rpi-sel-node-chrome:$(VERSION) $(NAME)/rpi-sel-node-chrome:$(MAJOR).$(MINOR)
	docker tag $(NAME)/rpi-sel-node-firefox:$(VERSION) $(NAME)/rpi-sel-node-firefox:$(MAJOR).$(MINOR)
	docker tag $(NAME)/rpi-sel-node-chrome-debug:$(VERSION) $(NAME)/rpi-sel-node-chrome-debug:$(MAJOR).$(MINOR)
	docker tag $(NAME)/rpi-sel-node-firefox-debug:$(VERSION) $(NAME)/rpi-sel-node-firefox-debug:$(MAJOR).$(MINOR)
	docker tag $(NAME)/rpi-sel-standalone-chrome:$(VERSION) $(NAME)/rpi-sel-standalone-chrome:$(MAJOR).$(MINOR)
	docker tag $(NAME)/rpi-sel-standalone-firefox:$(VERSION) $(NAME)/rpi-sel-standalone-firefox:$(MAJOR).$(MINOR)
	docker tag $(NAME)/rpi-sel-standalone-chrome-debug:$(VERSION) $(NAME)/rpi-sel-standalone-chrome-debug:$(MAJOR).$(MINOR)
	docker tag $(NAME)/rpi-sel-standalone-firefox-debug:$(VERSION) $(NAME)/rpi-sel-standalone-firefox-debug:$(MAJOR).$(MINOR)
	docker tag $(NAME)/rpi-sel-base:$(VERSION) $(NAME)/rpi-sel-base:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/rpi-sel-hub:$(VERSION) $(NAME)/rpi-sel-hub:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/rpi-sel-node-base:$(VERSION) $(NAME)/rpi-sel-node-base:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/rpi-sel-node-chrome:$(VERSION) $(NAME)/rpi-sel-node-chrome:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/rpi-sel-node-firefox:$(VERSION) $(NAME)/rpi-sel-node-firefox:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/rpi-sel-node-chrome-debug:$(VERSION) $(NAME)/rpi-sel-node-chrome-debug:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/rpi-sel-node-firefox-debug:$(VERSION) $(NAME)/rpi-sel-node-firefox-debug:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/rpi-sel-standalone-chrome:$(VERSION) $(NAME)/rpi-sel-standalone-chrome:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/rpi-sel-standalone-firefox:$(VERSION) $(NAME)/rpi-sel-standalone-firefox:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/rpi-sel-standalone-chrome-debug:$(VERSION) $(NAME)/rpi-sel-standalone-chrome-debug:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/rpi-sel-standalone-firefox-debug:$(VERSION) $(NAME)/rpi-sel-standalone-firefox-debug:$(MAJOR_MINOR_PATCH)

release: tag_major_minor
	@if ! docker images $(NAME)/rpi-sel-base | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/rpi-sel-base version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/rpi-sel-hub | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/rpi-sel-hub version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/rpi-sel-node-base | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/rpi-sel-node-base version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/rpi-sel-node-chrome | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/rpi-sel-node-chrome version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/rpi-sel-node-firefox | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/rpi-sel-node-firefox version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/rpi-sel-node-chrome-debug | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/rpi-sel-node-chrome-debug version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/rpi-sel-node-firefox-debug | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/rpi-sel-node-firefox-debug version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/rpi-sel-standalone-chrome | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/rpi-sel-standalone-chrome version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/rpi-sel-standalone-firefox | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/rpi-sel-standalone-firefox version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/rpi-sel-standalone-chrome-debug | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/rpi-sel-standalone-chrome-debug version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/rpi-sel-standalone-firefox-debug | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/rpi-sel-standalone-firefox-debug version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker push $(NAME)/rpi-sel-base:$(VERSION)
	docker push $(NAME)/rpi-sel-hub:$(VERSION)
	docker push $(NAME)/rpi-sel-node-base:$(VERSION)
	docker push $(NAME)/rpi-sel-node-chrome:$(VERSION)
	docker push $(NAME)/rpi-sel-node-firefox:$(VERSION)
	docker push $(NAME)/rpi-sel-node-chrome-debug:$(VERSION)
	docker push $(NAME)/rpi-sel-node-firefox-debug:$(VERSION)
	docker push $(NAME)/rpi-sel-standalone-chrome:$(VERSION)
	docker push $(NAME)/rpi-sel-standalone-firefox:$(VERSION)
	docker push $(NAME)/rpi-sel-standalone-chrome-debug:$(VERSION)
	docker push $(NAME)/rpi-sel-standalone-firefox-debug:$(VERSION)
	docker push $(NAME)/rpi-sel-base:$(MAJOR)
	docker push $(NAME)/rpi-sel-hub:$(MAJOR)
	docker push $(NAME)/rpi-sel-node-base:$(MAJOR)
	docker push $(NAME)/rpi-sel-node-chrome:$(MAJOR)
	docker push $(NAME)/rpi-sel-node-firefox:$(MAJOR)
	docker push $(NAME)/rpi-sel-node-chrome-debug:$(MAJOR)
	docker push $(NAME)/rpi-sel-node-firefox-debug:$(MAJOR)
	docker push $(NAME)/rpi-sel-standalone-chrome:$(MAJOR)
	docker push $(NAME)/rpi-sel-standalone-firefox:$(MAJOR)
	docker push $(NAME)/rpi-sel-standalone-chrome-debug:$(MAJOR)
	docker push $(NAME)/rpi-sel-standalone-firefox-debug:$(MAJOR)
	docker push $(NAME)/rpi-sel-base:$(MAJOR).$(MINOR)
	docker push $(NAME)/rpi-sel-hub:$(MAJOR).$(MINOR)
	docker push $(NAME)/rpi-sel-node-base:$(MAJOR).$(MINOR)
	docker push $(NAME)/rpi-sel-node-chrome:$(MAJOR).$(MINOR)
	docker push $(NAME)/rpi-sel-node-firefox:$(MAJOR).$(MINOR)
	docker push $(NAME)/rpi-sel-node-chrome-debug:$(MAJOR).$(MINOR)
	docker push $(NAME)/rpi-sel-node-firefox-debug:$(MAJOR).$(MINOR)
	docker push $(NAME)/rpi-sel-standalone-chrome:$(MAJOR).$(MINOR)
	docker push $(NAME)/rpi-sel-standalone-firefox:$(MAJOR).$(MINOR)
	docker push $(NAME)/rpi-sel-standalone-chrome-debug:$(MAJOR).$(MINOR)
	docker push $(NAME)/rpi-sel-standalone-firefox-debug:$(MAJOR).$(MINOR)
	docker push $(NAME)/rpi-sel-base:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/rpi-sel-hub:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/rpi-sel-node-base:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/rpi-sel-node-chrome:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/rpi-sel-node-firefox:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/rpi-sel-node-chrome-debug:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/rpi-sel-node-firefox-debug:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/rpi-sel-standalone-chrome:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/rpi-sel-standalone-firefox:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/rpi-sel-standalone-chrome-debug:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/rpi-sel-standalone-firefox-debug:$(MAJOR_MINOR_PATCH)

test: test_chrome \
 test_firefox \
 test_chrome_debug \
 test_firefox_debug \
 test_chrome_standalone \
 test_firefox_standalone \
 test_chrome_standalone_debug \
 test_firefox_standalone_debug


test_chrome:
	VERSION=$(VERSION) NAMESPACE=$(NAMESPACE) ./tests/bootstrap.sh NodeChrome

test_chrome_debug:
	VERSION=$(VERSION) NAMESPACE=$(NAMESPACE) ./tests/bootstrap.sh NodeChromeDebug

test_chrome_standalone:
	VERSION=$(VERSION) NAMESPACE=$(NAMESPACE) ./tests/bootstrap.sh StandaloneChrome

test_chrome_standalone_debug:
	VERSION=$(VERSION) NAMESPACE=$(NAMESPACE) ./tests/bootstrap.sh StandaloneChromeDebug

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
	chrome \
	chrome_debug \
	ci \
	firefox \
	firefox_debug \
	generate_all \
	generate_hub \
	generate_nodebase \
	generate_chrome \
	generate_firefox \
	generate_chrome_debug \
	generate_firefox_debug \
	generate_standalone_chrome \
	generate_standalone_firefox \
	generate_standalone_chrome_debug \
	generate_standalone_firefox_debug \
	hub \
	nodebase \
	release \
	standalone_chrome \
	standalone_firefox \
	standalone_chrome_debug \
	standalone_firefox_debug \
	tag_latest \
	test
