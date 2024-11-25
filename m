Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5061714AC;
	Mon, 25 Nov 2024 12:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732539213; cv=fail; b=A6prYN0AMNSm1rbucafL9AVIUVzIiC+2zwOVEcNiiyUgKYXKWYorvZn27Qi5VDlEWieX0GxhIPOARPajimdwl2bW+vQx+bqZ3PEEAssRkh3NqDCqYpJEnEQkIgfY6Kci9DXW6OVt34KQYfP1k3hWvIwYQzn1/7sTgtuRPLTa22I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732539213; c=relaxed/simple;
	bh=ldZ9rS+/S76jsjnjRq6Yjm85jFLIYWLRGs0YHgjuYk8=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MsrC4OMKgIvZ7WZ2PLW50Vh8ggF7yKVup5U6uvVJHPR9Cpjd6+sWAboJHXsWoafI+P2YRsQBLrIgHbdmbzSTr1XloG2ODpCWrm5jjZTpVSOHuq4HxNwQnNhjjFoaXTwDC90nAmeEtk3MoOe3jUHNPEOn+Pkzy4g2y4r6I1rjsfc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MB36kzIh; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MB36kzIh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732539211; x=1764075211;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=ldZ9rS+/S76jsjnjRq6Yjm85jFLIYWLRGs0YHgjuYk8=;
  b=MB36kzIh9cdbmh3bp63IiFCVYWbfqQYSxTcxGiasV1TuQAUJrO6Y1zAK
   yAH9NBLxsGvy11rPLIKHFBXoAr4zVz4kXD9QBSsIzsJMa2BHYpevdhyYC
   cnafumZ2XxDB4ow3oFfAUHyEBogduyMFzc2l/8DDnogGOijoIrlwt1T84
   rHQZthn/CHxaksU4SkSR5TJirWBVhi9oXwH+ebdBpN0eK2BgEmn34sh2k
   5J6/KHJMJ7A3eS8FKCaFHHx9KDpyX4xSjWPCyOrx2ic4qZL4cuLRag8h1
   YrzPNKAOTK0RagTPxCU1qelj7mry3lV/tNC3MIuvqgCTvEVkq7e3q61Zu
   Q==;
X-CSE-ConnectionGUID: y9nmnZF5RW2NdR4Kl+UfaA==
X-CSE-MsgGUID: ynzPgd39T621nWLONg4B0A==
X-IronPort-AV: E=McAfee;i="6700,10204,11267"; a="32007531"
X-IronPort-AV: E=Sophos;i="6.12,182,1728975600"; 
   d="scan'208";a="32007531"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 04:53:30 -0800
X-CSE-ConnectionGUID: Bo8yt67iT32iyvsnASsIZg==
X-CSE-MsgGUID: Km09N+hTSNm8VFod1WKUEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,182,1728975600"; 
   d="scan'208";a="122202354"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Nov 2024 04:53:31 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 25 Nov 2024 04:53:29 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 25 Nov 2024 04:53:29 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 25 Nov 2024 04:53:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QpvXbPpTlu8e79oCCa/LRViZtBZYrzCwt9yp+Nej+sPlT1qC85GZvoNM7VMV2LwZQSteRTa+W7PzwobP9ulljTgFlhVndUKhijQU5oPWLe2PTXdnaFfR9vbpkN7aRL9roVmggalNvOSHeDRqzEGpIMNWy+v50jY0ATAWNLT/TcMWH4eeKRIWSUpMJpO6EHoc/hP1QbEZ9auiLP8XiGsH6SMc1BxhEddyJBYNeXGbklCcFyGq8U8wU4mdDXqoFOdfhm1jJESxAO417NIV4q3uz2n0MdbjqQITwx7UFRplPHnzXxBrztyZB6qFZinJepuQQkiZ9eHQcJqlM0zBwGOMGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZjncHkZoIWCnd0ru4VCcSR7m720lQskzzRMdvhk5trA=;
 b=N+nmAjKZFJaxg9wI34mQUDZ1BSqThFW3zZltVzaV4aii9esBZD1eDuYqVfBm8cTTD4tTPrpeA3fHNnzG6AkC0rDNWBZlIUYCx3livwL/aXVH5VAMlK4WPJsKXsZ5b9VnM8z7Is7NAl03MCsKAJUlCfR/hqvM32lsGG1dnS9ZZhE8SgJqrV3r1ML5i5MSJstNoU5mqMr6AF9pfL5BfU1x/mCdmdRDjncktp7GNcj6N9Z6cQhGS/D9gQ2kklsoq+nXlL4xghLFyPLF81NNdiykOwafvyVoJrlTI/XfHFJ104sk+ed1CQYHM54g1XMvvxRH2mT62IeQhzd+e58kNNDO8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by PH7PR11MB6547.namprd11.prod.outlook.com (2603:10b6:510:211::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.20; Mon, 25 Nov
 2024 12:53:26 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.8182.019; Mon, 25 Nov 2024
 12:53:26 +0000
Date: Mon, 25 Nov 2024 20:53:17 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Kees Cook <kees@kernel.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>,
	<linux-unionfs@vger.kernel.org>, <ltp@lists.linux.it>, Miklos Szeredi
	<miklos@szeredi.hu>, Kees Cook <kees@kernel.org>, Amir Goldstein
	<amir73il@gmail.com>, <linux-kernel@vger.kernel.org>,
	<linux-hardening@vger.kernel.org>, <oliver.sang@intel.com>
Subject: Re: [PATCH] ovl: Check for NULL OVL_E() results
Message-ID: <202411251652.ecbb3c7e-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241117044612.work.304-kees@kernel.org>
X-ClientProxiedBy: SI1PR02CA0010.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::17) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|PH7PR11MB6547:EE_
X-MS-Office365-Filtering-Correlation-Id: a51d5779-cc89-428b-d95b-08dd0d502720
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?TvxzhYaQpJwKtCDg9XHK4Ri2AdD3saFmuZQYUtPUCws98cA2WfbgBtUdkNWa?=
 =?us-ascii?Q?CzPj05agntscta7PYDWbkR/9Z/1i7Fg5SVhDI5Psu9EuaNkMHWM8wpK8j7KV?=
 =?us-ascii?Q?mi4YlIBR5BL6/jJV1foWaLKJ3WBtSul0EyYt5PZ5SCycbPLl9qajcZ3VO5Uw?=
 =?us-ascii?Q?zfjJzmDbgIG7dICWD0mOmVPZMyWrtVMzh3kXPyTwP23c8ycq3wdjKPhYGTcl?=
 =?us-ascii?Q?4x4UMzmbtfOCVE316+0SzsJ6ZeuYvCQIUFdrh5pHKc4OplZIrLNqhD+iBJtK?=
 =?us-ascii?Q?pLqXz9e1zl9PV3MI4S1vj/NX1oRicxHEzq33da2idkjzV4OhtExbk1igJAs5?=
 =?us-ascii?Q?JqC37v4E4JkZ/MhMCipCq+OHV/5/aoiZolkj+M8Qbr8/IoPcBl04Fqn3VoDU?=
 =?us-ascii?Q?buNfOBHfDcfCwcVfllkTQAtJUR29h1Gujeg/3mbLROU96JurLw4fMOHTekFm?=
 =?us-ascii?Q?ChtfTAbRvLUc/9dozkKli6A9TyvRGM374YX1zIi59HWWEmIAiUk8soIcknP4?=
 =?us-ascii?Q?B139c+ojrQxw0PaRzWIVSMbdMQe2+zOzihAhIP9LhvTnAQPMa1TjPfs+DOJg?=
 =?us-ascii?Q?crT+JtQ27OoxHyxowJRJ01rxLdXKKAFRIldD67oIMC7FnKoE0H+48XJSyv4s?=
 =?us-ascii?Q?Nz3C9/pT41n+tU7k39FWNdZqhOI4Jqr6wpQM0RhXp8j/OqQZsQG6wPbT2Qq+?=
 =?us-ascii?Q?r/5m7JHCC2cGLgBo2DwZzsFDctTIZL6oueRE7xvsCYUO8e6+UqcOgisRQyKV?=
 =?us-ascii?Q?RjmqAptUCLc+7MGwKJxIfb+83nhmNt6Ih26Z+Vt4IcmZZEr04Xr9zOE4XbxJ?=
 =?us-ascii?Q?n6jk6U+9I2L/cac+BN1q8MO/4/FxQaS0iG/hrhLoqPwJV9D65vyjk4dQUwtK?=
 =?us-ascii?Q?OkGiMmgygzMhbW6AN122vYk9KvNgHl3ISEX47J3kBqo3VD4r9TuhZOcL7i4B?=
 =?us-ascii?Q?S9SiNZ1QOpc1SWttcbd22g9ErGgseiHOg3WYoDVz2dVgXOQ2DSPoSEHqtK+E?=
 =?us-ascii?Q?n+GywAAa2wjBjfLsmtLNRfBAESXUc8pKM8Isgh5B0ui1s1lKXpm/9YzatiEe?=
 =?us-ascii?Q?iAf2ce8ujD7VA/0u8xksf4WVd6KRPx25JLyXFzTyTB13LEZfOIbRoNN/qwXG?=
 =?us-ascii?Q?eqvEbUPZOU5wubUTNDdssaRhz8cj8jQq89dC6gTI83wcVZYqRkE1XHCMo5Eq?=
 =?us-ascii?Q?/LMr21WbspTfglcMocUiZQy4oLfQ7bKjeG7FeYABUJkCFYuDfyuWJs48Bma8?=
 =?us-ascii?Q?MCHEHxcd/ReI9YYeIBwPcaEUWYI+3sqRmtydAzZkfb1F2bbz/M47lwuC+TlT?=
 =?us-ascii?Q?SeD7XISuKyl54djuK7iuC7Nk?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6gFbpp649hAQR5HQt7Y10otVVaNTw4hV/MLCJF+tEmLwg61fmPetXN5XuEeC?=
 =?us-ascii?Q?AtP6ZVU+bXi2mGSt7phlOg0eVShFxruGahNDGcQ0ItruykNCaGl9DxmUYeW2?=
 =?us-ascii?Q?GTigRULZ2mgGbovdrVyizj0E+6pcYB+Ii1W7hv5OFXHZ/MFktoLJIy97LdBf?=
 =?us-ascii?Q?SBA1bQ84ECAP2Oqs6E8QOGgNL9ptNxkdK2RKlOYyHonIlWx7Kp3ZHFKfnq18?=
 =?us-ascii?Q?oYEB7VqYZKVEJES0/sNzOCmnOKT5f8nUBf3rhDhWlsf3nRGHBCxxtO8VbwEf?=
 =?us-ascii?Q?nC8K2TcLedoKTFZLKBbxIPfd6X307uyLMpI2S5UI2dYmN7bVdDPK1D+aKicr?=
 =?us-ascii?Q?gVk3p5ZdIFqwKWXKFKr+TDY9cFHgF8AwFXjFXcNQarrsuIpbEKKjtbMAlNhT?=
 =?us-ascii?Q?311IyfNZlbhNog5WAqYobaBhQ8x5TH7yfqYhXH/nmzbdkFLa7ppv4ENgwiNU?=
 =?us-ascii?Q?Aseu1Pn2jYY8RshzDZ7c+vpCULNaJs98/PYPQoIXd1UuOFxLic62njNgwxqt?=
 =?us-ascii?Q?q9rz0rJtoLusRI1lJ8tFtW/Chtqd7iE/1VIgVO/cCyJxEOw6jdBqGVfzwe3g?=
 =?us-ascii?Q?4tXFn3Moql8LV7tA0GXTgjnNWf8T2/srWxPHsxpsvmPUgeM3zo/zxqY9P3jr?=
 =?us-ascii?Q?DD2cmXPOSGkRetBpuCPCm8lrMx4P7Y2Y5zF1zAhEVsiJWcquOfpJBm20iJvN?=
 =?us-ascii?Q?1NmMEeCWL3zuqz/j0JShLzE2UhKkFkECE44PAIkn8pxRN6dQkJiWsfRqd0sB?=
 =?us-ascii?Q?44WqCAJMaE7qTEdaUSIEbUaBrS1ZcFsCXsr2WHdfwN0psMCNLGNJcAo48/89?=
 =?us-ascii?Q?6QtZXKNXDkWw0eBLvVzgReiauoDZJjgWWpm/WEPA95uZdMQIKQ3v5xIrb1by?=
 =?us-ascii?Q?FIJ3mzMMGyABB37u47LbP2xBzREMuJA7fGNrSTL5rUZnbfX4xc77qqk+6nS0?=
 =?us-ascii?Q?11w+NodSeOWd6TxmKxkE6e4mX6xnQIe1/Kad+co293rs/36ylnLRiK/RaW3w?=
 =?us-ascii?Q?gbTZ54N0ZTLE5Hiopotb1+lAECvL+D8LUI7tLh4KAwJzOOTE4M8ElIRFbNqF?=
 =?us-ascii?Q?CgsBwLqVm+rO/wEWxm43wbSwwOqGXN9jwVZOJoxB01jpo4a8JALTVVyHSU48?=
 =?us-ascii?Q?3dqVX+gFpwoihnICpjBra60IPR5cWYDDDWmfRa9JhFQypDq2tpAOiSHT4aVX?=
 =?us-ascii?Q?xjMz03iAwe9E3sz17twevc6UYjvgs++KQNRW1uVwGVYqvkuvfwKuS/Qkqok3?=
 =?us-ascii?Q?BFfNH0EVJi5CJR7Qdz1t8hYKgozz6SP1JHDwTfN77dHKvE/vN0wsLiIdOvlg?=
 =?us-ascii?Q?gxk9N6xrZ2L/JVt2al3iZ62DijFlZfQccqCGJkDLD7tRtpiVi7XK0YnV8fDD?=
 =?us-ascii?Q?S+14Ge9jhzwdAGq9ZY1ZSCLfwYTMQHBgLh7defMxwJsNqrcp0r/JypNgYmYV?=
 =?us-ascii?Q?rH16SU8ajQdCXQ1fsbeAObxkdk38xQjTFI26gWubtozgBZ1xUl8ZZm3Jt7H9?=
 =?us-ascii?Q?yMOWexg3E3TL0u+Y4GuMjcCnRuQBHA38+K8NOyqxzKUnWLtpUNMkF5hTfmG7?=
 =?us-ascii?Q?+Oou5NoG0R3SVSFpT5Z4ZczavIxumftxZ9DSDWAg?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a51d5779-cc89-428b-d95b-08dd0d502720
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2024 12:53:26.3668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BYuWms/ltMFrJNOjrerJ/zjEV1cmwHpHZgErKY8WU1FM0Bmn868fKGD8CQp5EnOkid3cbKW+L6L378Eh3yYNow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6547
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "WARNING:at_fs/overlayfs/util.c:#ovl_path_type[overlay]" on:

commit: d6b14141241121ff7761dc8dfb33d27284fc5331 ("[PATCH] ovl: Check for NULL OVL_E() results")
url: https://github.com/intel-lab-lkp/linux/commits/Kees-Cook/ovl-Check-for-NULL-OVL_E-results/20241121-100558
base: https://git.kernel.org/cgit/linux/kernel/git/vfs/vfs.git vfs.all
patch link: https://lore.kernel.org/all/20241117044612.work.304-kees@kernel.org/
patch subject: [PATCH] ovl: Check for NULL OVL_E() results

in testcase: ltp
version: ltp-x86_64-14c1f76-1_20241111
with following parameters:

	disk: 1HDD
	fs: ext4
	test: syscalls-07



config: x86_64-rhel-9.4-ltp
compiler: gcc-12
test machine: 4 threads 1 sockets Intel(R) Core(TM) i3-3220 CPU @ 3.30GHz (Ivy Bridge) with 8G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202411251652.ecbb3c7e-lkp@intel.com


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20241125/202411251652.ecbb3c7e-lkp@intel.com


kern  :warn  : [  407.439702] ------------[ cut here ]------------
user  :notice: [  407.448057] fanotify06.c:134: TPASS: group 0 got event: mask 2 pid=5267 fd=13
kern  :warn  : [  407.448607] WARNING: CPU: 0 PID: 5267 at fs/overlayfs/util.c:211 ovl_path_type+0xdb/0x220 [overlay]

kern  :warn  : [  407.461773] Modules linked in:
user  :notice: [  407.473065] fanotify06.c:134: TPASS: group 1 got event: mask 2 pid=5267 fd=13
kern  :warn  : [  407.473711]  overlay

kern  :warn  : [  407.485300]  brd exfat vfat fat xfs
user  :notice: [  407.489747] fanotify06.c:134: TPASS: group 2 got event: mask 2 pid=5267 fd=13
kern  :warn  : [  407.490395]  ext2 ext4 mbcache jbd2 netconsole btrfs blake2b_generic xor zstd_compress

kern  :warn  : [  407.502433]  raid6_pq libcrc32c snd_hda_codec_realtek snd_hda_codec_generic snd_hda_scodec_component
user  :notice: [  407.512136] fanotify06.c:217: TPASS: group 3 got no event
kern  :warn  : [  407.513249]  intel_rapl_msr intel_rapl_common sd_mod x86_pkg_temp_thermal

kern  :warn  : [  407.529180]  intel_powerclamp sg coretemp snd_hda_intel
user  :notice: [  407.537741] fanotify06.c:217: TPASS: group 4 got no event
kern  :warn  : [  407.538876]  kvm_intel ipmi_devintf ipmi_msghandler

kern  :warn  : [  407.550897]  i915 snd_intel_dspcfg snd_intel_sdw_acpi kvm
user  :notice: [  407.557559] fanotify06.c:217: TPASS: group 5 got no event
kern  :warn  : [  407.558678]  cec snd_hda_codec snd_hda_core

kern  :warn  : [  407.570873]  intel_gtt snd_hwdep crct10dif_pclmul crc32_pclmul drm_buddy
user  :notice: [  407.576845] fanotify06.c:217: TPASS: group 6 got no event
kern  :warn  : [  407.577961]  crc32c_intel ahci ghash_clmulni_intel

user  :notice: [  407.586986] fanotify06.c:217: TPASS: group 7 got no event
kern  :warn  : [  407.591490]  snd_pcm

kern  :warn  : [  407.599214]  drm_display_helper ttm rapl libahci snd_timer intel_cstate
user  :notice: [  407.606451] fanotify06.c:217: TPASS: group 8 got no event
kern  :warn  : [  407.608219]  wmi_bmof

kern  :warn  : [  407.617727]  mei_me intel_uncore drm_kms_helper snd pcspkr
user  :notice: [  407.625498] fanotify06.c:158: TINFO: Test #1: Fanotify merge overlayfs mount mark
kern  :warn  : [  407.626824]  i2c_i801 lpc_ich i2c_smbus

kern  :warn  : [  407.635208]  libata mei soundcore video wmi binfmt_misc loop fuse drm dm_mod ip_tables
kern  :warn  : [  407.659894] CPU: 0 UID: 0 PID: 5267 Comm: fanotify06 Tainted: G S                 6.12.0-rc5-00193-gd6b141412411 #1
kern  :warn  : [  407.671076] Tainted: [S]=CPU_OUT_OF_SPEC
kern  :warn  : [  407.675743] Hardware name: Hewlett-Packard HP Pro 3340 MT/17A1, BIOS 8.07 01/24/2013
kern  :warn  : [  407.684219] RIP: 0010:ovl_path_type+0xdb/0x220 [overlay]
kern  :warn  : [  407.690304] Code: 01 00 00 41 8b 04 24 4d 85 f6 0f 84 b7 00 00 00 41 bc 01 00 00 00 85 c0 75 25 5b 44 89 e0 5d 41 5c 41 5d 41 5e c3 cc cc cc cc <0f> 0b 45 31 e4 5b 5d 44 89 e0 41 5c 41 5d 41 5e c3 cc cc cc cc 4c
kern  :warn  : [  407.709811] RSP: 0018:ffffc900021ff870 EFLAGS: 00010246
kern  :warn  : [  407.715790] RAX: dffffc0000000000 RBX: ffff8881e6ea33a0 RCX: ffffffffc2f437e4
kern  :warn  : [  407.723669] RDX: 1ffff1103cdd46c2 RSI: ffffc900021ff8f0 RDI: ffff8881e6ea3610
kern  :warn  : [  407.731551] RBP: ffff888001a9e800 R08: 0000000000000000 R09: ffffed1000353d0f
kern  :warn  : [  407.739432] R10: ffff888001a9e87f R11: ffff88811835de00 R12: 0000000000000000
kern  :warn  : [  407.747312] R13: ffff888001a9e830 R14: ffffc900021ff8f0 R15: 000000000011801e
kern  :warn  : [  407.755192] FS:  00007fc80cb3a740(0000) GS:ffff888174c00000(0000) knlGS:0000000000000000
kern  :warn  : [  407.764026] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kern  :warn  : [  407.770512] CR2: 00007f3378006280 CR3: 000000013af18005 CR4: 00000000001726f0
kern  :warn  : [  407.778391] Call Trace:
kern  :warn  : [  407.781606]  <TASK>
kern  :warn  : [  407.784463]  ? __warn+0xcd/0x260
kern  :warn  : [  407.788451]  ? ovl_path_type+0xdb/0x220 [overlay]
kern  :warn  : [  407.793929]  ? report_bug+0x25d/0x2c0
kern  :warn  : [  407.798337]  ? handle_bug+0x53/0xa0
kern  :warn  : [  407.802582]  ? exc_invalid_op+0x13/0x40
kern  :warn  : [  407.807159]  ? asm_exc_invalid_op+0x16/0x20
kern  :warn  : [  407.812092]  ? ovl_already_copied_up+0x94/0x110 [overlay]
kern  :warn  : [  407.818264]  ? ovl_path_type+0xdb/0x220 [overlay]
kern  :warn  : [  407.823744]  ovl_path_realdata+0x16/0x200 [overlay]
kern  :warn  : [  407.829384]  ovl_open+0x179/0x220 [overlay]
kern  :warn  : [  407.834335]  ? __pfx_ovl_open+0x10/0x10 [overlay]
kern  :warn  : [  407.839807]  ? revert_creds+0x7a/0xb0
kern  :warn  : [  407.844218]  ? ovl_permission+0x143/0x1f0 [overlay]
kern  :warn  : [  407.849862]  do_dentry_open+0x453/0x10d0
kern  :warn  : [  407.854532]  ? __pfx_ovl_open+0x10/0x10 [overlay]
kern  :warn  : [  407.860011]  vfs_open+0x75/0x340
kern  :warn  : [  407.863987]  do_open+0x41c/0xd40
kern  :warn  : [  407.867963]  path_openat+0x23b/0x630
kern  :warn  : [  407.872289]  ? __pfx_path_openat+0x10/0x10
kern  :warn  : [  407.877141]  ? __pfx_ksys_write+0x10/0x10
kern  :warn  : [  407.881898]  ? kill_pid_info_type+0xa6/0xc0
kern  :warn  : [  407.886824]  do_filp_open+0x1b0/0x3e0
kern  :warn  : [  407.891240]  ? syscall_exit_to_user_mode+0xc/0x1e0
kern  :warn  : [  407.896780]  ? __pfx_do_filp_open+0x10/0x10
kern  :warn  : [  407.901705]  ? kfree+0xef/0x400
kern  :warn  : [  407.905595]  ? _raw_spin_lock+0x81/0xe0
kern  :warn  : [  407.910185]  ? strncpy_from_user+0x28/0x1f0
kern  :warn  : [  407.915111]  ? alloc_fd+0x269/0x440
kern  :warn  : [  407.919350]  do_sys_openat2+0x11e/0x160
kern  :warn  : [  407.923934]  ? __kasan_slab_alloc+0x2f/0x70
kern  :warn  : [  407.928867]  ? __pfx_do_sys_openat2+0x10/0x10
kern  :warn  : [  407.933975]  ? syscall_exit_to_user_mode+0xc/0x1e0
kern  :warn  : [  407.939513]  ? syscall_exit_to_user_mode+0xc/0x1e0
kern  :warn  : [  407.945048]  __x64_sys_openat+0x135/0x1d0
kern  :warn  : [  407.949806]  ? __pfx___x64_sys_openat+0x10/0x10
kern  :warn  : [  407.955082]  ? syscall_exit_to_user_mode+0x1c1/0x1e0
kern  :warn  : [  407.960795]  ? do_syscall_64+0x85/0x150
kern  :warn  : [  407.965377]  do_syscall_64+0x79/0x150
kern  :warn  : [  407.969790]  ? kmem_cache_free+0x265/0x4d0
kern  :warn  : [  407.974635]  ? switch_fpu_return+0xe8/0x1f0
kern  :warn  : [  407.979567]  ? __task_pid_nr_ns+0x21e/0x2a0
kern  :warn  : [  407.984497]  ? syscall_exit_to_user_mode+0xc/0x1e0
kern  :warn  : [  407.990035]  ? do_syscall_64+0x85/0x150
kern  :warn  : [  407.994617]  ? do_syscall_64+0x85/0x150
kern  :warn  : [  407.999198]  ? do_syscall_64+0x85/0x150
kern  :warn  : [  408.003785]  ? exc_page_fault+0x57/0xc0
kern  :warn  : [  408.008361]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
kern  :warn  : [  408.014144] RIP: 0033:0x7fc80cc34f81
kern  :warn  : [  408.018477] Code: 75 57 89 f0 25 00 00 41 00 3d 00 00 41 00 74 49 80 3d 6a 26 0e 00 00 74 6d 89 da 48 89 ee bf 9c ff ff ff b8 01 01 00 00 0f 05 <48> 3d 00 f0 ff ff 0f 87 93 00 00 00 48 8b 54 24 28 64 48 2b 14 25
kern  :warn  : [  408.037988] RSP: 002b:00007ffdfed4d7b0 EFLAGS: 00000202 ORIG_RAX: 0000000000000101
kern  :warn  : [  408.046305] RAX: ffffffffffffffda RBX: 0000000000000041 RCX: 00007fc80cc34f81
kern  :warn  : [  408.054181] RDX: 0000000000000041 RSI: 000055e24d04dd40 RDI: 00000000ffffff9c
kern  :warn  : [  408.062062] RBP: 000055e24d04dd40 R08: 00000000000001a4 R09: 0000000000000000
kern  :warn  : [  408.069934] R10: 00000000000001b6 R11: 0000000000000202 R12: 00000000000000a6
kern  :warn  : [  408.077813] R13: 00000000000001a4 R14: 0000000000000000 R15: 0000000000000000
kern  :warn  : [  408.085692]  </TASK>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

