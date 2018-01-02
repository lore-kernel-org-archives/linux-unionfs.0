From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC][PATCH 1/2] vfs: update overlay inode times on write
Date: Wed, 3 Jan 2018 08:26:45 +1100
Message-ID: <20180102212645.GB30682@dastard>
References: <1514896009-11468-1-git-send-email-amir73il@gmail.com>
 <1514896009-11468-2-git-send-email-amir73il@gmail.com>
 <20180102165101.GC15274@redhat.com>
 <CAOQ4uxiG5rsEodycxbzuXFAmHLM=fhhPTYkoyBPXyME3YCVZ+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:31598 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750984AbeABV0t (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 2 Jan 2018 16:26:49 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiG5rsEodycxbzuXFAmHLM=fhhPTYkoyBPXyME3YCVZ+g@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Jan 02, 2018 at 07:27:41PM +0200, Amir Goldstein wrote:
> On Tue, Jan 2, 2018 at 6:51 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Tue, Jan 02, 2018 at 02:26:48PM +0200, Amir Goldstein wrote:
> >> Currently with overlayfs, the real upper inode's i_mtime is updated on
> >> write, but not overlay vfs inode. The vfs inode's i_mtime is used by nfsd
> >> to check if nfs client cache is stale, so updating the overlay vfs inode
> >> i_mtime on write is required for overlayfs NFS export support.
> >>
> >> The non uptodate mtime issue was found and verified with the
> >> nfstest_posix test when run over NFS exported overlayfs:
> >>
> >>  $ nfstest_posix --runtest=write
> >>  ...
> >>  FAIL: write - file st_mtime should be updated
> >>
> >> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> >> ---
> >>  fs/inode.c | 9 ++++++---
> >>  1 file changed, 6 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/fs/inode.c b/fs/inode.c
> >> index 03102d6ef044..a252256f4e51 100644
> >> --- a/fs/inode.c
> >> +++ b/fs/inode.c
> >> @@ -1567,8 +1567,7 @@ EXPORT_SYMBOL(bmap);
> >>  /*
> >>   * Update times in overlayed inode from underlying real inode
> >>   */
> >> -static void update_ovl_inode_times(struct dentry *dentry, struct inode *inode,
> >> -                            bool rcu)
> >> +static void update_ovl_d_inode_times(struct dentry *dentry, bool rcu)
> >>  {
> >>       struct dentry *upperdentry;
> >>
> >> @@ -1585,6 +1584,7 @@ static void update_ovl_inode_times(struct dentry *dentry, struct inode *inode,
> >>        * stale mtime/ctime.
> >>        */
> >>       if (upperdentry) {
> >> +             struct inode *inode = d_inode(dentry);
> >>               struct inode *realinode = d_inode(upperdentry);
> >>
> >>               if ((!timespec_equal(&inode->i_mtime, &realinode->i_mtime) ||
> >> @@ -1607,7 +1607,8 @@ static int relatime_need_update(const struct path *path, struct inode *inode,
> >>       if (!(path->mnt->mnt_flags & MNT_RELATIME))
> >>               return 1;
> >>
> >> -     update_ovl_inode_times(path->dentry, inode, rcu);
> >> +     update_ovl_d_inode_times(path->dentry, rcu);
> >> +
> >
> > Hi Amir,
> >
> > If we update overlay inode mtime, ctime in write path, then do we still
> > need this call in relatime_need_update() path? I mean what other path
> > is there where real inode mtime/ctime will be out of sync with overlay
> > inode mtime/ctime.
> >
> 
> Specifically, in the mentioned nfstest_posix test, i_mtime was not
> updated on write of regular file and i_mtime of parent was not updated on link.
> I guess there are more cases where i_mtime is updated not in the
> write() path. I can think of punch hole for regular files and even file system
> specific ioctls, which overlayfs is not aware of.
> To handle those cases, I added the 2nd patch, which is "mtime reader
> oriented", just like the relatime_need_update() case.
> 
> The problem is that AFAIK there is no simple place where all
> i_mtime updates can be intercepted. Perhaps the recent work by Jeff
> to sort out i_version readers/writers will provide a better place
> to intercept all mtime updates?? At least for underlying filesystems that
> support i_version, we could update overlay inode times only if i_version
> was updated, but I don't even know what would be the best implementation
> choice for relatime_need_update() in that case.

You might be able to intercept m/ctime changes at notify_change(),
but you are not going to be able to catch all timestamp changes
because many of them are deep inside filesystem specific
implementations of various functions. e.g. see all the internal XFS
calls to xfs_trans_ichgtime() to change inode timestamps during
various modifications because they are conditional on the
modifications those operations make to the filesystem and hence they
can't be specified/directed by the VFS....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
