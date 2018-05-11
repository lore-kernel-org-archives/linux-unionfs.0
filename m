Return-Path: <vgoyal@redhat.com>
Date: Fri, 11 May 2018 11:14:55 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v15 10/30] ovl: Modify ovl_lookup() and friends to lookup
 metacopy dentry
Message-ID: <20180511151455.GC6044@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
 <20180507174102.24086-11-vgoyal@redhat.com>
 <20180511143041.GB6044@redhat.com>
 <CAOQ4uxjJHW90tafaeDxCp-k98JJzbk=AHN7LjP8z44xTgwwGow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjJHW90tafaeDxCp-k98JJzbk=AHN7LjP8z44xTgwwGow@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, May 11, 2018 at 06:05:11PM +0300, Amir Goldstein wrote:

[..]
> > +                *
> > +                * For non-dir dentry, if index=on, then ensure origin
> > +                * matches the dentry found using path based lookup,
> > +                * otherwise error out. If index=off, then do not error
> > +                * out if origin does not match.
> >                  */
> > -               if (upperdentry && !ctr && ovl_verify_lower(dentry->d_sb)) {
> > +               if (upperdentry && !ctr &&
> > +                   ((d.is_dir && ovl_verify_lower(dentry->d_sb)) ||
> > +                    (!d.is_dir && origin_path))) {
> >                         err = ovl_verify_origin(upperdentry, this, false);
> >                         if (err) {
> > -                               dput(this);
> > -                               break;
> > +                               if (d.is_dir) {
> > +                                       dput(this);
> > +                                       break;
> > +                               } else if (ofs->config.index) {
> > +                                       dput(this);
> > +                                       goto out_put;
> > +                               }
> > +                       } else {
> > +                               /* Bless lower as verified origin */
> > +                               origin = this;
> >                         }
> > +               }
> >
> 
> Logically, this looks correct, but if we don't need the blessing for index=off
> and we won't fail lookup, then there is no need to ovl_verify_origin() at
> all if index=off, so this shrinks a few lines of code and saves the extra
> check.

Makes sense. Will change. Call ovl_verify_origin() only if index is
on for non-dir files.

Vivek
> 
> Thanks,
> Amir.
