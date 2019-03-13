From: Richard Weinberger <richard@nod.at>
Subject: Re: overlayfs vs. fscrypt
Date: Wed, 13 Mar 2019 14:00:28 +0100
Message-ID: <1854703.ve7plDhYWt@blindfold>
References: <4603533.ZIfxmiEf7K@blindfold> <1852545.qrIQg0rEWx@blindfold> <CAJfpegvrG4LfnuC62JNtdXpCf4vb+aEiDre5YCxe7xUSQP8yjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegvrG4LfnuC62JNtdXpCf4vb+aEiDre5YCxe7xUSQP8yjw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-fscrypt@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Am Mittwoch, 13. März 2019, 13:58:11 CET schrieb Miklos Szeredi:
> On Wed, Mar 13, 2019 at 1:47 PM Richard Weinberger <richard@nod.at> wrote:
> >
> > Am Mittwoch, 13. März 2019, 13:36:02 CET schrieb Miklos Szeredi:
> > > I don't get it.  Does fscrypt try to check permissions via
> > > ->d_revalidate?  Why is it not doing that via ->permission()?
> >
> > Please let me explain. Suppose we have a fscrypto directory /mnt and
> > I *don't* have the key.
> >
> > When reading the directory contents of /mnt will return an encrypted filename.
> > e.g.
> > # ls /mnt
> > +mcQ46ne5Y8U6JMV9Wdq2C
> 
> Why does showing the encrypted contents make any sense?  It could just
> return -EPERM on all operations?

The use case is that you can delete these files if the DAC/MAC permissions allow it.
Just like on NTFS. If a user encrypts files, the admin cannot read them but can
remove them if the user is gone or loses the key.

Thanks,
//richard
