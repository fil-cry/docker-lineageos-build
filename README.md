# docker-lineageos

A docker container to build [LineageOS](https://lineageos.org/) 20.0

The goal is to have an environment, easy to setup on any host, to build LineageOS 20.0 roms.  
The container is started in interactive mode to manually run the build commands.  
At startup, it creates the `worker` user and opens a shell as this user.  
The user is created using the same uid and gid as the user that is running the container on the host.  
The purpose is to give to `worker` the ability to update the `lineage` folder, as would do its owner on the host.  

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
$ docker run -it --rm --privileged -e WUID=$(id -u) -e WGID=$(id -g) \
  -v /etc/localtime:/etc/localtime:ro \
  --hostname "$(hostname)-lineageos-builder" \
  -v "$(pwd)/.ccache":/ccache \
  -v "$(pwd)/lineage":/lineage \
  docker-lineageos-build
```

* the --privileged option is required so that nsjail to execute properly. This prevents sandbox building to be disabled. 
* the --hostname option is defined to have a fixed hostname in the container and prevent regenereting the kernel and model specific stuff.
* the localtime bind volume is not required. Just less confusing when the modification time of a file in the container is displayed within the same timezone than its host.
* the 2 main bind volumes are
* * the ccache directory
* * the lineageos source directory
* the 2 env parameters WUID and WGID are the id to set to the worker group and user
* an optional '-e USE_CCACHE=0' can be added to disable ccache in the container. Ccache is enable by default.

When it exists, `/lineage/build/envsetup.sh` is loaded during shell login through the worker's profile file.

Once the worker is started, you can run any lineage build command. See any [build instructions](https://wiki.lineageos.org/devices/beryllium/build) from LineageOS wiki. Eg:
```shell
$ repo init <...>
$ repo sync
$ breakfast <...> 
$ lunch lineage_beryllium-user
$ brunch <...> 
$ hmm
```

## License
GPLv3 (see [LICENSE](LICENSE))
