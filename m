Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64AEDC004C0
	for <linux-unionfs@archiver.kernel.org>; Mon, 23 Oct 2023 14:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbjJWOD6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 23 Oct 2023 10:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbjJWODw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 23 Oct 2023 10:03:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 906C2100
        for <linux-unionfs@vger.kernel.org>; Mon, 23 Oct 2023 07:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698069781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xDgRZ0x9xPt7V34P9H4H8ZuOaECkg0KFXrFPD6akRHg=;
        b=hJUxwHIcwb60Eq2NrSqdcRPdH9vj6naUKuB25D6oP2jUFLdHFJzb7WOcGxWRWiPR01brdi
        Vp/XvgfpvB6exSSE2Q4e6bm1oZwf1hpyG+B73VCRKhUxHhroKTG9Unjo7lHCWKgpiJzkyc
        MmhCbQ1dba3hYxnqgDyGTC3uLh0ukuw=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-Gn_cOEuFN5qGLtqVbK7-Ew-1; Mon, 23 Oct 2023 10:02:45 -0400
X-MC-Unique: Gn_cOEuFN5qGLtqVbK7-Ew-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-5a08e5c7debso1897975a12.2
        for <linux-unionfs@vger.kernel.org>; Mon, 23 Oct 2023 07:02:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698069763; x=1698674563;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xDgRZ0x9xPt7V34P9H4H8ZuOaECkg0KFXrFPD6akRHg=;
        b=I6Ad5C7OAPSA0cu0LP/R4SP1kUso19hcevjJ3VPQNowGZFrFgNzt58UBgHyAgJzWSV
         nsQR3AVEMQQM1BPUc/2kme9KkVtnLctPgWDpx7jfQ1O+LA9iIPsPzIRhgekQMrrlDBax
         EOfzx25gCNU/LxVagpCJlQ6keuLF9A7eKfzf2hI2tu8EG9ohvmQR1HQ6yskQUZ0aa0Qr
         T2DvoDK4QQnxPtnldx/gp9k1oBa4wdSvm+wiZLozne40j0IC0lqz4nihQ/SKVmTd0ZYp
         eAgkqtG8LiyOfJSoLL7KNzuArz8Qs2MCrDsEwK2ljLqfg97epz9oCCAgeOL6b4eEAEok
         kPRw==
X-Gm-Message-State: AOJu0Yyhxsvmvbjyktte6WeuP6Bl5CBt0YO5ovrhD0jbmdpuVlL8/q5I
        PUrfcI4PKdWYSEHrZ+JpyJa6B0OkHPTBrXx8kLSSqB3vbZcN1JbXHls/Pup+OzKfmCzrnP30qoG
        eLLgR0477kI/Rr4oPQ1Jhnb5mzw==
X-Received: by 2002:a17:90a:1947:b0:27d:10ab:2325 with SMTP id 7-20020a17090a194700b0027d10ab2325mr6863081pjh.27.1698069762395;
        Mon, 23 Oct 2023 07:02:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFbY4H4g7p7rJdDpxKC2+X1GUZcGXmlQXjFWqFEzcqYSGOG2pXXXTfVog+2/guZIzHQ5TVb5g==
X-Received: by 2002:a17:90a:1947:b0:27d:10ab:2325 with SMTP id 7-20020a17090a194700b0027d10ab2325mr6863041pjh.27.1698069761845;
        Mon, 23 Oct 2023 07:02:41 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id rs6-20020a17090b2b8600b0027ce48022cbsm7565672pjb.14.2023.10.23.07.02.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 07:02:41 -0700 (PDT)
Date:   Mon, 23 Oct 2023 22:02:37 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Christian Brauner <brauner@kernel.org>,
        Karel Zak <kzak@redhat.com>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH v2] overlay: add test for lowerdir mount option parsing
Message-ID: <20231023140237.d5e3qewsm4sdi4d2@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20231023104916.2932366-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231023104916.2932366-1-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Oct 23, 2023 at 01:49:16PM +0300, Amir Goldstein wrote:
> Check parsing and display of spaces and escaped colons and commans in
> lowerdir mount option.
> 
> This is a regression test for two bugs introduced in v6.5 with the
> conversion to new mount api.
> 
> There is another regression of new mount api related to libmount parsing
> of escaped commas, but this needs a fix in libmount - this test only
> verifies the fixes in the kernel, so it uses LIBMOUNT_FORCE_MOUNT2=always
> to force mount(2) and kernel pasring of the comma separated options list.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Zorro,
> 
> I've fixed the libmount issue by splitting the combined test cases
> to two test cases that corresspond to the two kernel fix commits.
> 
> The first test case (lowerdir_spaces) is agnostic to libmount version.
> 
> The second test case (lowerdir_commas) explicitly opts-in to mount(2)
> syscall.
> 
> ATM, using LIBMOUNT_FORCE_MOUNT2=always, as the second test cases does,
> would be our recommended workaround for the escaped commas regression
> in v6.5, until libmount gets a fix to detect overlayfs escaped commas.
> 
> Thanks,
> Amir.
> 
>  tests/overlay/083     | 71 +++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/083.out |  2 ++
>  2 files changed, 73 insertions(+)
>  create mode 100755 tests/overlay/083
>  create mode 100644 tests/overlay/083.out
> 
> diff --git a/tests/overlay/083 b/tests/overlay/083
> new file mode 100755
> index 00000000..0f434951
> --- /dev/null
> +++ b/tests/overlay/083
> @@ -0,0 +1,71 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2023 CTERA Networks. All Rights Reserved.
> +#
> +# FS QA Test 083
> +#
> +# Test regressions in parsing and display of special chars in mount options.
> +#
> +# The following kernel commits from v6.5 introduced regressions:
> +#  b36a5780cb44 ("ovl: modify layer parameter parsing")
> +#  1784fbc2ed9c ("ovl: port to new mount api")
> +#
> +
> +. ./common/preamble
> +_begin_fstest auto quick mount
> +
> +# Import common functions.
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs overlay
> +_fixed_by_kernel_commit 32db51070850 \
> +	"ovl: fix regression in showing lowerdir mount option"
> +_fixed_by_kernel_commit c34706acf40b \
> +	"ovl: fix regression in parsing of mount options with escaped comma"
> +
> +# _overlay_check_* helpers do not handle special chars well
> +_require_scratch_nocheck
> +
> +# Remove all files from previous tests
> +_scratch_mkfs
> +
> +# Create lowerdirs with special characters
> +lowerdir_spaces="$OVL_BASE_SCRATCH_MNT/lower1 with  spaces"
> +lowerdir_colons="$OVL_BASE_SCRATCH_MNT/lower2:with::colons"
> +lowerdir_commas="$OVL_BASE_SCRATCH_MNT/lower3,with,,commas"
> +lowerdir_colons_esc="$OVL_BASE_SCRATCH_MNT/lower2\:with\:\:colons"
> +lowerdir_commas_esc="$OVL_BASE_SCRATCH_MNT/lower3\,with\,\,commas"
> +upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
> +workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
> +mkdir -p "$lowerdir_spaces" "$lowerdir_colons" "$lowerdir_commas"
> +
> +# _overlay_mount_* helpers do not handle special chars well, so execute mount directly.
> +# if escaped colons are not parsed correctly, mount will fail.
> +$MOUNT_PROG -t overlay ovl_esc_test $SCRATCH_MNT \
> +	-o"upperdir=$upperdir,workdir=$workdir" \
> +	-o"lowerdir=$lowerdir_colons_esc:$lowerdir_spaces" \
> +	2>&1 | tee -a $seqres.full
> +
> +# if spaces are not escaped when showing mount options,
> +# mount command will not show the word 'spaces' after the spaces
> +$MOUNT_PROG -t overlay | grep ovl_esc_test  | tee -a $seqres.full | grep -v spaces && \
> +	echo "ERROR: escaped spaces truncated from lowerdir mount option"
> +$UMOUNT_PROG $SCRATCH_MNT
> +
> +# Kernel commit c34706acf40b fixes parsing of mount options with escaped comma
> +# when the mount options string is provided via data argument to mount(2) syscall.
> +# With libmount >= 2.39, libmount itself will try to split the comma separated
> +# options list provided to mount(8) commnad line and call fsconfig(2) for each
> +# mount option seperately.  Since libmount does not obay to overlayfs escaped
> +# commas format, it will call fsconfig(2) with the wrong path (i.e. ".../lower3")
> +# and this test will fail, but the failure would indicate a libmount issue, not
> +# a kernel issue.  Therefore, force libmount to use mount(2) syscall, so we only
> +# test the kernel fix.
> +LIBMOUNT_FORCE_MOUNT2=always $MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_DEV $SCRATCH_MNT \
> +	-o"upperdir=$upperdir,workdir=$workdir,lowerdir=$lowerdir_commas_esc" 2>> $seqres.full || \
> +	echo "ERROR: incorrect parsing of escaped comma in lowerdir mount option"

Hi Amir, Please check, this part still fails as:

# ./check -overlay overlay/083
FSTYP         -- overlay
PLATFORM      -- Linux/x86_64 hp-dl380pg8-01 6.6.0-rc6-mainline+ #7 SMP PREEMPT_DYNAMIC Thu Oct 19 22:34:28 CST 2023
MKFS_OPTIONS  -- /mnt/scratch
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /mnt/scratch /mnt/scratch/ovl-mnt

overlay/083 0s ... - output mismatch (see /root/git/xfstests/results//overlay/083.out.bad)
    --- tests/overlay/083.out   2023-10-23 21:18:46.765059777 +0800
    +++ /root/git/xfstests/results//overlay/083.out.bad 2023-10-23 21:51:39.030561512 +0800
    @@ -1,2 +1,3 @@
     QA output created by 083
    +ERROR: incorrect parsing of escaped comma in lowerdir mount option
     Silence is golden
    ...
    (Run 'diff -u /root/git/xfstests/tests/overlay/083.out /root/git/xfstests/results//overlay/083.out.bad'  to see the entire diff)

HINT: You _MAY_ be missing kernel fix:
      32db51070850 ovl: fix regression in showing lowerdir mount option

HINT: You _MAY_ be missing kernel fix:
      c34706acf40b ovl: fix regression in parsing of mount options with escaped comma

Ran: overlay/083
Failures: overlay/083
Failed 1 of 1 tests

# cat results/overlay/083.full 
ovl_esc_test on /mnt/scratch/ovl-mnt type overlay (rw,relatime,seclabel,lowerdir=/mnt/scratch/lower2\:with\:\:colons:/mnt/scratch/lower1 with  spaces,upperdir=/mnt/scratch/ovl-upper,workdir=/mnt/scratch/ovl-work,uuid=on)
mount: /mnt/scratch/ovl-mnt: mount(2) system call failed: Stale file handle.
       dmesg(1) may have more information after failed mount system call.

# dmesg
[341033.046302] run fstests overlay/083 at 2023-10-23 22:00:11
[341033.458188] XFS (loop0): Mounting V5 Filesystem 23e1781e-f5ce-4c2b-8801-3b586f459ee8
[341033.464410] XFS (loop0): Ending clean mount
[341033.506666] overlayfs: failed to verify origin (/lower3,with,,commas, ino=16908385, err=-116)
[341033.507626] overlayfs: failed to verify upper root origin
[341033.540865] XFS (loop1): Unmounting Filesystem 58e81b68-81dd-48cd-ab23-ce30ec77e689
[341033.554488] XFS (loop0): Unmounting Filesystem 23e1781e-f5ce-4c2b-8801-3b586f459ee8

> +
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/overlay/083.out b/tests/overlay/083.out
> new file mode 100644
> index 00000000..0beba309
> --- /dev/null
> +++ b/tests/overlay/083.out
> @@ -0,0 +1,2 @@
> +QA output created by 083
> +Silence is golden
> -- 
> 2.34.1
> 

