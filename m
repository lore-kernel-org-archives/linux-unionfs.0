From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: overlayfs vs. fscrypt
Date: Wed, 13 Mar 2019 08:01:27 -0700
Message-ID: <20190313150126.GA703@sol.localdomain>
References: <4603533.ZIfxmiEf7K@blindfold>
 <1852545.qrIQg0rEWx@blindfold>
 <CAJfpegvrG4LfnuC62JNtdXpCf4vb+aEiDre5YCxe7xUSQP8yjw@mail.gmail.com>
 <1854703.ve7plDhYWt@blindfold>
 <CAJfpegtgfuAkgv26QH6Ht25OeMiev-QvEf7ror4KAbud7FADgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJfpegtgfuAkgv26QH6Ht25OeMiev-QvEf7ror4KAbud7FADgg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Richard Weinberger <richard@nod.at>, linux-fsdevel@vger.kernel.org, linux-fscrypt@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Hi Miklos,

On Wed, Mar 13, 2019 at 02:24:47PM +0100, Miklos Szeredi wrote:
> On Wed, Mar 13, 2019 at 2:00 PM Richard Weinberger <richard@nod.at> wrote:
> >
> > Am Mittwoch, 13. März 2019, 13:58:11 CET schrieb Miklos Szeredi:
> > > On Wed, Mar 13, 2019 at 1:47 PM Richard Weinberger <richard@nod.at> wrote:
> > > >
> > > > Am Mittwoch, 13. März 2019, 13:36:02 CET schrieb Miklos Szeredi:
> > > > > I don't get it.  Does fscrypt try to check permissions via
> > > > > ->d_revalidate?  Why is it not doing that via ->permission()?
> > > >
> > > > Please let me explain. Suppose we have a fscrypto directory /mnt and
> > > > I *don't* have the key.
> > > >
> > > > When reading the directory contents of /mnt will return an encrypted filename.
> > > > e.g.
> > > > # ls /mnt
> > > > +mcQ46ne5Y8U6JMV9Wdq2C
> > >
> > > Why does showing the encrypted contents make any sense?  It could just
> > > return -EPERM on all operations?
> >
> > The use case is that you can delete these files if the DAC/MAC permissions allow it.
> > Just like on NTFS. If a user encrypts files, the admin cannot read them but can
> > remove them if the user is gone or loses the key.
> 
> There's the underlying filesystem view where admin can delete files,
> etc.   And there's the fscrypt layer stacked on top of the underlying
> fs, which en/decrypts files *in case the user has the key*.  What if
> one user has a key, but the other one doesn't?  Will d_revalidate
> constantly switch the set of dentries between the encrypted filenames
> and the decrypted ones?  Sounds crazy.  And the fact that NTFS does
> this doesn't make it any less crazy...
> 

fscrypt (aka ext4/f2fs/ubifs encryption) isn't a stacked filesystem.  I think
you're confusing it with eCryptfs.  There's only one "view" of the filesystem.

It's true that different processes can put different keys in their
process-subscribed keyrings, e.g. their session keyrings.  But that doesn't
change the fact that each cached inode either has the key or it doesn't, and all
users share those same cached inodes.  The mistake here is not making the keys
be provided at the filesystem level too, and I've proposed to fix that:
https://patchwork.kernel.org/cover/10821413/

Note that the the key (->i_crypt_info) is never removed from a cached inode
without evicting it.  It used to be done, but it was broken and removed.  Now a
cached inode can only have the key added.  For this reason and others, I think
fscrypt_d_revalidate() contains unneeded checks and can be simplified to this:

	static int fscrypt_d_revalidate(struct dentry *dentry, unsigned int flags)
	{
		struct dentry *dir;
		bool valid;

		if (flags & LOOKUP_RCU)
			return -ECHILD;

		if (dentry->d_flags & DCACHE_ENCRYPTED_WITH_KEY)
			return 1;

		dir = dget_parent(dentry);
		valid = (d_inode(dir)->i_crypt_info == NULL);
		dput(dir);
		return valid;
	}

I think we can even support RCU mode too.

Then, one possibility is to move fscrypt_d_revalidate() to the VFS.  If we
replace DCACHE_ENCRYPTED_WITH_KEY with the opposite meaning, say
DCACHE_CIPHERTEXT_NAME, then the VFS will have everything it needs to just do
the equivalent of fscrypt_d_revalidate() directly in d_revalidate() in
fs/namei.c.  So fscrypt_d_ops won't be needed at all.  Something like this:

#ifdef CONFIG_FS_ENCRYPTION
static inline int fscrypt_d_revalidate(struct dentry *dentry,
                                       unsigned int flags)
{
	struct dentry *dir;
	struct inode *dir_inode;

	if (!(READ_ONCE(dentry->d_flags) & DCACHE_CIPHERTEXT_NAME))
		return 1;

	dir = READ_ONCE(dentry->d_parent);
	dir_inode = READ_ONCE(dir->d_inode);
	return READ_ONCE(dir_inode->i_crypt_info) == NULL;
}
#else
static inline int fscrypt_d_revalidate(struct dentry *dentry,
                                       unsigned int flags)
{
        return 1;
}
#endif

static inline int d_revalidate(struct dentry *dentry, unsigned int flags)
{
        int status;

        if (unlikely(dentry->d_flags & DCACHE_OP_REVALIDATE))
                status = dentry->d_op->d_revalidate(dentry, flags);
        else
                status = 1;

        if (status > 0)
                status = fscrypt_d_revalidate(dentry, flags);
        return status;
}


What do you think about this?

- Eric
