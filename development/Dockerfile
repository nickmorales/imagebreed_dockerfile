FROM debian:bullseye

LABEL maintainer="nm529@cornell.edu"
LABEL main_version="9"

ENV CPANMIRROR=http://cpan.cpantesters.org
ENV TZ UTC

EXPOSE 8080

RUN mkdir -p /home/production/public/sgn_static_content \
    && mkdir -p /home/production/public/static_content \
    && mkdir -p /home/production/tmp/solgs \
    && mkdir -p /home/production/archive \
    && mkdir -p /home/production/public/images/image_files \
    && chown -R www-data /home/production/public \
    && mkdir -p /home/production/tmp \
    && chown -R www-data /home/production/tmp \
    && mkdir -p /home/production/archive/breedbase \
    && chown -R www-data /home/production/archive \
    && mkdir -p /home/production/blast/databases/current \
    && mkdir -p /home/production/cxgn \
    && mkdir -p /home/production/cxgn/local-lib \
    && mkdir -p /home/production/cache \
    && chown -R www-data /home/production/cache \
    && mkdir /etc/starmachine \
    && mkdir /etc/postfix \
    && mkdir /var/log/sgn \
    && touch /home/production/archive/image_analysis.log

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
    && apt-get update -y --allow-unauthenticated \
    && apt-get upgrade -y \
    && apt-get install build-essential pkg-config apt-utils gnupg2 curl -y \
    && apt-get update -y

COPY postfix.main.cf /etc/postfix/main.cf

RUN apt-get install -y aptitude
RUN aptitude install -y libterm-readline-zoid-perl nginx starman emacs gedit vim less sudo htop git dkms perl-doc ack-grep gcc g++ make xutils-dev nfs-common lynx xvfb ncbi-blast+ libmunge-dev libmunge2 munge slurm-wlm slurmctld slurmd libslurm-perl libssl-dev graphviz lsof imagemagick mrbayes muscle bowtie bowtie2 postfix mailutils libcupsimage2 libglib2.0-dev libglib2.0-bin screen apt-transport-https wget libnlopt-dev

# Required for R-package spdep, dependencies of agricolae
# Java for Tassel
RUN aptitude install libgdal-dev libproj-dev libgeos-dev libudunits2-dev dirmngr software-properties-common libgfortran-10-dev libicu-dev libgit2-dev -y \
    && aptitude install default-jre default-jdk -y

# Postgres 14
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list \
    && aptitude update -y \
    && apt-get upgrade -y \
    && aptitude -y install postgresql-14 postgresql-client-14

RUN curl -L https://cpanmin.us | perl - --sudo App::cpanminus

RUN chmod 777 /var/spool/ \
    && mkdir /var/spool/slurmstate \
    && chown slurm:slurm /var/spool/slurmstate/ \
    && ln -s /var/lib/slurm-llnl /var/lib/slurm

# R 4.2.0 -- keyservers: keys.gnupg.net, hkp://keyserver.ubuntu.com:80, keyserver.ubuntu.com
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7' \
    && add-apt-repository 'deb https://cloud.r-project.org/bin/linux/debian bullseye-cran40/' \
    && aptitude update -y \
    && aptitude install r-base r-base-dev libopenblas-base -y

# XML::Simple dependency: libexpat1-dev
# HTML::FormFu: libcatalyst-controller-html-formfu-perl
# Cairo Perl module needs this: libcairo2-dev
# GD Perl module needs this: libgd-dev
# postgres driver DBD::Pg needs this: libpq-dev
# MooseX::Runnable Perl module needs this: libmoosex-runnable-perl
RUN aptitude install -y libexpat1-dev libcatalyst-controller-html-formfu-perl libcairo2-dev libgd-dev libpq-dev libmoosex-runnable-perl libgdbm6 libgdm-dev

# INSTALL OPENCV IMAGING LIBRARY
RUN aptitude install -y python3-dev python3-pip python3-numpy
RUN aptitude install -y libgtk2.0-dev libgtk-3-0 libgtk-3-dev libavcodec-dev libavformat-dev libswscale-dev libhdf5-serial-dev libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libxvidcore-dev libatlas-base-dev gfortran exiftool libzbar-dev cmake

RUN aptitude install -y python3-virtualenv \
    && pip3 install virtualenv virtualenvwrapper \
    && python3 -m virtualenv --python=/usr/bin/python3 /home/production/cv \
    && . /home/production/cv/bin/activate \
    && /home/production/cv/bin/python3 -m pip install --upgrade pip \
    && pip3 install imutils matplotlib pillow statistics PyExifTool pytz pysolar scikit-image scikit-learn packaging pyzbar pandas tensorflow numpy rasterio \
    && pip3 install opencv-python \
    && pip3 install torch \
    && pip3 install -U keras-tuner \
    && pip3 install GDAL==$(gdal-config --version) --global-option=build_ext --global-option="-I/usr/include/gdal" \
    && pip3 install open3d

# Copy OPENCV code repos. Run the prepare.pl script to clone them before the build
# ADD repos_opencv /home/production/cxgn

# RUN . /home/production/cv/bin/activate \
#    && cd /home/production/cxgn/opencv \
#    && mkdir build \
#    && cd /home/production/cxgn/opencv/build \
#    && cmake -D CMAKE_BUILD_TYPE=RELEASE \
#        -D CMAKE_INSTALL_PREFIX=/usr/local \
#        -D INSTALL_PYTHON_EXAMPLES=ON \
#        -D OPENCV_EXTRA_MODULES_PATH=/home/production/cxgn/opencv_contrib/modules \
#        -D PYTHON3_EXECUTABLE=$(which python3) \
#        -D PYTHON3_NUMPY_INCLUDE_DIRS=$(python3 -c "import numpy; print(numpy.get_include())") \
#        -D BUILD_EXAMPLES=ON \
#        -D OPENCV_ENABLE_NONFREE=ON \
#        -D OPENCV_GENERATE_PKGCONFIG=YES .. \
#    && make -j 4 \
#    && make install \
#    && ldconfig

# RUN mv /usr/local/lib/python3.7/site-packages/cv2/python-3.7/cv2.cpython-37m-x86_64-linux-gnu.so /usr/local/lib/python3.7/site-packages/cv2/python-3.7/cv2.so \
#    && ln -s /usr/local/lib/python3.7/site-packages/cv2/python-3.7/cv2.so /home/production/cv/lib/python3.7/site-packages/cv2.so

# RUN python3 -m virtualenv --python=/usr/bin/python3 /home/production/mrcnn \
#    && . /home/production/mrcnn/bin/activate \
#    && pip3 install tensorflow==1.5.0 keras==2.1.5 "numpy<1.17" scipy matplotlib scikit-image Pillow cython h5py imgaug IPython[all] "six>=1.15.0" \
#    && git clone https://github.com/matterport/Mask_RCNN.git \
#    && cd Mask_RCNN \
#    #&& pip3 install -r requirements.txt \
#    && pip3 install "setuptools>=46.4.0" \
#    && python3 setup.py install

# INSTALL REML F90 SUITE
# RUN wget -r -np -R "index.html*" http://nce.ads.uga.edu/html/projects/programs/Linux/64bit_AMD/ \
#    && chmod 777 nce.ads.uga.edu/html/projects/programs/Linux/64bit_AMD/* \
#    && scp nce.ads.uga.edu/html/projects/programs/Linux/64bit_AMD/* /usr/local/bin
COPY tools/remlf90/* /usr/local/bin/

# INSTALL ASREML
# RUN mkdir -p /opt/vsn/asreml/4.x.0.b
# COPY tools/asreml /opt/vsn/asreml/4.x.0.b/
# RUN ln -s /opt/vsn/asreml/4.x.0.b /opt/vsn/asreml/latest \
#    && ln -s /opt/vsn/asreml/latest/bin/asreml.sh /bin/asreml \
#    && ln -s /opt/vsn/asreml/latest/bin/asreml_select.sh /bin/asreml_select

# Copy some tools that don't have a Debian package
COPY tools/gcta/gcta64  /usr/local/bin/
COPY tools/quicktree /usr/local/bin/
COPY tools/sreformat /usr/local/bin/

# Copy imagemagick policy with higher resource limits
COPY imagemagick_policy.xml /etc/ImageMagick-6/policy.xml

# Install Docker
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    && aptitude update \
    && aptitude install docker-ce -y

RUN curl -sL https://deb.nodesource.com/setup_16.x | sudo bash - \
    && aptitude install -y nodejs
#Specific version: npm install -g n \ && n 10.24.1

# Copy static_content for example drone imagery (AlfalfaExample35MeterMicasenseAerialDroneFlightRawCaptures.zip, ExampleColorAerialDroneFlightRawCaptures.zip, AgisoftMicasense10ChannelGrapesOrthomosaic.tif, RiceExampleRGBandDSMOrthophotosGeoTIFFs.zip not included in Git repo)
ADD public_static_content /home/production/public/static_content

# Copy code repos. Run the prepare.pl script to clone them before the build
ADD repos /home/production/cxgn/
ADD repos_dev /home/production/cxgn/

# RUN g++ /home/production/cxgn/DroneImageScripts/cpp/stitching_multi.cpp -o /usr/bin/stitching_multi `pkg-config opencv4 --cflags --libs` \
#    && g++ /home/production/cxgn/DroneImageScripts/cpp/stitching_single.cpp -o /usr/bin/stitching_single `pkg-config opencv4 --cflags --libs`

COPY sgn_local_docker.conf /home/production/cxgn/sgn/sgn_local.conf
COPY slurm.conf /etc/slurm/slurm.conf
COPY sgn_local_docker.conf /home/production/cxgn/sgn/
COPY starmachine.conf /etc/starmachine/

WORKDIR /home/production/cxgn/sgn

ENV PERL5LIB=/home/production/cxgn/local-lib/:/home/production/cxgn/local-lib/lib/perl5:/home/production/cxgn/sgn/lib:/home/production/cxgn/cxgn-corelibs/lib:/home/production/cxgn/Phenome/lib:/home/production/cxgn/Cview/lib:/home/production/cxgn/ITAG/lib:/home/production/cxgn/biosource/lib:/home/production/cxgn/tomato_genome/lib:/home/production/cxgn/Chado/chado/lib:/home/production/cxgn/Bio-Chado-Schema/lib:.

ENV HOME=/home/production
ENV PGPASSFILE=/home/production/.pgpass
RUN echo "R_LIBS_USER=/home/production/cxgn/R_libs" >> /etc/R/Renviron
ENV R_LIBS_USER=/home/production/cxgn/R_libs

COPY entrypoint.sh /entrypoint.sh
RUN ln -s /home/production/cxgn/starmachine/bin/starmachine_init.d /etc/init.d/sgn

# start services when running container...
ENTRYPOINT /bin/bash /entrypoint.sh
