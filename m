Return-Path: <SRS0=fTQB=DU=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF5E7C433E7
	for <linux-unionfs@archiver.kernel.org>; Tue, 13 Oct 2020 16:23:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C4F625272
	for <linux-unionfs@archiver.kernel.org>; Tue, 13 Oct 2020 16:23:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fa1CgfE6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389562AbgJMQXu (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 13 Oct 2020 12:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389406AbgJMQXt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 13 Oct 2020 12:23:49 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C392BC0613D0;
        Tue, 13 Oct 2020 09:23:49 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id l16so457982ilt.13;
        Tue, 13 Oct 2020 09:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7bdiNuNZf6e/kH0/rK0q6XP8HUYnK/qJHShfyX9nTKA=;
        b=Fa1CgfE6jNd6AD8kRR04JHzhhvfcABxY4JV6S8TaZ8fy3857uxTpZHXt/U3L24P0tE
         jUxlfVrO8FIp8cN0pL5ZYZAHSJlPfTqTOnlEyyLArkDbtcs7WZmuQpBKnXGE9OeaxLcs
         mubpxJ1ApDlfD9GzFCD1sFfEqeRMsxp5xmiU6WInaOdQOwn0tNTQ9XiMnObcUXbbr4vw
         gJKruekf508MZwiRg4Ef9LbY5nkxgI3as120U6xPmN+FFTeOIfFT6zVRbyyD/5/1zRSE
         i6r+zIspfMPa3hrjktiC9LTxt9XnzZOSSFyCldyTQ3/ojyR0+faiTe00yqDJ9bILdM/F
         XksQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7bdiNuNZf6e/kH0/rK0q6XP8HUYnK/qJHShfyX9nTKA=;
        b=PMM/rNVNhO6RBFujp/zY6KSY/A917vTflGMC9trek/TjfPzbyJgX00dwo5x+g8XbU1
         v61BeWmbB4G5Fp3umc+NNJTgCYfb9ZXq+pUXwITFLQZZLpUsCvkWBq6HBA5ztEkStD43
         GA/N9eHKwKH4WsGZzRO184ZEbttdtsmVipBkyshzmo39zH/5a5xaJl8rzzgfTq6Qz/5S
         uDvruSmQQTQSo+PVc/9QuUx6/qvkQr/cnXVvrW/+5EIjaWIh49JXQtWmVZFYle21Ea51
         FCT6/ySABj5kUJQrDOWdqLup2jrue2M6Zc+MyWcRK8Qa/04o1jzS3h8xOtXFYh1vkpFk
         y0/g==
X-Gm-Message-State: AOAM5322oN79iQr2GbCeq5E8XOxwnGCdtRBVmUcYJJu1DIbUzpfEYYxg
        GdK7zh3gFie4tmJNRvRTTDmv8JEuxxKDR/k65Gk=
X-Google-Smtp-Source: ABdhPJxfx1b0eOqpFyyjQR/sdV23O5YW5Na6YioAI8N74dY9UqcLB8/OpKWT9xRS0rGWcj0cAP5JBKyiBGrz/eOKhZ8=
X-Received: by 2002:a92:6403:: with SMTP id y3mr639045ilb.72.1602606228943;
 Tue, 13 Oct 2020 09:23:48 -0700 (PDT)
MIME-Version: 1.0
References: <20201013145954.4274-1-ptikhomirov@virtuozzo.com> <20201013145954.4274-3-ptikhomirov@virtuozzo.com>
In-Reply-To: <20201013145954.4274-3-ptikhomirov@virtuozzo.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 13 Oct 2020 19:23:37 +0300
Message-ID: <CAOQ4uxiyzJPYCj8NT93aVzZNsM4++6b-uK0DOKt2gRxA4MY_fg@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] ovl: introduce new "uuid=off" option for inodes
 index feature
To:     Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Oct 13, 2020 at 6:00 PM Pavel Tikhomirov
<ptikhomirov@virtuozzo.com> wrote:
>
> This replaces uuid with null in overlayfs file handles and thus relaxes
> uuid checks for overlay index feature. It is only possible in case there
> is only one filesystem for all the work/upper/lower directories and bare
> file handles from this backing filesystem are unique. In other case when
> we have multiple filesystems lets just fallback to "uuid=on" which is
> and equivalent of how it worked before with all uuid checks.
>
> This is needed when overlayfs is/was mounted in a container with index
> enabled (e.g.: to be able to resolve inotify watch file handles on it to
> paths in CRIU), and this container is copied and started alongside with
> the original one. This way the "copy" container can't have the same uuid
> on the superblock and mounting the overlayfs from it later would fail.
>
> That is an example of the problem on top of loop+ext4:
>
> dd if=/dev/zero of=loopbackfile.img bs=100M count=10
> losetup -fP loopbackfile.img
> losetup -a
>   #/dev/loop0: [64768]:35 (/loop-test/loopbackfile.img)
> mkfs.ext4 loopbackfile.img
> mkdir loop-mp
> mount -o loop /dev/loop0 loop-mp
> mkdir loop-mp/{lower,upper,work,merged}
> mount -t overlay overlay -oindex=on,lowerdir=loop-mp/lower,\
> upperdir=loop-mp/upper,workdir=loop-mp/work loop-mp/merged
> umount loop-mp/merged
> umount loop-mp
> e2fsck -f /dev/loop0
> tune2fs -U random /dev/loop0
>
> mount -o loop /dev/loop0 loop-mp
> mount -t overlay overlay -oindex=on,lowerdir=loop-mp/lower,\
> upperdir=loop-mp/upper,workdir=loop-mp/work loop-mp/merged
>   #mount: /loop-test/loop-mp/merged:
>   #mount(2) system call failed: Stale file handle.
>
> If you just change the uuid of the backing filesystem, overlay is not
> mounting any more. In Virtuozzo we copy container disks (ploops) when
> create the copy of container and we require fs uuid to be unique for a new
> container.
>
> CC: Amir Goldstein <amir73il@gmail.com>
> CC: Vivek Goyal <vgoyal@redhat.com>
> CC: Miklos Szeredi <miklos@szeredi.hu>
> CC: linux-unionfs@vger.kernel.org
> CC: linux-kernel@vger.kernel.org
> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>


> ---
> v2: in v1 I missed actual uuid check skip
> v3: rebase to overlayfs-next, replace uuid with null in file handles,
> split ovl_fs propagation to function arguments to separate patch, add
> separate bool "uuid=on/off" option, move numfs check up, add doc note.
> v4: get rid of double negatives, remove nouuid leftower comment, fix
> misprint in kernel config name
> v5: fix typos; remove config option, module param, ovl_uuid_def and the
> corresponding notes
>
> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> ---
>  Documentation/filesystems/overlayfs.rst |  5 +++++
>  fs/overlayfs/copy_up.c                  |  3 ++-
>  fs/overlayfs/namei.c                    |  4 +++-
>  fs/overlayfs/ovl_entry.h                |  1 +
>  fs/overlayfs/super.c                    | 20 ++++++++++++++++++++
>  5 files changed, 31 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
> index 580ab9a0fe31..a3e588dc8437 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -563,6 +563,11 @@ This verification may cause significant overhead in some cases.
>  Note: the mount options index=off,nfs_export=on are conflicting for a
>  read-write mount and will result in an error.
>
> +Note: the mount option uuid=off can be used to replace UUID of the underlying
> +filesystem in file handles with null, and effectively disable UUID checks. This
> +can be useful in case the underlying disk is copied and the UUID of this copy
> +is changed. This is only applicable if all lower/upper/work directories are on
> +the same filesystem, otherwise it will fallback to normal behaviour.
>
>  Volatile mount
>  --------------
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 3380039036d6..0b7e7a90a435 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -320,7 +320,8 @@ struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs, struct dentry *real,
>         if (is_upper)
>                 fh->fb.flags |= OVL_FH_FLAG_PATH_UPPER;
>         fh->fb.len = sizeof(fh->fb) + buflen;
> -       fh->fb.uuid = *uuid;
> +       if (ofs->config.uuid)
> +               fh->fb.uuid = *uuid;
>
>         return fh;
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index f058bf8e8b87..f731eb4d35f9 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -159,8 +159,10 @@ struct dentry *ovl_decode_real_fh(struct ovl_fs *ofs, struct ovl_fh *fh,
>         /*
>          * Make sure that the stored uuid matches the uuid of the lower
>          * layer where file handle will be decoded.
> +        * In case of uuid=off option just make sure that stored uuid is null.
>          */
> -       if (!uuid_equal(&fh->fb.uuid, &mnt->mnt_sb->s_uuid))
> +       if (ofs->config.uuid ? !uuid_equal(&fh->fb.uuid, &mnt->mnt_sb->s_uuid) :
> +                             !uuid_is_null(&fh->fb.uuid))
>                 return NULL;
>
>         bytes = (fh->fb.len - offsetof(struct ovl_fb, fid));
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index 1b5a2094df8e..b7a73ea147b8 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -14,6 +14,7 @@ struct ovl_config {
>         bool redirect_follow;
>         const char *redirect_mode;
>         bool index;
> +       bool uuid;
>         bool nfs_export;
>         int xino;
>         bool metacopy;
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 290983bcfbb3..4717244e7d7a 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -356,6 +356,8 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
>                 seq_printf(m, ",redirect_dir=%s", ofs->config.redirect_mode);
>         if (ofs->config.index != ovl_index_def)
>                 seq_printf(m, ",index=%s", ofs->config.index ? "on" : "off");
> +       if (!ofs->config.uuid)
> +               seq_puts(m, ",uuid=off");
>         if (ofs->config.nfs_export != ovl_nfs_export_def)
>                 seq_printf(m, ",nfs_export=%s", ofs->config.nfs_export ?
>                                                 "on" : "off");
> @@ -410,6 +412,8 @@ enum {
>         OPT_REDIRECT_DIR,
>         OPT_INDEX_ON,
>         OPT_INDEX_OFF,
> +       OPT_UUID_ON,
> +       OPT_UUID_OFF,
>         OPT_NFS_EXPORT_ON,
>         OPT_NFS_EXPORT_OFF,
>         OPT_XINO_ON,
> @@ -429,6 +433,8 @@ static const match_table_t ovl_tokens = {
>         {OPT_REDIRECT_DIR,              "redirect_dir=%s"},
>         {OPT_INDEX_ON,                  "index=on"},
>         {OPT_INDEX_OFF,                 "index=off"},
> +       {OPT_UUID_ON,                   "uuid=on"},
> +       {OPT_UUID_OFF,                  "uuid=off"},
>         {OPT_NFS_EXPORT_ON,             "nfs_export=on"},
>         {OPT_NFS_EXPORT_OFF,            "nfs_export=off"},
>         {OPT_XINO_ON,                   "xino=on"},
> @@ -549,6 +555,14 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>                         index_opt = true;
>                         break;
>
> +               case OPT_UUID_ON:
> +                       config->uuid = true;
> +                       break;
> +
> +               case OPT_UUID_OFF:
> +                       config->uuid = false;
> +                       break;
> +
>                 case OPT_NFS_EXPORT_ON:
>                         config->nfs_export = true;
>                         nfs_export_opt = true;
> @@ -1877,6 +1891,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>         ofs->share_whiteout = true;
>
>         ofs->config.index = ovl_index_def;
> +       ofs->config.uuid = true;
>         ofs->config.nfs_export = ovl_nfs_export_def;
>         ofs->config.xino = ovl_xino_def();
>         ofs->config.metacopy = ovl_metacopy_def;
> @@ -1956,6 +1971,11 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>         if (!ovl_upper_mnt(ofs))
>                 sb->s_flags |= SB_RDONLY;
>
> +       if (!ofs->config.uuid && ofs->numfs > 1) {
> +               pr_warn("The uuid=off requires a single fs for lower and upper, falling back to uuid=on.\n");
> +               ofs->config.uuid = true;
> +       }
> +
>         if (!ovl_force_readonly(ofs) && ofs->config.index) {
>                 err = ovl_get_indexdir(sb, ofs, oe, &upperpath);
>                 if (err)
> --
> 2.26.2
>
