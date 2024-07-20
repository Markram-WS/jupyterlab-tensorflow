# #===== gpu
# FROM tensorflow/tensorflow:latest-gpu

# # Install dependencies
# RUN apt-get update && apt-get clean 
# RUN apt-get update && apt-get install -y \
#     numactl \
#     libfreetype6-dev swig libgl1-mesa-glx libbox2d-dev \
#     libsdl2-dev libsdl2-ttf-dev libsdl2-image-dev libsdl2-mixer-dev libjpeg8-dev zlib1g-dev libportmidi-dev libx11-dev libxext-dev  xvfb x11-utils 

# ENV CUDNN_NAME=cudnn-linux-x86_64-8.9.6.50_cuda12-archive

# # Copy the cuDNN tar.xz file(s) to the Docker image
# COPY ./${CUDNN_NAME}.tar.xz /tmp/
# # Install xz-utils for handling xz-compressed files and extract the cuDNN archive using shell
# RUN apt-get update && \
#     apt-get install -y --no-install-recommends \
#     xz-utils && \
#     tar -xvf /tmp/${CUDNN_NAME}.tar.xz  -C /usr/local/ && \
#     cp -rv /usr/local/${CUDNN_NAME}/lib/ /usr/local/cuda-12.3/lib && \
#     cp -rv /usr/local/${CUDNN_NAME}/include/ /usr/local/cuda-12.3/include && \
#     rm -rf /usr/local/cuda-12 /usr/local/cuda /usr/local/${CUDNN_NAME}

# ENV PATH /usr/local/cuda-12.3/bin:$PATH
# ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-12.3/nvvm/libdevice/
# ENV XLA_FLAGS="--xla_gpu_cuda_data_dir=/usr/local/cuda-12.3"

#===== cpu
FROM tensorflow/tensorflow:latest 
#UBONTU 20.04
# Install necessary packages and set up MS SQL tools
RUN apt-get update && \
    apt-get install -y curl gnupg unixodbc-dev odbcinst && \
    curl https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc && \
    curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list | tee /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql18 && \
    ACCEPT_EULA=Y apt-get install -y mssql-tools18 && \
    echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc

# Install additional necessary packages
RUN apt-get update && apt-get install -y \
    numactl libfreetype6-dev swig libgl1-mesa-glx libbox2d-dev xserver-xephyr \
    libsdl2-dev libsdl2-ttf-dev libsdl2-image-dev libsdl2-mixer-dev libjpeg8-dev graphviz \
    zlib1g-dev libportmidi-dev libx11-dev libxext-dev xvfb x11-utils gcc-multilib \
    python3-dev libmysqlclient-dev build-essential pkg-config

# Clean up to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set environment variables for MySQL client and display
RUN python3 -m venv /venv
ENV PATH="/venv/bin:$PATH"

RUN python3 -m pip install --upgrade pip && \
pip install setuptools wheel \
pymysql \
ipywidgets \
tensorflow-probability \
scikit-learn \
pybind11 \
cython \
SQLAlchemy \
pygame==2.5.2 \
gymnasium \
pyodbc \
gymnasium[box2d] \
pyarrow \
pandas>=2.0.0 \
matplotlib \
xlsxwriter \
openpyxl \
numpy \
jupyterlab \
pyvirtualdisplay \
pymysql \
ray \
keras \
piglet \
fastparquet \
tensorboard \
deltalake \
pydot \
wandb


#CMD ["jupyter-lab", "--ip='0.0.0.0'","--port=8888", "--NotebookApp.token=''", "--NotebookApp.password=''","--allow-root"]