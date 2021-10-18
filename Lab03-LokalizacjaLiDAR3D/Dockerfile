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
        git wget libpcl-dev cmake libgoogle-glog-dev libatlas-base-dev libeigen3-dev libsuitesparse-dev ros-melodic-rviz && \
    rm -rf /var/lib/apt/lists/*

# CERES
RUN mkdir /ceres
WORKDIR /ceres
RUN wget http://ceres-solver.org/ceres-solver-1.14.0.tar.gz
RUN tar zxf ceres-solver-1.14.0.tar.gz
RUN mkdir ceres-bin
WORKDIR /ceres/ceres-bin
RUN cmake ../ceres-solver-1.14.0
RUN make -j3
#RUN make test
RUN make install

# CREATE CATKIN WS
RUN mkdir -p /catkin_ws/src/
WORKDIR /catkin_ws

# BUILD WORKSPACE
RUN /bin/bash -c ". /opt/ros/${ROS_DISTRO}/setup.bash; catkin_make"

# FILL BASHRC
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc
RUN echo "source /catkin_ws/devel/setup.bash" >> ~/.bashrc
