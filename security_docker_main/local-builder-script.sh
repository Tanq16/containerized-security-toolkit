DOCKER_BUILDKIT=1 docker build -f builder.Dockerfile -t tanq16/intermediate_builder:amd .
docker builder prune -f
docker push tanq16/intermediate_builder:amd
DOCKER_BUILDKIT=1 docker build -t tanq16/sec_docker:main .
docker push tanq16/sec_docker:main
