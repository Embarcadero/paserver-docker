# RAD Studio PAServer Docker

<a href="https://www.embarcadero.com/products/rad-studio"><img alt="Embarcadero RAD Studio" src="https://raw.githubusercontent.com/azapater/paserver-docker/main/.github/images/rad-studio-logo.png" align="right"></a>

Welcome to the guide for deploying RAD Studio applications on Linux using Docker and PAServer. This repository offers a Docker script designed to simplify the setup and management of your development environment, allowing RAD Studio developers to deploy and test their applications in a Linux environment.

- **Container available on [Docker Hub][dockerhub-paserver]**
- [PAServer Documentation][paserver-docs]
- [More information on RAD Studio][radstudio]
- Other containers: [InterBase][github-interbase-docker] only, [RAD Server][github-radserver-docker], and [RAD Server with InterBase][github-radserver-interbase-docker]

The image defaults to running **PAServer** on port `64211` with the _password_ `securepass`

The 10.x images use Ubuntu 18.04.6 LTS (Bionic Beaver) while the +11.x images use Ubuntu 22.04.1 LTS (Jammy Jellyfish)

## 🚀 How to Use [`run.sh`] Script

The [`run.sh`] script is your go-to automation tool for setting up and deploying the PAServer application with ease and flexibility. Below are the instructions to utilize this script effectively.

### 📋 Prerequisites

Ensure Docker is installed on your system as this script uses Docker for running the PAServer application.

### 🌟 Features

- **Customizable Name**: Assign a unique name to your PAServer container.
- **Bind Path**: Designate a custom path for volume mapping.
- **Detach Mode**: Opt for running your container in the background.
- **Port Configuration**: Select the port where PAServer runs.
- **Production Mode**: Activate production mode for your deployment.
- **Version Control**: Choose the specific PAServer version for deployment.
- **Password Protection**: Secure your PAServer with a custom password.

### 🛠️ Usage

Navigate to the directory containing [`run.sh`] in your terminal. Execute the script with your preferred options:

```bash
./run.sh [OPTIONS]
```

#### 📌 Options

- `--name` or `-n`: Container's name (e.g., `--name=myPAServer`).
- `--path` or `-pa`: Bind path for volume mapping (e.g., `--path=/my/custom/path`).
- `--detach` or `-d`: Run container in detach mode (background).
- `--port` or `-p`: Port for PAServer (e.g., `--port=64211`).
- `--production` or `-pr`: Enable production mode (`true`).
- `--version` or `-v`: PAServer version (e.g., `--version=latest`).
- `--password` or `-pw`: Set a password for PAServer (e.g., `--password=securepass`).

### 🌈 Examples

Run PAServer in production mode on port 65000 with a custom name and password:

```bash
./run.sh --name=myPAServer --port=65000 --production --password=mysupersecurepassword
```

Run PAServer in detach mode with a specific version, bind path, and password:

```bash
./run.sh --detach --version=12.1 --path=/my/custom/path --password=mysupersecurepassword
```

### 📝 Note

Make sure you have the necessary permissions to execute `run.sh`. Use `chmod +x run.sh` to make it executable if needed.

## 🐳 Using `docker run` Directly

For users who prefer a more hands-on approach or wish to customize their deployment further, you can directly use the `docker run` command to start your PAServer container. This method provides flexibility and allows you to manually specify each option.

### 🛠️ Command Structure

The basic structure of the command to run the PAServer Docker container is as follows:

```bash
docker run [OPTIONS] radstudio/paserver:[VERSION]
```

### 📌 Options

- `-e PA_SERVER_PASSWORD=[PASSWORD]`: Sets the password for the PAServer. Replace `[PASSWORD]` with your desired password.
- `--name [NAME]`: Assigns a custom name to your Docker container. Replace `[NAME]` with your preferred container name.
- `-p [PORT]:64211`: Maps a custom port on your host to the PAServer's default port (64211). Replace `[PORT]` with the port number you wish to use.
- `[DETACH_ARG]`: Use `-d` to run the container in detached mode (in the background).
- `[BIND_PATH_ARG]`: Use `-v [HOST_PATH]:[CONTAINER_PATH]` to bind a volume for persistent data or configurations. Replace `[HOST_PATH]` and `[CONTAINER_PATH]` with your specific paths.

### 🌈 Examples

To run the PAServer in a Docker container named `myPAServer`, listening on port 65000, with a password of `mysupersecurepassword`, and running in detached mode, you would use the following command:

```bash
docker run -d \
           -e PA_SERVER_PASSWORD=mysupersecurepassword \
           --name myPAServer \
           -p 65000:64211 radstudio/paserver:latest
```

If you wish to bind a volume for persistent data, you can add the `-v` option:

```bash
docker run -d \
           -e PA_SERVER_PASSWORD=securepass \
           -v /path/on/host:/root/PAServer/scratch-dir \
           --name myPAServer \
           -p 65000:64211 radstudio/paserver:latest
```

#### Using Docker Compose

Docker Compose allows you to define and run multi-container Docker applications. Here is an example `docker-compose.yml` file that demonstrates how to use a Docker image as part of a service, utilizing environment variables for configuration.

```yaml
version: '3.8'
services:
  myPAServer:
    image: radstudio/paserver:latest
    container_name: myPAServer
    environment:
      - PA_SERVER_PASSWORD=${PA_SERVER_PASSWORD} # Environment variable for the server password
    ports:
      - '${HOST_PORT}:64211' # Environment variable for the host port
    volumes:
      - ${HOST_PATH}:/root/PAServer/scratch-dir # Environment variable for the host path
    restart: unless-stopped
```

This configuration defines a single service called `myPAServer`. It uses the Docker image `radstudio/paserver:latest`. The service configuration includes mapping a port from the host to the container, setting an environment variable for the server password, and mounting a volume from the host to the container. These settings are customizable through environment variables defined in a `.env` file located in the same directory as your `docker-compose.yml`.

```
# .env file
PA_SERVER_PASSWORD=securepass
HOST_PORT=65000
HOST_PATH=/path/on/host
```

To start your application, execute the following command in the directory containing your `docker-compose.yml`:

```bash
docker-compose up
```

This command initiates the Docker Compose process, which reads the `docker-compose.yml` file and the `.env` file, applying the configurations to start your service as defined.

This will pull the necessary image (if it's not already locally available), create the defined volumes, set the environment variables, and start your application on the specified ports.

#### 📝 Note

Ensure you replace `/path/on/host` with the actual path you wish to use for volume binding. The `latest` tag can be replaced with any specific version of the PAServer you wish to deploy.

## 🛠️ Customizing Your Docker Image

This guide will help you customize the PAServer image to suit your specific needs, such as adding additional files or folders, installing extra packages, and making other modifications.

### 📁 Adding Files or Folders

To add files or folders to your Docker image, use the `COPY` or `ADD` instruction in your Dockerfile. `COPY` is preferred for copying local files, while `ADD` can handle remote URLs and tar extraction.

#### Example: Adding a Configuration File

```dockerfile
COPY ./myconfig.conf /etc/myapp/myconfig.conf
```

This command copies `myconfig.conf` from your project directory to `/etc/myapp/myconfig.conf` inside the Docker image.

### 📦 Installing Extra Packages

To install additional packages, you can modify the `RUN` command that installs packages. It's best to combine package installation commands into a single `RUN` instruction to reduce the number of layers in your Docker image.

#### Example: Installing Git and Cmake

```dockerfile
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    && rm -rf /var/lib/apt/lists/*
```

Based on each project, specific libraries may be necessary. This command updates the package lists, installs _Git_ and _Cmake_, and cleans up afterward to keep the image size down.

To avoid extra layering in the final Docker image, it's good practice to modify the existing `RUN apt-get update` command to include your required libraries.

### 🛠️ Customizing Installation Commands

You can customize the Dockerfile to change environment variables, download different versions of software, or modify the installation process.

#### Example: Setting a Custom Environment Variable

```dockerfile
ENV MY_CUSTOM_VAR=myvalue
```

This sets an environment variable `MY_CUSTOM_VAR` that can be used by your application.

### 🏗️ Building Your Custom Image

After customizing your Dockerfile, you can build your Docker image using the `docker build` command.

```bash
docker build -t my-custom-paserver:latest .
```

This command builds a Docker image named `my-custom-paserver` with the `latest` tag, using the Dockerfile in the current directory.

### 🔑 Using Build Arguments

For values that might change between builds (like passwords or version numbers), you can use `ARG` instructions in your Dockerfile and pass values with the `--build-arg` option during the build.

#### Example: Specifying a Custom Password

```dockerfile
ARG password=securepass
```

Build with a custom password:

```bash
docker build --build-arg password=mypassword -t my-custom-paserver:latest .
```

### 💡 Tips

- This repository provides a [`build.sh`] script that can be used as a template for simplifying custom builds.
- Currently, this image is only compatible with `linux/amd64`. To avoid potential problems in arm setups, build the image with the arg `--platform linux/amd64`

### 🛡️ Best Practices

- **Minimize Layers**: Combine related commands into single `RUN` instructions where possible.
- **Clean Up**: Remove unnecessary files and packages to keep the image size down.
- **Use `.dockerignore`**: Add a `.dockerignore` file to your project to avoid copying unnecessary files into your Docker image.
- **Secure Secrets**: Avoid hardcoding sensitive information in your Dockerfile. Use build arguments for build-time secrets and environment variables or Docker secrets for runtime secrets.

## License and Copyright

This software is Copyright &copy; 2024 by [Embarcadero Technologies, Inc.][embarcacero]

_You may only use this software if you are an authorized licensee of an Embarcadero developer tools product. See the latest [software license agreement][embarcadero-license] for any updates._

![Embarcadero(Black)](https://raw.githubusercontent.com/azapater/paserver-docker/main/.github/images/embt-logo-black.png#gh-light-mode-only)
![Embarcadero(White)](https://raw.githubusercontent.com/azapater/paserver-docker/main/.github/images/embt-logo-white.png#gh-dark-mode-only)

[dockerhub-paserver]: https://hub.docker.com/r/radstudio/paserver
[radstudio]: https://www.embarcadero.com/products/rad-studio
[paserver-docs]: http://docwiki.embarcadero.com/RADStudio/en/PAServer,_the_Platform_Assistant_Server_Application
[github-interbase-docker]: https://github.com/Embarcadero/InterBase-Docker
[github-radserver-docker]: https://github.com/Embarcadero/pa-radserver-docker
[github-radserver-interbase-docker]: https://github.com/Embarcadero/pa-radserver-ib-docker
[embarcadero]: https://www.embarcadero.com/
[embarcadero-license]: https://www.embarcadero.com/products/rad-studio/rad-studio-eula
