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
   - on ubuntu: make sure Docker is up to date and able to accommodate large images.  We have some instructions [here](https://github.com/DavidBrainard/RenderToolboxDevelop/wiki/Matlab-on-Docker-and-EC2#ssh-to-ec2-instance-and-install-docker-with-support-for-large-containers)).
   - on amazon linux: `sudo yum install docker`
 - `sudo service docker start`

To get Git: 
 - [install Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
   - on ubuntu: `sudo apt-get install git`
   - on amazon linux: `sudo yum install git`

To get the Amazon command line tool
 - on ubuntu:
   - `sudo apt-get install python-pip`
   - `sudo pip install awscli`
 - on amazon linux: already installed

Amazon linux has the command line tool already.

Set up your AWS account and configure the command line tool with your credentials:
 - `aws configure`
 - # enter your credentials

To get this repository:
 - `git clone https://github.com/benjamin-heasly/render-toolbox-docker.git`
 - `cd render-toolbox-docker`

# 1. Matlab layer
The Matlab layer is unusual.  It's a docker image that I (Ben) created by interactively installing Matlab inside Docker.  The result is about 16GB, which is too big for normal Docker workflows involving Docker Hub.

Instead, I manually saved this image and put it on Amazon s3.

To get this image for yourself, you download the image and tell Docker to load it:
 - `aws s3 cp s3://render-toolbox-docker-matlab/docker-matlab-activated.tar docker-matlab-activated.tar`
 - `sudo docker load --input docker-matlab-activated.tar`
 - `rm docker-matlab-activated.tar`

Now Docker knows about our Matlab layer, which we will build upon in the next step.

# 2. Mitsuba layer
This layer might already live on Docker Hub.  In that case, you're all set!

If not, here's how to build it.  Note that these instructions use my (Ben's) Docker Hub account name `ninjaben`.  You might need to change this to your own account name.
 - `cd render-toolbox-docker/mitsuba`
 - `sudo docker build -t ninjaben/render-toolbox-docker-mitsuba:latest .`
 - `sudo docker login`
 - # enter Docker Hub credientials
 - `sudo docker push ninjaben/render-toolbox-docker-mitsuba:latest`

# 3. pbrt-v2-spectral layer
This layer might already live on Docker Hub.  In that case, you're all set!

If not, here's how to build it.  Note that these instructions use my (Ben's) Docker Hub account name `ninjaben`.  You might need to change this to your own account name.
 - `cd render-toolbox-docker/pbrt-v2-spectral`
 - `sudo docker build -t ninjaben/render-toolbox-docker-pbrt-v2-spectral:latest .`
 - `sudo docker login`
 - # enter Docker Hub credientials
 - `sudo docker push ninjaben/render-toolbox-docker-pbrt-v2-spectral:latest`

# 4. Psychtoolbox and RenderToolbox3 layer
This layer might already live on Docker Hub.  In that case, you're all set!

If not, here's how to build it.  Note that these instructions use my (Ben's) Docker Hub account name `ninjaben`.  You might need to change this to your own account name.
 - `cd render-toolbox-docker/ptb-rtb`
 - `sudo docker build -t ninjaben/render-toolbox-docker-ptb-rtb:latest .`
 - `sudo docker login`
 - # enter Docker Hub credientials
 - `sudo docker push ninjaben/render-toolbox-docker-ptb-rtb:latest`

# Run it!
Once all the layers are in place, you should be able to launch a Docker container with all the pieces in place for RenderToolbox3.
 - `sudo docker run -t -i --mac-address e4:ce:8f:60:8f:0a ninjaben/matlab:activated "/bin/bash"`

Depending on how you got here, Docker might take some time to download the other layers.

Once you're in, you should have command line access inside the Docker container.  Try launching Matlab with a RenderToolbox3 command:
 - `matlab -nodesktop -nosplash -r "RenderToolbox3InstallationTest"`

It should render some tests scenes!
