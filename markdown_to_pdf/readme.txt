Build using -
docker build -t tanq16/sec_docker:render .

Run using -
docker run --name "render_md" -p 8000:8000 -v <markdown files store>/:/root/md_files/ --rm -it tanq16/sec_docker:render bash /root/run.sh <filename>.md

The file will be rendered as html and served on localhost:8000
