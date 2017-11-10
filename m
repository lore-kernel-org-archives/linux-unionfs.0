From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v6 11/15] ovl: Do not expose metacopy only upper dentry
Date: Fri, 10 Nov 2017 10:54:37 +0200
Message-ID: <CAOQ4uxhRmBVKP=3p4Pfny45sxJDHU-qGqAULphEGt1LmC2Av=A@mail.gmail.com>
References: <20171109205019.11409-1-vgoyal@redhat.com> <20171109205019.11409-12-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:52998 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751020AbdKJIyi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 10 Nov 2017 03:54:38 -0500
Received: by mail-yw0-f193.google.com with SMTP id w2so7573209ywa.9
        for <linux-unionfs@vger.kernel.org>; Fri, 10 Nov 2017 00:54:38 -0800 (PST)
In-Reply-To: <20171109205019.11409-12-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Nov 9, 2017 at 10:50 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> d_real() can make a upper metacopy dentry/inode visible to the vfs layer.
> This is something new and vfs layer does not know that this inode contains
> only metadata and not data. And this could break things.
>
> So to be safe, do not export metacopy only dentry/inode to vfs using d_real().
>
> If d_real() is called with flag D_REAL_UPPER, return upper dentry only if
> it has data (flag OVL_UPPERDATA is set).
>
> Similiarly, if d_real(inode=X) is called, a warning is emitted if returned
> dentry/inode does not have OVL_UPPERDATA set. This should not happen as
> we never made this metacopy inode visible to vfs so nobody should be calling
> overlayfs back with inode=metacopy_inode.
>
> I scanned the code and I don't think it breaks any of the existing code.
> There are two users of D_REAL_UPPER. may_write_real() and
> update_ovl_inode_times().
>
> may_write_real(), will get an NULL dentry if upper inode is metacopy only
> and it will return -EPERM. Effectively, we are disallowing modifications
> to metacopy only inode from this interface. Though there is opportunity
> to improve it. (Allow chattr on metacopy inodes).
>
> update_ovl_inode_times() gets inode mtime and ctime from real inode. It
> should not be broken for metacopy inode as well for following reasons.
>
> - For any metadata operations (setattr, acl etc), overlay always calls
>   ovl_copyattr() and updates ovl inode mtime and ctime. So there is no
>   need to update mtime and ctime int his case. Its already updated.
>
> - For metadata inode, mtime should be same as lower and not change. (data
>   can't be modified on metadata inode without copyup).
>
> - For file writes, ctime and mtime will be updated. But in that case
>   first data will be copied up and this will not be a metadata inode
>   anymore. And furthr call to d_real(D_REAL_UPPER) will return upper
>   inode and new mtime and ctime will be obtainable.
>
> So atime updates should work just fine for metacopy inodes.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/super.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 5cb19781763d..f1d7d38b747f 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -84,8 +84,14 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
>         struct dentry *real;
>         int err;
>
> -       if (flags & D_REAL_UPPER)
> -               return ovl_dentry_upper(dentry);
> +       if (flags & D_REAL_UPPER) {
> +               real = ovl_dentry_upper(dentry);
> +               if (!real)
> +                       return NULL;
> +               if (!ovl_has_upperdata(dentry))
> +                       return NULL;
> +               return real;
> +       }
>
>         if (!d_is_reg(dentry)) {
>                 if (!inode || inode == d_inode(dentry))
> @@ -109,7 +115,9 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
>
>                         if (unlikely(metacopy))
>                                 goto lower;
> -               }
> +               } else if (unlikely(metacopy))
> +                       goto bug;
> +


Now I see why you needed the boolean var.
IMO, this patch should be better squashed with patch 10
for dealing with all cases of d_real()
Maybe title should be:
ovl: Do not expose metacopy only upper dentry from d_real()

Because that is the only thing that this patch takes care of

Amir.
