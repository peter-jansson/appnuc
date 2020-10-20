FROM jansson/pj as base_1

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
       alpine \
       apt-utils \
       bash \
       bc \
       binutils \
       build-essential \
       cmake \
       curl \
       doxygen \
       ffmpeg \
       fossil \
       git \
       gnuplot \
       libboost-all-dev \
       libcanberra-gtk-module \
       libcurl4-openssl-dev \
       libssl-dev \
       libx11-dev \
       libxext-dev \
       libxft-dev \
       libxpm-dev \
       mercurial \
       openssh-server \
       openssl \
       python3 \
       python3-pip \
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
       wget \
       freeglut3-dev \
       libmotif-dev \
       xorg \
       xorg-dev \
       && rm -rf /var/lib/apt/lists/*
# Install some Python libraries that are useful.
RUN pip3 install bumps dropbox cx_Oracle lmfit matplotlib numpy pandas reportlab scipy \
       && rm -rf /root/.cache
# To get rid of harmless warnings from gvim.
RUN mkdir -p /root/.local/share

#------------------------------------------------------------------------------
FROM base_1 AS base_2

# Install Dropbox and the script to control it.
RUN cd ~ && wget --no-hsts -q -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
RUN curl -s -o /usr/bin/dropbox.py "https://www.dropbox.com/download?dl=packages/dropbox.py" && chmod a+x /usr/bin/dropbox.py
RUN echo "echo Please run ~/.dropbox-dist/dropboxd to start the Dropbox daemon. You will be prompted to link your account." > /etc/profile.d/greeting.sh


#-------------------------------------------------------------------------------
# Build and install the Geant4 simulation toolkit.
# http://geant4.cern.ch/

FROM base_2 AS geant4_base

ENV GEANT4_VERSION 10.06.p02

#-------------------------------------------------------------------------------
FROM geant4_base AS geant4_build

WORKDIR /tmp/geant4/source

RUN curl -s -S -o geant4.${GEANT4_VERSION}.tar.gz \
   http://geant4-data.web.cern.ch/geant4-data/releases/geant4.${GEANT4_VERSION}.tar.gz
RUN tar -xzf geant4.${GEANT4_VERSION}.tar.gz

WORKDIR /tmp/geant4/build

RUN cmake /tmp/geant4/source/geant4.${GEANT4_VERSION} \
       -DCMAKE_INSTALL_PREFIX=/usr/local/geant4.${GEANT4_VERSION} \
       -DGEANT4_USE_SYSTEM_EXPAT=OFF \
       -DGEANT4_BUILD_MULTITHREADED=ON \
       -DGEANT4_INSTALL_DATA=ON \
       -DGEANT4_USE_OPENGL_X11=ON \
       -DGEANT4_USE_RAYTRACER_X11=ON \
       -DGEANT4_USE_XM=ON

RUN \
   make && \
   make install && \
   echo ". /usr/local/geant4.${GEANT4_VERSION}/bin/geant4.sh" >> /etc/profile.d/geant4.sh && \
   echo ". \${G4NEUTRONHPDATA}/../../geant4make/geant4make.sh" >> /etc/profile.d/geant4.sh

#-------------------------------------------------------------------------------
FROM geant4_base AS geant4_installed
COPY --from=geant4_build /usr/local/geant4.${GEANT4_VERSION} /usr/local/geant4.${GEANT4_VERSION}
COPY --from=geant4_build /etc/profile.d/geant4.sh /etc/profile.d

#-------------------------------------------------------------------------------
# Install pre-compiled Root.
FROM geant4_installed AS root_install
WORKDIR /tmp
ENV ROOT root_v6.22.02
RUN wget --no-hsts -q https://root.cern/download/${ROOT}.Linux-ubuntu20-x86_64-gcc9.3.tar.gz -O ${ROOT}.tar.gz
RUN tar -xzf ${ROOT}.tar.gz
RUN mv root /usr/local/${ROOT}
RUN echo ". /usr/local/${ROOT}/bin/thisroot.sh" >> /etc/profile.d/${ROOT}.sh

FROM geant4_installed AS root_installed
ENV ROOT root_v6.22.02
COPY --from=root_install /usr/local/${ROOT} /usr/local/${ROOT}
COPY --from=root_install /etc/profile.d/${ROOT}.sh /etc/profile.d

#-------------------------------------------------------------------------------
# Enable access to the ssh server, enable and configure root login.
# Inspiration from https://docs.docker.com/engine/examples/running_ssh_service/#run-a-test_sshd-container
RUN echo "root:password" | chpasswd
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && echo "AddressFamily inet" >> /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
# https://askubuntu.com/questions/1110828/ssh-failed-to-start-missing-privilege-separation-directory-var-run-sshd
RUN systemd-tmpfiles --create
EXPOSE 22

WORKDIR /root
CMD ["/usr/sbin/sshd", "-D"]
