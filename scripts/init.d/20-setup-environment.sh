#!/bin/bash
mkdir -p $ROS_HOME $ROS_CONFIG $ROS_BAGS

# create a symlink to latest recording directory
rm $LATEST 2>/dev/null || true && ln -s -r $ROS_HOME $LATEST

# Store the camera config files
cp -r $(rospack find ipb_car_launch)/config/camera/* $ROS_CONFIG
