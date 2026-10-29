Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793236173;
	b=kmVC+z+lD/G1F2k3c1T8BobtCQkPUTHM7OrxNQ4F7jgqXvnbTy2f5cBJ+cS35okJbIto
	 e+dIDo4pUoNiRtS5Po8DV5CBgw7Nfp2CwxIqCgjxAng94sN/v4Kdkz9VFBssv0Iub7Hvi
	 CrGlEFcmMANGlBC3ueal9JWemQMUQZ9kNeVk/nu2FZ/1DenDZ2jm/RhQD6TzQOZHTeAi3
	 jq9eImLH/TU3wL+l6kN8eVet03iQ0d6xw+0BnrpmGcV3MzlzCfBINnt1O4vHHMq2GawYc
	 5biXzKFReL7ZWKduNdt15kgj4Y1y6PjeeVCTvUGzT8q1lPCZjbkBJ+gWE5aDIL5jLnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793236173;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=fa3cWEpno319wkUWKX53/JP608wR2XPrIP2o3Tz0eeE=;
	b=T92nkh2V9WfxInMdZjbGd2atfG6wG2j6pMoJRs5p6Io4LR4ClVqug0rfiyIh5dCygPfy
	 kWb84ZLnmbe4J3xNEKYpigBDctYMxbNPv8IE1mIWh+Ugum++RKZi2MHC3AEsauDm2Odn9
	 4BFg1zWDmzZ87OYVx4RjhPvDfKkwKU3x7Joq3l7MrRKvcanyrOx+QHkioxWxZQJ/Een8m
	 nlAFNo/fYI1YAU65gFOwB2tpYsOYrTSuueyzq1NNxoI08qMgDLWfxLDEA/k0nPIWGwlyp
	 7rVQx/y/91vTbG3wjAYCfB78ZCr+aNJd4o4ORgVEV5e2BiD46+vJASBfEspnTbMmyzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=PKuPwZIA;
	arc=none smtp.remote-ip=209.85.222.182
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2D6606A32F
	for <linux-unionfs@vger.kernel.org>; Thu, 29 Oct 2026 01:09:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BE2D6606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=PKuPwZIA
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-93e515769d3so132124485a.3
        for <linux-unionfs@vger.kernel.org>; Wed, 28 Oct 2026 18:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793236171; x=1793840971; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fa3cWEpno319wkUWKX53/JP608wR2XPrIP2o3Tz0eeE=;
        b=PKuPwZIAD9J7uJNwVLLAh5a+uRxdTqTyqR7yO9KwTAAybdFVOvfQS5w85EBad7vegj
         GQQ+sMEP/0oaNMX4Zj5LCb8p6wJ7F3n1fkarGVLe5xj3GIwtmAmJSGUnnAzthKOIolKJ
         9as6jW627nx7cf0Q1BcqtZ5G1vh/xZ9IUT3d12YgJqqZcOoRQoLIubomXC3ZDrHyeceK
         xZOGHMeG23kHxNmwBIwlvenAyz9ojOqftR10Pg3GQFb9dLwLU101x2hs28R/kvUgTQ0Z
         GP3LpEnGgglp/7/RSg1Mrq/gMG7Lqkv8t0rsci5z0v9kTmhwVMYLhiO1t4mRuzQ33D7W
         nwiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793236171; x=1793840971;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fa3cWEpno319wkUWKX53/JP608wR2XPrIP2o3Tz0eeE=;
        b=m7n2hUbB4Crwm+IHYKK+lOEq6pBz7kHSaFHhS1VBJtTY1iYaEYbKtI8qrhz89h4VKV
         G4MtHr0kLtisqyYlYNd4/PuxNrVwlz/VkgdvQyG+nGAflDacoeUMZnKCs9bD6MUbseX2
         9CxVlju7wjzUbC20zNOUyjgjvUGmzZYeYjQ05f1blmMYIzYIKsBkf2B9XDHSlYsLhCrE
         hZeQaozzj0JFP9u6UNfWyL6y20ES0QFL55vXDgzT7CnKhvQatLhu3KIEYX/1GYH2IaVf
         qDvB1rxjYQukItOD6IpsiAlv9GypXhZWNeRpItCS9NxwanBljHSRbgREuqqhFYfBZ1FO
         JRTA==
X-Forwarded-Encrypted: i=1; AKwUvBwfz8nFbJ7fJD7KrY1m/23hMScLeyC593x3didoC9R72mhe9g35k0kGbiK+p1BHV8i0EHbHrMrEdz2cpDt7@vger.kernel.org
X-Gm-Message-State: AFq9FYLQudiraZXRVMgWOQI7gAL0thySaTjSm903txgt7YQRGtrm/Aqz
	2u8OYSTteGs8II/9+YytlozycgPT5VeYikapCzQ1YZh7g/wXkTdB9HwyqJfOcOqdDAg=
X-Gm-Gg: AYBFou1byB1Au6xDZ39Y0iHCfHUy95Y1W4dZQ/dcizGf2qF8caMT5SR4Hk5JOavCv9Y
	8gmMMyZ9B7IMwWRTA6bxHVd9hcfPJPbxkbVGltSTSqc0SdxBa/CXhNPnu99saW1sMzHVVfPVJDM
	0GIibdOVvxNCvxt91W33y0ezn6HcEWTiOX7Wr4ijAv2WfXHzM9IadyLzwSfTqMi+b2lDfS/EH6o
	QZ4XMB85L0Rin2KXBe1HzVQ03Hoded9FN3d3DmReRb20Vvuz0dFXxCh64an8O7+TSyXdc/8zs/u
	6lCXROXUebc6VjVEtmMqKsZB0h7Zoi8fl8KWjmEcjD8uLLw5nIVbOUzHUEIc8N1qTraR8Y49JKa
	ulJCrVbovI/hc3yaa0CiUE5O8v2Mm4tFuC0EK0Jcku3h87JyZ7/GlemaZ9XMVSXaA9dcwRMVWyB
	7pa3jitiPHx1IKdqjMqvbDRfEyEWzND5pPsg52Lu4+PUSrUcWhnoatREe8SrnnPptyUdugIORGz
	KASJQXkA7JEIQVF35/JaUN4JFtlY1g3l1djyvcIEH/8fi9BLUIhUmm9wBukvv/cxA0/HnoICU8r
	Q4Xk3cYQOoNgrBb54xKbf1A/ewkqUIFU6mnuZyH8FuKDpg==
X-Received: by 2002:a05:620a:2807:b0:939:7683:33d5 with SMTP id af79cd13be357-94408a695a5mr641483485a.19.1793236171367;
        Wed, 28 Oct 2026 18:09:31 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.244])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-940f078e516sm1407749585a.33.2026.10.28.18.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 18:09:30 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Thu, 29 Oct 2026 01:09:15 +0000
Subject: [PATCH v2 01/10] ovl: setup overlayfs' private bdi
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-b4-ovl-containerized-sync-v2-1-4e9f08e4a052@toxicpanda.com>
References: <20261029-b4-ovl-containerized-sync-v2-0-4e9f08e4a052@toxicpanda.com>
In-Reply-To: <20261029-b4-ovl-containerized-sync-v2-0-4e9f08e4a052@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Chengguang Xu <charliecgxu@tencent.com>, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793236165; l=2269;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=74ImzQ7zpYMMINxR4xsfYw0uL7kLUXRHS98AvYSiyms=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QJiHpMOMNCOFs9w7W95tCK/aAVI3EgedZVWQ/ZFj9ZzhNJq9BgBEn6uhvSgb5XAJdkagkPCa+FQ
 g2gEiMXsjXwA=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

From: Chengguang Xu <charliecgxu@tencent.com>

Setup overlayfs' private bdi so that we can collect
overlayfs' own dirty inodes.

Signed-off-by: Chengguang Xu <charliecgxu@tencent.com>
[josef: only for an overlay that tracks dirty inodes, add
 ovl_tracks_dirty()]
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/overlayfs/overlayfs.h | 17 +++++++++++++++++
 fs/overlayfs/super.c     |  7 +++++++
 2 files changed, 24 insertions(+)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 92da556598da..aa6c2d005a40 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -7,6 +7,7 @@
 #include <linux/kernel.h>
 #include <linux/uuid.h>
 #include <linux/fs.h>
+#include <linux/backing-dev.h>
 #include <linux/fsverity.h>
 #include <linux/namei.h>
 #include <linux/posix_acl.h>
@@ -663,6 +664,22 @@ static inline bool ovl_should_sync(struct ovl_fs *ofs)
 	return ofs->config.fsync_mode != OVL_FSYNC_VOLATILE;
 }
 
+/*
+ * Does this overlay track the upper inodes that are modified through it, so
+ * that syncfs() and unmount only have to sync those?
+ *
+ * There is nothing to track without an upper filesystem, and a volatile overlay
+ * never syncs.  sync_filesystem() does not write any inodes of a filesystem
+ * that has no writeback, like tmpfs, and nothing ever clears their dirty flags.
+ */
+static inline bool ovl_tracks_dirty(struct ovl_fs *ofs)
+{
+	if (!ovl_upper_mnt(ofs) || !ovl_should_sync(ofs))
+		return false;
+
+	return ovl_upper_mnt(ofs)->mnt_sb->s_bdi != &noop_backing_dev_info;
+}
+
 static inline bool ovl_should_sync_metadata(struct ovl_fs *ofs)
 {
 	return ofs->config.fsync_mode == OVL_FSYNC_STRICT;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 19b6d54c4500..ce3e30235ae9 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1455,6 +1455,13 @@ static int ovl_fill_super_creds(struct fs_context *fc, struct super_block *sb)
 		if (err)
 			return err;
 
+		/* Dirty overlay inodes go on the lists of this bdi */
+		if (ovl_tracks_dirty(ofs)) {
+			err = super_setup_bdi(sb);
+			if (err)
+				return err;
+		}
+
 		upper_sb = ovl_upper_mnt(ofs)->mnt_sb;
 		if (!ovl_should_sync(ofs)) {
 			ofs->errseq = errseq_sample(&upper_sb->s_wb_err);

-- 
2.55.0

