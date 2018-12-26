Return-Path: <vgoyal@redhat.com>
Date: Wed, 26 Dec 2018 14:09:45 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] overlayfs: During copy up, first copy up data and then
 xattrs
Message-ID: <20181226190945.GC5398@redhat.com>
References: <20181219185309.GA27281@redhat.com>
 <CAOQ4uxjeEfFK3dTKEugJhGBpoVrsuvNCLQ7js4makis5KsRzmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjeEfFK3dTKEugJhGBpoVrsuvNCLQ7js4makis5KsRzmw@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Giuseppe Scrivano <gscrivan@redhat.com>, dwalsh@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Dec 19, 2018 at 09:54:59PM +0200, Amir Goldstein wrote:
> On Wed, Dec 19, 2018 at 8:53 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > If xattrs are copied up first and then data is copied up, it can clear
> > suid/sgid permissions on copied up file and hence remove security.capability
> > xattr. And this can result into surprises.
> >
> > First of all, if a setuid binary on lower is opened for writing (but
> > nothing is actually written), then copy up should not result in removing
> > setuid bit.
> >
> > Also, chown, first copies up file and then tries to clear setuid bit.
> > But by that time security.capability xattr is already gone (due to
> > data copy up), and caller gets -ENODATA. This has been reported by
> > Giuseppe here.
> >
> > https://github.com/containers/libpod/issues/2015#issuecomment-447824842
> >
> 
> Can you write an xfstest for those use cases?

Will do.

> 
> > Fix this by copying up data first and then metadta. This is a regression
> > which has been introduced by my commit as part of metadata only copy up
> > patches.
> >
> > commit bd64e57586d3722d2fc06093c3d7e3c4adb9e060
> 
> Pleases used the Fixes: annotation.

Ok.

> 
> > Author: Vivek Goyal <vgoyal@redhat.com>
> > Date:   Fri May 11 11:49:27 2018 -0400
> >
> >     ovl: During copy up, first copy up metadata and then data
> >
> > TODO: There will be some corner cases where a file is copied up metadata
> >       only and later data copy up happens and that will clear setuid/setgid
> >       bit. Something needs to be done about that too.
> >
> > Reported-by: Giuseppe Scrivano <gscrivan@redhat.com>
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  fs/overlayfs/copy_up.c |   31 +++++++++++++++++--------------
> >  1 file changed, 17 insertions(+), 14 deletions(-)
> >
> > Index: rhvgoyal-linux-fuse/fs/overlayfs/copy_up.c
> > ===================================================================
> > --- rhvgoyal-linux-fuse.orig/fs/overlayfs/copy_up.c     2018-12-19 11:31:33.981003615 -0500
> > +++ rhvgoyal-linux-fuse/fs/overlayfs/copy_up.c  2018-12-19 11:31:38.862003615 -0500
> > @@ -443,10 +443,26 @@ static int ovl_copy_up_inode(struct ovl_
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
> >         err = ovl_copy_xattr(c->lowerpath.dentry, temp);
> >         if (err)
> >                 return err;
> > -
> 
> Nit: keep newline.

Ok.

Thanks
Vivek
