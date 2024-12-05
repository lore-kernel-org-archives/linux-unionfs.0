Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB430218AA2
	for <linux-unionfs@vger.kernel.org>; Thu,  5 Dec 2024 15:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733412287; cv=fail; b=TesdZbb3uXd1gflzQQM3r5lIM9GGrc++eznVLm1vM74WPSRE5qfK2+IL59n8rPA6DII7xJQysO+OlZiJYu6cheUxe9SlmGJ6svlDN18U62H5LYm/d2c3BMGgLzyVO9JP9LqS2nbr/81s7+DHHEmZTGgliGIWg76kMuQrYSa0bzI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733412287; c=relaxed/simple;
	bh=nsGA+nn/kJe7iVNuZAYLLV3quscdUcFinnWBrutXwRI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=K5RqR+JJE7IweEzbzYVeQxz0GSzv7pdBB/fQ3vODjR7NSCbAPppb9FK5SWa4eqo29ggmtbxQARec7L2+qNqJ83BsM1IbbdPWBgdaeFUpTKam0rTHYqLzEdFeIz+kgIDppeC5zXZmwz1MUxRchXqz2Q/PLOIMOyrzf5WlkUWp1wM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=g9sUgdYP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TIZqYrqQ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g9sUgdYP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TIZqYrqQ"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B5DfuFd010357;
	Thu, 5 Dec 2024 15:24:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=HSbhKY89O6ddJvGCCfGZp/JRvH4gbPrc65OGCtmdO+c=; b=
	g9sUgdYP9MtmHG2C8Sy740IG3SVJcQX+1N1OnfP57zxghT1JOvNuAlO2W3PFjUyp
	7OowAgEmDjPmQHiQHofVwzvgbTw5om6nv2xPDGrRnXQdMNz8WUmm+PprmoHV+JpI
	HweTkW5lM4blaXbLUNH9EiXoYM7b6yG5uja4ZKvFN8xfkmn25B/kbva2Z6qRE4ae
	j3ghoPHcUF3djj0eTd9vZLBewjp7hX5VaVz/GKnS1Omg5vZQvclkQVBwE/htPGeJ
	sy2S1JsZO79znpRR91gmKAzv3i+che0QIBCDRTF7a/HIZX+GPjoTN/0Vj1mJsyTG
	2vrivfg7ABof0yod0oDhcw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437smakdyk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Dec 2024 15:24:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B5FA0xI037022;
	Thu, 5 Dec 2024 15:24:25 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2045.outbound.protection.outlook.com [104.47.55.45])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 437s5bj6ey-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Dec 2024 15:24:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZrFGNiRUEaUR5cqQWEZTs2gGKUvPr/03ZyVULLI1Om8l/ObebkmmziIW3OTsgxaxn0HqYvMBz/FM/mw5YpESbpPMQtUTFWZEchHQ8jAX7Z+oMCAGcvxf7sEu8+dSNyudkP/TI7gwD3/kW6LAr/C6Ed4Zi9oQz7yBoR+h0uTUbysvZ1UTqsltnFvEpMZv0fM072SUXoiTbO+IzZlRlOU0YA/nWtPMA5245Kd6EgHBF3cDEepq0i9Av0u2ylQ9XVqQBCAZTbvyZN2ObFjD6OufDQPFa4ZM3E1vrSnCzwnQtKkwPK62oXn5aKajCwa30BvaDP1UFOijo7pR9fc1gLgBXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HSbhKY89O6ddJvGCCfGZp/JRvH4gbPrc65OGCtmdO+c=;
 b=kRVEZh3ZjxKfTYw93a5zldEH6O8GMnvfq/S/AWpAoNAHk0hNSWvkyDPS8UJSYgIjIoiNJAW3lIRP9U0Gx1PVwql+0/iEUJEo7wAl2K8Pp5B3W5DM4YRbidfDkJS87590hpTdBkDEF5/3DDr9YdV4z/ea42nDvq4hyffJJtpdXDQkINXBkOH4bt3lcjbzbsw6rG/+MzENsjOeTd6mmXFxo0yx7Nag7px7ceM4Xfv33Bo9NA9etSpeppjIpFJFc2BiBty2/t1r6HOa+J76w92zw2OwP5328e0tL8Qt1vBvaQYCpamuHCIpJOGhTR7h/6rMzStH/HyzzWkXU3IRZzjIQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HSbhKY89O6ddJvGCCfGZp/JRvH4gbPrc65OGCtmdO+c=;
 b=TIZqYrqQcTijAm4zSAATUO8lZ1TNVaHm/iEUMn+A0OK3MY4SNTcmckbCr0MXC62bVPLGzmbUjbm7MF+eLxUDI/Y0FKcXcp+xY1I18Mhqw+VivcNCQgS+RqosVSxg96AdGlB8fEs+T743Vr7B6d45WSReurSbvQYKeniEfyZLzF4=
Received: from BYAPR10MB3366.namprd10.prod.outlook.com (2603:10b6:a03:14f::25)
 by BN0PR10MB5063.namprd10.prod.outlook.com (2603:10b6:408:126::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.13; Thu, 5 Dec
 2024 15:24:22 +0000
Received: from BYAPR10MB3366.namprd10.prod.outlook.com
 ([fe80::baf2:dff1:d471:1c9]) by BYAPR10MB3366.namprd10.prod.outlook.com
 ([fe80::baf2:dff1:d471:1c9%7]) with mapi id 15.20.8230.010; Thu, 5 Dec 2024
 15:24:22 +0000
Date: Thu, 5 Dec 2024 15:24:18 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jinjiang Tu <tujinjiang@huawei.com>, miklos@szeredi.hu,
        akpm@linux-foundation.org, vbabka@suse.cz, jannh@google.com,
        linux-mm@kvack.org, linux-unionfs@vger.kernel.org,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com, yi.zhang@huawei.com,
        Matthew Wilcox <willy@infradead.org>,
        Liam Howlett <liam.howlett@oracle.com>
Subject: Re: [PATCH -next] ovl: respect underlying filesystem's
 get_unmapped_area()
Message-ID: <f773da0d-38df-43ad-86a9-6cba785d53a8@lucifer.local>
References: <20241205143038.3260233-1-tujinjiang@huawei.com>
 <69b72e3d-b101-4641-9ce5-51346c93a98d@lucifer.local>
 <CAOQ4uxjLZJXDm+7aiFsEtiUhvux5U=dftw7eNBpk55J6wW9XBw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxjLZJXDm+7aiFsEtiUhvux5U=dftw7eNBpk55J6wW9XBw@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0671.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:351::11) To BYAPR10MB3366.namprd10.prod.outlook.com
 (2603:10b6:a03:14f::25)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB3366:EE_|BN0PR10MB5063:EE_
X-MS-Office365-Filtering-Correlation-Id: e693bb02-25a0-412e-2e88-08dd1540e544
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YVlEbTZtcVJKWmErVFpEbjBFWUhxd1pDYVRaTFluRTF5Z1RtdDgwcW5GbnFB?=
 =?utf-8?B?QXVCVWg3TE5Ua3BSelBCeGxBNk5Ddm1ucmpWUC9CMHo0NGRwYVFCMWxYa1BV?=
 =?utf-8?B?b0pVdTdLc1pSWFF4U0R1RVVET1MwcktTWVlwVVQ5QnA3VFA5M1QwRWIxZVdU?=
 =?utf-8?B?V3RsM28zWnFUbmpoUU5HNU53YncwOFR3Ym4wUlg1VU5xc3NQUkFYaFVOUEtx?=
 =?utf-8?B?SnZmQlV3aXNVQmtkYnZ1c0lxZEZrVjYySHRqNmRXYTBlWldiMnNMZmcxdDNr?=
 =?utf-8?B?Uit0UUNkMUZzSHdOR0ZVYWYwYS9kL2dvVk9XM05wUW9zVDRPYlJLZnVpT2RZ?=
 =?utf-8?B?Sk56TDY1OFdadFBueU93RmxjQjRNdzhxbDNTWFkrUEZvams5cXJXV2dyZldL?=
 =?utf-8?B?VHdyQUtDMVBsWUk2cEJoQ21yY0VnTk5zc0dFUkIxZk1oc0dwMHdTWGJsS25a?=
 =?utf-8?B?M3AydVlZVlkrZmN0YXVNekp0M1QrYVBPVWQzWmIvbkthTE4xMklqS2ZsTUZX?=
 =?utf-8?B?STdUWmNiVmtKRlN1ZHR6akZaUnNrZzUxdW9raTBPODZJVk1ua1lVaHhsU0cy?=
 =?utf-8?B?bTdoUERkeUo2bHJJVG5FV05pWTZ2QTljYTJPL0xUK2g3Z1dHS0ZESzZkS2pK?=
 =?utf-8?B?bHptZmR0VHp4TzZUTjRjZkpSWE1nVE5scG1RZ0E5bGRWUkRiOC91ZTRpNTR1?=
 =?utf-8?B?RkNnZ2VXN0RzZGw3UXhweGFBcEpGcVA5dHROSXgycGhZdk1jN1ZBcThGc0pV?=
 =?utf-8?B?RlFLRnRxR1RGWVF4UFFIeXJPMGo5dnFudnhxRnhlbm53OWRkS2t1K1Z2cEoz?=
 =?utf-8?B?ZDRFQWZQQ2ZiU3MzMG1ORkdkbEd1TzF2NEE3L0ZNK3dYUXArdmhzRVFSMGUr?=
 =?utf-8?B?SGZtSkhURW11U3ZYNWt6SzlZTWQvcmhQTDd1VFcrL1FVRTZJcDJRUlQ2ZjJR?=
 =?utf-8?B?ZUFyT09yNlFOcWo5bEdpT0hLUDAwUkFzVWFFNklBcHdGcUtSczg5d2FGR2Yx?=
 =?utf-8?B?WHFEVVdOUEJ1R0cyallHNE13UUVQU0FiMTlDODRXM0RWcUg1TVllY1REU0xJ?=
 =?utf-8?B?V3MyMVRVVHBiSjZqQ1MzRkRvcUxCOEMrN29FOHJBcEFmTW00c00rWWZtUmVO?=
 =?utf-8?B?RXlwQ0dJRWozMXhTa0tMQU04dWRoY05aNVFMMUd3UHZRdzZBVml5UjJLT3hP?=
 =?utf-8?B?RVNlZ3lUMzFNWVRQMXl0anRwNFJYamEvbXRpV0hjUUV2OFVlWmtsSk9uYlJU?=
 =?utf-8?B?bFNISzAvVFFBdUJDZ2ZHNXNhRktJRnhxN0VlSVpUU3dERjF2UXZlMkdiZHFQ?=
 =?utf-8?B?U2VkZmcvcFpEUG1FMlBHdHp6NmN4VjN4aUZaOWh2M2R3ZVFkL2trZzBQejlS?=
 =?utf-8?B?RFN6ZHhtNEIrcmR3UThWeHQ1VjlWV0JXNU5UTEFySTE5eldqU1cxR21JYi9r?=
 =?utf-8?B?N2NyWk16RVR0bjZZUmZGZmVDL0docm5zc2wzd2NJb2RaOW8zeEZRRTJmMlRt?=
 =?utf-8?B?MmZEd1JoUUJBZjJLSEtuQnVGVS9mRUx0UXJicXQralA1OUF5a21zeEtlTWtT?=
 =?utf-8?B?blZqQTYrMGpTMnllWWloUGhhRkZ0WTRlMDhFT1RhQ0lEeVp4S2xxUVJXRHdv?=
 =?utf-8?B?MVNNckdkUlpCeXJIZEU5eVlQeGVnWWdVQlJyaktBbmhpcE9ucWpEVzV5dUhU?=
 =?utf-8?B?UG9FOXYrWWtSZ0gwanYvZi9IM2M2UDV2UFVwU01pbk5FSnY2SzZTRFhqbWZU?=
 =?utf-8?B?dkduV2xtUGZGenJrbHY1M1ZaZjlTQlJobEF5OW9oRTlBcUJuVVR3UlQvMkc4?=
 =?utf-8?B?RGZ0ZndFWk9reGRRdnFsdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3366.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZGhnZVNlcjcxYzlUbUVXd2ZDQ2VWWkJpb0J4TFRZL0dWM0xOWGJXTWFJcUY3?=
 =?utf-8?B?Rk5pdlZQeDZXTDduWWVJcFc3SnJpdmp1Um1aamhSTEFFanRhdkQ4aUNoV0F3?=
 =?utf-8?B?ZEpMd2V3MXpwMjFBeENSOW9HNWg5UUlaYXhuSGtHdXVXVnU1MFBHNHZ4Q25I?=
 =?utf-8?B?Y0FkYzBNckhjLzUvMDhXd2NBOWI2elVGRFJDWk1LcjNldjl4Tk5SdTNGZ1dT?=
 =?utf-8?B?Y1RRR1VoaW1RZGN3R0R3L0dYS1pzOE03dlQ3Q3BMV3d2QnpqbUM4Q3JJdTlT?=
 =?utf-8?B?eDBGUjhNcVVLcTQ5L1ByLzloYmZ0dnpyQ3Z2KzkrK1Biajk0Tmo2ZnlQSUYz?=
 =?utf-8?B?SnZKWS9HUElyeHJKZE1wWkF4d21NRlBTdDZPSWhneUlEUmVNYk5iVmlIWjcx?=
 =?utf-8?B?YUsyWGordHhFUEt4aDhaUUM3end3bjRSZGVadmdOdTVIeDcrUlJEYVZKOHB4?=
 =?utf-8?B?SmtuRGlod2VuYU50dFk1Q0NCdHpwVCtBL0NoMTNzd3FQTENNRi9aTWJPQXY1?=
 =?utf-8?B?amltU1FWVFRlOUlFSFJ1dmtPanl0VHV3Uk9Xc1VOS0lYU0NvelhCbTdxeFdz?=
 =?utf-8?B?ZXNPM0FmVnQ0d1RLa0pSb3ExRWtLWXJFZHNWaCtteFhFaWcrYjlrVGcrZUFT?=
 =?utf-8?B?QTNIRmpnTjZSeklqa0hid29nQ014NXBCTU5sdEpRWTBMa29qNDZreEpyWUgy?=
 =?utf-8?B?b0NGUFozWFlJV1M1VWNmb0hJUDMxUE5ZU2laQkp5STUyWW9VT09Wd3RDNVl6?=
 =?utf-8?B?MS9LTXU4TUFXVUUxMXJUUlczUHdyWkdPQ29VUTlabnlja1N6VzUvT0w3L3BW?=
 =?utf-8?B?ZVc1K1dlejYzamRFanBqbmg1WTZLUmtSUUxFYVdkK3p0N0psdHI4WmNySEI4?=
 =?utf-8?B?bDhqNHdtcm40UFNPUVNnbGI3TmpzUFRuS2VSS0lyN1ZUWEkxMTRTMmp5eTZ2?=
 =?utf-8?B?Znp2U3pkTlhsYTcvS3NNQWpZclovNEpMZ2hqc0lpckRCcytjekxIYnNER2JS?=
 =?utf-8?B?OEZqYXlnVTFEOGlVT0h6bXprKzJDdDRrem9lWTZMcTE2OW5XUngrMktLVVFG?=
 =?utf-8?B?OVFldURMVUZjNlZQRHdlNUdENmdvSERDS2lLeFFNbHpMNzQzNzdDT1QvMzRE?=
 =?utf-8?B?MHhYdUFaTG1DMWdJaWp5ZW1jdWZzUHM5VUU1K3U5ZElNbTI0S29oTHpRcXhm?=
 =?utf-8?B?RmxRTkREbG5KaU1pV3F4VjNIaFVXbTJLcW9jeWRyVDNxKzBxN0ZPVlVzbmFw?=
 =?utf-8?B?Vm9IdHdUbHpVSERpV1U2Q3pITTJ4eWJKMExrRS94YVphcGxTb2ZyNlpoWHdY?=
 =?utf-8?B?cC9qZlNHT0RnNkxqV25PMkxPQ1ZNOHc2ZmZYUVpWWlYyMGsrbm50NTVmU0Q1?=
 =?utf-8?B?OUN4cnJCaWRCS1RKVVQ4V1hucXZnYjRMajRhL1k0WEozZmdYY1VVYjNZKzBt?=
 =?utf-8?B?UTcwVFFvTTk3MWRORTVzMC9NZC94RnRwUUlGYWFra2ExejBSc2M4MzFHUjgr?=
 =?utf-8?B?a1kxenVjeGI3RUhwT3c2bzFsUVA2R3dlUXdiK1NNRFlEK01uQnNYUjI0SndK?=
 =?utf-8?B?WjE5T2xQZldQWjRkbFprUFVDNTlaNW4zUWdpM3BOWlcvVXR2QlZJWkFMQ09R?=
 =?utf-8?B?cjZrdmJXeGlPY1Z1Ym02R3lac0pxQ3FOTUxuekthb1ZRV3hLRHlLNERpeFBu?=
 =?utf-8?B?YUFsTDQ2c1AyaUk2OXhYdmdXdld5aTV4SFk1dVFtNVZKRFpvbjZveDB3SGRT?=
 =?utf-8?B?cElidE4rZ0NmdE5DeGl3Zk0rejZ1Sk5GbVdvTkVoMUVHWmFzeE5WTWh2Q2pY?=
 =?utf-8?B?UTBoQXlQMnhjZGsvMmNLRzM5VC9QdXNNOGhlNzFUb1Q2ZEZ3UFFFam9tUndr?=
 =?utf-8?B?WHhZQmZ0V2pJN1BYMnpyMkR0Z2E1VDByM2RxWldHUkgwZ2Y2SzJsNjJYYUpP?=
 =?utf-8?B?QmR1RXlycUVkbkNBOWhsOVpyQzBMb2NZNlR6c1lCNEJiK1hJc245SHlGQStP?=
 =?utf-8?B?R0lwb3BxU0pueHhRaXVNNkVsU25CTnFUNXdtWWh6aCtxV005S1ZzS2lXS29m?=
 =?utf-8?B?QzNmYUROb0JscUV4a0dRTTlCWDMyYm9EdGh6dFB2ME1JcHVVUldWTDZpanpl?=
 =?utf-8?B?Z2J1QjVFbWwvYmRZU0h2UUtDOWV2aTZVM1JBMk90TlplQXpyeWxYYVd6SlNa?=
 =?utf-8?B?UGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AUot4Gv6Ib5VNIkObrRoj8qbn6SrwBk/FkeZ1rz/yUBQMReGQIRNujPfRYPdJPe4sL5dNRIkG0akStQ7eW2dMzpCVBq/ZrGngzhptQ3xYPu6hDcTHAnwQW5B1LFxtqEY0Vmr4pqih0evEmJTeCsBKA56lBgGojeUN8v0ORY2SrndPfARWVTQSGIFK55UjB5S9pCHjyUhFPNR5/F3L0zAKsQj1vCJzJSxob99Ja8SpDLb/68fNpsGU6u897sCLo4Sl7PGM/uWULI169P2jSWs/yVD5DSHFQ+GwSruZoh5fQHr7l9RarjRSyg5LNXXwcyHmnbfbaeRLZePPhJYmckuAYLFtJk3kanqFDPPEYTrhY3wErn/rDym3Uk+J/TBK9ysyJ5NEjlBaiJ9mvoGWTPlRc3RaYxMXbvKI7XsntxSrrbcnYYZWu0QUIjyCGllzzvrgWB0jthf+DVLHiFlS8StKAR1lzSG8yGK3jMCpB8svq/3Dbzojzpj+6B1T2SGGbGNK3zWxrvUwxg9mjU+p95RJrKZc/d0D+Ieib6GgLMYVocSQyxrG0mI7puZ6Z0MctDMvWTiyhF+fMm0we4WCgWQB6oX/yEUmPbYRt85Jq0KgEw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e693bb02-25a0-412e-2e88-08dd1540e544
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3366.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2024 15:24:22.6355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zTU7lWzmlMLTiuvMNGebEfZcc2K+l3Tfe2r3vJvemg2phrh5AFJ0qRvL2HeMX+0ghIjgRbEcUTlvuuPKQD9Vl5Nt0V2bMkALc7l/mFGNe04=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5063
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-05_12,2024-12-05_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412050111
X-Proofpoint-ORIG-GUID: SXo1WTer_hRhxSgT6dGLtJtRH1yNMXGN
X-Proofpoint-GUID: SXo1WTer_hRhxSgT6dGLtJtRH1yNMXGN

(fixing typo in cc list: tujinjiang@huawe.com -> tujinjiang@huawei.com)

+ Liam

(JinJiang - you forgot to cc the correct maintainers, please ensure you run
scripts/get_maintainers.pl on files you change)

On Thu, Dec 05, 2024 at 04:12:12PM +0100, Amir Goldstein wrote:
> On Thu, Dec 5, 2024 at 4:04 PM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
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
> >
> > Isn't the correct solution to get overlayfs to support large folios?
> >
> > >
> > > Besides, since overlayfs may be built with CONFIG_OVERLAY_FS=m, we should
> > > export get_unmapped_area().
> >
> > Yeah, not in favour of this at all. This is an internal implementation
> > detail. It seems like you're trying to hack your way into avoiding
> > providing support for large folios and to hand it off to the underlying
> > file system.
> >
> > Again, why don't you just support large folios in overlayfs?
> >
>
> This whole discussion seems moot.
> overlayfs does not have address_space operations
> It does not have its own page cache.

And here we see my total lack of knowledge of overlayfs coming into play
here :) Thanks for pointing this out.

In that case, I object even further to the original of course...

>
> The file in  vma->vm_file is not an overlayfs file at all - it is the
> real (e.g. ext4) file
> when returning from ovl_mmap() => backing_file_mmap()
> so I have very little clue why the proposed solution even works,
> but it certainly does not look correct.

I think then Jinjiang in this cause you ought to go back to the drawing
board and reconsider what might be the underlying issue here.

>
> Thanks,
> Amir.

Cheers, Lorenzo
