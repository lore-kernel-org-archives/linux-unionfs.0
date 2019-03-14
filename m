From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: overlayfs vs. fscrypt
Date: Thu, 14 Mar 2019 08:34:33 +0100
Message-ID: <CAJfpegvX4ANfso-Jn1zaB+m4Q_0eK9i-+MCJ+sTH5QzD3PZFMQ@mail.gmail.com>
References: <4603533.ZIfxmiEf7K@blindfold> <15244624.W7e5yEypHC@blindfold>
 <20190313222610.GF10169@gmail.com> <4098793.CtYQtWW4dM@blindfold>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4098793.CtYQtWW4dM@blindfold>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Cc: Eric Biggers <ebiggers@kernel.org>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-fscrypt@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Paul Lawrence <paullawrence@google.com>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Mar 13, 2019 at 11:42 PM Richard Weinberger <richard@nod.at> wrote:
>
> Am Mittwoch, 13. M=C3=A4rz 2019, 23:26:11 CET schrieb Eric Biggers:

> > What specifically is wrong with supporting the ciphertext "view" of enc=
rypted
> > directories, and why do you want to opt UBIFS out of it specifically bu=
t not
> > ext4 and f2fs?  (The fscrypt_operations are per-filesystem type, not
> > per-filesystem instance, so I assume that's what you had in mind.)  Not=
e that we
> > can't unconditionally remove it because people need it to delete files =
without
> > the key.  We could add a mount option to disable it, but why exactly?
>
> You are right, fscrypt_operations is the wrong structure.
> My plan was having it per filesystem instance. So a mount-option seems li=
ke
> a good option. Of course for all filesystems that support fscrypt, not ju=
st UBIFS.

Yes, please.   Changing filesystem contents based on a mount option is
orders of magnitude more sane than doing so on key insertion/removal.

Thanks,
Miklos
