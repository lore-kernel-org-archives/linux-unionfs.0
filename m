Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40284 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729697AbfAKSfk (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 11 Jan 2019 13:35:40 -0500
Date: Fri, 11 Jan 2019 13:35:38 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH][V2] overlayfs: During copy up, first copy up data and
 then xattrs
Message-ID: <20190111183538.GA16012@redhat.com>
References: <20190110222947.GA32672@redhat.com>
 <CAOQ4uxh2cYg6Mt=-kY1Nh-ODq+Py=tXJ7PRKU2k_FBS3mgHtwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxh2cYg6Mt=-kY1Nh-ODq+Py=tXJ7PRKU2k_FBS3mgHtwA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, dwalsh@redhat.com, Giuseppe Scrivano <gscrivan@redhat.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Jan 11, 2019 at 07:39:11AM +0200, Amir Goldstein wrote:
> On Fri, Jan 11, 2019 at 12:29 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > If a file with capability set (and hence security.capability xattr) is
> > written kernel clears security.capability xattr. For overlay, during file
> > copy up if xattrs are copied up first and then data is, copied up. This
> > means data copy up will result in clearing of security.capability xattr
> > file on lower has. And this can result into surprises. If
> > a lower file has CAP_SETUID, then it should not be cleared over
> > copy up (if nothing was actually written to file).
> >
> > This also creates problems with chown logic where it first copies up file
> > and then tries to clear setuid bit. But by that time security.capability
> > xattr is already gone (due to data copy up), and caller gets -ENODATA.
> > This has been reported by Giuseppe here.
> >
> > https://github.com/containers/libpod/issues/2015#issuecomment-447824842
> >
> > Fix this by copying up data first and then metadta. This is a regression
> > which has been introduced by my commit as part of metadata only copy up
> > patches.
> >
> > TODO: There will be some corner cases where a file is copied up metadata
> >       only and later data copy up happens and that will clear
> >       security.capability xattr. Something needs to be done about that too.
> >
> > Fixes: bd64e57586d3 ("ovl: During copy up, first copy up metadata and then data")
> > Reported-by: Giuseppe Scrivano <gscrivan@redhat.com>
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  fs/overlayfs/copy_up.c |   30 +++++++++++++++++-------------
> >  1 file changed, 17 insertions(+), 13 deletions(-)
> >
> > Index: rhvgoyal-linux/fs/overlayfs/copy_up.c
> > ===================================================================
> > --- rhvgoyal-linux.orig/fs/overlayfs/copy_up.c  2018-11-28 08:45:58.122478207 -0500
> > +++ rhvgoyal-linux/fs/overlayfs/copy_up.c       2019-01-10 13:29:05.997079686 -0500
> > @@ -443,6 +443,23 @@ static int ovl_copy_up_inode(struct ovl_
> >  {
> >         int err;
> >
> > +       /*
> > +        * Copy up data first and then xattrs. Writing data after
> > +        * xattrs will remove security.capability xattr automatically.
> > +        */
> > +       if (S_ISREG(c->stat.mode) && !c->metacopy) {
> > +               struct path upperpath, datapath;
> > +
> > +               ovl_path_upper(c->dentry, &upperpath);
> > +               BUG_ON(upperpath.dentry != NULL);
> > +               upperpath.dentry = temp;
> > +
> > +               ovl_path_lowerdata(c->dentry, &datapath);
> > +               err = ovl_copy_up_data(&datapath, &upperpath, c->stat.size);
> > +               if (err)
> > +                       return err;
> > +       }
> > +
> 
> I know you just moved this code around, but please change it to
> if (WARN_ON(...)) return -EIO;

Will do.

> 
> If it was up to me, I would change the call arguments to:
>               err = ovl_copy_up_data(c, temp);
> 
> and compose the paths inside ovl_copy_up_data().
> There are more similarities to both call sites than there are differences.

This I will take care of some other time. This is cleanup and I want to
mark this patch for stable as well.

Thanks
Vivek
