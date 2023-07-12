# fedora:37 required for GCC 12.x, so as to prevent fortran compiler errors
FROM fedora:37
LABEL maintainer=woodwardsh

ENV HOME=/home/app
ENV OMPI_ALLOW_RUN_AS_ROOT=1
ENV OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1
WORKDIR ${HOME}

# --- Install dependencies (layer shared with exocam,rocke3d images) ---
RUN dnf install -y gcc gcc-gfortran git nano wget which xz netcdf.x86_64 netcdf-fortran.x86_64 netcdf-devel.x86_64 netcdf-fortran-devel.x86_64 openmpi.x86_64 openmpi-devel.x86_64

# Ensure mpif90 in path & set LD_LIBRARY_PATH for mk_diags
ENV PATH=$PATH:/usr/lib64/openmpi/bin
ENV LD_LIBRARY_PATH=/usr/lib64/openmpi/lib

# --- Install HEXTOR ---
RUN git clone --recurse-submodules https://github.com/BlueMarbleSpace/hextor.git

# Configure
# model/Makefile: update FC, WDIR; switching over FLAGS, FLAGSFFH from ifort to gfortran
# NB FLAGS addition is from `h5fc -show`
# runEBM.sh: update WDIR
RUN sed -i "s|^\(FC\s*=\).*|\1 /usr/bin/gfortran|" ${HOME}/hextor/model/Makefile && \
    sed -i "s|^\(WDIR\s*=\).*|\1 /home/app/hextor/model|" ${HOME}/hextor/model/Makefile && \
    sed -i "s|^FLAGS|_FLAGS|" ${HOME}/hextor/model/Makefile && \
    sed -i "s|^#\(FLAGS\(\s*\)=\(.*\)\)|\1 -I/usr/lib64/gfortran/modules -L/usr/lib64 -lhdf5hl_fortran -lhdf5_hl -lhdf5_fortran -lhdf5|" ${HOME}/hextor/model/Makefile && \
    sed -i "s|^#\(FLAGSFFH\(\s*\)=\(.*\)\)|\1|" ${HOME}/hextor/model/Makefile && \
    sed -i "s|^_FLAGS|#FLAGS|" ${HOME}/hextor/model/Makefile && \
    sed -i "s|^\(set wdir\s*=\s\).*|\1 /home/app/hextor|" ${HOME}/hextor/runEBM.sh && \
    mkdir ${HOME}/hextor/plots && \
    mkdir ${HOME}/hextor/model/out && \
    mkdir ${HOME}/hextor/shared
