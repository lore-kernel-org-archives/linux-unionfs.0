From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 12/13] ovl: Do not export metacopy only upper dentry
Date: Thu, 26 Oct 2017 09:54:06 +0300
Message-ID: <CAOQ4uxjkOAkpuJ-X+XK3no6fcpp7OadWKQKH3bqGX1Ct_PAxfw@mail.gmail.com>
References: <1508958575-14086-1-git-send-email-vgoyal@redhat.com> <1508958575-14086-13-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:54393 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751507AbdJZGyH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Oct 2017 02:54:07 -0400
Received: by mail-yw0-f193.google.com with SMTP id w5so2066432ywg.11
        for <linux-unionfs@vger.kernel.org>; Wed, 25 Oct 2017 23:54:07 -0700 (PDT)
In-Reply-To: <1508958575-14086-13-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Wed, Oct 25, 2017 at 10:09 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
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
>  fs/overlayfs/super.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index e97dccb..dc8909a 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -80,8 +80,18 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
>         struct dentry *real;
>         int err;
>
> -       if (flags & D_REAL_UPPER)
> -               return ovl_dentry_upper(dentry);
> +       if (flags & D_REAL_UPPER) {
> +               real = ovl_dentry_upper(dentry);
> +               if (!real)
> +                       return NULL;


bool ovl_dentry_is_metacopy(dentry) {
> +               if (!ovl_dentry_check_upperdata(dentry))
> +                       return false;
> +               if (!ovl_test_flag(OVL_UPPERDATA, d_inode(dentry)))
> +                       return true;
> +               /* Pairs with smp_wmb() in ovl_copy_up_meta_inode_data() */
> +               smp_rmb();
                    return false;
}

to be used 2 times in ovl_d_real() and in ovl_getattr()


> +               return real;
> +       }
>
>         if (!d_is_reg(dentry)) {
>                 if (!inode || inode == d_inode(dentry))
> @@ -113,6 +123,9 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
>                                 smp_rmb();
>                         }
>                 }
> +
> +               WARN_ON(ovl_dentry_check_upperdata(dentry) &&
> +                       !ovl_test_flag((OVL_UPPERDATA), d_inode(dentry)));

Instead of checking flag twice, check it once above the if (!inode), e.g:

bool metacopy = ovl_dentry_is_metacopy(dentry);
if (!inode) {
        ...
        if (unlikely(metacopy))
                goto lower;
} else if (unlikely(metacopy))
        goto bug;
}

>                 return real;
>         }
>
> --
> 2.5.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
