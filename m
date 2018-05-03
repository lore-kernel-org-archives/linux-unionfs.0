Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:48010 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751108AbeECUby (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 3 May 2018 16:31:54 -0400
Date: Thu, 3 May 2018 16:31:53 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v14 16/31] ovl: Always open file/inode which contains
 data and not metacopy
Message-ID: <20180503203153.GD10792@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com>
 <20180426191013.13219-17-vgoyal@redhat.com>
 <CAOQ4uxjjD0o3H54OozyUfoUSJUw9iqQKvi1m+sTd9hfiA3YOgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjjD0o3H54OozyUfoUSJUw9iqQKvi1m+sTd9hfiA3YOgA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, Apr 28, 2018 at 01:49:38AM -0700, Amir Goldstein wrote:
> On Thu, Apr 26, 2018 at 12:09 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > ovl_open() should open file which contains data and not open metacopy
> > inode.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> 
> This looks fine, but I don't see a reason to separate it from 26/31
> first allow only data open, then allow also meta open..
> Anyway, I am not sure about the cleanest way to sort all the cases.

Ok, I have simplified it now. Merged fsync and patch 26 in one. Also
got rid of separate function to open meta file. I now have just added
a parameter to ovl_open_realfile() and ovl_real_file() which specifies
that its fine to open metacopy inode.

That feels much cleaner to me now.

Vivek
> 
> > ---
> >  fs/overlayfs/file.c | 16 ++++++++++++----
> >  1 file changed, 12 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> > index 23638d8ebab5..558a859b2658 100644
> > --- a/fs/overlayfs/file.c
> > +++ b/fs/overlayfs/file.c
> > @@ -18,18 +18,26 @@ static struct file *ovl_open_realfile(const struct file *file)
> >  {
> >         struct inode *inode = file_inode(file);
> >         struct inode *upperinode = ovl_inode_upper(inode);
> > -       struct inode *realinode = upperinode ?: ovl_inode_lower(inode);
> > +       struct inode *realinode;
> >         struct file *realfile;
> > +       bool upperreal = false;
> >         const struct cred *old_cred;
> >
> > +       if (upperinode && ovl_has_upperdata(inode))
> > +               upperreal = true;
> > +
> > +       /* Always open file which contains data. Do not open metacopy. */
> > +       realinode = upperreal ? upperinode : ovl_inode_lowerdata(inode);
> > +
> >         old_cred = ovl_override_creds(inode->i_sb);
> >         realfile = path_open(&file->f_path, file->f_flags | O_NOATIME,
> >                              realinode, current_cred(), false);
> >         revert_creds(old_cred);
> >
> >         pr_debug("open(%p[%pD2/%c], 0%o) -> (%p, 0%o)\n",
> > -                file, file, upperinode ? 'u' : 'l', file->f_flags,
> > -                realfile, IS_ERR(realfile) ? 0 : realfile->f_flags);
> > +                file, file, upperreal ? 'u' : 'l',
> > +                file->f_flags, realfile,
> > +                IS_ERR(realfile) ? 0 : realfile->f_flags);
> >
> >         return realfile;
> >  }
> > @@ -80,7 +88,7 @@ static int ovl_real_file(const struct file *file, struct fd *real)
> >         real->file = file->private_data;
> >
> >         /* Has it been copied up since we'd opened it? */
> > -       if (unlikely(file_inode(real->file) != ovl_inode_real(inode))) {
> > +       if (unlikely(file_inode(real->file) != ovl_inode_real_data(inode))) {
> >                 real->flags = FDPUT_FPUT;
> >                 real->file = ovl_open_realfile(file);
> >
> > --
> > 2.13.6
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
