Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8291E126F39
	for <linux-unionfs@vger.kernel.org>; Thu,  7 Mar 2024 11:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709809352; cv=none; b=rdTdJDbsLl1JjYrdfOq7fUg5cTusZKmpQx6zo7sMO5RBlmfeN3RO+hjy8v/e79vsXi+UDh40KloycvrdqUFI1rGvJiFhkPTvq1IAwgl1b/EbGX3ZJWVNHJqA072S19Q52eE6nUSlePjkGeE6kqIM/3VkM8ORoERaOsHOegGNNhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709809352; c=relaxed/simple;
	bh=0QSQnxyjKd0GA5iCm7uDjwuB0eToFvjoyYNhhg6+cLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H3Hneqyo58YUBmSkCHc23/sPEEwY34kOArAtsCCEkwzkBHPmjvRFgUVdzI1yd5oFcH4mLZUFiQEIfc+aXEqbMVA7CU5a2dACSak9S2zhuykefYTvay7wLpaDZp6JAnNnpV7bVh0xqAurrH1o6GlCff5iwNMP79XVwfWw3l94fH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JTxKS9Uq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JTxKS9Uq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709809349;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sqEbdTxhH+AlXN0X2BsJ2SrYEHV0BB3bqwnGH/m+9AE=;
	b=JTxKS9UqfjlgvJHrL8HKhkf+jomlLc/byYLGQxPO1zxfkxeeyd9bU1i3Y7uQm1Nmo6kKbt
	e/TsYXjPcNUYxuEoSe5qG7g8CRSo+H5ftVIJGdcScAe6O+3p7EtxNi1zKM+f19wuxvDwJ6
	zYlfXy0cakD0TautNxTCtLisnnY9WA0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-193-jDlrkWd0N6OJtwZe6EJWlw-1; Thu, 07 Mar 2024 06:02:28 -0500
X-MC-Unique: jDlrkWd0N6OJtwZe6EJWlw-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-412dcaf0bd6so3815015e9.0
        for <linux-unionfs@vger.kernel.org>; Thu, 07 Mar 2024 03:02:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709809346; x=1710414146;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sqEbdTxhH+AlXN0X2BsJ2SrYEHV0BB3bqwnGH/m+9AE=;
        b=JDpAP0olMphusoo9T9p55oRqGOFpxBrhIZm7ytWAB3wI5bLqrvixlv85jq0GzcBJZG
         zFla6sgO8KMjWlzWadWqjz+8V/SSVExKyXwzfTjAWIXf7XLFqNoeOZWdlzmevJ5dxKrT
         ShtHaAk3GtxLS25NFW2S2JMjJGiYs8eM1NxsrF/70OtL6r88YFvuweB+W8Xlqyuv17RL
         JrVwJIcA8SmyBBk0W6GjTIIOeIcKNJfpxnwmLZmN2QLa6rqSIrSHgh/7IHKU1ts3+0oR
         WyN6vTCa5p7ZcT3+TElrMYCu0G4nH60F0AmVnc3CN9MH4WzFtGPp1/ISZD71yyt72MUo
         751w==
X-Gm-Message-State: AOJu0Yye0/SWgMzTcQxv2gVFeOqZ0Rerh9HIpBI9ZADJ6l2eOu5ViJRN
	EreZhAvjnQa/+P9QPd+uCFSf45clY/cRgyQ2bj7lgzeqkKg4p9CrNmhXomXfpEX3wG9HuAfy8xk
	IK1cd2TlveDJbEpXTl0FkObOYfcaaeiiTdCybl0UnURku6hlzbMKxb027IpdPioKffYGMM+JlLY
	Y0EoJ9rSjsxnWAqwY2CR/ynyLGZY3rQGf9f0WLVBGbAbgRpf4=
X-Received: by 2002:a05:600c:5185:b0:412:f6cd:ad8f with SMTP id fa5-20020a05600c518500b00412f6cdad8fmr3261510wmb.4.1709809345956;
        Thu, 07 Mar 2024 03:02:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHtDWB/ZSmiASu9PIAgyOKOj+RelMGT3+2vbYtyDguf96RbKmQmpuXxyZtBIwzZwrxTs3pJ0A==
X-Received: by 2002:a05:600c:5185:b0:412:f6cd:ad8f with SMTP id fa5-20020a05600c518500b00412f6cdad8fmr3261485wmb.4.1709809345487;
        Thu, 07 Mar 2024 03:02:25 -0800 (PST)
Received: from maszat.piliscsaba.szeredi.hu (92-249-208-180.pool.digikabel.hu. [92.249.208.180])
        by smtp.gmail.com with ESMTPSA id v12-20020a05600c470c00b00412b4dca795sm2332625wmo.7.2024.03.07.03.02.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Mar 2024 03:02:23 -0800 (PST)
From: Miklos Szeredi <mszeredi@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: Amir Goldstein <amir73il@gmail.com>,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 4/4] ovl: clean up struct ovl_dir_cache use outside readdir.c
Date: Thu,  7 Mar 2024 12:02:08 +0100
Message-ID: <20240307110217.203064-4-mszeredi@redhat.com>
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

Remove unnecessary forward declaration in super.c and move helper functions
that are only used inside readdir.c

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/overlayfs.h |  2 --
 fs/overlayfs/readdir.c   | 10 ++++++++++
 fs/overlayfs/super.c     |  2 --
 fs/overlayfs/util.c      | 10 ----------
 4 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index ee949f3e7c77..167dc37f804c 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -470,8 +470,6 @@ struct inode *ovl_inode_lowerdata(struct inode *inode);
 struct inode *ovl_inode_real(struct inode *inode);
 struct inode *ovl_inode_realdata(struct inode *inode);
 const char *ovl_lowerdata_redirect(struct inode *inode);
-struct ovl_dir_cache *ovl_dir_cache(struct inode *inode);
-void ovl_set_dir_cache(struct inode *inode, struct ovl_dir_cache *cache);
 void ovl_dentry_set_flag(unsigned long flag, struct dentry *dentry);
 void ovl_dentry_clear_flag(unsigned long flag, struct dentry *dentry);
 bool ovl_dentry_test_flag(unsigned long flag, struct dentry *dentry);
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index b98e0d17f40e..4a20a44b34f2 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -61,6 +61,16 @@ struct ovl_dir_file {
 	struct file *upperfile;
 };
 
+static struct ovl_dir_cache *ovl_dir_cache(struct inode *inode)
+{
+	return inode && S_ISDIR(inode->i_mode) ? OVL_I(inode)->cache : NULL;
+}
+
+static void ovl_set_dir_cache(struct inode *inode, struct ovl_dir_cache *cache)
+{
+	OVL_I(inode)->cache = cache;
+}
+
 static struct ovl_cache_entry *ovl_cache_entry_from_node(struct rb_node *n)
 {
 	return rb_entry(n, struct ovl_cache_entry, node);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 2eef6c70b2ae..2413d3107335 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -26,8 +26,6 @@ MODULE_DESCRIPTION("Overlay filesystem");
 MODULE_LICENSE("GPL");
 
 
-struct ovl_dir_cache;
-
 static struct dentry *ovl_d_real(struct dentry *dentry,
 				 const struct inode *inode)
 {
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index a8e17f14d7a2..cfe625717c47 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -421,16 +421,6 @@ const char *ovl_lowerdata_redirect(struct inode *inode)
 		OVL_I(inode)->lowerdata_redirect : NULL;
 }
 
-struct ovl_dir_cache *ovl_dir_cache(struct inode *inode)
-{
-	return inode && S_ISDIR(inode->i_mode) ? OVL_I(inode)->cache : NULL;
-}
-
-void ovl_set_dir_cache(struct inode *inode, struct ovl_dir_cache *cache)
-{
-	OVL_I(inode)->cache = cache;
-}
-
 void ovl_dentry_set_flag(unsigned long flag, struct dentry *dentry)
 {
 	set_bit(flag, OVL_E_FLAGS(dentry));
-- 
2.44.0

