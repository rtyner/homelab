# Docker Notes

## Links

<https://dockerswarm.rocks/>
<https://docs.docker.com/engine/swarm/>
<https://geek-cookbook.funkypenguin.co.nz/ha-docker-swarm/design/>
<https://www.smarthomebeginner.com/traefik-2-docker-tutorial/>
<https://www.youtube.com/watch?v=3c-iBn73dDE>
<https://www.youtube.com/c/TechWorldwithNana/videos>

## Swarm

- clustered node of of docker hosts with distributed manager nodes to provide fault tolerance

| **Hostname**                    | **IP**       | **Description**      |
| ------------------------------- | ------------ | -------------------- |
| prod-docker-mgr1.rtynerlabs.io  | 192.168.1.25 | docker swarm manager |
| prod-docker-node1.rtynerlabs.io | 192.168.1.26 | docker swarm node 1  |
| prod-docker-node2.rtynerlabs.io | 192.168.1.27 | docker swarm node 1  |

| **Hostname**    | **IP**          | **Description**      |
| --------------- | --------------- | -------------------- |
| do-docker-mgr1  | 137.184.58.157  | docker swarm manager |
| do-docker-node1 | 143.198.189.109 | docker swarm node 1  |
| do-docker-node2 | 167.99.232.2    | docker swarm node 2  |

```bash
docker swarm init --advertise-addr 192.168.1.25
```

## Useful Commands

### start container on a port and link with another

```bash
docker run --name mediawiki -p 8080:80 --link mediawiki-mysql:mysql -d mediawiki
```

### list running containers

```bash
docker ps
```

### start a conainter on a port

```bash
docker run --name mediawiki -p 8080:80 -d mediawiki
```

### kill a container

```bash
docker kill 233fce5bcd21
```

### copy files to a container

```bash
docker cp LocalSettings.php mediawiki:/var/www/html
```

### list resource usage of running containers

```bash
docker cp LocalSettings.php mediawiki:/var/www/html
```

### launch a bash bash in a conatiner

```bash
docker exec -it mediawiki-mysql bash
```

### show stopped docker containers

```bash
docker ps -a | grep Exit
```
