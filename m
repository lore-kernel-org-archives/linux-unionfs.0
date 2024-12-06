Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055FA1EE033
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Dec 2024 09:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733477165; cv=fail; b=tsZuwNIsDhLzvKBISM4WEFctFMfJ7qvz7sINurdS/yzvTYveQACucilPmK0jfGymVuTFrS1KUZL3IyPyK56NyljygOkAbz1+OSc8chmXGNebmPVUDVVviLruLOWyqz0zl8vmeZw+6EYyIvvdCetqDQcUaM/r/gXSsWZGbbkaDMk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733477165; c=relaxed/simple;
	bh=iwNdSBBSDH+bzBjjbM7RiWn8bi2UrKpL+8jWZ4rPJkk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fOTD/54QOpPzHut7/EPoD3cqqjPaM57BZWKyh13qNNpY01BprQSZ6Sj5rYNB0TYjaNRj7jDVQof1U+/ur2VAXsmsAjPpni6AH3iJER9GZ4e+3Bsgb6WYxKQExthwZ/yhDZYqaFsoDNqYwVnZEw1fHuWwRtvK1VY5znKyuqk8iVs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cu29rEmU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Vl3NkYDk; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cu29rEmU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Vl3NkYDk"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B66rxE5031829;
	Fri, 6 Dec 2024 09:25:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=II/HOccudqzPZzVwG6hLXTr1rS22UbtQ7Qwdnmzgpns=; b=
	cu29rEmUZ1dyoY9VbTCHNPhwdCvfyydrngmKDb/3AFgj4iRO/X+v0O8w8b6SKxij
	/bKKgoCaO4ui0zCzZraxn+XbyJfAtvle1m+V0hhMyVj3oqxYkkqlLQTF+xKs4tDm
	3oHxH6Th6xAppGn0eTxaW+U2u7GmIdITwgB/P1Q3rFdfMSu86TJB7DuRaO3eFMZg
	HN2u2R5ei0dMg2SDHQy+fFlVYqluj2TqeaD8CpjVQsBmwQIyRGTxTCVNh0GpkaD9
	0o6ezFXYBZGFaQNmVXu8ig8PJkJ2Y/ohy5GX0JLB7yEJvOVxrquJ6/8as+b9PtRu
	wQ1EGhucRJM0/Ai1T7bWcw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437u8td84j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Dec 2024 09:25:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B684kkH037003;
	Fri, 6 Dec 2024 09:25:35 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 437s5cm2kc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Dec 2024 09:25:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H8S82l4QA6a79MXBNIckqVI4PsXuc+CSP7l3FrJ3eCabE/0cN+i+PX09MROVsu9qfvmGrnqseiAPq7/+aIlS/xxI3zBEefq10qORN9wRNJ5dIAWfiIomdzYcf2x6zEoH1qAtxQH8DKAMMRUYJUvpOcMBp8qhH/matEJp6T/Cv98dmn7x1FIAnW7dap2Xi3Cgm3jjwg7fVJKsZO49Smmpj/YT0NwgD+hlaxW80WDss7trNe8To+gIPU8xDOtV/j3TKI75q5S5chu2KEl+ifaEybcbK8igkp7Aa/H4aj8NYXCrg6s3hsjNHCDgXZLCQjtx5gU2NkC2Uk2a12Mx6CiNpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=II/HOccudqzPZzVwG6hLXTr1rS22UbtQ7Qwdnmzgpns=;
 b=LXWgND92JcrdAyeFaWlCjH+beqe7kP7U/etbNpTp8JiP83YwlSXvsTpCr+mI3ulfNPEV4EKlIm2ylI25u+Ji3oNSiKcP7W0jt+pwQn18cCQlcPPph7i/y9yJd9VrPuhKw2s0XjAH1g0p7+WkTrGbpIwwWT1cTMNDHGm5SllI2Jqx36uzQ0d19jzMMsyDKUEJcsu/H80C41gpk7SFCt/zuY9gvDykpUuH0XGWJK5Qcdb/Ugmu8kbR9+fl3nxQ1fGGf5VL62LtNF6hPuRA7Gr2xbl2o722A4ILOy1Er5rZhH1osbASczfke4vN+WMcYTBhEnX9yyR9MTUsZy4Xu0ogoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=II/HOccudqzPZzVwG6hLXTr1rS22UbtQ7Qwdnmzgpns=;
 b=Vl3NkYDkS+r/3/DyenCbK7HjqojfENLhbxncsb4DWvhkD16BANFC/ZAMkmVK2kBrjOP69ird2HHQJvKR3AuP7wlWckp63MxLNTqXN9iFUL+UPHRuEVtCNOC0e1q0qG6TdBWg1bf4F01W5NohgDwPguS6qSuePhM17vL9jViwrss=
Received: from BYAPR10MB3366.namprd10.prod.outlook.com (2603:10b6:a03:14f::25)
 by DS7PR10MB7346.namprd10.prod.outlook.com (2603:10b6:8:eb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.24; Fri, 6 Dec
 2024 09:25:32 +0000
Received: from BYAPR10MB3366.namprd10.prod.outlook.com
 ([fe80::baf2:dff1:d471:1c9]) by BYAPR10MB3366.namprd10.prod.outlook.com
 ([fe80::baf2:dff1:d471:1c9%7]) with mapi id 15.20.8230.010; Fri, 6 Dec 2024
 09:25:32 +0000
Date: Fri, 6 Dec 2024 09:25:19 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: miklos@szeredi.hu, amir73il@gmail.com, akpm@linux-foundation.org,
        vbabka@suse.cz, jannh@google.com, linux-mm@kvack.org,
        linux-unionfs@vger.kernel.org, wangkefeng.wang@huawei.com,
        sunnanyong@huawei.com, yi.zhang@huawei.com,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH -next] ovl: respect underlying filesystem's
 get_unmapped_area()
Message-ID: <a39ef271-dc1b-4f61-ba01-dde5b127bef2@lucifer.local>
References: <20241205143038.3260233-1-tujinjiang@huawei.com>
 <69b72e3d-b101-4641-9ce5-51346c93a98d@lucifer.local>
 <041dcc1a-0630-27b9-661b-8c64a3775426@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <041dcc1a-0630-27b9-661b-8c64a3775426@huawei.com>
X-ClientProxiedBy: LO4P265CA0100.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::12) To BYAPR10MB3366.namprd10.prod.outlook.com
 (2603:10b6:a03:14f::25)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB3366:EE_|DS7PR10MB7346:EE_
X-MS-Office365-Filtering-Correlation-Id: c5e806df-fc4a-4352-e66e-08dd15d7eee7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZHpnUFlaVmFYM05PS0NTdFlHVkV2WFhKQjJ2dmIxaVMyR1ZBNUdvRGpPRHQ2?=
 =?utf-8?B?Nm13a3NGSmEzYWhrYkNLb1cyMGRUWGVMSVgrN2xVVjZVRG5oejdOMTBqaUFl?=
 =?utf-8?B?RU1JVVh0R282QmQ3VGdSNGxpcGszdDFqeGE5S0ovTFZyQ09KYWdJR3ptNTFm?=
 =?utf-8?B?Mkc1d2doNzJxYmFEelBpUGE0VUkvVG5kV0NubDRrdVMwbnZmRHg4cmp4QlBW?=
 =?utf-8?B?bzRITkNvUGJYU05zU2x6dkJxSFZ3ZDFWZS80eEZOaTlkTnJZR3FIcjFaTG9N?=
 =?utf-8?B?Q1UrN3hLbnBBdFJRcEVvVDFjWW9yRDlsU2xwMzhPVzF1NXpaZVhOcUIzRXQ3?=
 =?utf-8?B?MnNkN214STdoNjJhSjJiTkpYYXFYZ1h3S3ZxMk5DSWhsb1FiK0g3dXZrTWQ4?=
 =?utf-8?B?M1M5ZXZEdTR0Q1R3VmVWV0dBSkQ4dzcwNWJHSGtXQ0pBZ3FvVEJYQThmVnk0?=
 =?utf-8?B?c0lkaHI5c0h2TjlFMzFXbXNLMGM1UnV6UlRZKzV4YTIyRGZLQW42Tk1QSi9B?=
 =?utf-8?B?M0FCU0NOR3Bzc2VKYVRZZkhLOUYyOG9HVTNsQUF0SzJyVlRrS2pZRjVSenJF?=
 =?utf-8?B?R2dvZ0NKQ0VuSlU5dW12Nms0amhpWDJRQWlHUHhITHdqNi9TcE0rVkJ0ek5l?=
 =?utf-8?B?K0UyMG4yRHlXb1l6ODVNVS9lVlNWVWFjNnl4Y28rbmc1R0crb1JiMVV5emNo?=
 =?utf-8?B?RGJLMEZjUEEvb1gxSzhBRFlXSS9VRitybVU1OWRqMmpNbnMyZSs1YTljcE1D?=
 =?utf-8?B?RVBmdzNmd3VROXEyVnpkS3BDa2dhcXVVQlFma0ZvcUdPbC9BSVBLTTl5ZTBt?=
 =?utf-8?B?L2VsTzNzN3MvMWgzOG5oRXp6WG1hNzQ4ZGlFWUk1Y2VHeDhLTXpUQlpvaXc3?=
 =?utf-8?B?b0NiZnVCeU9hNUJLM1Z2YmQzNWs4Q3pTQ1MxWTM0MzdvY0RGOXlFdUt1L082?=
 =?utf-8?B?RFl4YVRKVEZuczEwaDhvSkg5QWxCcW1GV29UbnNJTTFNNlRieldHZXlSV044?=
 =?utf-8?B?VHQwVkxMSGFuUDFlak5Xek1iZEhHMVVPSmswZjhpTkFiZ2RleThDRHBSWWhz?=
 =?utf-8?B?K2pCQlQzUTRyYXdLTGlTVG5Yd2MremNCbXdqU0MxczRzNVphVmVGWFJ4YlZk?=
 =?utf-8?B?U0xBdWphNlhlKzdOR2FHYUZhRlJFZGhsU1dqN1lLd3ZBUmNMUk43WjBJQ05k?=
 =?utf-8?B?TmVOdXYrdGNGamlqeWEzWWp6WFQ1eUpnVEYzWmZMMFFtd3dzQjM1M211eTBs?=
 =?utf-8?B?c1UwTy9pRVNkTVVEWWk5MElHMGVNbmNUU2Vkc0RiSWQ5RkZyVzdEY1lLT01k?=
 =?utf-8?B?TzhPdVVwcmRwZEJxWjNvb0tEVVpPcGRMbjQ4NmdhZENFWmJHRmxVTm5UcFdi?=
 =?utf-8?B?ajdLRnlFY1pTYmg0eUQxVmVqdlFzUW53bzIyY2d1RU8zWW5iQlQ3Q0ZzMld4?=
 =?utf-8?B?eDV4QmdhNi90d01PYVRjYTlNZ09XaTM4VUM3V0cyYmFIRzk5WHhLT3crMGkw?=
 =?utf-8?B?emFYTzJiZHVIYVpMOW9ZNm5malZoVWJiTUJaV2huZWtJa1RxTHhSd1hWbDVG?=
 =?utf-8?B?MTI1c3JEcDlYQzRaWW9HaDFMdTVnOTdrREhsZVlaWUxSWW1JczV5bWtPYktl?=
 =?utf-8?B?ZzRvR1o5T0cyN1J5VG5ZbUJPbExENUpFZ0RMNGo3aTkvQ2xZVnNmNjVHbFJj?=
 =?utf-8?B?WnlqRVM3YnNGRWs3Z2VJWHdYWTZZMmNqS3AzK0E0YStPa1JEajF4cmk4Q3Fl?=
 =?utf-8?B?N1F0Zlg1cWZUUzEzaHBCZTd3Sks2d0t6S0t2Q3JBNjlXeE9YWEpDeml3Y2VL?=
 =?utf-8?B?cHd1bW5CdWJEclpZYU84UT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3366.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?blkrZTV4WGZZVGg0VGdLc1JzampBY2dkYmVPeURYVG41NnlZT3RCeEZ4eVND?=
 =?utf-8?B?emxTc0N3QjdGalRiaWpzNUtuS2RyVDZGRlduWUFkWUxwQk1YeUxialU0QWhQ?=
 =?utf-8?B?MDBwc21OZm5RV0tqcTVzcGJmMVloZjZkNllyK01qeUk2QWR4Sm9ZYjZDVlRV?=
 =?utf-8?B?RGNFOGZHQ3BkRUJ5Wm5adFdSajZCKzFLL200ZmI3NzBGaUJBWXJNTGNDTnVZ?=
 =?utf-8?B?N1YxLytSRmx4UWdIN1ZFeC9Ycy9JZ1FMVUpieEQzT2xVREN1TnpJbnlOeHNR?=
 =?utf-8?B?OVhCeVpuODNUWjY5NXlqWlJhQVNSS2pVaVpkRmNyd2NhK2FOVW5lOEw2TXp4?=
 =?utf-8?B?aUR0Q1JhV2lwTHY5OHpNY2tlamh1V2YzWCsvQzQ5R1pENjd5QXNxa3QrZnlS?=
 =?utf-8?B?TlJtcGJuL2sxdVhISnpBQmJ6QnhNeDJxK2NHQU5kbVpWaHRMU0x0L1JtZ3lH?=
 =?utf-8?B?bkJjeWYxTHgvd2tUTWk3UXowOFlFVnNpbUNVY2p0Ykw2K2hyTC9HbE1HTGV4?=
 =?utf-8?B?YmNZdjJqWmFuTjN6WTRKc1JTNU1iWmVVb1pHdzFZVkhxOVJEdGlWUzRJMmN5?=
 =?utf-8?B?QXZubkhpeE41UkQwd0UzSVlzZnM0TjZCaVNPeGJUakNwUnc4R2EzVkp4b3Fa?=
 =?utf-8?B?NURFRElDa3JNWXh0c1BUK3l4WEVEbmluK1dJanVmRWpKQTdaVXdvbUgwN1VP?=
 =?utf-8?B?c3QwNldJcDR5WEJvN0dRVndpVlhKOWpZK1JwR0c3aFlvS1I1SHlvZlJjNWRh?=
 =?utf-8?B?aE5EVXRIV1hKZ09lc0NGVmlpNWNVRkJpbmh2TGNYcEpLbVBBbU52bVk1dXk5?=
 =?utf-8?B?SVI4VEt5V2lZanFhVllvcHR3MTlaS090Zklud1ZjUEx6VXdMamdWYW9OZVpl?=
 =?utf-8?B?V3EwT2Q4R1pBYy9hL1FHbkYxcG95K1BYd3EycCtsTmp2OGs5dmt6Qkd0ZEtS?=
 =?utf-8?B?b25wWCtyWjVlcnB1VkpWNDFMMDU3NVBCa2xqOFEyMDBEQVA0WHZkUlNhY2Zi?=
 =?utf-8?B?dWFJaS9SKy9kRVdRd2IyQTJObks2OHg4Z3B0RXpPMmp6VElDby9VR05WSGQy?=
 =?utf-8?B?VVhpZi9FMDd6c05qWDcrUHN0S29vTDI5cWlkOWw4eWtWRjVpRnJNbHBwNyt0?=
 =?utf-8?B?VVFDZUVWWHNpNGNDY3JEK1VXdnVoY1gwSzMzVE9FdXBjQlZQNkVYWnZSa2dM?=
 =?utf-8?B?VDRtSUpFbldBczMvb3pEbGhvcm9qeVUvZGFKNnpoWURiWUlLaVRwMDg0UDhw?=
 =?utf-8?B?aHZQUzdpbkZva2E0RHpQNWpKYzN2aTJvUDhqc0V4RFNnd0o4bGl0cmptR0lu?=
 =?utf-8?B?ZW94ejUvMlkxbTJEV1dxSjM2Y0F5NkVSdjNQaFRtWW5WQlVjMmgxdG5OaUJN?=
 =?utf-8?B?WGtHNTduaDVTWk5Td0VSL3dLZDdzZjg1Zkx1ZDYwUlVodnVrMEZlbnZFakJk?=
 =?utf-8?B?NzVSQS9IZnBYZTNXSnp6SG8xdWVoNWk1eHI3UmJvV2xLNzd0VHFiQUZpbkRD?=
 =?utf-8?B?MnlvSzduL3NWZU5SNkxyMDR4Y1JWdWZRcFJVcDEzZnlLRzNFMWtQNzhYM0ZX?=
 =?utf-8?B?MExoQWJOMXN6eUhRUit0VXEvWmZBRTRRSlpFK2hZU1I3bWVoUjlLamprUTBI?=
 =?utf-8?B?T1doT2oyK1BWVmVZS1E3SlU5V0pOSWg1MmdPSzZVdEZlMTFTUUc0S0Y1dWdR?=
 =?utf-8?B?K0dkdmUxbTVoMDZXMHJnZUVreFhTbTRwK1M5YndQRTIwelJ1dTRuMzJMUnM3?=
 =?utf-8?B?cWl6YWRMb3dDRWtBRlQ0OVdRYndxSkVDYUZOTHBaRGNYUHJUUXVnRFAvZjZC?=
 =?utf-8?B?WTU5dzBWaXZmQnBHYmMzdFFSa21vOHBjWFB6K2R2R1c0bmxsMUhveDZQTUtt?=
 =?utf-8?B?a1ZhODhMTHpDcWRhNnpMakFvczhWOUtPWm40UkNHejEvbm9YT1o4MkRaMUxZ?=
 =?utf-8?B?YVZvbXhxUjNFUmlvcEtlWDlncEZ1NUJueHAxdUEzbSsrcUVpbWphb2c2aUxF?=
 =?utf-8?B?N3lDNWdoZEphaGk3eWhRdXlkdk9zNmJaTytEUzdsZUdaSjY3NisxeC9BbEpv?=
 =?utf-8?B?b0xueUZuSVRYK1MyalhoK0ppLzBBMEJBNXRUUDFJaHFmeUNvYUV5N1gwUERJ?=
 =?utf-8?B?aExxWHVCREppVVJNZGtxdlhTS0tvZkNvMk1jVDJXZmFZbko3SWY0T2F1dVgr?=
 =?utf-8?B?RVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gn20GJfsMXxL5LhelLejIVrv44TfKpLb1CnI5hTJd23vxJgCY8tr2TcBJZ5McBOQAyGCamrqCYZvFnjcr3+YtO2BCYwQ9MrVztO9l7KwCVjUKEQ59HlB9RBo0hi1XI6Nr9y3dr1jTye211Q4xgAVZSbtlfvj/KLPfZfaQBFLzRwYcVl2HF5WKYO4vcI6wiqtFokvDbEj9E9KR73C+PjCFnSb1OIh9yNbP1Z2uYUwOysQzDiMb9NnmAWldIjbY9wRAzAJcxfevCGEwbfOkpnEWEenuNGE08HzpzNQsjs7AqCCWnSf97l4CNG45XQJg6i5fi0CbhyD6ZJkcX/DYx9L/JdFaBNJTycZceWeQpikcGmZKeZFgAyjFJTdjdb6e2wIH0o/sSYKxwQGiQ7WJRG9g+G3W97f3vwADzpB4Lv4yWdoTWSamFCEQoHZ2c/5fca7xc04cLz+40Rsecro0APSlnm1+QtYMpvGRPU9mZEzcPJKgBjM2tcj3AQFVTje7Ltgv+b4P+ZxnxagCdDW1U9t/Z8B8QnAV68y886ijUmQzmG2ZP6zXqtKcSnPIDFC0+VOzeRGSnEJd72lIRvRN+Qz5kwqWYZS4nGajfAm8DH78jQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5e806df-fc4a-4352-e66e-08dd15d7eee7
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3366.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2024 09:25:32.8146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A86CdD2eGkUi82/XUSXmavibY7ZPLdsmovght/DYYHvxJusd29EBEcOTmsXJ9K7tHGUeYZ3yoJSytWjk/XyTLlvUOdlqDv3yuQhHKD7ZUrs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7346
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-06_04,2024-12-05_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412060067
X-Proofpoint-ORIG-GUID: WRKPFCkoF5PhJaeGObAl6Bqxl-3sW348
X-Proofpoint-GUID: WRKPFCkoF5PhJaeGObAl6Bqxl-3sW348

To be clear - I'm not accepting the export of __get_unmapped_area() so if
you depend on this for this approach, you can't take this approach.

It's an internal implementation detail. That you choose to make your
filesystem possibly a module doesn't mean that mm is required to export
internal impl details to you. Sorry.

To rescind this would require a very strong argument, you have not provided
it.

On Fri, Dec 06, 2024 at 11:35:08AM +0800, Jinjiang Tu wrote:
>
> 在 2024/12/5 23:04, Lorenzo Stoakes 写道:
> > + Matthew for large folio aspect
> >
> > On Thu, Dec 05, 2024 at 10:30:38PM +0800, Jinjiang Tu wrote:
> > > During our tests in containers, there is a read-only file (i.e., shared
> > > libraies) in the overlayfs filesystem, and the underlying filesystem is
> > > ext4, which supports large folio. We mmap the file with PROT_READ prot,
> > > and then call madvise(MADV_COLLAPSE) for it. However, the madvise call
> > > fails and returns EINVAL.
> > >
> > > The reason is that the mapping address isn't aligned to PMD size. Since
> > > overlayfs doesn't support large folio, __get_unmapped_area() doesn't call
> > > thp_get_unmapped_area() to get a THP aligned address.
> > >
> > > To fix it, call get_unmapped_area() with the realfile.
> > Isn't the correct solution to get overlayfs to support large folios?
> >
> > > Besides, since overlayfs may be built with CONFIG_OVERLAY_FS=m, we should
> > > export get_unmapped_area().
> > Yeah, not in favour of this at all. This is an internal implementation
> > detail. It seems like you're trying to hack your way into avoiding
> > providing support for large folios and to hand it off to the underlying
> > file system.
> >
> > Again, why don't you just support large folios in overlayfs?
> >
> > Literally no other file system or driver appears to make use of this
> > directly in this manner.
> >
> > And there's absolutely no way this should be exported non-GPL as if it were
> > unavoidable core functionality that everyone needs. Only you seem to...
> >
> > > Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> > > ---
> > >   fs/overlayfs/file.c | 20 ++++++++++++++++++++
> > >   mm/mmap.c           |  1 +
> > >   2 files changed, 21 insertions(+)
> > >
> > > diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> > > index 969b458100fe..d0dcf675ebe8 100644
> > > --- a/fs/overlayfs/file.c
> > > +++ b/fs/overlayfs/file.c
> > > @@ -653,6 +653,25 @@ static int ovl_flush(struct file *file, fl_owner_t id)
> > >   	return err;
> > >   }
> > >
> > > +static unsigned long ovl_get_unmapped_area(struct file *file,
> > > +		unsigned long addr, unsigned long len, unsigned long pgoff,
> > > +		unsigned long flags)
> > > +{
> > > +	struct file *realfile;
> > > +	const struct cred *old_cred;
> > > +	unsigned long ret;
> > > +
> > > +	realfile = ovl_real_file(file);
> > > +	if (IS_ERR(realfile))
> > > +		return PTR_ERR(realfile);
> > > +
> > > +	old_cred = ovl_override_creds(file_inode(file)->i_sb);
> > > +	ret = get_unmapped_area(realfile, addr, len, pgoff, flags);
> > > +	ovl_revert_creds(old_cred);
> > Why are you overriding credentials, then reinstating them here? That
> > seems... iffy? I knew nothing about overlayfs so this may just be a
> > misunderstanding...
>
> I refer to other file operations in overlayfs (i.e., ovl_fallocate, backing_file_mmap).
> Since get_unmapped_area() has security related operations (e.g., security_mmap_addr()),
> We should call it with the cred of the underlying file.
>
> >
> > > +
> > > +	return ret;
> > > +}
> > > +
> > >   const struct file_operations ovl_file_operations = {
> > >   	.open		= ovl_open,
> > >   	.release	= ovl_release,
> > > @@ -661,6 +680,7 @@ const struct file_operations ovl_file_operations = {
> > >   	.write_iter	= ovl_write_iter,
> > >   	.fsync		= ovl_fsync,
> > >   	.mmap		= ovl_mmap,
> > > +	.get_unmapped_area = ovl_get_unmapped_area,
> > >   	.fallocate	= ovl_fallocate,
> > >   	.fadvise	= ovl_fadvise,
> > >   	.flush		= ovl_flush,
> > > diff --git a/mm/mmap.c b/mm/mmap.c
> > > index 16f8e8be01f8..60eb1ff7c9a8 100644
> > > --- a/mm/mmap.c
> > > +++ b/mm/mmap.c
> > > @@ -913,6 +913,7 @@ __get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
> > >   	error = security_mmap_addr(addr);
> > >   	return error ? error : addr;
> > >   }
> > > +EXPORT_SYMBOL(__get_unmapped_area);
> > We'll need a VERY good reason to export this internal implementation
> > detail, and if that were provided we'd need a VERY good reason for it not
> > to be GPL.
> >
> > This just seems to be a cheap way of invoking (),
> > maybe, if it is being used by the underlying file system.
>
> But the underlying file system may not support large folio. In this case,
> the mmap address doesn't need to be aligned with THP size.

But it'd not cause any problems to just do that anyway right? I don't think
many people think 'oh no I have a PMD aligned mapping now what will I do'?

Again - the right solution here is to handle large folios in overlayfs as
far as I can tell.

In any case as per the above, we're just not exporting
__get_unmapped_area(), sorry.

>
> >
> > And again... why not just add large folio support? We can't just take a
> > hack here.
> >
> > >   unsigned long
> > >   mm_get_unmapped_area(struct mm_struct *mm, struct file *file,
> > > --
> > > 2.34.1
> > >
