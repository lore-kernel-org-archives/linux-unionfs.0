From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: Sync upper dirty data when sync overlayfs
Date: Tue, 28 Nov 2017 11:00:43 +0200
Message-ID: <CAOQ4uxgbM_bFkm_hymvn6U2i+NZQG2LAqpH8XtTsduVLJXdHDQ@mail.gmail.com>
References: <1511844026-12765-1-git-send-email-cgxu@mykernel.net>
 <CAOQ4uxiL8vdkcTSGnqGKtH1AVaZ+W0LcaTaoi6mifGjhq48Ljg@mail.gmail.com> <0DEF5E95-D6C6-4F2C-9710-C4DC8BB14691@mykernel.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:44496 "EHLO
        mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751601AbdK1JAp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Nov 2017 04:00:45 -0500
Received: by mail-yb0-f196.google.com with SMTP id x72so11703589ybg.11
        for <linux-unionfs@vger.kernel.org>; Tue, 28 Nov 2017 01:00:45 -0800 (PST)
In-Reply-To: <0DEF5E95-D6C6-4F2C-9710-C4DC8BB14691@mykernel.net>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: cgxu <cgxu@mykernel.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Suyue <suyue@meili-inc.com>

On Tue, Nov 28, 2017 at 10:18 AM, cgxu <cgxu@mykernel.net> wrote:
>
[...]
>> Unless I am missing something subtle here, you should export vfs
>> __sync_filesystem and call it from here instead of duplicating it.
>> Any technical reason not to do it?
>>
>
> Actually, not a technical reason. How about below modification?
> If it looks good I=E2=80=99ll send patch on new mail thread.
>

Much better. See one nit below.
Why new mail thread? It is better if you send V3 patch with same subject
and change log since V2, so maintainer knows this patch supersedes
the previous one.


>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index f5738e9..736f04d 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -231,6 +231,7 @@ static void ovl_put_super(struct super_block *sb)
>         kfree(ufs);
>  }
>
> +/* Sync real dirty inodes in upper filesystem (if it exists) */
>  static int ovl_sync_fs(struct super_block *sb, int wait)
>  {
>         struct ovl_fs *ufs =3D sb->s_fs_info;
> @@ -240,12 +241,9 @@ static int ovl_sync_fs(struct super_block *sb, int w=
ait)
>         if (!ufs->upper_mnt)
>                 return 0;
>         upper_sb =3D ufs->upper_mnt->mnt_sb;
> -       if (!upper_sb->s_op->sync_fs)
> -               return 0;
>
> -       /* real inodes have already been synced by sync_filesystem(ovl_sb=
) */
>         down_read(&upper_sb->s_umount);
> -       ret =3D upper_sb->s_op->sync_fs(upper_sb, wait);
> +       ret =3D __sync_filesystem(upper_sb, wait);
>         up_read(&upper_sb->s_umount);
>         return ret;
>  }
> diff --git a/fs/sync.c b/fs/sync.c
> index 83ac79a..76c913e 100644
> --- a/fs/sync.c
> +++ b/fs/sync.c
> @@ -28,7 +28,7 @@
>   * wait =3D=3D 1 case since in that case write_inode() functions do
>   * sync_dirty_buffer() and thus effectively write one block at a time.
>   */
> -static int __sync_filesystem(struct super_block *sb, int wait)
> +int __sync_filesystem(struct super_block *sb, int wait)
>  {
>         if (wait)
>                 sync_inodes_sb(sb);
> @@ -39,6 +39,7 @@ static int __sync_filesystem(struct super_block *sb, in=
t wait)
>                 sb->s_op->sync_fs(sb, wait);
>         return __sync_blockdev(sb->s_bdev, wait);
>  }
> +EXPORT_SYMBOL(__sync_filesystem);
>
>  /*
>   * Write out and wait upon all dirty data associated with this
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 885266a..ef03b18 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2464,6 +2464,7 @@ static inline bool sb_is_blkdev_sb(struct super_blo=
ck *sb)
>  }
>  #endif
>  extern int sync_filesystem(struct super_block *);
> +extern int __sync_filesystem(struct super_block *, int);
>  extern const struct file_operations def_blk_fops;
>  extern const struct file_operations def_chr_fops;

Nits:
1. __sync_filesystem comes before sync_filesystem in c file.
    Please keep same order in h file.
2. Please run checkpatch on your patch. it will complain on
    "function definition argument should also have an identifier name"
    please fix that and feel free to fix adjacent sync_filesystem()
    definition while at it

Thanks,
Amir.
