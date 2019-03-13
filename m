From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: overlayfs vs. fscrypt
Date: Wed, 13 Mar 2019 14:24:47 +0100
Message-ID: <CAJfpegtgfuAkgv26QH6Ht25OeMiev-QvEf7ror4KAbud7FADgg@mail.gmail.com>
References: <4603533.ZIfxmiEf7K@blindfold> <1852545.qrIQg0rEWx@blindfold>
 <CAJfpegvrG4LfnuC62JNtdXpCf4vb+aEiDre5YCxe7xUSQP8yjw@mail.gmail.com> <1854703.ve7plDhYWt@blindfold>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1854703.ve7plDhYWt@blindfold>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Cc: linux-fsdevel@vger.kernel.org, linux-fscrypt@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Wed, Mar 13, 2019 at 2:00 PM Richard Weinberger <richard@nod.at> wrote:
>
> Am Mittwoch, 13. M=C3=A4rz 2019, 13:58:11 CET schrieb Miklos Szeredi:
> > On Wed, Mar 13, 2019 at 1:47 PM Richard Weinberger <richard@nod.at> wro=
te:
> > >
> > > Am Mittwoch, 13. M=C3=A4rz 2019, 13:36:02 CET schrieb Miklos Szeredi:
> > > > I don't get it.  Does fscrypt try to check permissions via
> > > > ->d_revalidate?  Why is it not doing that via ->permission()?
> > >
> > > Please let me explain. Suppose we have a fscrypto directory /mnt and
> > > I *don't* have the key.
> > >
> > > When reading the directory contents of /mnt will return an encrypted =
filename.
> > > e.g.
> > > # ls /mnt
> > > +mcQ46ne5Y8U6JMV9Wdq2C
> >
> > Why does showing the encrypted contents make any sense?  It could just
> > return -EPERM on all operations?
>
> The use case is that you can delete these files if the DAC/MAC permission=
s allow it.
> Just like on NTFS. If a user encrypts files, the admin cannot read them b=
ut can
> remove them if the user is gone or loses the key.

There's the underlying filesystem view where admin can delete files,
etc.   And there's the fscrypt layer stacked on top of the underlying
fs, which en/decrypts files *in case the user has the key*.  What if
one user has a key, but the other one doesn't?  Will d_revalidate
constantly switch the set of dentries between the encrypted filenames
and the decrypted ones?  Sounds crazy.  And the fact that NTFS does
this doesn't make it any less crazy...

Thanks,
Miklos
