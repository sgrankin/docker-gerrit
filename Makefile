VERSION := 2.14
# bazel-master-stable
PLUGINS_MASTER := avatars-gravatar emoticons force-draft gitiles oauth owners
# bazel-stable
PLUGINS := delete-project lfs wip

define DOCKERFILE
FROM sgrankin/docker-openjdk32
RUN apk add --no-cache git runit openssh
COPY gerrit.war		/app/
COPY *.jar		/app/plugins/
COPY gerrit.config	/app/etc/
COPY entrypoint.sh 	/entrypoint.sh
VOLUME /data
EXPOSE 8080 29418
CMD ["/entrypoint.sh"]
endef
export DOCKERFILE

CURL ?= curl
CURLOPTS ?= -sSL

build: gerrit.war $(PLUGINS_MASTER:=.jar) $(PLUGINS:=.jar)
	echo "$$DOCKERFILE" > Dockerfile
	docker build -t gerrit .

exec: build
	docker run -it --rm gerrit /bin/sh

run: build
	docker run -it --rm -p 8080:8080 gerrit

clean:
	rm gerrit.war $(PLUGINS_MASTER:=.jar) $(PLUGINS:=.jar)

gerrit.war:
	$(CURL) $(CURLOPTS) -o $@ https://www.gerritcodereview.com/download/gerrit-$(VERSION).war

$(PLUGINS_MASTER:=.jar)::
	$(CURL) $(CURLOPTS) -o $@ https://gerrit-ci.gerritforge.com/view/Plugins-stable-2.14/job/plugin-$(@:.jar=)-bazel-master-stable-$(VERSION)/lastSuccessfulBuild/artifact/bazel-genfiles/plugins/$(@:.jar=)/$@

$(PLUGINS:=.jar)::
	$(CURL) $(CURLOPTS) -o $@ https://gerrit-ci.gerritforge.com/view/Plugins-stable-2.14/job/plugin-$(@:.jar=)-bazel-stable-$(VERSION)/lastSuccessfulBuild/artifact/bazel-genfiles/plugins/$(@:.jar=)/$@


.PHONY: build exec run clean
