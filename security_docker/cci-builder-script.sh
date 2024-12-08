tag=$1
DOCKER_BUILDKIT=1 docker build -f builder.Dockerfile -t intermediate_builder .
docker builder prune -f
DOCKER_BUILDKIT=1 docker build -t tanq16/sec_docker:$tag .
docker push tanq16/sec_docker:$tag
