FROM ninjaben/render-toolbox-docker-pbrt-v2-spectral:latest

MAINTAINER Ben Heasly <benjamin.heasly@gmail.com>

### clone PTB
RUN git clone https://github.com/Psychtoolbox-3/Psychtoolbox-3.git

### clone RTB3
RUN git clone https://github.com/DavidBrainard/RenderToolbox3

### add config file
ADD RenderToolboxDockerConfig.m RenderToolboxDockerConfig.m

### configure RTB3
RUN matlab -nospash -nodesktop -r RenderToolboxDockerConfig
