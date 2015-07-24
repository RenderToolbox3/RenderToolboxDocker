# render-toolbox-docker
Dockerfile and instructions for setting up RenderToolbox3 inside Docker

# Greetings!

This repository contains a few Dockerfiles and other configuration for getting RenderToolbox3 to run inside Docker.

There are a few Dockerfiles organized as layers.  These are intended to separate the configuration of various parts.  They layers are:
 1. Matlab
 1. Mitsuba
 1. pbrt-v2-spectral
 1. Psychtoolbox and RenderToolbox3
 
You'll have to download or build the layers in order, before you can finally live the Docker dream.  After you do this once, Docker will have all the layers it needs cached locally, so you can reuse them quickly.

If you are running Docker in the cloud, you should do all this once, then save a machine image (like an AMI on Amazon) so that you can have all these layers cached locally in that machine image.  This should allow you to quickly fire up rendering and image processing in the cloud.

The instructions below should work for Ubuntu and Amazon Linux.

# Dependencies

You need to get a few dependencies for this to work.

To get Docker:
 - [install Docker](https://docs.docker.com/installation/)
   - on ubuntu (might be out-dated, here is an [alternative](https://github.com/DavidBrainard/RenderToolboxDevelop/wiki/Matlab-on-Docker-and-EC2#ssh-to-ec2-instance-and-install-docker-with-support-for-large-containers)): `sudo apt-get install docker docker.io`
   - on amazon linux: `sudo yum install docker`
 - `sudo service docker start`

To get Git: 
 - [install Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
   - on ubuntu: `sudo apt-get install git`
   - on amazon linux: `sudo yum install git`

To get the Amazon command line tool (Ubuntu only)
 - sudo apt-get install python-pip
 - sudo pip install awscli

Amazon linux has the command line tool already.

Set up your AWS account and configure the command line tool with your credentials:
 - `aws configure`
 - # enter your credentials

To get this repository:
 - `git clone https://github.com/benjamin-heasly/render-toolbox-docker.git`
 - `cd render-toolbox-docker`

# 1. Matlab layer

# 2. Mitsuba layer

# 3. pbrt-v2-spectral layer

# 4. Psychtoolbox and RenderToolbox3 layer

# Run it!
