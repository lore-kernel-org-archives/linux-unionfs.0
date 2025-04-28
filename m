Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0803B25F7AA;
	Mon, 28 Apr 2025 11:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745838703; cv=none; b=LqEPOqu3TaciLwunUAIw0KQyUPghzXd4sv2hd4eV99/hPyzw6E506piqCQ1Z3KBxy0WS4fSutQNlVkNK/Wq6N0mIX3uYVP8VTQ13YOMZYnV7mmtQLKOpp22iev9BplUGBxKrNrdl6StUZnCYBNKoYIwunGPAho530lj2+iUgpug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745838703; c=relaxed/simple;
	bh=McOM0VUTJ+DdjGmhVBpGrxjCfpAB0KF9ke7LVj13w84=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=W9VsZ9MLiirAazpRng73U70cAj5QvfD2lBJRhX9iJoyaOfoX80UiVXsy8mOio0OoqucXu3wMVIElHtpxMdO/m8DgWc1MO6frjdT9UdciF/3kpOSw6WMqLaIjtJIeIlmUlWX1TpfotCy9E+mCdEkxhnEBVVJS8pxRQLEx1rbnGRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4ZmLJc5nXcz69c9;
	Mon, 28 Apr 2025 19:07:44 +0800 (CST)
Received: from kwepemg500010.china.huawei.com (unknown [7.202.181.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 632361401F3;
	Mon, 28 Apr 2025 19:11:38 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemg500010.china.huawei.com
 (7.202.181.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 28 Apr
 2025 19:11:37 +0800
From: Wang Zhaolong <wangzhaolong1@huawei.com>
To: <miklos@szeredi.hu>, <amir73il@gmail.com>
CC: <linux-unionfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<wangzhaolong1@huawei.com>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH] overlayfs: fix potential NULL pointer dereferences in file handle code
Date: Mon, 28 Apr 2025 19:11:36 +0800
Message-ID: <20250428111136.290004-1-wangzhaolong1@huawei.com>
X-Mailer: git-send-email 2.34.3
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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

Fixes: cbe7fba8edfc ("ovl: make sure that real fid is 32bit aligned in memory")
Cc: stable@vger.kernel.org
Signed-off-by: Wang Zhaolong <wangzhaolong1@huawei.com>
---
 fs/overlayfs/copy_up.c | 4 ++--
 fs/overlayfs/namei.c   | 8 +++++++-
 2 files changed, 9 insertions(+), 3 deletions(-)

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
index be5c65d6f848..5acc13c012c1 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -496,10 +496,13 @@ static int ovl_verify_fh(struct ovl_fs *ofs, struct dentry *dentry,
 			 enum ovl_xattr ox, const struct ovl_fh *fh)
 {
 	struct ovl_fh *ofh = ovl_get_fh(ofs, dentry, ox);
 	int err = 0;
 
+	if (!fh)
+		return -ENODATA;
+
 	if (!ofh)
 		return -ENODATA;
 
 	if (IS_ERR(ofh))
 		return PTR_ERR(ofh);
@@ -516,11 +519,11 @@ int ovl_verify_set_fh(struct ovl_fs *ofs, struct dentry *dentry,
 		      bool is_upper, bool set)
 {
 	int err;
 
 	err = ovl_verify_fh(ofs, dentry, ox, fh);
-	if (set && err == -ENODATA)
+	if (set && err == -ENODATA && fh)
 		err = ovl_setxattr(ofs, dentry, ox, fh->buf, fh->fb.len);
 
 	return err;
 }
 
@@ -702,10 +705,13 @@ int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index)
 
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

