# build
```
$ stack build
```
# run
```
$ stack exec cccm-exe
```
## Listening on
```
http://localhost:8000
```

## docker buld
```
$ cd build
$ make -f Makefile
```

## docker ENV
```
$ CONN_STR="host=localhost dbname=cc user=postgres" stack --no-nix-pure exec cccm-exe
```
