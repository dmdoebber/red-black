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
    python3-pip3    \
    git             \
    unzip
    
RUN pip3 install lab

WORKDIR /workspace/cerberus/

# Set up some environment variables.
ENV CXX g++
ENV BUILD_COMMIT_ID 821fad1

# Fetch the code at the right commit ID from the Github repo
#RUN curl -L https://github.com/ctpelok77/fd-red-black-postipc2018/archive/${BUILD_COMMIT_ID}.tar.gz | tar xz --strip=1



COPY file.zip /workspace/cerberus/

RUN unzip file.zip

# Invoke the build script with appropriate options
RUN python3 ./build.py -j4 release

# Strip the main binary to reduce size
#RUN strip --strip-all builds/release/bin/downward

CMD /bin/bash