From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: problem about lower symlink
Date: Mon, 28 Aug 2017 09:43:06 +0300
Message-ID: <CAOQ4uxi8iR9C4txRfU4RDqcE+gZBG5qZFh3ivQnnjZm_PmuSvQ@mail.gmail.com>
References: <baf5c3bc-f611-797e-7f98-691d4432b63e@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:37514 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdH1GnI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 28 Aug 2017 02:43:08 -0400
Received: by mail-yw0-f194.google.com with SMTP id s143so2837194ywg.4
        for <linux-unionfs@vger.kernel.org>; Sun, 27 Aug 2017 23:43:07 -0700 (PDT)
In-Reply-To: <baf5c3bc-f611-797e-7f98-691d4432b63e@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, miaoxie@huawei.com

On Mon, Aug 28, 2017 at 7:20 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> Hi all:
>
> I notice that if the lower dir have absolute path symlink to another lower file,
> the lower origin file will be modified if we do something to this symlink in merge
> layer, such as chown or chmod. It can be reproduced as these steps:
>
> $ mkdir lower upper worker merger
> $ touch lower/aa
> $ ln -s $(pwd)/lower/aa $(pwd)/lower/bb
> $ mount -t overlay -o lowerdir=lower,upperdir=upper,workdir=worker overlayfs merger
> $ ls -l merger/aa
>   -rw-r--r--. 1 root root  0 Aug 28 07:42 merger/aa
> $ chmod 777 merger/bb
> $ ls -l merger/aa
>   -rwxrwxrwx. 1 root root  0 Aug 28 07:42 merger/aa
>
>
> I have an idea to resolve this problem, we can do someting in ovl_get_link(). I.e. like that:
>
> static const char *ovl_get_link(struct dentry *dentry,
>                                 struct inode *inode,
>                                 struct delayed_call *done)
> {
>         const struct cred *old_cred;
>         const char *p;
>
>         if (!dentry)
>                 return ERR_PTR(-ECHILD);
>
>         old_cred = ovl_override_creds(dentry->d_sb);
>         p = vfs_get_link(ovl_dentry_real(dentry), done);
>         revert_creds(old_cred);
>
> +       if (*p == '/')
> +               return ovl_get_link_orig(ofs, p);
>
>         return p;
> }
>
> In ovl_get_link_orig(), we can deal with three cases:
> 1) Link origin belongs to the lower layer:
>    Find which lower layer it belongs to, then convert absolute path to relative
>    path and return. We also can save the relative path in a string to ovl_inode,
>    which can get directly next time;
> 2) Link origin belongs to the upper layer:
>    No problem, do nothing;
> 3) Link origin not handled by overlayfs:
>    Return ENOENT errno.
>
> What do you think? Please let me know if you have some suggestiones.
>

I don't think that is a problem that is unique to overlayfs or that it should be
fixed by overlayfs.

Is it not the same behavior you would get with bind mounts and even copying
a subdir with absolute links to another location? Basically, it the problem of
escaping a container/sandbox and overlayfs is a private case.

I believe the concern, which is just, but not unique to overlayfs is supposed to
be addressed by AT_NO_JUMPS and friends (https://lwn.net/Articles/723057/).
Not sure if a mount option to enforce AT_NO_JUMPS was being considered,
but if it was, maybe setting it by default on an overlayfs mount would
make sense.

Thanks,
Amir.
