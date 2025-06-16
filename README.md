# operation-bofice
VS Code docker deployment for a locally hosted remote VS Code deployment.

## Setup
Setup is as simple as installing Docker and running docker compose inside the repo
```
docker compose up -d
```

It is worth noting that you may want to adjust the `compose.yml` file and adjust the mount points for the volumes, in this instance I use `/mnt/data/dev` as this is where I mount my tooldev share.
