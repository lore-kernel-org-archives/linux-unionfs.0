Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAAD7CA553A
	for <linux-unionfs@archiver.kernel.org>; Wed, 13 Sep 2023 16:24:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjIMQYh (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 13 Sep 2023 12:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjIMQYg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 13 Sep 2023 12:24:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A4485B3
        for <linux-unionfs@vger.kernel.org>; Wed, 13 Sep 2023 09:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694622227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HSeP8Pl8IyQkwnTNUoAh9rzd59W702HaO/sB6jKbxPA=;
        b=U6igp9+PPy/uSDqAdjRXXHuWPaCVQXUdbM36gaKwwnUNjxUR9LXQMVdMJ+ooHPrvqelhtz
        3NEIkyXm+EXKe4MIF528PK6tV2snTbY1sUcWbvFdfs4qZML34sxseE7FN4BZ+j8UNlNH7w
        K7uFp9z/4ncA+M8bBtYzvSghCm2YG9o=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-519-vZUwZJNANX24WwFgw9BSBg-1; Wed, 13 Sep 2023 12:23:44 -0400
X-MC-Unique: vZUwZJNANX24WwFgw9BSBg-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1c0a90de7a2so96967575ad.2
        for <linux-unionfs@vger.kernel.org>; Wed, 13 Sep 2023 09:23:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694622223; x=1695227023;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HSeP8Pl8IyQkwnTNUoAh9rzd59W702HaO/sB6jKbxPA=;
        b=M/p58/P7AlNb33Mh3ptkhP9yFetTSpA4vquzrddQvPOkt4dV3vfom7pVy5aC9zxxdn
         A0kGvmY5oD31PCu30kYdxiucVofmJOTyi9knT18pm2J4BOW6jvju3eVaiW/dRCNoBB+g
         SGsADX7svIqL+CQoY928YtA325sCMeYGbMz2ENfr2ALeOqC8kcGa3ScmvBq040poXaiu
         fLkGGZGaIwew9H80z4xYERtWmG8BntAAJoujyMt5eVZ4WoVXVTB/EOU7ppYR1TwkvpEx
         whkCEXWA509gkRGHWmbp/IWNLYLa+oFd8G5mGy2kqFwzH6cYiMRMvq+RRGMfdQCIBunX
         PNoQ==
X-Gm-Message-State: AOJu0Yw93OhUMYLtaeaZJ+8Y5Fb9i2qVbTYWJWmnh4jdCgoYyQdUDdJi
        1kji3hIwf9x+dCL1fcVNriGFgVCna7qcNKOpx4vmwMkJYCKa2eqxDxvZfdqATzDKtCPocMXnJTf
        V7ye9DzluIVU0phrQM+WmQ696Wg==
X-Received: by 2002:a17:902:ecc8:b0:1c0:ec66:f2b2 with SMTP id a8-20020a170902ecc800b001c0ec66f2b2mr4331498plh.27.1694622223559;
        Wed, 13 Sep 2023 09:23:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE/j8du43N6j9iBkVHWC/yBlH/n4KddpLGfEqjRojgRNp3V9DlIaDuj9ACfCAT74eYzJ+YdDw==
X-Received: by 2002:a17:902:ecc8:b0:1c0:ec66:f2b2 with SMTP id a8-20020a170902ecc800b001c0ec66f2b2mr4331473plh.27.1694622223262;
        Wed, 13 Sep 2023 09:23:43 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id c5-20020a170902d90500b001b8622c1ad2sm10636807plz.130.2023.09.13.09.23.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Sep 2023 09:23:42 -0700 (PDT)
Date:   Thu, 14 Sep 2023 00:23:39 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] overlay: add test for persistent unique fsid
Message-ID: <20230913162339.hfare3jt2emhk5t6@zlang-mailbox>
References: <20230903075411.2596590-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230903075411.2596590-1-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Sep 03, 2023 at 10:54:11AM +0300, Amir Goldstein wrote:
> Test overlayfs fsid behavior with new mount options uuid=null/on
> that were introduced in kernel v6.6:
> 
> - Test inherited upper fs fsid with mount option uuid=off/null
> - Test uuid=null behavior for existing overlayfs by default
> - Test persistent unique fsid with mount option uuid=on
> - Test uuid=on behavior for new overlayfs by default
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---

It looks good to me, as there's not objection, I'd like to merge this test
case in next release.

Reviewed-by: Zorro Lang <zlang@redhat.com>

> 
> Zorro,
> 
> This is the functional test for an overlayfs feature merged to v6.6.
> The test does _notrun on older kernels:
> 
> overlay/081 14s ...  [07:40:13][   57.780790] overlay: Bad value for 'uuid'
>  [07:40:14] [not run]
> 	overlay/081 -- Overlayfs does not support unique fsid feature
> 
> The test for another big overlayfs feature that was merged to v6.6,
> overlay/080 (validate lower using fs-verity) is already merged to fstests.
> 
> Note that overlay/080 requires running overlayfs over a base filesystem
> with fs-verity support enabled, for example, on ext4 formatted with
> mkfs.ext4 -O verity [1].
> 
> Thanks,
> Amir.
> 
> [1] https://lore.kernel.org/fstests/20230625135033.3205742-2-amir73il@gmail.com/
> 
>  tests/overlay/081     | 128 ++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/081.out |   2 +
>  2 files changed, 130 insertions(+)
>  create mode 100755 tests/overlay/081
>  create mode 100644 tests/overlay/081.out
> 
> diff --git a/tests/overlay/081 b/tests/overlay/081
> new file mode 100755
> index 00000000..05156a3c
> --- /dev/null
> +++ b/tests/overlay/081
> @@ -0,0 +1,128 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2023 CTERA Networks. All Rights Reserved.
> +#
> +# FSQA Test No. 081
> +#
> +# Test persistent (and optionally unique) overlayfs fsid
> +# with mount options uuid=null/on introduced in kernel v6.6
> +#
> +. ./common/preamble
> +_begin_fstest auto quick
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/attr
> +
> +# real QA test starts here
> +_supported_fs overlay
> +
> +_scratch_mkfs >>$seqres.full 2>&1
> +
> +# Create overlay layer with pre-packaged merge dir
> +upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
> +workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
> +lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
> +mkdir -p $upperdir/test_dir
> +mkdir -p $lowerdir/test_dir
> +test_dir=$SCRATCH_MNT/test_dir/
> +
> +# Record base fs fsid
> +upper_fsid=$(stat -f -c '%i' $upperdir)
> +lower_fsid=$(stat -f -c '%i' $lowerdir)
> +
> +# Sanity tests
> +[[ -n "$upper_fsid" ]] || \
> +	echo "invalid upper fs fsid"
> +[[ "$lower_fsid" == "$upper_fsid" ]] || \
> +	echo "lower fs and upper fs fsid differ"
> +
> +# Test legacy behavior - ovl fsid inherited from upper fs
> +_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o uuid=null 2>/dev/null || \
> +	_notrun "Overlayfs does not support unique fsid feature"
> +
> +# Lookup of test_dir marks upper root as "impure", so following (uuid=auto) mounts
> +# will NOT behave as first time mount of a new overlayfs
> +ovl_fsid=$(stat -f -c '%i' $test_dir)
> +[[ "$ovl_fsid" == "$upper_fsid" ]] || \
> +	echo "Overlayfs (uuid=null) and upper fs fsid differ"
> +
> +# Keep base fs mounted in case it has a volatile fsid (e.g. tmpfs)
> +$UMOUNT_PROG $SCRATCH_MNT
> +
> +# Test legacy behavior is preserved by default for existing "impure" overlayfs
> +_scratch_mount
> +
> +ovl_fsid=$(stat -f -c '%i' $test_dir)
> +[[ "$ovl_fsid" == "$upper_fsid" ]] || \
> +	echo "Overlayfs (uuid=auto) and upper fs fsid differ"
> +
> +$UMOUNT_PROG $SCRATCH_MNT
> +
> +# Test unique fsid on explicit opt-in for existing "impure" overlayfs
> +_scratch_mount -o uuid=on
> +
> +ovl_fsid=$(stat -f -c '%i' $test_dir)
> +ovl_unique_fsid=$ovl_fsid
> +[[ "$ovl_fsid" != "$upper_fsid" ]] || \
> +	echo "Overlayfs (uuid=on) and upper fs fsid are the same"
> +
> +$UMOUNT_PROG $SCRATCH_MNT
> +
> +# Test unique fsid is persistent by default after it was created
> +_scratch_mount
> +
> +ovl_fsid=$(stat -f -c '%i' $test_dir)
> +[[ "$ovl_fsid" == "$ovl_unique_fsid" ]] || \
> +	echo "Overlayfs (uuid=auto) unique fsid is not persistent"
> +
> +$UMOUNT_PROG $SCRATCH_MNT
> +
> +# Test ignore existing persistent fsid on explicit opt-out
> +_scratch_mount -o uuid=off
> +
> +ovl_fsid=$(stat -f -c '%i' $test_dir)
> +[[ "$ovl_fsid" == "$upper_fsid" ]] || \
> +	echo "Overlayfs (uuid=off) and upper fs fsid differ"
> +
> +$UMOUNT_PROG $SCRATCH_MNT
> +
> +# Test fallback to uuid=null with non-upper ovelray
> +_overlay_scratch_mount_dirs "$upperdir:$lowerdir" "-" "-" -o ro,uuid=on
> +
> +ovl_fsid=$(stat -f -c '%i' $test_dir)
> +[[ "$ovl_fsid" == "$lower_fsid" ]] || \
> +	echo "Overlayfs (uuid=null) and lower fs fsid differ"
> +
> +# Re-create fresh overlay layers, so following (uuid=auto) mounts
> +# will behave as first time mount of a new overlayfs
> +_scratch_unmount
> +_scratch_mkfs >>$seqres.full 2>&1
> +mkdir -p $upperdir/test_dir
> +mkdir -p $lowerdir/test_dir
> +
> +# Record new base fs fsid
> +upper_fsid=$(stat -f -c '%i' $upperdir)
> +
> +# Test unique fsid by default for first time mount of new overlayfs
> +_scratch_mount
> +
> +ovl_fsid=$(stat -f -c '%i' $test_dir)
> +ovl_unique_fsid=$ovl_fsid
> +[[ "$ovl_fsid" != "$upper_fsid" ]] || \
> +	echo "Overlayfs (uuid=auto) and upper fs fsid are the same"
> +
> +$UMOUNT_PROG $SCRATCH_MNT
> +
> +# Test unique fsid is persistent by default after it was created
> +_scratch_mount -o uuid=on
> +
> +ovl_fsid=$(stat -f -c '%i' $test_dir)
> +[[ "$ovl_fsid" == "$ovl_unique_fsid" ]] || \
> +	echo "Overlayfs (uuid=on) unique fsid is not persistent"
> +
> +$UMOUNT_PROG $SCRATCH_MNT
> +
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/overlay/081.out b/tests/overlay/081.out
> new file mode 100644
> index 00000000..663a8864
> --- /dev/null
> +++ b/tests/overlay/081.out
> @@ -0,0 +1,2 @@
> +QA output created by 081
> +Silence is golden
> -- 
> 2.34.1
> 

