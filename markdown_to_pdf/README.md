# Markdown to PDF (HTML) Docker

This image can be used to render a webpage from a markdown file. The intent is to use a great looking template and produce high quality webpages. The html template used for this is at [html5up - editorial](https://html5up.net/editorial).

The best way to use this is to build the image like mentioned under the first section. It can then be run as follows &rarr;
```bash
docker run --name "render_md" \
-p 8000:8000 \
-e HS1="page header strong 1" -e HN="page header normal" -e HS2="page header strong 2" \
-v <md file and images directory>:/root/md_files/ \
--rm -it <image_tag> bash /root/run.sh <name of file>.md
```

The page has a header on top which follows the a bold-normal-bold format. These are controlled using the env variables of HS1, HN and HS2 passed in the run command above. They can be left as empty strings as well if a header is not needed.

This command will serve the rendered output on port 8000 and can be accessible at `http://localhost:8000/`. From here, the browser print option can be used to print the PDF version of the rendered file.

The markdown rendering script is a naive one and requires the following hard requirements to be followed &rarr;
<!-- start bullet list -->
* Any kind of headings (`# heading` to `### heading`) are supported and `#### heading` produces normal text
* Tables should be preceded by an html comment `<!-- start table -->` and ended by `<!-- end table -->`
* Only single level bulleted lists using `*` are supprted and lists must be enclose between the `<!-- start bullet list -->` and `<!-- end bullet list -->` lines
* Only single level numbered lists are supported and they must be enclosed between `<!-- start number list -->` and `<!-- end number list -->`
* Blockquotes are not supported yet
* Images and links follow normal format
* Horizontal lines are supported as `---`
<!-- end bullet list -->

An example markdown file is present inside the directory.

---