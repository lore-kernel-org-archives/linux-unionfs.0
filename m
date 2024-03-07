Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE045126F2F
	for <linux-unionfs@vger.kernel.org>; Thu,  7 Mar 2024 11:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709809345; cv=none; b=YxJtDNA3WQv7Ve8lg4q5mCwnhZAefhmabmVTR9X37+IoYP74rRfrdJaX2EQ/e0vlvbgZVUrZJapnGf1OfskFY+plwt2qCyBTgZwGK4TDyoGtoJy1cgHSFlXuCwydvCSMbkRjPfTVoudsiI6RPqGhHp38eRIiFnVhqK9QNhZT20c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709809345; c=relaxed/simple;
	bh=jE66qC+TUWnSOohnYVQvtZUZfYDRxM0Jl4e3DWdEllM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EjkmaxD+qw+v68Ijl/7O7WjCIwk8SKlvIDXCkYo8oBm1+ZqV/jqXUH2R4vUtLIGxpuPJcRVlCa+HskeqjDSOjlAsCL9+kTtfhcvO2xe0AEKRHhnO9KRTZ0GJY4pyHvDTO9UbpX1gHb/lV+2CvqiS7h80rsJFettH6NPVhntjAZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J6ZykEIr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J6ZykEIr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709809342;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ELPJMiYv8En8P/hVP2pnkUG9L7naxhl47oaBUoUc8N4=;
	b=J6ZykEIrvw4fKvcEr1eYDAb3Loh8REqsbzknZ6hnC5I2JcWtlH6QyQ5l3i2KFk5DWP9+fL
	8+OCpel59j7tDrNJfVIpoCDPM2ixXi2MOJ7av4sbNC/z2JeV+8/3hccwiYFjw9+oLTQerM
	SWKABhNygcHMmuwiCJYFPN3RgLw9OGs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-eVGYHUQUOmGTgtHKSx_Agg-1; Thu, 07 Mar 2024 06:02:21 -0500
X-MC-Unique: eVGYHUQUOmGTgtHKSx_Agg-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-413104d8daeso2831105e9.2
        for <linux-unionfs@vger.kernel.org>; Thu, 07 Mar 2024 03:02:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709809340; x=1710414140;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ELPJMiYv8En8P/hVP2pnkUG9L7naxhl47oaBUoUc8N4=;
        b=fcVLOmL6ccLDq61veHbF9exU/FayFGN4UNkHpoMksgFJc2W9b3V73cOPUBpy/Iuco4
         o0xqONV+ykkAaVZpNKzXjVIwxUpQNi05JQXdK2lCaGHpLUh9DG8tN1QIoO/Cy+u7EoK/
         eecQFNt6jUQne/7lEGx55EFS4iC8f80fW9yxLueScHoU38dQ+zJCKkYS076Tac0ji6wq
         D01LzUFvpXf+zh0p86PF/vg2MbWeP9NSsKjonqVPUpJxzEVPkg50qCKXGecNLsfKoIyM
         KyUWwoVyRq/LXdsUSA8PXHK/1t9P41/dyIe711Uh0SmNKCSR+IJCeGCcXQcefzKLYGZy
         9CJg==
X-Gm-Message-State: AOJu0YyWedAcgoTbibALE/9wQ7XY8D0jdm+YGsnKxz4K3dzFnSMnaTaa
	lKmK6rFb42XwDg8mUVqxAK3scAc8g6ETPOfDUbSGIqMzvRjECGFhdR2f9/0reyB27nWDTLvHkXt
	lE97PDDmU9CDapfbCH3cAvOvsJJSN2125l6sob4BYXvPgUSMHCYoGRopLMwqCyHFLtGP6ymANiI
	BSZ31mjSSZdg942ksk6yXGhZmNvJhqf8XzUbNlismR8OKdKMI=
X-Received: by 2002:a05:600c:1f81:b0:412:f137:742c with SMTP id je1-20020a05600c1f8100b00412f137742cmr4394698wmb.11.1709809339988;
        Thu, 07 Mar 2024 03:02:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEe1d8+nfkjL4Efs0DeINLBOca9eRGr2NKryJc0D80b+BhRb40CSjNoJpuozSHJfokn/lM32Q==
X-Received: by 2002:a05:600c:1f81:b0:412:f137:742c with SMTP id je1-20020a05600c1f8100b00412f137742cmr4394667wmb.11.1709809339486;
        Thu, 07 Mar 2024 03:02:19 -0800 (PST)
Received: from maszat.piliscsaba.szeredi.hu (92-249-208-180.pool.digikabel.hu. [92.249.208.180])
        by smtp.gmail.com with ESMTPSA id v12-20020a05600c470c00b00412b4dca795sm2332625wmo.7.2024.03.07.03.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Mar 2024 03:02:18 -0800 (PST)
From: Miklos Szeredi <mszeredi@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: Amir Goldstein <amir73il@gmail.com>,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/4] ovl: use refcount_t in readdir
Date: Thu,  7 Mar 2024 12:02:05 +0100
Message-ID: <20240307110217.203064-1-mszeredi@redhat.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

At this point this is just a cleanup, since the refcount is also protected
by overlayfs inode lock.

This will change in a following patch.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/readdir.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 0ca8af060b0c..b894a97f8ef8 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -13,6 +13,7 @@
 #include <linux/security.h>
 #include <linux/cred.h>
 #include <linux/ratelimit.h>
+#include <linux/refcount.h>
 #include "overlayfs.h"
 
 struct ovl_cache_entry {
@@ -30,7 +31,7 @@ struct ovl_cache_entry {
 };
 
 struct ovl_dir_cache {
-	long refcount;
+	refcount_t refcount;
 	u64 version;
 	struct list_head entries;
 	struct rb_root root;
@@ -243,9 +244,7 @@ static void ovl_cache_put(struct ovl_dir_file *od, struct inode *inode)
 {
 	struct ovl_dir_cache *cache = od->cache;
 
-	WARN_ON(cache->refcount <= 0);
-	cache->refcount--;
-	if (!cache->refcount) {
+	if (refcount_dec_and_test(&cache->refcount)) {
 		if (ovl_dir_cache(inode) == cache)
 			ovl_set_dir_cache(inode, NULL);
 
@@ -405,8 +404,7 @@ static struct ovl_dir_cache *ovl_cache_get(struct dentry *dentry)
 
 	cache = ovl_dir_cache(inode);
 	if (cache && ovl_inode_version_get(inode) == cache->version) {
-		WARN_ON(!cache->refcount);
-		cache->refcount++;
+		refcount_inc(&cache->refcount);
 		return cache;
 	}
 	ovl_set_dir_cache(d_inode(dentry), NULL);
@@ -415,7 +413,7 @@ static struct ovl_dir_cache *ovl_cache_get(struct dentry *dentry)
 	if (!cache)
 		return ERR_PTR(-ENOMEM);
 
-	cache->refcount = 1;
+	refcount_set(&cache->refcount, 1);
 	INIT_LIST_HEAD(&cache->entries);
 	cache->root = RB_ROOT;
 
-- 
2.44.0

