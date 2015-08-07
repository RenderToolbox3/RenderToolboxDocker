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

### Linux Flavors
The instructions here should work for Ubuntu.

The instructions *almost* work on Amazon Linux, but we would have to figure out how to install `aufs` on Amazon Linux, to support large Docker containers.  This is because the Matlab layer is very large, which is because Matlab is very large.

S for now, if you're choosing a Linux instance type, choose Ubuntu.

# Dependencies

On your local machine or cloud instance, you need to get a few dependencies.

First of all, you'll need at least 30GB of free space.

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
 - on amazon linux: it's already installed for you

Set up your AWS account and configure the command line tool with your credentials:
 - `aws configure`
 - # enter your credentials

To get this repository:
 - `git clone https://github.com/benjamin-heasly/render-toolbox-docker.git`
 - `cd render-toolbox-docker`

# 1. Matlab layer
The Matlab layer is unusual.  It's a docker image that I (Ben) created by interactively installing Matlab inside Docker.  The result is about 16GB, which is too big for normal Docker workflows involving Docker Hub.

Instead, I manually saved this image and put it on Amazon S3.

To get this image for yourself, you download the image and tell Docker to load it:
 - `aws s3 cp s3://render-toolbox-docker-matlab/docker-matlab-activated.tar docker-matlab-activated.tar`
 - `sudo docker load --input docker-matlab-activated.tar`
 - `rm docker-matlab-activated.tar`

The `docker load` step will fail if your Docker is not configured to handle large images.

Now Docker knows about our Matlab layer, which we will build upon in the next step.

# 2. Mitsuba layer
The Mitsuba layer will sit on top of the Matlab layer.  Building this layer will add the Mitsuba source code and two builds of Mitsuba -- one for multispectral rendering and one for RGB rendering.

The build may take many minutes because compiling Mitsuba takes a while, and we do it twice. 
 - `cd render-toolbox-docker/mitsuba`
 - `sudo docker build -t ninjaben/render-toolbox-docker-mitsuba:latest .`

This should result in source code and builds under the `/mitsuba` folder, as well as a few executable scripts in `/usr/local/bin`.

# 3. pbrt-v2-spectral layer
The pbrt-v2-spectral layer will sit on top of the Mitsuba layer.  Building this layer will add a multi-spectral variant of the PBRT source and a multi-spectral build of PBRT.

This build should only take a few minutes.
 - `cd render-toolbox-docker/pbrt-v2-spectral`
 - `sudo docker build -t ninjaben/render-toolbox-docker-pbrt-v2-spectral:latest .`
 
 This should result in source code and builds under the `/pbrt` folder, as well as an executable script in `/usr/local/bin`.

# 4. Psychtoolbox and RenderToolbox3 layer
The pbrt-rtb layer will sit on top of the pbrt-v2-spectral layer.  Building this layer will add Psychtoolbox, RenderToolbox3, and a RenderToolbox3 configuration script suitable for this Docker environment.

This build should only take a few minutes.
 - `cd render-toolbox-docker/ptb-rtb`
 - `sudo docker build -t ninjaben/render-toolbox-docker-ptb-rtb:latest .`

# Run it!
Once all four layers are in place, you should be able to launch a Docker container based on the last layer.

This should launch a docker container based on our last layer, and give you command line access inside it.
 - `sudo docker run -t -i --mac-address e4:ce:8f:60:8f:0a -v ~/render-toolbox:/home/docker/matlab/render-toolbox ninjaben/render-toolbox-docker-ptb-rtb:latest "/bin/bash"`

Note: the `--mac-address e4:ce:8f:60:8f:0a` part is necessary to work with our Matlab license.

Note: the `-v ~/render-toolbox:/home/docker/matlab/render-toolbox` part gives the Docker container access to the host file system.  This will allow you to access RenderToolbox3 outputs.

Once you're in, you should have command line access inside the Docker container.  Try launching Matlab.  The following command will launch a non-interactive Matlab session.  It should run some RenderToolbox3 configuration, render some tests scenes, then exit:
 - `matlab -nodesktop -nosplash -r "RenderToolboxDockerConfig, RenderToolbox3InstallationTest, exit"`

When this is done, you can exit the Docker container and let it shut down.
 - `exit`

# View the output
The test scene output should appear in your host file system in the folder `~/render-toolbox`.

If you're doing all this on your local workstation, you can go and look at the rendered images directly!

# Get the Output
If you're doing all this from a cloud instance, you need a way to download the rendered images before you can look at them.

You can push the rendered images to an Amazon S3 "bucket".  :
 - `cd ~`
 - `tar -czpf test-renderings.tar.gz render-toolbox/`
 - `aws s3 cp test-renderings.tar.gz s3://render-toolbox-test-output/docker/test-renderings.tar.gz`

Now you can easily download the `.tar` them from the S3 web interface.

Note: in this example, `render-toolbox-test-output` is an S3 "bucket", which I (Ben) have permission to write to.  You should create your own bucket ans use your own bucket name.  For example:
 - `aws s3 cp test-renderings.tar.gz s3://YOUR_OWN_BUCKET/docker/test-renderings.tar.gz`
