# Recursively fetch all files that requiere a new build, like C++ files, dockers, and build systems
CPP_SOURCES := $(shell find . -type f \( -name '*.cpp' -o -name '*.hpp' -o -name '*.cc' -o -name '*.h' \) -not -path '*/\.*')
CMAKELISTS := $(shell find . -name 'CMakeLists.txt' -not -path '*/\.*')
DOCKERFILES := $(shell find . -name 'Dockerfile*' -not -path '*/\.*')
SOURCES := $(CPP_SOURCES) $(DOCKERFILES) $(CMAKELISTS)
export COMPOSE_FILE=launch.yaml

# Build targets ------------------------------------------------------------------------------------
.build: .init $(SOURCES)
	@docker compose down
	@docker compose build --pull --build-arg USER_ID="$(shell id -u)" --build-arg GROUP_ID="$(shell id -g)"
	@docker compose run --rm build catkin build --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
	@touch $@
build: .build

# git configuration
.init:
	@git submodule update --init --recursive
	@git config --local include.path ../.gitconfig
	@touch $@
init: .init

# Launch targets ------------------------------------------------------------------------------------
# wrapper around docker exec command to simplify Makefile
docker_exec=@docker compose exec launch /ros_entrypoint.sh

start: .build
ifeq ($(NETWORK_MODE),host)
	@docker compose up launch --detach --no-build --pull never
else
	@docker compose --profile virtual_networking up launch --detach --no-build --pull never
endif

stop:
	@docker compose down

stop_networking:
	@docker compose --profile virtual_networking down network

run:start
	$(docker_exec) bash -l

launch:start
	$(docker_exec) scripts/ipb_car_launch

record:
	$(docker_exec) scripts/ipb_car_record

replay:start
	$(docker_exec) scripts/ipb_car_replay

attach:
	$(docker_exec) tmux attach -t ipb_car_launch

clean:
	@git checkout .
	@rm -rf .build .catkin_tools .init build/ devel/ logs/

wiki:
	@echo "Serving wiki locally..."
	@docker stop ipb_car_wiki 2>/dev/null || true
	@docker run --rm -p 4567:4567 -v $(shell pwd):/app --workdir /app/src/wiki --name ipb_car_wiki -d gollumwiki/gollum:master >/dev/null
	@sleep 2 && xdg-open "http://localhost:4567/" >/dev/null || true
