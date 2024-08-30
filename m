Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901561B583F;
	Fri, 30 Aug 2024 19:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725047165; cv=none; b=mQEhPHBsI+BKZ2pQVDjxdCgz33hKLraXX/3LHb4sV20vQL+6vi2FPM01+1KIPbNW3PJNCFm4XUogaevHBFnyqgoyOK7ZBZjXFwGxx3Xlo1bIAUdErG0M1vhd520S8KwS4c0j/Se9/r4rE35EGgIK4B8Y5BiRZSokaBWxDRlqwns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725047165; c=relaxed/simple;
	bh=yacoRN4lhoE+G3Z7siJhVjuY7CdOTpVhPjUYv3HH6rc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CJRC91sNJkPOi2V2E2Z1pUak4tEwc3aoCj73W4OSeaGhRiBdsHusK1sPbZaszaGzTM4iNqcdcHehzKl3KYQloeXs1rs4vZ/O8Fvr787/CsXwef2hRRYLVLk+b5VhXrmvsR6GG/+VsbXorngGt5bBBv7xBqT0aMU9kgs84+XY6us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xuem+mZu; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xuem+mZu"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5353cd18c20so2672811e87.0;
        Fri, 30 Aug 2024 12:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725047162; x=1725651962; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PCK31f6nMFSZIQVq2dpwLwpb6hFH6JVgA/GmCF/iUJ8=;
        b=Xuem+mZucZnpNBes+SYdmiF9fqHPPr45kobbb4P8+3xOiyDqcee/coiDWL9ydlqwCj
         B+RdV8oAbOylnmXTAONvOz99BjWGduRVx0O004KM8XCnhOout4CqQy2hiGNl+jzicm8y
         ePDr7r3Shf87cz6M0Thro0lK708LhB/BH1JYU48zGT47dblhTUrSAgDickjwj4Xvb75D
         ++ey/ySAm+2kB9GmS0ZpsPhREiiGXRS7LcpQU1qTtBpkPt4rGlwUPHITAJ5h5VQVchWQ
         O9n9FgEgFaRPKpGQ51DPzUcckTbAPl6RKKhMq+BtNA4Vqir+PrtyAuVyEyPdHFa9NL4S
         H8tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725047162; x=1725651962;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PCK31f6nMFSZIQVq2dpwLwpb6hFH6JVgA/GmCF/iUJ8=;
        b=sO/8DUZbCkq4eDA22SRxC4p7NRUDiIGZRvOQAW2yme5H6nOfg3Htsjxccp5N6Li5tI
         1Qk7d08NZtMJSVyyNM7dg7/6TW+9xqbLRpw7yIqySyExz/mfWpa6+FP6FVrqqziFMEeU
         hmdzfr9SfCwG/osxq6sSjyUNQ4mSf7+rRA/Zyv/IUWw9Ozh1rww/8XXctID50uttxsoj
         dWOMh/9u6z/mPNWK5H2oOFTBXh4KOCgi7Ob3RVrtPPYmLozq2xJFV/GBhf0y2jRMNxix
         205enc9xBYzTbF/z0fevTIthQtRLw3TQyok6MueLEoRimzQ3kgZB8FFm4xJA6Q06s/BQ
         FIHQ==
X-Forwarded-Encrypted: i=1; AJvYcCUlCiDeAmzqLue8kMHv8NwdMOfsLtpxORMAyerDlJWr5wZU+5iBOl8U4c26EpRvSTAlrNO6eEC2@vger.kernel.org, AJvYcCWQCZIKbHq1HvOwMoh+NbkrErhpaH83AxKlPEEvEU/go49/9ENXURwxdCN2nNeYmZrwnGFmS+Jdbjt9skSyOQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1kmVdDivd2xpDjjhY0LjA8NdFBRpIRduj7qWzRbA1oH4s5bBZ
	coqWLxFIctWWtMC7GjxFd76VaWi3X+zQkIn2lPrN+uzR2Ms/U+yMJc4ipvup
X-Google-Smtp-Source: AGHT+IFFL5Y7lf70w/UB85jkmhmGVxj7GF1VTsTeI0YZrcbuMPLoqyCLTKzNiLd3iPHdW2dIxlxU7Q==
X-Received: by 2002:a05:6512:1047:b0:52c:c5c4:43d2 with SMTP id 2adb3069b0e04-53546b910a0mr2456721e87.47.1725047160831;
        Fri, 30 Aug 2024 12:46:00 -0700 (PDT)
Received: from amir-ThinkPad-T480.arnhem.chello.nl (92-109-99-123.cable.dynamic.v4.ziggo.nl. [92.109.99.123])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c226ce9326sm2202964a12.95.2024.08.30.12.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2024 12:46:00 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH] overlay: deprecate test t_truncate_self
Date: Fri, 30 Aug 2024 21:45:46 +0200
Message-Id: <20240830194546.860173-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since kernel commit 2a010c412853 ("fs: don't block i_writecount during
exec"), truncating an executable file while it is being executed is
allowed. Therefore, the test t_truncate_self now fails, so remove it.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Zorro,

This is a fix for a test regression since v6.11-rc1.
My fix is to deprecate the test, because the change of behavior is
desired (at least until a non test user complains).

Thanks,
Amir.

 .gitignore            |  1 -
 src/Makefile          |  2 +-
 src/t_truncate_self.c | 26 --------------------------
 tests/overlay/013     | 41 -----------------------------------------
 tests/overlay/013.out |  2 --
 5 files changed, 1 insertion(+), 71 deletions(-)
 delete mode 100644 src/t_truncate_self.c
 delete mode 100755 tests/overlay/013
 delete mode 100644 tests/overlay/013.out

diff --git a/.gitignore b/.gitignore
index 36083e9d..94f6b564 100644
--- a/.gitignore
+++ b/.gitignore
@@ -171,7 +171,6 @@ tags
 /src/t_snapshot_deleted_subvolume
 /src/t_stripealign
 /src/t_truncate_cmtime
-/src/t_truncate_self
 /src/test-nextquota
 /src/testx
 /src/trunc
diff --git a/src/Makefile b/src/Makefile
index b3da59a0..52299b4c 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -13,7 +13,7 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
 	godown resvtest writemod writev_on_pagefault makeextents itrash rename \
 	multi_open_unlink unwritten_sync genhashnames t_holes \
 	t_mmap_writev t_truncate_cmtime dirhash_collide t_rename_overwrite \
-	holetest t_truncate_self af_unix t_mmap_stale_pmd \
+	holetest af_unix t_mmap_stale_pmd \
 	t_mmap_cow_race t_mmap_fallocate fsync-err t_mmap_write_ro \
 	t_ext4_dax_journal_corruption t_ext4_dax_inline_corruption \
 	t_ofd_locks t_mmap_collision mmap-write-concurrent \
diff --git a/src/t_truncate_self.c b/src/t_truncate_self.c
deleted file mode 100644
index a11f7d5a..00000000
--- a/src/t_truncate_self.c
+++ /dev/null
@@ -1,26 +0,0 @@
-#include <stdio.h>
-#include <string.h>
-#include <errno.h>
-#include <unistd.h>
-#include <libgen.h>
-
-int main(int argc, char *argv[])
-{
-	const char *progname = basename(argv[0]);
-	int ret;
-
-	ret = truncate(argv[0], 4096);
-	if (ret != -1) {
-		if (argc == 2 && strcmp(argv[1], "--may-succeed") == 0)
-			return 0;
-		fprintf(stderr, "truncate(%s) should have failed\n",
-			progname);
-		return 1;
-	}
-	if (errno != ETXTBSY) {
-		perror(progname);
-		return 1;
-	}
-
-	return 0;
-}
diff --git a/tests/overlay/013 b/tests/overlay/013
deleted file mode 100755
index 73c72c30..00000000
--- a/tests/overlay/013
+++ /dev/null
@@ -1,41 +0,0 @@
-#! /bin/bash
-# SPDX-License-Identifier: GPL-2.0
-# Copyright (c) 2016 Red Hat Inc.  All Rights Reserved.
-#
-# FS QA Test 013
-#
-# Test truncate running executable binaries from lower and upper dirs.
-# truncate(2) should return ETXTBSY, not other errno nor segfault
-#
-# Commit 03bea6040932 ("ovl: get_write_access() in truncate") fixed this issue.
-. ./common/preamble
-_begin_fstest auto quick copyup
-
-# Import common functions.
-. ./common/filter
-
-_require_scratch
-_require_test_program "t_truncate_self"
-
-# remove all files from previous runs
-_scratch_mkfs
-
-# copy test program to lower and upper dir
-lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
-upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
-mkdir -p $lowerdir
-mkdir -p $upperdir
-cp $here/src/t_truncate_self $lowerdir/test_lower
-cp $here/src/t_truncate_self $upperdir/test_upper
-
-_scratch_mount
-
-# run test program from lower and upper dir
-# test programs truncate themselfs, all should fail with ETXTBSY
-$SCRATCH_MNT/test_lower --may-succeed
-$SCRATCH_MNT/test_upper
-
-# success, all done
-echo "Silence is golden"
-status=0
-exit
diff --git a/tests/overlay/013.out b/tests/overlay/013.out
deleted file mode 100644
index 3e66423b..00000000
--- a/tests/overlay/013.out
+++ /dev/null
@@ -1,2 +0,0 @@
-QA output created by 013
-Silence is golden
-- 
2.34.1

