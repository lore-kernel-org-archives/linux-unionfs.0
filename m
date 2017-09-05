From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 2/3] ovl: fix relatime for directories
Date: Tue, 5 Sep 2017 14:53:49 +0200
Message-ID: <20170905125349.GC29201@veci.piliscsaba.szeredi.hu>
References: <1504597596-17994-1-git-send-email-mszeredi@redhat.com>
 <1504597596-17994-3-git-send-email-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:38592 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751119AbdIEMxy (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 5 Sep 2017 08:53:54 -0400
Received: by mail-wr0-f193.google.com with SMTP id p14so1414170wrg.5
        for <linux-unionfs@vger.kernel.org>; Tue, 05 Sep 2017 05:53:54 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1504597596-17994-3-git-send-email-mszeredi@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>

On Tue, Sep 5, 2017 at 10:55 AM, Amir Goldstein <amir73il@gmail.com> wrote:
[...]
> Alternatively, update_ovl_inode_times() could use D_REAL_UPPER
> and then we explicitly say that we don't care about lower mtime/ctime
> modifications.

Right, you convinced me that this is the right way to go.  Updated patch below
(and pushed to overlayfs-next).

Thanks,
Miklos
---

From: Miklos Szeredi <mszeredi@redhat.com>
Subject: ovl: fix relatime for directories

Need to treat non-regular overlayfs files the same as regular files when
checking for an atime update.

Add a d_real() flag to make it return the upper dentry for all file types.

Reported-by: "zhangyi (F)" <yi.zhang@huawei.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/inode.c             |   21 +++++++++++++++++----
 fs/overlayfs/super.c   |    3 +++
 include/linux/dcache.h |    3 +++
 3 files changed, 23 insertions(+), 4 deletions(-)

--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1569,11 +1569,24 @@ EXPORT_SYMBOL(bmap);
 static void update_ovl_inode_times(struct dentry *dentry, struct inode *inode,
 			       bool rcu)
 {
-	if (!rcu) {
-		struct inode *realinode = d_real_inode(dentry);
+	struct dentry *upperdentry;
 
-		if (unlikely(inode != realinode) &&
-		    (!timespec_equal(&inode->i_mtime, &realinode->i_mtime) ||
+	/*
+	 * Nothing to do if in rcu or if non-overlayfs
+	 */
+	if (rcu || likely(!(dentry->d_flags & DCACHE_OP_REAL)))
+		return;
+
+	upperdentry = d_real(dentry, NULL, 0, D_REAL_UPPER);
+
+	/*
+	 * If file is on lower then we can't update atime, so no worries about
+	 * stale mtime/ctime.
+	 */
+	if (upperdentry) {
+		struct inode *realinode = d_inode(upperdentry);
+
+		if ((!timespec_equal(&inode->i_mtime, &realinode->i_mtime) ||
 		     !timespec_equal(&inode->i_ctime, &realinode->i_ctime))) {
 			inode->i_mtime = realinode->i_mtime;
 			inode->i_ctime = realinode->i_ctime;
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -75,6 +75,9 @@ static struct dentry *ovl_d_real(struct
 	struct dentry *real;
 	int err;
 
+	if (flags & D_REAL_UPPER)
+		return ovl_dentry_upper(dentry);
+
 	if (!d_is_reg(dentry)) {
 		if (!inode || inode == d_inode(dentry))
 			return dentry;
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -562,6 +562,9 @@ static inline struct dentry *d_backing_d
 	return upper;
 }
 
+/* d_real() flags */
+#define D_REAL_UPPER	0x2	/* return upper dentry or NULL if non-upper */
+
 /**
  * d_real - Return the real dentry
  * @dentry: the dentry to query
