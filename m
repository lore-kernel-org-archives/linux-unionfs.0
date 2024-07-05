Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C09D3D6A
	for <linux-unionfs@vger.kernel.org>; Fri,  5 Jul 2024 01:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720142226; cv=none; b=USvbd4Szb1Bf8Pu9ElWYr2Q6Dg6M0oJ+zenaU2xkMUY2QRTLmY+K9OXFJvUMPnHn+p8zf7gSv59SdRQ6hMEDyXZx99qP0itx2pcc1yNx3h88DuWtnTM8iiIKqwyTcyw+D5oazAqR5yBVVdwEgvaczH6g1F7kzfTTMkuWqFGbkWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720142226; c=relaxed/simple;
	bh=o0S0g6mswgYrQ9YRDQBdT9djj809W8ts5LTB9GSaZQI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=icD6a+KhbWlpPFibBlYPKGceU6MMPrfrBDRz9p7D8+PHnU95HaSKyFLvG16zVod0spcxUz5pzf4trjUK/4WTaIwV2g/6ZcYgAYQQ6ivMviCmNxwNuIM3Pyw2gio8rNDaUx0bgXxeuvz33/hcNYjzW5wJqNtHhOf2OvuLVPdxYao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WFb8n4xYmzZhF4;
	Fri,  5 Jul 2024 09:12:25 +0800 (CST)
Received: from kwepemm000013.china.huawei.com (unknown [7.193.23.81])
	by mail.maildlp.com (Postfix) with ESMTPS id 476F3140336;
	Fri,  5 Jul 2024 09:17:01 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemm000013.china.huawei.com
 (7.193.23.81) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Fri, 5 Jul
 2024 09:17:00 +0800
From: Zhihao Cheng <chengzhihao1@huawei.com>
To: <miklos@szeredi.hu>, <amir73il@gmail.com>
CC: <linux-unionfs@vger.kernel.org>, <brauner@kernel.org>
Subject: [PATCH v3 0/3] ovl: simplify ovl_parse_param_lowerdir()
Date: Fri, 5 Jul 2024 09:15:07 +0800
Message-ID: <20240705011510.794025-1-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.39.2
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

v1->v2:
 1. Repalce lower layers parsing code with the existing helper function
    ovl_parse_param_lowerdir().
 2. Add '\n' for pr_err in function ovl_parse_param_lowerdir().
v2->v3:
 1. Add Fix tag for patch 3.
 2. Add Reviewed-by tag for patch 2.

The overlay/079, overlay/085 and overlay/086 are passed after applying
pacthes.

Christian Brauner (1):
  ovl: pass string to ovl_parse_layer()

Zhihao Cheng (2):
  ovl: fix wrong lowerdir number check for parameter Opt_lowerdir
  ovl: ovl_parse_param_lowerdir: Add missed '\n' for pr_err

 fs/overlayfs/params.c | 49 ++++++++++---------------------------------
 1 file changed, 11 insertions(+), 38 deletions(-)

-- 
2.39.2

