xhost +local:root

# BUILD THE IMAGE
ROS_IMAGE="arm/image03"
docker build -f Dockerfile -t $ROS_IMAGE ./..
