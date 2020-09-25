Return-Path: <SRS0=6QjP=DC=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6E20C4363D
	for <linux-unionfs@archiver.kernel.org>; Fri, 25 Sep 2020 16:43:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 935232075F
	for <linux-unionfs@archiver.kernel.org>; Fri, 25 Sep 2020 16:43:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oycXR9qG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbgIYQnD (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 25 Sep 2020 12:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727324AbgIYQnD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 25 Sep 2020 12:43:03 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072A1C0613CE;
        Fri, 25 Sep 2020 09:43:03 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id z13so3441913iom.8;
        Fri, 25 Sep 2020 09:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pMJSBGncr9k8+i5yr4/WJpZH3QmmiD+UwEsuN6RTtI0=;
        b=oycXR9qGnnYyNd2ph2xmGb9rTEZzdhlwRyH36Mb+SPJ8kZ63wrxcMg5AajYL3b041W
         BfkPCBdpeMd78WIhhATPNfy9W0FxohBjieWXMfm60DhqdB/rO2dV0t76M96Lj3zuy9Zd
         jiZRB/5j5l5JoOtdNXLCMSF0fMmxUnCZiAgUyWy+/EhjXQX6AXnQnb4fiNDiPeuYzUDi
         bK/vQd4WKKo2b0O25G0iUqdGMTkE7R/NRoGp11wo0gxMaMPFbXBMMhdWzwDTJhguTK9l
         gKUWoV8ued8nFhdXjJWqzhTsfCuAyfK1AqM6OlPcsD/x/0Q7UopHLNvJ1YUXTY8wLWBm
         KYvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pMJSBGncr9k8+i5yr4/WJpZH3QmmiD+UwEsuN6RTtI0=;
        b=XWtxr88/BdPO1RnSAFuqxa7XjTrNagL05GFK0doR5mVeveqKcMzdE/ypnPOHiM1stV
         /+fUqgruNVjlZctMFfdIJnFrKmVJKBKPPWApcCd701EhUnNqin87fbKLWcFhhGHxtZ1W
         tEuW55Afbj69/egyPApFZYyLhOF/14PrvipkzrACdUiwHLMmb/AjzYDaln2Id/pWPId6
         9NJQZcSHb88GrWGiJL1tIIO6HsKNcLgor3tOTo58yvRB8RC/+MGrYd496vEYbd0ZsYjp
         MrbsSVRGFJx5nbICp7BUOir66P6+UUMnL6CJdc+oZkHOkUAjJIYVwvGcqcmS0E7bGtMd
         SzWA==
X-Gm-Message-State: AOAM532GILENXxF3/gNUKz9cqyO5WQH/6IzTAPPqxJbvfbqlDIHwEEJj
        6GiydA2s9vWdu+DpeyTDaoCfSrhGBxhMODEjcWYs0dacT8w=
X-Google-Smtp-Source: ABdhPJy/l3coWToI1447uhcRxjzlPar6YPUdUv9u9WzmGqwBuilO0fs3UQqjebtyPKWOIDM5nI6QB/HoXbEhEd8HomA=
X-Received: by 2002:a05:6602:2e81:: with SMTP id m1mr917217iow.64.1601052181955;
 Fri, 25 Sep 2020 09:43:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200925083507.13603-1-ptikhomirov@virtuozzo.com> <20200925083507.13603-3-ptikhomirov@virtuozzo.com>
In-Reply-To: <20200925083507.13603-3-ptikhomirov@virtuozzo.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 25 Sep 2020 19:42:51 +0300
Message-ID: <CAOQ4uxgxw7hZysDPfkrE9=Rc8-iK3=3SMX+RQJqgaARFRb_rNA@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] ovl: introduce new "uuid=off" option for inodes
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

On Fri, Sep 25, 2020 at 11:35 AM Pavel Tikhomirov
<ptikhomirov@virtuozzo.com> wrote:
>
> This replaces uuid with null in overelayfs file handles and thus relaxes

typo: overelayfs

> uuid checks for overlay index feature. It is only possible in case there
> is only one filesystem for all the work/upper/lower directories and bare
> file handles from this backing filesystem are uniq. In other case when
> we have multiple filesystems lets just fallback to "uuid=on" which is
> and equivalent of how it worked before with all uuid checks.
>

typo: uniq

> This is needed when overlayfs is/was mounted in a container with index
> enabled (e.g.: to be able to resolve inotify watch file handles on it to
> paths in CRIU), and this container is copied and started alongside with
> the original one. This way the "copy" container can't have the same uuid
> on the superblock and mounting the overlayfs from it later would fail.
>
> Note: In our (Virtuozzo) use case users inside a container can create
> "regular" overlayfs mounts without any "index=" option, but we still
> want to migrate this containers with CRIU so we set "index=on" as kernel

this container

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

typos: crat, uniq

> container.
>
> CC: Amir Goldstein <amir73il@gmail.com>
> CC: Vivek Goyal <vgoyal@redhat.com>
> CC: Miklos Szeredi <miklos@szeredi.hu>
> CC: linux-unionfs@vger.kernel.org
> CC: linux-kernel@vger.kernel.org
> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
>

Apart from some typos, looks good to me.

You may add:
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Please do not post v5. you should wait for more feedback from others.

> ---
> v2: in v1 I missed actual uuid check skip
> v3: rebase to overlayfs-next, replace uuid with null in file handles,
> split ovl_fs propagation to function arguments to separate patch, add
> separate bool "uuid=on/off" option, move numfs check up, add doc note.
> v4: get rid of double negatives, remove nouuid leftower comment, fix
> missprint in kernel config name
>
>  Documentation/filesystems/overlayfs.rst |  6 ++++++
>  fs/overlayfs/Kconfig                    | 19 +++++++++++++++++++
>  fs/overlayfs/copy_up.c                  |  3 ++-
>  fs/overlayfs/namei.c                    |  4 +++-
>  fs/overlayfs/ovl_entry.h                |  1 +
>  fs/overlayfs/super.c                    | 25 +++++++++++++++++++++++++
>  6 files changed, 56 insertions(+), 2 deletions(-)
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
> index dd188c7996b3..c21abdb43206 100644
> --- a/fs/overlayfs/Kconfig
> +++ b/fs/overlayfs/Kconfig
> @@ -61,6 +61,25 @@ config OVERLAY_FS_INDEX
>
>           If unsure, say N.
>
> +config OVERLAY_FS_INDEX_UUID
> +       bool "Overlayfs: export uuid in file handles"
> +       default y
> +       depends on OVERLAY_FS
> +       help
> +         If this config option is disabled then overlay will replace uuid with
> +         null in overlayfs file handles, effectively disabling uuid checks for
> +         them. This affects overlayfs mounted with "index=on". This only can be
> +         done if all upper and lower directories are on the same filesystem
> +         where basic fhandles are uniq. In case the latter is not true

There are some typos in it, but I think this phrase can be dropped:
"where basic fhandles are uniq"

Thanks,
Amir.
