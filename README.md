# zerotier-allinone

Dockerized all-in-one ZeroTier Node contains a moon, a controller with [zero-ui](https://github.com/dec0dOS/zero-ui) web interface.

## Getting started:

- Clone this repo.
- Install podman, podman-compose and podman-plugins.
- Run `podman-compose up -d`.
- Log into the controller web ui at <http://yourip:4000> with the username and password set in `docker-compose.yml`.
- A moon which is also the controller is started. Moon id is printed to podman logs.

## References

<https://github.com/rwv/docker-zerotier-moon>

<https://github.com/dec0dOS/zero-ui>
