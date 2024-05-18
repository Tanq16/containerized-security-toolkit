DOCKER_BUILDKIT=1 docker buildx build -o type=docker --platform=linux/arm64 -f builder.Dockerfile -t intermediate_builder:local .
docker builder prune -f
DOCKER_BUILDKIT=1 docker buildx build -o type=docker --platform=linux/arm64 -t tanq16/sec_docker:main_apple .
docker push tanq16/sec_docker:main_apple
