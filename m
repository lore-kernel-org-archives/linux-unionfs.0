Return-Path: <vgoyal@redhat.com>
Date: Wed, 30 Jan 2019 10:43:12 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] overlayfs: Do not lose security.capability xattr over
 metadata file copy-up
Message-ID: <20190130154312.GA2757@redhat.com>
References: <20190129205042.GA22017@redhat.com>
 <CAOQ4uxhAsVgkxND=Bj-jrZf307_+e=E6Zg+a1kOiFaGh1YBuEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhAsVgkxND=Bj-jrZf307_+e=E6Zg+a1kOiFaGh1YBuEQ@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Jan 30, 2019 at 09:42:19AM +0200, Amir Goldstein wrote:
> On Tue, Jan 29, 2019, 10:50 PM Vivek Goyal <vgoyal@redhat.com wrote:
> 
> > If a file has been copied up metadata only, and later data is copied up,
> > upper loses any security.capability xattr it has (underlying filesystem
> > clears it as upon file write).
> >
> 
> 
> Write also clears suid mode bits
> Should we restore these as well? Or do we already and I missed it?

[ Adding linux-unionfs ]

suid mode bit is only cleared if caller does not have CAP_FSETID.

should_remove_suid() {
        if (unlikely(kill && !capable(CAP_FSETID) && S_ISREG(mode)))
                return kill;
}

We do copy up in the context of mounter which is root, often with
CAP_FSETID.

So while this is not a widespread problem yet, it is a potential issue.
We can fix it if somebody runs into it.

> 
> 
> > From a user's point of view, this is just a file copy-up and that should
> > not result in losing security.capability xattr. Hence, before data copy
> > up, save security.capability xattr (if any) and restore it on upper after
> > data copy up is complete.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  fs/overlayfs/copy_up.c   |   24 +++++++++++++++++++++++-
> >  fs/overlayfs/overlayfs.h |    1 +
> >  fs/overlayfs/util.c      |   44
> > ++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 68 insertions(+), 1 deletion(-)
> >
> > Index: rhvgoyal-linux/fs/overlayfs/util.c
> > ===================================================================
> > --- rhvgoyal-linux.orig/fs/overlayfs/util.c     2019-01-28
> > 14:42:10.499670636 -0500
> > +++ rhvgoyal-linux/fs/overlayfs/util.c  2019-01-29 14:45:49.747395201 -0500
> > @@ -912,3 +912,47 @@ invalid:
> >         res = -EINVAL;
> >         goto err_free;
> >  }
> > +
> > +size_t ovl_getxattr(struct dentry *dentry, char *name, void **value,
> > +                               size_t *size)
> > +{
> >
> 
> 
> Please add padding arg and use this helper from ovl_get_redirect_xattr.

Ok, will do.

Vivek
