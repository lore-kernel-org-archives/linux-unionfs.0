From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: two questiones about overlayfs
Date: Tue, 15 Aug 2017 12:22:45 +0200
Message-ID: <20170815102245.GA29201@veci.piliscsaba.szeredi.hu>
References: <b68bea1b-4b51-8573-cf8a-06da4c41ed00@huawei.com>
 <CAOQ4uxiL=Gqy6A=_gKTFG0sQRYkZ37aptdn2fEvcF0phJBmW7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:35873 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753478AbdHOKWy (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 15 Aug 2017 06:22:54 -0400
Received: by mail-wm0-f41.google.com with SMTP id t201so5829262wmt.1
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Aug 2017 03:22:53 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiL=Gqy6A=_gKTFG0sQRYkZ37aptdn2fEvcF0phJBmW7Q@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "zhangyi (F)" <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>, miaoxie@huawei.com, Vivek Goyal <vgoyal@redhat.com>

On Tue, Aug 08, 2017 at 07:01:30AM +0200, Amir Goldstein wrote:
> On Mon, Aug 7, 2017 at 9:57 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> > Hi,all:
> > I found two problemes about overlayfs, please let me know what you think:
> >
> > 1. Cannot update upper dir's access time.
> > Reproduce:
> > # mkdir lower upper worker merger
> > # mkdir upper/dir
> > # mount -t overlay -o lowerdir=lower,upperdir=upper,workdir=worker overlayfs merger
> > # ls mrger/dir
> > # stat mrger/dir
> >   Access: 2017-08-07 11:03:56.364771584 -0400
> >   Modify: 2017-08-07 11:01:52.319771584 -0400
> >   Change: 2017-08-07 11:01:52.319771584 -0400
> > # touch mrger/dir/aa
> > # stat mrger/dir
> >   Access: 2017-08-07 11:03:56.364771584 -0400
> >   Modify: 2017-08-07 11:05:33.969771584 -0400
> >   Change: 2017-08-07 11:05:33.969771584 -0400
> > # ls mrger/dir
> > # stat mrger/dir
> >   Access: 2017-08-07 11:03:56.364771584 -0400
> >   Modify: 2017-08-07 11:05:33.969771584 -0400
> >   Change: 2017-08-07 11:05:33.969771584 -0400
> >
> > I find the reason of this problem is in update_ovl_inode_times():
> > (598e3c8f7 "vfs: update ovl inode before relatime check")
> >
> > static void update_ovl_inode_times(struct dentry *dentry, struct inode *inode,
> >                                bool rcu)
> > {
> >         if (!rcu) {
> >                 struct inode *realinode = d_real_inode(dentry);
> >
> >         *d_real_inode() cannot get dir's real inode, so i_mtime always equal to i_ctime*
> >         *an not updated*
> >
> 
> Technically, I think this could be changed to check
> if unlikely(dentry->d_flags & DCACHE_OP_REAL) and call
> vfs_getattr(&path, &stat, STATX_MTIME | STATX_CTIME, AT_STATX_SYNC_AS_STAT)
> to get the really real inode times also for directory.
> 
> But I think that would be considered a hack and the proper way to solve this
> would be to introduce a new dentry op ->d_real_inode().
> Unlike d_real_inode() which returns the inode used for open,
> ->d_real_inode() would return the inode used for stat.
> 
> If the helper d_real_inode() would call the new op,
> the only other user of d_real_inode() (check_conflicting_open) would have to
> open code inode_is_open_for_write(d_real(dentry)->d_inode)

Better just use the already existing ->d_real() with a special flags value to
indicate we want the real dentry for stat, not for open.

Something like this:

diff --git a/fs/inode.c b/fs/inode.c
index 50370599e371..8e526c7a1173 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1570,7 +1570,7 @@ static void update_ovl_inode_times(struct dentry *dentry, struct inode *inode,
 			       bool rcu)
 {
 	if (!rcu) {
-		struct inode *realinode = d_real_inode(dentry);
+		struct inode *realinode = d_inode(d_real(dentry, NULL, -1));
 
 		if (unlikely(inode != realinode) &&
 		    (!timespec_equal(&inode->i_mtime, &realinode->i_mtime) ||
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index d86e89f97201..792dc043f7b4 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -76,6 +76,10 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
 	int err;
 
 	if (!d_is_reg(dentry)) {
+		/* Special case -1 to mean query for stat not for open */
+		BUILD_BUG_ON((unsigned int) -1 ==  VALID_OPEN_FLAGS);
+		if (open_flags == (unsigned int) -1)
+			return ovl_dentry_real(dentry);
 		if (!inode || inode == d_inode(dentry))
 			return dentry;
 		goto bug;
