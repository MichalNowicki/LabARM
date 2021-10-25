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
        git wget libpcl-dev cmake libgoogle-glog-dev libatlas-base-dev libeigen3-dev libsuitesparse-dev ros-melodic-rviz git && \
    rm -rf /var/lib/apt/lists/*

# PANGOLIN
RUN git clone --recursive https://github.com/stevenlovegrove/Pangolin.git
WORKDIR /Pangolin
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
RUN git clone https://github.com/UZ-SLAMLab/ORB_SLAM3.git ORB_SLAM3
WORKDIR ORB_SLAM3
RUN git fetch origin pull/382/head:pr382
RUN git checkout pr382
RUN cat build.sh | head -n -1 >  build2.sh
RUN chmod +x build2.sh
RUN ./build2.sh
WORKDIR /ORB_SLAM3/build
RUN make -j4

# CREATE CATKIN WS
RUN mkdir -p /catkin_ws/src/
WORKDIR /catkin_ws

# BUILD WORKSPACE
RUN /bin/bash -c ". /opt/ros/${ROS_DISTRO}/setup.bash; catkin_make"

# FILL BASHRC
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc
RUN echo "source /catkin_ws/devel/setup.bash" >> ~/.bashrc
