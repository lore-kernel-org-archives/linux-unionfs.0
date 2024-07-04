Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9E11A0711
	for <linux-unionfs@vger.kernel.org>; Thu,  4 Jul 2024 07:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720076738; cv=none; b=tkkd3pCHR+z39NTr49NHX4bxuDL9HsqIoDCDiJIZHzzV7xQdlhHpmvaZoYH1nvxCdbR/xS2V7zs/Mu8EpviMzj883U93hPKTUko3U5g7nYe6Io+NZ9jQgjLp+ofgrXMUPV/cFUx8ShEjXvzbHdkgFmgtgz0Tq+D11rCMvxFijB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720076738; c=relaxed/simple;
	bh=QGf4sHPi4VRb8Ywl/WyZ4mdhpoGucQ82oT6Q/WllO+o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=La45JYR/X38bUVrJYU19KgJ1cAuvhQikZuZVRxjGpP9aT6odBgX8bvis4tJkzUStnnZe1tqRY5mwvfa5e3jAR2+R3UzjLCvsbu1k4qLZBtMATarhBhw5cLhnvh/AAkOL0HsTqHTn6wq0T+JKYxXlCl+gqCOtBykW04e00uzbo88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4WF6xv4w56zQkGf;
	Thu,  4 Jul 2024 15:01:23 +0800 (CST)
Received: from kwepemm000013.china.huawei.com (unknown [7.193.23.81])
	by mail.maildlp.com (Postfix) with ESMTPS id B9B171410A7;
	Thu,  4 Jul 2024 15:05:12 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemm000013.china.huawei.com
 (7.193.23.81) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 4 Jul
 2024 15:05:12 +0800
From: Zhihao Cheng <chengzhihao1@huawei.com>
To: <miklos@szeredi.hu>, <amir73il@gmail.com>
CC: <linux-unionfs@vger.kernel.org>, <brauner@kernel.org>
Subject: [PATCH v2 2/3] ovl: fix wrong lowerdir number check for parameter Opt_lowerdir
Date: Thu, 4 Jul 2024 15:03:22 +0800
Message-ID: <20240704070323.3365042-3-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240704070323.3365042-1-chengzhihao1@huawei.com>
References: <20240704070323.3365042-1-chengzhihao1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm000013.china.huawei.com (7.193.23.81)

The max count of lowerdir is OVL_MAX_STACK[500], which is broken by
commit 37f32f526438("ovl: fix memory leak in ovl_parse_param()") for
parameter Opt_lowerdir. Since commit 819829f0319a("ovl: refactor layer
parsing helpers") and commit 24e16e385f22("ovl: add support for
appending lowerdirs one by one") added check ovl_mount_dir_check() in
function ovl_parse_param_lowerdir(), the 'ctx->nr' should be smaller
than OVL_MAX_STACK, after commit 37f32f526438("ovl: fix memory leak in
ovl_parse_param()") is applied, the 'ctx->nr' is updated before the
check ovl_mount_dir_check(), which leads the max count of lowerdir
to become 499 for parameter Opt_lowerdir.
Fix it by replacing lower layers parsing code with the existing helper
function ovl_parse_layer().

Fixes: 37f32f526438 ("ovl: fix memory leak in ovl_parse_param()")
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
---
 fs/overlayfs/params.c | 40 +++++++---------------------------------
 1 file changed, 7 insertions(+), 33 deletions(-)

diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 52e3860973b7..8dd834c7f291 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -353,6 +353,8 @@ static void ovl_add_layer(struct fs_context *fc, enum ovl_opt layer,
 	case Opt_datadir_add:
 		ctx->nr_data++;
 		fallthrough;
+	case Opt_lowerdir:
+		fallthrough;
 	case Opt_lowerdir_add:
 		WARN_ON(ctx->nr >= ctx->capacity);
 		l = &ctx->lower[ctx->nr++];
@@ -375,7 +377,7 @@ static int ovl_parse_layer(struct fs_context *fc, const char *layer_name, enum o
 	if (!name)
 		return -ENOMEM;
 
-	if (upper)
+	if (upper || layer == Opt_lowerdir)
 		err = ovl_mount_dir(name, &path);
 	else
 		err = ovl_mount_dir_noesc(name, &path);
@@ -431,7 +433,6 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 {
 	int err;
 	struct ovl_fs_context *ctx = fc->fs_private;
-	struct ovl_fs_context_layer *l;
 	char *dup = NULL, *iter;
 	ssize_t nr_lower, nr;
 	bool data_layer = false;
@@ -471,35 +472,11 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 		goto out_err;
 	}
 
-	if (nr_lower > ctx->capacity) {
-		err = -ENOMEM;
-		l = krealloc_array(ctx->lower, nr_lower, sizeof(*ctx->lower),
-				   GFP_KERNEL_ACCOUNT);
-		if (!l)
-			goto out_err;
-
-		ctx->lower = l;
-		ctx->capacity = nr_lower;
-	}
-
 	iter = dup;
-	l = ctx->lower;
-	for (nr = 0; nr < nr_lower; nr++, l++) {
-		ctx->nr++;
-		memset(l, 0, sizeof(*l));
-
-		err = ovl_mount_dir(iter, &l->path);
+	for (nr = 0; nr < nr_lower; nr++) {
+		err = ovl_parse_layer(fc, iter, Opt_lowerdir);
 		if (err)
-			goto out_put;
-
-		err = ovl_mount_dir_check(fc, &l->path, Opt_lowerdir, iter, false);
-		if (err)
-			goto out_put;
-
-		err = -ENOMEM;
-		l->name = kstrdup(iter, GFP_KERNEL_ACCOUNT);
-		if (!l->name)
-			goto out_put;
+			goto out_err;
 
 		if (data_layer)
 			ctx->nr_data++;
@@ -517,7 +494,7 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 			 */
 			if (ctx->nr_data > 0) {
 				pr_err("regular lower layers cannot follow data lower layers");
-				goto out_put;
+				goto out_err;
 			}
 
 			data_layer = false;
@@ -531,9 +508,6 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 	kfree(dup);
 	return 0;
 
-out_put:
-	ovl_reset_lowerdirs(ctx);
-
 out_err:
 	kfree(dup);
 
-- 
2.39.2

