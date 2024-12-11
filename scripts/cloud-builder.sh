cd images/general

docker build -f builder.Dockerfile -t intermediate_builder .
docker builder prune -f
docker build -t cst-cloud .
