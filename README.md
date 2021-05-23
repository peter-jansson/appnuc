# appnuc
Applied nuclear physics relevant software.

![LGPL-3](https://www.gnu.org/graphics/lgplv3-with-text-154x68.png)

An Ubuntu based image/container with a bunch of standard programs that are useful for scientific work in the field of applied nuclear physics. In addition, the following list of relevant software is installed.

* [Geant4](https://geant4.web.cern.ch/) monte carlo framework
* [Root](https://root.cern.ch/) data analysis framework
* [XCOM](https://dx.doi.org/10.18434/T48G6X) program from NIST

## Docker
Docker hub contains the [image](https://hub.docker.com/r/jansson/appnuc) built using the Dockerfile, which can pulled into the local Docker registry by the command `docker pull jansson/appnuc`.

The image can be started in a container by, e.g., the command `docker run --rm -it jansson/appnuc bash -l`. Significantly more information on how to mount a local file system to the container as well as other command line options is available in the [Docker documentation](https://docs.docker.com/engine/reference/commandline/cli/).

## Singularity
A [Singularity](https://sylabs.io/) file containing the same containerized Ubuntu and software can be built using the Singularity definition file, named `Singularity`. E.g. using the command `sudo singularity build appnuc.sif Singularity` to build `appnuc.sif`.

See the [Singularity user guide](https://sylabs.io/guides/3.7/user-guide/) for more information.
