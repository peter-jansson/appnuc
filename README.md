# appnuc
Applied nuclear physics relevant software.

![LGPL-3](https://www.gnu.org/graphics/lgplv3-with-text-154x68.png)

The Dockerfile can be used to build an Ubuntu based Docker image with a bunch of standard programs that are useful for scientific work in the field of applied nuclear physics. In addition, the following list of relevant software is installed.

* [Geant4](https://geant4.web.cern.ch/) monte carlo framework
* [Root](https://root.cern.ch/) data analysis framework
* [XCOM](https://dx.doi.org/10.18434/T48G6X) program from NIST

Docker hub contains the [latest image](https://hub.docker.com/r/jansson/appnuc) built using the Dockerfile, the image can pulled into the local Docker registry by the command `docker pull jansson/appnuc`.

The images can be started in a cointainer by, e.g., the command `docker run --rm -it jansson/appnuc bash -l`. Significantly more information on how to mount a local file system to the cointainer as well as other command line options is available in the [Docker documentation](https://docs.docker.com/engine/reference/commandline/cli/).
