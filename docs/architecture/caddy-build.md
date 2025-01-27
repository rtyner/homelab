## Resources
- [Using Cloudflare DNS Provider](https://caddy.community/t/how-to-use-dns-provider-modules-in-caddy-2/8148)
- [Reverse Proxy Quick Start](https://caddyserver.com/docs/quick-starts/reverse-proxy)
- [Caddyfile Quick Start](https://caddyserver.com/docs/quick-starts/caddyfile)
- [Caddyfile Concepts](https://caddyserver.com/docs/caddyfile/concepts)
- [Caddy Conventions](https://caddyserver.com/docs/conventions)
- [Caddy Global Options](https://caddyserver.com/docs/caddyfile/options#log)
- [Common Caddyfile Patterns](https://caddyserver.com/docs/caddyfile/patterns)
- [Uptime Kuma Reverse Proxy - Vultr](https://www.vultr.com/pt/docs/how-to-install-uptime-kuma-with-caddy-on-ubuntu-20-04)
- [Uptime Kuma Reverse Proxy - Uptime Kuma Github](https://github.com/louislam/uptime-kuma/wiki/Reverse-Proxy#caddy)

## Installing Caddy

```bash
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update
sudo apt install caddy
```

## Building Caddy with Cloudflare module
```shell
sudo apt install golang-go
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/xcaddy/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-xcaddy-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/xcaddy/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-xcaddy.list
sudo apt update
sudo apt install xcaddy
mkdir ~/caddy
cd ~/caddy
xcaddy build --with github.com/caddy-dns/cloudflare
sudo mv caddy /usr/bin
sudo caddy stop
sudo caddy start
```

- Caddy commands
	- `caddy start`
	- `caddy run`
	- `caddy stop`
- All config is done in a Caddyfile that is not particular on its location
```yaml
{
	acme_dns cloudflare API_TOKEN
}

https://rtynerlabs.io {
	
	# enable static file server
	file_server

	# compress response
	encode gzip	

	#test response
	respond "hello"

}

https://portainer-cloud.rtynerlabs.io {

	reverse_proxy 127.0.0.1:9000

}

https://uptime.rtynerlabs.io {

	reverse_proxy 127.0.0.1:3001

}

https://search.rtynerlabs.io {

	reverse_proxy 127.0.0.1:5000

}
```

- Error with SSL
```shell
# rt@rt-prod-docker-01 | ~/caddy [14:07] sudo caddy start
2022/11/24 14:11:36.318	INFO	using adjacent Caddyfile
2022/11/24 14:11:36.320	WARN	Caddyfile input is not formatted; run the 'caddy fmt' command to fix inconsistencies	{"adapter": "caddyfile", "file": "Caddyfile", "line": 2}
2022/11/24 14:11:36.322	INFO	admin	admin endpoint started	{"address": "localhost:2019", "enforce_origin": false, "origins": ["//localhost:2019", "//[::1]:2019", "//127.0.0.1:2019"]}
2022/11/24 14:11:36.322	INFO	http	server is listening only on the HTTPS port but has no TLS connection policies; adding one to enable TLS	{"server_name": "srv0", "https_port": 443}
2022/11/24 14:11:36.322	INFO	http	enabling automatic HTTP->HTTPS redirects	{"server_name": "srv0"}
2022/11/24 14:11:36.322	INFO	http	enabling HTTP/3 listener	{"addr": ":443"}
2022/11/24 14:11:36.323	INFO	failed to sufficiently increase receive buffer size (was: 208 kiB, wanted: 2048 kiB, got: 416 kiB). See https://github.com/lucas-clemente/quic-go/wiki/UDP-Receive-Buffer-Size for details.
2022/11/24 14:11:36.323	INFO	http.log	server running	{"name": "srv0", "protocols": ["h1", "h2", "h3"]}
2022/11/24 14:11:36.323	INFO	http.log	server running	{"name": "remaining_auto_https_redirects", "protocols": ["h1", "h2", "h3"]}
2022/11/24 14:11:36.323	INFO	http	enabling automatic TLS certificate management	{"domains": ["rtynerlabs.io"]}
2022/11/24 14:11:36.324	INFO	autosaved config (load with --resume flag)	{"file": "/root/.config/caddy/autosave.json"}
2022/11/24 14:11:36.324	INFO	serving initial configuration
2022/11/24 14:11:36.324	INFO	tls	cleaning storage unit	{"description": "FileStorage:/root/.local/share/caddy"}
2022/11/24 14:11:36.325	INFO	tls	finished cleaning storage units
2022/11/24 14:11:36.325	INFO	tls.cache.maintenance	started background certificate maintenance	{"cache": "0x40005e1f80"}
2022/11/24 14:11:36.325	INFO	tls.obtain	acquiring lock	{"identifier": "rtynerlabs.io"}
2022/11/24 14:11:36.327	INFO	tls.obtain	lock acquired	{"identifier": "rtynerlabs.io"}
2022/11/24 14:11:36.328	INFO	tls.obtain	obtaining certificate	{"identifier": "rtynerlabs.io"}
2022/11/24 14:11:36.329	INFO	http	waiting on internal rate limiter	{"identifiers": ["rtynerlabs.io"], "ca": "https://acme-v02.api.letsencrypt.org/directory", "account": "caddy@zerossl.com"}
2022/11/24 14:11:36.329	INFO	http	done waiting on internal rate limiter	{"identifiers": ["rtynerlabs.io"], "ca": "https://acme-v02.api.letsencrypt.org/directory", "account": "caddy@zerossl.com"}
Successfully started Caddy (pid=22205) - Caddy is running in the background
# rt@rt-prod-docker-01 | ~/caddy [14:11] curl https://rtynerlabs.io
curl: (35) error:0A000438:SSL routines::tlsv1 alert internal error
```

- This error is related to the `dns cloudflare` line being in a specific site in the Caddyfile removing that results in https content being served, placing it at the top of the file seems to work fine
```shell
	tls {
		dns cloudflare {API TOKEN}
	}	
```

[### Reverse proxy](https://www.vultr.com/pt/docs/how-to-install-uptime-kuma-with-caddy-on-ubuntu-20-04)

```shell
# add to caddy file
https://subdomain.rtynerlabs.io {

	reverse_proxy 127.0.0.1:PORT
	
}
```