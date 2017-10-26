From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 11/13] ovl: Introduce read/write barriers around metacopy
 flag update
Date: Thu, 26 Oct 2017 09:34:15 +0300
Message-ID: <CAOQ4uxio4ZESiJ35dAimnFW_YcdEpmRCPqMPDB5i2AWvRg2WOA@mail.gmail.com>
References: <1508958575-14086-1-git-send-email-vgoyal@redhat.com> <1508958575-14086-12-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:56272 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751463AbdJZGeQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Oct 2017 02:34:16 -0400
Received: by mail-yw0-f194.google.com with SMTP id t11so2033720ywg.12
        for <linux-unionfs@vger.kernel.org>; Wed, 25 Oct 2017 23:34:16 -0700 (PDT)
In-Reply-To: <1508958575-14086-12-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Wed, Oct 25, 2017 at 10:09 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> If a file is copied up metadata only and later when same file is opened
> for WRITE, then data copy up takes place. We copy up data, remove METACOPY
> xattr and then set the UPPERDATA flag in ovl_entry->flags. While all
> these operations happen with oi->lock held, read side of oi->flags is
> lockless. That is another thread on another cpu can check if UPPERDATA
> flag is set or not.
>
> So this gives us an ordering requirement w.r.t UPPERDATA flag. That is, if
> another cpu sees UPPERDATA flag set, then it should be guaranteed that
> effects of data copy up and remove xattr operations are also visible.
>
> For example.
>
>         CPU1                            CPU2
> ovl_copy_up_flags()                     acquire(oi->lock)
>  ovl_dentry_needs_data_copy_up()          ovl_copy_up_data()
>    ovl_test_flag(OVL_UPPERDATA)           vfs_removexattr()
>                                           ovl_set_flag(OVL_UPPERDATA)
>                                         release(oi->lock)
>
> Say CPU2 is copying up data and in the end sets UPPERDATA flag. But if
> CPU1 perceives the effects of setting UPPERDATA flag but not effects of
> preceeding operations, that would be a problem.

Why would that be a problem?
What can go wrong?
If you try to answer the question instead of referring to a vague "problem"
you will see that only the ovl_d_real() code path can be a problem and maybe
(I did not check) ovl_getattr. Please change your example above to ovl_d_real()
code path of CPU1

>
> Hence this patch introduces smp_wmb() on setting UPPERDATA flag operation
> and smp_rmb() on UPPERDATA flag test operation.
>
> May be some other lock or barrier is already covering it. But I am not sure
> what that is and is it obvious enough that we will not break it in future.
>
> So hence trying to be safe here and introducing barriers explicitly for
> UPPERDATA flag/bit.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/copy_up.c |  7 ++++++-
>  fs/overlayfs/super.c   | 13 ++++++++++---
>  fs/overlayfs/util.c    | 11 ++++++++++-
>  3 files changed, 26 insertions(+), 5 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index a6cda02..4876ae4 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -466,7 +466,12 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
>         err= vfs_removexattr(upperpath.dentry, OVL_XATTR_METACOPY);
>         if (err)
>                 return err;
> -
> +       /*
> +        * Pairs with smp_rmb() in ovl_dentry_needs_data_copy_up(). Make sure

Nope. only pairs with smp_rmpb() in ovl_d_real() (or in a new helper
you need to create)


> +        * if OVL_UPPERDATA flag is visible, then all the write operations
> +        * before it are visible as well.
> +        */
> +       smp_wmb();
>         ovl_set_flag(OVL_UPPERDATA, d_inode(c->dentry));
>         return err;
>  }
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 4cf1f98..e97dccb 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -102,9 +102,16 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
>                         if (err)
>                                 return ERR_PTR(err);
>
> -                       if (ovl_dentry_check_upperdata(dentry) &&
> -                           !ovl_test_flag(OVL_UPPERDATA, d_inode(dentry)))
> -                               goto lower;
> +                       if (ovl_dentry_check_upperdata(dentry)) {
> +                               if (!ovl_test_flag(OVL_UPPERDATA,
> +                                   d_inode(dentry)))
> +                                       goto lower;
> +                               /*
> +                                * Pairs with smp_wmb in
> +                                * ovl_copy_up_meta_inode_data()
> +                                */
> +                               smp_rmb();
> +                       }
>                 }
>                 return real;
>         }
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index ef720a9..d0f3bf7 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -238,6 +238,8 @@ bool ovl_dentry_check_upperdata(struct dentry *dentry) {
>  }
>
>  bool ovl_dentry_needs_data_copy_up(struct dentry *dentry, int flags) {
> +       bool upperdata;
> +
>         if (!ovl_dentry_check_upperdata(dentry))
>                 return false;
>
> @@ -250,7 +252,14 @@ bool ovl_dentry_needs_data_copy_up(struct dentry *dentry, int flags) {
>         if (!(OPEN_FMODE(flags) & FMODE_WRITE))
>                 return false;
>
> -       if (likely(ovl_test_flag(OVL_UPPERDATA, d_inode(dentry))))
> +       upperdata = ovl_test_flag(OVL_UPPERDATA, d_inode(dentry));
> +       /*
> +        * Pairs with smp_wmb() in ovl_copy_up_meta_inode_data(). Make sure
> +        * if setting of OVL_UPPERDATA is visible, then effects of writes
> +        * before that are visible too.
> +        */
> +       smp_rmb();
> +       if (upperdata)

Nope. smp_rmb() is not needed here, because most of the places that
use this helper
will take a lock and call it again under lock.
You may need an explicit smp_rmb() also in getattr() though, so you
can create a new
helper that does exactly what the hunk in ovl_d_real does and reuse
the helper in ovl_getattr

>                 return false;
>
>         return true;
> --
> 2.5.5
>
