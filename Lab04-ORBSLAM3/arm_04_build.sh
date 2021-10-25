xhost +local:root

# BUILD THE IMAGE
ROS_IMAGE="arm/image04"
docker build -f Dockerfile -t $ROS_IMAGE ./..
