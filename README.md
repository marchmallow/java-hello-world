# java-hello-world
Simple Hello World to test deployment of jar packages to github package repository

Github docs: <https://help.github.com/en/packages/using-github-packages-with-your-projects-ecosystem/configuring-apache-maven-for-use-with-github-packages>

## Key package deployment settings

* [config/settings.xml](./config/settings.xml)
* [pom.xml: distributionManagement](https://github.com/marchmallow/java-hello-world/blob/master/pom.xml#L89)

## Docker build

### Prereq.

- Have docker running.

- Create a .env file with following secrets:

```
MAVEN_USERNAME=<github userid>
GITHUB_TOKEN=<personal access token>
DEPLOY_REPO=<OWNER/REPOSITORY> (eg. marchmallow/java-hello-world)
```

### Make help

```
build-docker                   Builds the docker image
build                          Full build (jar + docker)
clean                          Clean (mvn clean)
deploy                         Deploy
package                        Build the jar package (mvn package)
run                            Runs app in a docker container
test                           Run Test
```
