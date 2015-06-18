From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/8] overlay: Call ovl_drop_write() earlier in
 ovl_dentry_open()
Date: Thu, 18 Jun 2015 14:32:23 +0100
Message-ID: <20150618133223.12722.1869.stgit@warthog.procyon.org.uk>
References: <20150618133215.12722.70352.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065AbbFRNc3 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 18 Jun 2015 09:32:29 -0400
In-Reply-To: <20150618133215.12722.70352.stgit@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: sds@tycho.nsa.gov, viro@zeniv.linux.org.uk, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, dhowells@redhat.com, linux-security-module@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org

Call ovl_drop_write() earlier in ovl_dentry_open() before we call vfs_open()
as we've done the copy up for which we needed the freeze-write lock by that
point.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/overlayfs/inode.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 308379b2d0b2..21079d1ca2aa 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -343,31 +343,25 @@ static int ovl_dentry_open(struct dentry *dentry, struct file *file,
 	int err;
 	struct path realpath;
 	enum ovl_path_type type;
-	bool want_write = false;
 
 	type = ovl_path_real(dentry, &realpath);
 	if (ovl_open_need_copy_up(file->f_flags, type, realpath.dentry)) {
-		want_write = true;
 		err = ovl_want_write(dentry);
 		if (err)
-			goto out;
+			return err;
 
 		if (file->f_flags & O_TRUNC)
 			err = ovl_copy_up_last(dentry, NULL, true);
 		else
 			err = ovl_copy_up(dentry);
+		ovl_drop_write(dentry);
 		if (err)
-			goto out_drop_write;
+			return err;
 
 		ovl_path_upper(dentry, &realpath);
 	}
 
-	err = vfs_open(&realpath, file, cred);
-out_drop_write:
-	if (want_write)
-		ovl_drop_write(dentry);
-out:
-	return err;
+	return vfs_open(&realpath, file, cred);
 }
 
 static const struct inode_operations ovl_file_inode_operations = {
