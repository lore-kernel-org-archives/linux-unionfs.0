Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F57C33987
	for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 00:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778892759; cv=none; b=e9sDrzlChH6b/fPRQY+qEvg8eqmXFVkT6dDE+LPfKZq82L88fgrjnTM0gD3ROqf2pvyDLV5dSIFHMLv4hnCzgTQdH9tnWPsYhi9isKTcFLb6sWRFbBDJAT4iGGPyHv9oj/JvRUx9+V/okcmVGQ0nL2NcY7nIbeBcJDtkh+k1opE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778892759; c=relaxed/simple;
	bh=oaVjW+kto9iJmTBWvplDeJOWF9LQ5WC98I/67i6KwSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jliQCr1qudylw5NnINILJuNS4ZNIuxtko0NyuqxUJES6RRTO5McrWk2nhDu6NFPSjC/CmjCzxeWsMSC8ppS1PbLcKjYakvJADh5oLe2tQmEEUEe8cQO5J7/gAyWSnojvp7C+fcLA5ulNz8mMkvyzlHiF6KH6U1F7skiijwQggTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=clB5KirR; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="clB5KirR"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-7c2fa14795aso485597b3.1
        for <linux-unionfs@vger.kernel.org>; Fri, 15 May 2026 17:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778892757; x=1779497557; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WBcpSskz4i7VuiAz2sQnUJMSd3u4qsIaknHE8pSV17M=;
        b=clB5KirR0J0XEvzWCrXj+l1/Q+K4+6kjCDbjcDJaECyS2OV3KgURhpvr93fPvJvfa0
         RvEvXLhjjAMSXYfjocnV87rtn4wIea7WU7UkVO0NrHWLIkEvmmcoT7cNL0GESSW/MHsE
         dTEf2Hq1QXKNNKZBiA3yxaG/RHm7lOmjU1VK+SHxAzaX3jBPYI+hpTatgMCmEC4cDPYo
         q52IOG6DpJM2PSmnINq89ZIuFb2Qdu7fGdfmin/pqpIsRN2l4PiUxE4oZRyJEDhexcSd
         ZLxWJFW+3eZ39IJ7OO26bfXzEv869/dSPPd2in3TC014JGZ4J5L9GkyXzzatS7rarI+r
         oULw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778892757; x=1779497557;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WBcpSskz4i7VuiAz2sQnUJMSd3u4qsIaknHE8pSV17M=;
        b=OdHBzH1OYbjfeNzyLP7XtrKqTCSNI41S7k0uZQ1UnXpKbduUZXDPcmrB35UJYyIBTk
         5J4HplEKs/p5gizGxfT0QZFZVhMoadXaWwDn3Be0GEsTmiUZ98kcY1YvnFVlmBvP9ogy
         mLAlE7L54uwBLRi9al8LU2kJCkfLopmNV8eR4NvYYCXQY740Wqeyt69KJIADrjZjLb5B
         887MBMVG93CwTejd4y3eb+LPG0hLkCPBBjZeFXkFTeCNm7wvq+sXzYoidvmN98aaLf63
         XiHSUraRcr15h8RBH6lFZUkLEbzaMq9v9SK6XGyv5IYCHCXISujmqTz5S5YOeR/dGohD
         TStg==
X-Forwarded-Encrypted: i=1; AFNElJ+TQOYQgQzXpxdHInjXSbUEInSa7XucGlWLMWXGatZ2QV0X3frSqISkOsnjtuOGZ7bdayfVbi0xYGLK6FdB@vger.kernel.org
X-Gm-Message-State: AOJu0YwXjctl2JWA7XD+vbVZd60DgD4OeYoQ2USoxkPPrhMzjM4OQ/rt
	ajWkw3sZTycXz55qn1MLlsmj4pHwU8rfJHTlJWBxugxuj9uLjn+QGUzw
X-Gm-Gg: Acq92OGZ/0FgJBCrdlYLqweDGeSKJ6DY97+c1fj0I3KtGiPV/8mo8QVIUWbvCVzMYug
	GOCbawE9PQv8jaftuIljoJH72Q4EFDLz83kUIqjYiqyb8vL9nx4earp97f5To/n0olXRyANtFBq
	OVOb6pLpMewA7M5qQ/B42OpI7hJdDVYIV8bForXLyF1Vp5ZQF5H+e6GmYVwJFo72TTJa67sRM/R
	tHATLuzSCdsKRPH6+euMeF0qjL0HVn25AzEQkcfTtubCwr0FEObEGNRKo5VRBHY9hqMjwi3vDhO
	BPBeiooVlaZxGSltZ4DQDBxxwOXQ/SyDOUVe2dxXtutdYTC2qx761f8I5b9oyPNMynbAOYKoQOh
	Lymwkee44CLa9N1I8139eEMcj2oGIDuGMEpB5+fOSZLFrCXRhVwF1QX1w2DDQSv5eY4fOQNZOWk
	NjPF1b9gmrZM6WjoOtdY/QwFX2F2V9/Q==
X-Received: by 2002:a05:690c:c504:b0:7b1:d1af:4b95 with SMTP id 00721157ae682-7c95c8eccc6mr76943427b3.45.1778892757232;
        Fri, 15 May 2026 17:52:37 -0700 (PDT)
Received: from localhost ([2a03:2880:f806:e::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7c7f5c965d6sm38263367b3.47.2026.05.15.17.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 17:52:36 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: amir73il@gmail.com,
	miklos@szeredi.hu
Cc: fuse-devel@lists.linux.dev,
	linux-unionfs@vger.kernel.org
Subject: [PATCH v2 08/21] fuse: handle zero ops_mask in FUSE_DEV_IOC_BACKING_OPEN
Date: Fri, 15 May 2026 17:39:51 -0700
Message-ID: <20260516004004.1455526-9-joannelkoong@gmail.com>
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

Servers that pre-date the ops_mask field will pass a zero ops_mask in
FUSE_DEV_IOC_BACKING_OPEN. Default this to FUSE_PASSTHROUGH_RW_OPS to
maintain backwards compatibility.

For FUSE_PASSTHROUGH_INO servers, an ops_mask must be set.
FUSE_PASSTHROUGH_INO is a new feature with no backwards compatibliity
requirements.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/backing.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
index 2234ab47406a..b499860e1185 100644
--- a/fs/fuse/backing.c
+++ b/fs/fuse/backing.c
@@ -119,9 +119,23 @@ int fuse_backing_open(struct fuse_conn *fc, struct fuse_backing_map *map)
 	if (map->flags || map->ops_mask & ~FUSE_BACKING_MAP_VALID_OPS)
 		goto out;
 
-	/* For now passthrough inode operations requires FUSE_PASSTHROUGH_INO */
-	if (!fc->passthrough_ino && map->ops_mask & FUSE_PASSTHROUGH_INODE_OPS)
-		goto out;
+	if (!fc->passthrough_ino) {
+		/*
+		 * For now passthrough inode operations requires
+		 * FUSE_PASSTHROUGH_INO
+		 */
+		if (map->ops_mask & FUSE_PASSTHROUGH_INODE_OPS)
+			goto out;
+		/*
+		 * To maintain backwards compatibility with servers that
+		 * pre-date the ops_mask field, a zero ops_mask defaults
+		 * to passing through both reads and writes
+		 */
+		if (!map->ops_mask)
+			map->ops_mask |= FUSE_PASSTHROUGH_RW_OPS;
+	} else if (!map->ops_mask) {
+		return -EINVAL;
+	}
 
 	file = fget_raw(map->fd);
 	res = -EBADF;
-- 
2.52.0

