Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11021073.outbound.protection.outlook.com [52.101.70.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857A3340D9A;
	Tue, 23 Jun 2026 11:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782213348; cv=fail; b=GrId6SR50gNatcu1CNOzU8lnBvBM3SgHACk08pC6MkJ2N5zdBZKbzqaxSa33q58IbFY+3gspilQmCpMwlIxr3wKvcnvktkqmWYFfwQ7Y0bVUaMKgZe52yDe/TGU5YP7Y0sCnjsMh/yqSDSreozB2aIjrmlGZRO2XpcaV4u5Xfwo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782213348; c=relaxed/simple;
	bh=5j96r1ZMgSCwSH/UWn97RVYfVgQKQ6GH298OfdmN1Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=B5UJJnD15DS637z86llFb4m82AxNo7hiNmdSYBzSaQdHMSjWWUuTbOs7Efeoqet3xUnl9KdeX0fujRJoRC9+JKpBOAoNtnwysjb5WAdzg9zmMeyuRfHppORcnk+Chig88DXtxbGZ6ga8RT8a8Ax23KGjFh44s+VwGO3TzO1ykAk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com; spf=pass smtp.mailfrom=virtuozzo.com; dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b=IPm75NVT; arc=fail smtp.client-ip=52.101.70.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="IPm75NVT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=acBubLu4QcQ8hcU/9FQWZVHBn2tUA2U6ql3Kgi4yQ73Psp06h3Aaq5SHHfjTpMJa8e9AV5N5pzR+D5KVSPvYMsN19zZ1u9TZzx6L+AmKzK4yAqW18cjzoOvHNpgbzflLBkHIqa2XzYqkxQaCB+5m4kS8o30M4xN0dKEbN0KwrOQ+FilVySGK6jNYWJlImTWcuK6RrZuLTDWbHnVEy/fmpyYatYGNfTSyetVt4+8HKtAyAC6rO+umqf6FZi3yl9hfCZrwJQITth+b0uDmMmCRXgPvbZJUyjNeGUACW5zDlY+4a9Kub25rU+s1XC5b8sBqmegBrGvgcwaBItAfE/O8Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vdc0QsLVq28JvKfkSRqyzi8qzBdIB1LyvSAVuBUKuSg=;
 b=KLCaWh+PhkmfGX8LPHCxe3CoEmVkSqVx8ilZb6Jm2IImwU+qTwNxUt+oycNG0R/fcPHfvuUKa7ytXKbndz2rC/3cf6tIFc0KqBIVjK41DRciFMUXVFJsBOW8f6YEgUpzywUE24fHi8HHwvcgZsyVO1LHsn4ntpb/krpVlG18ivwAvB7hNj6KyrmaigoDSNjcTKHZyxRxbCN0bBUML+4XsDkfJln4lgEWIqKJ++5K5rDAeKTj0N5kh+RNZ2w862uTRWvs3F/Bho22Sxs5pcME3bszNBQRIlLQQbAsfITGjmJWKFxnhbI3vS7SYq7eK49Bws16WDRhohGF2ZWBealoiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vdc0QsLVq28JvKfkSRqyzi8qzBdIB1LyvSAVuBUKuSg=;
 b=IPm75NVTaRxY3UhFH3PsKZLLIbHhG6MNeep9bK3uj1Ip5J+AhcPSXzrFSEftcvbezftVzf644eXXT5pdFsJTgnLXwNpCEnyCmPRnshu710E79DeCrBdFuifPTjSDj6gebB7Ydv+TFAdH0KUv2Gsz3EdKxnzGcuYfuRTeowOJnjANay/L9sTyVVoG35G3kGZetkRpWwcZBW9BGRb2K2bHPYY7eUDgHaCzQJ2ESjbKz9q89pBT/0K9f4Rs/BZSBtJKjRmmD/CZLL69rmiID798baYyrVF3HGlArOPXeOO76K/BOYtwUjUqIuI6OPcTc4sU/WyuPXWise5NTL4x0L/zdg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from AM0PR08MB11804.eurprd08.prod.outlook.com
 (2603:10a6:20b:747::14) by AS2PR08MB9974.eurprd08.prod.outlook.com
 (2603:10a6:20b:643::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.12; Tue, 23 Jun
 2026 11:15:43 +0000
Received: from AM0PR08MB11804.eurprd08.prod.outlook.com
 ([fe80::bf46:f137:f6d2:5b3a]) by AM0PR08MB11804.eurprd08.prod.outlook.com
 ([fe80::bf46:f137:f6d2:5b3a%6]) with mapi id 15.21.0139.018; Tue, 23 Jun 2026
 11:15:43 +0000
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
Subject: [PATCH 0/3] ovl: make cachestat() work
Date: Tue, 23 Jun 2026 13:14:47 +0200
Message-ID: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.54.0
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
X-MS-Office365-Filtering-Correlation-Id: c1c5559a-7ccd-4bf3-e08d-08ded118c3ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|10070799003|366016|376014|7416014|52116014|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	DMCZ0mP1gen3TNwhrwndYeCD/+hmJmeA8n5e+aKSEDdnW78uMglDvlJGq3HAbgILhVWi304ON+eDy9u/HpoZH/sUiTydIL9VfPfRaNsC5ls9UCSfBkAlg3uZK6Ul1dFp04+senqVQczEES9K6sH1lZdDziTIXsDg2pSAz7VpxNwaeo/BfSI0NrbSyAbd2UkQT6fTuD28tWoYprg2xDmV8adEGy76rmYnNr8ASxdYHJ9ex1+IOqPnfq5QCHgyUMJUstVYF3iz9caXB8DnEBpDlVtEb6G2zeWfpzoAkPBl0i8gqdJPR2feyXgGD/ybkqpQaWAs3eg/uYCw+xjU5dj2LGNMGPx8vFJXEMsnuDvq/NmgTJUdeMqMy5h3wXAZFljbhc4ASutp0VZIEHRbLSgerM9NleNCbxJtDtJ/uzovXwcqs+LbevS2DQPEZ6JpplJ53xHRmxiK68fY9o/2HISBh2nOjtpFRkSGkKOrtT5EdGQCEkh0Uj3YeuzDnOudzNhVaIQIIpOSuQlMtdkM5sWk7QIMd/sjQJZT9ff142Mla4Oy8usXCrxDJ/gC9HLAZTiwVlqBZD3nnjF54Z/XDwrvIyXSTjSnG2OqCrtX00wTVpqw7g2v6h0CrKPB+Xbfk5ZHWAGfgvvzX8qNSoumtwspfKvd3w7XyxJ4VoE7qyiMLnE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR08MB11804.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(10070799003)(366016)(376014)(7416014)(52116014)(56012099006)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?F/uPcyfTGxIzGjdBVmd1z5XywUBU591PhwTaQ2+dbU7HGh0z1wQH/fBjleBb?=
 =?us-ascii?Q?vCb9qm4HalrIc4lrNZ2EH0PMdeePpOfCSFRBqhUxFksj6M5V7La4mAU9OsTd?=
 =?us-ascii?Q?Q5kVORgp9GqawbpEgSQoQVI13o9ocHgheYruJIbaZvmYPhkXQGXjbGULNtwm?=
 =?us-ascii?Q?e/pSyAU+3+kgjH2iV4CD01U83IZyF+1imFVlequSAa63PypY6i1c0rPMvqJb?=
 =?us-ascii?Q?CEux2vndibpXtaByHutqacV7MIPh7CqDHQa6sXGGPNvA1W1I3x9A/S3E6j93?=
 =?us-ascii?Q?n0zYV6uYKms2PQJpNgPfDe3DzIQZO8Iagtz/FjT2HMqdeYdCPoNX9pRjJReD?=
 =?us-ascii?Q?qS66/n3gHpFfTq6WwbnHIInYcxwHxTkd2gIJZsr8G+btik+wEXgo+IVBLtcZ?=
 =?us-ascii?Q?AyWcGbiTv0JOBExrD91XMwNwIJbewdesG3nKO/pnoE8dqjO7kZO1S/q3Y9pA?=
 =?us-ascii?Q?VIDBSxk2PCM4f+sQWuxUDuHx7mHpgPfZW0kyRMGQMntPoeknMkeVmtMPCMI2?=
 =?us-ascii?Q?9aFQdUmUPQJ1LLmFeYVuvh05xQ34nRvcJTcR8zM3dBN79+KLkeHLGMoGZuRf?=
 =?us-ascii?Q?Xcfktczrh2vBCaQH3jBbeMBvaIFwUN5szorWLaZKkwE//TN21n7TpPdtUH71?=
 =?us-ascii?Q?jax+8nHpGcoCpHVlOJjSSTZuIyc4wx4bJ8/eqxeMf+5PjYEJM05gt9R5q/S6?=
 =?us-ascii?Q?lLufHlpjQ22w/Z7443BvlvlAmjO9G889XIVFuGx1rHcbDfTHs9K1WuyVMMI5?=
 =?us-ascii?Q?dwWNOFDsP7jiYdmOTIGCdRYqV3KpsQX2smo0/izvBbPGCTDEUqHVHcpabw49?=
 =?us-ascii?Q?+wjRuTKVVB38D2vpLAQuLgdqUdXqJqfvUDYn6whQ0p+K0Ot17BCLYvlllBU5?=
 =?us-ascii?Q?oJ36RH3v8L0tn5kWBAPW9ZgIhsVQP0PGD2dsgYIRIDiqMT2slDBb7175cd5E?=
 =?us-ascii?Q?GY+vbLtfMPnF6SANxu6IBZimZM1/b5/s6PSdgwDM4BYXH7J2e2DnAh8OhHMO?=
 =?us-ascii?Q?sBu/BRV3mSQ7MV6n01UmCL4CoMiMW/+HK2xjOczxob5vXpnKkkKG2+tLSte6?=
 =?us-ascii?Q?KfEozkRM10KSv1lAxyQCxxvDaOyqV2eV6gI3iCB5IKrX0KHeTcPL7Vr2aHn/?=
 =?us-ascii?Q?QZfcIcBU+nBcj6NUS8Nz9SnUzsWnreruIMBRzP+h8KlIx0UNkU/71qJeNQVJ?=
 =?us-ascii?Q?uq2n+SxErjx2T3z48uVzTsnTh9u6rw4ccJcYifGNAo01uBwYTAAugvCf9IEL?=
 =?us-ascii?Q?yFhiuH72v7vQbt9a7bj12g6SVDpi3cUBjIFDGfqID0pMOEOdHT+i0LnhTpIY?=
 =?us-ascii?Q?Df9DTVsGG6MwBocz7R914MJDChvNBM2tYgwiM4Y2uGsINjgufXLB+UvrdOvL?=
 =?us-ascii?Q?dPIn5M4EnDfizrnZ2aA4JAYRdbSYzuFpbNM04BOmj8BsIJu9uwW17UpjcxBJ?=
 =?us-ascii?Q?2/EANNvV04K/cDD4izDWUj1qv5m0GVe1aypRKsxQiDwBBnJkFDOzinqvmrdm?=
 =?us-ascii?Q?9bSfxPTmsdvORFo3ds02XIO4e/C7e+MIKkK6FDHugpYqvRms+Zs1lBWSGMmM?=
 =?us-ascii?Q?/P6JfKxcTWloMxrniQvuotGPo+YejGId2mm9wt+LaCZ17z2253tb2p/y/2jg?=
 =?us-ascii?Q?wyldl1eJUWL830mHgHk2IW0PYyK1ka4wYptFPtahi2b1zU9pGABQ38O5DaB+?=
 =?us-ascii?Q?S4Doe1/2BG2eW8DJyAiEVITzH1ZAdJoRcPRHKr9dJHkdnXlfwMpci+4yIbHH?=
 =?us-ascii?Q?aXnv+ZyS4JlL++oRjyIzHDMn1tlfxMWW7ug3CBFmSsUJJhJmzWLvlRhqLphy?=
X-MS-Exchange-AntiSpam-MessageData-1: +aY7WzR6v17xeWR0kbzhNdalTWW5kdSZUTc=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1c5559a-7ccd-4bf3-e08d-08ded118c3ed
X-MS-Exchange-CrossTenant-AuthSource: AM0PR08MB11804.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2026 11:15:43.2405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kXG2CiqrI95srvXHNFzvgSKY7J4GdFu9lFbM2ZfeBMHXGeXkWfHfCa9BUjqABg+7bxypcZu/Pm9wJoEtAvL1xZ50KjvP3vNnIGwrlyOq6ks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9974

We were using cachestat() for our internal Virtuozzo cache related tests
and I saw that test behaves wrong on overlayfs, syscall returns all
zeroes instead of any meaningful cache statistics there. Let's fix it
similar to what was done for fadvise().

Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

Pavel Tikhomirov (3):
  fs, mm: add ->cachestat() file operation
  ovl: support cachestat() syscall on overlayfs files
  selftests/cachestat: add an overlayfs test case

 fs/overlayfs/file.c                           | 18 +++++
 include/linux/fs.h                            | 10 +++
 mm/filemap.c                                  | 43 +++++++++--
 .../selftests/cachestat/test_cachestat.c      | 75 ++++++++++++++++++-
 4 files changed, 137 insertions(+), 9 deletions(-)

-- 
2.54.0

