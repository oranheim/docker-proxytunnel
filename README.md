# Docker ProxyTunnel

Docker ProxyTunnel is a workaround image for MacOS SSH users

## The problem

```bash
mac$ brew install proxytunnel
(proxytunnel installed)

mac$ ssh user@ssh.example.com
Via user@ssh.example.com:443 -> user@ssh.example.com:22
error: Socket write error.
ssh_exchange_identification: Connection closed by remote host
```

## The solution

```bash
mac$ ./sshproxy.sh $HOME/.ssh/proxyconfig/ user@ssh.example.com
Via user@ssh.example.com:443 -> user@ssh.example.com:22
user@ssh.example.com's password: ******
Welcome to Ubuntu 16.04.4 LTS (GNU/Linux 4.4.0-116-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

5 packages can be updated.
0 updates are security updates.


Last login: Tue Mar 20 13:52:35 2018 from 192.168.0.100
ubuntu$ logout
Connection to user@ssh.example.com closed.
```

# Build

```bash
docker build -t descoped/proxytunnel .
```

This expects `config` file to be present in `/proxytunnel`.

# Sample ProxyTunnel

.ssh/proxyconfig/config:
```
Host ssh.example.com
   Hostname ssh.example.com
   ProtocolKeepAlives 30
   ProxyCommand /usr/bin/proxytunnel -E -p ssh.example.com:443 -d %h:%p
```

```bash
docker run -it -v SSH_CONFIG=$HOME/.ssh/proxyconfig:/root/.ssh -e SSH=user@ssh.example.com descoped/proxytunnel
```

```bash
./sshproxy.sh `PWD`/proxytunnel user@ssh.example.com
```

## feature request

enable a simpler way to use

```bash
docker run -it -e HOST=ssh.example.com -e PORT=443(default) -e USER=user descoped/proxytunnel
```

# Apache 2.4 configuration

The following modules must be enabled:

```
LoadModule proxy_http_module modules/mod_proxy_http.so
LoadModule proxy_connect_module modules/mod_proxy_connect.so
```

## ssh.example.com.conf

```
<VirtualHost ssh.example.com:443>
        ServerAdmin webmaster@localhost
        ServerName  ssh.example.com

        RewriteEngine On
        RewriteCond %{REQUEST_METHOD} !^CONNECT [NC]
        RewriteRule ^/(.*)$ - [F,L]

        ProxyRequests On
        ProxyBadHeader Ignore
        ProxyVia Full
        AllowCONNECT 22

        <Proxy *>
                AddDefaultCharset off
                Order deny,allow
                Deny from all
                #Require local
        </Proxy>

        <Proxy ssh.example.com:22>
                Order allow,deny
                Allow from all
        </Proxy>

        SSLEngine On
        SSLCertificateFile /etc/letsencrypt/live/ssh.example.com/fullchain.pem
        SSLCertificateKeyFile /etc/letsencrypt/live/ssh.example.com/privkey.pem

        LogLevel warn
        CustomLog /var/log/apache2/access.log combined
        ErrorLog /var/log/apache2/error.log
</VirtualHost>
```
