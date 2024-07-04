Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032FC13E024
	for <linux-unionfs@vger.kernel.org>; Thu,  4 Jul 2024 07:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720076750; cv=none; b=ZhTHj+tHgnVeVFl6m/Yit8G6W+uLFf3Kc1FesSVJ9mBUFAFPv/qOsCkavg1MskhMStVuDQlmZimQkd4gS2jzHRJZ5CKC+9y2WjDpdCO94u+5k4htzP3d6u5q/fphjWPDpf2mMhLbWfVfw2ZB+njqhQj6aZGAbasHD54V8FeE7NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720076750; c=relaxed/simple;
	bh=6zwUZ8Pur+otPr7OaT0DhvjE9EBz5tADs/OI2IYo3G0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uDkPm47DHDIlBCLnk3z+kFSqPOmsqIz5OC0dj/jEXsY2Zw1ap/SUSh7hCo/FLzDosu/0r1zA+GAajAhk3IBqQmCd87mOiCn0Tt2iZas/NLlkmDGReH9reIDMEiYV9ht8vN1s78rZCkmDJ6NLhGXFUfolyQMxrPu2QHyD4rOPk/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WF71z0crNznZ9p;
	Thu,  4 Jul 2024 15:04:55 +0800 (CST)
Received: from kwepemm000013.china.huawei.com (unknown [7.193.23.81])
	by mail.maildlp.com (Postfix) with ESMTPS id 3D2B8140443;
	Thu,  4 Jul 2024 15:05:13 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemm000013.china.huawei.com
 (7.193.23.81) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 4 Jul
 2024 15:05:12 +0800
From: Zhihao Cheng <chengzhihao1@huawei.com>
To: <miklos@szeredi.hu>, <amir73il@gmail.com>
CC: <linux-unionfs@vger.kernel.org>, <brauner@kernel.org>
Subject: [PATCH v2 3/3] ovl: ovl_parse_param_lowerdir: Add missed '\n' for pr_err
Date: Thu, 4 Jul 2024 15:03:23 +0800
Message-ID: <20240704070323.3365042-4-chengzhihao1@huawei.com>
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

Add '\n' for pr_err in function ovl_parse_param_lowerdir(), which
ensures that error message is displayed at once.

Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
---
 fs/overlayfs/params.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 8dd834c7f291..657da705db25 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -493,7 +493,7 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 			 * there are no data layers.
 			 */
 			if (ctx->nr_data > 0) {
-				pr_err("regular lower layers cannot follow data lower layers");
+				pr_err("regular lower layers cannot follow data lower layers\n");
 				goto out_err;
 			}
 
-- 
2.39.2

