# IPB-Car meta-workspace

<img alt="IPB car Mounter" src="https://raw.githubusercontent.com/wiki/ipb-car/wiki/uploads/ipb-car-mounted-0.1.jpeg" width="53%"> <img alt="IPB car Body" src="https://raw.githubusercontent.com/wiki/ipb-car/wiki/uploads/ipb-car-body-0.2.png" width="44.8%">

**NOTE:** This is a reference repository, Without the hardware setup using this code does not make any sense. It has been released to serve as a starting point for research teams/labs that want to implement the meta-workspace idea. If you want to know more about the infrastructure design, please check our [paper](https://www.ipb.uni-bonn.de/wp-content/papercite-data/pdf/vizzo2023itcsws.pdf)

## Installation

You only need to clone to code into a local ROS workspace (`mkdir -p
~/ipb_car/ros_ws/ && cd ~/ipb_car/ros_ws/`) in the host machine:

```sh
git clone git@github.com:ipb-car/meta-workspace.git 
```

## Build

```sh
make
```

## Networking setup

On your machine, you can choose to use the `host` network or 
the `virtual` one. Choosing the `host` network will give you internet
access. If you use the `virtual` one, you MUST specify which network
interface to use, but this can stream data from the ipb-car to your machine.

Alternatively, you can also add the changes to an `.env` file to make them
persistent.

### Specifying `NETWORK_INTERFACE`

```sh
export NETWORK_INTERFACE=eth0 # might be different on your machine!
```

### Specifying `NETWORK_MODE`

```sh
export NETWORK_MODE=host
```

## Launch

```sh
make launch
```

## Record

```sh
make record
```

## Documentation

```sh
make docs
```

Additionally, all the documentation of the car setup can be found at our
[wiki](https://github.com/ipb-car/wiki/wiki).

## Citation

If you use this meta-workspace for any academic work, please cite our original
[paper](https://www.ipb.uni-bonn.de/wp-content/papercite-data/pdf/vizzo2023itcsws.pdf)

```bibtex
@inproceedings{vizzo2023itscws,
  title         = {{Toward Reproducible Version-Controlled Perception Platforms: Embracing Simplicity in Autonomous Vehicle Dataset Acquisition}},
  author        = {Vizzo, Ignacio and Mersch, Benedikt and Nunes, Lucas and Wiesmann, Louis and Guadagnino, Tiziano and Stachniss, Cyrill},
  booktitle     = {Worshop on Building Reliable Datasets for Autonomous Vehicles, IEEE Intl.~Conf.~on Intelligent Transportation Systems (ITSC)},
  year          = 2023
}
```
