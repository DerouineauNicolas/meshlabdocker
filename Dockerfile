FROM ubuntu:16.04

RUN apt-get update

RUN apt-get update && apt-get install -q -y \
    build-essential \
    python \
    python-numpy \
    git \
    g++ \
    qt5-qmake \
    qtscript5-dev \
    libqt5xmlpatterns5-dev \
    libqt5opengl5-dev \
    assimp-utils \
    nano \
    xvfb\
    libomp-dev\
    clang-5.0 \
    && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/clang-5.0  /usr/bin/clang
RUN ln -s /usr/bin/clang++-5.0 /usr/bin/clang++ 

RUN git clone https://github.com/cnr-isti-vclab/vcglib  -b devel /devel/vcglib
RUN git clone https://github.com/cnr-isti-vclab/meshlab /devel/meshlab


#ARG QMAKE_FLAGS="-spec linux-clang CONFIG+=release CONFIG+=qml_release CONFIG+=c++11 QMAKE_CXXFLAGS+=-fPIC QMAKE_CXXFLAGS+=-std=c++11 QMAKE_CXXFLAGS+=-fpermissive INCLUDEPATH+=/usr/include/eigen3 LIBS+=-L/meshlab/src/external/lib/linux-g++"
ARG MAKE_FLAGS="-j 2"
ARG QMAKESPEC="linux-clang" 

WORKDIR /devel/meshlab/src/external
RUN qmake -qt=5 $QMAKE_FLAGS && make $MAKE_FLAGS

RUN qmake -qt=5 --version 

RUN echo "----------"

WORKDIR /devel/meshlab/src
#RUN  qmake -qt=5 meshlab_mini.pro $QMAKE_FLAGS && make $MAKE_FLAGS
RUN qmake -qt=5 meshlab_full.pro $QMAKE_FLAGS && make $MAKE_FLAGS
ENV PATH="/devel/meshlab/src/distrib:${PATH}"
