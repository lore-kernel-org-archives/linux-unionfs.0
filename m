From: "Andrey Jr. Melnikov" <temnota.am@gmail.com>
Subject: [PATCH] Fix overlayfs inotify interaction
Date: Thu, 30 Jun 2016 14:04:20 +0300
Message-ID: <20160630105956.GA9949@ppc.Dlink>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:34947 "EHLO
	mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbcF3LE0 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 30 Jun 2016 07:04:26 -0400
Received: by mail-lf0-f66.google.com with SMTP id w130so8020988lfd.2
        for <linux-unionfs@vger.kernel.org>; Thu, 30 Jun 2016 04:04:25 -0700 (PDT)
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Cc: John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>, Eric Paris <eparis@parisplace.org>

 Fix overlayfs inotify interaction - use d_real_inode() helper
 to resolve real (underlying) inode. Without this inotify is not functional on
 overlayfs.

Signed-off-by: Andrey Jr. Melnikov <temnota.am@gmail.com>

---
Runtime tested with inotifywait in monitor mode to confirm event generation.

cd /tmp/ && mkdir dest upper lower work
mount -t overlay none dest -o upperdir=upper/,lowerdir=lower/,workdir=work/
while /bin/true; do echo test >>/tmp/dest/lower-data; sleep 5; done &
inotifywait -m /tmp/dest/lower-data

 fs/notify/inotify/inotify_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index b8d08d0..592ce16 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -742,7 +742,7 @@ SYSCALL_DEFINE3(inotify_add_watch, int, fd, const char __user *, pathname,
 		goto fput_and_out;
 
 	/* inode held in place by reference to path; group by fget on fd */
-	inode = path.dentry->d_inode;
+	inode = d_real_inode(path.dentry);
 	group = f.file->private_data;
 
 	/* create/update an inode mark */
-- 
2.8.1
