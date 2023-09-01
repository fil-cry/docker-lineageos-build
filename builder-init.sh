#!/bin/bash

# customize prompt colors
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;35m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"

# setup minimal git config
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
git config --global color.ui true

# Enable ccache, unless the container is started with an ENV variable USE_CCACHE != 1
export CCACHE_DIR=/ccache
export CCACHE_EXEC=$(which ccache)
if [ -z ${USE_CCACHE} ] ; then
	export USE_CCACHE=1
elif [ ${USE_CCACHE} != 1 ] ; then
	export USE_CCACHE=0
fi
# set default ccache max size to 50G if ts not configured in /ccache yet
if [ -n ${USE_CCACHE} ] && [ ${USE_CCACHE} == 1 ] && ( [ ! -e /ccache/ccache.conf ] || ! $(grep -q max_size /ccache/ccache.conf) ) ; then
	ccache -M 50G
fi

# source envsetup.sh
if [ -f /lineage/build/envsetup.sh ]; then
	. /lineage/build/envsetup.sh
	env_setup_loaded=yes
else
    env_setup_loaded=
fi

source /lineage/build/envsetup.sh

# startup message
#clear
echo
echo -e '##################################################'
echo -e '#                                                #'
echo -e '#      This container is designed to build       #'
echo -e '#                lineageos 20.0                  #'
echo -e '#                                                #'
if [ -n "$env_setup_loaded" ]; then
	echo -e '# \033[01;34m\e[3msource /lineage/build/envsetup.sh\e[23m\033[01;37m is loaded.   #'
else 
	echo -e '# \033[01;31m\e[3msource /lineage/build/envsetup.sh\e[23m\033[01;37m not found.   #'
fi
echo -e '#                                                #'
echo -e '# Run \033[01;32m\e[3msyncro\e[23m\033[01;37m, \033[01;32m\e[3mlunch\e[23m\033[01;37m, \033[01;32m\e[3mbrunch\e[23m\033[01;37m, ... commmand.       #'
echo -e '#   $ \033[01;32m\e[3mbrunch lineage_beryllium-user\e[23m\033[01;37m              #'
echo -e '#                                                #'
echo -e '#   $ \033[01;32m\e[3mhmm\e[23m\033[01;37m to list build commands.                #'
echo -e '#                                                #'
echo -e '##################################################'
echo
unset env_setup_loaded

# aliases
alias ll='ls -la --color'
