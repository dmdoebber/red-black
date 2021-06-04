# The recipe below implements a Docker multi-stage build:
# <https://docs.docker.com/develop/develop-images/multistage-build/>

###############################################################################
## First stage: an image to build the planner.
## 
## We'll install here all packages we need to build the planner
###############################################################################
FROM ubuntu:18.04 AS builder

RUN apt-get update && apt-get install --no-install-recommends -y \
    cmake           \
    ca-certificates \
    curl            \
    g++             \
    make            \
    python3         \
    python3-pip     \
    git             \
    unzip           \
    bison           \
    flex            \
    python
    
RUN pip3 install lab

WORKDIR /home/dmdoebber/

# Set up some environment variables.
ENV CXX g++

ENV DOWNWARD_REPO /home/dmdoebber/red-black
ENV DOWNWARD_BENCHMARKS /home/dmdoebber/benchmarks

COPY bin/ /home/dmdoebber/bin/

RUN git clone https://github.com/aibasel/downward-benchmarks.git benchmarks
RUN git clone https://github.com/dmdoebber/red-black.git

WORKDIR /home/dmdoebber/red-black

# Invoke the build script with appropriate options
RUN python3 ./build.py -j4 release

# Strip the main binary to reduce size
#RUN strip --strip-all builds/release/bin/downward

CMD /bin/bash