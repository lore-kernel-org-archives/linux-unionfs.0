From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v5 1/4] ovl: move include of ovl_entry.h into overlayfs.h
Date: Tue, 31 Oct 2017 14:14:44 +0100
Message-ID: <CAJfpegupc9mb8AWYocnn-RB6zaemfSpCSHb+H4NDUxD=RtX-XA@mail.gmail.com>
References: <1509395247-15180-1-git-send-email-amir73il@gmail.com> <1509395247-15180-2-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:44490 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751608AbdJaNOp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 31 Oct 2017 09:14:45 -0400
Received: by mail-wr0-f195.google.com with SMTP id z55so15940164wrz.1
        for <linux-unionfs@vger.kernel.org>; Tue, 31 Oct 2017 06:14:45 -0700 (PDT)
In-Reply-To: <1509395247-15180-2-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, zhangyi <yi.zhang@huawei.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

Is this really necessary?

"ovl_entry.h" is supposed to be more of a low level thing, and I'm not
sure having that proliferate to all parts of the code is a good idea.

At least some justification would be good here.

Thanks,
Miklos

On Mon, Oct 30, 2017 at 9:27 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/copy_up.c   | 1 -
>  fs/overlayfs/inode.c     | 1 -
>  fs/overlayfs/namei.c     | 1 -
>  fs/overlayfs/overlayfs.h | 1 +
>  fs/overlayfs/super.c     | 1 -
>  fs/overlayfs/util.c      | 1 -
>  6 files changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index c441f9387a1b..9311d183b532 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -22,7 +22,6 @@
>  #include <linux/ratelimit.h>
>  #include <linux/exportfs.h>
>  #include "overlayfs.h"
> -#include "ovl_entry.h"
>
>  #define OVL_COPY_UP_CHUNK_SIZE (1 << 20)
>
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 03f0ec2b73eb..50e233ccca53 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -14,7 +14,6 @@
>  #include <linux/posix_acl.h>
>  #include <linux/ratelimit.h>
>  #include "overlayfs.h"
> -#include "ovl_entry.h"
>
>  int ovl_setattr(struct dentry *dentry, struct iattr *attr)
>  {
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 63200578ce5b..de2dac98e147 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -15,7 +15,6 @@
>  #include <linux/mount.h>
>  #include <linux/exportfs.h>
>  #include "overlayfs.h"
> -#include "ovl_entry.h"
>
>  struct ovl_lookup_data {
>         struct qstr name;
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 4fa30633780d..73ef1e850635 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -9,6 +9,7 @@
>
>  #include <linux/kernel.h>
>  #include <linux/uuid.h>
> +#include "ovl_entry.h"
>
>  enum ovl_path_type {
>         __OVL_PATH_UPPER        = (1 << 0),
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index f5738e96a052..8702803ba328 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -18,7 +18,6 @@
>  #include <linux/seq_file.h>
>  #include <linux/posix_acl_xattr.h>
>  #include "overlayfs.h"
> -#include "ovl_entry.h"
>
>  MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
>  MODULE_DESCRIPTION("Overlay filesystem");
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 51ca8bd16009..9158d17bb320 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -17,7 +17,6 @@
>  #include <linux/namei.h>
>  #include <linux/ratelimit.h>
>  #include "overlayfs.h"
> -#include "ovl_entry.h"
>
>  int ovl_want_write(struct dentry *dentry)
>  {
> --
> 2.7.4
>
