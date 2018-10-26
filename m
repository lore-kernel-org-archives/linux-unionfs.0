MIME-Version: 1.0
In-Reply-To: <20181018153714.3834-1-amir73il@gmail.com>
References: <20181018153714.3834-1-amir73il@gmail.com>
Date: Fri, 26 Oct 2018 23:55:12 +0200
Message-ID: <CAJfpegugU6Gkb4vV5mzaEqruaK5x_e8H=3-VbGu0mxHvho9CdQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] Overlay inode lock cleanups
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Oct 18, 2018 at 5:37 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Miklos,
>
> First patch removes pretty big ugliness.
> Second patch is just a matter of taste, so as you wish.
>
> I'll use this opportunity to recap the queue of my proposed patches for
> v4.20, so you can see if you missed to consider any of them:
>
> * 5401b99fcbb9 - (overlayfs-devel) ovl: abstract ovl_inode lock with a helper
> * 8edcbcef4e55 - ovl: remove the 'locked' argument of ovl_nlink_{start,end}
> * bd2ea818ecca - ovl: relax requirement for non null uuid of lower fs
> * 19c221c3a6b5 - ovl: disable new features for deprecated upper fs
> * 1c785e83823c - ovl: untangle copy up call chain
> * b67871490628 - (ovl-fixes) ovl: fix recursive oi->lock in ovl_link()
> * e39a0eb89ae4 - vfs: fix FIGETBSZ ioctl on an overlayfs file
> * 431d5170b91d - ovl: fix error handling in ovl_verify_set_fh()
> * 388b00daecb8 - kernel/acct.c: fix locking order when switching acct files

Pushed an update to overlayfs-next that contains most of these.  I've
dropped the kernel/acct.c one as I didn't yet have time to review it,
and also the option fallback one as that is still under discussion.

Passes my tests, but more eyes and testing cannot hurt...

Thanks,
Miklos
