# Use a imagem base oficial do ROS2 Humble compatível com ARM
FROM ros:humble-ros-base

# Atualize os pacotes e instale dependências necessárias
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    build-essential \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Clone, compile e instale o Micro XRCE-DDS Agent
RUN git clone https://github.com/eProsima/Micro-XRCE-DDS-Agent.git /root/Micro-XRCE-DDS-Agent
RUN cd /root/Micro-XRCE-DDS-Agent && mkdir build && cd build && cmake .. && make && sudo make install && sudo ldconfig /usr/local/lib/
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
RUN echo "source install/local_setup.bash"

