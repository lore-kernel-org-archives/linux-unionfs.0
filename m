From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 10/11] ovl: Introduce read/write barriers around metacopy
 flag update
Date: Wed, 18 Oct 2017 08:19:50 +0300
Message-ID: <CAOQ4uxipEM_yjVBYyL48OhUYs2qL6Cw+rA82+mTwRAoTS=Wk5w@mail.gmail.com>
References: <1508274358-17456-1-git-send-email-vgoyal@redhat.com> <1508274358-17456-11-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:55526 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964939AbdJRFTw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 18 Oct 2017 01:19:52 -0400
Received: by mail-qt0-f194.google.com with SMTP id v41so8345493qtv.12
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Oct 2017 22:19:51 -0700 (PDT)
In-Reply-To: <1508274358-17456-11-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Wed, Oct 18, 2017 at 12:05 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> If a file is copied up metadata only and later when same file is opened
> for WRITE, then data copy up takes place. We copy up data, remove METACOPY
> xattr and then clear the METACOPY flag from ovl_entry->flags. While all
> these operations happen with oi->lock held, read side of oi->flags is
> lockless. That is another thread on another cpu can check if METACOPY
> flag is clear or not.
>
> So this gives us an ordering requirement w.r.t METACOPY flag. That is, if
> another cpu sees METACOPY flag clear, then it should be guaranteed that
> effects of data copy up and remove xattr operations are also visible.
>
> For example.
>
>         CPU1                            CPU2
> ovl_copy_up_flags()                     acquire(oi->lock)
>  ovl_dentry_needs_data_copy_up()          ovl_copy_up_data()

The relevant lockless execution path of CPU1 is
ovl_d_real -> ovl_test_flag(OVL_METACOPY) ->  return real
when real is upper, upper needs to be with correct data

The execution path you describe here is going to test the flag
under overlay inode lock again in  ovl_copy_up_one() so it is irrelevant
to the barriers patch


>    ovl_test_flag(OVL_METACOPY)            vfs_removexattr()
>                                           ovl_clear_metacopy_flag()
>                                         release(oi->lock)
>
> Say CPU2 is copying up data and in the end clears metacopy flag. But if
> CPU1 perceives the effects of clearing of metacopy flag but not effects of
> preceeding operations, that would be a problem.
>
> Hence this patch introduces smp_wmb() on metacopy flag clear operation
> and smp_rmb() on metacopy flag test operation.
>
> May be some other lock or barrier is already covering it. But I am not sure
> what that is and is it obvious enough that we will not break it in future.
>
> So hence trying to be safe here and introducing barriers explicitly for
> metacopy bit.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/copy_up.c |  6 ++++++
>  fs/overlayfs/util.c    | 12 ++++++++++--
>  2 files changed, 16 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 99b7be4ff4fc..200ee3b7d397 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -466,6 +466,12 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
>         if (err)
>                 return err;
>
> +       /*
> +        * Pairs with smp_rmb() after test_bit(OVL_METACOPY). Make sure

This comment is meant to refer the reader to the code that this pairs with
i.e. pairs with smp_rmb() in ovl_d_real() ..

> +        * if OVL_METACOPY flag reset is visible, then all the write
> +        * operations before it are visible as well
> +        */
> +       smp_wmb();
>         ovl_clear_flag(OVL_METACOPY, d_inode(c->dentry));
>         return err;
>  }
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 91c542d1a39d..6bca9a960c6d 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -228,6 +228,8 @@ void ovl_dentry_set_upper_alias(struct dentry *dentry)
>  }
>
>  bool ovl_dentry_needs_data_copy_up(struct dentry *dentry, int flags) {
> +       bool metacopy;
> +
>         if (!S_ISREG(d_inode(dentry)->i_mode))
>                 return false;
>
> @@ -237,9 +239,15 @@ bool ovl_dentry_needs_data_copy_up(struct dentry *dentry, int flags) {
>         if (!(OPEN_FMODE(flags) & FMODE_WRITE))
>                 return false;
>
> -       if (!ovl_test_flag(OVL_METACOPY, d_inode(dentry)))
> +       metacopy = ovl_test_flag(OVL_METACOPY, d_inode(dentry));
> +       /*
> +        * Pairs with smp_wmb() while clearing OVL_METACOPY. Make sure if

This comment is meant to refer the reader to the code that this pairs with
i.e. pairs with smp_wmb() in ovl_copy_up_meta_inode_data() ..

> +        * clearing of OVL_METACOPY is visible, then effects of writes
> +        * before that are visible too.
> +        */
> +       smp_rmb();

Please move this rmb to ovl_d_real() after re-testing flag,
which is the only place that matters for inode data access.

> +       if (!metacopy)
>                 return false;
> -
>         return true;
>  }
>
> --
> 2.13.5
>
