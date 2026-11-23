Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795433717;
	b=sPgBcIL9LB4Q2EEM6A1cCHjOKqzq0tC8BJMvWMFHafpfYXOlbfg8JIjmDOggNpe/9FLl
	 EBq4+ZHZ9bH6beX72cB6mnr8+Rm1DqCIvHOiJblW4+0HKKl093zcbAaHEnf0Zumde0NNs
	 SR2Te5DU70Da/R9gzEgBKUDMd26/EcRAqLd7GWK6OVpXFtifpqmzSguLND7AVGb0Ltqsg
	 AMcXembjhDhXI9H6DNL5M8cuvHYFG+NvYKGnOb8wrAtyjcqlzBVsh5vIxOTsv2hpMlLmm
	 jmm+A6kpKQ5kSdIqWYr4E/I2G5rMKPRBPkeWFuj7rR6rQfvmX9byF++WZkommH3E0lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795433717;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=cBQ1e4v+PxM0RWCwPsTi8odmO3BvILm6dYR2hRcjN1o=;
	b=bCvXi9XgYVEqtFhh/wkOCp0d6x/5xOGtfjnslhyYM2SvXjo5808ajES1Xhy7g4BLsSd7
	 nlqgsKB3HuhQURTlTwAjBS3i6RVszUXhDD5HVl5RV9m+x1dz+EAy6HV45gWZvI/4X7yUg
	 pS8R3FySd0YXiklrERrrxpDHnDKB3pyEhQYUzDru5qoTRWz9yHa1fg0CjmmIrxAHXx+sl
	 Li8r+irrs8+iV/H8ERzlOmILo2j13G0DDMBVu0g13CgrILrTUtvB1x0NovUnV2YxDFUr+
	 a16kwlZ2ZaeILGSS4GuioFZrE4TxUjmUZWvBqic+uA1TFufEeu2Fn2Vs8AXysQCYh6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tlX8c84n;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7C1606A327
	for <linux-unionfs@vger.kernel.org>; Mon, 23 Nov 2026 11:35:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC7C1606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tlX8c84n
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a5b2be99a8so26914145e9.2
        for <linux-unionfs@vger.kernel.org>; Mon, 23 Nov 2026 03:35:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795433715; x=1796038515; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cBQ1e4v+PxM0RWCwPsTi8odmO3BvILm6dYR2hRcjN1o=;
        b=tlX8c84nAAvWBtxLZslesIZP8QnJSlIEXVMsN/6WU78Pn/PCxEWXlxkk6j4u8zG1sG
         mubpmD8uz0RqnccYWFmuFLBRCp6hqFxo9AfSy2JIYtwY+MOIPYQgfcUaGHvZ8l8jp/D+
         2BbbZ7tGO+JTMgPMrn3cmK10/zIPlgLif3F//PjAVDkT5lCgLxoD/9JSBWA68nyO1fVD
         BmpB3MTNXcg/hfiPNV0h1ohtqI+8MN5O7YGs86vY6LLe0HiJ2D+yW/yvXUWjhyhlVJCu
         KgxicZilAeoqkoNweY433ldnWODRRVrKi1+EEg65g266CNP01fondNYYi7/IXM1utDsd
         P8jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795433715; x=1796038515;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cBQ1e4v+PxM0RWCwPsTi8odmO3BvILm6dYR2hRcjN1o=;
        b=zeHk1ILG040i+RFnBcebE5w82jIpC3GVi7N8X7PyDsiuuvwYzKBRRe6KpvqZB4WRIJ
         8dOhy+cnIjXCYGMMtvSP4FOQhKwr55N04qLdcpAVhiECfUMG2F1DfxEaFaqHp0kRPNWi
         NYLwVlay734kQBjZF7EHql5zqWkgWTt1wZLUg0t9li34xnwqgACRiduzHVvmlm4afUtz
         yDSbFnvuDtkWksVvgogPfH2tB9LufTe7od2DLNWMowhwnVfZfjnOd0+Zqob62w7nZB+p
         xqF+lmzbcFWbfU8ja52NvZaz2AfUaQICaJTUgrr94MPOqFNlVwRk3ePNXjqeGbm+hi/F
         89tA==
X-Forwarded-Encrypted: i=1; AL+hErHm/injZra4wAl/Cie3C4gBtXEWKpvubyZ7H+/a8QeZw3yr4Oq1Q0BCXVRVkxaMd4GInL08FJaxrD98xo3X@vger.kernel.org
X-Gm-Message-State: APuU4Z98pXHZl4kQOe8rNlhmJQuXvJEYdpSEHPWAtV12KpfsbmN06C/L
	6EKGEjZ130/Uo+BEeryz/RXYKE6E8fpIIz/OdaABt0kUenGGWb+sk40YprQDSzyQ
X-Gm-Gg: AZFdTZef1H6TTak44LdgqLbO/6ZGV0gZwbxbqafsZPldAGcCoJOOwfXbSJNxsEnsRgr
	LJeKfzfCjbE9ePAGBRsgciR6+Wv9YQg6wO/Ph159RprqmV6O/f4h8UuV5pzoUOb+3YxF040VVvJ
	QAWC95hRtg8Droahyi4GMRJ9ExBsytb4QzkuDJOqoXz2p6yYfoKgLsPGnrVrz3vTkVIBn6w3RsY
	hnuKtT2cac7cW92DmABrk+bEhi8QOmE+cGFxsyhb0mCyLzKrCFOkhmUZYIR+aQcNGZ4QVJeoXuE
	iZjjgafT55bFX+THFc1r/VlSuBEC/SXgtWUCKYhVJQzzZQYRAwDxK+NjBzFunVF77kCF0XkRAV8
	1hQXVA9gmaChzrvNeDbDI7OdeoppmWfkHej9YZOMR0I9POYsEm6vQI4WNTdUlfDFib6rukunjhb
	5yoAbuZQccYOPTkToslYMkekngX1cMDg558Y+PVHcOCss157terDj/YyrtJbX544x1njSapabPJ
	cbQRhPkAen2gBvfKTI7WybMwuCrFaDYrykOnBL4ooVCC7N4skfQxwlYU/KJBR+SUp2RG9gPKPFl
	G0S4gonmVzAvmG00Zh2VTdO+81u+Uaj0vjmmYqyyV512UiEjKnIngDb7Z1Kfz+InxiW/c8fOB2l
	9sW+VUeAOdHXk
X-Received: by 2002:a05:600c:674b:b0:4bb:6847:791f with SMTP id 5b1f17b1804b1-4bb8880f267mr223533805e9.7.1795433714601;
        Mon, 23 Nov 2026 03:35:14 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb9067a0e6sm135211175e9.4.2026.11.23.03.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 03:35:14 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Chris Mason <mason@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Theodore Ts'o <tytso@mit.edu>,
	Carlos Maiolino <cem@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] xattr: enforce the name and size limits for in-kernel callers
Date: Mon, 23 Nov 2026 12:35:12 +0100
Message-ID: <20261123113513.1910906-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.56.1
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

The xattr system calls refuse a name longer than XATTR_NAME_MAX and a
value larger than XATTR_SIZE_MAX, but the VFS helpers do not. An
in-kernel caller may pass a name or a size that it got from another
filesystem, such as overlayfs copy up from a lower layer.

Check both limits before calling the xattr handler of the filesystem,
and fail with the errors that the system calls return for them.

Cc: stable@vger.kernel.org
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xattr.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 0705801a62cc5..824e8349e8c10 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -178,6 +178,18 @@ xattr_permission(const struct mnt_idmap *idmap, struct inode *inode,
 	return inode_permission(idmap, inode, mask);
 }
 
+/*
+ * The xattr system calls refuse a name above XATTR_NAME_MAX and a value above
+ * XATTR_SIZE_MAX, but an in-kernel caller may pass a name or a size that it
+ * got from another filesystem, such as the lower layer of overlayfs.
+ */
+static int xattr_check_name(const char *name)
+{
+	if (strnlen(name, XATTR_NAME_MAX + 1) > XATTR_NAME_MAX)
+		return -ERANGE;
+	return 0;
+}
+
 /*
  * Look for any handler that deals with the specified namespace.
  */
@@ -209,10 +221,17 @@ __vfs_setxattr(const struct mnt_idmap *idmap, struct dentry *dentry,
 	       size_t size, int flags)
 {
 	const struct xattr_handler *handler;
+	int error;
 
 	if (is_posix_acl_xattr(name))
 		return -EOPNOTSUPP;
 
+	error = xattr_check_name(name);
+	if (error)
+		return error;
+	if (size > XATTR_SIZE_MAX)
+		return -E2BIG;
+
 	handler = xattr_resolve_name(inode, &name);
 	if (IS_ERR(handler))
 		return PTR_ERR(handler);
@@ -416,6 +435,8 @@ vfs_getxattr_alloc(const struct mnt_idmap *idmap, struct dentry *dentry,
 	error = handler->get(handler, dentry, inode, name, NULL, 0);
 	if (error < 0)
 		return error;
+	if (error > XATTR_SIZE_MAX)
+		return -E2BIG;
 
 	if (!value || (error > xattr_size)) {
 		value = krealloc(*xattr_value, error + 1, flags);
@@ -434,16 +455,24 @@ __vfs_getxattr(struct dentry *dentry, struct inode *inode, const char *name,
 	       void *value, size_t size)
 {
 	const struct xattr_handler *handler;
+	ssize_t ret;
 
 	if (is_posix_acl_xattr(name))
 		return -EOPNOTSUPP;
 
+	ret = xattr_check_name(name);
+	if (ret)
+		return ret;
+
 	handler = xattr_resolve_name(inode, &name);
 	if (IS_ERR(handler))
 		return PTR_ERR(handler);
 	if (!handler->get)
 		return -EOPNOTSUPP;
-	return handler->get(handler, dentry, inode, name, value, size);
+	ret = handler->get(handler, dentry, inode, name, value, size);
+	if (ret > XATTR_SIZE_MAX)
+		return -E2BIG;
+	return ret;
 }
 EXPORT_SYMBOL(__vfs_getxattr);
 
-- 
2.56.1

