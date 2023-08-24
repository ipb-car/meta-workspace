#!/bin/bash
# TODO: is there any other way to retrieve the pi-gen directory from here? What happens if the
# launcher system is not on the root source of the ros_ws, but on another directory? Should we make
# pi-gen a ros-package just to robustly find it here? God help me
submodule="$(catkin locate --source)/raspbian"
launch_system_hash="$(git -C $submodule rev-parse HEAD)$(\
    $(git -C $submodule diff-index --quiet HEAD &&
    git -C $submodule ls-files --others) ||
    echo "-dirty")"
sd_card_hash=$(ssh pi grep COMMIT_HASH /etc/os-release | cut -d= -f2)

if [ "$launch_system_hash" != "$sd_card_hash" ]; then
    echo "[ERROR]: raspberry firmware mismatch!"
    echo "launcher image is at commit hash: ${launch_system_hash}"
    echo "raspbian image is at commit hash: ${sd_card_hash}"
    exit 1
fi
