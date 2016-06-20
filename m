From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] fix error: a bin file can truncate itself while running
 at overlayfs.
Date: Mon, 20 Jun 2016 09:05:48 +0200
Message-ID: <CAJfpegtaCP4sN3Qa1=Y6UwNcNP=rets5UjFphXZ11zaZ=A0yTg@mail.gmail.com>
References: <1466391089-17404-1-git-send-email-zhangaihua1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ob0-f193.google.com ([209.85.214.193]:33505 "EHLO
	mail-ob0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbcFTHFt (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 20 Jun 2016 03:05:49 -0400
Received: by mail-ob0-f193.google.com with SMTP id f10so3140800obr.0
        for <linux-unionfs@vger.kernel.org>; Mon, 20 Jun 2016 00:05:48 -0700 (PDT)
In-Reply-To: <1466391089-17404-1-git-send-email-zhangaihua1@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: zhangaihua1@huawei.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Mon, Jun 20, 2016 at 4:51 AM,  <zhangaihua1@huawei.com> wrote:
> From: Aihua Zhang <zhangaihua1@huawei.com>
>
> I wrote a testcase to truncate a bin file while it is running at overlayfs.
> the result as below:
>
> Bus error (core dumped)

Thanks for the report.

Please tell us more information about how to trigger the bug:

 - how did you set up the overlay filesystem?
 - which test case from which test suite was this?

> I think it's not appropriate for filesystem, and fixed it by this patch.
> after the patch, result as below:
>
> status:-1
> errno:26
> ETXTBSY:26
> PASS
>
> This is because the inode is not correct ,it should point to overlayfs rather
> than the upper filesystem.

Changeing denty_write_access() without a similar change in
allow_write_access() is sure to buggy.

But even with that fixed, it's not clear to me why exactly this change
is needed.  More thought needs to be going into this.

Thanks,
Miklos



>
> Signed-off-by: Aihua Zhang <zhangaihua1@huawei.com>
> ---
>  include/linux/fs.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index dd28814..54fdbf9 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2589,7 +2589,7 @@ static inline int get_write_access(struct inode *inode)
>  }
>  static inline int deny_write_access(struct file *file)
>  {
> -       struct inode *inode = file_inode(file);
> +       struct inode *inode = d_inode(file->f_path.dentry);
>         return atomic_dec_unless_positive(&inode->i_writecount) ? 0 : -ETXTBSY;
>  }
>  static inline void put_write_access(struct inode * inode)
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
