# Docker ProxyTunnel

Docker ProxyTunnel is a workaround image for MacOS SSH users

```bash
docker build -t descoped/proxytunnel .
```

```bash
docker run -it -v SSH_CONFIG=$HOME/.proxytunnel:/proxytunnel -e SSH=user@example.com descoped/proxytunnel
```

This expects `config` file to be present in `/proxytunnel`.

