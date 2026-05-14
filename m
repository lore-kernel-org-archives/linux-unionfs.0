Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013027.outbound.protection.outlook.com [40.93.196.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AC03B47E0;
	Thu, 14 May 2026 11:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778757271; cv=fail; b=mv0D0UUXQJEvxQHHJfWhR3ly8H8n6znn/lJQy03ZrQ9L1OUGdudMsmvmGI9Mup29h/3Poyg5JEXBIFgNVj2ombrfOM/wGIjNRROKVWw9I5ye+5X4cEG1T29CASgwHWexpHTXenyWpQtKBSsNP7CgttYRNaU4pz/JCUgR5IXiW5M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778757271; c=relaxed/simple;
	bh=/LsdNQ8r7N8kmmtwF/ST1n6c5mWJ0ef3Mg0injP9qwo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZYfyMHW2GNZCNxUEOdSJ40WmqB0RqKpqCQ8nt1rR7s2CqRPBs9udGGzsgA2umha0FcwA8HudJKfedIEmKheiWzGvaasxClHswu8C9ibPVFd0lzUUb2VYzosGYQdoh5Qs+QWhIR4s8fTy0d15bP6I63hNdtp0AVQHWJQlUchSBKM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=USDJCBlZ; arc=fail smtp.client-ip=40.93.196.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="USDJCBlZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=anr76WCcTYJkYHaa05UjcC5d1sNqzylJPQp52iTAPy6r9yXX19ItrVMDfBr0Zdwx3knpBSmmgF7pmDxEAfqwdSfCrFqxy6mIYaTFpAuWLhpXr1mJuZEUE5qUyk28ykj7I1iL2hrnX0SSdQY/9dzl5UF7QUSKn+S9IqCK4h9voWf8c375xF31Kv4Y1F5zBZiAVjOEB+Y5aV8TeyzcXvfluOjYKZ3j4qrysDohIqzgTp9ioJspoWY1SGQtq2YghGSQKjgDlGqpg1pMmp3EHUnMbrV9UYSjF6bZ5Gma6Svb3BcKyBSXxDvoPeOqgvsRzq79cTnPDhM6sItroJEvGzEZNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mtoxb+QN/+z3/TZj8/GXTww3QVctwT+LschYIeVkwxE=;
 b=AAfWjq2/Vi0eIyzZ/5n2IKAsMjf7pw4/G25l+77FEJ+CvvzBEIv/93BrBscZ1HQ0pCnxcGu3juWzPaK4B7ZhCotzmg7hlmkCZRieh3fCV7/X/8+sTurPSH3GydROdA0AK5svALtIpNl4Ur+R1k0bc1cs10CgU5veM7zTmQVSgHn6a2S5oo23kou8+9MWiUt/ezad+dUQSEiqRyUclpYOO48DpbzIdbX3z06BDrA1cu+1MjNeDnQu8z0QGGChMp+BEhtXcNvT3ybby5SIogOsvaDbOooDXw+oih4eHbq8FP1Ov/TiTKE8FG4eOThdgnLmfzxI2EjdTtv3wCzL8jpssg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=szeredi.hu smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mtoxb+QN/+z3/TZj8/GXTww3QVctwT+LschYIeVkwxE=;
 b=USDJCBlZH4FkNrgeDSRGBRMNszNOgRPAC7LYSGSmtDYE3a/Yw85r89vAAvyhAnSVvPUMyq8L8KjMNbJfgK/npwc4/JojtMjO/2nlYbAXff4GAD216FPws5DWpkhSj7vfI9v+MqfgNUk3XSPDqIoRp6//RyPsJywLWwM3lUDG4rYwdWXz/vJQhx3yYwEkqqKji71oSDVbQNvljAQoj97TjusL2a0H2Q3BeSll7KT4c3rpFjtDF/3zw5XwNnL3O7AHdpUlXf0/ssQOV3sgP1BfoBJQx/dG7pMJ41UoJln3Oz6I0uzL28xnTtTeQNM3vVQY5ESFmFMmACxf5oleZC5C6Q==
Received: from BN9PR03CA0968.namprd03.prod.outlook.com (2603:10b6:408:109::13)
 by SA1PR12MB7126.namprd12.prod.outlook.com (2603:10b6:806:2b0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.18; Thu, 14 May
 2026 11:14:24 +0000
Received: from BN2PEPF000044A9.namprd04.prod.outlook.com
 (2603:10b6:408:109:cafe::fe) by BN9PR03CA0968.outlook.office365.com
 (2603:10b6:408:109::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9913.11 via Frontend Transport; Thu,
 14 May 2026 11:14:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF000044A9.mail.protection.outlook.com (10.167.243.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.13 via Frontend Transport; Thu, 14 May 2026 11:14:23 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 14 May
 2026 04:14:07 -0700
Received: from 82875d6-lcedt.nvidia.com (10.126.231.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Thu, 14 May 2026 04:14:07 -0700
From: Nirmoy Das <nirmoyd@nvidia.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
CC: Christian Brauner <brauner@kernel.org>, <linux-unionfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Nirmoy Das <nirmoyd@nvidia.com>,
	<syzbot+a16fb0cce329a320661c@syzkaller.appspotmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH] ovl: keep err zero after successful ovl_cache_get()
Date: Thu, 14 May 2026 04:13:54 -0700
Message-ID: <20260514111354.3552538-1-nirmoyd@nvidia.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A9:EE_|SA1PR12MB7126:EE_
X-MS-Office365-Filtering-Correlation-Id: b666c6fa-9563-48e6-309a-08deb1a9f451
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700016|13003099007|56012099003|18002099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	RH8qpglMjZMXSnLko6v78DcsZPjMS1obUKbJ7Xh3Yyzu7d8qe+Pdneln4HDiu3Tw0xMM1CM3mAjBW1q3nXJ9HePOcW638/qmU2V5C49NfVVqmzNSKvQblt77j9BAFoKUFesnkQAbZ1XxXFT/3LIfndBlYCM+1VwxngXVvAu0QlUCZDy8h0kFTrgsOuaDL89W3x4vCtQgnXBSTZnyeIGmp9t3xNFkkcNCPAkpzRwKcfFlSM+aE0puhXZV9FqBINXqg5Vr4U3BFxY4hhOlLl+oOEQI6cfn4NoI6IZLRryBASPvfGpKnqvkQonOA0+SKQ+WBaD4lFbVllg0VKyRe9QpZmcj7hV/FvIOhiku3weXfCbQ27M7cC4e4PSlPfPnvDjh511uSfO6lU4cWSoiQ8ylL236lw8sG2bajtn3lgWPos5GSNpjn/y3zFKPnM9TzkdwexhiBfR/tH8tC1gV5AUxGJEYgtja9Dry53fPfwNlvSMyTdahuYielAa5IClT06KdzOqn1EOG7MfOVY8WxMn70uobaVyP2w8tuGXvEZRDA4RdXzp/Fx3gjCLcmz3v8hQCMQpYoN4dtMCMEnH2Coagr8FW16txgoqI3rWnV254aPWVd292i1pJ1+CyCOLDPwxCIo4A5R9NvCPi6CCV1Cl+j+v19cpQlmTtDbv315GDYO3/N+etIlY82KRVKexklAtHNg4mj5cnlXGoNPVvOsdfGtnyPfai3aXZ371QLSvRQaE=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700016)(13003099007)(56012099003)(18002099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	39UgBhfT2C5vWJtICEDYWRsOE7fvlOkOQ8vKcOyp8tS6fEXqDNfUoTQY1sw13m5gKLzrD5iv26QWjukmqtsTey2tEZ4PeAtpfhvFFl9V6mNDZ3rwNePxSwdLdPCjZObg9HyeiZsMSjsPZIQJPiwBPzdgLNwb9f3PYiY/N0K8scVHq62HXE/LIbPKjO0RvkUgYRKASIyfml3Lzr5nJkyLGlsTYZS6w/84l2TJ8AiURXAjlpe6vZsFwiTQfY4HGz35/Yfl+W0AMSh7UVO0nF3CdGc3eW/kg2X5C4vzkjCdyjUWiYLHg0MCQFh6F7vM/rhBZDk3CXZgF2pSIV6giSw6H6WyG57WMIhrlfewk8uvehwDsby3LWHonwy36ssZ0mL30BvyFoYffVIfGO3k73lMg9M5H7jIMAeXnTboGVCS4NoUXTMITyB1BuRpFMAAwOom
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2026 11:14:23.7824
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b666c6fa-9563-48e6-309a-08deb1a9f451
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A9.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7126

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
 fs/overlayfs/readdir.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 1dcc75b3a90f9..0d471064cfea1 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -844,9 +844,8 @@ static int ovl_iterate_merged(struct file *file, struct dir_context *ctx)
 		struct ovl_dir_cache *cache;
 
 		cache = ovl_cache_get(dentry);
-		err = PTR_ERR(cache);
 		if (IS_ERR(cache))
-			return err;
+			return PTR_ERR(cache);
 
 		od->cache = cache;
 		ovl_seek_cursor(od, ctx->pos);
-- 
2.43.0

