Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D9E165EFC
	for <linux-unionfs@vger.kernel.org>; Mon,  2 Sep 2024 20:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725307328; cv=none; b=jqI6Gt3BJLiZ4aSkyPy+pOTqSef3o74YhafoEepaNvNwg4OFyxN7v7gQRj5XWJozJAMoJ0DcXepDKtfICXTU4eXAn4Aczk8I2zH718fKBvJaBUkoduhan15jalFXCbKZD5XLhtHlW2VAgT2E1AehavEfAwnsGbxrPAGPwRU2z+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725307328; c=relaxed/simple;
	bh=B8l9vK94wsr/7yzQLlIvuwVTuaWU1bZ5ob7a2hMyZxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BRY7Eho8UMz8tvRuD9fTRvlAVJ0r3FWhFoQLRo/WYzZ08hoTEPipW8Xk6uohZ5b7BOMLhh2KDvHZzVtVHuADs37lv2Rs53hO4QPmNjiq2dLu0psCyaCsST4Gp0E+UglXWOm+Z8sI2DXYLjlZVHpxaRUklrTT3yJD5j31pkuvJ4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AWr+tCHp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AWr+tCHp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725307325;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SktQhWwnMk38o7Gp9igxhv0oK7DU7a4P/ff81aiY+2s=;
	b=AWr+tCHpQKpm3Rp5AtQOBiYDp5K9JhjP/gR8WZr2xxc3BH4uZukkkFWTE4hfO6UZ8rxZkB
	AcsEoXoLmFiGO8314MGTC7KipNPpCKwgwJhJv5ia4XBYP6NiuPPLTzrC1+EVnMmXjK5DUr
	8SIKRoGCKjHsml9vQdJOg39762iwCdM=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-148-2VQyMu_TPuWjrtf3iYJvIw-1; Mon, 02 Sep 2024 16:02:04 -0400
X-MC-Unique: 2VQyMu_TPuWjrtf3iYJvIw-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-7c6a9c1a9b8so4081249a12.0
        for <linux-unionfs@vger.kernel.org>; Mon, 02 Sep 2024 13:02:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725307323; x=1725912123;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SktQhWwnMk38o7Gp9igxhv0oK7DU7a4P/ff81aiY+2s=;
        b=lzX6tZEMJ06nxLb/33Pnz2cRunInhEvFDlggYLC/Wsrkgz/zi0dZ/lbRAldXtr/x96
         yBIYB7MzQit69hysAlwxy4t+XiUgqualH0kSHBBfikdhqPP4iF5ZjCAHUJ9kvUwAgdFO
         auwr28nGCMMvEYuWBvrETco03nByC6gfQi628S8t8hDhKSOSZ6q04UHYzSlbWbLWlWmf
         4kjun0ZFE+io3gzGyR+fxFvKdSwVJrxajtuLv6/hb78A0xhfd7F4yZd7H3eQX1P3k1JB
         jmRgy8TBtx5EOAg1JCueSMCR6BRBn9qfIjMqrEoPsuZZmrECoKRfs8pnSb2glZ+m7pJ6
         sfMg==
X-Forwarded-Encrypted: i=1; AJvYcCUKWzCZBFQQPZYNkQMAYwvCGQpaV/uKNj3wiin98LqmKTgAuug8i7OdPz1Vw4CLhOaxisXQ+ztakDbXF0d3@vger.kernel.org
X-Gm-Message-State: AOJu0Ywz5zUQJEoISl0XJxeQ1SwBIpc2u+J504x7g2cVsPLdNwEf5ZwE
	nA2RYpWAuZpx6HvNQvg8hJUKyFWDA3Fa1xoUhCwP5OCWbwXf00OMS6M8/Uq+RCCLCD+aQ1a09O1
	euXxAs7U56BsoZvTLx7t4v1N/pIhmHZ63ZS3hBIDC6Mghcr7PKsY6HfMUmFLRxo402zGUxFAIyQ
	==
X-Received: by 2002:a17:903:2289:b0:205:5fb6:2aba with SMTP id d9443c01a7336-2055fc571cbmr52123355ad.30.1725307323428;
        Mon, 02 Sep 2024 13:02:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEUMIBi3bozBzSkdveoyiMPH/9gW+EXFvJ9TAl8H7qfB/am6vTf1jFFxEGh2vDSznwdXYwG/w==
X-Received: by 2002:a17:903:2289:b0:205:5fb6:2aba with SMTP id d9443c01a7336-2055fc571cbmr52122865ad.30.1725307322764;
        Mon, 02 Sep 2024 13:02:02 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2056912c543sm25008785ad.247.2024.09.02.13.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2024 13:02:02 -0700 (PDT)
Date: Tue, 3 Sep 2024 04:01:59 +0800
From: Zorro Lang <zlang@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH] overlay: deprecate test t_truncate_self
Message-ID: <20240902200159.vtfgnh4zdsnvdyd7@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240830194546.860173-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240830194546.860173-1-amir73il@gmail.com>

On Fri, Aug 30, 2024 at 09:45:46PM +0200, Amir Goldstein wrote:
> Since kernel commit 2a010c412853 ("fs: don't block i_writecount during
> exec"), truncating an executable file while it is being executed is
> allowed. Therefore, the test t_truncate_self now fails, so remove it.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Zorro,
> 
> This is a fix for a test regression since v6.11-rc1.
> My fix is to deprecate the test, because the change of behavior is
> desired (at least until a non test user complains).


Makes sense to me,
Reviewed-by: Zorro Lang <zlang@redhat.com>

> 
> Thanks,
> Amir.
> 
>  .gitignore            |  1 -
>  src/Makefile          |  2 +-
>  src/t_truncate_self.c | 26 --------------------------
>  tests/overlay/013     | 41 -----------------------------------------
>  tests/overlay/013.out |  2 --
>  5 files changed, 1 insertion(+), 71 deletions(-)
>  delete mode 100644 src/t_truncate_self.c
>  delete mode 100755 tests/overlay/013
>  delete mode 100644 tests/overlay/013.out
> 
> diff --git a/.gitignore b/.gitignore
> index 36083e9d..94f6b564 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -171,7 +171,6 @@ tags
>  /src/t_snapshot_deleted_subvolume
>  /src/t_stripealign
>  /src/t_truncate_cmtime
> -/src/t_truncate_self
>  /src/test-nextquota
>  /src/testx
>  /src/trunc
> diff --git a/src/Makefile b/src/Makefile
> index b3da59a0..52299b4c 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -13,7 +13,7 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
>  	godown resvtest writemod writev_on_pagefault makeextents itrash rename \
>  	multi_open_unlink unwritten_sync genhashnames t_holes \
>  	t_mmap_writev t_truncate_cmtime dirhash_collide t_rename_overwrite \
> -	holetest t_truncate_self af_unix t_mmap_stale_pmd \
> +	holetest af_unix t_mmap_stale_pmd \
>  	t_mmap_cow_race t_mmap_fallocate fsync-err t_mmap_write_ro \
>  	t_ext4_dax_journal_corruption t_ext4_dax_inline_corruption \
>  	t_ofd_locks t_mmap_collision mmap-write-concurrent \
> diff --git a/src/t_truncate_self.c b/src/t_truncate_self.c
> deleted file mode 100644
> index a11f7d5a..00000000
> --- a/src/t_truncate_self.c
> +++ /dev/null
> @@ -1,26 +0,0 @@
> -#include <stdio.h>
> -#include <string.h>
> -#include <errno.h>
> -#include <unistd.h>
> -#include <libgen.h>
> -
> -int main(int argc, char *argv[])
> -{
> -	const char *progname = basename(argv[0]);
> -	int ret;
> -
> -	ret = truncate(argv[0], 4096);
> -	if (ret != -1) {
> -		if (argc == 2 && strcmp(argv[1], "--may-succeed") == 0)
> -			return 0;
> -		fprintf(stderr, "truncate(%s) should have failed\n",
> -			progname);
> -		return 1;
> -	}
> -	if (errno != ETXTBSY) {
> -		perror(progname);
> -		return 1;
> -	}
> -
> -	return 0;
> -}
> diff --git a/tests/overlay/013 b/tests/overlay/013
> deleted file mode 100755
> index 73c72c30..00000000
> --- a/tests/overlay/013
> +++ /dev/null
> @@ -1,41 +0,0 @@
> -#! /bin/bash
> -# SPDX-License-Identifier: GPL-2.0
> -# Copyright (c) 2016 Red Hat Inc.  All Rights Reserved.
> -#
> -# FS QA Test 013
> -#
> -# Test truncate running executable binaries from lower and upper dirs.
> -# truncate(2) should return ETXTBSY, not other errno nor segfault
> -#
> -# Commit 03bea6040932 ("ovl: get_write_access() in truncate") fixed this issue.
> -. ./common/preamble
> -_begin_fstest auto quick copyup
> -
> -# Import common functions.
> -. ./common/filter
> -
> -_require_scratch
> -_require_test_program "t_truncate_self"
> -
> -# remove all files from previous runs
> -_scratch_mkfs
> -
> -# copy test program to lower and upper dir
> -lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
> -upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
> -mkdir -p $lowerdir
> -mkdir -p $upperdir
> -cp $here/src/t_truncate_self $lowerdir/test_lower
> -cp $here/src/t_truncate_self $upperdir/test_upper
> -
> -_scratch_mount
> -
> -# run test program from lower and upper dir
> -# test programs truncate themselfs, all should fail with ETXTBSY
> -$SCRATCH_MNT/test_lower --may-succeed
> -$SCRATCH_MNT/test_upper
> -
> -# success, all done
> -echo "Silence is golden"
> -status=0
> -exit
> diff --git a/tests/overlay/013.out b/tests/overlay/013.out
> deleted file mode 100644
> index 3e66423b..00000000
> --- a/tests/overlay/013.out
> +++ /dev/null
> @@ -1,2 +0,0 @@
> -QA output created by 013
> -Silence is golden
> -- 
> 2.34.1
> 

