Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824F418C06
	for <linux-unionfs@vger.kernel.org>; Thu,  5 Jun 2025 17:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749145219; cv=none; b=jo2HYtNXkLzr+d4S5B0Yuyk9Q71bb3I3jfVcH7wzu6s8qURoCEOL6T3S0oxu9Z10J3z6ZweXatyFrLyyt6UoQ3YOvaMapCynzJQZfj47UvMkTs0OOtrf5zV4ff/y3RiJ5VIMqKv7CFMHKDbnws+XOvx7zEKTi1Do6My/8ahwCW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749145219; c=relaxed/simple;
	bh=RgKv1r9IMVTt3VDeHdXbu+22e54VLGyQXnhS0LiTUJI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TViZJLmCdHxJetH0wiwVWDkUBNJ78Io7Pl4OF7CCQRSXLyrXXzOLhvTuvQJWTpbeX2LcQE/zzXtJxxYCGbeH/71hIm0mxK4L7ubzrbew4vZGYhdws0gjyRINUYr/Yws3Ez7Rl6a5S3P0ZWvp69WnFwF2lBpnenMPa3oAesWgkuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TgwAAJXA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TgwAAJXA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749145215;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vwlg6lBxqGffvf2DWVfbPKyt1snNbKUQBjmobD4isok=;
	b=TgwAAJXAxcc4QmNhrz5BhdhHE83O/gn9yFU5Vse7hi2Tq3JmCd2uKbba1aDC5KLMfuX7fN
	7LQEnMkXaN7plcYb4wm3YsvPKygEK1zjKeXhgBq9Jl6RqWMOOGG2F3aBkKHXwYoNB8U9Lp
	3Q6sr4o8M5EZGqdJQhALHX5mE9xa1jY=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-404-j3ZSte6bM0WLhzlN0KdLSA-1; Thu, 05 Jun 2025 13:40:12 -0400
X-MC-Unique: j3ZSte6bM0WLhzlN0KdLSA-1
X-Mimecast-MFC-AGG-ID: j3ZSte6bM0WLhzlN0KdLSA_1749145211
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-234906c5e29so14255355ad.0
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Jun 2025 10:40:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749145211; x=1749750011;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vwlg6lBxqGffvf2DWVfbPKyt1snNbKUQBjmobD4isok=;
        b=fVpR5PIQh4KLXikO14MHqINLvuF10G3JX7c4q2RI4aVIFn3K1le8jT94n8kOaD5Anw
         2o8IkXYKNb882orrMe6HyPfuZ++ULgUNvmYPFURMetlQ86IWJiOam+GDxiqMc5tC3xHe
         qceQV327uej1sri2kcFprqSmLEqqiV2z9IeSxoHZ9vdq2RhDc28I1lymzTjGT8s6uM3K
         i4E9picPwJDEvK5ERQUfuDbx6atCGoEpn9u0b+jRxAAeDTpqlntp4XVkFXjx1KAHO9RJ
         uZ4fgY4N8grYF0TOQ8kfox9Ypjg6wTixjKNbOZ2TL2qnYXIpk4Cjn7P9KrCMeXrHT3be
         7SIA==
X-Forwarded-Encrypted: i=1; AJvYcCWuHxFFFoSVDYYM3+Z2aepS65zwTTB4IZo0/Qebvrba3xhYWRT5UCLX0uwj8xqe2+4jn63t7hHXjPVxDwoz@vger.kernel.org
X-Gm-Message-State: AOJu0YyXCLEvOUKKcyH8e30uyUHJ48P1/PS0icKSTFxOCMkdA4uFl//w
	ZHbCLMcK6yF/6WrT8z5Nfit6PXQyU2BLp7UbhJ4eeZMIR2P6KN3DAbw/lWORbO9haL7g7KIjoio
	pftUsP4KGXj1dru1A+Ui9S/lQYTXCDFlnskg947EFklfwssS0RjL9wdYzoRQ3pjak21E=
X-Gm-Gg: ASbGncsezO9VHMO6hDOc5Sy4yIPkIG1zegqqZHvX3JEE67u/3bDpkBsckNfXVW8mFEs
	77yCVtcx315q5HH6sYs8Ga+jjgsNclAXQZFUSoXQduGKOp4z7Pg3TcYuvV2b9bo31HQemKQ5uXi
	Kt/qvwjxRvFdISNoyl1DEcVdg0JSSoujJOGC78z4b1tleWzRFCyyeY6FaItgS105FgdMhu5Hwy+
	lQPDlwoi+LO/voG/Dmma020lMoB/8afvIfgSWiqCg1KERxtSHaHJDiV9RQ25YcAkgL/zx8snG64
	T7bSWUUnn5DEoji5KuiMqRhWSKRr853G1GdGBY0AbpUAJVn1BdGG
X-Received: by 2002:a17:903:2c9:b0:234:d778:13fa with SMTP id d9443c01a7336-23601d13585mr3047995ad.26.1749145211091;
        Thu, 05 Jun 2025 10:40:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFpVCJ3fno+BTFvqglRT+vOva1GLEiRKThNEttAa7fgb6sGBQnKHmEA7g9ycLT/9vb9cdIqkg==
X-Received: by 2002:a17:903:2c9:b0:234:d778:13fa with SMTP id d9443c01a7336-23601d13585mr3047735ad.26.1749145210790;
        Thu, 05 Jun 2025 10:40:10 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23506cd34f9sm122066655ad.157.2025.06.05.10.40.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 10:40:10 -0700 (PDT)
Date: Fri, 6 Jun 2025 01:40:06 +0800
From: Zorro Lang <zlang@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	=?utf-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>,
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v2 3/6] generic/604: do not run with overlayfs
Message-ID: <20250605174006.6wu7axncn2ytdf55@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250603100745.2022891-1-amir73il@gmail.com>
 <20250603100745.2022891-4-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250603100745.2022891-4-amir73il@gmail.com>

On Tue, Jun 03, 2025 at 12:07:42PM +0200, Amir Goldstein wrote:
> Overlayfs does not allow mounting over again with the same layers
> until umount is fully completed, so is not appropriate for this test
> which tries to mount in parallel to umount.
> 
> This is manifested as the test failure below when overlayfs strict mount
> checks are enabled by enabling the index feature:
> 
> $ echo Y > /sys/module/overlay/parameters/index
> ...
>     +mount: /vdf/ovl-mnt: /vdf already mounted or mount point busy.
>     +       dmesg(1) may have more information after failed mount system call.
>     +mount /vdf /vdf/ovl-mnt failed
> 
> Opt-out of this test with overlayfs and remove the hacks that were placed
> by commit 06cee932 ("generic/604: Fix for overlayfs") to make the test pass
> with overlayfs in the first place.
> 
> Tested-by: André Almeida <andrealmeid@igalia.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---

Good to me,

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/generic/604 | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/tests/generic/604 b/tests/generic/604
> index 744d3456..481250fd 100755
> --- a/tests/generic/604
> +++ b/tests/generic/604
> @@ -13,6 +13,9 @@ _begin_fstest auto quick mount
>  # Import common functions.
>  . ./common/filter
>  
> +# Overlayfs does not allow mounting over again with the same layers
> +# until umount is fully completed, so is not appropriate for this test.
> +_exclude_fs overlay
>  
>  # Modify as appropriate.
>  _require_scratch
> @@ -22,11 +25,9 @@ _scratch_mount
>  for i in $(seq 0 500); do
>  	$XFS_IO_PROG -f -c "pwrite 0 4K" $SCRATCH_MNT/$i >/dev/null
>  done
> -# For overlayfs, avoid unmounting the base fs after _scratch_mount tries to
> -# mount the base fs.  Delay the mount attempt by a small amount in the hope
> -# that the mount() call will try to lock s_umount /after/ umount has already
> -# taken it.
> -_unmount $SCRATCH_MNT &
> +# Delay the mount attempt by a small amount in the hope that the mount() call
> +# will try to lock s_umount /after/ umount has already taken it.
> +_scratch_unmount &
>  sleep 0.01s ; _scratch_mount
>  wait
>  
> -- 
> 2.34.1
> 

