Return-Path: <vgoyal@redhat.com>
Date: Mon, 7 May 2018 16:59:37 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v15 17/30] ovl: Open file with data except for the case
 of fsync
Message-ID: <20180507205937.GB2945@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
 <20180507174102.24086-18-vgoyal@redhat.com>
 <CAOQ4uxiXqKF1Vbg6HitUg6ax_Xy67mKDVS1t+P7pMT_57X=L5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiXqKF1Vbg6HitUg6ax_Xy67mKDVS1t+P7pMT_57X=L5g@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, May 07, 2018 at 10:47:28PM +0300, Amir Goldstein wrote:
> On Mon, May 7, 2018 at 8:40 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > ovl_open() should open file which contains data and not open metacopy
> > inode. With the introduction of metacopy inodes, with current implementaion
> > we will end up opening metacopy inode as well.
> >
> > But there can be certain circumstances like ovl_fsync() where we
> > want to allow opening a metacopy inode instead.
> >
> > Hence, change ovl_open_realfile() and ovl_open_real() and add extra
> > parameter which specifies whether to allow opening metacopy inode or not.
> > If this parameter is false, we look for data inode and open that.
> >
> > This should allow covering both the cases.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> 
> except one nit
> 
> > ---
> >  fs/overlayfs/file.c | 49 +++++++++++++++++++++++++++++++++----------------
> >  1 file changed, 33 insertions(+), 16 deletions(-)
> >
> > diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> > index a60734ec89ec..885151e8d0cb 100644
> > --- a/fs/overlayfs/file.c
> > +++ b/fs/overlayfs/file.c
> > @@ -14,22 +14,32 @@
> >  #include <linux/uio.h>
> >  #include "overlayfs.h"
> >
> > -static struct file *ovl_open_realfile(const struct file *file)
> > +static struct file *ovl_open_realfile(const struct file *file,
> > +                                     bool allow_metacopy)
> >  {
> >         struct inode *inode = file_inode(file);
> >         struct inode *upperinode = ovl_inode_upper(inode);
> > -       struct inode *realinode = upperinode ?: ovl_inode_lower(inode);
> > +       struct inode *realinode;
> >         struct file *realfile;
> > +       bool upperopen = false;
> >         const struct cred *old_cred;
> >
> > +       if (upperinode && (allow_metacopy || ovl_has_upperdata(inode))) {
> > +               realinode = upperinode;
> > +               upperopen = true;
> > +       } else {
> > +               realinode = allow_metacopy ? ovl_inode_lower(inode) :
> > +                                ovl_inode_lowerdata(inode);
> > +       }
> >         old_cred = ovl_override_creds(inode->i_sb);
> >         realfile = path_open(&file->f_path, file->f_flags | O_NOATIME,
> >                              realinode, current_cred(), false);
> >         revert_creds(old_cred);
> >
> >         pr_debug("open(%p[%pD2/%c], 0%o) -> (%p, 0%o)\n",
> > -                file, file, upperinode ? 'u' : 'l', file->f_flags,
> > -                realfile, IS_ERR(realfile) ? 0 : realfile->f_flags);
> > +                file, file, upperopen ? 'u' : 'l',
> > +                file->f_flags, realfile,
> > +                IS_ERR(realfile) ? 0 : realfile->f_flags);
> >
> >         return realfile;
> >  }
> > @@ -72,17 +82,24 @@ static int ovl_change_flags(struct file *file, unsigned int flags)
> >         return 0;
> >  }
> >
> > -static int ovl_real_fdget(const struct file *file, struct fd *real)
> > +static int ovl_real_fdget(const struct file *file, struct fd *real,
> > +                         bool allow_metacopy)
> >  {
> >         struct inode *inode = file_inode(file);
> > +       struct inode *realinode;
> >
> >         real->flags = 0;
> >         real->file = file->private_data;
> >
> > +       if (allow_metacopy)
> > +               realinode = ovl_inode_real(inode);
> > +       else
> > +               realinode = ovl_inode_realdata(inode);
> > +
> >         /* Has it been copied up since we'd opened it? */
> > -       if (unlikely(file_inode(real->file) != ovl_inode_real(inode))) {
> > +       if (unlikely(file_inode(real->file) != realinode)) {
> >                 real->flags = FDPUT_FPUT;
> > -               real->file = ovl_open_realfile(file);
> > +               real->file = ovl_open_realfile(file, allow_metacopy);
> >
> >                 return PTR_ERR_OR_ZERO(real->file);
> >         }
> > @@ -107,7 +124,7 @@ static int ovl_open(struct inode *inode, struct file *file)
> >         /* No longer need these flags, so don't pass them on to underlying fs */
> >         file->f_flags &= ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC);
> >
> > -       realfile = ovl_open_realfile(file);
> > +       realfile = ovl_open_realfile(file, false);
> >         if (IS_ERR(realfile))
> >                 return PTR_ERR(realfile);
> >
> > @@ -184,7 +201,7 @@ static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *iter)
> >         if (!iov_iter_count(iter))
> >                 return 0;
> >
> > -       ret = ovl_real_fdget(file, &real);
> > +       ret = ovl_real_fdget(file, &real, false);
> 
> 
> Instead of changing all those call sites, use a wrapper
> 
> ovl_real_fdget(file, real) => ovl_real_fdget_metacopy(file, real, false)
> 
> and use ovl_real_fdget_metacopy() directly only when you want
> the metacopy file.

You mean define another helper ovl_real_fdget_metacopy(file, real) and
use that when metacopy file is desired/allowed?

That's what I had done in previous series. That is define a separate
wrapper for metacopy and you had not liked it and that's why I did
it this way.

Anyway, I will change it again.

Vivek
