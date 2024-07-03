Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EA218654
	for <linux-unionfs@vger.kernel.org>; Wed,  3 Jul 2024 04:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719982106; cv=none; b=MtnHgtSyRI1XKGmaHYrPUDTDRspRYUC31va5T4wTZFhrc2v0kIFjrJkvuF+MuQk+cMp7A6zaEi71zsTQvgplmus7Yf2Nolyr3MOLMUbxlOIPvBEPf7s70FS6ky4JmGMOZb5qrQ8do+cBOssqu4PAILsEx4F1CEau1nQoWERGCEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719982106; c=relaxed/simple;
	bh=PLF/IWv/Z/8ZoFZYJGMRNK0AyXpF1lhemiMX0Q/UsT8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TLTXSQScWody4zLMsdxQoOhkTUUfBScNvS9E1MYsXP/0tnONLOPLEL9/SShoYcMn3b72WyCOM2EM9gXzWfI16jMdCO//lyC1cNQMxoPESHsPegnET+nGc4QT9hKjXwect4z21yOEVc7Tym8B6N/3+t2saml7Sswg7taVJM3uJJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4WDRyM1LdRzQjth;
	Wed,  3 Jul 2024 12:44:27 +0800 (CST)
Received: from kwepemm000013.china.huawei.com (unknown [7.193.23.81])
	by mail.maildlp.com (Postfix) with ESMTPS id 0E68D1402E0;
	Wed,  3 Jul 2024 12:48:15 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemm000013.china.huawei.com
 (7.193.23.81) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 3 Jul
 2024 12:48:14 +0800
From: Zhihao Cheng <chengzhihao1@huawei.com>
To: <miklos@szeredi.hu>, <amir73il@gmail.com>
CC: <linux-unionfs@vger.kernel.org>, <brauner@kernel.org>
Subject: [PATCH] ovl: fix wrong lowerdir number check for parameter Opt_lowerdir
Date: Wed, 3 Jul 2024 12:46:31 +0800
Message-ID: <20240703044631.4089465-1-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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
Fix it by updating 'ctx->nr' after the check ovl_mount_dir_check().

Fixes: 37f32f526438 ("ovl: fix memory leak in ovl_parse_param()")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
---
 fs/overlayfs/params.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 4860fcc4611b..0d8c456aa8fa 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -486,7 +486,6 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 	iter = dup;
 	l = ctx->lower;
 	for (nr = 0; nr < nr_lower; nr++, l++) {
-		ctx->nr++;
 		memset(l, 0, sizeof(*l));
 
 		err = ovl_mount_dir(iter, &l->path);
@@ -494,9 +493,12 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 			goto out_put;
 
 		err = ovl_mount_dir_check(fc, &l->path, Opt_lowerdir, iter, false);
-		if (err)
+		if (err) {
+			path_put(&l->path);
 			goto out_put;
+		}
 
+		ctx->nr++;
 		err = -ENOMEM;
 		l->name = kstrdup(iter, GFP_KERNEL_ACCOUNT);
 		if (!l->name)
-- 
2.39.2

