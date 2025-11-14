Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238A3332EA2
	for <linux-unionfs@vger.kernel.org>; Fri, 14 Nov 2025 18:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763144258; cv=none; b=Lz5ATdRVwJGp02ZEThlN+8llq9nYShIz1SiGpzLfUscAwTHtsFyVwaV3wrUALKj1yXg72hwzC6Eyk0F00aC6oOSu9scbt1y/nLx83A35FlP3MDqsqQFh+e3jbNYkjavVUNAWxd7by9J59+wyLPUouU1D/XhXp+GQ/kEsQMfjSEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763144258; c=relaxed/simple;
	bh=xhtb1KDxXyh6qSIXD3yaf4mkBfalj+bfIv3bOiHrTBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kljc94le55AWL3tl5rFojn9B/OREuXHDgvQI3xWspCepLPfJ5Cfip/HLHNq+pA1FXRJrVNw+W4lrv2J2Ijh0y4WQxGKnEVkslp6xMMeaOGZbmkRfbzN5BzrLqJmMJaJKb9c/TchRCH7/tT0V8MGFCGnROy/XngXfnWNhb5gSQ8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PRLmO3xG; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=XjnARHzv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PRLmO3xG";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="XjnARHzv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763144255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pzz2UQttAdlWuixFQvQcB5l7gTdqlw/lLPJ2vqXTeKA=;
	b=PRLmO3xGNL/T2WytFEx7SQb+HVH8mdTtWhXbC5Vzjc3HhKYJhNbVnkuc8PIc/QKsPBzqFM
	PADgApJHFtIrdcjM9WnI/dG2/4ttB/4DtKjLPNdLqt3jNumS+iRFHIiVv/Che40WpGPCpA
	vITPhSL7DcDEGEEvxBA+qacb1vRW1rA=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-257-O2Ibah1yNau2iHL0rnn-Hg-1; Fri, 14 Nov 2025 13:17:33 -0500
X-MC-Unique: O2Ibah1yNau2iHL0rnn-Hg-1
X-Mimecast-MFC-AGG-ID: O2Ibah1yNau2iHL0rnn-Hg_1763144252
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-340bc4ef67fso3062039a91.3
        for <linux-unionfs@vger.kernel.org>; Fri, 14 Nov 2025 10:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763144252; x=1763749052; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pzz2UQttAdlWuixFQvQcB5l7gTdqlw/lLPJ2vqXTeKA=;
        b=XjnARHzvvQ/eFLkGmnHs41EVamWGMKxy1fhzcA9PJ5dvS16+35cFgCrdS+NFw6ScWD
         3hAq3qDhVgn3cu5HMIsSxa2qjTKfVPrEfR+8morkt0Caul5+PSoGbVpJUK5PbuudIfzB
         rRGGKpoYheQxKdjyHHrRxtqlIhU46BD9mSAs1huITU/tzNomt7ZAFcpjEALBjF2nTTha
         b/1hR9WMReBaXauYs/9eqwHxAeqdc3bevkNXhOct4XcvFBtVZJix2j1cv0tkk+jZCLot
         1dU+NPrZemJm0iXeNrPurBNIZE7hhShDHj8JMV0b1Z1nRctMwwls8gguwgwzevuLfomG
         Rv3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763144252; x=1763749052;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pzz2UQttAdlWuixFQvQcB5l7gTdqlw/lLPJ2vqXTeKA=;
        b=Wgikxg+alryleDPeUAPY7g3myfkczasqifFycKB/lqZJpoM2SgzS1eODcTUgbP7f2U
         ArvkD229dn6YBYIsjAx+jNC7Px2PHVfcLtYqBJKRCjouQGo7hwANtmRVZimH0BJp4VKA
         Ra5NX9DzxvNNajbSCXC7pSYkFPTxohrO7zUFRHs7h8Zlsyy7rTEO2mP96onCvvPyXKkt
         Z5SjbQIHtY9Q8rXL8zrfJj470K+zcY2PzoPL8abbFMaqNxlB94nnmO6x2Rup7VB4PRD3
         3wKhqHN5wOH57aKSUdOdmazTGNgavdnHtz6zB+Rdh+XfO9ibUUPQ6hxZm9v0TL6SnZgE
         C9dA==
X-Forwarded-Encrypted: i=1; AJvYcCVap40VCIXVFi1fNBc+pi8Rmk3kBrr1BG6jl+M33Mrz0l/vk1bMqtOzIHC77ECGMazRZiICbPYXoZoDTDUi@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4aCaE5T+WRdZPcjdXB+47kUchVnM8RtY3eLiOpfshcRzuZkif
	woMjMW/7JtFahhCUUsA4t8CdZqzjDiF68NHleG1GEdqyzgEstdhC4Ii/VxWLC8GWyjumaZ7lc1j
	6PL10lK8UxIZWkQ8Q9ksaT0F5EyuJyQyg+gwbx4cbo29YEJizsNOkV/qfOoectAg9jpk=
X-Gm-Gg: ASbGncvGVU1I5LW5n58R1+0uEGBVso2qnlYDWt4vSuzG0KBQ54I4/Py1SUoZxS5hGYj
	ui1blCJzxZpF1mfMVB8Ix+oDqxcHsUse/zAcNZlKHuVUQmIyrVct+KikQ//SLGQMlqW6h08J2xQ
	LCgal3Cl2lHHm08+vugKeXFB4OTOr+eHnp/5mQ35K1Eqfn0KSgWlfaCP4cNnpIXrJJEMsZ6X8Hm
	0QxxmCbQ1VlgwW3p8oYG6bahf3x/rnsVsCpQeemdmP5i52R9pL8E4Q9Mx0ZSjgjqp0t/436p1Xn
	v0qJewaALwOe2exRcZciNMsxqu4ogLVe80Xgl5km58no3GkM+4JnqDcgPbVnCs31S311NnADVWb
	Bk4CB7nog3xwrGfEXj0/rpyZOSMfd0dEUTxmRllfwLCDzvhfFzA==
X-Received: by 2002:a17:90b:2552:b0:340:ec8f:82d8 with SMTP id 98e67ed59e1d1-343f9ea40c1mr5387256a91.12.1763144252188;
        Fri, 14 Nov 2025 10:17:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFjbz5/Tk+V/W5EZCxxK9X5glUMc6FVN7yj5MlVQPxg1aNXDu8bfP+hR9vNCYaHWNpSrvJ45g==
X-Received: by 2002:a17:90b:2552:b0:340:ec8f:82d8 with SMTP id 98e67ed59e1d1-343f9ea40c1mr5387220a91.12.1763144251605;
        Fri, 14 Nov 2025 10:17:31 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3456518a1a7sm1160636a91.15.2025.11.14.10.17.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 10:17:30 -0800 (PST)
Date: Sat, 15 Nov 2025 02:17:26 +0800
From: Zorro Lang <zlang@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	=?utf-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>,
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] overlay: add tests for casefolded layers
Message-ID: <20251114181726.lbk67ksagcpzt5lk@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20251017170649.2092386-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251017170649.2092386-1-amir73il@gmail.com>

On Fri, Oct 17, 2025 at 07:06:49PM +0200, Amir Goldstein wrote:
> Overalyfs did not allow mounting layers with casefold capable fs
> until kernel v6.17-rc1 and did not allow casefold enabled layers
> until kernel v6.18-rc1.
> 
> Since kernel v6.18-rc1, overalyfs allows this kind of setups,
> as long as the layers have consistent encoding and all the directories
> in the subtree have consistent casefolding.
> 
> Create test cases for the following scenarios:
> - Mounting overlayfs with casefold disabled
> - Mounting overlayfs with casefold enabled
> - Lookup subdir in overlayfs with mismatch casefold to parent dir
> - Change casefold of underlying subdir while overalyfs is mounted
> - Mounting overlayfs with strict enconding, but casefold disabled
> - Mounting overlayfs with strict enconding casefold enabled
> - Mounting overlayfs with layers with inconsistent UTF8 version
> 
> Co-developed-by: André Almeida <andrealmeid@igalia.com>
> Signed-off-by: André Almeida <andrealmeid@igalia.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Zorro,
> 
> This test covers the overlayfs casefold feature that was introduced in
> two steps - casefold disabled layers in 6.17-rc1 and casefold enabled
> layers in 6.18-rc1.
> 
> I think there is less interest in testing the v6.17 changes on their own
> so this test requires support for casefold enabled layers from 6.18-rc1
> and will notrun on kernel < 6.18-rc1:
> 
> generic/999 5s ...  [12:43:16] [12:43:18] [not run]
> 	generic/999 -- overlayfs does not support casefold enabled layers
> 
> If there is a demand, we could split a test for the v6.17 support.
> 
> Note that this test is written as a generic and not an overlay test,
> because we do not have the infrastructure to format and mount a base fs
> with casefold support, so this test can run with e.g. ext4 FSTYP, but it
> will notrun with e.g. xfs FSTYPE:
> 
> generic/999 6s ...  [12:30:03] [12:30:05] [not run]
> 	generic/999 -- xfs does not support casefold feature
> 
> I left the test number 999 for you to re-number.
> If you prefer that I post with another test number assignment in the
> future please let me know.

Hi Amir,

Sorry for this late reviewing, most of this case looks good to me :)

I tried ext4 and f2fs on linux v6.16, v6.17 and v6.18-rc4+, the test
works on them. But when I test on tmpfs (due to _require_scratch_casefold
says tmpfs supports casefold feature), it fails:

FSTYP         -- tmpfs
PLATFORM      -- Linux/x86_64 dell-per750-41 6.18.0-0.rc4.251106gdc77806cf3b47.40.fc44.x86_64+debug #1 SMP PREEMPT_DYNAMIC Thu Nov  6 17:22:41 UTC 2025
MKFS_OPTIONS  -- tmpfs_scratch
MOUNT_OPTIONS -- -o size=1G -o context=system_u:object_r:root_t:s0 tmpfs_scratch /mnt/scratch

generic/999 15s ... - output mismatch (see /root/git/xfstests/results//generic/999.out.bad)
    --- tests/generic/999.out   2025-11-11 09:54:58.168783859 +0800
    +++ /root/git/xfstests/results//generic/999.out.bad 2025-11-15 01:55:37.137507467 +0800
    @@ -11,3 +11,4 @@
     ls: cannot access 'SCRATCH_MNT/ovl-merge/dir/': Stale file handle
     Casefold disabled on subdir after mount
     ls: cannot access 'SCRATCH_MNT/ovl-merge/casefold/subdir': Object is remote
    +Overlayfs mount with strict casefold enabled should have failed
    ...
    (Run 'diff -u /root/git/xfstests/tests/generic/999.out /root/git/xfstests/results//generic/999.out.bad'  to see the entire diff)
Ran: generic/999
Failures: generic/999
Failed 1 of 1 tests

# cat local.config
export FSTYP=tmpfs
export TEST_DEV=tmpfs_test
export TEST_DIR=/mnt/test
export SCRATCH_DEV=tmpfs_scratch
export SCRATCH_MNT=/mnt/scratch

> 
> Thanks,
> Amir.
> 
> 
>  tests/generic/999     | 243 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/999.out |  13 +++
>  2 files changed, 256 insertions(+)
>  create mode 100755 tests/generic/999
>  create mode 100644 tests/generic/999.out
> 

[snip]

> +# Create lowerdir, upperdir and workdir without casefold enabled
> +lowerdir="$SCRATCH_MNT/ovl-lower"
> +upperdir="$SCRATCH_MNT/ovl-upper"
> +workdir="$SCRATCH_MNT/ovl-work"
> +merge="$SCRATCH_MNT/ovl-merge"
> +
> +mount_casefold_version()
> +{
> +	option="casefold=$1"
> +	mount -t tmpfs -o $option tmpfs $2
> +}
> +
> +mount_overlay()
> +{
> +	local lowerdirs=$1
> +
> +	_mount -t overlay overlay $merge \
> +		-o lowerdir=$lowerdirs,upperdir=$upperdir,workdir=$workdir
> +}
> +
> +unmount_overlay()
> +{
> +	_unmount $SCRATCH_MNT/ovl-merge 2>/dev/null
                 ^^^^^^^^^^^^^^^^^^^^^^
                 $merge ?

> +}
> +
> +# Try to mount an overlay with casefold enabled layers.
> +# On kernels older than v6.18 expect failure and skip the test
> +mkdir -p $merge $upperdir $workdir $lowerdir
> +_casefold_set_attr $upperdir >>$seqres.full
> +_casefold_set_attr $workdir >>$seqres.full
> +_casefold_set_attr $lowerdir >>$seqres.full
> +mount_overlay $lowerdir >>$seqres.full 2>&1 || \
> +	_notrun "overlayfs does not support casefold enabled layers"
> +unmount_overlay

[snip]

> +MNT1="$testdir/mnt1"
> +MNT2="$testdir/mnt2"
> +
> +mkdir $MNT1 $MNT2 "$testdir/merge"
> +
> +mount_casefold_version "utf8-12.1.0" $MNT1
> +mount_casefold_version "utf8-11.0.0" $MNT2
> +
> +mkdir "$MNT1/dir" "$MNT2/dir"
> +
> +_casefold_set_attr "$MNT1/dir"
> +_casefold_set_attr "$MNT2/dir"
> +
> +mkdir "$MNT1/dir/lower" "$MNT2/dir/upper" "$MNT2/dir/work"
> +
> +upperdir="$MNT2/dir/upper"
> +workdir="$MNT2/dir/work"
> +lowerdir="$MNT1/dir/lower"
> +
> +mount_overlay $lowerdir >>$seqres.full 2>&1  && \
> +	echo "Overlayfs mount different unicode versions should have failed" && \
> +	unmount_overlay
> +
> +umount $MNT1
> +umount $MNT2

I think we can make sure $MNT1 and $MNT2 are unmounted in _cleanup phase,
as what you did for $merge in _cleanup.

Thanks,
Zorro

> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/999.out b/tests/generic/999.out
> new file mode 100644
> index 00000000..ce383d94
> --- /dev/null
> +++ b/tests/generic/999.out
> @@ -0,0 +1,13 @@
> +QA output created by 999
> +Casefold disabled
> +Casefold enabled after mount
> +ls: cannot access 'SCRATCH_MNT/ovl-merge/subdir': Stale file handle
> +Casefold enabled lower dir
> +Casefold enabled lower subdir
> +ls: cannot access 'SCRATCH_MNT/ovl-merge/casefold/subdir': Object is remote
> +Casefold enabled upper dir
> +Casefold enabled
> +Casefold disabled on lower after mount
> +ls: cannot access 'SCRATCH_MNT/ovl-merge/dir/': Stale file handle
> +Casefold disabled on subdir after mount
> +ls: cannot access 'SCRATCH_MNT/ovl-merge/casefold/subdir': Object is remote
> -- 
> 2.50.1
> 

