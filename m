Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFA533987
	for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 00:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778892780; cv=none; b=ph7CNwHVRNu2213deMoM4KeTt1pqwbD0NayBCyt/B9HUzfc2xdsdTUI+CUROiZv2qUKetVJrOQRV/v+3xV12JUnR2OZKju5wiKCiCihv1ViwOpVCwAs/p1BxrGHaR/QEjB3IpbNuKXwmCCqt5LpbyeMecaDvc9d5YNEI9ZATz+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778892780; c=relaxed/simple;
	bh=sylTXm6GG/AeEIIF+r9V2b8xCYKj892ovOkVdiUYdL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sq0Gv71rWyLHF9XYDwpTu+dv9okWGeXoNw29Lf9NHrcBITxDGuLBXrsrgDzjVHc5304yyCKKooN8urA3Lhlf7ElJdAmsOR153CrNohZMZP2GbQHOkEyUYFgPm0oDSYPBUTUlZ4GZ1dHcpai6sWgfkAJ6nLlo5UDjqmzG2chkmWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IpfpUuot; arc=none smtp.client-ip=74.125.224.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IpfpUuot"
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-65d071aac6eso657523d50.0
        for <linux-unionfs@vger.kernel.org>; Fri, 15 May 2026 17:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778892778; x=1779497578; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OHwdKv3R2tDj/nunXDqFR2eqVkjOmabqfWOrmMP3FmQ=;
        b=IpfpUuotocLCDT+Rm/mU+tB/sN5goiyyMGlFSw8GPV0WuoF3AHY88wsU7PZW7P9vl4
         8AW5shbPiXwNMh21z18fxLT5CXu3rEFrKa6p3D08bx0C6CFVTNbIpEH7vZPVW1RqW6X5
         MeUTGo/Wta3OjY9x15651ZykHV1wUULTGaTHBZDsONp6EAkUaULw2nWA+dGanPzt5dBq
         Y/p3IQaQrFO3oyocxdGh3UHJKDkEU44gj4kVVP9kynt5APaijEy+sBAXr7GeGm3gQIWN
         mTmS821HdHRZyVtDB1Loxipk5m+rGcdnZGCDKUymCx7ZdyGYY9JyxG5JiWdAR6U2gALC
         tMsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778892778; x=1779497578;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OHwdKv3R2tDj/nunXDqFR2eqVkjOmabqfWOrmMP3FmQ=;
        b=L1hJ1AENsyiSy5Zzf/e7oZBvX9xy8WFYqw2IrZ+T4F7+SGwYhs1f8dbs1BGtOZGeIq
         J4MmLl4qNFCUSIEVRsJbPQZQyhRxeOkgWxl5h+Zy7gACr8K2HOlab4zeKmahACA80rFi
         MxplV++zwXx5O5RWo1Ql+uOswwyizCk+6+PMzcsMTlKocQ8cmx+I3K8mTgzkcvSJp2+z
         rijiEYnr4R9nckHF3A6OQk+Sbt2ddWfMMDVszdz8wtoUzndS16xnJWIFzCDm3GIO6UOM
         no3te79nLPE89bVEN2wLlKbIxkM5Z7j1V1Hvg7miZH4ZWiFJ1l0BcwDOnGBGHIoMStk5
         J4DQ==
X-Forwarded-Encrypted: i=1; AFNElJ/KSj1v5ajT+1YavXNmnCvYFDnW8PF1VuN7pxBveWbEhKx4VdfJdX3eegMzIZPj5M9hdcFwgQWfL7gb85ER@vger.kernel.org
X-Gm-Message-State: AOJu0YwDXR6wSkqW2Acetg0HKyj+7mtFc4pJEm2jgYCYXB4LFEl2nJVR
	s576brMx/pmNtv4FKP77Z2qtcb48/VyKIrr1Bn6zDQwEvDAKm1pvUEviszGqEIcL
X-Gm-Gg: Acq92OG/LiHp6WXutIDDSPuQKb8buEV6V9L8Gt9EBkr9LLJ0TIltip/+8UodU6iZSy+
	sQq/SOK0rhLyCIKPK3Fw6cMtjAOIwrsCGHLhrmzgvg2qI6U/aiOpShYPCLNxAeRdcWLNxehBApm
	zAHU0ryxRZRHFAZnB/HlhaSJpSqcnbi0m+JlcwesSd0c3d82jOz0eLrWdmCiIyuBTcfAs9VXdiw
	dgI36SR9ZCW535Ese7ZQcbAkEWcVtmzb/ERgqs4W+m2bj/kcf0/FxJd35IsH7OjwPiSLKIeQzyd
	TEDAqvkfUEhbe5NewGwjtUG9uDKzkvw0hlVcB2acz7YYDNbhhKnE29gSK4RZxHxJopDYTFJkd8C
	/M3/z7UHKXOOafg/VJLyJDJesqFjVIT6Ek5K1whYLP+DSrCfn6ErvQXJyY9UngmPREGlUV0E+2V
	TjnZZiRQhJTF7A9HWDpaFK
X-Received: by 2002:a53:b41a:0:b0:651:be87:9e5b with SMTP id 956f58d0204a3-65e2285e9a8mr5422284d50.53.1778892778528;
        Fri, 15 May 2026 17:52:58 -0700 (PDT)
Received: from localhost ([2a03:2880:f806:44::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-65e0d89b124sm3307182d50.6.2026.05.15.17.52.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 17:52:57 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: amir73il@gmail.com,
	miklos@szeredi.hu
Cc: fuse-devel@lists.linux.dev,
	linux-unionfs@vger.kernel.org
Subject: [PATCH v2 16/21] fuse: allow backing_id=0 in open to inherit inode's backing file
Date: Fri, 15 May 2026 17:39:59 -0700
Message-ID: <20260516004004.1455526-17-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260516004004.1455526-1-joannelkoong@gmail.com>
References: <20260516004004.1455526-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With FUSE_PASSTHROUGH_INO, the backing file is associated with the inode
at lookup time. Allow the server to pass in backing_id=0 in the open
response. On the kernel side, this uses the backing file already set up
on the inode.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/passthrough.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/passthrough.c b/fs/fuse/passthrough.c
index d62a1c751157..ae0137caa06d 100644
--- a/fs/fuse/passthrough.c
+++ b/fs/fuse/passthrough.c
@@ -193,13 +193,17 @@ int fuse_passthrough_readdir(struct file *file, struct dir_context *ctx)
  */
 struct fuse_backing *fuse_passthrough_open(struct file *file, int backing_id)
 {
+	struct fuse_inode *fi = get_fuse_inode(file_inode(file));
 	struct fuse_file *ff = file->private_data;
 	struct fuse_conn *fc = ff->fm->fc;
 	struct fuse_backing *fb = NULL;
 	struct file *backing_file;
 	int err;
 
-	fb = fuse_backing_id_get(fc, backing_id);
+	if (!backing_id && fc->passthrough_ino)
+		fb = fuse_backing_get(fuse_inode_backing(fi));
+	else
+		fb = fuse_backing_id_get(fc, backing_id);
 	if (IS_ERR_OR_NULL(fb)) {
 		err = fb ? PTR_ERR(fb) : -ENOENT;
 		fb = NULL;
-- 
2.52.0

