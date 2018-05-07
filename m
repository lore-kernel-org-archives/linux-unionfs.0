Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:59058 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752607AbeEGRlN (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 7 May 2018 13:41:13 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v15 25/30] ovl: Set redirect on upper inode when it is linked
Date: Mon,  7 May 2018 13:40:57 -0400
Message-Id: <20180507174102.24086-26-vgoyal@redhat.com>
In-Reply-To: <20180507174102.24086-1-vgoyal@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

When we create a hardlink to a metacopy upper file, first the redirect
on that inode. Path based lookup will not work with newly created link
and redirect will solve that issue.

Also use absolute redirect as two hardlinks could be in different directores
and relative redirect will not work.

I have not put any additional locking around setting redirects while
introducing redirects for non-dir files. For now it feels like existing
locking is sufficient. If that's not the case, we will have add more
locking. Following is my rationale about why do I think current locking
seems ok.

Basic problem for non-dir files is that more than on dentry could be
pointing to same inode and in theory only relying on dentry based locks
(d->d_lock) did not seem sufficient.

We set redirect upon rename and upon link creation. In both the paths
for non-dir file, VFS locks both source and target inodes (->i_rwsem).
That means vfs rename and link operations on same source and target
can't he happening in parallel (Even if there are multiple dentries
pointing to same inode). So that probably means that at a time on an inode,
only one call of ovl_set_redirect() could be working and we don't need
additional locking in ovl_set_redirect().

ovl_inode->redirect is initialized only when inode is created new. That
means it should not race with any other path and setting ovl_inode->redirect
should be fine.

Reading of ovl_inode->redirect happens in ovl_get_redirect() path. And this
called only in ovl_set_redirect(). And ovl_set_redirect() already seemed
to be protected using ->i_rwsem. That means ovl_set_redirect() and
ovl_get_redirect() on source/target inode should not make progress in
parallel and is mutually exclusive. Hence no additional locking required.

Now, only case where ovl_set_redirect() and ovl_get_redirect() could race
seems to be case of absolute redirects where ovl_get_redirect() has to
travel up the tree. In that case we already take d->d_lock and that should
be sufficient as directories will not have multiple dentries pointing to
same inode.

So given VFS locking and current usage of redirect, current locking around
redirect seems to be ok for non-dir as well. Once we have the logic to
remove redirect when metacopy file gets copied up, then we probably will
need additional locking.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 602b0ac1f4d4..c28354141baf 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -24,6 +24,8 @@ module_param_named(redirect_max, ovl_redirect_max, ushort, 0644);
 MODULE_PARM_DESC(ovl_redirect_max,
 		 "Maximum length of absolute redirect xattr value");
 
+static int ovl_set_redirect(struct dentry *dentry, bool samedir);
+
 int ovl_cleanup(struct inode *wdir, struct dentry *wdentry)
 {
 	int err;
@@ -468,6 +470,9 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
 	const struct cred *old_cred;
 	struct cred *override_cred;
 	struct dentry *parent = dentry->d_parent;
+	struct dentry *hardlink_upper;
+
+	hardlink_upper = hardlink ? ovl_dentry_upper(hardlink) : NULL;
 
 	err = ovl_copy_up(parent);
 	if (err)
@@ -502,12 +507,18 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
 		put_cred(override_creds(override_cred));
 		put_cred(override_cred);
 
+		if (hardlink && ovl_is_metacopy_dentry(hardlink)) {
+			err = ovl_set_redirect(hardlink, false);
+			if (err)
+				goto out_revert_creds;
+		}
+
 		if (!ovl_dentry_is_whiteout(dentry))
 			err = ovl_create_upper(dentry, inode, attr,
-						hardlink);
+						hardlink_upper);
 		else
 			err = ovl_create_over_whiteout(dentry, inode, attr,
-							hardlink);
+							hardlink_upper);
 	}
 out_revert_creds:
 	revert_creds(old_cred);
@@ -602,8 +613,7 @@ static int ovl_link(struct dentry *old, struct inode *newdir,
 	inode = d_inode(old);
 	ihold(inode);
 
-	err = ovl_create_or_link(new, inode, NULL, ovl_dentry_upper(old),
-				 ovl_type_origin(old));
+	err = ovl_create_or_link(new, inode, NULL, old, ovl_type_origin(old));
 	if (err)
 		iput(inode);
 
-- 
2.13.6

