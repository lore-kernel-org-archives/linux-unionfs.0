From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 05/13] ovl: During copy up, first copy up metadata and
 then data
Date: Thu, 26 Oct 2017 09:19:28 -0400
Message-ID: <20171026131928.GC28005@redhat.com>
References: <1508958575-14086-1-git-send-email-vgoyal@redhat.com>
 <1508958575-14086-6-git-send-email-vgoyal@redhat.com>
 <CAOQ4uxiXwMs2=pu7VCzWBXht4S7kDz34HL2uqLSvP_OiG8jXiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60860 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932217AbdJZNT2 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Oct 2017 09:19:28 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiXwMs2=pu7VCzWBXht4S7kDz34HL2uqLSvP_OiG8jXiQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Oct 26, 2017 at 08:42:08AM +0300, Amir Goldstein wrote:
> On Wed, Oct 25, 2017 at 10:09 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Just a little re-ordering of code. This helps with next patch where after
> > copying up metadata, we skip data copying step, if needed.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> 
> Please add
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> 
> if you post again with no changes to patch,
> so help me avoid re-review

Sure will do. This patch had changed slightly (I started returing err
instead of 0). That's probably I did not include it. 

Vivek

> 
> Thanks
> 
> > ---
> >  fs/overlayfs/copy_up.c | 33 ++++++++++++++++-----------------
> >  1 file changed, 16 insertions(+), 17 deletions(-)
> >
> > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > index 8a8f538..4f580ec 100644
> > --- a/fs/overlayfs/copy_up.c
> > +++ b/fs/overlayfs/copy_up.c
> > @@ -445,6 +445,21 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
> >  {
> >         int err;
> >
> > +       err = ovl_copy_xattr(c->lowerpath.dentry, temp);
> > +       if (err)
> > +               return err;
> > +
> > +       /*
> > +        * Store identifier of lower inode in upper inode xattr to
> > +        * allow lookup of the copy up origin inode.
> > +        *
> > +        */
> > +       if (c->origin) {
> > +               err = ovl_set_origin(c->dentry, c->lowerpath.dentry, temp);
> > +               if (err)
> > +                       return err;
> > +       }
> > +
> >         if (S_ISREG(c->stat.mode)) {
> >                 struct path upperpath;
> >
> > @@ -457,27 +472,11 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
> >                         return err;
> >         }
> >
> > -       err = ovl_copy_xattr(c->lowerpath.dentry, temp);
> > -       if (err)
> > -               return err;
> > -
> >         inode_lock(temp->d_inode);
> >         err = ovl_set_attr(temp, &c->stat);
> >         inode_unlock(temp->d_inode);
> > -       if (err)
> > -               return err;
> > -
> > -       /*
> > -        * Store identifier of lower inode in upper inode xattr to
> > -        * allow lookup of the copy up origin inode.
> > -        */
> > -       if (c->origin) {
> > -               err = ovl_set_origin(c->dentry, c->lowerpath.dentry, temp);
> > -               if (err)
> > -                       return err;
> > -       }
> >
> > -       return 0;
> > +       return err;
> >  }
> >
> >  static int ovl_copy_up_locked(struct ovl_copy_up_ctx *c)
> > --
> > 2.5.5
> >
