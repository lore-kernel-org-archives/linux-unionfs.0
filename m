Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9FD7E7D0A4
	for <linux-unionfs@archiver.kernel.org>; Thu, 21 Sep 2023 19:02:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbjIUTCK (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 21 Sep 2023 15:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbjIUTBp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 21 Sep 2023 15:01:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1915F7B96C
        for <linux-unionfs@vger.kernel.org>; Thu, 21 Sep 2023 10:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695317822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oK2PX137XfTZOWRLKOkFV4Sa+eaXzi/ddegWpwPmmro=;
        b=LdmDX3Nxl3egsXbRDO2a1J1SyewJFg4zHxSye+ZR0K9AOA23j3jKqAWbPbf0rCwc5NPhxN
        4uYob3JMqY32x7EMAX/Qa0QCTzWfCIy7kCa1WuUlmArW42GJ6gX62zEZSHH0/dSpPs5H5n
        8FAR743pto9JaAuyDsSmeFwifOkNMJQ=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-111-NVPyMviHMqyBfHQDErmfjQ-1; Thu, 21 Sep 2023 10:20:46 -0400
X-MC-Unique: NVPyMviHMqyBfHQDErmfjQ-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1c0d58f127fso8694295ad.2
        for <linux-unionfs@vger.kernel.org>; Thu, 21 Sep 2023 07:20:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695306045; x=1695910845;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oK2PX137XfTZOWRLKOkFV4Sa+eaXzi/ddegWpwPmmro=;
        b=AAM7vg+pja5DmUwhXgbGYuA8ZUavJ93ZcK7uVATqcBb8z41lKq0moC1gC/gJDjbBs4
         39+XWtcWIXt2pd7wWxX/c9LtvLES6H9aaHYUnp2Zeme+xI2aCdQnwCudwpp7RElWhfwB
         btmQHmvdLd29ZGDxnMnEeRtd8Lt+W8yYYRzugEU4aQ1qlLerV9nkY8RmRIZLI+crzQNZ
         Qv+uh9tDjBEy01Xv8OgVu2RU7XN1sf/QFrpm7bUAFiW39pjcS1yeq5ogUMAxXtuqh2OV
         QD1p3Vw+E4M3lzzj0C6N4Ixcz3yC5J/ENq3EjFXkWVETXk+rOoLmgHQ8DenvUQwdvg4/
         4D7w==
X-Gm-Message-State: AOJu0YxEzyJjgPcstz4fepQmOVG7x7pEAs8NOowEhAlDtjYqTMi0MHD9
        XhVkY6/SIgIGZmjUH0F2BlMtJQN0bZyxSv9BzVHmlRKouaKT2Ms41vJrlXi+9SUKRZ0Lj3ac1z3
        PKKwDWhVk5y32yR0HaO2jbMX2SA==
X-Received: by 2002:a17:902:e851:b0:1b8:8af0:416f with SMTP id t17-20020a170902e85100b001b88af0416fmr5592884plg.1.1695306044989;
        Thu, 21 Sep 2023 07:20:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEQyylMW0W28BrF97Ryzwd7N7x6wv78ELjt1csgIkBrtP15gOHsBecy+9nrfVNi5btFXUa0wA==
X-Received: by 2002:a17:902:e851:b0:1b8:8af0:416f with SMTP id t17-20020a170902e85100b001b88af0416fmr5592862plg.1.1695306044621;
        Thu, 21 Sep 2023 07:20:44 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 17-20020a170902ee5100b001bb7a736b4csm1550033plo.77.2023.09.21.07.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 07:20:44 -0700 (PDT)
Date:   Thu, 21 Sep 2023 22:20:40 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Yongcheng Yang <yoyang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-nfs@vger.kernel.org,
        Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org
Subject: Re: [PATCH] generic/471: add a test to check move in mountpoints of
 the same export
Message-ID: <20230921142040.hw6szynpmemusdi3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20230921134347.839957-1-yoyang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921134347.839957-1-yoyang@redhat.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Sep 21, 2023 at 09:43:47PM +0800, Yongcheng Yang wrote:
> Add a new test to ckeck file move (rename) operation among
> different mount points which are mounting to a same export.
> 
> This should be a simple test but it recently unveils an ancient
> nfsd bug. Thus let's make it to be a regresstion check.
> 
> Signed-off-by: Yongcheng Yang <yoyang@redhat.com>
> ---
> 
> Hi,
> 
> There is an ancient nfsd problem just pop up and is now resolved by
> the upstream commit [1]. Looks like it's a basic and simple test which
> is probably appropriate for the fstest IMO.
> 
> This test in nfs will be failed without patch [1]:
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> [root@kvm-07-guest24 xfstests]# ./check -nfs generic/471
> FSTYP     	-- nfs
> PLATFORM  	-- Linux/x86_64 kvm-07-guest24 5.14.0-abc.el9.x86_64 #1 SMP PREEMPT_DYNAMIC Wed Sep 13 04:59:08 EDT 2023
> MKFS_OPTIONS  -- localhost:/export_test2
> MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 localhost:/export_test2 /mnt_scratch
> 
> generic/471 1s ... - output mismatch (see /root/xfstests/results//generic/471.out.bad)
> 	--- tests/generic/471.out    2023-09-21 05:55:28.514673177 -0400
> 	+++ /root/xfstests/results//generic/471.out.bad    2023-09-21 08:06:16.935695355 -0400
> 	@@ -1,2 +1,3 @@
>  	QA output created by 471
>  	Silence is golden
> 	+mv: '/mnt_test/mountpoint1-471/A/f' and '/mnt_test/mountpoint1-471/B/f' are the same file
> 	...
> 	(Run 'diff -u /root/xfstests/tests/generic/471.out /root/xfstests/results//generic/471.out.bad'  to see the entire diff)
> 
> HINT: You _MAY_ be missing kernel fix:
>   	fdd2630a739819 nfsd: fix change_info in NFSv4 RENAME replies
> 
> Ran: generic/471
> Failures: generic/471
> Failed 1 of 1 tests
> 
> [root@kvm-07-guest24 xfstests]#
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> And it can pass after that patch [1] merged:
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> [root@fsqe-r6515-02 xfstests]# ./check -nfs generic/471
> FSTYP     	-- nfs
> PLATFORM  	-- Linux/x86_64 fsqe-r6515-02 5.14.0-abcd.el9.x86_64 #1 SMP PREEMPT_DYNAMIC Tue Sep 19 08:10:36 EDT 2023
> MKFS_OPTIONS  -- localhost:/export_test1
> MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 localhost:/export_test1 /mnt_scratch
> 
> generic/471    	0s
> Ran: generic/471
> Passed all 1 tests
> 
> [root@fsqe-r6515-02 xfstests]#
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> 
> Also I have just checked the xfs and overlayfs but the latter get failed:
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> [root@fsqe-r6515-02 xfstests]# ./check generic/471
> FSTYP         -- xfs (non-debug)
> PLATFORM      -- Linux/x86_64 fsqe-r6515-02 5.14.0-abcd.el9.x86_64 #1 SMP PREEMPT_DYNAMIC Tue Sep 19 08:10:36 EDT 2023
> MKFS_OPTIONS  -- -f /dev/loop1
> MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/loop1 /mnt_scratch
> 
> generic/471 0s ...  1s
> Ran: generic/471
> Passed all 1 tests
> 
> [root@fsqe-r6515-02 xfstests]#
> [root@fsqe-r6515-02 xfstests]# ./check -overlay generic/471
> FSTYP         -- overlay
> PLATFORM      -- Linux/x86_64 fsqe-r6515-02 5.14.0-abcd.el9.x86_64 #1 SMP PREEMPT_DYNAMIC Tue Sep 19 08:10:36 EDT 2023
> MKFS_OPTIONS  -- /mnt_scratch
> MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /mnt_scratch /mnt_scratch/ovl-mnt
> 
> generic/471 0s ... - output mismatch (see /root/xfstests/results//generic/471.out.bad)
>     --- tests/generic/471.out	2023-09-21 09:02:14.580495256 -0400
>     +++ /root/xfstests/results//generic/471.out.bad	2023-09-21 09:02:51.145345830 -0400
>     @@ -1,2 +1,3 @@
>      QA output created by 471
>      Silence is golden
>     +mv: '/mnt_test/ovl-mnt/mountpoint1-471/A/f' and '/mnt_test/ovl-mnt/mountpoint1-471/B/f' are the same file

Does the underlying fs affect this testing result?

CC Amir to get his review on this overlay specific failure.

>     ...
>     (Run 'diff -u /root/xfstests/tests/generic/471.out /root/xfstests/results//generic/471.out.bad'  to see the entire diff)
> Ran: generic/471
> Failures: generic/471
> Failed 1 of 1 tests
> 
> [root@fsqe-r6515-02 xfstests]#
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> For now I'm not sure if the overlayfs don't support this operation or
> we just need to fix that.
> 
> Thanks,
> Yongcheng
> 
> [1] https://lore.kernel.org/linux-nfs/ZPyMyv1nNFV2whKP@tissot.1015granger.net/T/#t
> 
> 
>  tests/generic/471     | 60 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/471.out |  2 ++
>  2 files changed, 62 insertions(+)
>  create mode 100755 tests/generic/471
>  create mode 100644 tests/generic/471.out
> 
> diff --git a/tests/generic/471 b/tests/generic/471
> new file mode 100755
> index 00000000..ada48129
> --- /dev/null
> +++ b/tests/generic/471
> @@ -0,0 +1,60 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2023 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test 471
> +#
> +# Mount the same export to different mount points and move (rename)
> +# files among those mount points.
> +# This simple test recently unveils an ancient nfsd bug that is fixed
> +# by fdd2630a739819 ("nfsd: fix change_info in NFSv4 RENAME replies").
> +#
> +. ./common/preamble
> +_begin_fstest auto quick

This test might be good to be in "rename" group too.

Others looks good to me.

Thanks,
Zorro

> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	$UMOUNT_PROG $testdir1 2>/dev/null
> +	$UMOUNT_PROG $testdir2 2>/dev/null
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +
> +# real QA test starts here
> +
> +_supported_fs generic
> +[ "$FSTYP" = "nfs" ] && \
> +	_fixed_by_kernel_commit fdd2630a739819 \
> +		"nfsd: fix change_info in NFSv4 RENAME replies"
> +
> +_require_test
> +_require_scratch
> +
> +echo "Silence is golden"
> +
> +_scratch_mkfs >> $seqres.full
> +testdir1=$TEST_DIR/mountpoint1-$seq
> +testdir2=$TEST_DIR/mountpoint2-$seq
> +rm -rf $testdir1 $testdir2
> +mkdir -p $testdir1 $testdir2
> +
> +# Don't share the data and attribute caches among mount points for NFS.
> +# This caching behavior is necessary to reproduce this issue as we're
> +# checking the alignment of each mount point's own unique cache.
> +[ "$FSTYP" = "nfs" ] && MOUNT_OPTIONS="-o nosharecache"
> +
> +SCRATCH_MNT=$testdir1 _scratch_mount
> +SCRATCH_MNT=$testdir2 _scratch_mount
> +rm -rf $testdir1/{A,B}
> +mkdir $testdir1/{A,B}
> +touch $testdir1/A/f
> +mv $testdir1/A/f $testdir1/B/
> +cat $testdir2/B/f
> +mv $testdir2/B/f $testdir2/A/
> +cat $testdir1/A/f
> +mv $testdir1/A/f $testdir1/B/
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/471.out b/tests/generic/471.out
> new file mode 100644
> index 00000000..260f629e
> --- /dev/null
> +++ b/tests/generic/471.out
> @@ -0,0 +1,2 @@
> +QA output created by 471
> +Silence is golden
> -- 
> 2.31.1
> 

