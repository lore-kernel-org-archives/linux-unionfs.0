Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC3C21C17A
	for <linux-unionfs@vger.kernel.org>; Thu,  5 Dec 2024 15:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733411077; cv=fail; b=luF+znHV23rqCBdJwryJYUxBSEYNKIn6k58HOB/vWwveFn+8a4L6ueB9F3JwunvTpA7mipub65w77qoZxakTRsJATRaWZgE3+oXyOWvpfs/I9Qc9+m3+xOaZZCbFkLvVSbEth8GFC/UL+V7zUnhWjHnX/6HpVL9MnUuKv7Cl4uE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733411077; c=relaxed/simple;
	bh=S9bmK0XAqY40OmiYg2gpJG6VH13LbqrU04x86rko61Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=E8D9wayGIxJodBGRGiMey75wxfGpc0E1zDUqNfZTMky2ZjBlNgCPiZQ2Y+cHWTBuDsgyxa/BHZLSlGhbrY5Bel9m88j+zVPGoUsKvrA2MKhja2FDgR4khsqLQfu3PHfzyDVmboNRBhKwUUgV7WOvKAVx9/ACaNqr4NDeZdB1KPQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eO8qPAW3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WNT/kthv; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eO8qPAW3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WNT/kthv"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B5DfliK001796;
	Thu, 5 Dec 2024 15:04:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=qvx8MV+K6DLsX1wY6L
	EZhqbLhc+bLgYmyJIb1Ec3vZY=; b=eO8qPAW3WSeVPR6OvzeSEyzHCLRuMfD+5D
	rOjcUs2DxMW/yWcngzb7SEsRpR255LDVjHbyWm5qPYd1EGWLV7dqWxMJpod+Wyza
	yGt03263ExaWJl1yoKxGEDP2JKB1SFzuZ6nfAPGqsn4J0hFcMZJe9gBfSmpeGSZE
	Ue8iXu+vqKajf/cVNdxSXR7pS7XCtWYD40buDnmK/PRT0dURWP8++x+TDyO3gz2B
	zPvJsJFOLQQZ7wtmEE3WMHQKeFHf6awD/X75zQns5UiUaUNFqzCk9DJbuN7eoe3L
	UvEu2IoRa0qyD5gtQGLBe+R2VJdyO7j0l2ZIoWdUBstV1NJhanpQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437s4cb4f4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Dec 2024 15:04:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B5E7X4m020389;
	Thu, 5 Dec 2024 15:04:10 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 437s5b1b73-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Dec 2024 15:04:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Noj4Jd++VWg8Or44ftErlsKLVaziZ8B4jOMq/04kP1MMGxx+c/ZsNKGZ0reHhmMu4nCyAV+jTD1A7jJgMRUXlar0lXrUa2sbD5RcDomU6GktPa0BStk1Upjs1kUqCUerF9zYWqijdEi8R0QIwhjFU5DsHeLGArFCH6lfbEGCdXtVYog91MF6SZgO1HUZuUrvvr5Vj/H4aO29NXQXMcp0vWvj1xsn6nq3dB91YG/Z9QndC2CXj/274zcfvwnf5+61wu8HuLA1Fd33YlEQg7pIQe4KlZD06G/p2ZSkmell+MXWFaCCOMza6KsPAEcMDeZWPoYk0WfVwfpaqS9ZzDnfoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qvx8MV+K6DLsX1wY6LEZhqbLhc+bLgYmyJIb1Ec3vZY=;
 b=PBoRgFn/nfgcp6eswvS5yCLhvdnCZjPrdK6q7GBe6vgyQ08FATkcJbooi78aPW+xhAs9cxbGYD9a+68Ze2cUG8Gdp93flLXgnZ4rcpDaFxexW0LoGMaMV/fWCkAlxPTCaVIgK2CP4Rr4ef7VriN1uWcMK383uslvXsPAI3AmQHfD7AIVVNmQ55QsH8c1AUSEFfH8URhstkkSpjMCHZ2uZxqn+Ca2y07C1h78Q6ci5nB0ehaMYiohxMhEEPoBpaqGkXfHsupHN9pcAnXvjyYrzdnkviLokKxZTqpTyPrHXLRNwMD2ZBh2fditQQgt4kUxxrg18GQNyU5A/jKOYluCjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qvx8MV+K6DLsX1wY6LEZhqbLhc+bLgYmyJIb1Ec3vZY=;
 b=WNT/kthvnrShZhG8Hsj6heknMr+aDTnJe7vX09R/OEm6kYet2CCJkj8Uf2rL7wOvUzxn063zhj0oTBqBSwL5S8EA3UA1EUePOSdMWNCb/OPMflJMCpzM/IR1Pddam2bli8uKPcsAx4JJahcyo12u67+Nd4Yn5ZRurgYzk/NeVTM=
Received: from BYAPR10MB3366.namprd10.prod.outlook.com (2603:10b6:a03:14f::25)
 by BLAPR10MB4978.namprd10.prod.outlook.com (2603:10b6:208:30e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.12; Thu, 5 Dec
 2024 15:04:05 +0000
Received: from BYAPR10MB3366.namprd10.prod.outlook.com
 ([fe80::baf2:dff1:d471:1c9]) by BYAPR10MB3366.namprd10.prod.outlook.com
 ([fe80::baf2:dff1:d471:1c9%7]) with mapi id 15.20.8230.010; Thu, 5 Dec 2024
 15:04:05 +0000
Date: Thu, 5 Dec 2024 15:04:03 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: miklos@szeredi.hu, amir73il@gmail.com, akpm@linux-foundation.org,
        vbabka@suse.cz, jannh@google.com, linux-mm@kvack.org,
        linux-unionfs@vger.kernel.org, wangkefeng.wang@huawei.com,
        sunnanyong@huawei.com, yi.zhang@huawei.com, tujinjiang@huawe.com,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH -next] ovl: respect underlying filesystem's
 get_unmapped_area()
Message-ID: <69b72e3d-b101-4641-9ce5-51346c93a98d@lucifer.local>
References: <20241205143038.3260233-1-tujinjiang@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241205143038.3260233-1-tujinjiang@huawei.com>
X-ClientProxiedBy: LO2P123CA0077.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::10) To BYAPR10MB3366.namprd10.prod.outlook.com
 (2603:10b6:a03:14f::25)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB3366:EE_|BLAPR10MB4978:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c04fd9e-dbb2-49d8-b21d-08dd153e0feb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UteohLtFpGbhtZXG0wLCNn7+qcx5c02kqqyCQllgtAycDAZjpwGLOmfVajLI?=
 =?us-ascii?Q?YoFXNhv9ZMyhi7TctA3MmkJTorwxjVeqjB75Z6Hb41tFisoQ+z2Hp477fclu?=
 =?us-ascii?Q?M0OdM3emWydankoiQQtBEbBMR/gVxCETXpnupGIdiPyj8s8ethyyUlksuxJ3?=
 =?us-ascii?Q?fe6E2TbIwMZOGMne5pXvHhqIQYZ4+kEt/gzBM+BQdmAoeCSkE+Wt2BA4Qxv0?=
 =?us-ascii?Q?Mk9/3zxVjbR8RC9ThkN2tjYon78SzbViWrIv0PZzxv6j+efNUV2xboFVANcc?=
 =?us-ascii?Q?led2k5XAovS/nemU9L7k0BuJ5K51f7hEKl+OmPII8pZUHK5axm6YcDN50vdl?=
 =?us-ascii?Q?nuBXsd3RYpUduRuZGxVnJV+/gt3IlbGTD/qcKryWISu5Oh2rzf8u7fJ4u7e3?=
 =?us-ascii?Q?lBIgKux7+qVTYZqd4OedQZ3T04/ehi+RSO1+fYtVV2eboKJq+4btt/9Vck6x?=
 =?us-ascii?Q?BVPI4THqyIO878T8a9qqBU1WregPpUokwYELATQCvNH+xOBwd3oJ+MM8xvC4?=
 =?us-ascii?Q?3x/cC3zCZhwyzfhtOOKINAmdy9OgC4HXDOq+cJAant2FEOujy+BUJYPqrnJn?=
 =?us-ascii?Q?cMhdDZgSSsQ31nTM7WsXrEzZ//f7kI0kBFR4MYgkDzS6YKUjGQsGX7aW+tGW?=
 =?us-ascii?Q?jztPicvAWWytZO0fc7Bw8cHK3qZlmD4Cu0Dbxayx6fQHWyEQQJJsiiWJjoht?=
 =?us-ascii?Q?9XQb1Xu0JU7f2Ahu4JY3/H22A1+M0CyJvK2vxgQFQxex/cBKDw0ifdV7TrW9?=
 =?us-ascii?Q?h9RbkIfhBZg5scbSnAOGr9VQIoff6PHewAMqwhkK61tT6G1QLaZ4JELOlSiw?=
 =?us-ascii?Q?5TGatN+pL29jK5V7OLv497X1sRuG79DhhSa7Fk1oFU93L7Jr/gnf+zotKz3/?=
 =?us-ascii?Q?hckLUQyE9YnLz/Q0q6gyQ75+UEndTU266qQawgQ9rVwQUqSJaru4pGmLXo0C?=
 =?us-ascii?Q?2lXAucYSMGxmjsVI63qnYKxz/MRerIhvh1xr9MxyiG2BEKJNKag19KC4gWQa?=
 =?us-ascii?Q?pyKPlSA7pyLVIomVSX9cFyuSXLNDxeeKYGGWr8+4rN17DMV74JzQwRJB5r1U?=
 =?us-ascii?Q?rREO4xTu2EYN2qmyrV5mKFbecXzPJ4EE5MetX3nJrgOrA+AIU1FbAf6b6tP9?=
 =?us-ascii?Q?46WmcPH7fj5tr6S9VdYhZlTRUTIs8LJbnphGY3KtUYX6YfeqkFzDEnBuYkPi?=
 =?us-ascii?Q?izoL0dqiwVFx8Q+xo/juEFFh2SyRdHFhPM6Jta8yrMwRA7gPfXck6IfpkGXp?=
 =?us-ascii?Q?hH9ZKh66b9qEcwVAta9cRc3G0gLLaBfTNphodnyyBi/3aC1NCjbXHKBNVDIh?=
 =?us-ascii?Q?Xk+U18BfIJp/kpdosn/3KDbx3crUXLPRiTWo0dxkrC0z0w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3366.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BHsPPaZf/POKUgLlKiaLJwGXS2m1xP5ZC5KA4HTbp8P+QrVD0gERfiGLEBEm?=
 =?us-ascii?Q?fByMHOokJJhdySObxS6abiCfGbEnEERI6fH0KNBMZzaB9hw5Ihw/2MZo23Kd?=
 =?us-ascii?Q?rAzHOJrzA9do6iYj+u3/IlNUWYi1FRAVGiHcx/+eCd+S3t2rfBrEP7W+lVJj?=
 =?us-ascii?Q?3bYN57fTQRIj+GWa81znrf0JtpbTa2G3rtVoquFxwVw2QN1BlfWk0pmSpHIm?=
 =?us-ascii?Q?sy1OH8RS/XBXUrpoZOITueyCxZWXEA5Ozc0MylZPZNSvqXUGQ9TLOg3pB7C1?=
 =?us-ascii?Q?tCDx8NlvD9G90DJB4c6Er0L2/DMSPKo9UERXOtXNqB+ZxSWn55b2uryPxxtr?=
 =?us-ascii?Q?mSXUVPsPa3SrY/vZJlK727IbewHcEMMrayLM+/whY/fBeFRVHdJ0KOY0udxk?=
 =?us-ascii?Q?gJ0koVFPEkI0iK0cgDpjiF8L4dT8NlLLw5SwQF99DCQsqo3wRYlWXyGU7nS4?=
 =?us-ascii?Q?hHBi21qHOp389lONRaxUIEp8xcsr2+czf7kr2pIwmo40IzDq0NAQKbur7P9S?=
 =?us-ascii?Q?Gjp5o/yb4Lijsm5by4+6TZHZQplKEGjxS+0zMa7FGsx02dwpMfCyAodAdX2X?=
 =?us-ascii?Q?XM10NO60MntMDn5CtrqBdetdBvChXtFf3XLPjsiF+S9zZWDaOdtVsRNFfZKB?=
 =?us-ascii?Q?1yyBYANEGxX+YVOWXHMmLvbOtHnjYfnpTZOFq9Cc0ygzHgVkAXooUJujF6O5?=
 =?us-ascii?Q?OImpsJLhSgE01UAfWREqQJ/XXLduGDcD1x/nCRUN1O+i75lKzvdGWvYLDJ/d?=
 =?us-ascii?Q?6+/CKVZ8+SnpPXmLBHvoh6cGGXfO7wE8aMkPZYHmUJ0X16ENOrFp2OlhM+/9?=
 =?us-ascii?Q?MiIx/GKa7CEjnxGfjTZZGs1DEw3LFgMxzPpFYeIvqXysj6/pjIeYc9dhxGBU?=
 =?us-ascii?Q?KY9whgvbBVh0zjsd+It0IBpplHss8DI8Hbv/kK5N02/CMmRLhsc1X956B0cS?=
 =?us-ascii?Q?N42jdgR+383yJPneHObq0vDWx16TEsJCmISHohKibzHbUiC6O7oyYwhySoa1?=
 =?us-ascii?Q?e3l/epxIbcs534+6pUPMIu0ipM8LKb3eNLACAZSq37EIcB6+AqKZ9T1LanAb?=
 =?us-ascii?Q?AkXAva8oCbUA3BNdAgXdMt+oVyeA/dL0JTfdoeFId0lbu2eUuhbNO94ouaON?=
 =?us-ascii?Q?PqKUdniVyP6yt7Gp4AcYj6ZS5rC/+AoKqKjx6/VJp9s0IzHv2ivj9ae+oXVW?=
 =?us-ascii?Q?z4GMYIvdpHPJQuzAv/ta49Y/kdhNDOPy3YEU/VSQeadibUXnQcDHORAzOqb4?=
 =?us-ascii?Q?4MUD7ZlwMYh27pC6nWZ7InywV460KFrqbSgxBy7w1MvmHIScIYAv35/BSRxJ?=
 =?us-ascii?Q?ifBlF48xp9zMpHQXvXad3MBRLXz6Vgz7YLCW4BFRBjsx7Cbjs3MWlq09t93s?=
 =?us-ascii?Q?ad5/IWCwAIC4+mXiLx46WtofWas3W9i1LP8OZAnZ3bEfq4ETCZF9W6WtqJPr?=
 =?us-ascii?Q?0BahUhspZ2v0qLuEk1L9m0zguI9JfYyG3ap8GcqlnoBvzuNWyJru1LRyntCz?=
 =?us-ascii?Q?x037E04pZ39bcflAIACzkM9gvefE2j7QdW02YzaF1+SlrpS9xlrylvAPJGqD?=
 =?us-ascii?Q?0MJ90FZ7NXWhuG9zB4R3J0ZKcoYbKAiyISU6W4heqRBrQelNuJwBGnFoxgMk?=
 =?us-ascii?Q?ow=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2+rAvkJPHwzOKPKB9fGIWqh+X9em1GYVG3/XkyEc74a7t5n8nwOkj7Hosd3NzcCLIixocoTFmDh648g0xgE9jwYomEDNHWRo/ppGGaK3ml9Rnr7kgXsOvHiF6ToRWdqdmH/C6oapwSo9O7M9EZS0toFoR+kyF8nc+1Dylyip5cCIke2cYOt/uZXLvKyBYKHVvSZrVYFS1iPx3xSaeO4PH67MQ2KHRb0sN2VxJdzTex8bbBUlCiB1OxNT5IH5N57M6Jf/hAUtsaUPBcwjg2klqzjd+Wr6KEEjQDPTzUBVPc0wknAsd1Ed23PNeST0m1X8pPr3VlbmV70JEAUKwPDOKU48/PB+VxC3d/pWcoXz/hmN3cBJKslLsKrnlv7qYs6cNYVOHIWidaBVN8yJRQ6L3rRi+lVBvb7Ps+HFcmQ8/k81RmPIAg91qy0hiPGCjOQpJ8n471K9KR24EiNPbttf10++KZz+IHMJsQk7+wajVMh8sxbfKs8czed1m2mc8XGz+AxYjSFHqU99PqdR1VWxaBU4C2OvmwDHebTDlw/GqkQGwTzcjR854adr5XSRJHIYGpLGf2Fs9im5QGEy0kQkIcT/FaWcGtol2y3wwyrlvBE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c04fd9e-dbb2-49d8-b21d-08dd153e0feb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3366.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2024 15:04:05.8403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JBi/l6XTvoYBiCkvj9+RPVZ1W7gVf68WVYqkQ7BrNPsvduBQQ+MBWp8BNb9E28Upd4egQPS9cRO2kkkznOOvq7HdoXwQqqTQ2eSWKSRABbg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4978
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-05_12,2024-12-05_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412050109
X-Proofpoint-ORIG-GUID: cZ_bvDAO_pzSJjZRSQTyhc7hHH6vcN5j
X-Proofpoint-GUID: cZ_bvDAO_pzSJjZRSQTyhc7hHH6vcN5j

+ Matthew for large folio aspect

On Thu, Dec 05, 2024 at 10:30:38PM +0800, Jinjiang Tu wrote:
> During our tests in containers, there is a read-only file (i.e., shared
> libraies) in the overlayfs filesystem, and the underlying filesystem is
> ext4, which supports large folio. We mmap the file with PROT_READ prot,
> and then call madvise(MADV_COLLAPSE) for it. However, the madvise call
> fails and returns EINVAL.
>
> The reason is that the mapping address isn't aligned to PMD size. Since
> overlayfs doesn't support large folio, __get_unmapped_area() doesn't call
> thp_get_unmapped_area() to get a THP aligned address.
>
> To fix it, call get_unmapped_area() with the realfile.

Isn't the correct solution to get overlayfs to support large folios?

>
> Besides, since overlayfs may be built with CONFIG_OVERLAY_FS=m, we should
> export get_unmapped_area().

Yeah, not in favour of this at all. This is an internal implementation
detail. It seems like you're trying to hack your way into avoiding
providing support for large folios and to hand it off to the underlying
file system.

Again, why don't you just support large folios in overlayfs?

Literally no other file system or driver appears to make use of this
directly in this manner.

And there's absolutely no way this should be exported non-GPL as if it were
unavoidable core functionality that everyone needs. Only you seem to...

>
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> ---
>  fs/overlayfs/file.c | 20 ++++++++++++++++++++
>  mm/mmap.c           |  1 +
>  2 files changed, 21 insertions(+)
>
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 969b458100fe..d0dcf675ebe8 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -653,6 +653,25 @@ static int ovl_flush(struct file *file, fl_owner_t id)
>  	return err;
>  }
>
> +static unsigned long ovl_get_unmapped_area(struct file *file,
> +		unsigned long addr, unsigned long len, unsigned long pgoff,
> +		unsigned long flags)
> +{
> +	struct file *realfile;
> +	const struct cred *old_cred;
> +	unsigned long ret;
> +
> +	realfile = ovl_real_file(file);
> +	if (IS_ERR(realfile))
> +		return PTR_ERR(realfile);
> +
> +	old_cred = ovl_override_creds(file_inode(file)->i_sb);
> +	ret = get_unmapped_area(realfile, addr, len, pgoff, flags);
> +	ovl_revert_creds(old_cred);

Why are you overriding credentials, then reinstating them here? That
seems... iffy? I knew nothing about overlayfs so this may just be a
misunderstanding...

> +
> +	return ret;
> +}
> +
>  const struct file_operations ovl_file_operations = {
>  	.open		= ovl_open,
>  	.release	= ovl_release,
> @@ -661,6 +680,7 @@ const struct file_operations ovl_file_operations = {
>  	.write_iter	= ovl_write_iter,
>  	.fsync		= ovl_fsync,
>  	.mmap		= ovl_mmap,
> +	.get_unmapped_area = ovl_get_unmapped_area,
>  	.fallocate	= ovl_fallocate,
>  	.fadvise	= ovl_fadvise,
>  	.flush		= ovl_flush,
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 16f8e8be01f8..60eb1ff7c9a8 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -913,6 +913,7 @@ __get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
>  	error = security_mmap_addr(addr);
>  	return error ? error : addr;
>  }
> +EXPORT_SYMBOL(__get_unmapped_area);

We'll need a VERY good reason to export this internal implementation
detail, and if that were provided we'd need a VERY good reason for it not
to be GPL.

This just seems to be a cheap way of invoking thp_get_unmapped_area(),
maybe, if it is being used by the underlying file system.

And again... why not just add large folio support? We can't just take a
hack here.

>
>  unsigned long
>  mm_get_unmapped_area(struct mm_struct *mm, struct file *file,
> --
> 2.34.1
>
