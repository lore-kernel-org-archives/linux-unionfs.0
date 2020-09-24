Return-Path: <SRS0=188/=DB=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A549EC4363D
	for <linux-unionfs@archiver.kernel.org>; Thu, 24 Sep 2020 17:02:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 620C62220C
	for <linux-unionfs@archiver.kernel.org>; Thu, 24 Sep 2020 17:02:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bpf6q/I+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbgIXRCT (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 13:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbgIXRCS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 24 Sep 2020 13:02:18 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9639FC0613CE;
        Thu, 24 Sep 2020 10:02:18 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id q4so4117103iop.5;
        Thu, 24 Sep 2020 10:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ofdwDvOykl3hkR9d/1Lt354PZIuNILnSHIZ0weGFi4U=;
        b=bpf6q/I+rdHSE2acVxQdPCeEVTQjcpT0fUH7wMjI8p1kG5SeyXGsqZnh+QHVTDWAHH
         kKradL1/HcfVT76uT8Zpzoto8b9dcbbkx5jjY63axKxUXC1bevKnj6WLZKZLmeYxExRq
         VgBWViiDwU8oV37Mnjp3oesDhdPfSwW+ulw03dUb2MrVHnRgKl2+ggUPqIWWdpeH3nGD
         SLRXhzAn4pbmumxnraABsm+UUV08o96rGdkVbVwg7xjAbSa4AQ4QZx/6Blo6J2q6/yl2
         WaK07KaOC6EkPU1B1fLbQGJn1re7zoHHcVIZITqQXo4kmbOnUQw83D9YoczdaoRCMchc
         yb4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ofdwDvOykl3hkR9d/1Lt354PZIuNILnSHIZ0weGFi4U=;
        b=E+ycY4EUKKNOHi6xzVF1sEZmzz5S/Ga3rf8z/5hp5jnzbrBnmwrrKwyGwelfxixaje
         FCfTyJy6jkpzqdQQTxUWtISka6GjQopaUF73S3529ZTT+qQqWpySWzdn066zurf6xd5s
         PQlAK/HUuDG2tkdOUrKWiFGpSyyDFdAEVviM4bLqu4rQN9ucvbfebq0RbRSW2S3DRyxL
         m7SK5rbY/nGvIxbVMFp93UlT6HKKaG6XU97mpwffGuPunuiS4Lf/js3QPu8PDMVxUeev
         k4a0Og6/BW9TrThZaWoStA7bZHiqWwoWi45HJVMRS1tQklH3GANjdLNnc4zNkW/8oxIq
         fNqQ==
X-Gm-Message-State: AOAM533USYA5m7Sot+jGdq80BavmcmqOAOClsQpdCV2zOkYba37CWN4U
        skhtBHxTSlwsMh6DAe+Yxg0Mnq2aYBu6CTYQj0E=
X-Google-Smtp-Source: ABdhPJxcSD6Q8spGdTsTBSsyKAlvKluyOJ6S4Y+Ra+B2CmWkyyjFM9Dmo6E8Rn7o6nPJnbMmTkHhDG6AAeMif55qmD8=
X-Received: by 2002:a6b:5a0d:: with SMTP id o13mr121779iob.186.1600966937840;
 Thu, 24 Sep 2020 10:02:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200924163755.7717-1-ptikhomirov@virtuozzo.com> <20200924163755.7717-3-ptikhomirov@virtuozzo.com>
In-Reply-To: <20200924163755.7717-3-ptikhomirov@virtuozzo.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 24 Sep 2020 20:02:06 +0300
Message-ID: <CAOQ4uxgb9+_=YhVe0bcO+W-vy3k2X2=nw1YHJOq27SjA33VDYg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] ovl: introduce new "uuid=off" option for inodes
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

On Thu, Sep 24, 2020 at 7:38 PM Pavel Tikhomirov
<ptikhomirov@virtuozzo.com> wrote:
>
> This replaces uuid with null in overelayfs file handles and thus relaxes
> uuid checks for overlay index feature. It is only possible in case there
> is only one filesystem for all the work/upper/lower directories and bare
> file handles from this backing filesystem are uniq. In other case when
> we have multiple filesystems lets just fallback to "uuid=on" which is
> and equivalent of how it worked before with all uuid checks.
>
> This is needed when overlayfs is/was mounted in a container with index
> enabled (e.g.: to be able to resolve inotify watch file handles on it to
> paths in CRIU), and this container is copied and started alongside with
> the original one. This way the "copy" container can't have the same uuid
> on the superblock and mounting the overlayfs from it later would fail.
>
> Note: In our (Virtuozzo) use case users inside a container can create
> "regular" overlayfs mounts without any "index=" option, but we still
> want to migrate this containers with CRIU so we set "index=on" as kernel
> default so that all the container overlayfs mounts get support of file
> handles automatically. With "uuid=off" we want the same thing (to be
> able to "copy" container with uuid change) - we would set kernel default
> so that all the container overlayfs mounts get "uuid=off" automatically.
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
> crate the copy of container and we require fs uuid to be uniq for a new
> container.
>
> v2: in v1 I missed actual uuid check skip
> v3: rebase to overlayfs-next, replace uuid with null in file handles,
> split ovl_fs propagation to function arguments to separate patch, add
> separate bool "uuid=on/off" option, move numfs check up, add doc note.

change log does not belong in commit message.
Move after --- please.

>
> CC: Amir Goldstein <amir73il@gmail.com>
> CC: Vivek Goyal <vgoyal@redhat.com>
> CC: Miklos Szeredi <miklos@szeredi.hu>
> CC: linux-unionfs@vger.kernel.org
> CC: linux-kernel@vger.kernel.org
> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> ---
>  Documentation/filesystems/overlayfs.rst |  6 ++++++
>  fs/overlayfs/Kconfig                    | 17 +++++++++++++++++
>  fs/overlayfs/copy_up.c                  |  3 ++-
>  fs/overlayfs/namei.c                    |  5 ++++-
>  fs/overlayfs/ovl_entry.h                |  1 +
>  fs/overlayfs/super.c                    | 25 +++++++++++++++++++++++++
>  6 files changed, 55 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
> index 580ab9a0fe31..4f9cc20f255c 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -563,6 +563,12 @@ This verification may cause significant overhead in some cases.
>  Note: the mount options index=off,nfs_export=on are conflicting for a
>  read-write mount and will result in an error.
>
> +Note: the mount option uuid=off (or corresponding module param, or kernel
> +config) can be used to replace UUID of the underlying filesystem in file
> +handles with null, and effectively disable UUID checks. This can be useful in
> +case the underlying disk is copied and the UUID of this copy is changed. This
> +is only applicable if all lower/upper/work directories are on the same
> +filesystem, otherwise it will fallback to normal behaviour.
>
>  Volatile mount
>  --------------
> diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
> index dd188c7996b3..888c6e5e71ee 100644
> --- a/fs/overlayfs/Kconfig
> +++ b/fs/overlayfs/Kconfig
> @@ -61,6 +61,23 @@ config OVERLAY_FS_INDEX
>
>           If unsure, say N.
>
> +config OVERLAY_FS_INDEX_UUID_OFF

Please get rid of all the double negatives.
config/param uuid_off should be uuid and default to Y.
Otherwise this looks fine to me.

> +       bool "Overlayfs: export null uuid in file handles"
> +       depends on OVERLAY_FS
> +       help
> +         If this config option is enabled then overlay will replace uuid with
> +         null in overlayfs file handles, effectively disabling uuid checks for
> +         them. This affects overlayfs mounted with "index=on". This only can be
> +         done if all upper and lower directories are on the same filesystem
> +         where basic fhandles are uniq. In case the latter is not true
> +         overlayfs would fallback to normal uuid checking mode.
> +
> +         It is needed to overcome possible change of uuid on superblock of the
> +         backing filesystem, e.g. when you copied the virtual disk and mount
> +         both the copy of the disk and the original one at the same time.
> +
> +         If unsure, say N.
> +
>  config OVERLAY_FS_NFS_EXPORT
>         bool "Overlayfs: turn on NFS export feature by default"
>         depends on OVERLAY_FS
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
> index f058bf8e8b87..0262c39886d0 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -159,8 +159,11 @@ struct dentry *ovl_decode_real_fh(struct ovl_fs *ofs, struct ovl_fh *fh,
>         /*
>          * Make sure that the stored uuid matches the uuid of the lower
>          * layer where file handle will be decoded.
> +        * In case of index=nouuid option just make sure that stored

leftover index=nouuid

Thanks,
Amir.
