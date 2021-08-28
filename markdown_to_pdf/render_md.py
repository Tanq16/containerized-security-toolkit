import re
import sys

boilerplate_pre = """
<!DOCTYPE HTML>
<html>
	<head>
		<title>BOX_NAME_TO_BE_REPLACED</title>
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
									<a href="#" class="logo"><strong>BOX_NAME_TO_BE_REPLACED</strong> security assessment by <strong>Tanishq Rupaal</strong></a>
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
        <thead>
            <tr>
                <th>Port</th>
                <th>Service</th>
                <th>Other details (if any)</th>
            </tr>
        </thead>
        <tbody>
"""
table_end = """
        </tbody>
    </table>
</div>
"""

def render_general(line):
    line = escape_html(line)
    line = re.sub('\[(.+?)\]\((.+?)\)', r'<a href="\2">\1</a>', line)
    return "<p>" + re.sub('`(.*?)`', r'<code>\1</code>', line.strip("\n")) + "</p>\n"

def render_heading(line):
    if line[:2] == "# ":
        item = line.split("#")[-1].strip("\n").strip()
        return '<h2 id="' + item + '">' + item + '</h2>\n'
    elif line[:4] == "### ":
        item = line.split("#")[-1].strip("\n").strip()
        return '<h3>' + item + '</h3>\n'
    else:
        return ''

def escape_html(line):
    line = line.replace('<', '&lt;')
    return line.replace('>', '&gt;') 

def render_line(line):
    if line.startswith("#"):
        return render_heading(line)
    elif line == "---\n" or line == "---":
        return '<hr class="major" />\n'
    elif line == "\n":
        return ""
    else:
        return render_general(line)
    
def main():
    md_file = sys.argv[1]
    f = open(md_file, "r")
    md_text = f.readlines()
    f.close()

    middle_html = ""

    i = 0
    while i < len(md_text):
        if "```" in md_text[i]:
            i += 1
            middle_html += "<pre><code>"
            while "```" not in md_text[i]:
                middle_html += md_text[i]
                i += 1
            middle_html += "</code></pre>\n"
            i += 1
        elif md_text[i].startswith("*"):
            middle_html += "<ul>\n"
            while md_text[i].startswith("*"):
                line_new = re.sub('`(.*?)`', r'<code>\1</code>', escape_html(md_text[i]).strip("\n"))
                middle_html += "<li>" + line_new.split("*")[-1].strip().strip("\n") + "</li>\n"
                i += 1
            middle_html += "</ul>\n"
        elif md_text[i].startswith("|"):
            middle_html += table_head
            i += 2
            while md_text[i].startswith("|"):
                vals = md_text[i].split("|")
                middle_html += "<tr>\n"
                middle_html += "<td>" + (vals[1]) + "</td>\n" + "<td>" + (vals[2]) + "</td>\n" + "<td>" + (vals[3]) + "</td>\n"
                middle_html += "</tr>\n"
                i += 1
            middle_html += table_end
        middle_html += render_line(md_text[i])
        i += 1
    
    f = open("/root/index.html", "w")
    box_name = md_file.split("/")[-1].split(".")[0]
    f.write(boilerplate_pre.replace("BOX_NAME_TO_BE_REPLACED", box_name) + middle_html + boilerplate_post)
    f.close()

if __name__ == '__main__':
    main()


"""
1. inline conversion - bold italics strikethrough etc., image, link and inline code
2. Line level - para, bullet, child bullet, numbered, child numbered, headings, hline
3. Para level - Table, code block

Give comment help for table, code and lists. Lists comment for sublists as well.
"""