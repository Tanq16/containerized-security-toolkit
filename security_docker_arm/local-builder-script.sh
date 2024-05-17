DOCKER_BUILDKIT=0 docker build -f builder.Dockerfile -t intermediate_builder .
docker builder prune -f
DOCKER_BUILDKIT=0 docker build -t tanq16/sec_docker:main_apple .
docker push tanq16/sec_docker:main_apple
