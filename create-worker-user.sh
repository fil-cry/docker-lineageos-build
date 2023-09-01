groupadd -g $2 worker
useradd -m -u $1 -g worker -s /bin/bash worker
cat /usr/local/etc/worker.profile > /home/worker/.profile
