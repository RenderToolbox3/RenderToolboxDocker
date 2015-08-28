FROM ninjaben/render-toolbox-docker-pbrt-v2-spectral:latest

MAINTAINER Ben Heasly <benjamin.heasly@gmail.com>

### clone PTB
WORKDIR /psychtoolbox
RUN git clone https://github.com/Psychtoolbox-3/Psychtoolbox-3.git

### clone RTB3
WORKDIR /render-toolbox
RUN git clone https://github.com/RenderToolbox3/RenderToolbox3

### add config file
ADD RenderToolboxDockerConfig.m RenderToolboxDockerConfig.m
