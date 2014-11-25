From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH] testsuite: overlayfs -> overlay
Date: Tue, 25 Nov 2014 16:47:00 +0100
Message-ID: <20141125154700.GB9137@tucsk.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:52058 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaKYPqu (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 25 Nov 2014 10:46:50 -0500
Received: by mail-wg0-f52.google.com with SMTP id a1so1216210wgh.25
        for <linux-unionfs@vger.kernel.org>; Tue, 25 Nov 2014 07:46:49 -0800 (PST)
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-unionfs@vger.kernel.org

Hello David,

Following patch fixes testsuite to use the right fstype.  This was changed in
linux tree by

  ef94b1864d1e  ovl: rename filesystem type to "overlay"

Thanks,
Miklos

---
 mount_union.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mount_union.py
+++ b/mount_union.py
@@ -27,6 +27,6 @@ from tool_box import *
         workdir = upper_mntroot + "/work"
         os.mkdir(upperdir)
         os.mkdir(workdir)
-        system("mount -t overlayfs overlayfs " + union_mntroot +
+        system("mount -t overlay overlay " + union_mntroot +
                " -olowerdir=" + lower_mntroot + ",upperdir=" + upperdir + ",workdir=" + workdir)
         ctx.note_upper_fs(upper_mntroot, testdir)
