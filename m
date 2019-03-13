From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: overlayfs vs. fscrypt
Date: Wed, 13 Mar 2019 13:58:11 +0100
Message-ID: <CAJfpegvrG4LfnuC62JNtdXpCf4vb+aEiDre5YCxe7xUSQP8yjw@mail.gmail.com>
References: <4603533.ZIfxmiEf7K@blindfold> <CAJfpegsy31D+=VJ+By2a9TLCvZJwvAUpb+_bJ5JVTsmsbZJTKQ@mail.gmail.com>
 <1852545.qrIQg0rEWx@blindfold>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1852545.qrIQg0rEWx@blindfold>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Cc: linux-fsdevel@vger.kernel.org, linux-fscrypt@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Wed, Mar 13, 2019 at 1:47 PM Richard Weinberger <richard@nod.at> wrote:
>
> Am Mittwoch, 13. M=C3=A4rz 2019, 13:36:02 CET schrieb Miklos Szeredi:
> > I don't get it.  Does fscrypt try to check permissions via
> > ->d_revalidate?  Why is it not doing that via ->permission()?
>
> Please let me explain. Suppose we have a fscrypto directory /mnt and
> I *don't* have the key.
>
> When reading the directory contents of /mnt will return an encrypted file=
name.
> e.g.
> # ls /mnt
> +mcQ46ne5Y8U6JMV9Wdq2C

Why does showing the encrypted contents make any sense?  It could just
return -EPERM on all operations?

Thanks,
Miklos
