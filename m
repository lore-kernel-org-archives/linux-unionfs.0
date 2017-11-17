From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v7 06/14] ovl: Move couple of copy up functions in
 copy_up.c
Date: Fri, 17 Nov 2017 10:40:02 -0500
Message-ID: <20171117154002.GB15566@redhat.com>
References: <20171116220335.13448-1-vgoyal@redhat.com>
 <20171116220335.13448-7-vgoyal@redhat.com>
 <CAOQ4uxiCXmBiEci5b+7j+WT9Q=gZbeVqknNKHDoBd82W3y1NNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51038 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965045AbdKQPkD (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 17 Nov 2017 10:40:03 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiCXmBiEci5b+7j+WT9Q=gZbeVqknNKHDoBd82W3y1NNQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Fri, Nov 17, 2017 at 11:06:12AM +0200, Amir Goldstein wrote:
> On Fri, Nov 17, 2017 at 12:03 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Right now two copy up related functions are part of inode.c. Amir suggested
> > it might be better to move these to copy_up.c. Hence this patch does that.
> 
> IMO it is better to phrase simply "Move the copy up helpers to copy_up.c."
> 
> > There will one more related function which will come in later patch.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  fs/overlayfs/copy_up.c | 30 ++++++++++++++++++++++++++++++
> >  fs/overlayfs/inode.c   | 30 ------------------------------
> >  2 files changed, 30 insertions(+), 30 deletions(-)
> >
> > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > index 303794bb9127..f84ba12c9b05 100644
> > --- a/fs/overlayfs/copy_up.c
> > +++ b/fs/overlayfs/copy_up.c
> > @@ -232,6 +232,36 @@ int ovl_set_attr(struct dentry *upperdentry, struct kstat *stat)
> >         return err;
> >  }
> >
> > +static bool ovl_open_need_copy_up(struct dentry *dentry, int flags)
> > +{
> > +       if (ovl_dentry_upper(dentry) &&
> > +           ovl_dentry_has_upper_alias(dentry))
> > +               return false;
> > +
> > +       if (special_file(d_inode(dentry)->i_mode))
> > +               return false;
> > +
> > +       if (!(OPEN_FMODE(flags) & FMODE_WRITE) && !(flags & O_TRUNC))
> > +               return false;
> > +
> > +       return true;
> > +}
> > +
> > +int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags)
> > +{
> > +       int err = 0;
> > +
> > +       if (ovl_open_need_copy_up(dentry, file_flags)) {
> > +               err = ovl_want_write(dentry);
> > +               if (!err) {
> > +                       err = ovl_copy_up_flags(dentry, file_flags);
> > +                       ovl_drop_write(dentry);
> > +               }
> > +       }
> > +
> > +       return err;
> > +}
> > +
> 
> I would put there at the bottom ,below ovl_copy_up_flags, where they belong
> logically (this file is sorted bottom up.

Ok, I will keep these functions below ovl_copy_up_flag().

But ovl_copy_up_meta_inode_data() is called by ovl_copy_up_one(). So will
keep that above ovl_copy_up_one().

> 
> And also need to move the declaration of ovl_open_maybe_copy_up() in
> overlayfs.h to the respective location.

Ok, will do.

Vivek
