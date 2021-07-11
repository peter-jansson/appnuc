apt-get update

DEBIAN_FRONTEND=noninteractive apt-get install -y \
    alpine \
    apt-utils \
    bash \
    bc \
    binutils \
    cmake \
    curl \
    doxygen \
    ffmpeg \
    fossil \
    git \
    gfortran-11 \
    gnuplot \
    g++-11 \
    libboost-all-dev \
    libcanberra-gtk-module \
    libcurl4-openssl-dev \
    libgl1-mesa-glx \
    libssl-dev \
    libx11-dev \
    libxext-dev \
    libxft-dev \
    libxpm-dev \
    make \
    mercurial \
    mesa-utils \
    openssh-server \
    openssl \
    postgresql-server-dev-13 \
    python3 \
    python3-lmfit \
    python3-matplotlib \
    python3-numpy \
    python3-pandas \
    python3-pip \
    python3-reportlab \
    python3-scipy \
    python3-sklearn \
    python3-sklearn-pandas \
    python3-tk \
    python3-venv \
    r-base \
    r-base-dev \
    r-cran-rsqlite \
    rsync \
    software-properties-common \
    tmux \
    vim \
    vim-gtk \
    freeglut3-dev \
    libmotif-dev \
    xorg \
    xorg-dev \
    xserver-xorg-video-nvidia-390

rm -rf /var/lib/apt/lists/*

apt-get clean

echo 'mkdir -p ~/.local/share' > /etc/profile.d/avoid-harmless-gvim-warning.sh
