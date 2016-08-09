#!/bin/sh
set -eo pipefail

# if command starts with an option, prepend full path sshd
if [ "${1:0:1}" = '-' ]; then
  echo Starting ssh server...
  set -- /usr/sbin/sshd "$@"
fi

# generate a modern crypto host key
if [ ! -f /etc/ssh/ssh_host_ed25519_key ]; then
    ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519
fi

# circumvent file mode issues by appending after generation
cat /root/.ssh/authorized_keys2 >> /root/.ssh/authorized_keys

exec "$@"
