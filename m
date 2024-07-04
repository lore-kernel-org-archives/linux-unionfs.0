Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C97E1A01B8
	for <linux-unionfs@vger.kernel.org>; Thu,  4 Jul 2024 07:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720076738; cv=none; b=OOPzhHXKADeRn7/BVqxwvQCRLjIh8nxXdydFZOB6GFY/MX9pY5KSPkq1bVBC/EbQKjqJRvY7/DEq8XwTye54kKR31m7OkyXu4VmQtiAeJgamL41ePLNjgz1zLLZCVuEGf66SgkNsQAvPUnR54lTrUAi1ZQ/o/AbnM2oqx7HN9+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720076738; c=relaxed/simple;
	bh=G9H7p+Si3dIe4d16KUaIFQ2MXen//SLUd3LThqyiB7g=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=iNnIN/wKx1KmUGz0I/sT89DIWk6fU4Dhfo3azYgIUDwIqVSsU76srmLSbtotjTINNH0uBfFWwekKkxHShTddr5yGaTt/Tak3AS2JriAEc4qocbIS7QiGYGo2szGWm9PwlKdY0B3U9fBSaVs1UR0dkk380J52iFga0F268NafkU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4WF6xt4pLhzQkG9;
	Thu,  4 Jul 2024 15:01:22 +0800 (CST)
Received: from kwepemm000013.china.huawei.com (unknown [7.193.23.81])
	by mail.maildlp.com (Postfix) with ESMTPS id B7E8718006E;
	Thu,  4 Jul 2024 15:05:11 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemm000013.china.huawei.com
 (7.193.23.81) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 4 Jul
 2024 15:05:11 +0800
From: Zhihao Cheng <chengzhihao1@huawei.com>
To: <miklos@szeredi.hu>, <amir73il@gmail.com>
CC: <linux-unionfs@vger.kernel.org>, <brauner@kernel.org>
Subject: [PATCH v2 0/3] ovl: simplify ovl_parse_param_lowerdir()
Date: Thu, 4 Jul 2024 15:03:20 +0800
Message-ID: <20240704070323.3365042-1-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.39.2
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

v1->v2:
 1. Repalce lower layers parsing code with the existing helper function
    ovl_parse_param_lowerdir().
 2. Add '\n' for pr_err in function ovl_parse_param_lowerdir().

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

