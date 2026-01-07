Received: from mail-m128233.netease.com (mail-m128233.netease.com [103.209.128.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7B42D29B7;
	Wed,  7 Jan 2026 03:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.209.128.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767757888; cv=none; b=m+ynq5gmcKUC+0w/j4jsLi0Q1cXkeT8uDJjcij07cpiY75qlmAdNgEPKDlajlKUXDfusIJdY/RI+Sw5Edhygg/HwwYOABb376ZB2Q1azivehtVeE5NDH3zYEiR8wTfhO4ilE82s3OMbDpU2q9RbuIui6nmciwqsHgAyDyf4RMOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767757888; c=relaxed/simple;
	bh=sBIE6ZT1kwLrrc8fygOvPNcEubmIWyp5/BCWfOtWYa0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a8YLZgMRdG3DmFNuMZzRPr5qkziI7JDGeD/tWXS1mPY3ucgCwFLu8iVG/OFw6/2kdi38XnLdTGoUYGcGg6d6QxW1/nYr+g1kSD7THC4vYJzld/mcH51UF9iRzqTyZtmcSOk7Bbs2ZAV78Kjm0B7MQts8qhfOwqae0/gPTJGcYVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ustc.edu; spf=pass smtp.mailfrom=ustc.edu; arc=none smtp.client-ip=103.209.128.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ustc.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ustc.edu
Received: from localhost (unknown [14.116.239.36])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2fc18e723;
	Wed, 7 Jan 2026 11:46:06 +0800 (GMT+08:00)
From: Chunsheng Luo <luochunsheng@ustc.edu>
To: miklos@szeredi.hu,
	amir73il@gmail.com
Cc: bschubert@ddn.com,
	linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chunsheng Luo <luochunsheng@ustc.edu>
Subject: [PATCH] overlayfs: mask d_type high bits before whiteout check
Date: Wed,  7 Jan 2026 11:45:51 +0800
Message-ID: <20260107034551.439-1-luochunsheng@ustc.edu>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9b968fd09d03a2kunm4d557c9c3ba432
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkZHUpKVkxNGhpCHklKTEJNS1YeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlKT1VKSk1VSUhCVUhNWVdZFhoPEhUdFFlBWUtVS1VLVUtZBg++

Commit c31f91c6af96 ("fuse: don't allow signals to interrupt getdents
copying") introduced the use of high bits in d_type as flags. However,
overlayfs was not adapted to handle this change.

In ovl_cache_entry_new(), the code checks if d_type == DT_CHR to
determine if an entry might be a whiteout. When fuse is used as the
lower layer and sets high bits in d_type, this comparison fails,
causing whiteout files to not be recognized properly and resulting in
incorrect overlayfs behavior.

Fix this by masking out the high bits with S_DT_MASK before checking.

Fixes: c31f91c6af96 ("fuse: don't allow signals to interrupt getdents copying")
Link: https://github.com/containerd/stargz-snapshotter/issues/2214
Signed-off-by: Chunsheng Luo <luochunsheng@ustc.edu>
---
 fs/overlayfs/readdir.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 160960bb0ad0..a2ac47458bf9 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -246,6 +246,9 @@ static int ovl_fill_lowest(struct ovl_readdir_data *rdd,
 {
 	struct ovl_cache_entry *p;
 
+	/* Mask out high bits that may be used (e.g., fuse) */
+	d_type &= S_DT_MASK;
+
 	p = ovl_cache_entry_find(rdd->root, c_name, c_len);
 	if (p) {
 		list_move_tail(&p->l_node, &rdd->middle);
@@ -316,6 +319,9 @@ static bool ovl_fill_merge(struct dir_context *ctx, const char *name,
 	char *cf_name = NULL;
 	int c_len = 0, ret;
 
+	/* Mask out high bits that may be used (e.g., fuse) */
+	d_type &= S_DT_MASK;
+
 	if (ofs->casefold)
 		c_len = ovl_casefold(rdd, name, namelen, &cf_name);
 
@@ -632,6 +638,9 @@ static bool ovl_fill_plain(struct dir_context *ctx, const char *name,
 	struct ovl_readdir_data *rdd =
 		container_of(ctx, struct ovl_readdir_data, ctx);
 
+	/* Mask out high bits that may be used (e.g., fuse) */
+	d_type &= S_DT_MASK;
+
 	rdd->count++;
 	p = ovl_cache_entry_new(rdd, name, namelen, NULL, 0, ino, d_type);
 	if (p == NULL) {
@@ -755,6 +764,9 @@ static bool ovl_fill_real(struct dir_context *ctx, const char *name,
 	struct dir_context *orig_ctx = rdt->orig_ctx;
 	bool res;
 
+	/* Mask out high bits that may be used (e.g., fuse) */
+	d_type &= S_DT_MASK;
+
 	if (rdt->parent_ino && strcmp(name, "..") == 0) {
 		ino = rdt->parent_ino;
 	} else if (rdt->cache) {
@@ -1144,6 +1156,9 @@ static bool ovl_check_d_type(struct dir_context *ctx, const char *name,
 	struct ovl_readdir_data *rdd =
 		container_of(ctx, struct ovl_readdir_data, ctx);
 
+	/* Mask out high bits that may be used (e.g., fuse) */
+	d_type &= S_DT_MASK;
+
 	/* Even if d_type is not supported, DT_DIR is returned for . and .. */
 	if (!strncmp(name, ".", namelen) || !strncmp(name, "..", namelen))
 		return true;
-- 
2.43.0

