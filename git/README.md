
## Git

This image simply has the latest git running on the latest centos.
It is useful when running git behind a firewall & the git version is < 1.7.10

## To run

```bash
# run an interactive shell with the current directory mounted to /work
docker  run  -i -v `pwd`:/work  -t git
```
