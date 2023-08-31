FROM ubuntu:20.04
MAINTAINER fil-cry

ENV DEBIAN_FRONTEND noninteractive

# Install most of the tools from Ubuntu packages
RUN set -ex ;\
	apt-get update &&  apt-get -y --no-install-recommends install \
		# No need to install the platform-tools (android-tools-adb, android-tools-fastboot). Yet...
		# Install the build packages
		bc \
		bison \
		build-essential \
		ccache \
		curl \
		flex \
		g++-multilib \
		gcc-multilib \
		git \
		git-lfs \
		gnupg \
		gperf \
		imagemagick \
		lib32ncurses5-dev \
		lib32readline-dev \
		lib32z1-dev \
		libelf-dev \
		liblz4-tool \
		libncurses5 \
		libncurses5-dev \
		libsdl1.2-dev \
		libssl-dev \
		libxml2 \
		libxml2-utils \
		lzop \
		pngcrush \
		rsync \
		schedtool \
		squashfs-tools \
		xsltproc \
		zip \
		zlib1g-dev \
		# No need to install the java/jdk, as it is embedded in android sources since lineageOs 16.0
		# Install python3
		python3 \
		# No repo package available in focal, but repo requires less and ssh commands, and the curl to download repo requires ca-certificates
		bash-completion \
		ca-certificates \
		less \
		openssh-client \
		# Other tools required to setup the container, or at certain build steps, or for comfort
		unzip && \
		# Cleaning
		apt-get clean && \
		rm -rf /var/lib/apt/lists/* && \
		rm -rf /tmp/* && \
		rm -rf /var/tmp/*
    
# Install other tools or configuration
RUN set -ex ;\
	# Set 'python3' as 'python' command
    ln -s /usr/bin/python3 /usr/bin/python && \
	# Install repo tool: download the tool from google repo, then runs an init so that it download its own up to date release. And finally installs the up to date one.
    git config --global user.email "you@example.com" && \
    git config --global user.name "Your Name" && \
    git config --global color.ui true && \
    export REPO=$(mktemp /tmp/repo.XXXXXXXXX) && \
    curl -o ${REPO} https://storage.googleapis.com/git-repo-downloads/repo && \
    chmod a+x ${REPO}  && \
    cd /tmp  && \
    ([[ $(${REPO} init) ]] || echo) && \    
    cp /tmp/.repo/repo/repo /usr/bin/repo && \
    cd / && \
    rm ${REPO} && \
    rm -rf /tmp/.repo

# Optional, for container debbuging : adds sudo, vim, ...
RUN set -ex ;\
    apt-get update && apt-get -y --no-install-recommends install \
		sudo \
		vim && \
    echo "lineage ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
	echo "alias ll='ls -la --color'" >> /etc/bash.bashrc

ENV DEBIAN_FRONTEND=dialog

# Add user lineage and setup its environment (env variable to setup ccache at startup, source envsetup.sh, startup message, ...)
RUN set -ex ;\
	useradd -m --shell /bin/bash lineage && \
	echo "" >> /home/lineage/.profile && \
	echo "# Custom settings for the container user" >> /home/lineage/.bashrc && \
	echo "source ~/.profile-lineage" >> /home/lineage/.bashrc
COPY --chown=lineage:lineage --chmod=644 home.lineage /home/lineage
USER lineage
WORKDIR /lineage

CMD ["bash"]
