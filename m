Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013033.outbound.protection.outlook.com [40.93.196.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A902C0299;
	Mon, 11 May 2026 06:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778480497; cv=fail; b=XoNKb0yQ9b5cl+ON+3wObzYX10mMtN5AiJ2yxP/OgqDzK1PGZ9YUCGfyrxxVRcW3sHCvI5y1kGnOiCSTDA4yYYVTec0zFtes/NTSm9QtU03FwJAc9tYrNDOGbeiOTj2El6QNy7fAiGVAmX71kF+AZEF+dPQjBCqtS8f1zTFuQ6w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778480497; c=relaxed/simple;
	bh=4x4Md5VljQ4LFIeTv4RC7aYOS0L+pvhLr/yihtMo9KQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=m/Iu2Pb0OtntZSNTqEl8UpfDXT7p4VDfOfhdsIRGwUp4aqZ6km/DmctvKhKwPtrVpYsvZ12XhULB3sramCs9thhyAPSIM/NuE0sOucpiK4PF1Twdd8rdm86Og1jDEGbSG7VcKa73FyY+er+QbQBgOg0LEYhSHFycAtwIcjseI2Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eLtKVVcf; arc=fail smtp.client-ip=40.93.196.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eLtKVVcf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T0kbY/6Z9cRDwn09B+u7ssWnLz2PR4dFVb99dougN+Fhn9Mr1pLEzrGANZko8POWGC2QZyNHC0HxFm84L2toeIukS7c0mfg/8h2Q3/7bWSw5adirkUPLGAtx+M73etEEb5FWOrtLWxrVvG+7YLgXxUK8kEHiVg8hz68Tam2LFJCnY/MERUMyDHwW+JwgxLShBULOf0uTDeh+V3r1UORDtpPeutxyIbE1PYJ1w5Cc6YkEskEG5/siasckhe+NqpOM7fa+oF+mPp+F2lkv7C/jk8567n92q7Rm30mPyAZRkU97w73sJCOigpp2Bo2ek9a0h5+jDB1Oz7dq8yvjF8XffA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PcmVVnjiexBQ1xCxKszsoFtM5LFtYtsKk9s2L2cw5eA=;
 b=r5//GxKZFid4INz6TDGq4onrGMeEDm3cttt33kbCVeu0lhnz44LCHfjtptXu15Tn022Ep+tVfnryel8S58cPuapDDf10Wk4Nc4HWjTSP0Wr3TdHhtUzUAgMrX9vMMZEqmAh5zVzZTIBCy5ofdh8e4jqnu+cr9/JogNslm8CiwXXPkM02LuxRQZAPfl6x6AWGerUkc5kKfPgxVQhhB0dR18TDfY59va0gW1QkJXJZJ8tCp65OkFDi5nc848JxIfqqVGV8LteaUqVFoi7y+BrxisZXEnFRmmDBi/cwoQJ6B/g1Gtnq3DK52sPl8FPPqpOXfDUnsHL9kJcvTHcF+nleRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=szeredi.hu smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PcmVVnjiexBQ1xCxKszsoFtM5LFtYtsKk9s2L2cw5eA=;
 b=eLtKVVcfObqpsfeSAARBUaKWP4grmltSzeXW1db7/cGJL1WoiVKnt+MxGM0Fbl/lExLWgw0jTkAPc2jcMcivnmHzupLzKvXf+oBFMI9pyXigdW/hGphHOghcjYx9oF8qP54DxNd/01W5vfCtD6f4L0rQOurALGeQFPPK5k1EQVuTsGUB4UL7ksEucdcEXIplzl9PpWN0EeqnTMv7vHyTwOHCmsBtfx5W1Wts7KCYSPUEByGjB8ICCuhHGYvP6uvi2qG+5vemn3lqFN3NPN9SCEqW8g8wm2wcX9aFnIzd0P9p/tMOcXDaleBha4+G6jEkbHPwQfWFITz0rMDAfOs2Xw==
Received: from DM6PR07CA0118.namprd07.prod.outlook.com (2603:10b6:5:330::31)
 by SJ5PPF28EF61683.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::98e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.23; Mon, 11 May
 2026 06:21:30 +0000
Received: from DM2PEPF00003FC8.namprd04.prod.outlook.com
 (2603:10b6:5:330:cafe::bb) by DM6PR07CA0118.outlook.office365.com
 (2603:10b6:5:330::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.23 via Frontend Transport; Mon,
 11 May 2026 06:21:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM2PEPF00003FC8.mail.protection.outlook.com (10.167.23.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.13 via Frontend Transport; Mon, 11 May 2026 06:21:30 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sun, 10 May
 2026 23:21:16 -0700
Received: from 82875d6-lcedt.nvidia.com (10.126.230.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Sun, 10 May 2026 23:21:15 -0700
From: Nirmoy Das <nirmoyd@nvidia.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
CC: <linux-unionfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Nirmoy
 Das" <nirmoyd@nvidia.com>,
	<syzbot+a16fb0cce329a320661c@syzkaller.appspotmail.com>
Subject: [RFC PATCH] ovl: keep merged and impure readdir caches separate
Date: Sun, 10 May 2026 23:20:57 -0700
Message-ID: <20260511062057.2365769-1-nirmoyd@nvidia.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM2PEPF00003FC8:EE_|SJ5PPF28EF61683:EE_
X-MS-Office365-Filtering-Correlation-Id: 7293db62-ebed-41d1-7bcc-08deaf258a6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700016|82310400026|56012099003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	OHVnDYynzBoW1As49SE3SwG0dSVevSbgmXPfhZ5KUPoe/Sd7SyquziGXHqLLde5w9swWCfqEWdFyjdy/DDGalqP3f4vLSMvLd9PXqce23zr370tt8rtDxjuDMb4VLAUqNh56KgcrddosL6JKLF1+sf38d91yZhssF8YyFDNt5eMeWktmYWxQIiUmxWH9n6K0pr+n1KriCg3S6zCx3kW/A1SjCM2ZDGSdVZlDg/bGEQl3C2uWTq9aMBg3ciUbBG3bpR7AJ/lELZIH24gyY4v+tL3RNW6pvPQFDcesHiv8nmnSlY7/DCpXw/cqBwgu9wsn23JS8MWHp2BfrbYw2v9wAyjyfrojtbpcBchCobVCIwJ6Q6ny57LBHA0b7pZSVbYNskEc6CfO7bfZJYBYzsbI8LdVW8RPUrlS60EU6kMADmIK4Y/F/VpVjvFY7qHDpC5DgogX/7eCtnI7wQBwpKkjheUU0TmJN33/EUIDHp801fA27P9p1nm2IjBTfKnUwkHc4+GLFfW+H2L28dAWbvFvC8nMvyIlDLeq0PsiXCvWhsfKePx+EdTpqO78HXFNBOlgxyhOZya0RL/xK20nqN/7w0AHtHhkU/Y9tCeMSzdZhBUwWM5kmH6WEkLJcXnl8FOSYC9RIKdL/y1LsDICQe/I/fJhjbemwDbApArClHR4G0Tib89QC8yO6f7yR5lwyI67bV899nj1dGX/+rLZiw34xbasA6hhPm/JvxB2TYDTes8=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700016)(82310400026)(56012099003)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	M35upXwmfnmhpZ6RYeApunTH6n/oO8AAHF5lEwToDxbxa7LCiYXVFOWWsc4iULq3sdhDFlWPAVkj1+Zv7wKk3sMoXmhkzBPjh84fDJ7+lKCxUry7ZXA3yRV+0qI6Ec25fnWCLrgMb2AoS1QdKaH/fmWuM+B0qNqEPRE92gdKoXzxsEtKiGLCPAnNHy4rQBcEfP48yhthgMRoIoERcQrEkuHoN53I/rxLVdcok9Yvs5rPyeaN3O+ukEWim+FqpHN6HJ8ohaBaIpVCPpD6IbXCY95SOBwr448p0ivuRwATRoACZIjkGauIxA7/pQR8b7gHg2Dw4MZh0fWdIRoTTBRDsxJiArCJQFCzuVJ5mmEEuYqfTWaioBdut8rsxEE7+VZesJ6A9hpb5oXFTUdTbltkUc8GCutJQFfjAby6d9SS+el7wPW++Bwf9zKN8Tghv0pN
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2026 06:21:30.2833
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7293db62-ebed-41d1-7bcc-08deaf258a6d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM2PEPF00003FC8.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF28EF61683

Overlayfs uses one inode cache slot for two readdir cache users with
different lifetime rules. Merged directory iteration pins the cache from
open directory files with cache->refcount. Impure real-directory iteration
uses the inode cache as an unrefcounted lookup table.

Those caches cannot be reused interchangeably. If merged iteration finds
an impure cache in the inode slot, it can pin and seek through a cache
that was not built for merged iteration. If impure iteration finds a merged
cache, it can walk an object whose lifetime is controlled by open directory
files. Either direction can leave ovl_iterate() using stale cache entries.

Add ovl_dir_cache_drop() to detach the inode cache before freeing it. Keep
refcounted merged caches alive until ovl_cache_put(), stop publishing new
merged caches through the inode slot, and let impure iteration reuse only
unrefcounted caches.

Fixes: 4edb83bb1041 ("ovl: constant d_ino for non-merge dirs")
Reported-by: syzbot+a16fb0cce329a320661c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a16fb0cce329a320661c
Assisted-by: Codex:GPT-5 [lore] [checkpatch]
Signed-off-by: Nirmoy Das <nirmoyd@nvidia.com>
---
 fs/overlayfs/readdir.c | 38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 1dcc75b3a90f9..326d8ad173881 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -292,6 +292,27 @@ void ovl_dir_cache_free(struct inode *inode)
 	}
 }
 
+static void ovl_dir_cache_drop(struct inode *inode)
+{
+	struct ovl_dir_cache *cache = ovl_dir_cache(inode);
+
+	if (!cache)
+		return;
+
+	ovl_set_dir_cache(inode, NULL);
+
+	/*
+	 * Merged dir caches are refcounted by open directory files.  If the
+	 * inode cache is replaced while such a file still references it, keep
+	 * the old cache alive until ovl_cache_put().
+	 */
+	if (cache->refcount)
+		return;
+
+	ovl_cache_free(&cache->entries);
+	kfree(cache);
+}
+
 static void ovl_cache_put(struct ovl_dir_file *od, struct inode *inode)
 {
 	struct ovl_dir_cache *cache = od->cache;
@@ -485,13 +506,7 @@ static struct ovl_dir_cache *ovl_cache_get(struct dentry *dentry)
 	struct ovl_dir_cache *cache;
 	struct inode *inode = d_inode(dentry);
 
-	cache = ovl_dir_cache(inode);
-	if (cache && ovl_inode_version_get(inode) == cache->version) {
-		WARN_ON(!cache->refcount);
-		cache->refcount++;
-		return cache;
-	}
-	ovl_set_dir_cache(d_inode(dentry), NULL);
+	ovl_dir_cache_drop(inode);
 
 	cache = kzalloc_obj(struct ovl_dir_cache);
 	if (!cache)
@@ -509,7 +524,6 @@ static struct ovl_dir_cache *ovl_cache_get(struct dentry *dentry)
 	}
 
 	cache->version = ovl_inode_version_get(inode);
-	ovl_set_dir_cache(inode, cache);
 
 	return cache;
 }
@@ -699,12 +713,12 @@ static struct ovl_dir_cache *ovl_cache_get_impure(const struct path *path)
 	struct ovl_dir_cache *cache;
 
 	cache = ovl_dir_cache(inode);
-	if (cache && ovl_inode_version_get(inode) == cache->version)
+	if (cache && !cache->refcount &&
+	    ovl_inode_version_get(inode) == cache->version)
 		return cache;
 
-	/* Impure cache is not refcounted, free it here */
-	ovl_dir_cache_free(inode);
-	ovl_set_dir_cache(inode, NULL);
+	/* Drop stale or incompatible inode cache before building impure cache */
+	ovl_dir_cache_drop(inode);
 
 	cache = kzalloc_obj(struct ovl_dir_cache);
 	if (!cache)

base-commit: e98d21c170b01ddef366f023bbfcf6b31509fa83
-- 
2.43.0

