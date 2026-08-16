---
title: "Levels 68–73: Docker & Containers"
description: "Images and running containers, logs and exec, building your own images, volumes and networks, Compose, and cleanup."
---

## Level 68: Images & Containers

> *Docker packages an application with everything it needs into one portable image you can run identically anywhere, isolated from the host.*

| Command | What it does |
|---|---|
| `docker pull nginx` | Download an image without running it |
| `docker run -d nginx` | Run detached, keeps running after the command returns |
| `docker run -d -p 8080:80 nginx` | Run detached, publish host port 8080 to container port 80 |
| `docker ps` | List running containers |
| `docker ps -a` | List every container, running or not |
| `docker images` | List local images |

---

## Level 69: Logs, Exec & Inspecting

| Command | What it does |
|---|---|
| `docker logs -f web` | Follow a container's logs live |
| `docker exec -it web bash` | Open an interactive shell inside a running container |
| `docker inspect web` | Full low-level container detail (JSON) |
| `docker stats` | Live CPU/memory/network usage per container |
| `docker stop web` | Stop cleanly |
| `docker rm web` | Remove a stopped container |

---

## Level 70: Building Images

> *Docker build looks for a file named exactly `Dockerfile` in the current directory by default, and its first real instruction is always `FROM`.*

| Command | What it does |
|---|---|
| `Dockerfile` | The build-instructions file, capital D, no extension |
| `FROM image` | Declares the base image everything else layers on |
| `docker build -t myapp:latest .` | Build and tag an image from the current directory |
| `docker tag myapp:latest myapp:v2` | Give an existing image a second tag |
| `docker push myrepo/myapp:latest` | Push an image to its registry |

---

## Level 71: Volumes & Networks

| Command | What it does |
|---|---|
| `docker volume create dbdata` | Create a named volume |
| `docker run -d -v dbdata:/path postgres` | Mount a volume into a container |
| `docker volume ls` | List volumes |
| `docker network create appnet` | Create a custom network |
| `docker run -d --network appnet redis` | Attach a container to it |

:::tip
Containers on the default bridge network can't reach each other by name. Containers on the same custom network can, which is the whole reason to create one.
:::

---

## Level 72: Docker Compose

> *A real app is rarely one container. Compose describes a whole multi-container stack in one file and brings it all up or down together.*

| Command | What it does |
|---|---|
| `docker-compose.yml` (or `compose.yml`) | The standard compose filename |
| `docker compose up -d` | Start every service, detached |
| `docker compose logs -f` | Follow every service's logs, combined |
| `docker compose up -d --scale worker=3` | Scale one service to N instances |
| `docker compose down` | Stop and remove everything the stack created |

---

## Level 73: Cleanup & Pruning

| Command | What it does |
|---|---|
| `docker container prune` | Remove every stopped container |
| `docker image prune` | Remove dangling images |
| `docker system prune` | Remove all of the above, at once |
| `docker rm -f web` | Force-remove a container even if it's still running |
| `docker system df` | See what's actually using disk space |

---

Finish this tier and move on to [Universal Packages](/bashquest/levels/15-universal-packages/): snap and flatpak, the two competing answers to sandboxed, distro-independent app installs.
