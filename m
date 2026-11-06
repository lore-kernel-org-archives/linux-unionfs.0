Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793938293;
	b=Hm0PobiUnMNu24X33VwYsXKY+GtjaPMK9kVuHGxFYcgBWVhJKL1ag/FEH2bwbTGnXkvB
	 uwL9HtEzBvRY3VZwplrl/mHtLgIvhnJUAi5PBh5oYDC5JJSBn6InV+hYeF/xrN0QK/Yry
	 aDo8a1hBTZhtZBniphLhRst40wDIkmGbVLdVxfmPfHRQIbryrzKCL6VSbo0PFmA3AmP4q
	 MNvEjOaMhoBCT7mCTgt8AMaHh7Dkmu7cPD7ifpQYp6rHQZRWtFM5x4uDuDDE1K/UnfcPy
	 bZThnsNOu9NM9GurQhSFmyA9BstP73Xu107drcwocUF86aDkyA8c5XhatvNu/DsWqmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793938293;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hRqDyoHEktqTbeAVhFKCkfdyebDYCapo3zaf99hygaE=;
	b=Gc+kMwpLOTp7CAjic8oes/H0SL5UzsqrKVVwBjB4iE4QoNhYdBCOAMNxtgZKT+HAuRfO
	 SptiZfcGWFEX7Uh969JZYAUy4fU5U8mEllFWXWid6SKfoUdYGSKjU4iM51nAkEg9Nj3xa
	 C/Lr/GcAt8C22wl3vJKB0djkkYwH/HoW6xCN7xu+S0Uhjoccok8Nr+teOW3CJSPf6rL+c
	 WrfTjxa7xIidoCTOmbghckiZgrai4IizkIKKwKrW8q4d7vSx+tOc46/Yupeumbdvxo2BI
	 KPX+hNDw+JCM/nojefxOyAtf+h/vDPa+c7H4Q/rAv++s3XSLMdJ4eIb+Rt528i49aRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OXZuYWwf;
	arc=none smtp.remote-ip=209.85.218.52
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56A3606A326
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Nov 2026 04:11:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A56A3606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OXZuYWwf
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c450ab1483cso31790766b.3
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Nov 2026 20:11:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793938291; x=1794543091; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hRqDyoHEktqTbeAVhFKCkfdyebDYCapo3zaf99hygaE=;
        b=OXZuYWwfTOPxLnSgIkf0JBcfVXToSswyq5KC98vzDZMOwgX0f9LfRSD4fI2Sm4Stnd
         B0EZJRNpP/T83pz5PNZWHbbME24F40Q1chxZbhzeC0B0KCwiF5C3LETG5p2e3f+fZGtr
         YACVZWqX+hqP7zrnIF+Okj0cCSEqH7XFxGKDbduhX8YYHB5JMzR3xiMVnfDWh8nFc4sf
         zMA13gFh5uOj/ntOAdFkh5HE+ERYPUcBVD6jPMrc89wkWmarZIYehF7P8lDAmBK6OgQn
         lxV8O6qJdnffGIogXiFy/wmJ/AFzBKDCwpNnlD26yuFAoWayzqU3jDHJ9KhajDL0jKB3
         ot/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793938291; x=1794543091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hRqDyoHEktqTbeAVhFKCkfdyebDYCapo3zaf99hygaE=;
        b=VMEZadlh/xPHxWcs6BIXj6uS4pW/jOBBvuTxfLUBJfJ1iDArOWe660NlNd5q0aXEfK
         1h4JVOi9BCppsP01tX3f+4XTGGN7tsA4n2UjcetJKAWsT6tj2V0ZNWyUdsDS6yD0oKI5
         zbrxKbSciYkFcYrrbmI6QQeevahkbohe23vC1LAxT19OxuE6JPAPbqW8sVCM+QARncpT
         fxNUNUWmFvFiP9hMTcnTPo6LVz0mNwarjYrdW9BreILSxqWF+pc6SxQB32qR5D4wFSje
         4YRG21PLegnG5Vfz5mYT2DRxs0/gsCFF7rwj7XTSs5WpHTypCpsixE1f9nvuvIKERa8D
         5ciw==
X-Forwarded-Encrypted: i=1; AKwUvBxRqd/jUx6iFblyHDF5GE5nIBgL7DGjC5cNajbCz3bQuZ+XsISw/Tma1dvzLDljPXiyyTC7ZwQd8kWxvF/I@vger.kernel.org
X-Gm-Message-State: APuU4Z8MGwh1GVeffYb4pRBnpY0eFGR1M7W1HUTo+CMDVDM4GRTVU2az
	u+7myFogBKo1aEjv+lIM5o8ugAlesjqYUBvKjlIbsOrBh8pAg5RjYmYk
X-Gm-Gg: AYBFou3MbNe7Ovr1JUb4/S0f5h934yjF1GZhbH5CwSioVGVJ+JQk3/JGCctYyI/xKnw
	Ig+ZQ5OZUKGLpjlO7uXhoiKy0IMxZ4cKVj5OU3OaMXw7Fp0L3sbawYhT4dS6rNsItsF7ueNotf9
	v/0UC5DioultiQJmIxEXs4B7N+wVC4+6T4nWK7Ar/Li1EvX75Cdbv32T105wSU4GAeFOZibyCJk
	YT36kMFBKChFqQY+mgtFCUoVbfZFrIRwRsHh0CBEzaPh6/RnRv9jpXsAMefXpSjMAuS3yTm944j
	FDNYliBhJpYz1ASMfVjEttEGJ5NeI4kTkBK2rxtcQ4/3C4aP9qT6+/e/RUw/lCSWWfpF/SMI5K+
	A3cKl5YYIrKT5a0dYEOZODa5j8kKELXBXcx7o5h4jexZkr2j/yof+6FC8pCXzQyYYyV4/9jeuj8
	CQKPS4YSjnBOKz9Wxiq0cYRJEfbvLhVVdGCQ2H0Ln5YvaMaTB8NMcP/iFDmyFuitWrFcZCihm5P
	rHLEFB0XsqNVHVPUiWrZ2FyJDXOdgB44cV/4vJ7w87CBWKznK9+VEtZoFOGADjgDW82ZQ2Z41+f
	3I1N5AZz7fN8Sv761fq9/kfyhVxIayRjqtPs8NDVWqrYbYsiQoXWYSMxzAsrlviv/Yi6Uu84MvY
	yaPXtr8qw+KXbmg==
X-Received: by 2002:a17:907:c0b:b0:c41:731c:534 with SMTP id a640c23a62f3a-c4d352c83c7mr112719366b.24.1793938290939;
        Thu, 05 Nov 2026 20:11:30 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d3566f7fdsm43067166b.31.2026.11.05.20.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 20:11:30 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	stable@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.1 2/3] ovl: hold a reference on the parent in readdir
Date: Fri,  6 Nov 2026 05:11:21 +0100
Message-ID: <20261106041128.3797453-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261106041128.3797453-1-amir73il@gmail.com>
References: <20261106041128.3797453-1-amir73il@gmail.com>
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

From: Chris Mason <mason@kernel.org>

commit 16d319e12328acafeafd3eecdf09c46d7fb43452 upstream.

Listing a directory on an overlay uses a freed dentry and crashes the
kernel when a lookup moves the directory at the same time.

Code that can sleep may only use d_parent without a reference while
something stops a move of the dentry. ovl_iterate_real(),
ovl_need_adjust_d_ino() and ovl_cache_update() use the d_parent of the
listed directory and hold only the lock of that directory. When a
lookup finds the directory under another parent after a change to a
layer, d_splice_alias() moves it without that lock and drops its
reference on the old parent.

With a delay in ovl_iterate_real(), getdents64 on an overlay directory
raced a rename in the lower layer and a lookup that moved its dentry,
and after an rmdir of the old parent KASAN reported a use-after-free in
security_inode_getattr().

Fix this by using dget_parent() in the three functions.

Fixes: b5efccbe0a12 ("ovl: constant d_ino across copy up")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[amir: fix comments in ovl_need_adjust_d_ino()]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
[backport: no ovl_need_adjust_d_ino(), take the parent with dget_parent()
 in ovl_iterate() and test a local flag]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/readdir.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -474,8 +474,8 @@ static int ovl_cache_update(const struct path *path, struct ovl_cache_entry *p,
 			goto get;
 		}
 		if (p->len == 2 && p->name[1] == '.') {
-			/* we shall not be moved */
-			this = dget(dir->d_parent);
+			/* d_splice_alias() can move even a locked dir */
+			this = dget_parent(dir);
 			goto get;
 		}
 	}
@@ -693,6 +693,7 @@ static int ovl_iterate_real(struct file *file, struct dir_context *ctx)
 	struct ovl_dir_file *od = file->private_data;
 	struct dentry *dir = file->f_path.dentry;
 	const struct ovl_layer *lower_layer = ovl_layer_lower(dir);
+	struct dentry *parent;
 	struct ovl_readdir_translate rdt = {
 		.ctx.actor = ovl_fill_real,
 		.orig_ctx = ctx,
@@ -703,18 +704,26 @@ static int ovl_iterate_real(struct file *file, struct dir_context *ctx)
 	if (rdt.xinobits && lower_layer)
 		rdt.fsid = lower_layer->fsid;
 
-	if (OVL_TYPE_MERGE(ovl_path_type(dir->d_parent))) {
+	/*
+	 * The lock on dir does not stop d_splice_alias() from moving it to
+	 * another parent, which drops the reference dir holds on this one.
+	 */
+	parent = dget_parent(dir);
+	if (OVL_TYPE_MERGE(ovl_path_type(parent))) {
 		struct kstat stat;
 		struct path statpath = file->f_path;
 
-		statpath.dentry = dir->d_parent;
+		statpath.dentry = parent;
 		err = vfs_getattr(&statpath, &stat, STATX_INO, 0);
-		if (err)
+		if (err) {
+			dput(parent);
 			return err;
+		}
 
 		WARN_ON_ONCE(dir->d_sb->s_dev != stat.dev);
 		rdt.parent_ino = stat.ino;
 	}
+	dput(parent);
 
 	if (ovl_is_impure_dir(file)) {
 		rdt.cache = ovl_cache_get_impure(&file->f_path);
@@ -741,16 +750,19 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
 	if (!ctx->pos)
 		ovl_dir_reset(file);
 
 	if (od->is_real) {
+		struct dentry *parent = dget_parent(dentry);
+		bool parent_merge = OVL_TYPE_MERGE(ovl_path_type(parent));
+
+		dput(parent);
 		/*
 		 * If parent is merge, then need to adjust d_ino for '..', if
 		 * dir is impure then need to adjust d_ino for copied up
 		 * entries.
 		 */
 		if (ovl_xino_bits(dentry->d_sb) ||
 		    (ovl_same_fs(dentry->d_sb) &&
-		     (ovl_is_impure_dir(file) ||
-		      OVL_TYPE_MERGE(ovl_path_type(dentry->d_parent))))) {
+		     (ovl_is_impure_dir(file) || parent_merge))) {
 			err = ovl_iterate_real(file, ctx);
 		} else {
 			err = iterate_dir(od->realfile, ctx);
-- 
backport
