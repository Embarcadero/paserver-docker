# paserver-docker
<a href="https://www.embarcadero.com/products/rad-studio"><img alt="Embarcadero RAD Studio" src="https://user-images.githubusercontent.com/821930/228646830-41d2a8bf-e528-4e8d-ba55-51071d523087.png" align="right"></a>
Docker script for RAD Studio Linux deployment via PAServer 

- **Container available on [Docker Hub](https://hub.docker.com/r/radstudio/pa-radserver)**
- [PAServer Documentation](http://docwiki.embarcadero.com/RADStudio/en/PAServer,_the_Platform_Assistant_Server_Application)
- [More information on RAD Studio](https://www.embarcadero.com/products/rad-studio)
- Other containers: [InterBase](https://github.com/Embarcadero/InterBase-Docker) only, [RAD Server](https://github.com/Embarcadero/pa-radserver-docker), and [RAD Server with InterBase](https://github.com/Embarcadero/pa-radserver-ib-docker)

The image defaults to running **PAServer** on port `64211` with the _password_ `securepass`, and **Broadwayd** on port `8082`

The 10.x images use Ubuntu 18.04.6 LTS (Bionic Beaver) while the 11.x images use Ubuntu 22.04.1 LTS (Jammy Jellyfish)

## Instructions

If you want to modify or build from GitHub without using [Docker Hub](https://hub.docker.com/r/radstudio/pa-radserver), you can build the Dockerfile with the `build.sh` script. **Note:** The Dockerfile requires the `paserver_docker.sh` script in the same directory
```
./build.sh
```

To pull and run the [Docker Hub](https://hub.docker.com/r/radstudio/paserver) version of PAServer Docker for a debug/non-production environment use the `pull-run.sh` script
```
./pull-run.sh
```

To pull and run the Docker Hub version of PAServer Docker for a non-debug/production environment use the `pull-run-production.sh` script
```
./pull-run-production.sh securepass123
```

To run the Docker Hub version of PAServer Docker for a debug/non-production environment use the `pull-run.sh` script
```
./run.sh
```

To run the Docker Hub version of paserver docker for a non-debug/production environment use the `run-production.sh` script
```
./run-production.sh securepass123
```

--- 

This software is Copyright &copy; 2023 by [Embarcadero Technologies, Inc.](https://www.embarcadero.com/)

_You may only use this software if you are an authorized licensee of an Embarcadero developer tools product. See the latest [software license agreement](https://www.embarcadero.com/products/rad-studio/rad-studio-eula) for any updates._

![Embarcadero(Black-100px)](https://user-images.githubusercontent.com/821930/211648635-c0db6930-120c-4456-a7ea-dc7612f01451.png#gh-light-mode-only)
![Embarcadero(White-100px)](https://user-images.githubusercontent.com/821930/211649057-7f1f1f07-a79f-44d4-8fc1-87c819386ec6.png#gh-dark-mode-only)
