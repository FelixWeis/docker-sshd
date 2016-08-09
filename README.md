# Automated sshd docker build

Simple alpine based openssh server. Can be used for testing purposes and dynamic
port fortwarding to test configurations inside a container cluster.

Dockerfile available here:

https://github.com/FelixWeis/docker-sshd/blob/master/Dockerfile

### Public Key
Caveat: Because sshd checks file owner and mode of `~/.ssh/authorized_keys` we use a trick:
Mount your public key instead to `/root/.ssh/.authorized_keys2`. On first startup,
its contents will be appended to the right file.

```
$ docker run -d \
    -v $HOME/.ssh/id_rsa.pub:/root/.ssh/.authorized_keys2 \
    -p 2222:22 \
    felixweis/sshd
```

If its not working as expected, you can debug the sshd container with `-ddd`

Then you can use ssh port forwarding to your local docker-machine vm:
```
$ ssh -D 2001 -p 2222 root@docker
```

Since we generate a new host key on container creation this may annoy some people. You can disable host verification like this:
```
$ ssh -D 2001 -p 2222 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@docker
```

With a seperate browser (e.g. firefox) you can enable SOCKS5 proxy with DNS forwarding and disable auto seach keywords to access the containers by their internal DNS name.

`about:config` changes
```
network.proxy.socks;localhost
network.proxy.socks_port;2001
network.proxy.socks_remote_dns;true
network.proxy.type;1
keyword.enabled;false
```

Now you can browse inside your cluster. 
