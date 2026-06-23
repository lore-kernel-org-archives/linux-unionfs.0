Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11021073.outbound.protection.outlook.com [52.101.70.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EB637C0F9;
	Tue, 23 Jun 2026 11:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782213362; cv=fail; b=f1KbDLsS+uhroM49VJjFLms3Wws4sVRGNTGAd3j/hy65aY7UQrJ0hoXfjEiM3WiaRB237Su+7PqkZ05ssv+ozUktyV1blOunozvIYOjH25o++XoLA2n6/cyblDsGAzRsRIwfW9WjnpK8QkWpe0lneAf3jc19muRJ3vNPIrTwF7Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782213362; c=relaxed/simple;
	bh=Eocu7WjXcwMHqwKcGhkVsrrNvMdk8ApcGJgMX4NQCf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PuzAqyl3YcTnS8jvNtoBXgZaNdE5pX411QDUVjZA3pbY4wCqqo2+bq0Ge3CA8X+1xna/t7DWJLHqCtD2LOfWtvTReGIn6RTdgV/0SORtSwl8dX8/J3EO6gkjozQ8Xnk5uhk3O1c9vn7sw0a11peguaqiwC0G0NJVxSKr6f1+Lgo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com; spf=pass smtp.mailfrom=virtuozzo.com; dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b=u/iwYlkt; arc=fail smtp.client-ip=52.101.70.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="u/iwYlkt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z1cB4oGidK3EmpE+mDCd0SipD5AEuzMgZamJgufUP31ppVdoX+TklSDnTxmA9gkHYyzc+d7+olR6HbXHthE+2FMBMpjCowfJbmJEeJKF5R/W7HGCeRsuV0Dw0dn7rBc82AvrP4MDw2MVuXqGJKN7XRREK2P2R6w+yaQimlflGsSe0jcg8XP154zLR6v6pXCszPUclXrdHC/xkey0nYGv23ACpnTBJVuW1lTz9/PKQZmpJBtgbUj8woSe9/9lSNNYFs6gcataRbrRwaZPqvRdLAIgPBi6E6VDY48utInAQZxOmIRnsZ65z8BD5uk0s225oSHBzwadTgsiLpRJZgKtqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m/ev9EwvfWfwYWYe4nc52tRKn62J1UMDqMCfRo2z74M=;
 b=s/pE7Xr6gqKR0e7sTelBAOr2R/nI/gCWepQGjUEsHURXaxKjexfFOMZSGZ6nEBOtm+6Hc3tMp+BUX93PIsHK3Ly/bd4oNIL6Hoxw2d/+/TAISDTprNgB68ImrjFr2JhuQxUGcBcH9vDl/L2KlOWsy8U2pDOck20zfKfLZf7y77x29sDr7JsfiWBSBmzP/mJNjXPGlkq88c2QeI+IyQZvhiZaCE4SuqoIckwuLY+CwFIKHVr7ofn7Mycc4sPZBXOE4verusigXA16UKJsW3t9b9q9HsFj7kn2mINeN3u75HTTeQTK1P3Po1TBVSzieKJOnqjNfgf2UYqueLwPEYfKBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m/ev9EwvfWfwYWYe4nc52tRKn62J1UMDqMCfRo2z74M=;
 b=u/iwYlkt2wJYFyX7ZSWWphARpyV82pDQ3FwYJp45VM30LcYCXqI7lww6lUWWi8V3bshprjCkwsbs71LLlPKhQI9BC97+USaKrZIjECngocObnBBBxAGINLRb5r38GacKEqt6cMDiqC9Vdh5Im0X8xRiAPn4gzHmNQ+iIKQIyqQF8Lmbk3zMGCDymQIeZWhJ4K0bllLr4gaaWnOVBmD4qCh3juZEY5KcPYK3ozRnuPgJFJmQBrkm1SXx8J3NniLcHla3kM0H1Ubi2VTiL47RyX8OMv8E8wVlZdyZO8bbm2iN1Y5YRcottXDN3hEbJJtJlTk8lYfX1a/WWgboncwYaFw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from AM0PR08MB11804.eurprd08.prod.outlook.com
 (2603:10a6:20b:747::14) by AS2PR08MB9974.eurprd08.prod.outlook.com
 (2603:10a6:20b:643::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.12; Tue, 23 Jun
 2026 11:15:46 +0000
Received: from AM0PR08MB11804.eurprd08.prod.outlook.com
 ([fe80::bf46:f137:f6d2:5b3a]) by AM0PR08MB11804.eurprd08.prod.outlook.com
 ([fe80::bf46:f137:f6d2:5b3a%6]) with mapi id 15.21.0139.018; Tue, 23 Jun 2026
 11:15:46 +0000
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shuah Khan <shuah@kernel.org>,
	linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Subject: [PATCH 2/3] ovl: support cachestat() syscall on overlayfs files
Date: Tue, 23 Jun 2026 13:14:49 +0200
Message-ID: <20260623111533.2285005-3-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
References: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0175.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b7::12) To AM0PR08MB11804.eurprd08.prod.outlook.com
 (2603:10a6:20b:747::14)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR08MB11804:EE_|AS2PR08MB9974:EE_
X-MS-Office365-Filtering-Correlation-Id: 87e77047-d577-484b-ee2d-08ded118c5b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|10070799003|366016|376014|7416014|52116014|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	vVO/fOeVP0vhrOgHiiQjkjIi7y6WtFY5gtOT+KeIDwUNWSFnGZFyzmvKwiG+eP7RZhwiKVfmsrU6dM58MHneWrO2TNUr6VIJI/1nXb1pdJJscgNdzjsE2RnB5lKXZTcK3RIqGzDcGpv3aiV9dmfpcWcSG+zQbsXkaU0XivRu8B/TTQPsFtuDQs1UDp9s0BggU2kGVzTEgH4enReeUlpKM7VA9+m2MGN5XpLuusbhyHvyBE5EK/wfDTa0mqXt1B7/bWwlYQ+xh8AIYM/7bx7AIkUnjNxB/+Oes0LaEbwP0U7M4rXnZr8hBTeIZ2mXtDV7ET/Ln8IACD38ag+L4UbugzqPXVzGhYS0hl/gDfBHMj3WDAoMY8wp4ajWm+wBpuLxT2+WSXpc4c1ao/43oybh4HZ1dYqDHXQxwsnVy++aERvBqk0AcaojZQjpsY9IaCk0+fjs3agRTJd3egho3VxZTkEsRgvcy3BGcsg4w5NpOCrcAHwHXf5M2MINl+/uMmJG7/JfZ5VUebBrww+puN++dgCOHleoHi0aTb19ytfy+BgvnbuP/KNafsR6FSo/Pvb5VQCQZmYAfj0Kje/4jlz1T1FGErsvUgEtY9M5T2bI7dnhrrkAe+HWGnaK/Aoo7m4Bb+YlUFEFlHcGzl/lJIqcNxsl7GESc++ieaUWNN3hj7A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR08MB11804.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(10070799003)(366016)(376014)(7416014)(52116014)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1TzjpGktSypNXfVAlnZ3X1n7ruP8/1UrDa+WHhXb6sJBvK/37zEnpn0oqClu?=
 =?us-ascii?Q?FgohrJ7lFKT/CQmTzDHLysKbXaBlNwf/ukCYPgNzKWo5/EoaVVBsoFK4E5E0?=
 =?us-ascii?Q?5DuB6A/Z91WyOBUi8DMlS9oS8ClfPGidugFkMumRh6+EfaSXZ/8U9vFgLK+X?=
 =?us-ascii?Q?KPIX+fQq+qnz3E1IMlQYrEQg5OUyw9210r7oxTx9Wn4R5jEngLs9wPv2DMKU?=
 =?us-ascii?Q?B/p4l5VRLUm0LNM78AolKEsKp6tjippDUVGlV5D7WoT2rPGKqt4hZrr4ikyb?=
 =?us-ascii?Q?WE95zMVThM5TxbLUt3tcYxzu880s8CecjarXrg5m11n6VipU7OtyxxjbVtAl?=
 =?us-ascii?Q?d7Tz9tD+esvQqSl8/9gKLJL22oAXQjbjuH0uw0CNLbLIA/gvTS6aBpx8rpgq?=
 =?us-ascii?Q?uUcyjZEXWX+obxcxks4gx6C2GGS81djbiKywCMYVHwkREsTWchr7fd90kU5w?=
 =?us-ascii?Q?njR8FGR90J9rudhna6Pl+2Q6kF6FKaVKzF7ozq4Vo37zli0foJHCD9a/6RoI?=
 =?us-ascii?Q?ZyR/LHeCu2syiCPTQVHJUEWAv331qLNV7C1EH4pPVBU2nKtE9Hm94vMvboe+?=
 =?us-ascii?Q?ijeYbmCScNdBQ28DzD+AbZcdIcDwp5ppIDUkrSW9as/opnKYbL/rbEgXVBh7?=
 =?us-ascii?Q?DI6k8SmRO+2XMB6F6l4ZuPNUKw8th1uYGb0lByXKElkjhqR4ZZ4YXCaWU9V1?=
 =?us-ascii?Q?0MTxCDzaYtX5GsdFoFbfwxRI6NR4ucLUuoNyYQ345y5Nvnulrp+Wij+9HC+h?=
 =?us-ascii?Q?vJ3lTwp44HeFAv+s+OW0d9t9mcAjuynq0WySWkE337yxnAMFmmihEwGcSgaX?=
 =?us-ascii?Q?BNhw6GyZCe2HhtZfLZDFCb+2nq8ARhTamoUBFIO+e/kIwsirByF/CiwuhZPv?=
 =?us-ascii?Q?/loIu4zROJcOTjan9nZzGVK6Z6JI/tYfcN6l8gAn8nOGi5KppBlcLnrTlpKd?=
 =?us-ascii?Q?IGPuoxOZRrm7RHCPQ/blcQk8TD/QTbLBD5y8XzljbQb/iiwRUSFmYvrK7swl?=
 =?us-ascii?Q?HGEdoMrgSMrfSULByySA9KlYvPR/RNvqevkReA/k0dZUjLENovRTonEu6Alu?=
 =?us-ascii?Q?pgjYunWMXPWg8k23JNvsYpgymB8dKU8/X6MpxnSfvA5+K0AbbAQbhsf5GFS/?=
 =?us-ascii?Q?cw4j5Tef3cT7ai9LjtYhGkFDVB25RdVoqoXVoLQgXmK+PAMipxuPgOXINeFE?=
 =?us-ascii?Q?9PgrK6peUgrFgL8rNZnQ8RVkdQEX3y0cQ9of4Dg1UWVTRLzidrdzMb2gf/1X?=
 =?us-ascii?Q?vuw8+2/pxcgs4LLt85jgKkmp65hOKXTqGVPi1G3oQymg7kqWfPOKxJM4ibOD?=
 =?us-ascii?Q?+aUDhSSnLv8+GeCX8dTnrG0NwtFgpcGl3IGaBGH5UHxjhwSrM+m911YMdjjc?=
 =?us-ascii?Q?kd51I0scHFXzXIB2FVSCb/IK2lR/MzA8mNLuGUNm1qWF5PhifquNw2JEe2Du?=
 =?us-ascii?Q?y29wd6F85QTkkrTLqrolUz/e4A7mBes3g8SRLwK2EloEbh8QobfHKXaKcSnZ?=
 =?us-ascii?Q?2xmKG0SUgNcjWM0EgYrrTXMjpngJJ0BCCqEk74Ut38uAxC/c9jdMrVfBFdNI?=
 =?us-ascii?Q?6CDehNEkVQanGF1NemUAS+S90+VcISVhIJ4I49qA5m/FmUpdwqXBQ9dIrIP5?=
 =?us-ascii?Q?P/6F4UltHVHloVnokZsY/5gDTwuf78mDQcWpxTRAksLL3mklxVkdHPeOBV/F?=
 =?us-ascii?Q?dVi47m/eEKyQnx/KNEJQNJqK/AotTsrB9TM7qHFbPOXfJbdlKf3XiXvBply7?=
 =?us-ascii?Q?bHj59kqvOjXCkt+0+igvXao2S1Cx/+cuJy6H+2woWbtadc/3tvPgdxsrGv9F?=
X-MS-Exchange-AntiSpam-MessageData-1: jsrUw1KBHo7/FZaN+wGrACqXm6AjW4hOONg=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87e77047-d577-484b-ee2d-08ded118c5b3
X-MS-Exchange-CrossTenant-AuthSource: AM0PR08MB11804.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2026 11:15:46.3492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cMvfQ3luKLQN09sf2FlWjQo08pyAWIrzz+9/1rwi0M4zWU9c03+Ee+CHJtClnBrTkUspZl7W+Vy3jwzfZkiZpeOgp58gFADXAsOHDRvphvk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9974

Overlayfs forwards data I/O to the real (upper/lower) file, so the page
cache lives in the real inode's mapping and cachestat() on an overlay
fd returned all zeroes.

Implement the ->cachestat() file operation by forwarding to the real
file via vfs_cachestat(), the same way ovl_fadvise() forwards
for fadvise.

Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
---
 fs/overlayfs/file.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 27cc07738f33b..a7e252a91ea43 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -518,6 +518,21 @@ static int ovl_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
 		return vfs_fadvise(realfile, offset, len, advice);
 }
 
+#ifdef CONFIG_CACHESTAT_SYSCALL
+static int ovl_cachestat(struct file *file, struct cachestat_range *csr,
+			 struct cachestat *cs)
+{
+	struct file *realfile;
+
+	realfile = ovl_real_file(file);
+	if (IS_ERR(realfile))
+		return PTR_ERR(realfile);
+
+	with_ovl_creds(file_inode(file)->i_sb)
+		return vfs_cachestat(realfile, csr, cs);
+}
+#endif
+
 enum ovl_copyop {
 	OVL_COPY,
 	OVL_CLONE,
@@ -642,6 +657,9 @@ const struct file_operations ovl_file_operations = {
 	.mmap		= ovl_mmap,
 	.fallocate	= ovl_fallocate,
 	.fadvise	= ovl_fadvise,
+#ifdef CONFIG_CACHESTAT_SYSCALL
+	.cachestat	= ovl_cachestat,
+#endif
 	.flush		= ovl_flush,
 	.splice_read    = ovl_splice_read,
 	.splice_write   = ovl_splice_write,
-- 
2.54.0

