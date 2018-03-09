Return-Path: <vgoyal@redhat.com>
Date: Fri, 9 Mar 2018 09:44:31 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 3/3] ovl: set d->is_dir and d->opaque for last path
 element
Message-ID: <20180309144431.GC4596@redhat.com>
References: <20180308221804.15708-1-vgoyal@redhat.com>
 <20180308221804.15708-4-vgoyal@redhat.com>
 <CAOQ4uxjXWE57eZoGzytqjHVon=x4Q5Xu1oXb_z5CNsAuowVN_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjXWE57eZoGzytqjHVon=x4Q5Xu1oXb_z5CNsAuowVN_g@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Mar 09, 2018 at 12:34:57AM +0200, Amir Goldstein wrote:
> On Fri, Mar 9, 2018 at 12:18 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Certain properties in ovl_lookup_data should be set only for the last
> > element of the path. IOW, of we are calling ovl_lookup_single() for an
> > absolute redirect, then d->is_dir and d->opaque do not make much sense
> > for intermediate path elements. Instead set them only if dentry being
> > lookup is last path element.
> 
> Yeh, that's what I said, but I realized later that this is not accurate.
> it's true for d->is_dir, but not true for d->opaque.
> opaqueness of path elements *can* determine that the redirect result is
> opaque, for example when redirecting to /a/b/c and /a is opaque, then
> the resolved redirection is opaque *unless* either /a/b or /a/b/c has
> an absolute redirect to escape the opaqueness of /a.

Hi Amir,

I am not sure I understand this argument about "opaque". Why opaqueness
of parent matters to child. Can you please give an example.

Vivek

> 
> Hence my fix patch.
> 
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  fs/overlayfs/namei.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> > index 32d1d96f80b6..dfefe6277659 100644
> > --- a/fs/overlayfs/namei.c
> > +++ b/fs/overlayfs/namei.c
> > @@ -220,6 +220,7 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
> >  {
> >         struct dentry *this;
> >         int err;
> > +       bool last_element = !post[0];
> >
> >         this = lookup_one_len_unlocked(name, base, namelen);
> >         if (IS_ERR(this)) {
> > @@ -247,9 +248,10 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
> >                         goto put_and_out;
> >                 goto out;
> >         }
> > -       d->is_dir = true;
> > +       if (last_element)
> > +               d->is_dir = true;
> >         if (!d->last) {
> > -               if (ovl_is_opaquedir(this)) {
> > +               if (last_element && ovl_is_opaquedir(this)) {
> >                         d->stop = d->opaque = true;
> >                         goto out;
> >                 }
> > --
> > 2.13.6
> >
