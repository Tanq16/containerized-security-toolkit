# Enumeration

Machine IP &rarr; `192.168.192.128`

### Network Scan

Nmap scan &rarr; `nmap -A -Pn -p- -T4 -o nmap.txt 192.168.192.128`

OS Detection &rarr;  `OS: Linux; CPE: cpe:/o:linux:linux_kernel`

| __*Port*__ | __*Service*__ | __*Other details (if any)*__ |
| :---: | :---: | :---: |
| 22 | SSH | OpenSSH 7.9p1 Debian 10+deb10u2 (protocol 2.0) |
| 80 | HTTP | Apache httpd 2.4.38 ((Debian)) |
| 88 | KERBEROS-SEC | nginx 1.14.2 |
| 110 | POP3 | Courier pop3d |
| 995 | POP3S | Courier pop3d |

### Web Scan

GoBuster scan &rarr; `gobuster dir -u http://192.168.192.128 -f -w /home/tanq/installations/SecLists/Discovery/Web-Content/directory-list-lowercase-2.3-medium.txt -x html,php,txt`

Directories/files listed &rarr;
* index.php
* index.html
* search.php
* rss.php
* icons/ (403)
* docs/
* print.php
* uploads/
* skins/
* core/
* manual/
* popup.php
* captcha.php
* example.php
* libs/
* snippet.php
* show_news.php
* cdata/
* server-status

The webserver is also running Cute News Management System powered by `CuteNews 2.1.2`.

---

# Exploitation

Using searchsploit to look at existing vulnerabilities, there are 4 results for the version of CuteNews being run on the system. looking at the RCE expoloit, the python code has easy to understand steps.

Basically, the vulnerability is the ability to upload a reverse shell in place of the avatar for a given user and then navigating to it. The exploit requires various steps. The first is to register a user. This was done at the `/index.php?register` page. This required a captcha value, which did not load inline on the page. Without eefort, the `captcha.php` file found in directory busting gives the captcha code directly. Therefore, a user was registered.

Next, the avatar for the user must be updated. This was done by navigating to `/index.php?mod=main&opt=personal` page. The php reverse shell from pentest monkey is used as the file for upload here. However, this file is rejected. This implies that the server does check for file names or file headers. By hit and trial, the headers are being checked and not the extensions.

Therefore, like the exploit-db version of the RCE, the php code must be prepended with the `GIF8;\n` header to trick the server to think it is an image file. Also, the `Content-Type` header is not checked for file type. The reverse shell uploads successfully and navigating to it at `/uploads/avatar_<username>_php_rev.php` executes the php code and gives the reverse shell. The user flag is also obtained via the `www-data` permissions.

---

# Privilege Escalation

Enumerating `sudo -l` and setuid files, the interesting option is that of `hping3`. Even if the `sudo -l` says only `--icmp` mode is allowed, since it is a setuid binary, the interface of hping3 can be sirectly exposed. The direct invocation of `hping3` allows for a application shell to execute. This does support usual bash commands.

`whoami` shows the permissions of `root`. Therefore, using the hping3 shell, the root flag can be obtained as well.

---