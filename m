Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98654EB2E;
	Sat,  3 Feb 2024 08:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706947956; cv=none; b=TeM3j1PjHDqbeVQcFiyBglY6VQ5ErE2bIU0i5sagO7a1mGos/gHwHSSiUwYyVZfVlSB2xdOThkmnej1MNhXg9LnjonzY8PXjyZ4NJOcfz2mr9yELmpvHxlVXMWiCzulpYTDR+21nVXRDuFsPt7ZASzrYTYPJlVYwCItVYujxQOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706947956; c=relaxed/simple;
	bh=ikPZ5zkmsFFcqFxxWf9OWGX1blrGNmVfI7oauxcHJTQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=t90P62sENWxu8zOBNN6nO/4RRpqkLHrcqS26xrjdMGEMY5cVFCsxO0QQ/UAYzDIzXe0hthpROUqKMW7MrCghzG2AavMtmvuzAoQ0/HPThZb3EMSQO+V1CqHwueMj/DSHaHgzYv3zUlOEI+Sqij0GZZNdyC3iGYHrHEKUGdtQ6mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F1bFrvFX; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F1bFrvFX"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-40fb94d42e4so21989985e9.2;
        Sat, 03 Feb 2024 00:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706947953; x=1707552753; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4B4yVk7R4ltaRKppNYv78/2Ny52aC23vDArqAHZjJRE=;
        b=F1bFrvFXPuDrADjj6pss33tQzsDA3/wjxZHrgwbpbWN2li08/55dO/od2jWxfJpyn9
         PQbL8X0J2MGBLshee7C79hEUFRWUidUuzfjNxvZBOZtXF2d+Y4hFj8ms83sjg6Pk8uZ/
         RlQLW9xZdETI5DXbBd1JtSv+/Pu+5VkNyCGVcm9b+5HIqn6pq9fJQk/uwChBd8jQSyYi
         g0YxQG5PvzZCJZVZp+oNsKs1rYzbqurmqVwmVfNXJyJflKbW+Ag6jzZeJkLpiVm2E9uY
         FpmzwrY4Owo2ZVPuX8QT92RHJJDG+hPjQp8bpuAbYS3qbwbHQ6/+RgsesU4kPoVwCewO
         oHVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706947953; x=1707552753;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4B4yVk7R4ltaRKppNYv78/2Ny52aC23vDArqAHZjJRE=;
        b=meT77780VpLgk8Ok+dB/k3liM1lSUbvJa+yRGGlF4sOUMOKc+SHEhQNVjvooYXQv7B
         7f3SFame1PGT7up7xLxk5kaJastkJjqpoTNjn86mPfR/l/cdgxVsMZbm5+Q1RDIysByM
         g2XlLUyHiFy/otdPQ306yLktCMUm3w5AsBprX5YqCdG3+lQhceApudDRWJlz62V2vpFL
         TPcni3emNoO0lyyPJGtg4fHwc1UpTehmjRF4GL2Ul5iKQb+JJepEe8DSLFGZ4oqqkz4v
         Pyr9sO1bpcy4FtDaUtmFWDlqAJFfc3FUhwNB0/yZW7nYtlKVrzHVvz2XsxOknRI/fkyA
         3OuQ==
X-Gm-Message-State: AOJu0YyOHOyFAXvGfTave8VX4lTT44keTFOQxN+T0G+Xo/5ttRVDAPyu
	B14SJz9hgq0/YKx+g2CwnW9R7h4vL1CRh819hTRcM86G9STRaDm0
X-Google-Smtp-Source: AGHT+IGh0nV/u3+p6qSpzEbN/RE50qBWZD0kcYJzHAdy3xvx2cyxQxqUhqPkonXTGto21cGo1gc0QQ==
X-Received: by 2002:a05:600c:1d23:b0:40f:2d7:287c with SMTP id l35-20020a05600c1d2300b0040f02d7287cmr495143wms.8.1706947952714;
        Sat, 03 Feb 2024 00:12:32 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCUs2Nf+PV17Sjs8KLJH+2Mjxt9D0dYwFAMQ7VJ4PiC1EqrOQUpL7fbS1vftIJoEfW7/JcELzzZDQejVmvClDXSYdi27vcIyiuHtH4c5WvAEk7yIm1snUAVi0kqkEMVo2yrqgbuSS5EwAAH3wO0RIoV/Vpkop6Sr4nI=
Received: from amir-ThinkPad-T480.lan (46-117-242-41.bb.netvision.net.il. [46.117.242.41])
        by smtp.gmail.com with ESMTPSA id i11-20020a05600c354b00b0040fc76ed923sm2157637wmq.6.2024.02.03.00.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Feb 2024 00:12:32 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Alexander Larsson <alexl@redhat.com>,
	linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH] overlay/084: Fix test to match new xwhiteouts dir on-disk format
Date: Sat,  3 Feb 2024 10:12:28 +0200
Message-Id: <20240203081228.1725872-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The xwhiteouts feature, which is tested in this test, was added to
overlayfs in kernel v6.7.

The on-disk format of the xwhiteouts directory was changed in kernel
v6.8-rc2, specfically by commit 420332b94119 ("ovl: mark xwhiteouts
directory with overlay.opaque='x'") and backported to kernel v6.7.3,
so this test now fails on kernel >= v6.8-rc2 and => v6.7.3.

Adapt the test to the new on-disk format and add a hint to make sure
that the on-disk format change is backported to v6.7 based kernels.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/084 | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tests/overlay/084 b/tests/overlay/084
index 8465caeb..778396a1 100755
--- a/tests/overlay/084
+++ b/tests/overlay/084
@@ -25,6 +25,11 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs overlay
+# This test does not run on kernels prior ro v6.7 and now it will also make sure
+# that the following on-disk format change was backported to v6.7 based kernels
+_fixed_by_kernel_commit 420332b94119 \
+	"ovl: mark xwhiteouts directory with overlay.opaque='x'"
+
 # We use non-default scratch underlying overlay dirs, we need to check
 # them explicity after test.
 _require_scratch_nocheck
@@ -115,7 +120,8 @@ do_test_xwhiteout()
 
 	mkdir -p $basedir/lower $basedir/upper $basedir/work
 	touch $basedir/lower/regular $basedir/lower/hidden  $basedir/upper/hidden
-	setfattr -n $prefix.overlay.whiteouts -v "y" $basedir/upper
+	# overlay.opaque="x" means directory has xwhiteout children
+	setfattr -n $prefix.overlay.opaque -v "x" $basedir/upper
 	setfattr -n $prefix.overlay.whiteout -v "y" $basedir/upper/hidden
 
 	# Test the hidden is invisible
-- 
2.34.1

