import re
import os
import sys

boilerplate_pre = """
<!DOCTYPE HTML>
<html>
	<head>
		<title>Markdown to HTML</title>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
		<link rel="stylesheet" href="assets/css/main.css" />
	</head>
	<body class="is-preload">

		<!-- Wrapper -->
			<div id="wrapper">

				<!-- Main -->
					<div id="main">
						<div class="inner">

							<!-- Header -->
								<header id="header">
									<a href="#" class="logo"><strong>HEADER_STRONG_1</strong> HEADER_NORMAL <strong>HEADER_STRONG_2</strong></a>
								</header>

							<!-- Content -->
								<section>
"""
boilerplate_post = """
								</section>
						</div>
					</div>

			</div>

		<!-- Scripts -->
			<script src="assets/js/jquery.min.js"></script>
			<script src="assets/js/browser.min.js"></script>
			<script src="assets/js/breakpoints.min.js"></script>
			<script src="assets/js/util.js"></script>
			<script src="assets/js/main.js"></script>

	</body>
</html>
"""
table_head = """
<div class="table-wrapper">
    <table class="alt">
"""
table_end = """
    </table>
</div>
"""

def escape_html(line):
    line = line.replace('<', '&lt;')
    return line.replace('>', '&gt;')

def render_heading(line):
    if line[:2] == "# ":
        item = line.split("#")[-1].strip("\n").strip()
        return '<h2>' + escape_html(item) + '</h2>\n'
    elif line[:3] == "## ":
        item = line.split("#")[-1].strip("\n").strip()
        return '<h3>' + escape_html(item) + '</h3>\n'
    elif line[:4] == "### ":
        item = line.split("#")[-1].strip("\n").strip()
        return '<h4>' + escape_html(item) + '</h4>\n'
    elif line[:5] == "#### ":
        item = line.split("#")[-1].strip("\n").strip()
        return '<p>' + escape_html(item) + '</p>\n'
    else:
        return ''

def inline_convert(line):
    line = escape_html(line)
    line = re.sub('\*\*(.*?)\*\*', r'<b>\1</b>', line)
    line = re.sub('\*(.*?)\*', r'<em>\1</em>', line)
    line = re.sub('!\[(.+?)\]\((.+?)\)', r'<figure><img src="\2" /><figcaption>\1</figcaption></figure>', line)
    line = re.sub('\[(.+?)\]\((.+?)\)', r'<a href="\2">\1</a>', line)
    line = re.sub('`(.*?)`', r'<code>\1</code>', line)
    return line.strip("\n")

def process(data):
    i = 0
    middle_html = ""
    while i < len(data):
        if data[i] == "---" or data[i] == "***" or data[i] == "---\n" or data[i] == "***\n":
            middle_html += '<hr class="major" />\n'
            i += 1
        elif "```" in data[i]:
            i += 1
            middle_html += "<pre><code>"
            while "```" not in data[i]:
                middle_html += escape_html(data[i])
                i += 1
            middle_html += "</code></pre>\n"
            i += 1
        elif data[i] == "<!-- start bullet list -->\n":
            i += 1
            middle_html += "<ul>\n"
            while data[i] != "<!-- end bullet list -->\n":
                middle_html += "<li>" + inline_convert(data[i][2:]) + "</li>\n"
                i += 1
            middle_html += "</ul>\n"
            i += 1
        elif data[i] == "<!-- start number list -->\n":
            i += 1
            middle_html += "<ol>\n"
            while data[i] != "<!-- end number list -->\n":
                line_to_edit = re.search('^[0-9]{1,2}\. (.+)', data[i]).group(1)
                middle_html += "<li>" + inline_convert(line_to_edit) + "</li>\n"
                i += 1
            middle_html += "</ol>\n"
            i += 1
        elif data[i] == "<!-- start table -->\n":
            middle_html += table_head
            i += 1
            headers = data[i].split("|")[1:-1]
            i += 2
            elements = []
            while data[i] != "<!-- end table -->\n":
                elements.append(data[i].split("|")[1:-1])
                i += 1
            middle_html += process_table(headers, elements)
            middle_html += table_end
            i += 1
        elif data[i].startswith("#"):
            middle_html += render_heading(data[i])
            i += 1
        elif data[i] == "\n":
            middle_html += "\n"
            i += 1
        else:
            middle_html += ("<p>" + inline_convert(data[i]) + "</p>\n")
            i += 1
    
    return middle_html

def process_table(headers, elements):
    to_return = "<thead><tr>\n"
    for i in headers:
        to_return += ("<th>" + inline_convert(i) + "</th>\n")
    to_return += "</tr></thead><tbody>\n"
    for i in elements:
        to_return += "<tr>\n"
        for j in i:
            to_return += "<td>" + inline_convert(j) + "</td>\n"
        to_return += "</tr>\n"
    to_return += "</tbody>\n"
    return to_return

def main():
    md_file = sys.argv[1]
    f = open(md_file, "r")
    md_text = f.readlines()
    f.close()

    boilerplate_pre_formatted = boilerplate_pre.replace("HEADER_STRONG_1", os.environ["HS1"])
    boilerplate_pre_formatted = boilerplate_pre_formatted.replace("HEADER_NORMAL", os.environ["HN"])
    boilerplate_pre_formatted = boilerplate_pre_formatted.replace("HEADER_STRONG_2", os.environ["HS2"])

    middle_html = process(md_text)

    f = open("/root/index.html", "w")
    f.write(boilerplate_pre_formatted + middle_html + boilerplate_post)
    f.close()

if __name__=="__main__":
    main()
