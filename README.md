# paserver-docker
Docker script for RAD Studio Linux deployment via PAServer. 

- [Container available on Docker Hub](https://hub.docker.com/r/radstudio/paserver)
- [PAServer Documentation](http://docwiki.embarcadero.com/RADStudio/en/PAServer,_the_Platform_Assistant_Server_Application)
- [More information on RAD Studio](https://www.embarcadero.com/products/rad-studio)



## Instructions

If you want to modify or build from GitHub without using [Docker Hub](https://hub.docker.com/r/radstudio/paserver), you can build the Dockerfile with the `build.sh` script. Note: The Dockerfile requires the `paserver_docker.sh` script in the same directory
```
./build.sh
```

To pull and run the [Docker Hub](https://hub.docker.com/r/radstudio/paserver) version of paserver docker for a non-production environment use the `pull-run.sh` script
```
./pull-run.sh
```

To pull and run the Docker Hub version of paserver docker for a production environment use the `pull-run-production.sh` script
```
./pull-run-production.sh securepass123
```

To run the Docker Hub version of paserver docker for a non-production environment use the `pull-run.sh` script
```
./run.sh
```

To run the Docker Hub version of paserver docker for a production environment use the `run-production.sh` script
```
./run-production.sh securepass123
```

This software is Copyright © [Embarcadero Technologies, Inc.](https://www.embarcadero.com/)

You may only use this software if you are an authorized licensee of an Embarcadero developer tools product. This software is considered a Redistributable as defined in the software license agreement that comes with the Embarcadero Products and is governed by the terms of such [software license agreement](https://www.embarcadero.com/products/rad-studio/rad-studio-eula).
