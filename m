Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FC9BC004D6
	for <linux-unionfs@archiver.kernel.org>; Wed, 20 Sep 2023 15:15:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234874AbjITPPO (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 20 Sep 2023 11:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234603AbjITPPM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 20 Sep 2023 11:15:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E28AA9
        for <linux-unionfs@vger.kernel.org>; Wed, 20 Sep 2023 08:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695222861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EuQ8ZHKY3/RhYQyr6LX8a2yu9PvZXsrNsWsQmzmK7as=;
        b=KhAMyOkNxp/anHx9/T1LrmGPy92C727ri40xhwfvnCKMps6XiSyT4h0+h9PJWG7elP2w9u
        6x57h3gAHOIMsNNHH9RzhP5RG+zTmp0MjID9hps9uHQEyyaGm+v4c8+LZWXCV4YYj0za9J
        rye0Udfkiz0DC1LiRaCU3uxHw5pvtls=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-372-xGXobG-UMRCBdf2rfgH-iw-1; Wed, 20 Sep 2023 11:14:11 -0400
X-MC-Unique: xGXobG-UMRCBdf2rfgH-iw-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-274ae7a5e88so4000520a91.2
        for <linux-unionfs@vger.kernel.org>; Wed, 20 Sep 2023 08:14:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695222848; x=1695827648;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EuQ8ZHKY3/RhYQyr6LX8a2yu9PvZXsrNsWsQmzmK7as=;
        b=nCLwHOpF19G3i8g0HTORxTNNszaN8qL0LmHs+jP5Ul3YNnK8sgkiqNqCVR/VeRP+m/
         ZFH3Mr31bbo43J9IexMRNKwePyfAe23misaYJIhlldk2nBCERbsT01eApXVRsxPbPi07
         IbFUhI2lkEhCZxOGr2EiPkTdjCbGuL5fU+m/nSawN2OaAosI/mi9Jy7xc3Al8e4jL1Ww
         WVU6fDoEWj91wu5fsz+FouU8UBu/upsOEWCHYd5mhwP04rkKe27UQyyZP3OTO+cq9D4O
         mSpSV/IhkBoM/furUY/lapq8i4cRdoYMCmqlVNDyHDiAdcO53GLKI/2uj/pAeo79vRyn
         oxow==
X-Gm-Message-State: AOJu0YzEkN85hyQ7exGREEaPPgveQ+/F89zMjPFl01euFacVbwPFGWvF
        WcxepUsU38K7RYZBn2jk8QkcVE0VjleztN9J0ZriKlgvx1/dVaD1qGnsj5uLyG7VgD59OJna+FB
        4vAVi9BM208ETSg94c013ilsqlg==
X-Received: by 2002:a17:90a:e601:b0:273:f51f:1626 with SMTP id j1-20020a17090ae60100b00273f51f1626mr2530468pjy.35.1695222847732;
        Wed, 20 Sep 2023 08:14:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGYBlLus7cH8A0TOF+ELrpxahnz+IdnInpsto9G/Hx4fidfPc4lNxi3CpAkyWgi6xL8TYyeAg==
X-Received: by 2002:a17:90a:e601:b0:273:f51f:1626 with SMTP id j1-20020a17090ae60100b00273f51f1626mr2530448pjy.35.1695222847412;
        Wed, 20 Sep 2023 08:14:07 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id fu10-20020a17090ad18a00b00263b9e75aecsm1459100pjb.41.2023.09.20.08.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Sep 2023 08:14:07 -0700 (PDT)
Date:   Wed, 20 Sep 2023 23:14:03 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Ruiwen Zhao <ruiwen@google.com>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH] overlay: add test for rename of lower symlink with
 NOATIME attr
Message-ID: <20230920151403.gsh5gphvlilhp6sv@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20230920130355.62763-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230920130355.62763-1-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Sep 20, 2023 at 04:03:55PM +0300, Amir Goldstein wrote:
> A test for a regression from v5.15 reported by Ruiwen Zhao:
> https://lore.kernel.org/linux-unionfs/CAKd=y5Hpg7J2gxrFT02F94o=FM9QvGp=kcH1Grctx8HzFYvpiA@mail.gmail.com/
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Zorro,
> 
> This is a test for a regression in kernel v5.15.
> The fix was merged for 6.6-rc2 and has been picked for
> the upcoming LTS releases 5.15, 6.1, 6.5.
> 
> The reproducer only manifests the bug in fs that inherit noatime flag,
> namely ext4, btrfs, ... but not xfs.
> 
> The test does _notrun on xfs for that reason.
> 
> Thanks,
> Amir.
> 
>  tests/overlay/082     | 68 +++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/082.out |  2 ++
>  2 files changed, 70 insertions(+)
>  create mode 100755 tests/overlay/082
>  create mode 100644 tests/overlay/082.out
> 
> diff --git a/tests/overlay/082 b/tests/overlay/082
> new file mode 100755
> index 00000000..abea3c2b
> --- /dev/null
> +++ b/tests/overlay/082
> @@ -0,0 +1,68 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2023 CTERA Networks. All Rights Reserved.
> +#
> +# FS QA Test 082
> +#
> +# kernel commit 72db82115d2b ("ovl: copy up sync/noatime fileattr flags")
> +# from v5.15 introduced a regression.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick
> +
> +# Import common functions.
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs overlay
> +_fixed_by_kernel_commit ab048302026d \
> +	"ovl: fix failed copyup of fileattr on a symlink"
> +
> +_require_scratch
> +_require_chattr A
> +
> +# remove all files from previous runs
> +_scratch_mkfs
> +
> +# prepare lower test dir with NOATIME flag
> +lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
> +mkdir -p $lowerdir/testdir
> +$CHATTR_PROG +A $lowerdir/testdir >> $seqres.full 2>&1 ||
> +	_notrun "base fs $OVL_BASE_FSTYP does not support No_Atime flag"
> +
> +# The NOATIME is inheritted to children symlink in ext4/fs2fs
> +# (and on tmpfs on recent kernels).
> +# The overlayfs test will not fail unless base fs is
> +# one of those filesystems.
> +#
> +# The problem with this inheritence is that the NOATIME flag is inheritted
> +# to a symlink and the flag does take effect, but there is no way to query
> +# the flag (lsattr) or change it (chattr) on a symlink, so overlayfs will
> +# fail when trying to copy up NOATIME flag from lower to upper symlink.
> +#
> +touch $lowerdir/testdir/foo
> +ln -sf foo $lowerdir/testdir/lnk
> +
> +$LSATTR_PROG -l $lowerdir/testdir/foo >> $seqres.full 2>&1
> +$LSATTR_PROG -l $lowerdir/testdir/foo | grep -q No_Atime || \
> +	_notrun "base fs $OVL_BASE_FSTYP does not inherit No_Atime flag"
> +
> +before=$(stat -c %x $lowerdir/testdir/lnk)
> +echo "symlink atime before readlink: $before" >> $seqres.full 2>&1
> +cat $lowerdir/testdir/lnk
> +after=$(stat -c %x $lowerdir/testdir/lnk)
> +echo "symlink atime after readlink: $after" >> $seqres.full 2>&1
> +
> +[ "$before" == "$after" ] || \
> +	_notrun "base fs $OVL_BASE_FSTYP does not inherit No_Atime flag on symlink"
> +
> +# mounting overlay
> +_scratch_mount
> +
> +# moving symlink will try to copy up lower symlink flags
> +mv $SCRATCH_MNT/testdir/lnk $SCRATCH_MNT/

Lots of above codes are checking if the underlying fs supports No_Atime (and inherit),
and _notrun if not support. How about do these checking steps in a require_*
function locally or in common/, likes _require_noatime_inheritance(). And we also
can let _require_chattr accept one more argument to specify a test directory.

The "mv ..." command looks like the final testing step. If there's not that bug,
nothing happen, but I'm wondering what should happen if there's a bug?

Thanks,
Zorro

> +
> +# success, all done
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/overlay/082.out b/tests/overlay/082.out
> new file mode 100644
> index 00000000..2977f141
> --- /dev/null
> +++ b/tests/overlay/082.out
> @@ -0,0 +1,2 @@
> +QA output created by 082
> +Silence is golden
> -- 
> 2.34.1
> 

