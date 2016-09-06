From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH] overlayfs: During copy up, switch to mounter's creds early
Date: Tue, 6 Sep 2016 13:40:32 -0400
Message-ID: <20160906174032.GA14087@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42006 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935507AbcIFRke (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Sep 2016 13:40:34 -0400
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, Paul Moore <pmoore@redhat.com>, linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Daniel J Walsh <dwalsh@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>

I have generated this patch on top of paul moore's selinux tree next
branch.

http://git.infradead.org/users/pcmoore/selinux next

Now, we have the notion that copy up of a file is done with the creds
of mounter of overlay filesystem (as opposed to task). Right now before
we switch creds, we do some vfs_getattr() operations in the context of
task and that itself can fail. We should do that getattr() using the
creds of mounter instead.

So this patch switches to mounter's creds early during copy up process so
that even vfs_getattr() is done with mounter's creds.

Two issues have been found during selinux testsuite testing with overlayfs
selinux patches.

https://github.com/SELinuxProject/selinux-testsuite/pull/4

And

https://github.com/SELinuxProject/selinux-testsuite/pull/2#issuecomment-244382478

Following are more details of first issue.

Client is trying to create a file inside a dir accessible to mounter but not
client. That is a context= mount with a label so that client can write. So
client should be able to create file inside directory. But client fails to
create file becuase during directory copy up, we try to do getattr() in the
context of task and that's denied. getattr() should have been done in the
context of mounter instead and that passes.

type=AVC msg=audit(1473182760.865:4048): avc:  denied  { getattr } for
 pid=19660 comm="touch" path="/mounterdir" dev="dm-0" ino=2128501
scontext=unconfined_u:unconfined_r:test_overlay_client_t:s0:c10,c20
tcontext=unconfined_u:object_r:test_overlay_mounter_files_t:s0 tclass=dir
permissive=0

Following are details of second issue.

A file is not accessible to both client and mounter and client tries to
touch file (with context= mount option). Given it is context= mount, client
checks on overlay inode will succeed. Only when mounter tries to do actual
operation on underlying file, it should fail. But in this case, copy_up()
code tries to do getattr() in the context of task (instead of context of
mounter), and gets the confusing avc.

type=AVC msg=audit(1472826175.533:437): avc: denied { getattr } for pid=3363
comm="touch" path="/noaccessfile" dev="dm-0" ino=2508742
scontext=unconfined_u:unconfined_r:test_overlay_client_t:s0:c10,c20
tcontext=unconfined_u:object_r:test_overlay_files_noaccess_t:s0 tclass=file
permissive=0 

This avc should have had source context of mounter instead of client.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/copy_up.c |    7 +++----
 fs/overlayfs/inode.c   |    3 +++
 2 files changed, 6 insertions(+), 4 deletions(-)

Index: pcmoore-linux/fs/overlayfs/copy_up.c
===================================================================
--- pcmoore-linux.orig/fs/overlayfs/copy_up.c	2016-08-18 08:39:41.915253749 -0400
+++ pcmoore-linux/fs/overlayfs/copy_up.c	2016-09-06 11:09:32.388648720 -0400
@@ -358,7 +358,6 @@ int ovl_copy_up_one(struct dentry *paren
 	struct path parentpath;
 	struct dentry *upperdir;
 	struct dentry *upperdentry;
-	const struct cred *old_cred;
 	char *link = NULL;
 
 	if (WARN_ON(!workdir))
@@ -379,8 +378,6 @@ int ovl_copy_up_one(struct dentry *paren
 			return PTR_ERR(link);
 	}
 
-	old_cred = ovl_override_creds(dentry->d_sb);
-
 	err = -EIO;
 	if (lock_rename(workdir, upperdir) != NULL) {
 		pr_err("overlayfs: failed to lock workdir+upperdir\n");
@@ -401,7 +398,6 @@ int ovl_copy_up_one(struct dentry *paren
 	}
 out_unlock:
 	unlock_rename(workdir, upperdir);
-	revert_creds(old_cred);
 
 	if (link)
 		free_page((unsigned long) link);
@@ -412,8 +408,10 @@ out_unlock:
 int ovl_copy_up(struct dentry *dentry)
 {
 	int err;
+	const struct cred *old_cred;
 
 	err = 0;
+	old_cred = ovl_override_creds(dentry->d_sb);
 	while (!err) {
 		struct dentry *next;
 		struct dentry *parent;
@@ -446,5 +444,6 @@ int ovl_copy_up(struct dentry *dentry)
 		dput(next);
 	}
 
+	revert_creds(old_cred);
 	return err;
 }
Index: pcmoore-linux/fs/overlayfs/inode.c
===================================================================
--- pcmoore-linux.orig/fs/overlayfs/inode.c	2016-08-18 08:39:41.915253749 -0400
+++ pcmoore-linux/fs/overlayfs/inode.c	2016-09-06 12:30:21.488049635 -0400
@@ -18,6 +18,7 @@ static int ovl_copy_up_truncate(struct d
 	struct dentry *parent;
 	struct kstat stat;
 	struct path lowerpath;
+	const struct cred *old_cred;
 
 	parent = dget_parent(dentry);
 	err = ovl_copy_up(parent);
@@ -25,6 +26,7 @@ static int ovl_copy_up_truncate(struct d
 		goto out_dput_parent;
 
 	ovl_path_lower(dentry, &lowerpath);
+	old_cred = ovl_override_creds(dentry->d_sb);
 	err = vfs_getattr(&lowerpath, &stat);
 	if (err)
 		goto out_dput_parent;
@@ -33,6 +35,7 @@ static int ovl_copy_up_truncate(struct d
 	err = ovl_copy_up_one(parent, dentry, &lowerpath, &stat);
 
 out_dput_parent:
+	revert_creds(old_cred);
 	dput(parent);
 	return err;
 }
