Return-Path: <vgoyal@redhat.com>
Date: Wed, 7 Mar 2018 15:43:29 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v12 14/17] ovl: Set redirect on metacopy files upon rename
Message-ID: <20180307204329.GL5350@redhat.com>
References: <20180306205408.23383-1-vgoyal@redhat.com>
 <20180306205408.23383-15-vgoyal@redhat.com>
 <CAOQ4uxgpjtUU1i8STkVYERV3-moyawb7ffTtpWCBJPTOA8_afQ@mail.gmail.com>
 <20180307151519.GE5350@redhat.com>
 <CAOQ4uxhj7Qy9f65nJdB70vDqODnTB8jSsAE4Hr8xbo5ReAL-BA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhj7Qy9f65nJdB70vDqODnTB8jSsAE4Hr8xbo5ReAL-BA@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Mar 07, 2018 at 06:26:01PM +0200, Amir Goldstein wrote:
> On Wed, Mar 7, 2018 at 5:15 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Wed, Mar 07, 2018 at 09:48:22AM +0200, Amir Goldstein wrote:
> >> On Tue, Mar 6, 2018 at 10:54 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> > Set redirect on metacopy files upon rename. This will help find data dentry
> >> > in lower dirs.
> >> >
> >> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> >> > ---
> >> >  fs/overlayfs/dir.c | 13 +++++++++----
> >> >  1 file changed, 9 insertions(+), 4 deletions(-)
> >> >
> >> > diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> >> > index cdeae4bdbfce..b955f6fede06 100644
> >> > --- a/fs/overlayfs/dir.c
> >> > +++ b/fs/overlayfs/dir.c
> >> > @@ -1048,9 +1048,11 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
> >> >                         err = ovl_set_redirect(old, samedir);
> >> >                 else if (!old_opaque && ovl_type_merge(new->d_parent))
> >> >                         err = ovl_set_opaque_xerr(old, olddentry, -EXDEV);
> >> > -               if (err)
> >> > -                       goto out_dput;
> >> > -       }
> >> > +       } else if (ovl_is_metacopy_dentry(old))
> >> > +                       err = ovl_set_redirect(old, false);
> >>
> >> You should use {} in the else statement as well.
> >
> > ok.
> >
> >>
> >> Q: why do you set samedir: = false here?
> >> A: because other hardlink aliasses cannot follow a relative redirect, right?
> >
> > Right. If we create a hardlink later then it will need absolute redirect
> > if both dentries are not in same dir.
> >
> >>
> >> This is a subtle detail that should be documented,
> >
> > Ok, will do.
> >
> >> but also
> >> maybe do use samedir if nlink == 1?
> >
> > Hmm.., so initially we could put a relative redirct (if nlink=1) and later
> > if we create a link, we could replace relative redirect with an absolute
> > redirect? I see we already have logic to do that for the case of rename.
> >
> > Now only thing I need to figure out in ovl_link() whethre two dentries
> > are in same dir or not. I am assuming I can just check parent dentry
> > pointers and see if these two have same parent or not.
> 
> Yes or we can just convert to absolute path anyway for nlink > 1.
> >
> > In fact, we probably don't even have to check for nlink=1. Only when
> > we create a upper hard link, then we need to make sure we replace relative
> > hardlink with absolute one. I will play with it and see how it goes.
> >
> 
> Yes. alomst true. but we do need to check for lower nlink > 1,
> because in that case (when index=on) upper hardlinks are created on
> copy up not only on ovl_link(), so easiest is to just start with
> absolute redirect
> on rename of lower hardlink.

Hmm..., even in that case it should work. For example, say foo.txt and
bar.txt are hardlinked in lower. hence nlink=2. And now I rename foo.txt
to foo-upper.txt, then it will be copied up (with index hardlinked) and
then a redirect will be set (foo.txt). And now, bar.txt can be looked up
without redirct and foo-upper.txt can be looked up with redirect. So it
should work even in nlink>1 in lower. Can you give a specific example
where it will be broken.

Having said that I don't mind to always set absolute redirect whenever
nlink > 1 (both in lower and upper) and that simplifies the logic a bit.

Vivek
