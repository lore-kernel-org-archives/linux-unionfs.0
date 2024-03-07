Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE2E85277
	for <linux-unionfs@vger.kernel.org>; Thu,  7 Mar 2024 11:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709809349; cv=none; b=uxm1NLeVjlXBqv83tlijFHvHXINDFPBqRb+WSqzx5d/QGI9KmPY9jdbMudqrxhLExEfjzopkknn1f19c/qA0c2VhCb0UYeRH+cJQ2deqX9VwIJW3QQXhI64Huv/Ok8pqA66nEeCQSNVW25OtFi3ohzqsaIzJPjbWmkorK6Hh6/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709809349; c=relaxed/simple;
	bh=DRvnV8HJutIaAxTKTLKjKif+ZWKH1rr59mk4v4Evgfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y977NEN8J9DJ30NTx3C9B6TFwQDayH5gcgThhgiu+7fdJwbb3Vr2QXcYynkGx3cjMSazIvFjzfzaLavpQc+unYa5/cC2VuhOLa8mdvd0dm4p8+mFxX4w2cp//s6pH02ZsoGNvztvABOmHgtzl9R2dv23nDga3WKNloYwU496H/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S3tNSS35; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S3tNSS35"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709809346;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0jVYJDDKL/ChitY3WVDYwxzPamDrn+GtiVTQKdLJFZo=;
	b=S3tNSS35wNybZ99bXIXOCcem4KDWjiWWuqI+V5mCEnbhyp5zMM7SBHhRMTQNF40noJAsUY
	PVB/JqclLYDvigNOPXjv6BbXVcadTNdXu1P7G7eBswcwi93FBzhXzt0Q978kCQMQs3LAgO
	DY9BI5efpz0hljPsV5uRoj6zAeJowr8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-108-iJuf0iXlP626VJ1Z-RZd4g-1; Thu, 07 Mar 2024 06:02:25 -0500
X-MC-Unique: iJuf0iXlP626VJ1Z-RZd4g-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-40fb505c97aso4644535e9.3
        for <linux-unionfs@vger.kernel.org>; Thu, 07 Mar 2024 03:02:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709809343; x=1710414143;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0jVYJDDKL/ChitY3WVDYwxzPamDrn+GtiVTQKdLJFZo=;
        b=P0l5nNHK1xywV9N2JZrGdUJye4wFfzwfO2RqayKXF2E5cZ0KsIigBsSKnu0iZYujne
         trv0Otbbtwnql0JdLOykSxl6qJ5RD5I0+uMoUTfy4h8vCCFlmkT4tGn3VIG4G7x+oOoS
         R6NW01OXswoftv8UMmPmnJAhPHd3qoYxagKFiE6KQzbubis5Osedv0lqG2Rib2s0erEo
         dvzaGpRjOcfpaUrwc4RXW1KW5spIg6em6dlAOgQ6oa5FLW92Lb8FDMV+X3c8CUnGPoTY
         Vsq0/uQsV8CSL0xXnGFAyBAO2n3Uz17zeoKm7P7oQp/xPKbNg7vIZWMJpKHf02tgIKMz
         L2zg==
X-Gm-Message-State: AOJu0YxrgYVMMyA5W/9pAZyoqfw9bYvGjuhf3jgczDibmJIaU5eOBQPV
	YTqF6GZkbhdrcA8O2TB6im/zjtRS918M5EArNUJGhbW6KMufe/zGKx1RIK/AXp/vVnBZJukBHdu
	xrmePV8BItpyyAubdnstioPvhwpPPZ1njAEFIY88s/xKXilMq6fhyyQM0LUznMkF3YeejkWod6C
	cIJv1bc0QLsYOBSBY+zj9h2hDl1eHTNPO8kzMQuFyQFMww/IA=
X-Received: by 2002:a05:600c:1d1c:b0:412:ed67:f948 with SMTP id l28-20020a05600c1d1c00b00412ed67f948mr5348734wms.32.1709809343612;
        Thu, 07 Mar 2024 03:02:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGxkAVWIDVWcUtSzYTwdWkYYnwjVhmqktUpKpAr0gbcqOreJtyMC2g99k+fKinvzoQ13J4NzQ==
X-Received: by 2002:a05:600c:1d1c:b0:412:ed67:f948 with SMTP id l28-20020a05600c1d1c00b00412ed67f948mr5348707wms.32.1709809343152;
        Thu, 07 Mar 2024 03:02:23 -0800 (PST)
Received: from maszat.piliscsaba.szeredi.hu (92-249-208-180.pool.digikabel.hu. [92.249.208.180])
        by smtp.gmail.com with ESMTPSA id v12-20020a05600c470c00b00412b4dca795sm2332625wmo.7.2024.03.07.03.02.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Mar 2024 03:02:20 -0800 (PST)
From: Miklos Szeredi <mszeredi@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: Amir Goldstein <amir73il@gmail.com>,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 3/4] ovl: only lock readdir for accessing the cache
Date: Thu,  7 Mar 2024 12:02:07 +0100
Message-ID: <20240307110217.203064-3-mszeredi@redhat.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240307110217.203064-1-mszeredi@redhat.com>
References: <20240307110217.203064-1-mszeredi@redhat.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The only reason parallel readdirs cannot run on the same inode is shared
access to the readdir cache.

Move lock/unlock to only protect the cache.  Exception is the refcount
which now uses atomic ops.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/readdir.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index edee9f86f469..b98e0d17f40e 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -245,8 +245,10 @@ static void ovl_cache_put(struct ovl_dir_file *od, struct inode *inode)
 	struct ovl_dir_cache *cache = od->cache;
 
 	if (refcount_dec_and_test(&cache->refcount)) {
+		ovl_inode_lock(inode);
 		if (ovl_dir_cache(inode) == cache)
 			ovl_set_dir_cache(inode, NULL);
+		ovl_inode_unlock(inode);
 
 		ovl_cache_free(&cache->entries);
 		kfree(cache);
@@ -733,12 +735,18 @@ static int ovl_iterate_real(struct file *file, struct dir_context *ctx)
 	}
 
 	if (ovl_is_impure_dir(file)) {
+		ovl_inode_lock(file_inode(file));
 		rdt.cache = ovl_cache_get_impure(&file->f_path);
-		if (IS_ERR(rdt.cache))
+		if (IS_ERR(rdt.cache)) {
+			ovl_inode_unlock(file_inode(file));
 			return PTR_ERR(rdt.cache);
+		}
 	}
 
 	err = iterate_dir(od->realfile, &rdt.ctx);
+
+	if (rdt.cache)
+		ovl_inode_unlock(file_inode(file));
 	ctx->pos = rdt.ctx.pos;
 
 	return err;
@@ -758,7 +766,6 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
 	if (!ctx->pos)
 		ovl_dir_reset(file);
 
-	ovl_inode_lock(file_inode(file));
 	if (od->is_real) {
 		/*
 		 * If parent is merge, then need to adjust d_ino for '..', if
@@ -773,9 +780,10 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
 		} else {
 			err = iterate_dir(od->realfile, ctx);
 		}
-		goto out;
+		goto out_revert;
 	}
 
+	ovl_inode_lock(file_inode(file));
 	if (!od->cache) {
 		struct ovl_dir_cache *cache;
 
@@ -808,6 +816,7 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
 	err = 0;
 out:
 	ovl_inode_unlock(file_inode(file));
+out_revert:
 	revert_creds(old_cred);
 	return err;
 }
@@ -817,7 +826,6 @@ static loff_t ovl_dir_llseek(struct file *file, loff_t offset, int origin)
 	loff_t res;
 	struct ovl_dir_file *od = file->private_data;
 
-	ovl_inode_lock(file_inode(file));
 	if (!file->f_pos)
 		ovl_dir_reset(file);
 
@@ -834,21 +842,22 @@ static loff_t ovl_dir_llseek(struct file *file, loff_t offset, int origin)
 		case SEEK_SET:
 			break;
 		default:
-			goto out_unlock;
+			goto out;
 		}
 		if (offset < 0)
-			goto out_unlock;
+			goto out;
 
 		if (offset != file->f_pos) {
 			file->f_pos = offset;
-			if (od->cache)
+			if (od->cache) {
+				ovl_inode_lock(file_inode(file));
 				ovl_seek_cursor(od, offset);
+				ovl_inode_unlock(file_inode(file));
+			}
 		}
 		res = offset;
 	}
-out_unlock:
-	ovl_inode_unlock(file_inode(file));
-
+out:
 	return res;
 }
 
@@ -930,11 +939,8 @@ static int ovl_dir_release(struct inode *inode, struct file *file)
 {
 	struct ovl_dir_file *od = file->private_data;
 
-	if (od->cache) {
-		ovl_inode_lock(inode);
+	if (od->cache)
 		ovl_cache_put(od, inode);
-		ovl_inode_unlock(inode);
-	}
 	fput(od->realfile);
 	if (od->upperfile)
 		fput(od->upperfile);
-- 
2.44.0

