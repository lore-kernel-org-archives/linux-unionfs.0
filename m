Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085CA79CE
	for <linux-unionfs@vger.kernel.org>; Fri,  5 Jul 2024 01:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720142227; cv=none; b=ZWiGD5O351GHMNPzZ4XQNqk50kA8RrFKXKFWLgBNxTkbI8/qNuPBXnaKd8qrJz+Ue2yIUq/Codo9ZX5jYlN4PBv7mOQb148Eg9lh8QoMsidisFHnBEp+hgE++0ehG4qxYMsOH8KzJikikhgRnxqzeKn5KNU5EDDUHRUINmD93+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720142227; c=relaxed/simple;
	bh=OknZaB4TI0r/TB1UINhHNWii3YKXWy3k18tBjwm7vz8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RsAs0BE/bqmGiIcm2HBFZeTyeYyndjEYUOyeQvwf9Iqwzqn5kThhyB+U1wZCRk8OJ2dEgzO0OtSV3lH0zGn58Xh+FWfXM/wUx8BC2W2cWiWnB/c8D9svM++JhGJS30F9+/SFJ8053XM2Mo1+2cuhvix6raTL7CbQDD+++bPXS4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4WFb9j2YWNz1yv3P;
	Fri,  5 Jul 2024 09:13:13 +0800 (CST)
Received: from kwepemm000013.china.huawei.com (unknown [7.193.23.81])
	by mail.maildlp.com (Postfix) with ESMTPS id CA4761402C7;
	Fri,  5 Jul 2024 09:17:02 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemm000013.china.huawei.com
 (7.193.23.81) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Fri, 5 Jul
 2024 09:17:02 +0800
From: Zhihao Cheng <chengzhihao1@huawei.com>
To: <miklos@szeredi.hu>, <amir73il@gmail.com>
CC: <linux-unionfs@vger.kernel.org>, <brauner@kernel.org>
Subject: [PATCH v3 3/3] ovl: ovl_parse_param_lowerdir: Add missed '\n' for pr_err
Date: Fri, 5 Jul 2024 09:15:10 +0800
Message-ID: <20240705011510.794025-4-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240705011510.794025-1-chengzhihao1@huawei.com>
References: <20240705011510.794025-1-chengzhihao1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm000013.china.huawei.com (7.193.23.81)

Add '\n' for pr_err in function ovl_parse_param_lowerdir(), which
ensures that error message is displayed at once.

Fixes: b36a5780cb44 ("ovl: modify layer parameter parsing")
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

