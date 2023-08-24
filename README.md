# IPB Car Package

This is the mother of all the rest of the packages you need to run the ipb-car
nodes. This is the only repo you need to launch all the sensors on the IPB car
and record the topics.

## Installation

You only need to clone to code into a local ROS workspace (`mkdir -p ~/ipb_car/ros_ws/ && cd ~/ipb_car/ros_ws/`) in the host machine:

```sh
git clone git@gitlab.ipb.uni-bonn.de:ipb-team/robots/ipb-car/meta-workspace
```

## Build

```sh
make
```

## Networking setup (SKIP if using polenta)

On your own machine you can either chose to use the `host` network or to use
the `virtual` one. If you choose the `host` network this will give you internet
access. If you use the `virtual` one then you MUST specify which network
interface to use, but this can stream data from the ipb-car to your machine.

Alternatively, you can also add the changes to an `.env` file, to make them
persistent.

### Specifying `NETWORK_INTERFACE`

```sh
export NETWORK_INTERFACE=eth0 # might be different in your machine!
```

### Specifying `NETWORK_MODE`

```sh
export NETWORK_MODE=host
```

## Start

```sh
make start
```

## Launch

```sh
make launch
```

## Record

```sh
make record
```

## Don't push code

This is an absolute "meta" package, this means, there is no real code inside
this repository. All slave repositories will be automatically updated every
time there is a change in there.

## Documentation

```sh
make docs
```

Additionally, all the documentation of the car setup can be found at our
[wiki](https://gitlab.ipb.uni-bonn.de/ipb-team/robots/ipb-car/docs).

## Paper

If you want to know more about the infrastructure design please check our
[paper](https://www.ipb.uni-bonn.de/wp-content/papercite-data/pdf/vizzo2023itcsws.pdf)

