Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DC0405ADD
	for <linux-unionfs@vger.kernel.org>; Tue, 24 Mar 2026 15:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774365746; cv=none; b=DYqmUzzST2r67+a6o7d0G8E5XTwDUaaFofhcOuzX2wA1hmXNsNJKRZGPlmjcfKhOZOH+vecmYl5ShlPgpkxzaUPQoVdsSHTTceCFGRtsX84OOhhVrBl/1XAdQNQ2oFiNey6JSvEwCCgjqymXYrig3XptfS5EnTrQ6P6sTv7DJ3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774365746; c=relaxed/simple;
	bh=UqgJUUtHXG46FtoCy5D841b1snD2nAdDFGbSknd5iH8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mRJsJ4z1YS8mYZh8s0uVlVAUUtVCOkIeowBRygHkZ5HXPCYN9BLnveM/VEBWfry+GMtLyg+6p7Fl3qt8cNiXKiBMl7cuTZASL8kkxp7/DtApaz5KfUyEdGy5Gfb1x6y5q8gBvWNcct+DE8ItWFIgYTOa5b5W0VKPhSFdDY02gT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ELwz1qWX; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ELwz1qWX"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b97ed4ad579so627928266b.3
        for <linux-unionfs@vger.kernel.org>; Tue, 24 Mar 2026 08:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774365743; x=1774970543; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zYDGorIwTYZxMzwCVryBDkbvpbGzwymfm8qqa+jq02o=;
        b=ELwz1qWXDSltHjhxKl+aEruLhIIEZgoF+BxE09nO0V2qIc3GEJDbrogxw+KXGcRkLX
         iRFHl4MD/j0loD8gy5izeF37YctlclVas88Ju6c0Fu2JOEKoV/yeMTtv4uaqXd9Ftyy2
         ek+1m3kkyF+9bhkSGwg6Ttw1FbvvFK4FMXYEtsYpzGhzvmHarlGIcyC7zmfwhcXuv3ls
         4oe/hwCGV2/ibbnxPqciJtIs8NFXhKK9RTxxnSx7hmYfCKvp+fn3yuMsnGpDe4OC43Pc
         J3nveypa3KbuuoItO8fhqCHS0SAJ53Gtdk6331qPq75zXwVYBagm9mbSI8f77uaXAw7l
         1cXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774365743; x=1774970543;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zYDGorIwTYZxMzwCVryBDkbvpbGzwymfm8qqa+jq02o=;
        b=Wmkodp4u7N2+LYfW39v54oDB3Cjj1spW4pFZks+Ah0u9zm5c/QzQCEb+Vr/SOafXsL
         RY9HE0ytOd1kZ/uzs6A8GD98Jil6uaDnqB+tWlct89tWUOq9nse552/9rW/BCZlC56hr
         nxgX54uL1EifFpwmMVuBodf03nse7uP56shzd4TQ8jDk/Ddt8VtAyfV28olGqGWvjgX9
         YtZzKofod5wzvO5kUG0GbfSzsTQ1aunj46QRyaRZ5KvSCxh7rzk5Utx9jrSWSro/g8f4
         IUIP4C93Jb0bY6qTwbq0cvKL+qhTmVI1rKGGfuw6hECqksbe4tAr03Cm18Ek5T143fgo
         u+Qg==
X-Gm-Message-State: AOJu0YxTTOnPCazGv0KxGMg0llp8wChB88xqg7s9BKAQSmobO+J9asXC
	XSe26Ldp7pGHvyfWu3t5J5emXhpE7b2hIPgONxJdiSESXXzdVztT1OZF
X-Gm-Gg: ATEYQzy6vVJ8ut4t1hN9fwMzIZUOO9xwzqLUDfJS6xTeR66bmKin+mZ0iCGMWEhR2sf
	/oYKNYsOKSFCRDl59hrgEYVFUQETuxz/vFn3UjZp2cgm/vZ/wX4RIuqVB99rK5IAJfHDORS2XrO
	UZoJkOEN2KshV927bBdu0ZEDBigO+BCQAIczbF805jjS2h4JVxrQzLp/ntWzjqu7AriWB8QHjez
	Mq7SRQ5Qgp5h3HuoX0ICEP5DabZFSHvO4pYVuazcUQ8FeOvkl/TX0NqvbDwtkwEGEQFEZFH59JZ
	gYlRNKqp3f0y62WxZ26UdcAPa8D1AgcqCs0b2bbA7t0gS9oXxYR/9/6aUsVzkSucJs9ez/z4aTp
	VAljWlPmxcnJio1H6tZwyZDZE/KRWaqydLUn6FAISzhKa4uBOyk+fccSqJBiKbltZe6HkaLztkC
	22itkInmTlbhci+PLpOdzPuQcntEJFo6Qva2+S4xzxVmZDa+zhFKR+rf4XLeH/m5JYj57z1F5WM
	Eej+GmCyLjeVT4gfjPc2u2ZzHzP
X-Received: by 2002:a17:907:3da7:b0:b97:b45e:785 with SMTP id a640c23a62f3a-b98453e7ef1mr1023339466b.6.1774365742586;
        Tue, 24 Mar 2026 08:22:22 -0700 (PDT)
Received: from localhost (2001-1c00-570d-ee00-4ce2-3481-21c7-16a7.cable.dynamic.v6.ziggo.nl. [2001:1c00:570d:ee00:4ce2:3481:21c7:16a7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b983387085fsm661023466b.52.2026.03.24.08.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 08:22:22 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] ovl: fix wrong detection of 32bit inode numbers
Date: Tue, 24 Mar 2026 16:22:21 +0100
Message-ID: <20260324152221.96677-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The implicit FILEID_INO32_GEN encoder was changed to be explicit,
so we need to fix the detection.

When mounting overlayfs with upperdir and lowerdir on different ext4
filesystems, the expected kmsg log is:

  overlayfs: "xino" feature enabled using 32 upper inode bits.

But instead, since the regressing commit, the kmsg log was:

  overlayfs: "xino" feature enabled using 2 upper inode bits.

Fixes: e21fc2038c1b9 ("exportfs: make ->encode_fh() a mandatory method for NFS export")
Cc: stable@vger.kernel.org # v6.7+
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

I have queued up this fix.
The regression has no serious impact on most users, because xino
works pretty well either way.

A nested overlayfs, where the lower overlayfs is nonsamefs ext4
would have less xino overflows, but this is a very corner case.

Thanks,
Amir.

 fs/overlayfs/util.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 3f1b763a8bb4c..2ea769f311c34 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -85,7 +85,10 @@ int ovl_can_decode_fh(struct super_block *sb)
 	if (!exportfs_can_decode_fh(sb->s_export_op))
 		return 0;
 
-	return sb->s_export_op->encode_fh ? -1 : FILEID_INO32_GEN;
+	if (sb->s_export_op->encode_fh == generic_encode_ino32_fh)
+		return FILEID_INO32_GEN;
+
+	return -1;
 }
 
 struct dentry *ovl_indexdir(struct super_block *sb)
-- 
2.53.0

