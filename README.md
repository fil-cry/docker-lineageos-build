# docker-lineageos

A docker container to build [LineageOS](https://lineageos.org/) 20.0

The goal is to have an environment, easy to setup on any platform, to build LineageOS 20.0 roms.  
The container is started in interactive mode to manually run the build commands.  

<!-- MDTOC maxdepth:6 firsth1:0 numbering:0 flatten:0 bullets:1 updateOnSave:1 -->

- [Build the container](#build-the-container)
- [Start the build environment](#start-the-build-environment)

<!-- /MDTOC -->

## Build the container

```shell
$ docker build -t docker-lineageos-build .
```

## Start the build environment

```shell
$ docker run -it --privileged \
  -v /etc/localtime:/etc/localtime:ro \
  --hostname "$(hostname)-lineageos-builder" \
  -v "$(pwd)/.ccache":/ccache \
  -v "$(pwd)/lineage":/lineage \
  docker-lineageos-build
```

* the --privileged option is required to give to the container capabilities that allows nsjail to execute propely, and prevent sandbox building to be disabled. 
* the --hostname option is defined to have a fixed hostname in the container and prevent regenereting the kernel and model specific stuff.
* the localtime bind volume is not required. Just less confusing when the modification time of a file in the container is displayed within the same timezone than its host.
* the 2 main bind volumes are
* * the ccache directory
* * the lineageos source directory

With appropriate path on host for ccache and lineage sources.  
/lineage/build/envsetup.sh is initially loaded from ~/.profile-docker-lineageos
Then run any command   lunch cmd, eg.
```shell
$ lunch lineage_beryllium-user
```

## License
GPLv3 (see [LICENSE](LICENSE))
