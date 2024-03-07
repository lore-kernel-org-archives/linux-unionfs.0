Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FD186AC5
	for <linux-unionfs@vger.kernel.org>; Thu,  7 Mar 2024 11:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709809347; cv=none; b=d2mqOp81SjJcE7LKibTMONRra/m9P3PUxpLNeIUm139D4s7GWx7qpImBeQpRzQp8I4ZXIELA8euLgpGo/DMGJSmLlL1OEMKNLi2S5WUawLTGYPbqLCcXiyVB9t43sEtvxvCcbaJKw/knp24pW151C6TZdCQvFs7yPJDgyVKRzwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709809347; c=relaxed/simple;
	bh=IbuU5cpOt420V29ONwOifcPW/3aVME6yzHFDe5gsTxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V522P8Z4RC5R1EiKVW7B0HXeN7F8JJayiukxhxoiQ/2NTX9Su8RzCJ23A6RdQySD5KmLi9tlSNqztkSa+L7m7F7wUrocnGUVHRHGgBakpcLyxpsApKxNTL6a/acnkyq5EIxDMJYsNsx96vSaMH6qO2RMr8KZ0OrQv6s1k+2yCWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DHWEWf9u; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DHWEWf9u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709809344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bowjdvADPqPbbMJAv78SEAOB2sDLU3RVgb2xFBl2V9E=;
	b=DHWEWf9uC0906Bri3/3wlemKZbLIjgnvi4CHNctNZcRVw+sU9x8/h2F+kVZEZ29FKBB9b7
	v02YN+77EH9vCj1reQ4zpRshhWKHUVI1TRysWkQ3g54veCycUMmj5tgjppjHuWuu02bz6V
	uChIurqLKVs5SviRdQwXr0we1umw9yM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-134-eaBQS2TvN7qPT6Ud2TMS6g-1; Thu, 07 Mar 2024 06:02:23 -0500
X-MC-Unique: eaBQS2TvN7qPT6Ud2TMS6g-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-412e992444eso3662135e9.3
        for <linux-unionfs@vger.kernel.org>; Thu, 07 Mar 2024 03:02:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709809340; x=1710414140;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bowjdvADPqPbbMJAv78SEAOB2sDLU3RVgb2xFBl2V9E=;
        b=q46WxCdUbrsWJgFdTAvDVpzSLhhSUtLHKeVuTG+FuY9jGeyrvpfTc8Bg54CnAyNgV1
         S8gDHb/YSqYGc8OSaQdL8/ChJ1AYi8NQPFwBIGLYgaeMFf+EW1+hJYjCDFnQZ6B9ZYHO
         t5DJlSwJdFtkAc1Fm4kSmESQZHKG3sXEIc1DycuiCBLd7AHX5po+9J9tO2Mfi1Q27PD1
         s3dC8YR5HJ2r8qKW4R40ZIFMGvbcKdg4Sd+HwLVG0JYma7Awmtp4PZ3f9qORaW5b2tDd
         V5AGn0o3IhACgw1eywquUhaSWCPCB7xm2tuxU7e951qYB8NjQ9GPi/vpUZoWgjQWUvHR
         BQlA==
X-Gm-Message-State: AOJu0Yz+5jB7ucg3jGp8qPXUa64MbsYxPsS++O7/HfiiE8j8jyF/kAC5
	Bac0mkNAlkYebFYf48DJYMo7DSmXdEZHAfJFW377F/lAOic1WJf2LhhlO0LKd/DBTJ9O50oFYUw
	51WRExYwoWJ4eim9DtyxtcYrFCzWy/qhZJppkNY4Y9wLyTa9078pJ7qc8LWA9uwWCROCPAT5VU5
	zbgLu9TncE1qQMXrNBcGzBWwMgxUpUOYUy/5QDIyAxoRjpVx4=
X-Received: by 2002:a05:600c:4ec9:b0:412:ef25:aa91 with SMTP id g9-20020a05600c4ec900b00412ef25aa91mr5115719wmq.18.1709809340771;
        Thu, 07 Mar 2024 03:02:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGYF+HpiuxhQAvUoex5tPttsDJk6McYDOiAp5uXUQ4YE6sEf/l3M2Ps2IwQLKOzA/wVD0apaQ==
X-Received: by 2002:a05:600c:4ec9:b0:412:ef25:aa91 with SMTP id g9-20020a05600c4ec900b00412ef25aa91mr5115701wmq.18.1709809340434;
        Thu, 07 Mar 2024 03:02:20 -0800 (PST)
Received: from maszat.piliscsaba.szeredi.hu (92-249-208-180.pool.digikabel.hu. [92.249.208.180])
        by smtp.gmail.com with ESMTPSA id v12-20020a05600c470c00b00412b4dca795sm2332625wmo.7.2024.03.07.03.02.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Mar 2024 03:02:19 -0800 (PST)
From: Miklos Szeredi <mszeredi@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: Amir Goldstein <amir73il@gmail.com>,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/4] ovl: get rid of iterate wrapper
Date: Thu,  7 Mar 2024 12:02:06 +0100
Message-ID: <20240307110217.203064-2-mszeredi@redhat.com>
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

Commit 3e3271549670 ("vfs: get rid of old '->iterate' directory operation")
added a wrapper around ovl_iterate() to lock the inode exclusive.

Use the overlayfs private inode lock instead to provide exclusive locking.

Add ovl_inode_lock()/_unlock() to ovl_iterate() and replace
inode_lock/_unlock() with the ovl_ variant in ovl_dir_llseek() and
ovl_dir_release().

This replacement is valid, because the inode lock was taken only to provide
exclusion between these functions (for other files referring to the same
inode).

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/readdir.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index b894a97f8ef8..edee9f86f469 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -758,6 +758,7 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
 	if (!ctx->pos)
 		ovl_dir_reset(file);
 
+	ovl_inode_lock(file_inode(file));
 	if (od->is_real) {
 		/*
 		 * If parent is merge, then need to adjust d_ino for '..', if
@@ -806,6 +807,7 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
 	}
 	err = 0;
 out:
+	ovl_inode_unlock(file_inode(file));
 	revert_creds(old_cred);
 	return err;
 }
@@ -815,7 +817,7 @@ static loff_t ovl_dir_llseek(struct file *file, loff_t offset, int origin)
 	loff_t res;
 	struct ovl_dir_file *od = file->private_data;
 
-	inode_lock(file_inode(file));
+	ovl_inode_lock(file_inode(file));
 	if (!file->f_pos)
 		ovl_dir_reset(file);
 
@@ -845,7 +847,7 @@ static loff_t ovl_dir_llseek(struct file *file, loff_t offset, int origin)
 		res = offset;
 	}
 out_unlock:
-	inode_unlock(file_inode(file));
+	ovl_inode_unlock(file_inode(file));
 
 	return res;
 }
@@ -929,9 +931,9 @@ static int ovl_dir_release(struct inode *inode, struct file *file)
 	struct ovl_dir_file *od = file->private_data;
 
 	if (od->cache) {
-		inode_lock(inode);
+		ovl_inode_lock(inode);
 		ovl_cache_put(od, inode);
-		inode_unlock(inode);
+		ovl_inode_unlock(inode);
 	}
 	fput(od->realfile);
 	if (od->upperfile)
@@ -966,11 +968,10 @@ static int ovl_dir_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
-WRAP_DIR_ITER(ovl_iterate) // FIXME!
 const struct file_operations ovl_dir_operations = {
 	.read		= generic_read_dir,
 	.open		= ovl_dir_open,
-	.iterate_shared	= shared_ovl_iterate,
+	.iterate_shared	= ovl_iterate,
 	.llseek		= ovl_dir_llseek,
 	.fsync		= ovl_dir_fsync,
 	.release	= ovl_dir_release,
-- 
2.44.0

