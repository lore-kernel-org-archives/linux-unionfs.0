From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] overlayfs: include linux/pagemap.h for PAGE_CACHE_SIZE
Date: Thu, 10 Dec 2015 16:26:56 +0100
Message-ID: <CAJfpegvCg+YoS-nV2h4=ydiaGLAtB4g-KwD_bKSCnbts-EScwg@mail.gmail.com>
References: <7380785.3TF39KbbER@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35409 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755AbbLJP05 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 10 Dec 2015 10:26:57 -0500
Received: by obc18 with SMTP id 18so60413490obc.2
        for <linux-unionfs@vger.kernel.org>; Thu, 10 Dec 2015 07:26:56 -0800 (PST)
In-Reply-To: <7380785.3TF39KbbER@wuerfel>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org

On Thu, Dec 10, 2015 at 4:10 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> The overlayfs has started enforcing a maximum file size, but is missing
> the header file that defines the PAGE_CACHE_SIZE constant in some
> configurations.

Hmm, it uses MAX_LFS_FILESIZE.  MAX_LFS_FILESIZE is defined in
<linux/fs.h>, which doesn't include <linux/pagemap.h>.

<linux/pagemap.h> includes <linux/fs.h> however.  So shouldn't
MAX_LFS_FILESIZE be defined in <linux/pagemap.h> instead?

Thanks,
Miklos


>
> fs/overlayfs/super.c: In function 'ovl_fill_super':
> fs/overlayfs/super.c:939:29: error: 'PAGE_CACHE_SIZE' undeclared (first use in this function)
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 7b1746cac878 ("ovl: setattr: check permissions before copy-up")
> Cc: <stable@vger.kernel.org>
> ---
> The patch that introduced this was marked for stable, so I'm marking this
> the same way.
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index ea94e50a3473..a4cbdf9824c7 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -9,6 +9,7 @@
>
>  #include <linux/fs.h>
>  #include <linux/namei.h>
> +#include <linux/pagemap.h>
>  #include <linux/xattr.h>
>  #include <linux/security.h>
>  #include <linux/mount.h>
>
