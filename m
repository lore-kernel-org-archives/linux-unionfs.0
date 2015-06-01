From: David Howells <dhowells@redhat.com>
Subject: Can ovl_drop_write() be called earlier in ovl_dentry_open()
Date: Mon, 01 Jun 2015 14:52:16 +0100
Message-ID: <21902.1433166736@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643AbbFANwV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 1 Jun 2015 09:52:21 -0400
Content-ID: <21901.1433166736.1@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, dhowells@redhat.com

In ovl_dentry_open(), ovl_drop_write() is called after vfs_open() - but is
this actually necessary?  Can't we just drop it post-copyup?  After all,
that's all we wanted the write lock for, right?

David
---
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -356,16 +356,14 @@ static int ovl_dentry_open(struct dentry *dentry, struct inode *inode,
 			err = ovl_copy_up_last(dentry, NULL, true);
 		else
 			err = ovl_copy_up(dentry);
+		ovl_drop_write(dentry);
 		if (err)
-			goto out_drop_write;
+			goto out;
 
 		ovl_path_upper(dentry, &realpath);
 	}
 
 	err = vfs_open(&realpath, d_backing_inode(realpath.dentry), file, cred);
-out_drop_write:
-	if (want_write)
-		ovl_drop_write(dentry);
 out:
 	return err;
 }
