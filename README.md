# Operation Bofice
VS Code docker deployment for a locally hosted remote VS Code deployment.

This repo was released alongside the Operation Bofice blog post discussing the use-case and reasoning for setting this up. In it's current form, this will spin up a local Code server which can be accessed on your network on `IP:8080` though if 8080 is in use on your desired host, feel free to adjust the deployment files.

## The Stack
Currently the Code server is designed to be used for the following languages:
- C Sharp
- C/++
- Assembly
- Golang

This can obviously be configured how you see fit by adjusting the compose.yml file under the `install extensions` section. 
It's worth noting that Code-Server uses the [Open VSX Registry](https://open-vsx.org/) so check it out if you want to adjust the configuration further

On top of this it also installs MingW to allow for cross-compilation. This has been included to allow for remote bof development regardless of OS you're currently on.

## Setup
Setup is as simple as installing Docker and running docker compose inside the repo
```
docker compose up -d
```

It is worth noting that you may want to adjust the `compose.yml` file and adjust the mount points for the volumes, in this instance I use `/mnt/data/dev` as this is where I mount my tooldev share.
