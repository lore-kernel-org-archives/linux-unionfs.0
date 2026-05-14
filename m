Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011052.outbound.protection.outlook.com [52.101.52.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5DF40B6EE;
	Thu, 14 May 2026 14:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778769837; cv=fail; b=VO10zZNpiTf5zs8QYBpIdmPjmbnO6k7rYTujZkeEZKSBU0Rj+xg4aaImmrzf9nCMIJIS4k4u1MB6xgHsnAc8vXPMqR+OL+QkStLM6cPNBdqSA0OI6f9LGPIBqxqt02bxV1Zf9rFPc139SxlzWxICJv/vxXrcLUlJ1BquXC88Bm0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778769837; c=relaxed/simple;
	bh=StJb01LP9zfWi+kiCpTs1Ug7v/4dqAPfHr8mf/LR7LM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ot7CJU5ztMxNPJvhKZJfgu/dQqRjJbSAlfYdIrDevIPoD5vyCgaXqIWV7i+cko5aEOa2p26J9FDuSX0DLFUdKfnIp3vFu33WtbqRHAhb3FaoM07w2aiuI973NecGC4FMFh+IJmrhtEzZE7ikBmUhRIZ6NHiTpnP7uryRlAhU4C0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=l3+tKSOs; arc=fail smtp.client-ip=52.101.52.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="l3+tKSOs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WLIbnhcxgVfxQgE10LH8K5BeDuxTvIDnvrUMujuHrQDaliYxzYoaqEqEUCqa576MFTo6oEn6GctPTX2puQCp9FDTDCIp/CdOOU8JYLj2gFXPIMVg9tOXtKA0xjsQtTbmX07+dEYlRaS/hi4m8szyWzkbn6VaRGt3b4+gzwF8ywKH5pE5Djq/vtDwvgcEucVlK5WEkHQkZQihgQdvmD/o+6KFT+F5u8/WIEvSpN+aGgM3I0VXzq0YnahP3frEXjAmbILvjqZ+x2kW5zvhzjIBYp0tHKVwdxttT6PO3LCQ0niGVwwu5RRf9kZVoGOUmvGUkpZs97N88za8aut2Tmn4BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JGf/GXeO2JQoRi6zM0nUMDhXtHD3D+cx+IRTthT1dHc=;
 b=hruD4WUjZqiWDinzUlOVM93bnwZQNhYh0zj9laY7f7ABZiKrZguoh6wJeHrKZIzT+75ia4QdcqEhmpZMnzfIF6iExgWYiHtGRv2tREQ02t7EcIMJiyrOOBN9D3YFYeYq+ntQRLZEmEftiFSHILu4kJWI4ErsKpsmczdxOyhFeAXrHOQMlhu1xL/PLc8x+RJ294TcFle+fyMD/uKKkP+3mdDIBHkAu9TOylcKnLpq/74KHoMZQJzL41CGnYybD815OSy9N0gmRzVW6GjrzWLsPxyHQzDb20Ar6F5YyCRL4dqUXbVFLN0BjsWFGlqwKSZ6S58TFZyMLWGYMfhkxkTSBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=szeredi.hu smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JGf/GXeO2JQoRi6zM0nUMDhXtHD3D+cx+IRTthT1dHc=;
 b=l3+tKSOsJuPLyuerv2XGP0teT9KbUvDeHr5hF37VhAePRAPGF1RLhtRMa53cORSjph1q1dL9WRE/OxLGh6fX8JHECL+4/d/Gutd/Y7pN098oVotnrKoa45kKNZRe0AYv86TZip/7ajkDO9aBwKeFeEISAkHbBbd+WsvgC5Mr9bv1X198Yh1QMGX1p26pRK8VFfQSx/aPpxJHxWh0uQ/tTFwC315aoG6YxT2Wdr8gdLJNy43JKjLdHWHEAPJb/F8uahI/pk2oxVPYZnMw/7E9KiQs9+0PxCifE8w/4Z+QIzh4wIeS4A3ToyA3hS5L16G2LoQabHXGFhyMboEougsJwQ==
Received: from BN0PR02CA0054.namprd02.prod.outlook.com (2603:10b6:408:e5::29)
 by LV2PR12MB5968.namprd12.prod.outlook.com (2603:10b6:408:14f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.19; Thu, 14 May
 2026 14:43:48 +0000
Received: from MN1PEPF0000F0E4.namprd04.prod.outlook.com
 (2603:10b6:408:e5:cafe::41) by BN0PR02CA0054.outlook.office365.com
 (2603:10b6:408:e5::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.25.19 via Frontend Transport; Thu, 14
 May 2026 14:43:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MN1PEPF0000F0E4.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.13 via Frontend Transport; Thu, 14 May 2026 14:43:45 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 14 May
 2026 07:43:17 -0700
Received: from 82875d6-lcedt.nvidia.com (10.126.230.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Thu, 14 May 2026 07:43:16 -0700
From: Nirmoy Das <nirmoyd@nvidia.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
CC: Christian Brauner <brauner@kernel.org>, <linux-unionfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>,
	<syzbot+a16fb0cce329a320661c@syzkaller.appspotmail.com>,
	<stable@vger.kernel.org>, Nirmoy Das <nirmoyd@nvidia.com>
Subject: [PATCH v2] ovl: keep err zero after successful ovl_cache_get()
Date: Thu, 14 May 2026 07:42:57 -0700
Message-ID: <20260514144258.3068715-1-nirmoyd@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260514111354.3552538-1-nirmoyd@nvidia.com>
References: <20260514111354.3552538-1-nirmoyd@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E4:EE_|LV2PR12MB5968:EE_
X-MS-Office365-Filtering-Correlation-Id: f7bc4027-7bbc-4453-92c6-08deb1c733e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700016|1800799024|22082099003|56012099003|18002099003|11063799003|13003099007;
X-Microsoft-Antispam-Message-Info:
	wBE0ReuHvNLsBqtjx2reTrta9ZSITTWI8ovG+mHjesUneOKjUPAUlOD1gPWIKgBKTvi7XoXdNQvyXGV8k+C6S6GoKTCTN6PTcmmUvsjIEyZCL0O4dTgEgyxSGKQhCseBywYI+0bpiB6l1ooeX0rC/4k7u0IJ3pMFu3bNTxEtvhHyaLGnxAYXSnDiwPQ+W2sTf4G0GDzYL9y0A99W9QdnJ+gIPK0Ac3EI3klCnsnIcW5ZSHFo+ceHZ0IW/LLPYBw6ZJ8nAVdWI6PKOCNk7kj5FnYpbRvj2rLJQmAkoDAXd2fMJ8ycPhFgSvGVREhpI+vgL6V7R8bGcqqMWxAQ5xFDlOF40YLZC21V/DS47hYFvsJ7TqZOdjKRpplysckpryzqqneKktlKzm9JmgtBa4dqdVFwufRU/XQ08/DaOGGiAqobTp/F8uFxzdRypo4VVK0CG20nm9YjEPrLXi2pmZrwR6tf0peMYbTQjEU34kl4GZ/h0Sh/L7Q0dSIZHOkZpRzJqnRSNxX/xzSdsGksTdv9YWMSXd0UILQ66x1BbPm+VuHgM5wErxS1Mdhd9cuE+P+MFjnHIDLSPpUNTeBaW9Qgh/SpFyyTWw8YiLKI/klEJTtA3rAIuj+1Np4WsbCg/hT82lMJrmWk2zVkmcHVigxppmLCXrfUhKHFUuxTdud6UkfWpDCq0tHw8p7TKznBR74KRa9ZwoyE4Neot/0qIREfPyUk2ndB2ZMJpFVs5uIn5no=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700016)(1800799024)(22082099003)(56012099003)(18002099003)(11063799003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	jZ8fCv3N8UbVXrslA966p+W61pSDo4J9w15PFLG/P7iAT28c3AktDEj98pZcmAY9PoB5ldf26M02tbL9v9RZrjoQbHQl7ZzgKivtyJNMdh9TQQ0IMeIjuETp7obO3GGTZlZuXfXzutZCNNMPI84Cp4FKx68Yr8IjFg0+WL0vJq/YaPPLzH0tbi5/TUQjMk0RbT8TRVsmZrrSnZtnT4OjpJMcYPCL1LMUuR1ZhVpVHl4JP58xvM/gV0XLELfYGk2W7g+zoYGDWsukrqD2qF1AvB1wBQfzmsIslTyKk7BFkbwsL2b0lv/l5E0qZcCidF7jgkKm7sTzbovze6wH6kA1xRplnMBRuLdgoWKMXX8/NZTd+qt59s75ujDgQxL2Ir7rI/fZFif7mCHvpeVpfzGa49u0L824wXCHF30cyBfHUhVwuQoJIXb15xwSTpNLhkaC
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2026 14:43:45.8850
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f7bc4027-7bbc-4453-92c6-08deb1c733e9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E4.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5968

ovl_iterate_merged() stores PTR_ERR(cache) in err before checking
IS_ERR(cache). On success err holds the truncated cache pointer and
can be returned as a bogus non-zero error.

The syzbot reproducer reaches this through overlay-on-overlay readdir:

  getdents64
    iterate_dir(outer overlay file)
      ovl_iterate_merged()
        ovl_cache_get()
          ovl_dir_read_merged()
            ovl_dir_read()
              iterate_dir(inner overlay file)
                ovl_iterate_merged()

Only compute PTR_ERR(cache) on the error path.

Fixes: d25e4b739f83 ("ovl: refactor ovl_iterate() and port to cred guard")
Reported-by: syzbot+a16fb0cce329a320661c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a16fb0cce329a320661c
Cc: stable@vger.kernel.org
Signed-off-by: Nirmoy Das <nirmoyd@nvidia.com>
---
v2:
 - Drop the now-redundant 'int err = 0' initializer and the trailing
   'return err' in ovl_iterate_merged(); err is only used inside the
   loop's update-check, so the function can just return 0 on success.
   (Amir Goldstein)
 - Link to v1:
   https://lore.kernel.org/all/20260514111354.3552538-1-nirmoyd@nvidia.com/

 fs/overlayfs/readdir.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 1dcc75b3a90f9..e7fe29cb6028b 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -838,15 +838,14 @@ static int ovl_iterate_merged(struct file *file, struct dir_context *ctx)
 	struct ovl_dir_file *od = file->private_data;
 	struct dentry *dentry = file->f_path.dentry;
 	struct ovl_cache_entry *p;
-	int err = 0;
+	int err;
 
 	if (!od->cache) {
 		struct ovl_dir_cache *cache;
 
 		cache = ovl_cache_get(dentry);
-		err = PTR_ERR(cache);
 		if (IS_ERR(cache))
-			return err;
+			return PTR_ERR(cache);
 
 		od->cache = cache;
 		ovl_seek_cursor(od, ctx->pos);
@@ -869,7 +868,7 @@ static int ovl_iterate_merged(struct file *file, struct dir_context *ctx)
 		od->cursor = p->l_node.next;
 		ctx->pos++;
 	}
-	return err;
+	return 0;
 }
 
 static bool ovl_need_adjust_d_ino(struct file *file)
-- 
2.43.0

