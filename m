From: Andrey Melnikov <temnota.am@gmail.com>
Subject: Re: [PATCH] Fix overlayfs inotify interaction
Date: Wed, 13 Jul 2016 00:01:53 +0300
Message-ID: <CA+PODjrncMt=vPkFun5eMFH02AAnMh89rFpcyhiu4ne_r1fVVA@mail.gmail.com>
References: <20160630105956.GA9949@ppc.Dlink>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:32959 "EHLO
	mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbcGLVCH (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 12 Jul 2016 17:02:07 -0400
Received: by mail-lf0-f66.google.com with SMTP id f93so2186336lfi.0
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Jul 2016 14:02:00 -0700 (PDT)
In-Reply-To: <20160630105956.GA9949@ppc.Dlink>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org

Ping.

2016-06-30 14:04 GMT+03:00 Andrey Jr. Melnikov <temnota.am@gmail.com>:
>  Fix overlayfs inotify interaction - use d_real_inode() helper
>  to resolve real (underlying) inode. Without this inotify is not functional on
>  overlayfs.
>
> Signed-off-by: Andrey Jr. Melnikov <temnota.am@gmail.com>
>
> ---
> Runtime tested with inotifywait in monitor mode to confirm event generation.
>
> cd /tmp/ && mkdir dest upper lower work
> mount -t overlay none dest -o upperdir=upper/,lowerdir=lower/,workdir=work/
> while /bin/true; do echo test >>/tmp/dest/lower-data; sleep 5; done &
> inotifywait -m /tmp/dest/lower-data
>
>  fs/notify/inotify/inotify_user.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
> index b8d08d0..592ce16 100644
> --- a/fs/notify/inotify/inotify_user.c
> +++ b/fs/notify/inotify/inotify_user.c
> @@ -742,7 +742,7 @@ SYSCALL_DEFINE3(inotify_add_watch, int, fd, const char __user *, pathname,
>                 goto fput_and_out;
>
>         /* inode held in place by reference to path; group by fget on fd */
> -       inode = path.dentry->d_inode;
> +       inode = d_real_inode(path.dentry);
>         group = f.file->private_data;
>
>         /* create/update an inode mark */
> --
> 2.8.1
>
