From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 23/28] ovl: Set redirect on upper inode when it is linked
Date: Tue, 29 May 2018 16:46:07 +0200
Message-ID: <20180529144612.16675-24-mszeredi@redhat.com>
References: <20180529144612.16675-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144612.16675-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>

When we create a hardlink to a metacopy upper file, first the redirect on
that inode.  Path based lookup will not work with newly created link and
redirect will solve that issue.

Also use absolute redirect as two hardlinks could be in different
directores and relative redirect will not work.

I have not put any additional locking around setting redirects while
introducing redirects for non-dir files.  For now it feels like existing
locking is sufficient.  If that's not the case, we will have add more
locking.  Following is my rationale about why do I think current locking
seems ok.

Basic problem for non-dir files is that more than on dentry could be
pointing to same inode and in theory only relying on dentry based locks
(d->d_lock) did not seem sufficient.

We set redirect upon rename and upon link creation.  In both the paths for
non-dir file, VFS locks both source and target inodes (->i_rwsem).  That
means vfs rename and link operations on same source and target can't he
happening in parallel (Even if there are multiple dentries pointing to same
inode).  So that probably means that at a time on an inode, only one call
of ovl_set_redirect() could be working and we don't need additional locking
in ovl_set_redirect().

ovl_inode->redirect is initialized only when inode is created new.  That
means it should not race with any other path and setting
ovl_inode->redirect should be fine.

Reading of ovl_inode->redirect happens in ovl_get_redirect() path.  And
this called only in ovl_set_redirect().  And ovl_set_redirect() already
seemed to be protected using ->i_rwsem.  That means ovl_set_redirect() and
ovl_get_redirect() on source/target inode should not make progress in
parallel and is mutually exclusive.  Hence no additional locking required.

Now, only case where ovl_set_redirect() and ovl_get_redirect() could race
seems to be case of absolute redirects where ovl_get_redirect() has to
travel up the tree.  In that case we already take d->d_lock and that should
be sufficient as directories will not have multiple dentries pointing to
same inode.

So given VFS locking and current usage of redirect, current locking around
redirect seems to be ok for non-dir as well.  Once we have the logic to
remove redirect when metacopy file gets copied up, then we probably will
need additional locking.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/dir.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 1658961a9762..7063e0f588cc 100644
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
@@ -656,6 +658,12 @@ static int ovl_link(struct dentry *old, struct inode *newdir,
 	if (err)
 		goto out_drop_write;
 
+	if (ovl_is_metacopy_dentry(old)) {
+		err = ovl_set_redirect(old, false);
+		if (err)
+			goto out_drop_write;
+	}
+
 	err = ovl_nlink_start(old, &locked);
 	if (err)
 		goto out_drop_write;
-- 
2.14.3
