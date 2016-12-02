From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATCH] vfs: lockdep annotate of stacked inode_lock()
Date: Fri, 2 Dec 2016 22:25:34 +0200
Message-ID: <CAOQ4uxhzwcKnsu3XgFXr6fU0mOafLAmc7vjGUcmhag4qCD=09g@mail.gmail.com>
References: <1480628891-15937-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wj0-f195.google.com ([209.85.210.195]:36305 "EHLO
        mail-wj0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751301AbcLBUZh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 2 Dec 2016 15:25:37 -0500
In-Reply-To: <1480628891-15937-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>, Quentin Casasnovas <quentin.casasnovas@oracle.com>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Dec 1, 2016 at 11:48 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> An overlayfs instance can be the lower layer of another stacked
> overlayfs instance.
>
> This setup triggers a lockdep splat of possible recursive locking
> of sb->s_type->i_mutex_key in iterate_dir().
>
> Fix this by annotating stackable inode_lock() according to stack
> level of the super block instance.
>
> Stackable fs inode_lock() is annotated at lockdep_class level,
> so it is independent of the inner fs I_MUTEX subclass annotations.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/inode.c         | 10 ++++++----
>  include/linux/fs.h | 14 ++++++++++++--
>  2 files changed, 18 insertions(+), 6 deletions(-)
>
> diff --git a/fs/inode.c b/fs/inode.c
> index 88110fd..f46b267 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -169,7 +169,8 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
>         lockdep_set_class(&inode->i_lock, &sb->s_type->i_lock_key);
>
>         init_rwsem(&inode->i_rwsem);
> -       lockdep_set_class(&inode->i_rwsem, &sb->s_type->i_mutex_key);
> +       lockdep_set_class(&inode->i_rwsem,
> +                         &sb->s_type->i_mutex_key[FS_STACK_NESTING(sb)]);
>

NACK to self. This new annotated lock name looks ugly in lockdep stats.
I'll move the annotation for the special nested case into the file system

Amir.
