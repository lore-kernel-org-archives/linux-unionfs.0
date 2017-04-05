From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v3 4/6] ovl: copy up regular file using O_TMPFILE
Date: Wed, 5 Apr 2017 15:36:01 -0400
Message-ID: <20170405193601.GA4475@redhat.com>
References: <1484588765-9397-1-git-send-email-amir73il@gmail.com>
 <1484588765-9397-5-git-send-email-amir73il@gmail.com>
 <CAOQ4uxiLgcpvz4hcFJdcYETokbQ=88nS4fA3_F4k8faCR=ia_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47898 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753393AbdDETgC (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 5 Apr 2017 15:36:02 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiLgcpvz4hcFJdcYETokbQ=88nS4fA3_F4k8faCR=ia_g@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Wed, Apr 05, 2017 at 09:32:36PM +0300, Amir Goldstein wrote:
> On Mon, Jan 16, 2017 at 7:46 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> > In preparation for concurrent copy up, implement copy up
> > of regular file as O_TMPFILE that is linked to upperdir
> > instead of a file in workdir that is moved to upperdir.
> >
> 
> Hi Vivek,
> 
> This commit is already in v4.11-rc1 and I haven't heard any complains.
> But I wanted to ask all the same.
> 
> With this commit the semantics of security checks are modified a bit.
> 
> Before this change it was:
> - Create temp file in workdir and negative dentry in upperdir with
>   security_inode_copy_up() creds
> - Move temp file to upperdir with mounter creds
> 
> After this change it is:
> - Create an O_TMPFILE and negative dentry in upperdir with
>   security_inode_copy_up() creds
> - Link O_TMPFILE to upperdir with mounter creds
> 
> Is this equivalent as far as SELinux goes?
> Does it mean that users may have to fix their sepolicy in some way?

Hi Amir,

I think this change is fine. security_inode_copy_up() returns new creds
using which new file should be created during copy up. And using tmpfile
does not seem to change it. We still switch to creds retruned by
security_inode_copy_up() and then tmpfile is created.

> 
> Were you able to verify that there are no overlay+selinux regression
> with v4.11-rc1? I just don't have selinux in my test setup...

I ran selinux-testsuite overlay test cases and they all passed. So I can't
think of any regression yet.

https://github.com/SELinuxProject/selinux-testsuite

Thanks
Vivek

> 
> Thanks,
> Amir.
> 
> > Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/overlayfs/copy_up.c | 27 ++++++++++++++++++++-------
> >  1 file changed, 20 insertions(+), 7 deletions(-)
> >
> > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > index 01e3327..6e39e90 100644
> > --- a/fs/overlayfs/copy_up.c
> > +++ b/fs/overlayfs/copy_up.c
> > @@ -20,6 +20,7 @@
> >  #include <linux/fdtable.h>
> >  #include <linux/ratelimit.h>
> >  #include "overlayfs.h"
> > +#include "ovl_entry.h"
> >
> >  #define OVL_COPY_UP_CHUNK_SIZE (1 << 20)
> >
> > @@ -233,7 +234,7 @@ int ovl_set_attr(struct dentry *upperdentry, struct kstat *stat)
> >  static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
> >                               struct dentry *dentry, struct path *lowerpath,
> >                               struct kstat *stat, const char *link,
> > -                             struct kstat *pstat)
> > +                             struct kstat *pstat, bool tmpfile)
> >  {
> >         struct inode *wdir = workdir->d_inode;
> >         struct inode *udir = upperdir->d_inode;
> > @@ -263,12 +264,17 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
> >         if (new_creds)
> >                 old_creds = override_creds(new_creds);
> >
> > -       temp = ovl_lookup_temp(workdir, dentry);
> > +       if (tmpfile)
> > +               temp = ovl_do_tmpfile(upperdir, stat->mode);
> > +       else
> > +               temp = ovl_lookup_temp(workdir, dentry);
> >         err = PTR_ERR(temp);
> >         if (IS_ERR(temp))
> >                 goto out1;
> >
> > -       err = ovl_create_real(wdir, temp, &cattr, NULL, true);
> > +       err = 0;
> > +       if (!tmpfile)
> > +               err = ovl_create_real(wdir, temp, &cattr, NULL, true);
> >
> >         if (new_creds) {
> >                 revert_creds(old_creds);
> > @@ -300,11 +306,14 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
> >         if (err)
> >                 goto out_cleanup;
> >
> > -       err = ovl_do_rename(wdir, temp, udir, upper, 0);
> > +       if (tmpfile)
> > +               err = ovl_do_link(temp, udir, upper, true);
> > +       else
> > +               err = ovl_do_rename(wdir, temp, udir, upper, 0);
> >         if (err)
> >                 goto out_cleanup;
> >
> > -       newdentry = dget(temp);
> > +       newdentry = dget(tmpfile ? upper : temp);
> >         ovl_dentry_update(dentry, newdentry);
> >         ovl_inode_update(d_inode(dentry), d_inode(newdentry));
> >
> > @@ -318,7 +327,8 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
> >         return err;
> >
> >  out_cleanup:
> > -       ovl_cleanup(wdir, temp);
> > +       if (!tmpfile)
> > +               ovl_cleanup(wdir, temp);
> >         goto out2;
> >  }
> >
> > @@ -342,6 +352,9 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
> >         struct dentry *lowerdentry = lowerpath->dentry;
> >         struct dentry *upperdir;
> >         const char *link = NULL;
> > +       struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
> > +       /* Should we copyup with O_TMPFILE or with workdir? */
> > +       bool tmpfile = S_ISREG(stat->mode) && ofs->tmpfile;
> >
> >         if (WARN_ON(!workdir))
> >                 return -EROFS;
> > @@ -373,7 +386,7 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
> >         }
> >
> >         err = ovl_copy_up_locked(workdir, upperdir, dentry, lowerpath,
> > -                                stat, link, &pstat);
> > +                                stat, link, &pstat, tmpfile);
> >  out_unlock:
> >         unlock_rename(workdir, upperdir);
> >         do_delayed_call(&done);
> > --
> > 2.7.4
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
