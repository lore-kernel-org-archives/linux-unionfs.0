From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: support ltp/testcase/bin/inotify04 on overlayfs
Date: Thu, 21 Jul 2016 12:34:32 +0200
Message-ID: <CAJfpegsMQSOgXHzdHf1ptVY45-yYVFA5NK_+hC1kGxsYwCH=rQ@mail.gmail.com>
References: <1469096391-4247-1-git-send-email-zhangaihua1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33791 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbcGUKed (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 21 Jul 2016 06:34:33 -0400
Received: by mail-oi0-f68.google.com with SMTP id l9so7321379oih.0
        for <linux-unionfs@vger.kernel.org>; Thu, 21 Jul 2016 03:34:33 -0700 (PDT)
In-Reply-To: <1469096391-4247-1-git-send-email-zhangaihua1@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Zhang AiHua <zhangaihua1@huawei.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Thu, Jul 21, 2016 at 12:19 PM,  <zhangaihua1@huawei.com> wrote:
> From: Aihua Zhang <zhangaihua1@huawei.com>
>
> after patch:
> [root@localhost bin]# ./inotify04
> inotify04    1  TPASS  :  got event: wd=1 mask=400 cookie=0 len=0 name=""
> inotify04    2  TPASS  :  got event: wd=1 mask=8000 cookie=0 len=0 name=""
> inotify04    3  TPASS  :  got event: wd=2 mask=4 cookie=0 len=0 name=""
> inotify04    4  TPASS  :  got event: wd=2 mask=400 cookie=0 len=0 name=""
> inotify04    5  TPASS  :  got event: wd=2 mask=8000 cookie=0 len=0 name=""
>
> Signed-off-by: Aihua Zhang <zhangaihua1@huawei.com>
> ---
>  fs/dcache.c          |    8 ++++++--
>  fs/overlayfs/inode.c |    2 +-
>  include/linux/fs.h   |    1 +
>  3 files changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 7654509..0db095d 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -313,7 +313,9 @@ static void dentry_iput(struct dentry * dentry)
>                 hlist_del_init(&dentry->d_u.d_alias);
>                 spin_unlock(&dentry->d_lock);
>                 spin_unlock(&inode->i_lock);
> -               if (!inode->i_nlink)
> +               if ((!inode->i_nlink) ||
> +                       ((inode->i_flags & S_SPECIAL_OVL) &&
> +                       (1 == inode->i_nlink)))


No such horrible hackery is needed if overlay code would correctly
reset i_nlink on rmdir.

See a50128d4524a ("ovl: clear nlink on rmdir") in the overlayfs-next branch of

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git

Thanks,
Miklos
