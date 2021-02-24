FROM jansson/pj as base_1

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
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
       postgresql-server-dev-12 \
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
RUN pip3 install bumps dropbox cx_Oracle lmfit matplotlib numpy pandas \
    reportlab scipy \
    && rm -rf /root/.cache
# To get rid of harmless warnings from gvim.
RUN mkdir -p /root/.local/share

#-------------------------------------------------------------------------------
# Build and install the Geant4 simulation toolkit.
# http://geant4.cern.ch/

FROM base_1 AS geant4_base

ENV G4 geant4.10.07.p01

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
FROM geant4_base AS geant4_build

WORKDIR /tmp
RUN curl -s -S -o ${G4}.tar.gz \
    https://geant4-data.web.cern.ch/releases/${G4}.tar.gz
RUN tar -xzf ${G4}.tar.gz

WORKDIR /build
RUN cmake /tmp/${G4} \
       -DCMAKE_BUILD_TYPE:STRING=Release \
       -DCMAKE_INSTALL_PREFIX=/usr/local/${G4} \
       -DGEANT4_USE_SYSTEM_EXPAT=OFF \
       -DGEANT4_BUILD_MULTITHREADED=ON \
       -DGEANT4_INSTALL_DATA=ON \
       -DGEANT4_USE_OPENGL_X11=ON \
       -DGEANT4_USE_RAYTRACER_X11=ON \
       -DGEANT4_USE_XM=ON
RUN cmake --build /build -j $(expr $(nproc) - 1) --config Release
RUN cmake --install /build --config Release --strip
RUN echo ". /usr/local/${G4}/bin/geant4.sh" > /etc/profile.d/${G4}.sh
RUN echo ". \${G4LEDATA}/../../geant4make/geant4make.sh" \
        >> /etc/profile.d/${G4}.sh

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
FROM geant4_base AS geant4_installed
COPY --from=geant4_build /usr/local/${G4} /usr/local/${G4}
COPY --from=geant4_build /etc/profile.d/${G4}.sh /etc/profile.d

#-------------------------------------------------------------------------------
# Install pre-compiled Root.

ENV ROOT root_v6.22.06

FROM geant4_installed AS root_install
WORKDIR /tmp
RUN wget -q \
    https://root.cern/download/${ROOT}.Linux-ubuntu20-x86_64-gcc9.3.tar.gz \
    -O ${ROOT}.tar.gz
RUN tar -xzf ${ROOT}.tar.gz
RUN mv root /usr/local/${ROOT}

FROM geant4_installed AS root_installed
COPY --from=root_install /usr/local/${ROOT} /usr/local/${ROOT}
RUN echo ". /usr/local/${ROOT}/bin/thisroot.sh" > /etc/profile.d/${ROOT}.sh

#-------------------------------------------------------------------------------
# Download, build and install the XCOM program from NIST.

FROM root_installed AS xcom_install
WORKDIR /usr/local
RUN wget -q https://physics.nist.gov/PhysRefData/Xcom/XCOM.tar.gz
RUN tar -xzf XCOM.tar.gz
WORKDIR /usr/local/XCOM
RUN gfortran -std=legacy XCOM.f -o XCOM

FROM root_installed AS xcom_installed
COPY --from=xcom_install /usr/local/XCOM /usr/local/XCOM

#-------------------------------------------------------------------------------
# Enable access to the ssh server, enable and configure root login.
RUN echo "root:password" | chpasswd
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
    && echo "AddressFamily inet" >> /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed \
   's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' \
   -i /etc/pam.d/sshd
# https://jansson.net/url/?h=f5968229
RUN systemd-tmpfiles --create
EXPOSE 22

WORKDIR /root
COPY docker-entrypoint.sh /
RUN chmod u+x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
