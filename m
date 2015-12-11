From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH 1/2] ovl: also update attr on ovl level inode in ovl_setattr()
Date: Fri, 11 Dec 2015 17:34:47 +0800
Message-ID: <1449826488-2489-1-git-send-email-guaneryu@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:34081 "EHLO
	mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbbLKJey (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 11 Dec 2015 04:34:54 -0500
Received: by pfcc203 with SMTP id c203so1584206pfc.1
        for <linux-unionfs@vger.kernel.org>; Fri, 11 Dec 2015 01:34:53 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, Eryu Guan <guaneryu@gmail.com>

suid and sgid should be cleared when unprivileged user writes to such
files. Overlayfs fails to do so because of the ovl level inode has no
S_ISUID or S_ISGID set and should_remove_suid() fails to set
ATTR_KILL_[SG]ID. xfstests generic/193 reveals the failure on overlayfs.

echo test > /mnt/overlay/testfile
chmod a+s /mnt/overlay/testfile
chown test:test /mnt/overlay/testfile
su test -c "echo > /mnt/overlay/testfile"

The suid bit should be cleard after being written by test user.

Fix it by updating attr on ovl level inode in ovl_setattr(), so the attr
is consistent with inode in upper level.

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 fs/overlayfs/inode.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 4060ffd..dbe0815 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -50,11 +50,22 @@ int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 	if (!err) {
 		upperdentry = ovl_dentry_upper(dentry);
 
+		/*
+		 * notify_change() assumes ATTR_KILL_[SG]ID and ATTR_MODE are
+		 * not set at the same time. Clear ATTR_MODE before we call the
+		 * next notify_change().
+		 */
+		if ((attr->ia_valid & (ATTR_KILL_SUID | ATTR_KILL_SGID)) &&
+		    (attr->ia_valid & ATTR_MODE))
+			attr->ia_valid &= ~ATTR_MODE;
 		mutex_lock(&upperdentry->d_inode->i_mutex);
 		err = notify_change(upperdentry, attr, NULL);
 		mutex_unlock(&upperdentry->d_inode->i_mutex);
 	}
 	ovl_drop_write(dentry);
+	/* Also update the inode in ovl level, for consistency. */
+	if (!err)
+		setattr_copy(d_inode(dentry), attr);
 out:
 	return err;
 }
-- 
1.8.3.1
