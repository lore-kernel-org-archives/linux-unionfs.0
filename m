Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1728C433E9
	for <linux-unionfs@archiver.kernel.org>; Tue, 26 Jan 2021 19:19:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58BE722B2C
	for <linux-unionfs@archiver.kernel.org>; Tue, 26 Jan 2021 19:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbhAZFuj (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 00:50:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728816AbhAYNZF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 25 Jan 2021 08:25:05 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649BEC06174A;
        Mon, 25 Jan 2021 05:24:19 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id d13so26415254ioy.4;
        Mon, 25 Jan 2021 05:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IF2DD1ZxWyHOIZtsZXXfUNNTSD9rCA0LLoYW+nSXou8=;
        b=GRFOyzZqBwr6lGCZFb5qN71Wgu8SV7v1JoeF3t13VLl7rsRjurRSv48EY7imASATsy
         nFuNQcgnei1G4DeUwHi2PFPJHI2zIaV/M9XO6+sEYHgrDbcMeYELD5BCt5u9BcybFhjN
         9o9WAWW7P8o/qVShxOhcc/ZKjTpj7j4QDmY5DuRB8JPO9tgKMhOhsQ213kq6KXrmg1lq
         hytK4yAJX84bRft+SaInwmsZasGORbY3KlUBjQcGOWEDWAe7sVqymIt6oD7+uSEi3vbz
         1opGMv1lpDVpxxC0/jGq2vcAV6hYDvnjGMTuQ9HP45czKud86gpO/OsXVJFpQoBm+m4M
         Y1ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IF2DD1ZxWyHOIZtsZXXfUNNTSD9rCA0LLoYW+nSXou8=;
        b=WzVBeYehCbEbQ08onDrnk82fHVuWMpMPk75xHz1B/1dEXiswQ0BxkSTEUQz4YjQUxV
         NYokLCFhVMr6x7WwvYqMSJJWEt82vzLO1MVwTcTp0lqIyNYOAGZpnZWdDj1ZHKoQyIV8
         owT9yc5xFfWu2aFSw3p3m60NHeLaac2gBqv+Yt6s/gtwb0H4NTaJOuysMka2D9xLRlej
         7nZ0cmNN/Jmjgc4ssyL3q9TU7bkI16VhY/J5Z5zEpn6pTZ3/CHhLds9EOLT/paEOa1eA
         za/mf8RR/tIHaASMB4V/37yvSzzyApDwkvuWkVo2PCZCsiq6GFakCPuubjxmjbcsA2X9
         2ptQ==
X-Gm-Message-State: AOAM532HWOPs9wkWndVI0BEO8VFWfho2kMd5QKNuZ6wNLTabaJz4Ok7j
        qbmn4C+D/rUm+ldPio6KBAC5IkpWTtvjL0ToErwYtVI1PJY=
X-Google-Smtp-Source: ABdhPJwOfMyl1Q8n+N6ixGy4kiID8nwHepdiYAHsKiCMM+8kl8B33E2epbpvhDoDDTMSG/s1ih0QW8y90be7RjT+AtA=
X-Received: by 2002:a5e:dc04:: with SMTP id b4mr339135iok.203.1611581058686;
 Mon, 25 Jan 2021 05:24:18 -0800 (PST)
MIME-Version: 1.0
References: <20210116165619.494265-1-amir73il@gmail.com> <20210116165619.494265-5-amir73il@gmail.com>
In-Reply-To: <20210116165619.494265-5-amir73il@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 25 Jan 2021 15:24:07 +0200
Message-ID: <CAOQ4uxiXUN7LkzNLZto6iK2YuDdxp7PGoQMGCm89p1kNWUf=YA@mail.gmail.com>
Subject: Re: [PATCH 4/4] overlay: Test lost immutable/append-only flags on copy-up
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Icenowy Zheng <icenowy@aosc.io>,
        Chengguang Xu <cgxu519@mykernel.net>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Jan 16, 2021 at 6:56 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Chengguang Xu reported [1] that append-only flag is lost on copy-up.
> I had noticed that for directories, immutable flag can also be lost on
> copy up (when parent is copied up). That's an old overlayfs bug.
>
> Overlayfs added the ability to set inode flags (e.g. chattr +i) in
> kernel 5.10 by commit 61536bed2149 ("ovl: support [S|G]ETFLAGS and
> FS[S|G]ETXATTR ioctls for directories").
> Icenowy Zheng reported [2] a regression in that commit that causes
> a deadlock when setting inode flags on lower dir.
>
> There is a commented line in the test that triggers this deadlock,
> but it has been left commented out until a fix is merged upstream.
>

Re-iterate in correct thread:

The fix for above is in overlayfs-next:

* 147ec02b8705 - ovl: avoid deadlock on directory ioctl

But I wouldn't uncomment that line in the test just yet.

To be clear, this test does not pass in master and there is no clear
estimation on when the reported issues will be fixed.

Miklos,

Do you plan to followup on your VFS implementation for the
{s,g}etxflags methods?

Thanks,
Amir.

> [1] https://lore.kernel.org/linux-unionfs/20201226104618.239739-1-cgxu519@mykernel.net/
> [2] https://lore.kernel.org/linux-unionfs/20210101201230.768653-1-icenowy@aosc.io/
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  tests/overlay/075     | 97 +++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/075.out | 11 +++++
>  tests/overlay/group   |  1 +
>  3 files changed, 109 insertions(+)
>  create mode 100755 tests/overlay/075
>  create mode 100644 tests/overlay/075.out
>
> diff --git a/tests/overlay/075 b/tests/overlay/075
> new file mode 100755
> index 00000000..bcdc8d4e
> --- /dev/null
> +++ b/tests/overlay/075
> @@ -0,0 +1,97 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2021 CTERA Networks. All Rights Reserved.
> +#
> +# FS QA Test No. 075
> +#
> +# Run the t_immutable test program for immutable/append-only files
> +# and directories that exist in overlayfs lower layer.
> +#
> +# This test is similar and was derived from generic/079, but instead
> +# of creating new files which are created in upper layer, prepare
> +# the test area in lower layer before running the t_immutable test on
> +# the overlayfs mount.
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +timmutable=$here/src/t_immutable
> +lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
> +upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
> +tmp=/tmp/$$
> +status=1       # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +       # -r will fail to remove test dirs, because we added subdirs
> +       # we just need to remove the flags so use -R
> +       $timmutable -R $upperdir/testdir &> /dev/null
> +       $timmutable -R $lowerdir/testdir &> /dev/null
> +       rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +_supported_fs overlay
> +
> +_require_chattr iaA
> +_require_test_program "t_immutable"
> +_require_scratch
> +
> +_scratch_mkfs
> +
> +# Preparing test area files in lower dir and check chattr support of base fs
> +mkdir -p $lowerdir
> +mkdir -p $upperdir
> +$timmutable -C $lowerdir/testdir >$tmp.out 2>&1
> +if grep -q -e 'Operation not supported' -e "Inappropriate ioctl" $tmp.out; then
> +       _notrun "Setting immutable/append flag not supported"
> +fi
> +# Remove the immutable/append-only flags and create subdirs
> +$timmutable -R $lowerdir/testdir >$tmp.out 2>&1
> +for dir in $lowerdir/testdir/*.d; do
> +       mkdir $dir/subdir
> +done
> +# Restore the immutable/append-only flags
> +$timmutable -C $lowerdir/testdir >$tmp.out 2>&1
> +
> +_scratch_mount
> +
> +# Test immutability of files in overlay
> +echo "Before directories copy up"
> +$timmutable $SCRATCH_MNT/testdir 2>&1
> +
> +# Trigger copy-up of immutable/append-only dirs by touching their subdirs
> +# inode flags are not copied-up, so immutable/append-only flags are lost
> +for dir in $SCRATCH_MNT/testdir/*.d; do
> +       # chattr on dir fails (not supported) on kernel < 5.10.
> +       # chattr on lower dir will deadlock on kernel 5.10 with commit 61536bed2149
> +       # ("ovl: support [S|G]ETFLAGS and FS[S|G]ETXATTR ioctls for directories"),
> +       # so this line is commented out until a fix is merged
> +       # $CHATTR_PROG +A $dir/subdir > /dev/null 2>&1
> +       touch $dir/subdir
> +done
> +
> +# Trigger copy-up of append-only files by touching them
> +# inode flags are not copied-up, so append-only flags are lost
> +# touch on the immutable files is expected to fail, so immutable
> +# flags will not be lost
> +for file in $SCRATCH_MNT/testdir/*.f; do
> +       touch $file > /dev/null 2>&1
> +done
> +
> +# immutable/append-only flags still exist on the overlay in-core inode
> +# After mount cycle, flags are forever lost
> +_scratch_cycle_mount
> +
> +# Test immutability of files in overlay after directories copy-up
> +echo "After directories copy up"
> +$timmutable $SCRATCH_MNT/testdir 2>&1
> +
> +status=$?
> +exit
> diff --git a/tests/overlay/075.out b/tests/overlay/075.out
> new file mode 100644
> index 00000000..ab39c6b8
> --- /dev/null
> +++ b/tests/overlay/075.out
> @@ -0,0 +1,11 @@
> +QA output created by 075
> +Before directories copy up
> +testing immutable...PASS.
> +testing append-only...PASS.
> +testing immutable as non-root...PASS.
> +testing append-only as non-root...PASS.
> +After directories copy up
> +testing immutable...PASS.
> +testing append-only...PASS.
> +testing immutable as non-root...PASS.
> +testing append-only as non-root...PASS.
> diff --git a/tests/overlay/group b/tests/overlay/group
> index 047ea046..cfc75bb1 100644
> --- a/tests/overlay/group
> +++ b/tests/overlay/group
> @@ -77,6 +77,7 @@
>  072 auto quick copyup hardlink
>  073 auto quick whiteout
>  074 auto quick exportfs dangerous
> +075 auto quick perms
>  100 auto quick union samefs
>  101 auto quick union nonsamefs
>  102 auto quick union nonsamefs xino
> --
> 2.25.1
>
