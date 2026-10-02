# RAD Studio PAServer Docker

<a href="https://www.embarcadero.com/products/rad-studio"><img alt="RAD Studio" src=".github/images/rad-studio-logo.png" align="right" width="128"></a>

Linux image for the RAD Studio Platform Assistant (PAServer). Use it to deploy and debug Linux applications from the IDE without setting up a VM by hand.

- [Docker Hub][dockerhub-paserver]
- [PAServer documentation][paserver-docs]
- [RAD Studio][radstudio]
- Other containers: [InterBase][github-interbase-docker], [RAD Server][github-radserver-docker], [RAD Server with InterBase][github-radserver-interbase-docker]

The image listens on port `64211`. The default password is `securepass`. Override it with `PA_SERVER_PASSWORD`.

Deployed files go to `/root/PAServer/scratch-dir` inside the container. Mount a host directory there if you want them kept across restarts.

Images for 10.x are based on Ubuntu 18.04. Images for 11 and later, including this one, are based on Ubuntu 22.04. The image is `linux/amd64` only. On an Arm machine, build and run with `--platform linux/amd64`.

## Run with `run.sh`

[`run.sh`] wraps `docker run`. Docker has to be installed, and the script needs execute permission (`chmod +x run.sh`).

```bash
./run.sh [OPTIONS]
```

| Option | Description |
| --- | --- |
| `--name`, `-n` | Container name. Default: `paserver`. |
| `--path`, `-pa` | Host directory to mount on the scratch dir. |
| `--detach`, `-d` | Run in the background. |
| `--port`, `-p` | Host port mapped to `64211`. Default: `64211`. |
| `--password`, `-pw` | PAServer password. Default: `securepass`. |
| `--version`, `-v` | Image tag. Default: `latest`. |
| `--production`, `-pr` | Skip the debug capabilities added for the IDE debugger. |
| `--help`, `-h` | Show the script help. |

Without `--production`, the container is started with `SYS_PTRACE` and an unconfined seccomp profile so the IDE can debug Linux apps.

```bash
./run.sh --name=myPAServer --port=65000 --production --password=mysupersecurepassword
```

```bash
./run.sh --detach --version=13.2 --path=/my/custom/path --password=mysupersecurepassword
```

## Run with Docker

```bash
docker run -d \
           -e PA_SERVER_PASSWORD=mysupersecurepassword \
           --name myPAServer \
           -p 65000:64211 \
           radstudio/paserver:latest
```

Mount the scratch directory when deployed binaries should survive the container:

```bash
docker run -d \
           -e PA_SERVER_PASSWORD=securepass \
           -v /path/on/host:/root/PAServer/scratch-dir \
           --name myPAServer \
           -p 65000:64211 \
           radstudio/paserver:13.2
```

Replace `latest` with a version tag such as `13.2` or `florence` when you want a specific release. For debugging, add the same capabilities `run.sh` adds outside production mode:

```bash
docker run --cap-add=SYS_PTRACE --security-opt seccomp=unconfined ...
```

### Docker Compose

```yaml
services:
  paserver:
    image: radstudio/paserver:13.2
    container_name: paserver
    environment:
      PA_SERVER_PASSWORD: ${PA_SERVER_PASSWORD}
    ports:
      - "${HOST_PORT}:64211"
    volumes:
      - ${HOST_PATH}:/root/PAServer/scratch-dir
    restart: unless-stopped
```

```
PA_SERVER_PASSWORD=securepass
HOST_PORT=65000
HOST_PATH=/path/on/host
```

```bash
docker compose up
```

## Build the image

[`build.sh`] downloads PAServer from the Embarcadero CDN and tags the image `latest`, `florence`, and `13.2`. The product version, codename, compiler version, and CDN path are set at the top of that script.

```bash
bash ./build.sh
```

A plain `docker build` uses the same 13.2 URL as its default. `build.sh` passes these build arguments, and any of them can be overridden:

| Argument | Role |
| --- | --- |
| `PA_SERVER_SOURCE` | `remote` downloads the tarball. `local` copies it from `bin/`. |
| `PA_SERVER_URL` | CDN URL used when the source is `remote`. |
| `PA_SERVER_TARBALL` | File name inside `bin/` when the source is `local`. |

The password is not a build argument. It is set when the container starts.

### Beta builds

A beta does not use the release version above. Put the tarball in `bin/`. Its name follows the PAServer version, `LinuxPAServer37.0.tar.gz` today and `LinuxPAServer38.0.tar.gz` when that version changes. With a single archive in the folder:

```bash
bash ./build.sh beta 14.0-beta.1 14.0-beta
```

With more than one archive, choose the file:

```bash
bash ./build.sh beta --file LinuxPAServer38.0.tar.gz 14.0-beta.1 14.0-beta
```

The tags are whatever you pass. Nothing in the script derives them from the codename or the product version, and `latest` is left unchanged. Do not commit the tarball.

When the next release ships, update the four variables at the top of [`build.sh`] and the default URL in the Dockerfile. The beta command stays the same.

### Extra packages

Linux projects often need libraries that are not in the base image. Add them to the runtime `apt-get install` in the Dockerfile, then build:

```bash
docker build --platform linux/amd64 -t my-custom-paserver:latest .
```

## License and Copyright

This software is Copyright &copy; 2024 by [Embarcadero Technologies, Inc.][embarcadero]

_You may only use this software if you are an authorized licensee of an Embarcadero developer tools product. See the latest [software license agreement][embarcadero-license] for any updates._

![Embarcadero](.github/images/embt-logo-black.png#gh-light-mode-only)
![Embarcadero](.github/images/embt-logo-white.png#gh-dark-mode-only)

[dockerhub-paserver]: https://hub.docker.com/r/radstudio/paserver
[radstudio]: https://www.embarcadero.com/products/rad-studio
[paserver-docs]: http://docwiki.embarcadero.com/RADStudio/en/PAServer,_the_Platform_Assistant_Server_Application
[github-interbase-docker]: https://github.com/Embarcadero/InterBase-Docker
[github-radserver-docker]: https://github.com/Embarcadero/pa-radserver-docker
[github-radserver-interbase-docker]: https://github.com/Embarcadero/pa-radserver-ib-docker
[embarcadero]: https://www.embarcadero.com/
[embarcadero-license]: https://www.embarcadero.com/products/rad-studio/rad-studio-eula
