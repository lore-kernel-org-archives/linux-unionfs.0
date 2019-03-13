From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: overlayfs vs. fscrypt
Date: Wed, 13 Mar 2019 16:26:54 +0200
Message-ID: <CAOQ4uxhqQKzriL0An4Tvzc1E_LffL-z9q1otOW_RdD1ZdKWP3Q@mail.gmail.com>
References: <4603533.ZIfxmiEf7K@blindfold> <1854703.ve7plDhYWt@blindfold>
 <CAJfpegtgfuAkgv26QH6Ht25OeMiev-QvEf7ror4KAbud7FADgg@mail.gmail.com> <4066872.KGdO14EQMx@blindfold>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4066872.KGdO14EQMx@blindfold>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-fscrypt@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Paul Lawrence <paullawrence@google.com>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Mar 13, 2019 at 3:34 PM Richard Weinberger <richard@nod.at> wrote:
>
> Am Mittwoch, 13. M=C3=A4rz 2019, 14:24:47 CET schrieb Miklos Szeredi:
> > > The use case is that you can delete these files if the DAC/MAC permis=
sions allow it.
> > > Just like on NTFS. If a user encrypts files, the admin cannot read th=
em but can
> > > remove them if the user is gone or loses the key.
> >
> > There's the underlying filesystem view where admin can delete files,
> > etc.   And there's the fscrypt layer stacked on top of the underlying
> > fs, which en/decrypts files *in case the user has the key*.  What if
> > one user has a key, but the other one doesn't?  Will d_revalidate
> > constantly switch the set of dentries between the encrypted filenames
> > and the decrypted ones?  Sounds crazy.  And the fact that NTFS does
> > this doesn't make it any less crazy...
>
> Well, I didn't come up with this feature. :-)
>
> If one user has the key and the other not, a classic multi-user
> system, then you need to make sure that the affected fscrypt instances
> are not visible by both.
> For example by using mount namespaces to make sure that user a can only
> see /home/foo and user b only /home/bar.
> Or removing the search permission on /home/foo and /home/bar.
>
> I know, I know, but that's how it is...
> Maybe Ted or Eric can give more details on why they chose this approach.
>

AFAIK, this feature was born to tailor Android's file based encryption.
https://source.android.com/security/encryption#file-based
It is meant to protect data at rest and what happens when user enters
the screen lock password IIRC, is that some service will get restarted.
IOW, there should NOT be any processes in Android accessing the
encrypted user data folders with and without the key simultaneously.
Also, like OpenWRT, in Android the key does not get removed
(until boot) AFAIK(?).

That dcache behavior remind me of the proposal to make case
insensitive a per mount option (also for an Android use case).
Eventually, that was replaced with per directory flag, which plays
much better with dache.

IMO, the best thing for UBIFS to do would be to modify fscrypt to support
opting out of the revalidate behavior, IWO, sanitize your hack to an API.

It's good that you are thinking about what will happen with overlayfs
over ext4/f2fs, but I think that it will be messy if dentry names would be
changing in underlying fs and the fact the overlayfs accessed the underlyin=
g
dirs with different credentials at times makes this even more messy.

The way out of this mess IMO would be for ext4/f2fs to also conditionally
opt-out of d_revalidate behavior at mount time if the fs is expected to be
used under overlayfs.
In Android, for example, I think the use case of "admin deleting
the encrypted directories" is only relevant on "reset to default" and that
happens in recovery boot that could potentially opt-out of encryption
altogether (because there is no user to enter the password anyway).

I could be over simplifying things for the Android use case and my
information could be severely out dated.
CC Paul Lawrence to fill in my Android knowledge gaps.

Thanks,
Amir.
