From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: overlayfs vs. fscrypt
Date: Wed, 13 Mar 2019 08:30:07 -0700
Message-ID: <20190313153006.GB703@sol.localdomain>
References: <4603533.ZIfxmiEf7K@blindfold>
 <1854703.ve7plDhYWt@blindfold>
 <CAJfpegtgfuAkgv26QH6Ht25OeMiev-QvEf7ror4KAbud7FADgg@mail.gmail.com>
 <4066872.KGdO14EQMx@blindfold>
 <CAOQ4uxhqQKzriL0An4Tvzc1E_LffL-z9q1otOW_RdD1ZdKWP3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhqQKzriL0An4Tvzc1E_LffL-z9q1otOW_RdD1ZdKWP3Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Richard Weinberger <richard@nod.at>, Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-fscrypt@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Paul Lawrence <paullawrence@google.com>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Mar 13, 2019 at 04:26:54PM +0200, Amir Goldstein wrote:
> On Wed, Mar 13, 2019 at 3:34 PM Richard Weinberger <richard@nod.at> wrote:
> >
> > Am Mittwoch, 13. März 2019, 14:24:47 CET schrieb Miklos Szeredi:
> > > > The use case is that you can delete these files if the DAC/MAC permissions allow it.
> > > > Just like on NTFS. If a user encrypts files, the admin cannot read them but can
> > > > remove them if the user is gone or loses the key.
> > >
> > > There's the underlying filesystem view where admin can delete files,
> > > etc.   And there's the fscrypt layer stacked on top of the underlying
> > > fs, which en/decrypts files *in case the user has the key*.  What if
> > > one user has a key, but the other one doesn't?  Will d_revalidate
> > > constantly switch the set of dentries between the encrypted filenames
> > > and the decrypted ones?  Sounds crazy.  And the fact that NTFS does
> > > this doesn't make it any less crazy...
> >
> > Well, I didn't come up with this feature. :-)
> >
> > If one user has the key and the other not, a classic multi-user
> > system, then you need to make sure that the affected fscrypt instances
> > are not visible by both.
> > For example by using mount namespaces to make sure that user a can only
> > see /home/foo and user b only /home/bar.
> > Or removing the search permission on /home/foo and /home/bar.
> >
> > I know, I know, but that's how it is...
> > Maybe Ted or Eric can give more details on why they chose this approach.
> >
> 
> AFAIK, this feature was born to tailor Android's file based encryption.
> https://source.android.com/security/encryption#file-based
> It is meant to protect data at rest and what happens when user enters
> the screen lock password IIRC, is that some service will get restarted.
> IOW, there should NOT be any processes in Android accessing the
> encrypted user data folders with and without the key simultaneously.

See my response to Miklos.  Even if some processes had the key in their keyring
and some didn't, which isn't the case on Android since on Android the fscrypt
keys are placed in a "global" keyring, there's still only one cached inode per
file/directory/symlink, and it either has the key (->i_crypt_info != NULL) or it
doesn't (i_crypt_info == NULL).  And it can only go from ->i_crypt_info == NULL
to ->i_crypt_info != NULL, not vice versa.

Also to be clear, there are other fscrypt users besides Android.  E.g. Chrome OS
where it replaced eCryptfs for home directory encryption and was actually the
original use case, people using it on "regular" Linux distros like Ubuntu via
the userspace tool https://github.com/google/fscrypt, and Richard using UBIFS
encryption on embedded devices.  It's not just for Android.

> Also, like OpenWRT, in Android the key does not get removed
> (until boot) AFAIK(?).

On Android, the fscrypt keys are removed when you switch users on a multi-user
device, or when you turn off work mode on a device with a work profile.  This is
currently accompanied by a 'sync && echo 3 > /proc/sys/vm/drop_caches', so the
inodes get evicted too and the files revert to their ciphertext "view".  I'd
like to replace this with my proposed new ioctl FS_IOC_REMOVE_ENCRYPTION_KEY,
which avoids the drop_caches hack: https://patchwork.kernel.org/patch/10821455/.

> 
> That dcache behavior remind me of the proposal to make case
> insensitive a per mount option (also for an Android use case).
> Eventually, that was replaced with per directory flag, which plays
> much better with dache.
> 
> IMO, the best thing for UBIFS to do would be to modify fscrypt to support
> opting out of the revalidate behavior, IWO, sanitize your hack to an API.

As noted in my other response, a better solution (if this is really needed at
all) would probably be to move a stripped-down version of fscrypt_d_revalidate()
to the VFS, so fscrypt won't need to use any dentry_operations at all.

> 
> It's good that you are thinking about what will happen with overlayfs
> over ext4/f2fs, but I think that it will be messy if dentry names would be
> changing in underlying fs and the fact the overlayfs accessed the underlying
> dirs with different credentials at times makes this even more messy.
> 
> The way out of this mess IMO would be for ext4/f2fs to also conditionally
> opt-out of d_revalidate behavior at mount time if the fs is expected to be
> used under overlayfs.
> In Android, for example, I think the use case of "admin deleting
> the encrypted directories" is only relevant on "reset to default" and that
> happens in recovery boot that could potentially opt-out of encryption
> altogether (because there is no user to enter the password anyway).
> 
> I could be over simplifying things for the Android use case and my
> information could be severely out dated.
> CC Paul Lawrence to fill in my Android knowledge gaps.
> 
> Thanks,
> Amir.

- Eric
