CPP_SOURCES := $(shell find src/ -type f \( -name '*.cpp' -o -name '*.hpp' -o -name '*.cc' -o -name '*.h' \) -not -path '*/\.*')
PY_SOURCES := $(shell find src/ -type f \( -name '*.py' \) -not -path '*/\.*')
YAML_SOURCES := $(shell find src/ -type f \( -name '*.yaml' -o -name '*.yml' \) -not -path '*/\.*')
CMAKELISTS := $(shell find src/ -name 'CMakeLists.txt' -not -path '*/\.*')
DOCKERFILES := $(shell find src/ -name 'Dockerfile*' -not -path '*/\.*')
SOURCES := $(CPP_SOURCES) $(PY_SOURCES) $(YAML_SOURCES) $(DOCKERFILES) $(CMAKELISTS)
export COMPOSE_FILE=launch.yaml

# Build targets ------------------------------------------------------------------------------------
.build: .init $(SOURCES)
	@docker compose build --pull --build-arg USER_ID="$(shell id -u)" --build-arg GROUP_ID="$(shell id -g)"
	@docker compose run --rm build colcon build --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_BUILD_TYPE=Release --event-handlers console_direct+
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

	@# Enable loopback interface multicast. Required by CycloneDDS, sent by Dexory.
	$(docker_exec) sudo ip link set lo multicast on

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
	@rm -rf .build .init build/ install/ devel/ log/

docs:
	@echo "Serving wiki locally..."
	@docker stop docs 2>/dev/null || true
	@docker run --rm -p 4567:4567 -v $(shell pwd):/app --workdir /app/src/docs --name docs -d gollumwiki/gollum:master >/dev/null
	@sleep 2 && xdg-open "http://localhost:4567/" >/dev/null || true
