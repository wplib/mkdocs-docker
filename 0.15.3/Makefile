#
# Standard version level Makefile used to build a Docker container for WPLib - https://github.com/wplib/wplib-box/
#


# Determine whether we use "nodeJS" or "JQ".
JSONCMD := $(shell jq -r '.project' ./container.json)
ifneq ($(JSONCMD),)
define GetFromPkg
$(shell jq -r ".$(1)" ./container.json)
endef

define rawJSON
$(shell jq -Mc -r '' ./container.json)
endef

else
JSONCMD := $(shell node -p "require('./container.json').project")
ifneq ($(JSONCMD),)
define GetFromPkg
$(shell node -p "require('./container.json').$(1)")
endef

define rawJSON
$(shell node -p "require('./container.json')")
endef

else
$(shell )

endif
endif

# Set global variables from container file.
PROJECT		:= $(call GetFromPkg,project)
NAME		:= $(call GetFromPkg,name)
VERSION		:= $(call GetFromPkg,version)
MAJORVERSION	:= $(call GetFromPkg,majorversion)
LATEST		:= $(call GetFromPkg,latest)
CLASS		:= $(call GetFromPkg,class)
NETWORK		:= $(call GetFromPkg,network)
PORTS		:= $(call GetFromPkg,ports)
VOLUMES		:= $(call GetFromPkg,volumes)
RESTART		:= $(call GetFromPkg,restart)
ARGS		:= $(call GetFromPkg,args)
ENV		:= $(call GetFromPkg,env)

OLDNAME		:= $(NAME)
ifeq ($(BUILD_TYPE),)
DOCKERFILE	:= DockerfileRuntime
BUILD_ARGS	:= --squash
NAME		:= $(NAME)
else
DOCKERFILE	:= DockerfileBase
BUILD_ARGS	:= --build-arg BUILD_TYPE="$(BUILD_TYPE)"
NAME		:= $(NAME)-$(BUILD_TYPE)
endif

IMAGE_NAME	?= $(PROJECT)/$(NAME)
CONTAINER_NAME	?= $(NAME)-$(VERSION)
CONTAINER_JSON	?= '$(call rawJSON)'


LOGFILE := $(NAME)-$(shell date +'%Y%m%d-%H%M%S').log


.PHONY: build push release clean list inspect test create shell run start stop rm

################################################################################
# Image related commands.
default: all

all:
	@echo "info		- Generate info from runtime container image."
	@echo "clean		- Clean runtime container image."
	@echo "build		- Generate runtime container image from base container image."
	@echo "push		- Push runtime container image to DockerHub."
	@echo ""
	@echo "build-full	- Generate runtime container image without base reference."
	@echo ""
	@echo "Process:"
	@echo "	make clean"
	@echo "	make build"


################################################################################
build: $(DOCKERFILE)
ifeq ($(PROJECT),)
	@echo "WPLib: ERROR - You need to install JQ or NodeJS."
else
	script -r -t 10 logs/$(LOGFILE) docker build -t $(IMAGE_NAME):$(VERSION) --label container.json='$(call rawJSON)' --label container.project="$(PROJECT)" --label container.name="$(NAME)" --label container.version="$(VERSION)" --label container.majorversion="$(MAJORVERSION)" --label container.latest="$(LATEST)" --label container.class="$(CLASS)" --label container.network="$(NETWORK)" --label container.ports="$(PORTS)" --label container.volumes="$(VOLUMES)" --label container.restart="$(RESTART)" --label container.args="$(ARGS)" --label container.env="$(ENV)" --build-arg $(ENV)="$(VERSION)" $(BUILD_ARGS) -f $(DOCKERFILE) .
ifneq ($(MAJORVERSION),)
	docker tag $(IMAGE_NAME):$(VERSION) $(IMAGE_NAME):$(MAJORVERSION)
endif
	@echo "WPLib: Log file saved to \"logs/$(LOGFILE)\""
endif


################################################################################
push:
ifeq ($(PROJECT),)
	@echo "WPLib: ERROR - You need to install JQ or NodeJS."
else
	docker push $(IMAGE_NAME):$(VERSION)
ifneq ($(MAJORVERSION),)
	docker push $(IMAGE_NAME):$(MAJORVERSION)
endif
endif


################################################################################
release: build
ifeq ($(PROJECT),)
	@echo "WPLib: ERROR - You need to install JQ or NodeJS."
else
	@make clean
	@make build
	@make push
endif


################################################################################
clean:
ifeq ($(PROJECT),)
	@echo "WPLib: ERROR - You need to install JQ or NodeJS."
else
	-docker image rm -f $(IMAGE_NAME):$(VERSION)
ifneq ($(MAJORVERSION),)
	-docker image rm -f $(IMAGE_NAME):$(MAJORVERSION)
endif
endif


################################################################################
list:
ifeq ($(PROJECT),)
	@echo "WPLib: ERROR - You need to install JQ or NodeJS."
else
	-docker image ls $(IMAGE_NAME):$(VERSION)
ifneq ($(MAJORVERSION),)
	-docker image ls $(IMAGE_NAME):$(MAJORVERSION)
endif
endif


################################################################################
inspect:
ifeq ($(PROJECT),)
	@echo "WPLib: ERROR - You need to install JQ or NodeJS."
else
	docker image inspect $(IMAGE_NAME):$(VERSION)
endif


################################################################################
test:
ifeq ($(PROJECT),)
	@echo "WPLib: ERROR - You need to install JQ or NodeJS."
else
	make -k stop; make -k rm
	make -k clean; make -k build; make -k create; make -k start
endif


################################################################################
# Container related commands.

create:
ifeq ($(PROJECT),)
	@echo "WPLib: ERROR - You need to install JQ or NodeJS."
else
	docker create   --name $(CONTAINER_NAME) $(RESTART)  $(NETWORK) $(PORTS) $(ARGS) $(VOLUMES) $(IMAGE_NAME):$(VERSION)
endif


################################################################################
shell:
ifeq ($(PROJECT),)
	@echo "WPLib: ERROR - You need to install JQ or NodeJS."
else
	docker run --rm --name $(CONTAINER_NAME)-shell -i -t $(NETWORK) $(PORTS) $(ARGS) $(VOLUMES) $(IMAGE_NAME):$(VERSION) /bin/bash
endif


################################################################################
run:
ifeq ($(PROJECT),)
	@echo "WPLib: ERROR - You need to install JQ or NodeJS."
else
	docker run --rm --name $(CONTAINER_NAME)             $(NETWORK) $(PORTS) $(ARGS) $(VOLUMES) $(IMAGE_NAME):$(VERSION)
endif


################################################################################
start:
ifeq ($(PROJECT),)
	@echo "WPLib: ERROR - You need to install JQ or NodeJS."
else
	docker start $(CONTAINER_NAME)
endif


################################################################################
stop:
ifeq ($(PROJECT),)
	@echo "WPLib: ERROR - You need to install JQ or NodeJS."
else
	docker stop $(CONTAINER_NAME)
endif


################################################################################
rm:
ifeq ($(PROJECT),)
	@echo "WPLib: ERROR - You need to install JQ or NodeJS."
else
	docker container rm -f $(CONTAINER_NAME)
endif


################################################################################

