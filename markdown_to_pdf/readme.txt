Build using -
docker build -t tanq16/sec_docker:render .

Run using -
docker run --name "render_md" -p 8000:8000 -e HS1="page header strong 1" -e HN="page header normal" -e HS2="page header strong 2" -v <md file and images directory>:/root/md_files/ --rm -it tanq16/sec_docker:render bash /root/run.sh <name of file>.md

The file will be rendered as html and served on localhost:8000. Can be printed using browser print. Direct rendering yet to be implemented.
