FROM ros:melodic-perception

# SETUP ENVS
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV NVIDIA_VISIBLE_DEVICES ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

# INSTALL SOME ESSENTIAL PROGRAMS
RUN apt-get update     && \
    apt-get install -y    \
        git wget libpcl-dev cmake libgoogle-glog-dev libatlas-base-dev libeigen3-dev libsuitesparse-dev ros-melodic-rviz git eog python-matplotlib && \
    rm -rf /var/lib/apt/lists/*

# PANGOLIN
RUN git clone --recursive https://github.com/stevenlovegrove/Pangolin.git
WORKDIR /Pangolin
RUN git reset --hard 69b79ad
RUN cat ./scripts/install_prerequisites.sh | head -n -1 > ./scripts/install_prerequisites2.sh
RUN echo '$SUDO $MANAGER -y ${PKGS_OPTIONS[*]} ${PACKAGES[*]}' >> ./scripts/install_prerequisites2.sh
RUN chmod +x ./scripts/install_prerequisites2.sh
RUN apt-get update && ./scripts/install_prerequisites2.sh recommended
RUN mkdir build
WORKDIR /Pangolin/build
RUN cmake ..
RUN cmake --build . -- -j4

# OPENCV
RUN apt-get install libopencv-dev python3-opencv

# EIGEN
RUN apt-get install libeigen3-dev

# ORBSLAM3
WORKDIR /
RUN git clone https://github.com/MichalNowicki/ORB_SLAM3.git
WORKDIR /ORB_SLAM3
RUN chmod +x build.sh
RUN ./build.sh

# CREATE CATKIN WS
RUN mkdir -p /catkin_ws/src/

# BUILD ROS WORKSPACE
WORKDIR /catkin_ws/
RUN /bin/bash -c ". /opt/ros/${ROS_DISTRO}/setup.bash;catkin_make"

# BUILD ORBSLAM3 ROS
WORKDIR /ORB_SLAM3/
RUN mkdir -p /ORB_SLAM3/Examples/ROS/ORB_SLAM3/build
WORKDIR /ORB_SLAM3/Examples/ROS/ORB_SLAM3/build
RUN /bin/bash -c "source /opt/ros/melodic/setup.bash;export ROS_PACKAGE_PATH=/opt/ros/melodic/share:/ORB_SLAM3/Examples/ROS;cmake .. -DROS_BUILD_TYPE=Release;make -j4"

# FILL BASHRC
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc
RUN echo "source /catkin_ws/devel/setup.bash" >> ~/.bashrc
RUN echo "export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:/ORB_SLAM3/Examples/ROS" >> ~/.bashrc

# FINAL WORKSPACE
WORKDIR /ORB_SLAM3
