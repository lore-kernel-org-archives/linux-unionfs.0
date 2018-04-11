Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180411151253.GB4568@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com> <20180329193854.13814-22-vgoyal@redhat.com>
 <CAOQ4uxhsijEOhGS8mBP_gtMFu0uERd6gK_2UfR-kN1D=wv5Kzw@mail.gmail.com> <20180411151253.GB4568@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 11 Apr 2018 20:01:40 +0300
Message-ID: <CAOQ4uxip-LznMWE86fcF+Zd5pQUR7hNJfMD90HukdYhL-Kj0=A@mail.gmail.com>
Subject: Re: [PATCH v13 21/28] ovl: Set redirect on metacopy files upon rename
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Apr 11, 2018 at 6:12 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Mar 30, 2018 at 10:31:46AM +0300, Amir Goldstein wrote:
>> On Thu, Mar 29, 2018 at 10:38 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > Set redirect on metacopy files upon rename. This will help find data dentry
>> > in lower dirs.
>> >
>> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>> > ---
>> >  fs/overlayfs/dir.c | 50 +++++++++++++++++++++++++++++++++++++-------------
>> >  1 file changed, 37 insertions(+), 13 deletions(-)
>> >
>> > diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
>> > index 3ea052b6bac7..7c0a02d9f6bd 100644
>> > --- a/fs/overlayfs/dir.c
>> > +++ b/fs/overlayfs/dir.c
>> > @@ -968,6 +968,27 @@ static void ovl_rename_unlock_ovl_inodes(struct dentry *old, struct dentry *new,
>> >                 mutex_unlock(&OVL_I(d_inode(new))->lock);
>> >  }
>> >
>> > +static bool ovl_relative_redirect(struct dentry *dentry, bool samedir)
>> > +{
>> > +       if (d_is_dir(dentry))
>> > +               return samedir;
>> > +
>> > +       /*
>> > +        * For non-dir hardlinked files, we need absolute redirects
>> > +        * in general as two upper hardlinks could be in different
>> > +        * dirs. We could put a relative redirect now and convert
>> > +        * it to absolute redirect later. But when nlink > 1 and
>> > +        * indexing is on, that means relative redirect needs to be
>> > +        * converted to absolute during copy up of another lower
>> > +        * hardllink as well.
>> > +        *
>> > +        * So without optimizing too much, just check if non-dir
>> > +        * has nlink > 1 or not. If yes, set absolute redirect to
>> > +        * begin with.
>> > +        */
>> > +       return (d_inode(dentry)->i_nlink > 1 ? false : samedir);
>>
>> I don't think this is wrong, but I don't like relying on the overlay inode
>> nlink. I wonder if you should separate the case of indexed and
>> non-indexed inode.
>
> Hi Amir,
>
> So if inode is indexed, use absolute redirect, otherwise use, relative
> redirect? But how do we get reliably the informaton if inode is
> indexed or not. I mean, OVL_INDEX has memory ordering issues, w.r.t
> copy up, so that's untrusted as well.
>
> How about if I check for nlink of lowerdentry (instead of ovl dentry).
> Will that be fine?
>

I guess that would be fine.
Maybe nicer if we set OVL_LOWER_HARDLINK in lookup.
But for now, let's just say I did not NACK your patch
and maybe there is no good reason to doubt the reliability of
overlay inode nlink, so unless Miklos feels otherwise, let's postpone this
discussion for a later time.

Cheers,
Amir.
