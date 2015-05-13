From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH] unionmount-testsuite: test rmdir of non-empty opaque dir
Date: Wed, 13 May 2015 17:15:02 +0200
Message-ID: <20150513151502.GB19583@tucsk.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:36507 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934415AbbEMPMp (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 13 May 2015 11:12:45 -0400
Received: by wgbhc8 with SMTP id hc8so13444155wgb.3
        for <linux-unionfs@vger.kernel.org>; Wed, 13 May 2015 08:12:44 -0700 (PDT)
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Vincent Batts <vbatts@gmail.com>, linux-unionfs@vger.kernel.org

---
 tests/rmdir.py |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/tests/rmdir.py
+++ b/tests/rmdir.py
@@ -203,3 +203,19 @@ from errno import *
     ctx.rmdir(sym, err=ENOTDIR)
     ctx.rmdir(sym, err=ENOTDIR)
     ctx.rmdir(d, err=ENOENT)
+
+# Remove an empty lower directory, recreate, populate and try to remove
+def subtest_16(ctx):
+    """Remove non-empty opaque directory"""
+    d = ctx.empty_dir() + ctx.termslash()
+    f = d + "/b"
+
+    ctx.rmdir(d)
+    ctx.rmdir(d, err=ENOENT)
+    ctx.mkdir(d, 0o755)
+    ctx.open_file(f, wo=1, crt=1, ex=1, write="abcq")
+    ctx.rmdir(d, err=ENOTEMPTY)
+    ctx.unlink(f)
+    ctx.open_file(f, ro=1, err=ENOENT)
+    ctx.unlink(f, err=ENOENT)
+    ctx.rmdir(d)
