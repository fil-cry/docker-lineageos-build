#!/bin/bash

# expect
# $1 as the user id
# $2 as the group id
# $3 as the value for USE_CCACHE (0 or 1)

# create the worker group and user with the given ids
groupadd -g $2 worker
useradd -m -u $1 -g worker -s /bin/bash worker

# disable ccache in worker's profile when the container has been started with -e USE_CCACHE=0
if [ $# -gt 2 ] && [ -n $3 ] && [ $3 != 1 ] ; then
	sed -i -e 's/export USE_CCACHE=1/export USE_CCACHE=0/g' /usr/local/etc/worker.profile
fi

# setup worker environemnt (setup ccache, config git, startup message, ...)
cat /usr/local/etc/worker.profile > /home/worker/.profile
