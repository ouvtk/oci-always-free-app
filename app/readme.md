Here the sample application lies.

To build it you need `docker` and `docker-compose` installed:
 - https://docs.docker.com/engine/install/
 - https://docs.docker.com/compose/install/

 Or alternatives:
 - https://podman.io/docs/installation
 - https://github.com/containers/podman-compose

Do the `docker-compose up` to have the application built as the `app/_build/the-app`.
That's where terraform expects to find the executable.