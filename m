From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v6 14/15] ovl: Introduce read/write barriers around
 metacopy flag update
Date: Fri, 10 Nov 2017 11:43:36 +0200
Message-ID: <CAOQ4uxhBvnFkma6qy=Be4uLDi-6aJmsgmpKGQ=XTJr8kXS0fmQ@mail.gmail.com>
References: <20171109205019.11409-1-vgoyal@redhat.com> <20171109205019.11409-15-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:50937 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751888AbdKJJni (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 10 Nov 2017 04:43:38 -0500
Received: by mail-yw0-f196.google.com with SMTP id i198so7664173ywe.7
        for <linux-unionfs@vger.kernel.org>; Fri, 10 Nov 2017 01:43:37 -0800 (PST)
In-Reply-To: <20171109205019.11409-15-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Nov 9, 2017 at 10:50 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
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
> ovl_d_real()                            acquire(oi->lock)
>   ovl_copy_up_flags()                    ovl_copy_up_data()
>    ovl_dentry_needs_data_copy_up()       vfs_removexattr()
>      ovl_test_flag(OVL_UPPERDATA)        ovl_set_flag(OVK_UPPERDATA)
>                                         release(oi->lock)

typo OVK_UPPERDATA

CPU1:
 ovl_d_real()
  ovl_open_maybe_copy_up()
    ovl_open_need_copy_up()
      ovl_dentry_needs_data_copy_up()
        ovl_test_flag(OVL_UPPERDATA)

That's the execution path I meant you should specify, the execution path
that could expose incomplete upper to vfs from d_real().

>
> Say CPU2 is copying up data and in the end sets UPPERDATA flag. But if
> CPU1 perceives the effects of setting UPPERDATA flag but not effects of
> preceeding operations, that would be a problem.
>

Instead of "that would be a problem", you can say that upper that is
not fully copied
up is exposed to vfs.

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
>  fs/overlayfs/util.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index f70eea77c5c7..81b307c20a8d 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -267,13 +267,26 @@ bool ovl_has_upperdata(struct dentry *dentry) {
>         if (!ovl_should_check_upperdata(dentry))
>                 return true;
>
> -       return ovl_test_flag(OVL_UPPERDATA, d_inode(dentry));
> +       if (!ovl_test_flag(OVL_UPPERDATA, d_inode(dentry)))
> +               return false;
> +       /*
> +        * Pairs with smp_wmb() in ovl_copy_up_meta_inode_data(). Make sure
> +        * if setting of OVL_UPPERDATA is visible, then effects of writes
> +        * before that are visible too.
> +        */
> +       smp_rmb();
> +       return true;
>  }
>

I think it is not right to have smp_rmb() is the locked path where it
is not needed
too costly.

We should probably have a different variant for ovl_already_copied_up_locked()
and if OVL_UPPERDATA is set for all non-eligible cases, ovl_has_upperdata()
can have the smp_rmb() and locked variant can just can check the flag directly.

Amir.
