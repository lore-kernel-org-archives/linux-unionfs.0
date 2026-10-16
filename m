Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9098A282F05;
	Fri, 16 Oct 2026 05:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792129672; cv=fail; b=TOIPG9fZ+jDYAYFUx+JkFOdEAoX1b6mECli3hebj+qyKmvy8weRLqleeYH/9BIbijE62IGXXnSvN12ZXnX65gx5bu2lj3C4g1b/ii1/FvQXDSedLu3J+geowJfBjmQo3rTbW8w0BR6YtqyUcfCbyhByvQZOrtnJHBzjWkSntNuY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792129672; c=relaxed/simple;
	bh=sSmjAcHgMRVXAB2cFw2pvCmhc2AE9+R6bM2sKmnJGZ8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eXiDB0GCtj0Lap6J2I/OYOUovCcr1Y79fF1/bAsxUlXQcy9J8NqfgewjQNprlbIYm2bnsNp0MOKlmhC69hHC0rtv/ZRdiqNHfLPF4LtD6oH5MaqFfQ0ZXzXDzy54WbaTWnY3IDYyrczGGAxwPu9HJBgDo/CbgTus3hFbLx/01zY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jeH6f+KM; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jeH6f+KM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792129671; x=1823665671;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sSmjAcHgMRVXAB2cFw2pvCmhc2AE9+R6bM2sKmnJGZ8=;
  b=jeH6f+KMm96odMkmXUL3qLeUDBDlyj/38UAjVavjLsq4+C7QCZL3P+QX
   5lELz+jdOpD8JAvfaISD21tFAC3q3UiZB8OcUtjhAFH5UJGbYJ+n3AZp0
   9KZHynRnSCzXnF9+QTLvSMqhnADAt1vYaFDqoRmMhm9dyMurw8v4oe57z
   sfK7MLwz5ny8+PscrWyJJbiu3ck6OnOUl143pxsdonWbr0guAKXcnZgiS
   KCHxpzii35UmLQ8xPKkh+QLWCJ6hqNvEfPLO6IfZpSaD4voxaIner/ilK
   wALYyfPXWeyK/wBtc4oFYCo1oa7fXOJSVzpIBxtItYFKbFLj0gsXfbl9E
   Q==;
X-CSE-ConnectionGUID: J0XAKdKMTBajeysP8Lk5VQ==
X-CSE-MsgGUID: 1hrY+QAQQc+4AFxpoDqbyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11936"; a="808039"
X-IronPort-AV: E=Sophos;i="6.27,161,1787036400"; 
   d="scan'208";a="808039"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2026 22:47:49 -0700
X-CSE-ConnectionGUID: kUifMKpeT3e6hV5VOSSClA==
X-CSE-MsgGUID: oHBVe0bNRvGVOIslQ0/MsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,161,1787036400"; 
   d="scan'208";a="3655395"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa013.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2026 22:47:49 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 15 Oct 2026 22:47:48 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Thu, 15 Oct 2026 22:47:48 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.41) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 15 Oct 2026 22:47:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SpFvttjpwjA+ywMJuoY+mi+XuRcoTWfEqId63cCxTzaqY7unvsWLnLXTvROBmid0EK6HdGtfyheNZncOwZRLmmYC74mqaAvoDBHyWqDPl8WotwnJPKpk3+/3In9S7w2BjPPapv1elQALJb/ITkM24EHWCVGOuwTQkhfKq6we8PZEPIgGtEI56UO/6Nt82CfpFg3TIRPOcwFRC9EXllCYIQ2ynUCRPaWWn+tvN8abhHV+PnVcLlTh4jYT8TkDHeVd/BCCBYXvE3TzbVxtGRXkbMMMbS8+e9njG5DLD35FKK55GCecQFURjj3FmsR5Anv9uAuYCQgmpS8270fSs35jEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i7qJZrogEOSt+qQMO6DxEcCTVkNtHsSenFZ7hWXCPIk=;
 b=mjvpzCMdpqf3LJIBwETQv48+x5AHEPI6jciOFueod1curieguMRzTUOMRQcR2YWtJiyiunYhbqik+Rz8HKdQ9kAsuD9l/MaNL+Ii6Q0W8qRO9+wjhwrYi5YUyayhM+Siq3BKdvj17H1BdtICT1SO3lFZoempugcxsT/DagmLug7lJoGilEjGlr7zEsXay9fb0qFts7zA8T0XGIep8+77Dz1DyyMFwST51iuJzK351br7waBgbnO0NO/6uQFZ9hquDa33YEx+vMbrhmcrJsnIRgWi4Kyw9s3Rip99xYpQPwXsAHOURUG+nInLLNScZTwQnGgzX1DNVQypwK1v7F3fUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA2PR11MB5035.namprd11.prod.outlook.com (2603:10b6:806:116::21)
 by BN9PR11MB5308.namprd11.prod.outlook.com (2603:10b6:408:119::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Fri, 16 Oct
 2026 05:47:46 +0000
Received: from SA2PR11MB5035.namprd11.prod.outlook.com
 ([fe80::9418:cd60:8ece:69c3]) by SA2PR11MB5035.namprd11.prod.outlook.com
 ([fe80::9418:cd60:8ece:69c3%5]) with mapi id 15.21.0522.013; Fri, 16 Oct 2026
 05:47:46 +0000
Message-ID: <3d3bdd7b-f849-47d3-a5bb-1e5a68d4edea@intel.com>
Date: Fri, 16 Oct 2026 11:17:36 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] ovl: provide private lockdep class for
 dentry->dep_map
To: NeilBrown <neil@brown.name>, Miklos Szeredi <miklos@szeredi.hu>, "Amir
 Goldstein" <amir73il@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
CC: Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-unionfs@vger.kernel.org>
References: <20261002223746.3248726-1-neilb@ownmail.net>
 <20261002223746.3248726-4-neilb@ownmail.net>
Content-Language: en-GB
From: "Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>
In-Reply-To: <20261002223746.3248726-4-neilb@ownmail.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0050.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1d3::14) To SA2PR11MB5035.namprd11.prod.outlook.com
 (2603:10b6:806:116::21)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR11MB5035:EE_|BN9PR11MB5308:EE_
X-MS-Office365-Filtering-Correlation-Id: c1c1db20-b79d-4e53-5526-08df2b4900c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|261009223027099003|56012099006|11063799006|4143699003|22082099003|10067099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info: XzBqIq9beG+7QCwCH9g71LPwcY0R/Ik7NtucHWm1pHLzwnXk6n9uVlREVHdZ4RJVsUK6T3tLqnsuDxh4sitq/iMGYtZxgLiGaAKuwcPP9ORVEkKf3LiMAwv2cTHWD89Kj9JwtMM9CjEOyA9bKOb2ot06JVhM4DQbDGbGsjOYeQNLVfiwZGUMnCS2QuRAJD2pjwQc7Te0YfBwImP4nx98O2oUaNvNBvbqe/zdgjHCFeHHuLYsH+ldCm5bTwpjxdZHUab45P0pk9HYIkROaSDItjlidok4Zjeaw+7wRyRVM7G08oSMpHp/INoIOAj4tF4+2J2iLdm/wW+/nE+X0bPBBb4iN3HwkofoMHG0lzcZHSmnFcaBqsV/9gFMzfD32N2aAyhZPhRTMre9zh0sNDngm6HTmn3qcD0yiwz74nI+U+F+PZ88nD7W+5qHPmAsjsd6DcRM6p2yYOBYp5mGYD01JXFrQwUpRWQkxjrn7c4cOZ88BZN7Gm3kD7DdVy4rqqxjOqd7E5Y2ZVAX1HnnsZ2RfA9MxWpSByK2g5xmWert4P/RMAmlNXT0hyXed3p0aGnt2ENkgDUFK9LmdNoEsMz6zHWFRgYSiZBhioHXjhPdMwwupgPBNojHZC7cWGcGzxGB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5035.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(261009223027099003)(56012099006)(11063799006)(4143699003)(22082099003)(10067099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cjBoeU9oUmYwVTEvbWh2SWZGUDBLRXNZdm1CejYybnFNOVlXWE51ZGFkckx5?=
 =?utf-8?B?dGZ1NDN3eTNNUkZWVzk0K2FCbFAyUkd6TXdzV05KdWUxRWhyL0JMSDhSTzJt?=
 =?utf-8?B?UUhnQ1p4QmVnNkJGc04rbVJTNnRUR2t1alNZSXIyTWJMdzcvb1NoaGRyUkM3?=
 =?utf-8?B?RWV2NjZpNzQzVm1LeTRLcjdDOHJtbCtNUmphQWR5aWg4WDZ3Si9XMDdYY3lp?=
 =?utf-8?B?YTBKQWxTWUJSS3ZuQTREeDdLenhicnJNVHMvVDVWSEJGa2xHWCtjb1BrU1g5?=
 =?utf-8?B?QVNVRWRTL0lsb015V1NubkIyb0QzdnZmZWRsRXdYVDgrcFAwRDFoeUxQRXMz?=
 =?utf-8?B?alJJVkhESDlGMWt1d0M1OVAxdTlHOU9jVHdLdWY2eFlXWHJudis1dUFJbkV0?=
 =?utf-8?B?VjArUWZyUjRpalhKeS85VUpHMHJmcWRlcUVFZGl0Sk0zWG8yR2VhejNIRnYy?=
 =?utf-8?B?R1N1UldCQ0lDdHdKTmFaRVlSbDN3aWZMWlFrQnc5NDVMRTBaZDVsaTZuZlo1?=
 =?utf-8?B?R2twUi9tNEl4VjludHZPcGN4eUpHNHJIVm9UMWNIVTl5R3BycVl0UDlUTS9O?=
 =?utf-8?B?ekJoWjRvdytGbEJ5VDlUcWdKcEw3amc1WHhERmh5Q0VWTGV3amxzUzlDS3M0?=
 =?utf-8?B?U1E4T1k5bFhac2JCQWxRaDNpWUUxc25lbWhhMVNjTXljNnNObHh2bmhNQzhT?=
 =?utf-8?B?TmJSNmZiWkhWSXVxNmRRMXpRcnVaaUp2aGVqU0h0SXo3UE1FRm1Tc1RtS212?=
 =?utf-8?B?akR5c3hMT2tJeXZOaGltdUFYcXNpek42TkJmVWtaanRMbklUdUpKYTFhL0pI?=
 =?utf-8?B?NXB6anRoNWNTaWdSWitPUGNEVU5PNjNlV0U0MHNFRTRoR3gwNEpiSDdSUmx5?=
 =?utf-8?B?NzFRWTk2WHpyOW9DN1Z4bzdZbWJteDE5cnlZNVAwK0w2WkRpSjBJV3NxaW44?=
 =?utf-8?B?MjFOM1VMVWc5OTJZVGZpLzd6UmIrdmdxcjN6TkZYU1ZLWkwyY0FMaktKRlFz?=
 =?utf-8?B?N1l2T3NLemZ2Z1JpWnVLVTJHdVhGUXg5ZGdGZ09aWmcwUWlzYVVLellUeFFQ?=
 =?utf-8?B?anZybFdYVE1GSm9GekUrN1BtdG1wYy9vYTdYK29HRm0xYm56T0hBdXgvNlJw?=
 =?utf-8?B?TjlFUGgyZHdVeng0N3ZYTkJ6TzNibGtramhaWWEweTkwaEZCek1aWHNYMmww?=
 =?utf-8?B?RWY0NUp5V1QyR0FuUzhuaTN5dnpCL2h5QVF2R0RkQ01iZE5xaG5FeVRoVTN4?=
 =?utf-8?B?UGlSWVI3M0kvSFBuNDhPMVZGQ3FrYVRkRlBRbzFoa1ZiZVIrR25UVVhFelAw?=
 =?utf-8?B?alAvejBBQkFhaEM3aERDSldJREZJMmZLZWp6cWhvbEIwTXMrUjNFRlVJWERJ?=
 =?utf-8?B?UWhSUDMvY3RBV0poY0dHdnFxbXVDbzR1OFJPUDg0dlMrZUZnZ3NoRVZjOElW?=
 =?utf-8?B?czdXTnRCcHFUTWNKUmdQZjk0aE01OHJCUzd1RDUzNm9tUlQxRmhWQlR0WTRY?=
 =?utf-8?B?SXhNNCtDckZxSDh5dG9QcUpkdG5YK3hoZmNzb3VOdSttQnFlczJXcjhXTjZ5?=
 =?utf-8?B?cG10T1FUZW1hamtYOThUMk8xTWg1bGRxNjltT2xhOU81ZTlNUDJhR2F3MFI0?=
 =?utf-8?B?MDFDM2NLWmNtakRCRmxPU0RrelMzaUdrMFhlQ014a0hDNDFHU05Wb3JXeE5m?=
 =?utf-8?B?bmk4dFU0Z2MzbWZobzdNVFd6OHZMS01PT3V0MGFJVVVuOEtxcVl1YUtrOEd3?=
 =?utf-8?B?UXRuK2RDbVdMNDNJdFEwcHhFNW4vWEtVNEVvbkRpalMrK2NUa3ljbzFnY3dP?=
 =?utf-8?B?WFNWRFNuSVhWOUU4dEovZXNFV2NJT0M2YkIrZ2l1ekl2aUMycnVTN1A0d2Qw?=
 =?utf-8?B?QWpjTnVoM0VjN1FONWc4ZEkyQlM5S0VQT2N0N0VtQW5GWWhMWCtxTVFlZzJK?=
 =?utf-8?B?OStwcFM5OEFPV2J4MWMzZU50T2hxNUZIUTF6enVWL2FmQUlYQXJuWGVaTnRK?=
 =?utf-8?B?bXJ0SjFqdGpaYldXdkFJREhGZjJ6cG5MZFJIQ1BjNXhINkVUUHFhNG5aR3dV?=
 =?utf-8?B?NGFvSGt2V1BabnJyL1k0OXBJeS9ocnlnNHZ2VGtUenlTdW0zaDF1VzhyaXl4?=
 =?utf-8?B?S2xSajdLQkpYRGt6cXcvU2g5OXhXR294OHVZWFI2NmtodnNhWkhzMXpPTFoy?=
 =?utf-8?B?K2t0MWpLUEtESXlGOFFhYkVvYURMM01GVmp5MGU2Z1RydjBjMS83L2F5TFBR?=
 =?utf-8?B?dVZjaXNtS2NxZExHbkl2ODJtcjBDL01ndGorZ3F6MFZ1UFovNU5YVGRzUTZa?=
 =?utf-8?B?TTkyVjZhOHZReVNRMGRhU0hwcmpGQXpvN0I0elRyRWprWkpQdWdRbjQ3VXZi?=
 =?utf-8?Q?lWMT4gFUNRNwy6wU=3D?=
X-Exchange-RoutingPolicyChecked: F2447Ssv5gnRiWNyDMGdD3hGSCXIuuODb7intbjy8kOv/ACOHtTS9OlFzIH7Ps9bDwU3CXQga/13iqL7GCwRiK64lmvkLc/CujMdvr3TyJ7nDz6TcnSeN0pi+9rBeWi0dBF8cZsywGgX4QaBZmeofra7QqrgbtAi1B/Zoj3o/RWoeNcVAV9LahWd9UR/C8suLSWHtXrTml+O1fHNzp5+mZHIOUz4kVHtBf+W1C93vHUQckc0htVvnyuzXeF4BOYXgQeBQ2CbTgAwC84AjRWU0dAhdIFtUxTkjkjRLbB7FrzufQUtsIRQ9wIhvjQWC4bK/Kvo06ByxxTOOuP3ZRGapA==
X-MS-Exchange-CrossTenant-Network-Message-Id: c1c1db20-b79d-4e53-5526-08df2b4900c6
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5035.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 05:47:46.0152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DL/eKjYWZ9qMP6hcHmkItnSmHBo9dzg1KJelMksYkuvkV9yBcUoTrv67VHTIUIIuN1V/sacc/dkU03h7DY4VXkxVntioLbek2LluL8uGZwM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5308
X-OriginatorOrg: intel.com

Hello Neil,

On 10/3/2026 4:05 AM, NeilBrown wrote:
> From: NeilBrown <neil@brown.name>
> 
> Now that d_alloc_parallel() locking is tracked by lockdep, ovl needs to
> take care that it doesn't trigger on deliberate recursion into
> subordinate filesystems.  As ovl can stack over itself, the use
> of the per-file_system_type d_lookup_key is not enough.
> 
> So provide a .d_init() function to update the map as it already done for
> i_rwsem and ovl_inode.lock.
> 

Thank you for the patch. Any idea when this lands in linux-next?

==
Chaitanya

> Reported-and-tested-by: "Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>
> Link: https://lore.kernel.org/all/e3772a51-eabc-4c31-b73d-f3187bf1b3b2@intel.com/
> Fixes: 59492f9991dc ("VFS: add lockdep monitoring of DCACHE_PAR_LOOKUP lock.")
> Signed-off-by: NeilBrown <neil@brown.name>
> ---
>   fs/overlayfs/inode.c     |  1 -
>   fs/overlayfs/overlayfs.h |  2 ++
>   fs/overlayfs/super.c     | 19 +++++++++++++++++++
>   3 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 401cb8c75520..bf40198c8b8a 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -816,7 +816,6 @@ static const struct address_space_operations ovl_aops = {
>    * - OVL_I(inode)->lock			(ovl_inode_lock[1])
>    * - upper_mnt->mnt_sb->s_writers	(ovl_want_write[0])
>    */
> -#define OVL_MAX_NESTING FILESYSTEM_MAX_STACK_DEPTH
>   
>   static inline void ovl_lockdep_annotate_inode_mutex_key(struct inode *inode)
>   {
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index e0d8c6152e9f..64cbe4c4bd3e 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -16,6 +16,8 @@
>   #undef pr_fmt
>   #define pr_fmt(fmt) "overlayfs: " fmt
>   
> +#define OVL_MAX_NESTING FILESYSTEM_MAX_STACK_DEPTH
> +
>   enum ovl_path_type {
>   	__OVL_PATH_UPPER	= (1 << 0),
>   	__OVL_PATH_MERGE	= (1 << 1),
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index e487597337e8..08147799e47c 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -163,10 +163,28 @@ static int ovl_dentry_weak_revalidate(struct dentry *dentry, unsigned int flags)
>   	return ovl_dentry_revalidate_common(dentry, flags, true);
>   }
>   
> +#ifdef CONFIG_LOCKDEP
> +static int ovl_dentry_init(struct dentry *dentry)
> +{
> +	static struct lock_class_key ovl_d_lock_key[OVL_MAX_NESTING];
> +	int depth = dentry->d_sb->s_stack_depth - 1;
> +
> +	if (WARN_ON_ONCE(depth < 0 || depth >= OVL_MAX_NESTING))
> +		depth = 0;
> +
> +	lockdep_set_class(dentry, &ovl_d_lock_key[depth]);
> +
> +	return 0;
> +}
> +#else
> +#define ovl_dentry_init NULL
> +#endif
> +
>   static const struct dentry_operations ovl_dentry_operations = {
>   	.d_real = ovl_d_real,
>   	.d_revalidate = ovl_dentry_revalidate,
>   	.d_weak_revalidate = ovl_dentry_weak_revalidate,
> +	.d_init = ovl_dentry_init,
>   };
>   
>   #if IS_ENABLED(CONFIG_UNICODE)
> @@ -176,6 +194,7 @@ static const struct dentry_operations ovl_dentry_ci_operations = {
>   	.d_weak_revalidate = ovl_dentry_weak_revalidate,
>   	.d_hash = generic_ci_d_hash,
>   	.d_compare = generic_ci_d_compare,
> +	.d_init = ovl_dentry_init,
>   };
>   #endif
>   

