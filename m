Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155EB53A7;
	Tue, 29 Apr 2025 00:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745885601; cv=none; b=Rfaox45XTTS/Iyb0D58lmjoKPgzEp0/Kc+Dj1NKfe2j76RjT0ke0bLpLwgmSFvgQGyksDIiG3NPD24WqNLTiQUSHOCZaIsBzKsVsmGY1LzwQvQIUvgoAIbJb4HyBIMoljnKXQzG6J6sCLAqUmA3eY5iJGdNpofLJ0r442vBjU+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745885601; c=relaxed/simple;
	bh=HiRVX59FAYDlVZsniwT06tqFI1rfNUP051mzgdDgM4g=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OJ5dHh+J5UbsfpfjDGhrNX1BJNl4VrBk5htS0VKntxudc3+JXSz+FpsjW1I0glJP9EgP640v6ZJli03aUhQslYlZ/cphWi3S5erQbSiIdHVWvkA8/Kfw0jA8ucKj2z4o31EgZ/h6qkRgzBQ37zy/chXwQCjIaGDsmMXz0NV+bIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Zmgjb4dFKz1d0vT;
	Tue, 29 Apr 2025 08:12:03 +0800 (CST)
Received: from kwepemg500010.china.huawei.com (unknown [7.202.181.71])
	by mail.maildlp.com (Postfix) with ESMTPS id BC4121402ED;
	Tue, 29 Apr 2025 08:13:09 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemg500010.china.huawei.com
 (7.202.181.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 29 Apr
 2025 08:13:09 +0800
From: Wang Zhaolong <wangzhaolong1@huawei.com>
To: <miklos@szeredi.hu>, <amir73il@gmail.com>
CC: <linux-unionfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<wangzhaolong1@huawei.com>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH] overlayfs: fix potential NULL pointer dereferences in file handle code
Date: Tue, 29 Apr 2025 08:13:08 +0800
Message-ID: <20250429001308.370040-1-wangzhaolong1@huawei.com>
X-Mailer: git-send-email 2.34.3
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemg500010.china.huawei.com (7.202.181.71)

Several locations in overlayfs file handle code fail to check if a file
handle pointer is NULL before accessing its members. A NULL file handle
can occur when the lower filesystem doesn't support export operations,
as seen in ovl_get_origin_fh() which explicitly returns NULL in this case.

The following locations are vulnerable to NULL pointer dereference:

1. ovl_set_origin_fh() accesses fh->buf without checking if fh is NULL
2. ovl_verify_fh() uses fh->fb members without NULL check
3. ovl_get_index_name_fh() accesses fh->fb.len without NULL check

Fix these potential NULL pointer dereferences by adding appropriate NULL
checks before accessing the file handle structure members.

V1 -> V2:
- Reworked ovl_verify_fh() to postpone ofh allocation until after fh
  validation
- Return -EINVAL instead of -ENODATA for NULL fh in ovl_verify_fh()

Fixes: cbe7fba8edfc ("ovl: make sure that real fid is 32bit aligned in memory")
Cc: stable@vger.kernel.org
Signed-off-by: Wang Zhaolong <wangzhaolong1@huawei.com>
---
 fs/overlayfs/copy_up.c | 4 ++--
 fs/overlayfs/namei.c   | 9 ++++++++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index d7310fcf3888..9b45010d4a7d 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -489,12 +489,12 @@ int ovl_set_origin_fh(struct ovl_fs *ofs, const struct ovl_fh *fh,
 	int err;
 
 	/*
 	 * Do not fail when upper doesn't support xattrs.
 	 */
-	err = ovl_check_setxattr(ofs, upper, OVL_XATTR_ORIGIN, fh->buf,
-				 fh ? fh->fb.len : 0, 0);
+	err = ovl_check_setxattr(ofs, upper, OVL_XATTR_ORIGIN,
+				 fh ? fh->buf : NULL, fh ? fh->fb.len : 0, 0);
 
 	/* Ignore -EPERM from setting "user.*" on symlink/special */
 	return err == -EPERM ? 0 : err;
 }
 
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index be5c65d6f848..f6b2a99a111b 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -493,13 +493,17 @@ static int ovl_check_origin(struct ovl_fs *ofs, struct dentry *upperdentry,
  * Return 0 on match, -ESTALE on mismatch, < 0 on error.
  */
 static int ovl_verify_fh(struct ovl_fs *ofs, struct dentry *dentry,
 			 enum ovl_xattr ox, const struct ovl_fh *fh)
 {
-	struct ovl_fh *ofh = ovl_get_fh(ofs, dentry, ox);
+	struct ovl_fh *ofh;
 	int err = 0;
 
+	if (!fh)
+		return -EINVAL;
+
+	ofh = ovl_get_fh(ofs, dentry, ox);
 	if (!ofh)
 		return -ENODATA;
 
 	if (IS_ERR(ofh))
 		return PTR_ERR(ofh);
@@ -702,10 +706,13 @@ int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index)
 
 int ovl_get_index_name_fh(const struct ovl_fh *fh, struct qstr *name)
 {
 	char *n, *s;
 
+	if (!fh)
+		return -EINVAL;
+
 	n = kcalloc(fh->fb.len, 2, GFP_KERNEL);
 	if (!n)
 		return -ENOMEM;
 
 	s  = bin2hex(n, fh->buf, fh->fb.len);
-- 
2.34.3

