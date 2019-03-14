From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH 4/4] ubifs: Implement new mount option, fscrypt_key_required
Date: Thu, 14 Mar 2019 21:54:10 +0100
Message-ID: <1957441.Hty6t2mpXG@blindfold>
References: <CAJfpegvX4ANfso-Jn1zaB+m4Q_0eK9i-+MCJ+sTH5QzD3PZFMQ@mail.gmail.com> <20190314171559.27584-5-richard@nod.at> <20190314174913.GA30026@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190314174913.GA30026@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-mtd@lists.infradead.org, linux-fscrypt@vger.kernel.org, jaegeuk@kernel.org, tytso@mit.edu, linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, paullawrence@google.com
List-Id: linux-unionfs@vger.kernel.org

Eric,

Am Donnerstag, 14. März 2019, 18:49:14 CET schrieb Eric Biggers:
> Hi Richard,
> 
> On Thu, Mar 14, 2019 at 06:15:59PM +0100, Richard Weinberger wrote:
> > Usually fscrypt allows limited access to encrypted files even
> > if no key is available.
> > Encrypted filenames are shown and based on this names users
> > can unlink and move files.
> 
> Actually, fscrypt doesn't allow moving files without the key.  It would only be
> possible for cross-renames, i.e. renames with the RENAME_EXCHANGE flag.  So for
> consistency with regular renames, fscrypt also forbids cross-renames if the key
> for either the source or destination directory is missing.
> 
> So the main use case for the ciphertext view is *deleting* files.  For example,
> deleting a user's home directory after that user has been removed from the
> system.  Or the system freeing up space by deleting cache files from a user who
> isn't currently logged in.

Right, I somehow thought beside of deleting you can do more.

> > 
> > This is not always what people expect. The fscrypt_key_required mount
> > option disables this feature.
> > If no key is present all access is denied with the -ENOKEY error code.
> 
> The problem with this mount option is that it allows users to create undeletable
> files.  So I'm not really convinced yet this is a good change.  And though the
> fscrypt_key_required semantics are easier to implement, we'd still have to
> support the existing semantics too, thus increasing the maintenance cost.

The undeletable-file argument is a good point. Thanks for bringing this up.
To get rid of such files root needs to mount without the new mount parameter. ;-\

> > 
> > The side benefit of this is that we don't need ->d_revalidate().
> > Not having ->d_revalidate() makes an encrypted ubifs usable
> > as overlayfs upper directory.
> > 
> 
> It would be preferable if we could get overlayfs to work without providing a
> special mount option.

Yes, but let's see what Al finds in his review.

> > Signed-off-by: Richard Weinberger <richard@nod.at>
> > ---
> >  fs/ubifs/crypto.c |  2 +-
> >  fs/ubifs/dir.c    | 29 ++++++++++++++++++++++++++---
> >  fs/ubifs/super.c  | 15 +++++++++++++++
> >  fs/ubifs/ubifs.h  |  1 +
> >  4 files changed, 43 insertions(+), 4 deletions(-)
> > 
> 
> Shouldn't readlink() honor the mount option too?

Hmmm, yes. We need to honor it in ->get_link() too.

> > +		if (c->fscrypt_key_required && !dir->i_crypt_info)
> > +			return -ENOKEY;
> > +
> 
> How about returning -ENOKEY when trying to open the directory in the first
> place, rather than allowing getting to readdir()?  That would match the behavior
> of regular files.

I'm not sure what the best approach is.
We could also do it in ->permission().

Thanks,
//richard
