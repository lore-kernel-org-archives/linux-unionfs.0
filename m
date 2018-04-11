Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <1523466569-11765-1-git-send-email-amir73il@gmail.com>
References: <1523466569-11765-1-git-send-email-amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 11 Apr 2018 20:11:17 +0300
Message-ID: <CAOQ4uxiDaLxCXADp6dT5evDKY5iv-7VXAFkEBQ_4YjjhGd2kYA@mail.gmail.com>
Subject: Re: [PATCH] ovl: set lower layer st_dev only if setting lower st_ino
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Apr 11, 2018 at 8:09 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> For broken hardlinks, we do not return lower st_ino, so we should
> also not return lower pseudo st_dev.
>
> Fixes: a0c5ad307ac0 ("ovl: relax same fs constraint for constant st_ino")
> Cc: <stable@vger.kernel.org> #v4.15
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/inode.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>
> Miklos,
>
> This fixes a very obvious (to me) bug.
>
> I have a WIP unionmount-testsuite check for this.
> Will sort it out and push it to my tree later.
>
> Also pushed ovl-xino branch rebased on this bug fix.
>

OOPS, just saw that ovl-xino is already in overlayfs-next,
I can rebase the fix and re-send tomorrow.

Thanks,
Amir.
