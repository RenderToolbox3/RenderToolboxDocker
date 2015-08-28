FROM ninjaben/render-toolbox-docker-pbrt-v2-spectral:latest

MAINTAINER Ben Heasly <benjamin.heasly@gmail.com>

### clone PTB
WORKDIR /psychtoolbox
RUN git clone https://github.com/Psychtoolbox-3/Psychtoolbox-3.git

### clone RTB3
WORKDIR /render-toolbox
RUN git clone https://github.com/RenderToolbox3/RenderToolbox3

### clone Sphere Renderer toolbox
WORKDIR /sphere-renderer-toolbox
RUN git clone https://github.com/RenderToolbox3/SphereRendererToolbox.git

### add RenderToolbox3 config file
ADD RenderToolboxDockerConfig.m RenderToolboxDockerConfig.m

### let Matlab JVM use 2GB heap memory
ADD java.opts /usr/local/MATLAB/R2015a/bin/glnxa64/java.opts
