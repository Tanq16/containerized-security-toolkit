DOCKER_BUILDKIT=1 docker build -f builder.Dockerfile -t intermediate_builder .
docker builder prune -f
DOCKER_BUILDKIT=1 docker build -t sec_docker .
