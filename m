Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.69.102
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795113280;
	b=KMUmjU1gFs2aNQtQ1pWKwGccYonkRZGj7QOCUE541g0NBhZCYs9S8LX5CZCxFeJe/uUA
	 eU6m/4D6U1pYHwGjYYIcCniik8kBBndW0iFhESajYfEenVrYAB3raIHEuYopL+0fJU6UM
	 sYH3OyFZMp1egOClAl3hT/6kXg3ErgMRtqkdBPEvIFTsUaTmyBLzr9JXZueKr67EZYGqW
	 jAUFfVVrA8tQS/o5SLIdEgw+yW8e6OXRt3/scQzIAk2z7NcssCSCFEIQE+8Un6NXuAGrM
	 slCZYk4ZvNsUCrT9VYQzfmd4UFU/XI+ClBLUMT/SUhGGGqrpHmv5JapHiT65hRaryVg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795113280;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-AntiSpam-MessageData-1:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=0vxw8Y/Y3wzKmT9yYuQHcCtRpctNh95EEn7KFbp0XfI=;
	b=kf7F5Q2W4w9pZX67PjV1Dleo9Wn2txji3wdo6Zi4If7lzLNkYdgLd6fNo3MFCGwpENXl
	 LBd92cJFgMPuJstLBVUcz1VTRglkTDDYn2ytwoYILYQiio2GyTKp89/+4D2RgLLx31XFA
	 q36bVcOLdiymEVhdxisWBfZSR/gpZSiMnzkpU/YS+BXkCvmIKlPbCcxfS37oiO6ZK9aKk
	 fd2pQzuTjGkqzUK+ENCjOvOVxJyey/98xqc2zfslVHd7eWbvyuWiTboGtl2p17JQE4FrB
	 rxR08oKoSsufuomBGIpVO5Zln/16Zpt9+/joDd7+L4Kk0UhFm6gn7Q9WofXY/ZQIrrA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=virtuozzo.com;
	spf=pass smtp.mailfrom=virtuozzo.com;
	dkim=pass header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=selector2 header.b=VU7jN7Wf;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.69.102
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11020102.outbound.protection.outlook.com [52.101.69.102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4901606A320;
	Thu, 19 Nov 2026 18:34:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4901606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=selector2 header.b=VU7jN7Wf
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RRDXALFrtkhhGfp0VOFkZUbA2japJG1YjMsun6oLqlHiR1FphSQ+V2LkB2eEC6AEL5vb1Ab4v6Lp9W/yF64OmspJot7aiuk0EyY3EEyRLmYQ9Jm2Q+J+Fx5Qnj7d3LfJKajfoshEBULozIpDyWCPr3VBDO8qjl0I7/FUwjYNR6bhzkjS4YZzYDP5uI9ufUW7nlnQfDaTzYuHObu8z1CJAMAB5fSDYnh6Y/y6yBQ2h9DyhTan+DxiuHhUziIzx8fXQqosFAaFX2qqJdG4db39rJPzVFN1iU0Jz9dduwxVUo4Rf3QSVDXilb9T1CqfzRYxWoC38WLS5+iGMB6xrDQmmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0vxw8Y/Y3wzKmT9yYuQHcCtRpctNh95EEn7KFbp0XfI=;
 b=OpGWc2XoAq98xga4odbWURpn4UimGIUcv/lfBZGaUKKRvD33JDUTc6zgRqvbzHccQHezyUReNeK9R8i6PY4qrbOMP2X8DL8h3E61bhPrXvXRnn5PNxOAL3xhkBkmeME7dgFHhKoZ7tmsm78xZATLzmPUh8/Tb+GMdYalJLzrlYExRgMxfu/AcSEWXlZP+mTiYE9ZiI7d5530Ss9iglavKtTAqpc2KUajPEqohKczaVom3qWTpEIsQStjzb3rmxwoZHpYQkxoBQF7KzdUx3WN297/m6BtoXQ8yEguX/K1CjUAAKII06fK+XPEvwzdA95aMmiaC+D7Hjlo2GH8wpJjhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0vxw8Y/Y3wzKmT9yYuQHcCtRpctNh95EEn7KFbp0XfI=;
 b=VU7jN7Wflm4UZGUrnXkh2R7re5cbxYCUiOcJHaGgCC4sPcJETolXDAkx++px92PJgEmREwE+DaGy0H9pcvZeuFTfS/9ijbQEh+3cVfOmCQqudmq1ADaLBUzvn/GrK1aiHmWH/VoOoq6nbgNAcTCT1441K1uMSFdoFGgpcbm0IetXclJIJHTJcS7hIJ+STVlSYCl2WzVmRKnFwLBFDY0aXSNYBX8S6zh58451u7oCdQz7pkZ4TiNRLzmWxsO+BK3eeDAJEVeohy64XVuek6COoTunxcjO+eYN99wiOiQFQUEgPSF3yflMY+YIcrqJVJYORlzCxztcL+6AnBcM/oiK9Q==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from AM0PR08MB11804.eurprd08.prod.outlook.com
 (2603:10a6:20b:747::14) by MI7PR08MB837237.eurprd08.prod.outlook.com
 (2603:10a6:290:102::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Thu, 19 Nov
 2026 18:34:36 +0000
Received: from AM0PR08MB11804.eurprd08.prod.outlook.com
 ([fe80::bf46:f137:f6d2:5b3a]) by AM0PR08MB11804.eurprd08.prod.outlook.com
 ([fe80::bf46:f137:f6d2:5b3a%7]) with mapi id 15.21.0615.015; Thu, 19 Nov 2026
 18:34:36 +0000
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To: Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Ding Feng <dingf3ng@gmail.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shuah Khan <shuah@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/cachestat: add overlayfs test cases
Date: Thu, 19 Nov 2026 19:30:40 +0100
Message-ID: <20261119183039.1505892-2-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <CAOQ4uxjHwtZEHu9xMM6zg9niSgNdLXhAu65jA8Ai_SKVg-W2nw@mail.gmail.com>
References: <CAOQ4uxjHwtZEHu9xMM6zg9niSgNdLXhAu65jA8Ai_SKVg-W2nw@mail.gmail.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0102.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:79::15) To AM0PR08MB11804.eurprd08.prod.outlook.com
 (2603:10a6:20b:747::14)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR08MB11804:EE_|MI7PR08MB837237:EE_
X-MS-Office365-Filtering-Correlation-Id: bb38dd11-d384-408b-8f21-08df466bc347
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|376014|7416014|52116014|1800799024|23010399003|56012099006|5023799004|261009223027099003|261021121427099003|10067099003|261102130727099003|261102123227099003|261026140227099003|261022105027099003|261022075727099003|261022115727099003|261026121527099003|261021123027099003|261028144727099003|18002099003|22082099003|6133799003|4133799003;
X-Microsoft-Antispam-Message-Info:
	GBfUXBfpOR9xbu6gtnEgeHucV0u4WGKs7u6LORpYyLgwzAXExvpXCVkF22bIfhJzNfuTY/mGHC6wC3Um6DIu1H3FmHWnfjXfXqpCyYiuMQKHLYHh25/U9h5xcqCMTCCPxB5REw8YEDNjoISM8gY2FM+9fI3vEDXMbqmkndAR1zrfXkMAa9lCyISjx8NgiXCXmT/VnBmFm99yLDsCI3e144iOGEDsdRqCPYeQUvMauV8aydCtASXePsS6Zaz+HUZVW2K/hQ61eA3ZlX6TlCwhfkieNeVsoshSGgkHhcTllatlw+LDkWWYEfW9F1urKQD6MpGpoEXtAZj8mamhCQC9c8Z/IaojULoIGp+XKVZwOtsiFcI4EaZEB8jwDYmGsG5SaYjeuh1ugZziaRGqSyaqBuMzF341NJqgb7cYjRth9wH68bqMXA/12nNbg4uhEqezplnNuzjVbbkBo196yWv5HTL2k/I4hVs3YD25idBruLvB5af9l0Rtz/o1uObjG0vztfXd82DIS8bYUR7ybNdZgqZ5rPPj4uGJZVedaz5XJmzHNxFxwyDKVxhn/OkQqt64gVdlL+WGK3YqERpPL+eRwLDyr69ljkB+hITaQVfOn6TGozceWaNufs+cJRmQKr5D
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR08MB11804.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(7416014)(52116014)(1800799024)(23010399003)(56012099006)(5023799004)(261009223027099003)(261021121427099003)(10067099003)(261102130727099003)(261102123227099003)(261026140227099003)(261022105027099003)(261022075727099003)(261022115727099003)(261026121527099003)(261021123027099003)(261028144727099003)(18002099003)(22082099003)(6133799003)(4133799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HXbLPj3JXAfV+lPwKZy2Jz7+U/MiChpfXdslH+N3f9CfOf/WAuXD9UJw4T7n?=
 =?us-ascii?Q?YXWoMzUsarRvDDklRlCHaIWUd238Gt96qwfylyBfVTFx8hSDAxjNrdHkG+jG?=
 =?us-ascii?Q?/HjdAyUR9Xz3gQXfhH0dKG9NzyjFOx4LqSm4nY/ltC6xAQ1RVFwVN9iSAa/R?=
 =?us-ascii?Q?9qJHp4bhKuHiYkRWzGolAicAHlRWi+sLsjffkpx9kojAIB8oOBC7pPxRB6AE?=
 =?us-ascii?Q?bAUMGkl4hwYdRtyr4Vdb5S6oOjdrLl4XKkFtFratwqy4ZEu2E6UYYW00T2Xr?=
 =?us-ascii?Q?t0dPeCJtPoueDiqHJ4mg5udSm8i6KALHqrg7eWH21X3a+W/IyNzciUmozSgk?=
 =?us-ascii?Q?LPgc9ibFIxS2ebz4wR0WLhWw04mScfbhidWW2y3yj0VyIWgmGjj+8aMYhxeQ?=
 =?us-ascii?Q?eQ1nNCNYJWQ1c/gRH6CpLgWgT9dCnuy1ZGbTUNy1++jjwun7RXFQ5nvKfnlS?=
 =?us-ascii?Q?9ZzsfypHpLRRwl9SbOgM6T/eVUbFvB0jviBqEpGyGB6qL6efbQIMV7QiacT2?=
 =?us-ascii?Q?SG8dZSAQt+7qhDB6usKETwVh2iCJoiykzVwfDxHyugFfzeZbihijO20lMVNu?=
 =?us-ascii?Q?hGpHkT+tuWWh29j7uHzhE/qJFZdhvxR+SMLlR1gBHRymw7vEsuUweFftDbgf?=
 =?us-ascii?Q?QcLqeGNsg/thyDoiR5sf3hSgGNLkjpH3OjoK2KVx1ub8pmyqE5b2dGUTjis3?=
 =?us-ascii?Q?Q5FazEKQD1kLE65AncbPjdQ67GUy1abjbHgWw8BxCkz34LaDHU66k5Fr+1oP?=
 =?us-ascii?Q?C4xzXuY5z3rGUBijaEC0vTQhcGyxW++BqUrxi9E0gHQqpmBB1HbNyEMNbHOQ?=
 =?us-ascii?Q?aSSfS7Lfq84L9mP+DB4boT6D3UoG07qK/Sp8FIShh0nwSruSlTeb0DmcKOfh?=
 =?us-ascii?Q?yVSm1sX4JQ7ikaqmNBWuFLvNQpq5jryh7Low9+DE0epD3dEr/9WjSeOqxdZW?=
 =?us-ascii?Q?xKFYmD4z9mO2DOPqDXRfhnmvybQscb/bJguxzzdtJGt20lghMyIClQmsOG2S?=
 =?us-ascii?Q?6PM5z8hdT8mclSR4aiM7qEYaBCdsyNqFGBme9+JieIRUn3oB3UaY1eSRz6CG?=
 =?us-ascii?Q?b6NLR0LprY6AdVk72HdKp5WumQ/0YdOFDgww0yPvuosv8QlJSRX59iF3jdan?=
 =?us-ascii?Q?aWiUpqqKbt5UwtQR41X6WmN1xD1AbrWQAz+BKyJYB1eGyNtbOP706zByCjPr?=
 =?us-ascii?Q?vqjGiCyZ9m9q9TnSbWwr753tICrO5ER5XEi44PXyicsfUci0t1raeEorD5mq?=
 =?us-ascii?Q?Ivk5d86Sv/bOqVgdQcnfNXuYdwtRs8WAfTc8M5+kzd7zlZhlqGGOFwAVTDVM?=
 =?us-ascii?Q?7dXv8aPv+6PEpcSijezXlh/Oir+Oqdg6gvlp1KdbvTeoGfjrmFETJLdR9eH6?=
 =?us-ascii?Q?FKUQncRuAasKS5KYUod3jMaTdrm3/WMm8Dhg8RcDnB2R2WfaLqSeZp9HvAHw?=
 =?us-ascii?Q?Gds2qrXSeP1G5jYR70nwdgsEFt758kzJlVkzFoAG4HlPrd0gTnLeSpRLuXP0?=
 =?us-ascii?Q?s+K/eCOQ8fxFexWxkNCdVVk0ncbijM4t+bWhTNydGD4E2Td8/nfMSbkbxzEQ?=
 =?us-ascii?Q?ZBNk5ex1TfoJfCVsCVLHcDKUZOwbKQwWbaSPhaREEZT4Ks45G2FMuLK0XzbG?=
 =?us-ascii?Q?EoucqQrITVyPrFhzVSVL4jvGgPREzby8VEtgsHQpHUg+KPeVT4ZwpRYUZn6A?=
 =?us-ascii?Q?eAg6HxkTkziJ3Uha4kOShBUK34du4UadajvjhVWybUXhKTVTQCcLtiW7ulBm?=
 =?us-ascii?Q?Qm1HloKQ8APRgotBjJqxkVMrXQu+C0TSe7UDJjX4Wrf3Nmo41UIGBHXZGFWd?=
X-MS-Exchange-AntiSpam-MessageData-1: zX1dta65ixeIwOGwsCbBnLHDG019U9dvsLg=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb38dd11-d384-408b-8f21-08df466bc347
X-MS-Exchange-CrossTenant-AuthSource: AM0PR08MB11804.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 18:34:36.2579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fboc0b3dpgZiMIc+Hrv7m31h5OqpG37e24vEPStUCS7QWv+zURIBo3Sb4n2n2UJDM23Ri/bVcehihE6QTGkukeYBugJYu3y7FSn2/S212wk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MI7PR08MB837237

Run cachestat() on overlayfs files in four variants. The file is written
either to the lower dir of an overlayfs or through its mount, so its
page cache is in the lower or in the upper dir. Then it is opened
read-only, so it is not copied up, and checked:

- through the overlayfs mount: the page cache is one stacking level
  down;
- through a second overlayfs mount, which has the first one's merged dir
  as its lower dir: the page cache is two stacking levels down.

Overlayfs does not cache file data in its own inodes, so cachestat()
sees the pages only if it is forwarded to the real file.

Add a check_cached argument to test_cachestat() to check the pages of a
file the test did not write itself, and bump NR_TESTS to the actual
number of tests (it was 9 while ten were already run).

The test rework and the changelog were drafted with the help of an AI
coding assistant (Claude); the result was reviewed and tested by me.

Link: https://lore.kernel.org/r/20261118123105.1247627-1-amir73il@gmail.com/
Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
---
v2:
- Rework of patch 3/3 of v1 on top of Amir's ->f_real() patch; the
  ->cachestat() file operation from patches 1-2 is replaced by it.
- Add lower file and nested overlayfs cases, and a check_cached argument
  to test_cachestat().
v1: https://lore.kernel.org/r/20260623111533.2285005-1-ptikhomirov@virtuozzo.com/

The nested cases pass only with Amir's ovl_f_real() recursion fix
(https://lore.kernel.org/r/CAOQ4uxjHwtZEHu9xMM6zg9niSgNdLXhAu65jA8Ai_SKVg-W2nw@mail.gmail.com/)
plus EXPORT_SYMBOL(__file_real) when overlayfs is a module; on Amir's v1
alone they fail with "Cached: 0".
---
 .../selftests/cachestat/test_cachestat.c      | 172 +++++++++++++++++-
 1 file changed, 163 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/cachestat/test_cachestat.c b/tools/testing/selftests/cachestat/test_cachestat.c
index 542cd09cb4434..af8fa21c90ca1 100644
--- a/tools/testing/selftests/cachestat/test_cachestat.c
+++ b/tools/testing/selftests/cachestat/test_cachestat.c
@@ -4,27 +4,42 @@
 
 #include <stdio.h>
 #include <stdbool.h>
+#include <stdlib.h>
 #include <linux/kernel.h>
 #include <linux/magic.h>
 #include <linux/mman.h>
 #include <sys/mman.h>
+#include <sys/mount.h>
 #include <sys/shm.h>
+#include <sys/stat.h>
 #include <sys/syscall.h>
 #include <sys/vfs.h>
 #include <unistd.h>
 #include <string.h>
 #include <fcntl.h>
 #include <errno.h>
+#include <limits.h>
 
 #include "kselftest.h"
 
-#define NR_TESTS	9
+#define NR_TESTS	14
 
 static const char * const dev_files[] = {
 	"/dev/zero", "/dev/null", "/dev/urandom",
 	"/proc/version", "/proc"
 };
 
+static const struct {
+	bool lower;
+	bool nested;
+	const char *desc;
+} ovl_tests[] = {
+	{ false, false, "an overlayfs file" },
+	{ false, true, "a nested overlayfs file" },
+	{ true, false, "an overlayfs lower file" },
+	{ true, true, "a nested overlayfs lower file" },
+};
+
 void print_cachestat(struct cachestat *cs)
 {
 	ksft_print_msg(
@@ -117,10 +132,14 @@ static bool is_on_tmpfs(int fd)
  * Open/create the file at filename, (optionally) write random data to it
  * (exactly num_pages), then test the cachestat syscall on this file.
  *
+ * If write_random == true or check_cached == true, check that all num_pages
+ * pages of the file are cached or evicted.
+ *
  * If test_fsync == true, fsync the file, then check the number of dirty
  * pages.
  */
-static int test_cachestat(const char *filename, bool write_random, bool create,
+static int test_cachestat(const char *filename, bool write_random,
+			  bool check_cached, bool create,
 			  bool test_fsync, unsigned long num_pages,
 			  int open_flags, mode_t open_mode)
 {
@@ -161,7 +180,7 @@ static int test_cachestat(const char *filename, bool write_random, bool create,
 	} else {
 		print_cachestat(&cs);
 
-		if (write_random) {
+		if (write_random || check_cached) {
 			if (cs.nr_cache + cs.nr_evicted != num_pages) {
 				ksft_print_msg(
 					"Total number of cached and evicted pages is off.\n");
@@ -294,6 +313,122 @@ bool run_cachestat_test(enum file_type type)
 	return ret;
 }
 
+static int mount_overlayfs(const char *lowerdir, const char *upperdir,
+			   const char *workdir, const char *merged)
+{
+	char opts[4 * PATH_MAX];
+
+	snprintf(opts, sizeof(opts), "lowerdir=%s,upperdir=%s,workdir=%s",
+		 lowerdir, upperdir, workdir);
+	if (mount("overlay", merged, "overlay", 0, opts)) {
+		ksft_print_msg("Unable to mount overlayfs (need root?): %s\n",
+			       strerror(errno));
+		return KSFT_SKIP;
+	}
+
+	return KSFT_PASS;
+}
+
+/*
+ * Write a file to an overlayfs, either directly to its lower dir (if lower)
+ * or through the overlayfs mount, so that its page cache is in the lower or
+ * upper dir. Then open the file read-only, so it is not copied up, through the
+ * overlayfs mount or, if nested, through a second overlayfs mount on top of it
+ * (using the first one's merged dir as its lower dir), and run cachestat on
+ * it. Overlayfs does not cache file data in its own inodes, so cachestat sees
+ * the pages only if it is forwarded one (or two, if nested) stacking levels
+ * down, to the page cache belonging to the real file.
+ */
+static int run_cachestat_overlayfs_test(bool lower, bool nested)
+{
+	char tmpl[] = "/tmp/cachestat_ovl.XXXXXX";
+	char lowerdir[PATH_MAX];
+	char upper1[PATH_MAX], work1[PATH_MAX], merged1[PATH_MAX];
+	char upper2[PATH_MAX], work2[PATH_MAX], merged2[PATH_MAX];
+	char cmd[PATH_MAX + 16], file[PATH_MAX + 16];
+	const char *write_path, *read_path;
+	char *base;
+	int ret;
+
+	base = mkdtemp(tmpl);
+	if (!base) {
+		ksft_print_msg("Unable to create overlayfs base dir: %s\n",
+			       strerror(errno));
+		return KSFT_FAIL;
+	}
+
+	snprintf(lowerdir, sizeof(lowerdir), "%s/lower", base);
+	snprintf(upper1, sizeof(upper1), "%s/upper1", base);
+	snprintf(work1, sizeof(work1), "%s/work1", base);
+	snprintf(merged1, sizeof(merged1), "%s/merged1", base);
+	snprintf(upper2, sizeof(upper2), "%s/upper2", base);
+	snprintf(work2, sizeof(work2), "%s/work2", base);
+	snprintf(merged2, sizeof(merged2), "%s/merged2", base);
+
+	if (mkdir(lowerdir, 0755) || mkdir(upper1, 0755) ||
+	    mkdir(work1, 0755) || mkdir(merged1, 0755) ||
+	    mkdir(upper2, 0755) || mkdir(work2, 0755) ||
+	    mkdir(merged2, 0755)) {
+		ksft_print_msg("Unable to create overlayfs dirs: %s\n",
+			       strerror(errno));
+		ret = KSFT_FAIL;
+		goto cleanup;
+	}
+
+	if (lower)
+		write_path = lowerdir;
+	else
+		write_path = merged1;
+
+	if (nested)
+		read_path = merged2;
+	else
+		read_path = merged1;
+
+	snprintf(file, sizeof(file), "%s/cachestat", write_path);
+
+	/* Write the lower file before mounting overlayfs over it */
+	if (lower) {
+		ret = test_cachestat(file, true, false, false, false, 4,
+				     O_CREAT | O_RDWR, 0600);
+		if (ret != KSFT_PASS)
+			goto cleanup;
+	}
+
+	ret = mount_overlayfs(lowerdir, upper1, work1, merged1);
+	if (ret != KSFT_PASS)
+		goto cleanup;
+
+	if (!lower) {
+		ret = test_cachestat(file, true, false, false, false, 4,
+				     O_CREAT | O_RDWR, 0600);
+		if (ret != KSFT_PASS)
+			goto umount;
+	}
+
+	if (nested) {
+		ret = mount_overlayfs(merged1, upper2, work2, merged2);
+		if (ret != KSFT_PASS)
+			goto umount;
+	}
+
+	snprintf(file, sizeof(file), "%s/cachestat", read_path);
+	/* Look at that page cache through the overlayfs layer(s) */
+	ret = test_cachestat(file, false, true, false, false, 4,
+			     O_RDONLY, 0);
+
+	if (nested)
+		umount(merged2);
+umount:
+	umount(merged1);
+cleanup:
+	/* Best-effort recursive cleanup of the temporary tree. */
+	snprintf(cmd, sizeof(cmd), "rm -rf %s", base);
+	if (system(cmd))
+		ksft_print_msg("Unable to clean up %s\n", base);
+	return ret;
+}
+
 int main(void)
 {
 	int ret;
@@ -317,8 +452,8 @@ int main(void)
 	for (int i = 0; i < 5; i++) {
 		const char *dev_filename = dev_files[i];
 
-		if (test_cachestat(dev_filename, false, false, false,
-			4, O_RDONLY, 0400) == KSFT_PASS)
+		if (test_cachestat(dev_filename, false, false, false, false,
+				   4, O_RDONLY, 0400) == KSFT_PASS)
 			ksft_test_result_pass("cachestat works with %s\n", dev_filename);
 		else {
 			ksft_test_result_fail("cachestat fails with %s\n", dev_filename);
@@ -326,16 +461,16 @@ int main(void)
 		}
 	}
 
-	if (test_cachestat("tmpfilecachestat", true, true,
-		false, 4, O_CREAT | O_RDWR, 0600) == KSFT_PASS)
+	if (test_cachestat("tmpfilecachestat", true, false, true,
+			   false, 4, O_CREAT | O_RDWR, 0600) == KSFT_PASS)
 		ksft_test_result_pass("cachestat works with a normal file\n");
 	else {
 		ksft_test_result_fail("cachestat fails with normal file\n");
 		ret = 1;
 	}
 
-	switch (test_cachestat("tmpfilecachestat", true, true,
-		true, 4, O_CREAT | O_RDWR, 0600)) {
+	switch (test_cachestat("tmpfilecachestat", true, false, true,
+			       true, 4, O_CREAT | O_RDWR, 0600)) {
 	case KSFT_FAIL:
 		ksft_test_result_fail("cachestat fsync fails with normal file\n");
 		ret = KSFT_FAIL;
@@ -361,5 +496,24 @@ int main(void)
 		ksft_test_result_fail("cachestat fails with a mmap file\n");
 		ret = 1;
 	}
+
+	for (int i = 0; i < ARRAY_SIZE(ovl_tests); i++) {
+		const char *desc = ovl_tests[i].desc;
+
+		switch (run_cachestat_overlayfs_test(ovl_tests[i].lower,
+						     ovl_tests[i].nested)) {
+		case KSFT_FAIL:
+			ksft_test_result_fail("cachestat fails with %s\n", desc);
+			ret = 1;
+			break;
+		case KSFT_PASS:
+			ksft_test_result_pass("cachestat works with %s\n", desc);
+			break;
+		case KSFT_SKIP:
+			ksft_test_result_skip("overlayfs not available for %s\n",
+					      desc);
+			break;
+		}
+	}
 	return ret;
 }
-- 
2.56.0

