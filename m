Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793626225;
	b=5eLx20qBOLeEAIXq0IlnYxhl7/G5BFaNzl5XQMktAxc3CcfXWU/iSQWaJDwxhHnj5f0h
	 F7LZZUWqVej5w3+2PTmR/CUM4GOU0Zu77JRdcdOvv+5aXcOI9lBS0S4XQTqW0fS76mBMN
	 amT+5dj+Tz30qHdJ/JwrlHvq+SBB7hCV4qe6AtZcJ5iArfPRxtoWKC/kyY0Pad7zskOmR
	 +qR3vy4AkAu3MrQJ4LdW9oNnFwuP/DxgqgZIJox3OWJdFZd65tJKt03rVMNFjbbcEhjkD
	 ON2CJNOMnCOlU9SfXLB1oEGLZJPzwEPz5vqNM7Vhw7EDDEEE+u9pOr6udBEr+oS1I1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793626225;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=MbpiROGQuzVONeXp96zntA9ceKse3+uC6QJ979xAbqY=;
	b=e9RtVr+dGe/CJhNqHbNBKDHZCVt3HZi6VRT0W9ONgmDtF889WMfW5fzeOkOyzCURTrbi
	 gDnT9jKFFWo82ASoqN3yBhqFSzmu9jQvaiHh7iz40lOoz65tnKvKw3oecjaZxIOKTM2yT
	 zVbqWkQHPqgCnswbNn7ySVZm340mkzkfzkPxas6QGn7wDfe6spB6j+i4hI6wrUFUuvs9u
	 BxuzDAswlM9Kk5W3qK8/WjE+3LGM8yvvhEwtmOzX8JzgDa5EoCH90ZsnxsYRnEB1diPQW
	 JLYmIFYBE+M71dqXZNUDLD/6pglofX+w+2zQZbigDcslsZTrUlBOLXIDuW+7cVAfHsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SEHxRY4+;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1C7606A327
	for <linux-unionfs@vger.kernel.org>; Mon,  2 Nov 2026 13:30:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED1C7606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SEHxRY4+
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a5036bbac7so18113365e9.3
        for <linux-unionfs@vger.kernel.org>; Mon, 02 Nov 2026 05:30:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793626223; x=1794231023; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=MbpiROGQuzVONeXp96zntA9ceKse3+uC6QJ979xAbqY=;
        b=SEHxRY4+KzlF6m4DVJJmK2js3aghhM7f1F1OLGzNkF2qUc2JiYeZdUC3SuJ3sQU9mH
         Qz7RC7owoB94WsmcCfeMS9/XimsNpNLyiqSf7k3BNTheWNaIjWmDWBzwUnIepRbv+Fut
         62wV+WS7tAy8GNU9nrQE2RfIbb+24NgGwcJar9KYvzjgklgf8ZzfD/pw1hPlFKyCra6s
         VNrhdpF5JwOjkv00Hb5XLGT5Xr/RFQw9tpzU5x7aJSNtdhkfrgdWY+Zm9yHPXow0H/dx
         rNwrnT24YmA5cFx59Dc7n2V7+NuFCNhWwzwvtkxs1O1ufTmdgpOOf4Bn3GzkQ9nRsfLX
         Kfvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793626223; x=1794231023;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MbpiROGQuzVONeXp96zntA9ceKse3+uC6QJ979xAbqY=;
        b=hlD7YWdAQTaSO7I2sFqXcJjJKP+uabopy/oBgfaJd8nWnPvb2fvvQ4x1vGktP1PNKL
         wvvSqfQpcnkZgOBntJaDJVmGY0CYHNybEkO60N5Cm/ws4uL88Kf/IaiV54UXs6aYZ3kG
         fs7JktI8EufG81Qk2e49/qpVIQ4dMNLPiDQG+gLpYOX1FsF+0u/dZLIbNju2UAqPFm9T
         /01EA8ARqkzAcoSa3eqiV0PxRjkpTlAEW343HhN9N3Ba+Xl24Kw+6o8IV0P3JBpQThrv
         PeJB8gRigurDrrr0GdwAsk2EsBiykVx6OveFjDdylFwTpe74pj36Oqz+5eHssHROSbcL
         kHnA==
X-Forwarded-Encrypted: i=1; AKwUvByGh+BkrWDvDRR01eQ3D3d22ih7hNNWnhMzwCiPu1FMqirrWkmQ/H9X0k3cd+lhrGI8SZrErQNpfnPWE7Yl@vger.kernel.org
X-Gm-Message-State: AFq9FYJSxdof9myI5D5vUuJxhaW/HSTYaLIjijZKyxUz0XEx4oFIgqOX
	sOBdp5WQWE6rbY79IFneNrxO9PpBbXUKoCHNA/LB5Y0Lmrd8WupoE2Nl
X-Gm-Gg: AYBFou0mzuzgWKPOmEvY+pAfM2bXmF6FTe4RjqGLU4hVpTvqGKG3LpF/3Epo8JyHmld
	THAb4LW4l7bqnqpzeWwjyw7Ih374CpGAT04aVed2UQV1lXcb8aimHPGMLaBZDqL42P89EjBMCQB
	7gA3Yrp1DRyenDjGW8Vv/ewtNrbzvQ76GsIeX6+qJZ9GpGoEUEVFu8t55y8mS2S2XSDCub/7+Ql
	wslQps7BUVmTsEFO2XtO+EW8m5jcNrOPbWnSZ5ftoqD7w8B2VNMTAjQAFNZX5f6VQYLIq1dmKjq
	rwIDGa3dJhqG5Y9oIbed8gsFeafcxNQyYdaBACeaxCVCtJD9p/ByjNw1nzfXGQiCPCPyMulatu/
	5oLDA3rbaazpMqc/TuQm2hCjTbr8ikNEGnahPK2Yks58yx6JaMmGqGjPRPJvnNJcu8Ul7f69BtL
	Id50ST9O/kk+b09f+vW6vbm+o6kzt4a556IaTE8HPekk0hHVCZTCBGJbW5Bc8a5EoM87k+tf2iR
	2xyFNDASMVHLEiO9HIIgWddJF8SqgnUMTS9zUEjK9dDBDdijF0hCjudeOywZz4s5ZYnd7c1MskE
	kDsNlJnFIevfDYfCneAyXri1srOX8C674mBH8HUXQb72PKmLU/l2LrJqyWg/MWWeXSN2b6kggD6
	XRI/lPiceXK5c
X-Received: by 2002:a05:600c:870f:b0:4a2:1612:6367 with SMTP id 5b1f17b1804b1-4ac185bcf74mr220454775e9.15.1793626223025;
        Mon, 02 Nov 2026 05:30:23 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abf60f1076sm291182855e9.6.2026.11.02.05.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 05:30:21 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	kernel test robot <yi1.lai@intel.com>,
	stable@vger.kernel.org
Subject: [PATCH] selftests/fscontext_ns: expect EINVAL for overlay descendant userns create
Date: Mon,  2 Nov 2026 14:30:20 +0100
Message-ID: <20261102133020.3341462-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit a518e63c3775 ("ovl: return EINVAL instead of EIO in case of
mismatched user_ns") changed the errno for completing an overlay
fscontext from another user namespace. Update the overlay test variant
to match binfmt_misc.

Reported-by: kernel test robot <yi1.lai@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202611020115.2281e158-lkp@intel.com
Fixes: a518e63c3775 ("ovl: return EINVAL instead of EIO in case of mismatched user_ns")
Cc: stable@vger.kernel.org
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 .../selftests/filesystems/fscontext_ns/fscontext_ns_test.c      | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/filesystems/fscontext_ns/fscontext_ns_test.c b/tools/testing/selftests/filesystems/fscontext_ns/fscontext_ns_test.c
index 0f30a3e6e197d..535bf1f4e1a30 100644
--- a/tools/testing/selftests/filesystems/fscontext_ns/fscontext_ns_test.c
+++ b/tools/testing/selftests/filesystems/fscontext_ns/fscontext_ns_test.c
@@ -193,7 +193,7 @@ FIXTURE_VARIANT_ADD(fscontext_ns, binfmt_misc) {
 
 FIXTURE_VARIANT_ADD(fscontext_ns, overlay) {
 	.fsname = "overlay",
-	.expected_errno = EIO,
+	.expected_errno = EINVAL,
 };
 
 TEST_F(fscontext_ns, create_from_descendant_userns)
-- 
2.55.0

