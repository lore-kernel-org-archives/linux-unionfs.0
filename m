From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 2/7] ovl: During copy up, first copy up metadata and then
 data
Date: Tue, 3 Oct 2017 10:25:00 -0400
Message-ID: <20171003142459.GB14308@redhat.com>
References: <1506951605-31440-1-git-send-email-vgoyal@redhat.com>
 <1506951605-31440-3-git-send-email-vgoyal@redhat.com>
 <CAOQ4uxgD72v94k7cgTKnu8n1kev7=RvZMyydw9C-K4FTEUr3OQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49916 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751241AbdJCOZB (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 3 Oct 2017 10:25:01 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgD72v94k7cgTKnu8n1kev7=RvZMyydw9C-K4FTEUr3OQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Mon, Oct 02, 2017 at 10:13:24PM +0300, Amir Goldstein wrote:
> On Mon, Oct 2, 2017 at 4:40 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > This just helps with later patches where after copying up metadata, we
> > skip data copying step, if needed.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  fs/overlayfs/copy_up.c | 24 ++++++++++++------------
> >  1 file changed, 12 insertions(+), 12 deletions(-)
> >
> > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > index f1b15e5c37d3..cdc4d79a1249 100644
> > --- a/fs/overlayfs/copy_up.c
> > +++ b/fs/overlayfs/copy_up.c
> > @@ -445,18 +445,6 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
> >  {
> >         int err;
> >
> > -       if (S_ISREG(c->stat.mode)) {
> > -               struct path upperpath;
> > -
> > -               ovl_path_upper(c->dentry, &upperpath);
> > -               BUG_ON(upperpath.dentry != NULL);
> > -               upperpath.dentry = temp;
> > -
> > -               err = ovl_copy_up_data(&c->lowerpath, &upperpath, c->stat.size);
> > -               if (err)
> > -                       return err;
> > -       }
> > -
> >         err = ovl_copy_xattr(c->lowerpath.dentry, temp);
> >         if (err)
> >                 return err;
> > @@ -480,6 +468,18 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
> >                         return err;
> >         }
> >
> > +       if (S_ISREG(c->stat.mode)) {
> > +               struct path upperpath;
> > +
> > +               ovl_path_upper(c->dentry, &upperpath);
> > +               BUG_ON(upperpath.dentry != NULL);
> > +               upperpath.dentry = temp;
> > +
> > +               err = ovl_copy_up_data(&c->lowerpath, &upperpath, c->stat.size);
> > +               if (err)
> > +                       return err;
> > +       }
> > +
> 
> You moved copy_up_data to after ovl_set_attr() -> ovl_set_timestamps()
> Does this break the copied up mtime? I'm not sure.
> I didn't see that do_splice_direct() or vfs_clone_file_range() change
> mtime directly, but inside file system, they might.

Hi Amir,

That's a good point. I will move ovl_set_attr() call after data copy.

Thanks
Vivek
