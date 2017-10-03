From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 7/7] ovl: Fix ovl_getattr() to get size from lower
Date: Tue, 3 Oct 2017 11:24:08 -0400
Message-ID: <20171003152408.GE14308@redhat.com>
References: <1506951605-31440-1-git-send-email-vgoyal@redhat.com>
 <1506951605-31440-8-git-send-email-vgoyal@redhat.com>
 <CAOQ4uxhvN7xTK9Y7LXfuWoDY6NYRB9t+r=tb=_4oQO-2Ce_KRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58084 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752349AbdJCPYI (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 3 Oct 2017 11:24:08 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhvN7xTK9Y7LXfuWoDY6NYRB9t+r=tb=_4oQO-2Ce_KRA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Mon, Oct 02, 2017 at 10:40:07PM +0300, Amir Goldstein wrote:
> On Mon, Oct 2, 2017 at 4:40 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > If an inode has been copied up metadata only, then we need to query the
> > size from lower and fill up the stat->size.
> 
> So you won't need this patch if you copy st_size on metadata_copy,
> which seems like the logical thing to do.
> Thinking very far into the future when METACOPY and ORIGIN will
> be able to share page mappings, they will have to start with the same size.

Ok, Will set upper size same as lower during metacopy operation.

Vivek

> 
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  fs/overlayfs/inode.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> > index e5825b8948e0..1b676deacc2d 100644
> > --- a/fs/overlayfs/inode.c
> > +++ b/fs/overlayfs/inode.c
> > @@ -140,6 +140,16 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
> >         if (!is_dir && ovl_test_flag(OVL_INDEX, d_inode(dentry)))
> >                 stat->nlink = dentry->d_inode->i_nlink;
> >
> > +       if (ovl_test_flag(OVL_METACOPY, d_inode(dentry))) {
> > +               struct kstat lowerstat;
> > +               u32 lowermask = STATX_SIZE;
> > +
> > +               ovl_path_lower(dentry, &realpath);
> > +               err = vfs_getattr(&realpath, &lowerstat, lowermask, flags);
> > +               if (err)
> > +                       goto out;
> > +               stat->size = lowerstat.size;
> > +       }
> >  out:
> >         revert_creds(old_cred);
> >
> > --
> > 2.13.5
> >
