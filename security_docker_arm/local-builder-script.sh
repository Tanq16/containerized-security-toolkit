DOCKER_BUILDKIT=1 docker build -f builder-goexecs.Dockerfile -t gobuilder .
DOCKER_BUILDKIT=1 docker build -f builder-others.Dockerfile -t otherbuilder .
docker builder prune -f
DOCKER_BUILDKIT=1 docker build -t tanq16/sec_docker:main_apple .
docker push tanq16/sec_docker:main_apple
