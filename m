Return-Path: <vgoyal@redhat.com>
Date: Wed, 7 Mar 2018 13:52:07 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v12 13/17] ovl: Check redirects for metacopy files
Message-ID: <20180307185207.GH5350@redhat.com>
References: <20180306205408.23383-1-vgoyal@redhat.com>
 <20180306205408.23383-14-vgoyal@redhat.com>
 <CAOQ4uxgLiSNpQq0AE2aXdH3zMCPsdCNgxYtp71CauuGgrd20TQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgLiSNpQq0AE2aXdH3zMCPsdCNgxYtp71CauuGgrd20TQ@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Mar 07, 2018 at 02:16:25PM +0200, Amir Goldstein wrote:
> On Tue, Mar 6, 2018 at 10:54 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Right now we rely on path based lookup for data origin of metacopy upper.
> > This will work only if upper has not been renamed. We solved this problem
> > already for merged directories using redirect. Use same logic for metacopy
> > files.
> >
> > This patch just goes on to check redirects for metacopy files.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  fs/overlayfs/namei.c | 17 ++++++++---------
> >  1 file changed, 8 insertions(+), 9 deletions(-)
> >
> > diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> > index 220e754c974b..a4a5c5f5540d 100644
> > --- a/fs/overlayfs/namei.c
> > +++ b/fs/overlayfs/namei.c
> > @@ -265,22 +265,22 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
> >                 goto put_and_out;
> >         }
> >         if (!d_can_lookup(this)) {
> > -               if (d->is_dir)
> > -                       goto put_and_out;
> > +               d->is_dir = false;
> 
> That test was supposed to catch non-dir under dir from an upper layer
> but you are loosing the information stored in d->dir.
> 
Can you elaborate a bit more. I never understood this check.

This probably worked in the past. But now absolute redirects can be put
on regular files as well. So it is very much possible that d->is_dir
is set and then we find a non-dir dentry and in that case we don't
want to jump to "put_and_out"?

IOW, this check worked as long as redirects were supposed to be used
only for directories. Now with metacopy, redirects can be put on on
non-dir as well.

What I can probably do is that leave d->is_dir untouched. But not sure
what does that buy us. When we return back to ovl_lookup() it does not
mean anything. returned dentry could be a directory or non-directory.

If we set it to d->is_dir=false, atleast this info is meaningful in
ovl_lookup and we know if returned dentry is a direcotry or non-dir.

> >                 err = ovl_check_metacopy_xattr(this);
> >                 if (err < 0)
> >                         goto out_err;
> >                 if (!err) {
> >                         d->stop = true;
> >                         d->metacopy = false;
> > +                       goto out;
> >                 } else
> >                         d->metacopy = true;
> > -               goto out;
> > -       }
> > -       d->is_dir = true;
> > -       if (!d->last && ovl_is_opaquedir(this)) {
> > -               d->stop = d->opaque = true;
> > -               goto out;
> > +       } else {
> > +               d->is_dir = true;
> > +               if (!d->last && ovl_is_opaquedir(this)) {
> > +                       d->stop = d->opaque = true;
> > +                       goto out;
> 
> I think there is a bug here - not related to your change, but semi related
> to your recent fix patch (patch 1 in this series).
> 
> d->last is set to true when lookup in parent poe->numlower layer,
> but parent may be pure upper for example and redirect from child can still
> continue lookup to lower layers. If a directory is marked both "redirect" and
> "opaque" (which is an inconsistency). In that case, d->last will be true
> and opaque xattr will not be checked, but redirect will be checked.

I am not sure I understand the concern. d->last will be set only if this
is last layer we are looking into and in that case it does not matter if
we process opaque or not.

Say we had pure upper parent and child directory had both opaque and redirect
set. If redirect is relative, then we will not even search in lower pas
poe->numlower=0. If redirect is absolute, then poe is reset to roe and we
will start searching from root and d->last will be set when searching in
last layer. 

So I can't see what's the issue. Can you give an example.

Thanks
Vivek

> 
> Since AFAIK d->last is an optimization, I think it could be relaxed to
> lower.layer->idx == roe->numlower - 1
> and then for the d->last case, we can skip both opaque and redirect checks
> and skip redirect check for both directory and metadata.
> 
> 
> > +               }
> >         }
> >         err = ovl_check_redirect(this, d, prelen, post);
> >         if (err)
> 
> Thanks,
> Amir.
