Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164CA2264D6
	for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 00:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778892786; cv=none; b=FvD0uLbF0FbUJnaqLqyxXhnCMljvbJewI4t8Gd5H/PV8b9FRAGMobWGO+K5N6nTPSkr/RXrXG8NxfT4565899RRJFfu5f5szuNyOU0wGd/whPlKq1VmAlw02LEhpf9H714pnfJ89AdRsyfQfPkyPRbgDdIkqGJinUrYEUIpfqG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778892786; c=relaxed/simple;
	bh=pB/iMarwsGvZxdwSqwkF0CCgm1K7/63lXSX7V3m4wBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mUn50z0PPXj2vQIMItED10fwG8MTmaS+BjwY8IAy+Tu6t6BR1QCBkCXIK+2RbqQCLQNl0aGA1msEG/LGFWQDdNF+Xuz+Fp8YjMPADHt0+omETQFQyeubYUj4gDNRWbhNjrpoktsGGslY0vGUst9Ojk7iEM2nfoL0RqjjfLk1o38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KD3k8H6s; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KD3k8H6s"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-7b41fdf9de2so398397b3.0
        for <linux-unionfs@vger.kernel.org>; Fri, 15 May 2026 17:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778892784; x=1779497584; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Aw3LBRGJ21Qgcn+sxKL5AGoP01BrPzR1EMWQXzshZ7M=;
        b=KD3k8H6slLo+x0y6Xh+r7qbGOl7wOuAmImPy2OOvHbAZF9l8+JJyuuBvhyq/do4G3b
         clsGJIQD6E1Prk/XI63DYKDrZx9MtryhlA2QmfuHaCm8bqCxAGCiqA13wFfedwTSf2pC
         ze2zqoToB0T8jTZVGvEedHpzNLws382u0KZa7IK5RklM+RKisSHp2FU/kh0iTFkp+pL4
         ImlwPi2m+KWynpPfx96W4or6OlZkTR6dO5IlQ5hDOu+PtjrL+xU8SrLPDtHOkdYgjNeO
         5d+z339lxmr8Ea+mJ+fv0l4sWuDGpF9MgNOPj3lznzcvgCYeBIz/J647cfEUUkNcZ3r1
         cTfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778892784; x=1779497584;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Aw3LBRGJ21Qgcn+sxKL5AGoP01BrPzR1EMWQXzshZ7M=;
        b=iWxtN+R8RCB8f/SnaRrbeV+lS87AeHNZny+ry+kFmoa7HPfMbsrKTaUq3Z9HpwNLnS
         oc6OzKJrOf8Cf69ow9vTPeGOlExlG+cJjBlzpEqsKovX4vWV8q83jO4Q32BicJwEbILF
         gnMXAF9c8sKJ+BBgPniM27P1KDwbRWEHM+K7rOHGl3QwUToxgrh592/GAMNNIdabzlwX
         TZgcY59gdnnUkxzyb7S9EgTMV/AF2AlNRTeDRswqPoOiLA2HXSTp13AzvZxntKPPTI3G
         um3IW4MErcIFilZ0sYmxbPcbDId61AYtBYCIkNaKLNqPMaCRczzNL371P+qy+/Pe9PMX
         54Ww==
X-Forwarded-Encrypted: i=1; AFNElJ/V1OFrnoff0j42qDefu9XHXG+oXYqPxH+IzoCuDKmFHdvd27MtqVfNARhZuZhUmPi9dNjyFAhLa1j3mtBa@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3SvXdiw803MFJlwghLXWY6jEi5eBSjd6sugHVjJ+SXtis8+r0
	sAvQ28CnzRTawybANPBMUuyKReyLK7DhRpGePbk+jFcXIsrCMehs0YAr
X-Gm-Gg: Acq92OFQFSLh9CfRRzUth+7WAt2Wsm1Bt9a/BoblIn29exx6tF5UBzf43Bwjfpx2rKw
	LVbO/Pjs87no9jjPp8lmmlS7WAE0HOIe4wMtXZaagED2aLtFAM9KFAFN9L1BvCWa9Qykq73Yhvn
	nOuJapP58PtWS6ZqulEBoMgi/K9BUuGiE1xfAc9DODo5XD1O+IOYWXE9vGwYauGPQEyeeG/sHk0
	4lMI+uDALvYXvoLuKwX2YwWNP4Q+ANMDrGkJOmEA5k3jHkeI10zx3iWfPKIUkNuIVq0dm5gK55+
	XyLIekyDDlwqEvmIbypI88BbCEpPzfX2NwTlNtI5qsagcCIr9ZPVPib6Q53aSqJoW+GtxpvG8oi
	BkuInzZoqQrXhwayELLIOkGuie3I3+EJJW5RevS8qLQZ8KaPgiby4sudssWyob1gac1QcPg4LCf
	aIqVPNCJsFRvrDKXx1W8E=
X-Received: by 2002:a05:690c:6e85:b0:7bd:b0a0:509c with SMTP id 00721157ae682-7c95b8260e6mr71533377b3.28.1778892784146;
        Fri, 15 May 2026 17:53:04 -0700 (PDT)
Received: from localhost ([2a03:2880:f806:b::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7c7f5aa24fesm36502657b3.42.2026.05.15.17.53.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 17:53:03 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: amir73il@gmail.com,
	miklos@szeredi.hu
Cc: fuse-devel@lists.linux.dev,
	linux-unionfs@vger.kernel.org
Subject: [PATCH v2 18/21] backing-inode: add backing_inode_setattr()
Date: Fri, 15 May 2026 17:40:01 -0700
Message-ID: <20260516004004.1455526-19-joannelkoong@gmail.com>
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

Move logic in ovl_setattr() to a generic backing_inode_setattr() function
in fs/backing-inode.c, which other filesystems that use backing inodes
(eg fuse passthrough) will use.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/backing-inode.c            | 54 ++++++++++++++++++++++++++++
 fs/overlayfs/inode.c          | 66 ++++++++++-------------------------
 include/linux/backing-inode.h |  4 +++
 3 files changed, 76 insertions(+), 48 deletions(-)

diff --git a/fs/backing-inode.c b/fs/backing-inode.c
index 474770a1fa9d..e72f278789d8 100644
--- a/fs/backing-inode.c
+++ b/fs/backing-inode.c
@@ -41,3 +41,57 @@ void backing_inode_copyattr(struct inode *inode,
 }
 EXPORT_SYMBOL_GPL(backing_inode_copyattr);
 
+int backing_inode_setattr(struct dentry *dentry,
+			  const struct path *backing_path,
+			  struct iattr *attr, const struct cred *cred)
+{
+	struct dentry *backing_dentry = backing_path->dentry;
+	struct inode *winode = NULL;
+	int err;
+
+	if (attr->ia_valid & ATTR_SIZE) {
+		winode = d_inode(backing_dentry);
+		err = get_write_access(winode);
+		if (err)
+			return err;
+	}
+
+	/*
+	 * Clear ATTR_MODE to avoid BUG_ON in notify_change(), which does not
+	 * allow ATTR_MODE together with ATTR_KILL_SUID/SGID (the first
+	 * notify_change() converted ATTR_KILL_SUID/SGID into ATTR_MODE using
+	 * @dentry's inode mode).
+	 *
+	 * This also ensures notify_change() recomputes the mode from the
+	 * backing inode's current mode, instead of a potentially stale value
+	 * from @dentry's inode.
+	 */
+	if (attr->ia_valid & (ATTR_KILL_SUID|ATTR_KILL_SGID))
+		attr->ia_valid &= ~ATTR_MODE;
+
+	/*
+	 * The filesystem's file is not meaningful to the backing filesystem.
+	 * Clear ATTR_FILE so the backing filesystem does not try to use it.
+	 */
+	attr->ia_valid &= ~ATTR_FILE;
+
+	err = mnt_want_write(backing_path->mnt);
+	if (err)
+		goto out_put_write;
+
+	inode_lock(backing_dentry->d_inode);
+	scoped_with_creds(cred)
+		err = notify_change(mnt_idmap(backing_path->mnt),
+				    backing_dentry, attr, NULL);
+	if (!err)
+		backing_inode_copyattr(dentry->d_inode, backing_path);
+	inode_unlock(backing_dentry->d_inode);
+	mnt_drop_write(backing_path->mnt);
+
+out_put_write:
+	if (winode)
+		put_write_access(winode);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(backing_inode_setattr);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 00c69707bda9..f1cd67e6e9c8 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -15,16 +15,17 @@
 #include <linux/namei.h>
 #include <linux/posix_acl.h>
 #include <linux/posix_acl_xattr.h>
+#include <linux/backing-inode.h>
 #include "overlayfs.h"
 
 
 int ovl_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		struct iattr *attr)
 {
+	struct path backing_path;
 	int err;
 	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
 	bool full_copy_up = false;
-	struct dentry *upperdentry;
 
 	err = setattr_prepare(&nop_mnt_idmap, dentry, attr);
 	if (err)
@@ -39,57 +40,26 @@ int ovl_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		err = ovl_copy_up(dentry);
 	else
 		err = ovl_copy_up_with_data(dentry);
-	if (!err) {
-		struct inode *winode = NULL;
-
-		upperdentry = ovl_dentry_upper(dentry);
-
-		if (attr->ia_valid & ATTR_SIZE) {
-			winode = d_inode(upperdentry);
-			err = get_write_access(winode);
-			if (err)
-				goto out;
-		}
-
-		if (attr->ia_valid & (ATTR_KILL_SUID|ATTR_KILL_SGID))
-			attr->ia_valid &= ~ATTR_MODE;
 
-		/*
-		 * We might have to translate ovl file into real file object
-		 * once use cases emerge.  For now, simply don't let underlying
-		 * filesystem rely on attr->ia_file
-		 */
-		attr->ia_valid &= ~ATTR_FILE;
-
-		/*
-		 * If open(O_TRUNC) is done, VFS calls ->setattr with ATTR_OPEN
-		 * set.  Overlayfs does not pass O_TRUNC flag to underlying
-		 * filesystem during open -> do not pass ATTR_OPEN.  This
-		 * disables optimization in fuse which assumes open(O_TRUNC)
-		 * already set file size to 0.  But we never passed O_TRUNC to
-		 * fuse.  So by clearing ATTR_OPEN, fuse will be forced to send
-		 * setattr request to server.
-		 */
-		attr->ia_valid &= ~ATTR_OPEN;
+	if (err)
+		return err;
 
-		err = ovl_want_write(dentry);
-		if (err)
-			goto out_put_write;
+	/*
+	 * If open(O_TRUNC) is done, VFS calls ->setattr with ATTR_OPEN
+	 * set.  Overlayfs does not pass O_TRUNC flag to underlying
+	 * filesystem during open -> do not pass ATTR_OPEN.  This
+	 * disables optimization in fuse which assumes open(O_TRUNC)
+	 * already set file size to 0.  But we never passed O_TRUNC to
+	 * fuse.  So by clearing ATTR_OPEN, fuse will be forced to send
+	 * setattr request to server.
+	 */
+	attr->ia_valid &= ~ATTR_OPEN;
 
-		inode_lock(upperdentry->d_inode);
-		with_ovl_creds(dentry->d_sb)
-			err = ovl_do_notify_change(ofs, upperdentry, attr);
-		if (!err)
-			ovl_copyattr(dentry->d_inode);
-		inode_unlock(upperdentry->d_inode);
-		ovl_drop_write(dentry);
+	backing_path.dentry = ovl_dentry_upper(dentry);
+	backing_path.mnt = ovl_upper_mnt(ofs);
 
-out_put_write:
-		if (winode)
-			put_write_access(winode);
-	}
-out:
-	return err;
+	return backing_inode_setattr(dentry, &backing_path, attr,
+				     ovl_creds(dentry->d_sb));
 }
 
 static void ovl_map_dev_ino(struct dentry *dentry, struct kstat *stat, int fsid)
diff --git a/include/linux/backing-inode.h b/include/linux/backing-inode.h
index 6b43cba9fabd..fd02c87e0f99 100644
--- a/include/linux/backing-inode.h
+++ b/include/linux/backing-inode.h
@@ -11,4 +11,8 @@
 void backing_inode_copyattr(struct inode *inode,
 			    const struct path *backing_path);
 
+int backing_inode_setattr(struct dentry *dentry,
+			  const struct path *backing_path,
+			  struct iattr *attr, const struct cred *cred);
+
 #endif /* _LINUX_BACKING_INODE_H */
-- 
2.52.0

