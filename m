Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E139113E024
	for <linux-unionfs@vger.kernel.org>; Thu,  4 Jul 2024 07:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720076737; cv=none; b=GttVIy5yFtADND+DnQQ3usUM7C3Pz4uSFTqPl30fueiSy7pUrqt3sRqvVFrLSgSZMsFxYIGC41McDQBUwjdJj++2VFP9Th43OxalhJB5RiYEbwyf8MAYYjNp0DgzTTy6NbUKyZWzIjK/XhTIuzd0gvB9eq3slLCGzikYQ7BvjCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720076737; c=relaxed/simple;
	bh=d1RfOw5f8V1dSmyW5gx5AYxZnT8RZLBeiSfVpvXfwa4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZiXDIwywYnLaasRwYYoYD9mQOgdmFZXU+zbE2cCzh3X3NRn0Yu1g9gzD8RuZ+4uWMOqApn8sDNKYbs4m6Ca26D5PNKngjGI0GuCmMGAWCf26U2pPJeWerYU2nPud/3ivAPp3w8LYmB1YRquvLFgqIrCPDbJ8MvvCV5XR1nXZc00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WF70Q56RDzdgHn;
	Thu,  4 Jul 2024 15:03:34 +0800 (CST)
Received: from kwepemm000013.china.huawei.com (unknown [7.193.23.81])
	by mail.maildlp.com (Postfix) with ESMTPS id 41FFB140443;
	Thu,  4 Jul 2024 15:05:12 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemm000013.china.huawei.com
 (7.193.23.81) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 4 Jul
 2024 15:05:11 +0800
From: Zhihao Cheng <chengzhihao1@huawei.com>
To: <miklos@szeredi.hu>, <amir73il@gmail.com>
CC: <linux-unionfs@vger.kernel.org>, <brauner@kernel.org>
Subject: [PATCH v2 1/3] ovl: pass string to ovl_parse_layer()
Date: Thu, 4 Jul 2024 15:03:21 +0800
Message-ID: <20240704070323.3365042-2-chengzhihao1@huawei.com>
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

From: Christian Brauner <brauner@kernel.org>

So it can be used for parsing the Opt_lowerdir.

Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
---
 fs/overlayfs/params.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 4860fcc4611b..52e3860973b7 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -365,10 +365,9 @@ static void ovl_add_layer(struct fs_context *fc, enum ovl_opt layer,
 	}
 }
 
-static int ovl_parse_layer(struct fs_context *fc, struct fs_parameter *param,
-			   enum ovl_opt layer)
+static int ovl_parse_layer(struct fs_context *fc, const char *layer_name, enum ovl_opt layer)
 {
-	char *name = kstrdup(param->string, GFP_KERNEL);
+	char *name = kstrdup(layer_name, GFP_KERNEL);
 	bool upper = (layer == Opt_upperdir || layer == Opt_workdir);
 	struct path path;
 	int err;
@@ -582,7 +581,7 @@ static int ovl_parse_param(struct fs_context *fc, struct fs_parameter *param)
 	case Opt_datadir_add:
 	case Opt_upperdir:
 	case Opt_workdir:
-		err = ovl_parse_layer(fc, param, opt);
+		err = ovl_parse_layer(fc, param->string, opt);
 		break;
 	case Opt_default_permissions:
 		config->default_permissions = true;
-- 
2.39.2

