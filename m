From: David Howells <dhowells@redhat.com>
Subject: Proto-tool to produce graphical schematic of path-taking syscall errors
Date: Thu, 24 Jul 2014 15:46:20 +0100
Message-ID: <12624.1406213180@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759005AbaGXOq0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 24 Jul 2014 10:46:26 -0400
Content-ID: <12623.1406213180.1@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, linux-unionfs@vger.kernel.org

Hi Miklos,

Attached is the beginnings of a tool that produces an HTML graphical schematic
of the errors returned by various path-taking syscalls (eg. open) for all the
relevant flags (leastways, the ones Python3 can operate).

To run it:

	./error-probe.py >error.html
	konqueror ./error.html # ... or whatever browser you prefer

It does its probing in /tmp/a/ but that is easily configurable by editing the
script.

I intend to break the tool into two parts:

 (1) A tool that probes a directory and produces a report file.

 (2) A tool that produces a graphical schematic comparing two report files.

David
---
#!/usr/bin/python3
#
# Probe for error messages
#

base = "/tmp/a/"
test = base + "foo"
test2 = base + "bar"

import os, errno, shutil

def prep_neg():
    """N"""
    return test

def prep_file():
    """F"""
    fd = os.open(test, os.O_CREAT|os.O_WRONLY)
    os.write(fd, b"hello")
    os.close(fd)
    return test

def prep_empty_dir():
    """E"""
    os.mkdir(test)
    return test

def prep_dir():
    """D"""
    os.mkdir(test)
    fd = os.open(test + "/a", os.O_CREAT|os.O_WRONLY)
    os.write(fd, b"hello")
    os.close(fd)
    return test

def prep_sym_neg():
    """LN"""
    os.symlink(test2, test)
    return test

def prep_sym_file():
    """LF"""
    fd = os.open(test2, os.O_CREAT|os.O_WRONLY)
    os.write(fd, b"hello")
    os.close(fd)
    os.symlink(test2, test)
    return test

def prep_sym_empty_dir():
    """LE"""
    os.mkdir(test2)
    os.symlink(test2, test)
    return test

def prep_sym_dir():
    """LD"""
    os.mkdir(test2)
    fd = os.open(test2 + "/a", os.O_CREAT|os.O_WRONLY)
    os.write(fd, b"hello")
    os.close(fd)
    os.symlink(test2, test)
    return test

def prep_neg_com():
    """CN"""
    name = prep_neg()
    return name + "/a"

def prep_file_com():
    """CF"""
    name = prep_file()
    return name + "/a"

def prep_symneg_com():
    """CLN"""
    name = prep_sym_neg()
    return name + "/a"

def prep_symfile_com():
    """CLF"""
    name = prep_sym_file()
    return name + "/a"

results_table = []

prep_funcs = [ prep_neg, prep_file, prep_empty_dir, prep_dir,
               prep_sym_neg, prep_sym_file, prep_sym_empty_dir, prep_sym_dir,
               prep_neg_com, prep_file_com,
               prep_symneg_com, prep_symfile_com ]

banner = [ "Syscall", "Flags" ]
for ts in [ "", "/" ]:
    for prep in prep_funcs:
        banner.append(prep.__doc__ + ts)

results = []
file_nr = 0
def begin(name, flags="-"):
    global file_nr, results
    results = [ (name, False), (flags, False) ]
    shutil.rmtree(base)
    os.mkdir(base)
    file_nr = 0

def advance():
    global file_nr, test, test2
    file_nr += 1
    test = base + "foo" + str(file_nr)
    test2 = base + "bar" + str(file_nr)

def no_error():
    global results
    results.append(("+", False))

def got_error(oe):
    global results
    err = errno.errorcode[oe.errno]
    results.append((err, False))

def commit():
    global results_table, results, test, test2
    results_table.append(results)
    results = None
    test = None
    test2 = None

###############################################################################
#
# Test open
#
###############################################################################
for d in [ 0, os.O_DIRECTORY ]:
    for c in [ 0, os.O_CREAT ]:
        for e in [ 0, os.O_EXCL ]:
            for t in [ 0, os.O_TRUNC ]:
                for a in [ 0, os.O_APPEND ]:
                    for rw in [ os.O_RDONLY, os.O_WRONLY, os.O_RDWR ]:
                        flags = ""
                        if d == os.O_DIRECTORY:
                            flags += "d"
                        if c == os.O_CREAT:
                            flags += "c"
                        if e == os.O_EXCL:
                            flags += "e"
                        if t == os.O_TRUNC:
                            flags += "t"
                        if a == os.O_APPEND:
                            flags += "a"
                        if rw == os.O_RDONLY or rw == os.O_RDWR:
                            flags += "r"
                        if rw == os.O_WRONLY or rw == os.O_RDWR:
                            flags += "w"

                        begin("open", flags)
                        for ts in [ "", "/" ]:
                            for prep in prep_funcs:
                                advance()
                                f = prep()
                                try:
                                    fd = os.open(f + ts, rw|a|c|e|t|d)
                                    os.close(fd)
                                    no_error()
                                except OSError as oe:
                                    got_error(oe)
                        commit()

###############################################################################
#
# Test unlink
#
###############################################################################
begin("unlink")
for ts in [ "", "/" ]:
    for prep in prep_funcs:
        advance()
        f = prep()
        try:
            os.unlink(f + ts)
            no_error()
        except OSError as oe:
            got_error(oe)
commit()

###############################################################################
#
# Test mkfifo
#
###############################################################################
begin("mkfifo")
for ts in [ "", "/" ]:
    for prep in prep_funcs:
        advance()
        f = prep()
        try:
            os.mkfifo(f + ts)
            no_error()
        except OSError as oe:
            got_error(oe)
commit()

###############################################################################
#
# Test symlink
#
###############################################################################
begin("symlink")
for ts in [ "", "/" ]:
    for prep in prep_funcs:
        advance()
        f = prep()
        try:
            os.symlink(test + "_sym", f + ts)
            no_error()
        except OSError as oe:
            got_error(oe)
commit()

###############################################################################
#
# Test mkdir
#
###############################################################################
begin("mkdir")
for ts in [ "", "/" ]:
    for prep in prep_funcs:
        advance()
        f = prep()
        try:
            os.mkdir(f + ts)
            no_error()
        except OSError as oe:
            got_error(oe)
commit()

###############################################################################
#
# Test chmod
#
###############################################################################
begin("chmod")
for ts in [ "", "/" ]:
    for prep in prep_funcs:
        advance()
        f = prep()
        try:
            os.chmod(f + ts, 0o755)
            no_error()
        except OSError as oe:
            got_error(oe)
commit()

###############################################################################
#
# Test chown
#
###############################################################################
begin("chown")
for ts in [ "", "/" ]:
    for prep in prep_funcs:
        advance()
        f = prep()
        try:
            os.chown(f + ts, os.getuid(), os.getgid())
            no_error()
        except OSError as oe:
            got_error(oe)
commit()

###############################################################################
#
# Test rmdir
#
###############################################################################
begin("rmdir")
for ts in [ "", "/" ]:
    for prep in prep_funcs:
        advance()
        f = prep()
        try:
            os.rmdir(f + ts)
            no_error()
        except OSError as oe:
            got_error(oe)
commit()

###############################################################################
#
# Test truncate
#
###############################################################################
begin("truncate")
for ts in [ "", "/" ]:
    for prep in prep_funcs:
        advance()
        f = prep()
        try:
            os.truncate(f + ts, 1)
            no_error()
        except OSError as oe:
            got_error(oe)
commit()

###############################################################################
#
# Test readlink
#
###############################################################################
begin("readlink")
for ts in [ "", "/" ]:
    for prep in prep_funcs:
        advance()
        f = prep()
        try:
            os.readlink(f + ts)
            no_error()
        except OSError as oe:
            got_error(oe)
commit()

###############################################################################
#
# Test access
#
###############################################################################
for flag in [ "-", "n" ]:
    begin("access", flag)
    for ts in [ "", "/" ]:
        for prep in prep_funcs:
            advance()
            f = prep()
            try:
                if flag == "n":
                    os.access(f + ts, os.R_OK, follow_symlinks=False)
                else:
                    os.access(f + ts, os.R_OK)
                no_error()
            except OSError as oe:
                got_error(oe)
    commit()

###############################################################################
#
# Test stat
#
###############################################################################
for flag in [ "-", "n" ]:
    begin("stat", flag)
    for ts in [ "", "/" ]:
        for prep in prep_funcs:
            advance()
            f = prep()
            try:
                if flag == "n":
                    os.stat(f + ts, follow_symlinks=False)
                else:
                    os.stat(f + ts)
                no_error()
            except OSError as oe:
                got_error(oe)
    commit()

###############################################################################
#
# Test utime
#
###############################################################################
for flag in [ "-", "n" ]:
    begin("utime", flag)
    for ts in [ "", "/" ]:
        for prep in prep_funcs:
            advance()
            f = prep()
            try:
                if flag == "n":
                    os.utime(f + ts, follow_symlinks=False)
                else:
                    os.utime(f + ts)
                no_error()
            except OSError as oe:
                got_error(oe)
    commit()

###############################################################################
#
# Test getxattr
#
###############################################################################
for flag in [ "-", "n" ]:
    begin("getxattr", flag)
    for ts in [ "", "/" ]:
        for prep in prep_funcs:
            advance()
            f = prep()
            try:
                if flag == "n":
                    os.getxattr(f + ts, "security.selinux", follow_symlinks=False)
                else:
                    os.getxattr(f + ts, "security.selinux")
                no_error()
            except OSError as oe:
                got_error(oe)
    commit()

###############################################################################
#
# Test listxattr
#
###############################################################################
for flag in [ "-", "n" ]:
    begin("listxattr", flag)
    for ts in [ "", "/" ]:
        for prep in prep_funcs:
            advance()
            f = prep()
            try:
                if flag == "n":
                    os.listxattr(f + ts, follow_symlinks=False)
                else:
                    os.listxattr(f + ts)
                no_error()
            except OSError as oe:
                got_error(oe)
    commit()

###############################################################################
#
# Test rename
#
###############################################################################
for ts_s in [ "", "/" ]:
    for prep_s in prep_funcs:
        slash = ""
        if ts_s == "/":
            slash = "/"
        begin("rename", "|<CODE><B>" + prep_s.__doc__ + slash + "</B></CODE>")
        for ts_d in [ "", "/" ]:
            for prep_d in prep_funcs:
                advance()
                f_s = prep_s()
                advance()
                f_d = prep_d()
                try:
                    os.rename(f_s + ts_s, f_d + ts_d)
                    no_error()
                except OSError as oe:
                    got_error(oe)
        commit()

###############################################################################
#
# Test hard linking
#
###############################################################################
for ts_s in [ "", "/" ]:
    for prep_s in prep_funcs:
        slash = ""
        if ts_s == "/":
            slash = "/"
        begin("link", "|<CODE><B>" + prep_s.__doc__ + slash + "</B></CODE>")
        for ts_d in [ "", "/" ]:
            for prep_d in prep_funcs:
                advance()
                f_s = prep_s()
                advance()
                f_d = prep_d()
                try:
                    os.link(f_s + ts_s, f_d + ts_d)
                    no_error()
                except OSError as oe:
                    got_error(oe)
        commit()

###############################################################################
#
# Dump the results
#
###############################################################################
#for r in results_table:
#    print(r[0:2])
#exit(88)

nrow = len(results_table)
ncol = len(results_table[0])

colours = {
    "+"         : "lightgreen",
    "ENOENT"    : "#fff0f0",
    "ENOTDIR"   : "#f0c080",
    "EISDIR"    : "#ffffb0",
    "EEXIST"    : "#f04040",
    "ENOTEMPTY" : "#b04040",
    "EINVAL"    : "#5040ff",
    "EPERM"     : "#7030ff",
    }

print("<HTML>")
print("<BODY>")

print("<TABLE border=1>")
print("<TR><TD><CODE><B>N</B></CODE></TD><TD>Non-existent name</TD></TR>")
print("<TR><TD><CODE><B>F</B></CODE></TD><TD>Ordinary file</TD></TR>")
print("<TR><TD><CODE><B>E</B></CODE></TD><TD>Empty directory</TD></TR>")
print("<TR><TD><CODE><B>D</B></CODE></TD><TD>Populated directory</TD></TR>")
print("<TR><TD><CODE><B>L<I>x</I></B></CODE></TD><TD>Symlink to <I>x</I></TD></TR>")
print("<TR><TD><CODE><B>C<I>x</I></B></CODE></TD><TD>Non-directory path component <I>x</I></TD></TR>")
print("<TR><TD><CODE><B>/</B></CODE></TD><TD>Pathname terminated with a '/'</TD></TR>")
print("</TABLE>")
print("<P>")


print("<TABLE rules=\"rows\">")
print("<COLGROUP>")
print("<COL width=\"1*\">")
print("<COL width=\"1*\">")
print("</COLGROUP>")
print("<COLGROUP>")
for c in range(2, ncol):
    print("<COL width=\"1*\">")
print("</COLGROUP>")

print("<TR>")
print("<TH>" + banner[0] + "</TH>")
print("<TH>" + banner[1] + "</TH>")
for val in banner[2:]:
    #if len(val) < 7:
    #    val += "       "[0:(7 - len(val))]
    for i in range(0, 7 - len(val)):
        val += "&nbsp;"
    print("<TH><CODE>" + val + "</CODE></TH>")
print("</TR>")

def extract_key(a):
    return -a[0]

# Merge together rectangular regions with same values in order of
# descending size
rects = []
for r in range(0, nrow):
    row = results_table[r]
    for c in range(0, ncol):
        if c == 1:
            continue
        hspan = 1
        vspan = 1
        (val, merged) = results_table[r][c]
        for nc in range(c + 1, ncol):
            if nc == 1:
                break
            if row[nc] != (val, False):
                break
            hspan += 1
        for nr in range(r + 1, nrow):
            if results_table[nr][c] != (val, False):
                break
            vspan += 1
            for nc in range(c + 1, c + hspan):
                if results_table[nr][nc] != (val, False):
                    hspan = nc - c
                    break
        assert(r + vspan <= nrow)
        assert(c + hspan <= ncol)
        if hspan * vspan >= 2:
            rects.append((hspan * vspan, r, c, hspan, vspan))

rects.sort(key=extract_key)
for n in range(0, len(rects)):
    rect = rects[n]
    if rect == None:
        continue
    (area, r, c, hspan, vspan) = rect

    # Eliminate overlapping rectangles
    for n2 in range(n, len(rects)):
        rect2 = rects[n2]
        if rect2 == None:
            continue
        (area2, r2, c2, hspan2, vspan2) = rect2

        if r2 > r + vspan - 1 or r2 + vspan2 - 1 < r:
            continue
        if c2 > c + hspan - 1 or c2 + hspan2 - 1 < c:
            continue

        # We could shrink the smaller rectangle, but that would
        # necessitate moving it within rects[]
        rects[n2] = None

    # Mark merged cells
    (val, merged) = results_table[r][c]
    for nr in range(r, r + vspan):
        for nc in range(c, c + hspan):
            results_table[nr][nc] = (val, True)
    results_table[r][c] = (val, rect)

# Dump the table
for r in range(0, nrow):
    row = results_table[r]
    print("<TR>")
    for c in range(0, ncol):
        (val, merged) = results_table[r][c]
        if merged == True:
            continue
        hspan = 1
        vspan = 1
        if c == 1:
            pass
        elif merged == False:
            for nc in range(c + 1, ncol):
                if row[nc] != (val, False):
                    break
                hspan += 1
            for nr in range(r + 1, nrow):
                if results_table[nr][c] != (val, False):
                    break
                vspan += 1
                for nc in range(c + 1, c + hspan):
                    if results_table[nr][nc] != (val, False):
                        hspan = nc - c
                        break
            if hspan > 1 or vspan > 1:
                for nr in range(r, r + vspan):
                    for nc in range(c, c + hspan):
                        if nr == r and nc == c:
                            continue
                        results_table[nr][nc] = (val, True)
        else:
            (area, r, c, hspan, vspan) = merged


        colour = "white"
        if val in colours:
            colour = colours[val]

        al = "left"
        if c >= 2:
            al = "center"

        print("<TD rowspan=\"" + str(vspan) + "\" colspan=\"" + str(hspan) + "\" bgcolor=\"" + colour + "\" align=\"" + al + "\">" + val + "</TD>")
    print("</TR>")

print("</TABLE>")
print("</BODY>")
print("</HTML>")

