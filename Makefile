.PHONY: build
build:
	docker build -t gerrit .

.PHONY: exec
exec: build
	docker run -it --rm gerrit /bin/sh

.PHONY: run
run: build
	docker run -it --rm gerrit
