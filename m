Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793818439;
	b=ksVgVAkgygHTY1b+FFESc51rGOKmmUEIcB6JOFY/iEb/7J9FO/mjwJXLo00chx6kBWf6
	 04IjRBRnvf3SxLGt0FZt6R2lXnHTRfeWnmTznFS3bllQb7Rf4z3jt545YEC6cP+Czx7Bl
	 OyXO5sqeKSDUSutNOi3HRvwEezjdF0EMtmWSEKP+uagaXcfCs/at8XREEyjGnr7rU1DAY
	 Q8c7YprnQPaLZthclpEM5YVHZwQXZFQeApPtqPoehq31X97AOIkwg49eo8ipD58f+3AqK
	 wiGJ/W5X1MzOcWe1BoipgiB98LWNPDI5DTHacbf/bwmeph9ifX5FuoH7+8Y5Tzzj5Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793818439;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=G5wbYNiPhAHIb+26anH3v3vEHstJg4FjlaenE/QZAko=;
	b=VNAJkt3DVylbKlgw3v6kJbhRdVLRPmfH0IztnyEJhnTtDAYx4+ptHwfeILsH3q0FzxlY
	 p0g6kdxaNigtzi9Nhjpt2O1UQZWxBq6UwYV7y1sG4MnrQHezXLHvbqWTSumK/m3yCJ0lv
	 Vr7WhyUcqyoUuj+aD6JbAVi9iosDLjtSdJikMrFOUaNIm9iAYfF78JBh91rwYiqdPYqaX
	 JShl/yY0db637RpUrtVGZbWO2+co93jXrW5IzRG4SRVU/R3/ThLMDtPsMdAX1lj1++qs/
	 YzTN9VJY8krO/GPQXaCaSKDquoYQ0GjpadKWsfm6JtY7qXY26HkZqvt8+FHWowPALWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=w4gDAWve;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53417606EE9D
	for <linux-unionfs@vger.kernel.org>; Wed,  4 Nov 2026 18:53:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 53417606EE9D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=w4gDAWve
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a35a60499eso8508705e9.0
        for <linux-unionfs@vger.kernel.org>; Wed, 04 Nov 2026 10:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793818438; x=1794423238; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=G5wbYNiPhAHIb+26anH3v3vEHstJg4FjlaenE/QZAko=;
        b=w4gDAWveJlfcdoihCDwXx9RBMOCcH2h36Pa3eLdnrl6Lr7QVTrk2MGx7+S3FCayk70
         7WjWbLHkvBIBmS3ANQEjxQ2lu1mdA9B2+n0F4vfWLs6YZOazhKD/MPiQ4MUNEOD9kKjx
         I/yYl6a8IBCaUqWOQihMxMlJj1mIUnyKMBuG5FrT02+OY5eULftm7IRmrfPUxNpOQh8+
         QCfy1WorYWqAWla7SuKWP03Yl4waWffqS74izShxCKyJ7RLumPEMa74/CcIGYwpkdAJ6
         vy1jLgELsrW6LDIHjuYqyLS1nPRXPGoOZz4yXDFq7GtzTPjVvxybRA9i8qKf8IIQiKDa
         Yy3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793818438; x=1794423238;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G5wbYNiPhAHIb+26anH3v3vEHstJg4FjlaenE/QZAko=;
        b=y/ZwOekltWbNaaBj0NnmwqoQfU1PGqVSylo6NePV5JhKRQlfNSxZzeXBQue6VHFe/w
         kvt9uUkeiV1+QTsCPcrfxW9Mlymeu/X2meEFUmxJ2Hm0p+LYWeGO8QLf/3TPxMeIXIZ3
         W4A6EMVFVEzR+dTbxRNcuZUt8ewQUSzevhx0HjgZhC4Q4QVpw8hCKW0ROcgWY+4Do19y
         w4BJI8fDigcU+hODPqt+wzYOrX+Qrq/rt4CqKAJVOTFTXABO/aj4l5oUQUWJyr003h+o
         ggEj8V5BbPMVrsqbuivZncIacUF57oHKHP/HoOeJZQ0a7ncCwPNImHOCfpa2g01BC0wi
         AcWw==
X-Forwarded-Encrypted: i=1; AKwUvBzigMasYqM/V2yM31mwcuJopyYyVNNHTqhulocYZZ7anZgqdrgNn+HJxHiGYPNac5iUthi/WTUc1Gs994uA@vger.kernel.org
X-Gm-Message-State: APuU4Z+2b3mfTsUkdrHVN+QmqDJnJA+2Ybph4cksM0JHcPPfN/pE3YYa
	HPNdlsiRLWo1EZ7ivQD9m5BgfrhSXBoV9QyWuJqoxUaZ8YeJw6elDT5GiBNTqSLJ
X-Gm-Gg: AYBFou01VjIp1s3MyGSYrNc+GJdAHcyYhZINMB8C0YLJD434RVR6IQKbST/885bwYp0
	GhphzUm3rXfefnpFm9NgC2pX5lfbJNUOa4O9eGwNVpGBH9VZctJP2NcX10tVbhJTeA1vySo/r4n
	uuX9dUr+anRfYBJAn6IOk7o8DIf4fHFz35T25BZZAllfXUtHmRvb2/0lPWHHfWetm3sfW4Js6SE
	zFriKRhx2dMXl5SnwLx5T35H+mI8jQXVBAV8U/Fldyvzvg5X4oMp5Rasl6VybyDlBOU/90IkGmh
	2DH2zj0wAUm64ycd6SOh3ZjXaTnxsJ/VW3btVk+TXbpgPrayZXwP7BNLh2rjnJ3C3UyigucdUOP
	lgNYMFo/jE4pAhIoIHZpss6+UmAS7uqmYxT8jF2BUEH10TVlXuHecRbn+Uu8J6Gfb5/h+KKfelP
	i+0yP+spHAg/0bWdLYRkgncjtaHelrFm8nxSWRBzAdvHQs49x7p4IWB6enepeh2/4EKtclXQSPo
	ozzYML8Ts6puRNBO1HiFisxIhRIvAKIfnt5LIvPwdbhKv6k3zRSXxmJ7JvYuT0j2zkRBujJzUJ5
	wTgg2QrNeBEGEx6SbzR+6F5+O5pVYfW3QSmG8CBFV6JfO3SILR4HI51R4N+WkZWCWsm2MCFOmIH
	rhlqas13B4Cs=
X-Received: by 2002:a05:600c:8b04:b0:4a1:fb01:13 with SMTP id 5b1f17b1804b1-4ac17a3683bmr388138315e9.18.1793818437576;
        Wed, 04 Nov 2026 10:53:57 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b57317cb8esm3727555e9.13.2026.11.04.10.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 10:53:57 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	stable@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Fahad Alharbi <fahad@codepure.com>
Subject: [PATCH 6.1 1/3] ovl: fortify ovl_copy_xattr() against underlying layer modifications
Date: Wed,  4 Nov 2026 19:53:55 +0100
Message-ID: <20261104185356.3631002-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.55.0
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

commit e6b9117076fb4c0ff4a670efa9c876d9a50d79ab upstream.

Adapt ovl_getxattr_value() to be used from ovl_copy_xattr(), by
allowing to pass it a pre-allocated buffer, which can be resized
and by handling the ENODATA/EOPNOTSUPP return codes in the caller.

This replaces the retry loop in ovl_copy_xattr() with a single retry
after resizing the buffer. If the value changed again by then, the
underlying layer was modified, so return -EIO instead of retrying.

As a side effect, ovl_copy_up_meta_inode_data() now returns -EIO instead
of -ERANGE in this case of underlying xattr size changes.

Reported-by: Fahad Alharbi <fahad@codepure.com>
Tested-by: Fahad Alharbi <fahad@codepure.com>
Suggested-by: Miklos Szeredi <miklos@szeredi.hu>
Link: https://lore.kernel.org/linux-fsdevel/CAJfpegsVoUyqy0dYkTvBGRZvgdv_nmzmCw_uF+LP-Vq3EhEkSg@mail.gmail.com/
Fixes: e4ad29fa0d22 ("ovl: use a minimal buffer in ovl_copy_xattr")
Cc: stable@vger.kernel.org
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
[ backport: context: ovl_must_copy_xattr() instead of ovl_copy_acl(), no
  blank line before the retry: label and no OVL_VERIFIED_DIGEST;
  depends on 755b5c5c9277 ("ovl: do not copy up an xattr value that was
  never read") ]

 fs/overlayfs/copy_up.c | 68 ++++++++++++++++++++----------------------
 1 file changed, 32 insertions(+), 36 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -44,6 +44,9 @@ static bool ovl_must_copy_xattr(const char *name)
 	       !strncmp(name, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN);
 }
 
+static ssize_t ovl_getxattr_value(const struct path *path, char *name,
+				  char **value, ssize_t *value_size);
+
 int ovl_copy_xattr(struct super_block *sb, const struct path *oldpath, struct dentry *new)
 {
 	struct dentry *old = oldpath->dentry;
@@ -93,34 +96,12 @@ int ovl_copy_xattr(struct super_block *sb, const struct path *oldpath, struct de
 			error = 0;
 			continue; /* Discard */
 		}
-retry:
-		size = ovl_do_getxattr(oldpath, name, value, value_size);
-		if (size == -ERANGE) {
-			size = ovl_do_getxattr(oldpath, name, NULL, 0);
-			/* Nothing was read into value, so it must not be used */
-			if (size >= 0 && size <= value_size)
-				size = -EIO;
-		}
-
+		size = ovl_getxattr_value(oldpath, name, &value, &value_size);
 		if (size < 0) {
 			error = size;
 			break;
 		}
 
-		if (size > value_size) {
-			void *new;
-
-			new = kvmalloc(size, GFP_KERNEL);
-			if (!new) {
-				error = -ENOMEM;
-				break;
-			}
-			kvfree(value);
-			value = new;
-			value_size = size;
-			goto retry;
-		}
-
 		error = ovl_do_setxattr(OVL_FS(sb), new, name, value, size, 0);
 		if (error) {
 			if (error != -EOPNOTSUPP || ovl_must_copy_xattr(name))
@@ -896,26 +877,39 @@ static bool ovl_need_meta_copy_up(struct dentry *dentry, umode_t mode,
 	return true;
 }
 
-static ssize_t ovl_getxattr_value(const struct path *path, char *name, char **value)
+static ssize_t ovl_getxattr_value(const struct path *path, char *name,
+				  char **value, ssize_t *value_size)
 {
 	ssize_t res;
 	char *buf;
 
-	res = ovl_do_getxattr(path, name, NULL, 0);
-	if (res == -ENODATA || res == -EOPNOTSUPP)
-		res = 0;
+	res = ovl_do_getxattr(path, name, *value, *value_size);
+	if (res == -ERANGE) {
+		res = ovl_do_getxattr(path, name, NULL, 0);
+		/* Xattr changed underneath us? */
+		if (res >= 0 && res <= *value_size)
+			return -EIO;
+	}
 
-	if (res > 0) {
-		buf = kzalloc(res, GFP_KERNEL);
+	if (res > *value_size) {
+		buf = kvmalloc(res, GFP_KERNEL);
 		if (!buf)
 			return -ENOMEM;
 
 		res = ovl_do_getxattr(path, name, buf, res);
-		if (res < 0)
-			kfree(buf);
-		else
-			*value = buf;
+		if (res < 0) {
+			kvfree(buf);
+			/* Xattr changed underneath us? */
+			if (res == -ERANGE)
+				return -EIO;
+			return res;
+		}
+
+		kvfree(*value);
+		*value = buf;
+		*value_size = res;
 	}
+
 	return res;
 }
 
@@ -926,7 +920,7 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
 	struct path upperpath;
 	int err;
 	char *capability = NULL;
-	ssize_t cap_size;
+	ssize_t cap_size = 0;
 
 	ovl_path_upper(c->dentry, &upperpath);
 	if (WARN_ON(upperpath.dentry == NULL))
@@ -934,7 +928,9 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
 
 	if (c->stat.size) {
 		err = cap_size = ovl_getxattr_value(&upperpath, XATTR_NAME_CAPS,
-						    &capability);
+						    &capability, &cap_size);
+		if (cap_size == -ENODATA || cap_size == -EOPNOTSUPP)
+			cap_size = 0;
 		if (cap_size < 0)
 			goto out;
 	}
@@ -961,7 +957,7 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
 
 	ovl_set_upperdata(d_inode(c->dentry));
 out_free:
-	kfree(capability);
+	kvfree(capability);
 out:
 	return err;
 }
-- 
backport
