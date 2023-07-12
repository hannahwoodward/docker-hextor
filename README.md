# HEXTOR Docker Image

[Docker](https://www.docker.com/)/[Podman](https://podman.io/) image to install and run a containerised HEXTOR on Fedora.


## Useful links

* [HEXTOR EBM repo](https://github.com/BlueMarbleSpace/hextor)
* [HEXTOR model description (doi:10.3847/PSJ/ac49eb)](https://doi.org/10.3847/PSJ/ac49eb)


## Roadmap

* Improve setup for better custom EBM configurations


## Installation & running via published image

* [Install Docker desktop](https://www.docker.com/get-started)
* Ensure Docker desktop is running
* Download published image:

```
docker pull woodwardsh/hextor:latest
```

* Run container:

```
docker run -it --rm --volume=${PWD}/shared:/home/app/hextor/shared woodwardsh/hextor:latest

# Options:
# -it       interactive && TTY (starts shell inside container)
# --rm      delete container on exit
# --volume  mount local directory inside container
```

* Follow instructions in [HEXTOR repo README](https://github.com/BlueMarbleSpace/hextor) from #3 onwards to configure and run the model. Note that a directory named `shared` has been mounted in the example above to allow copying over of custom files (e.g. namelists, lookup tables, etc) into the container.

### Podman

* Replace `docker` with `podman`, and note additional options to fix permissions on mounted volumes (see [podman run](https://docs.podman.io/en/latest/markdown/podman-run.1.html)):

```
podman run -it --rm -v ${PWD}/shared:/home/app/hextor/shared --security-opt label=disable woodwardsh/hextor:latest
```


## Installation & running via locally built image

* Clone repo & navigate inside:

```
git clone git@github.com:hannahwoodward/docker-hextor.git && cd docker-hextor
```

* Build image from Dockerfile (~15 min):

```
docker build -t hextor .
```

* Or, if debugging:

```
docker build -t hextor . --progress=plain --no-cache
```

* Run locally built container:

```
docker run -it --rm -v ${PWD}/shared:/home/app/hextor/shared hextor

# Options:
# -it       interactive && TTY (starts shell inside container)
# --rm      delete container on exit
# -v        mount local directory inside container
```

### Podman

* Build with similar command, replacing `docker` with `podman`:

```
podman build -t hextor .
```

* Run, with additional options to fix permissions on mounted volumes (see [podman run](https://docs.podman.io/en/latest/markdown/podman-run.1.html)):

```
podman run -it --rm -v ${PWD}/shared:/home/app/shared --security-opt label=disable hextor
```


## Publishing image

```
docker login && docker tag hextor woodwardsh/hextor && docker push woodwardsh/hextor
```
