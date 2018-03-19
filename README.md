# Docker ProxyTunnel

Docker ProxyTunnel is a workaround image for MacOS SSH users


## Build

```bash
docker build -t descoped/proxytunnel .
```

This expects `config` file to be present in `/proxytunnel`.

# Sample ProxyTunnel

.ssh/config:
```
Host ssh.example.com
   Hostname ssh.example.com
   ProtocolKeepAlives 30
   ProxyCommand /usr/bin/proxytunnel -E -p ssh.example.com:443 -d %h:%p
```

```bash
docker run -it -v SSH_CONFIG=$HOME/ssh-config:/opt/proxytunnel/.ssh -e SSH=user@ssh.example.com descoped/proxytunnel
```

```bash
docker run -it -e HOST=ssh.example.com -e PORT=443(default) -e USER=user descoped/proxytunnel
```

```bash
./sshproxy.sh `PWD`/proxytunnel user@ssh.example.com
```
