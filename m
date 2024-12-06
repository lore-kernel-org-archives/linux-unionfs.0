Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753951FF7A1
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Dec 2024 11:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733486064; cv=fail; b=riApHkoKqa9X67xYZMTXPGrZdLXmWbc9lrR/sj1svyIMizjOC6Du1/K9aamWl4drjrrgdwk77y7TJe0vSiTUyqHv6NBoMuCSVLfmqAhvBlkLegcRKm0TCIPx5r/O09wkaEBIECkZObM0PlNbxWiYqxgvl2qgpWJZMg0TQ54KYAc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733486064; c=relaxed/simple;
	bh=dbf3DWKGVHVI3hfTR6s/uDzkMNPJkT5M6I/iaTSVZds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cgfILvF5sVxSRbphBL9glwDOpY5ahT2JFL28ExQrfmV5GsKDMBKX8eWu7w+FwutPAT3fjimYxWDmGL1ZNPj7/+xAq48xW7h1S1fz0tJ43DH45HL7Ki/+IH3uCM6ouIPHcrIZS91VPwe3Qi8d5qpZ8+tFcYuDgkzR3iVCS2xZvts=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Js+FCyJj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KpNCTdUi; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Js+FCyJj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KpNCTdUi"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B66s1E2024108;
	Fri, 6 Dec 2024 11:53:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=bOSedgFw8G7QkjKBJs
	ek9lJIel+CX4PG5n6tcbvvlnU=; b=Js+FCyJjTHzl6X4Bbbq0jtSpkA7HuP90TZ
	vyclDhnDAf5TyD3iHsySd7PHIbj2o4ogx88aG0pQzTFvRMGBAiZ7oDvx/G+aVf+I
	hgGytomesFv5DgG4ir6KyURc+ZjvoX0LjC9HODjicxKK+elYn9EpPo7DJOD+01uU
	0m5icNOypkn+xjZQGOniKK8l6TLnCzHu/BWCkgwTYRVAJTqPy6HY9lNbnvQbYnL8
	rfcQprYsSUHAHgNIR4+5D9rQydMzohb63+/COhIi6qnL0iWUxvXRTp9a6JwYuPnB
	cahHPUPeb8LGOH3r57lNpFlqNbpnim3dp/VZEMo53oTSMYnXdN+g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437s4cd69q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Dec 2024 11:53:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B6A19gL036915;
	Fri, 6 Dec 2024 11:53:54 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2043.outbound.protection.outlook.com [104.47.57.43])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 437s5cr7ex-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Dec 2024 11:53:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sxKWFBZEwpeAWWS5aAr+CfP9HSuekRdDQX1hPJi8YGOtNfoCXOCudPkGXCnXefuvH/75RzNpY2BzXzW2NcCYdYOW1tWjyDcSOLfRNxe80+ecJnbNJ/9F0XmEpyE43A7nThS3wu+5O5Dv0PCqk4H3roJ1/FJ2HFuc6CZWW5U3Yp5DQ/HFAhSqUmnguJ94HJ4bNJuTQf+DTpNbwy7nj3kPLm1PTv32/T1ngwIp/Y8RHGNMumO9iDZY1DGfMkZArTa4OfPHU61RoqjjtymUMO4jF3V7ASct2MmfviqKLRXyu0KNQaX5TriaTreIxjNx1imBqTF3joOowFKWdj4xkdi9ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bOSedgFw8G7QkjKBJsek9lJIel+CX4PG5n6tcbvvlnU=;
 b=nF/Zit2sDqH0FC4hmcIO+HXGJJG+Jgimc9MrG87nwvB568/qhOBMedYzbqsFqrzZzLFNKmU2BuB+hwdPEMWs1jajTT4H9hh8LiFvrXv/f2LyVc2wuVC/x++nreyZvdMwtlfY4KlM147iqUAmWXO/lVvYx0suJjNz6V7kub2SiVcguD5vm9GyNwb412gIVsZl2KlpiFaTZRmPkbBP1NvZRDhed5sn/bDIGuM0mnZdDpBkLlaUOGWcXPkvVtvasFZzxENpMNPDoh8guAPv5FXWeVsH7XdJDae/+hjUeHA4DHUIN6tsj2zu5ZT0oCkIuyA/SzgX2W7i/IGxD9MB+xg4PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bOSedgFw8G7QkjKBJsek9lJIel+CX4PG5n6tcbvvlnU=;
 b=KpNCTdUioacAkgQsWBxFd1vzSGtH9g5IofqUqE+2k76MH5BzRfT4ZbGNvyQ52YgoUFl5LD1g2ThL5f00TG+eykyBxJfRam2cka/0wrtgmJHXnqhtodOcBZNOdvdb0jP39pRGSkCm3QMOo6n585/s7W5e28PQsz+2e2oJtsOsUkk=
Received: from BYAPR10MB3366.namprd10.prod.outlook.com (2603:10b6:a03:14f::25)
 by IA1PR10MB7358.namprd10.prod.outlook.com (2603:10b6:208:3fa::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.11; Fri, 6 Dec
 2024 11:53:51 +0000
Received: from BYAPR10MB3366.namprd10.prod.outlook.com
 ([fe80::baf2:dff1:d471:1c9]) by BYAPR10MB3366.namprd10.prod.outlook.com
 ([fe80::baf2:dff1:d471:1c9%7]) with mapi id 15.20.8230.010; Fri, 6 Dec 2024
 11:53:51 +0000
Date: Fri, 6 Dec 2024 11:53:47 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Jinjiang Tu <tujinjiang@huawei.com>, miklos@szeredi.hu, amir73il@gmail.com,
        akpm@linux-foundation.org, vbabka@suse.cz, jannh@google.com,
        linux-mm@kvack.org, linux-unionfs@vger.kernel.org,
        sunnanyong@huawei.com, yi.zhang@huawei.com,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH -next] ovl: respect underlying filesystem's
 get_unmapped_area()
Message-ID: <a101ce9b-9789-4883-a232-056330642fd8@lucifer.local>
References: <20241205143038.3260233-1-tujinjiang@huawei.com>
 <69b72e3d-b101-4641-9ce5-51346c93a98d@lucifer.local>
 <041dcc1a-0630-27b9-661b-8c64a3775426@huawei.com>
 <a39ef271-dc1b-4f61-ba01-dde5b127bef2@lucifer.local>
 <f2668332-78ac-4dc1-abcc-440e38964ccc@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2668332-78ac-4dc1-abcc-440e38964ccc@huawei.com>
X-ClientProxiedBy: LO4P123CA0132.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::11) To BYAPR10MB3366.namprd10.prod.outlook.com
 (2603:10b6:a03:14f::25)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB3366:EE_|IA1PR10MB7358:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b1fe651-71fd-4a3f-8f9a-08dd15eca657
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QLJ7nasKeHteIJfunN9ymoY5Fd8hXMzfC96+lG+og6MaNHkQasVmA3AdVP1Y?=
 =?us-ascii?Q?T660UnuqT9uddenr361mpa5j579G0l0sKPP/9UKE2lI+gDWO5Qa9Vf2851MP?=
 =?us-ascii?Q?yY5QquV/vFA2E5auJo2Rc/MMhwBUuA3ABgKRUYFSrOW4mw3H4t0ql+Fw1gDK?=
 =?us-ascii?Q?q8JRypQcK6M6Kcbnnez909TeU8SYrwapHb4Juyn1r2DY6ZgfvyJtysHHEW+I?=
 =?us-ascii?Q?Sv/THb1oTNJ69E+fahEsCL85ZHqDGF50gjvxPtzbtBXvodmPDd3H/tuKY8/e?=
 =?us-ascii?Q?jxq0ZS+YhXgWs62XRKI1186qtZKxBVJj4zhYobOuFzyiuw0DDtLw9gfYufLp?=
 =?us-ascii?Q?2XJLxv7T6PTQruIKpGddVVE7/56SV4JTGwPbygf0gyUetz0dpGh23Phgxtw/?=
 =?us-ascii?Q?n3T7i/XDlp48/x6BlZoMrd+icMG2fAArYYFM+Q/XiQ3T02iUxWJl/zllN53f?=
 =?us-ascii?Q?/TX2BTh891bmcR9Q8xoYZx7qPqP5CBEE0JXWP8w40JRouy8SgZLn9mHkiZrD?=
 =?us-ascii?Q?bLxtpDzJ+O0W8I8mNivurA8ztmiZqZyE36Fs9mMzE2iwKFxia8B5dKNlvcT7?=
 =?us-ascii?Q?Xjo8XholzSUJPnscRlKR3JI3fdUJFn22Gtt714zHjLFq26uvP9bbe5EPXbPd?=
 =?us-ascii?Q?YK15cxLKRTW3mfvh/Ww5/x5rSZEi/TBbYBtwthPvW7g++zATUeidwKykzdA3?=
 =?us-ascii?Q?DSxRmLB8r7LOspN4r18Mu6NDpsnC1jH0iinGR2AqOj1B+0fEBCNEeYHDfotc?=
 =?us-ascii?Q?GypaTrIEw0UBvneE3NF6Pcz4nRI1VffO1onk7Y10uag23apu/T2R3qlUlmh7?=
 =?us-ascii?Q?3KfJXVJbgA73+LPzo7fXbqtQwwNkw8OEdt1oA6PdbQt64vvUr9JGynEr3Qst?=
 =?us-ascii?Q?1Dd2JAsojfaMW3p/UN5llEdUKpPwShry78oYb0iCGQ3FzhDgkbOF2F/5Z+3/?=
 =?us-ascii?Q?574HFWCVebsQX7mYdwoW5NdWxbQZ3ELWalL8yeFVE5DQ4ZRZLMNvJc11Zs45?=
 =?us-ascii?Q?Kx6UhU+efEB55OJaQBy54dRblbQ2ZZEtlwWIEY1AqD/+xiNVkdyGmxPzwNqI?=
 =?us-ascii?Q?yaT8wzZisBFqFGxPZqLhPQcJEcasDdfSGlmITYOzvbjCVvZw3WLwQlSVFFQL?=
 =?us-ascii?Q?OQcwkWaIF2wGMp5UNx8i6e3cNOXJlB0f5hn54gE36vV/rsmp79PB6zr6gwL9?=
 =?us-ascii?Q?e/B5GHwW42w/OQefJCGW7250Sz7tDjgtIK+cE///MrvZ8aCm54+qKYCw84B4?=
 =?us-ascii?Q?h2wSs05JLpTef2n1GNPJWSpRZn5C3BVFDAeGrFFeB4T15uex5hL0SzAU3J5J?=
 =?us-ascii?Q?E9g2T98c/mnMSfO3LwOq3r9ekdvta1ggKqGyf8f+96TSlg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3366.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oZiFBpGD+hyCNW5UDYVccdPJd8PQ0vWM+PPYVfNoNFqt64za1zk/64ex/yYa?=
 =?us-ascii?Q?E5RKnsQ8hdGonBvHd1THMhXllRR6F2wmPobmWvRRM5mnaHH6jPYwaryBrAMW?=
 =?us-ascii?Q?dTAsV/CLjGaK81Y26dAA5DJgK2hrLxtP8/IZ8hv0Qqvz2wjw4BMbtHaBweCH?=
 =?us-ascii?Q?qErG9hAHjf6msGQ1kF59VG+It0WB0tSB/Uu4EyQF54AsCKkMGL4QxmZtURy2?=
 =?us-ascii?Q?tmF+34gLEpJFjNKjnpW2k3X8wlnXV9IDZD3iFBZm865uuvB4/b+5RWLh1gPF?=
 =?us-ascii?Q?cA+IgYd1RZJcLfx153x3C8yFbZDhYVIl24Z2zioBa3+ARTH9GZh26yTZzL1j?=
 =?us-ascii?Q?Y2gdLmJ6lbCaiuGwwKYF9i/XGo20SYXQRaBaBj5Z5AqnoNBY7zMt9zhsKbCz?=
 =?us-ascii?Q?lr5kYsrzyQajMozfd5CIv9SJY+RcJe6djBf+O3vmcW20QfCW0FUhBzNbTw+1?=
 =?us-ascii?Q?56C3XYsla5Q0Vkj/8fAzBwFQE7HENM+Rb1wilHQjgKxXLoKpjnBrtFX2A5XV?=
 =?us-ascii?Q?w4We3J+HOW53K6BjHe8O+U8wOUmEDDU8dRoZqUFZp3qGT6MCQm3Hgmn9RNYd?=
 =?us-ascii?Q?xXAj2uk9NwpzZYFvsNaqF42TAt39KwrDg6N+129uWRml0H2Kxa2rQTemqDfY?=
 =?us-ascii?Q?oCx9OPrL7i9MgbS6SyaqQ/XmjTdINUPlLT9ASJ3gPxrVYjsLsIEvj+agpqY+?=
 =?us-ascii?Q?vtlUAvuWauJYyrLuC69K0en9jFiRZ5QWS2WLPGJj9hnIjybuQzeeS1t5Wsxt?=
 =?us-ascii?Q?qLknWzdv3DOaQy5hdu0hhQDdc1mfJk4MkjDoJijCcP5FZfi79/8F57fvxVnF?=
 =?us-ascii?Q?iebiCZCpRCMBDCwn00rWQeSdBiFmueizv7UbcyDXrUWmuGHntFK65G/ivfVo?=
 =?us-ascii?Q?YyIWzUa6qD0X6mjm8JUQ/Ssljs5XqG0mvSGRtSYVltIR1q3OokCBmIFH830n?=
 =?us-ascii?Q?iWELOLB60tLcb8n6ppDefTAxAsKbjAswE9dt00Dw49aHsxm02yMXTac9B9k9?=
 =?us-ascii?Q?KfJfajzGuJ7o6QZHkrqxfNd7Pe3yoqie3wXV3Yo9UguGXLG3ZIcxUWBORdVi?=
 =?us-ascii?Q?q8mb/H5ChB/Hspm2P4961MExRL/acXXRRN9W5hVhpn/m/dU4ChOoveQf0UfY?=
 =?us-ascii?Q?KXr4bG2zWiNoOeKhg4C4C8u27vrGQVlQ6QnLFeMp3fnb+eXOjCiSsYU0JQ1r?=
 =?us-ascii?Q?8MulVOOMqhPyAe8HHIzpF4WAMdzjHqQrFoqfDNAivdFOpnzl47jA2o8wcEgu?=
 =?us-ascii?Q?rfKlVKNyXlQbc2V7JaA5ot9X6mQsinkQGKwrvsTIacWVDDhiZSa83bKdIMIf?=
 =?us-ascii?Q?hUKgIOrFJ25fNbL6g0YonMT2MteV/1ALHuo1rIwvBMJxbkoN8t801gusdthO?=
 =?us-ascii?Q?v4xHSxp0zlJdh5wlB4AzmDywg179pW4pDKrgp7K/Ia1NCz5lPBpLfO8gbgaC?=
 =?us-ascii?Q?SJMNNCs1BAvnJZgVHIQ4BT+Db/XTggHnXKPwQAWDoUZjObm6XA6S3mNAYURJ?=
 =?us-ascii?Q?Xy48HPpoSQ9FTQLojkUgZUoR8iv6g9dvIVrqQh4SDw/OLKJLN4E+i06pdyLd?=
 =?us-ascii?Q?PTFlajrYn74gMZjwerXpu6Uv5yzLy7O/9wCelwr17fvMrUmTJeQa40TE1jy1?=
 =?us-ascii?Q?Vg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0TgsJIvgYXgb3zs30EKJVP1EFp/OdGZ8ko/5CGpottmZac6CrVVyl8kwNNzBeKkzpnYIb1Sa2RFt3xAkDTZMuaAGDTnK4b3ywkzljP2fDTPAkILlKde8azjYY6BVlGThgUyM/UY1WQJGo7UMvHeq5CS+ucKTYpNYCGNMAwmtkdxSujhCwYYVdkNCdrtSoTmRWs1hx7zzdx3Colbk6hnUmN2oTV428WBWPzvAFH5pP67s4bL2uKls2YieltmR0i4UEDBzBVcjdW2dmxKjOg4YtGYvWEYqCkQinaz3aiN5tyft+DA3q6CDdvxMY2ztQJnYIvTJROqGsflzUNGwfGkR7OuaqOJEemyRIF562ZO+N5CR9iKffkuDoCT1OaRoeq/nBF09dHEoI4/eIiRQK52eJfMKGla6czncE5h+SfsamewHkeJQxWNiGzw3CiP0Kvv/o1ATFK8dmhUAYv0TJpJH0id9xCVm/H5EqUY5ZUHlIS96WkgRLQnW+W0auorcIx+ipNaXasd2nqLBgSQ3k8SNjc9nY13oCTIH/LuQ0ogeI83H+iVmCARCNz4U8fwmdP1aS57BNBtuRTOBWcg6rj/DL46HJRIeMyj5NI76mgY44FA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b1fe651-71fd-4a3f-8f9a-08dd15eca657
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3366.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2024 11:53:51.0106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jen0t/7sD53rRsqIKvtYJQlmNBXlT8UHZYD7Vg8xPjB6895n7/FfZbt5qT1Lotm8fYmaVI+mBqrpyV2wO+hssbXJatk6zkxv9FdfVsuxw4o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7358
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-06_07,2024-12-05_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412060088
X-Proofpoint-ORIG-GUID: ghnUS3G4IvLXr0JQDwuEFf1Z186FosTz
X-Proofpoint-GUID: ghnUS3G4IvLXr0JQDwuEFf1Z186FosTz

On Fri, Dec 06, 2024 at 06:45:11PM +0800, Kefeng Wang wrote:
> So maybe use mm_get_unmapped_area() instead of __get_unmapped_area(),
> something like below,
>
> +static unsigned long ovl_get_unmapped_area(struct file *file,
> +               unsigned long addr, unsigned long len, unsigned long pgoff,
> +               unsigned long flags)
> +{
> +       struct file *realfile;
> +       const struct cred *old_cred;
> +
> +       realfile = ovl_real_file(file);
> +       if (IS_ERR(realfile))
> +               return PTR_ERR(realfile);
> +
> +       if (realfile->f_op->get_unmapped_area) {
> +               unsigned long ret;
> +
> +               old_cred = ovl_override_creds(file_inode(file)->i_sb);
> +               ret = realfile->f_op->get_unmapped_area(realfile, addr, len,
> +                                                       pgoff, flags);
> +               ovl_revert_creds(old_cred);

Credentials stuff necessary now you're not having security_mmap_addr()
called etc.?

> +
> +               if (ret)
> +                       return ret;

Surely you'd unconditionally return in this case? I don't think there's any case
where you'd want to fall through.

> +       }
> +
> +       return mm_get_unmapped_area(current->mm, file, addr, len, pgoff,
> flags);
> +}
>
> Correct me If I'm wrong.
>
> Thanks.
>

I mean this doesn't export anything we don't want exported so this is fine
from that perspective :)

And I guess in principle this is OK in that __get_unmapped_area() would be
invoked on the overlay file, will do the required arch_mmap_check(), then
will invoke your overlay handler.

I did think of suggesting invoking the f_op directly, but it feels icky
vs. just supporting large folios.

But actually... hm I realise I overlooked the fact that underlying _files_
will always provide a large folio-aware handler.

I'm guessing you can't use overlayfs somehow with a MAP_ANON | MAP_SHARED
mapping or similar, thinking of:

	if (file) {
		...
	} else if (flags & MAP_SHARED) {
		/*
		 * mmap_region() will call shmem_zero_setup() to create a file,
		 * so use shmem's get_unmapped_area in case it can be huge.
		 */
		get_area = shmem_get_unmapped_area;
	}

But surely actually any case that works with overlayfs will have a file and
so... yeah.

Hm, I actually think this should work.

Can you make sure to do some pretty thorough testing on this just to make
sure you're not hitting on any weirdness?
