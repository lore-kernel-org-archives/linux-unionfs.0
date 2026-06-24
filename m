Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11020141.outbound.protection.outlook.com [52.101.69.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437443998A4;
	Wed, 24 Jun 2026 12:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782303735; cv=fail; b=tq2bZrH2JJm2uQnTibIsWEBCiasafIEYRdKhX695CI+PnlMwPpnq2kiebaGBsWo/NKMg/PASfIvvpWQG2PLoWLzD3OzORXuYS9625SyNuvF7YFVmyMnVwztRuW/53hqq4Ym5W13QpPpc7EaP0dR4DWURH8oRr/03V+jfzfyvplg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782303735; c=relaxed/simple;
	bh=hlvbwU25l9oALhl2+FQ38SLRrzFcqPU4tN0a28D04FE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bQ9YMmhPtLzS6dMOW01wLZb2q8xsF+ibPz6s22st/sgoXVgtyQrKH1JtcH/GUwZIhJo45wVkgVsGSGtvljHaJ3+jXsMD4SAJpsnLTSlvE7efYEGqKvtrUjy0dap0f3eIUqsVDb986e3O3GgWJE7+EvrN3AOmIWQg2qzzRhi+mog=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com; spf=pass smtp.mailfrom=virtuozzo.com; dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b=nmD4Q6+m; arc=fail smtp.client-ip=52.101.69.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="nmD4Q6+m"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Eg8jnBsa0kK9IXOM9sx82IBx2jWv289p2r8oG1DRZXOb9uqZbdILMNUnbWa3FA5jUxql7xc5kyXEv2KrVxjWk8Wex8g4MTc1uCfBnzu2Sw74lqLrgNFt9+StKW/TQLxGkSMcgFsUACbv7sXXmvTjfvlQzfsIGHCIrO3Zl6wVsEVUMFpp8buKSZAit6fHs+NOI423c0tm7E5s69Hi90aBNCobatTOcNGgQEvZM/8jWqIjyypCZIjRFkm9yPQnPQ1+u9cU2z5xTw5GrPLnTiPwf9jT14Isj7RDMVkJhSi6zA4s/fcuBUJni/f6Qsmr1mkKb7Gr4kh/G+NUABUwdR+BIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WewgG4Z1DhUrsGySv3D+D/5erjBDPZX7At5zHJY3avU=;
 b=gObI0RDwWUgFCab7nIIKmenyTGRyMG2XQ80+X+FYdEITR7YMy/1IjONkymCgDaZGN1D4qHXNHseY45sC13HRxFLqUqeE55AsaT48aPsKf9YEIGjIU+AU5Me/38bar8a9T6jHEQ4iMcCcWka8wuc95A8Nw+PXi+HhkKWCVnXlyoBwlsXxocmcteRY2g+J2NHJQdHC2mh8ix3Wv6jP97ZjkSUglfn/qRRKyRwRAINO9v7/27to8kod7QRrFyQXjb+GWfKqY5gNBhFp+5mVYFkVg0sYrzlq+gVcABI7lkvcaYT5XCt68n3YPGZNDBHPOnHSx2mNdhoSdgqXml5ZebXjlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WewgG4Z1DhUrsGySv3D+D/5erjBDPZX7At5zHJY3avU=;
 b=nmD4Q6+mXcyN0IyJDfpbw07+UGHjfLvppxrpmwL/GyQsGX685tpGhXbTOJcGYpVZttuu1Xnsy//5MDR9o3uzesYgKlx6SpECmxwa5ZUiUMGm7jCD4IP8zvKVN94VlGGP/UkpgVNeqZq7MBwW0wJvhcwyCbSNumqVdGN41yTqSW0VIV9Wf7M7Uj0/gWfQrmXGq80PbHQdNxEj5NrGDycAk5YHAO7VjpgRlow8Torx4NFF8oMY0gaFJye3ZNOxCb5me6bscgB6L0Md1UJP9IL04nqQ5P/KeIGi8pdf1P4t8QmiJCLc5SNU8Rzz+FypUgWyp7vcl8IC03cOyHiSuN00kw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from GV2PR08MB11819.eurprd08.prod.outlook.com
 (2603:10a6:150:301::23) by AM8PR08MB6401.eurprd08.prod.outlook.com
 (2603:10a6:20b:361::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.12; Wed, 24 Jun
 2026 12:22:11 +0000
Received: from GV2PR08MB11819.eurprd08.prod.outlook.com
 ([fe80::cf17:c42a:92:b6e3]) by GV2PR08MB11819.eurprd08.prod.outlook.com
 ([fe80::cf17:c42a:92:b6e3%4]) with mapi id 15.21.0159.007; Wed, 24 Jun 2026
 12:22:09 +0000
Message-ID: <50c74f8c-82b0-404a-a74b-b3ba0bc7daf8@virtuozzo.com>
Date: Wed, 24 Jun 2026 14:22:08 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] selftests/cachestat: add an overlayfs test case
To: Nhat Pham <nphamcs@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>,
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
References: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
 <20260623111533.2285005-4-ptikhomirov@virtuozzo.com>
 <CAKEwX=PEE9=P-0=3mCRXArR9eL247P6SpDnYiGHp5zKZ4J+ETA@mail.gmail.com>
Content-Language: en-US
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
In-Reply-To: <CAKEwX=PEE9=P-0=3mCRXArR9eL247P6SpDnYiGHp5zKZ4J+ETA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BEXP281CA0003.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::13)
 To GV2PR08MB11819.eurprd08.prod.outlook.com (2603:10a6:150:301::23)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR08MB11819:EE_|AM8PR08MB6401:EE_
X-MS-Office365-Filtering-Correlation-Id: 50097950-1df0-4512-692c-08ded1eb36a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|7416014|10070799003|22082099003|18002099003|4143699003|6133799003|56012099006;
X-Microsoft-Antispam-Message-Info:
	jzcigE58o5oggSJP+dJOQK0c5qOLu7mW20Q0utRvVJGBgZjAwQRSkCxUWb4NuCW1JlppIb7j1DlieYZHaeEFy2tTvWf6r+fOZeAGQsKY6pj3jNmXjyAzuiBbPl5hyx6AgAMyNgAThRBOBbX2CxawC+w1ktroBoTTbv+xOscTnuNbqxyuP0ZMhGrYIzrNht1fAhWm61NCAYLhLbhBCDx3oZ/l48H2CHhF4eDYsuoEFMKc2fwGRVJafcKtl3HaiYnPwkXCUoVmiMGiJPZ0Rucpovn7dsCQNaYHgwjCfJi+sdbOzrUoMdC4RpobIDy2tvlIPSI0BtdVhX32AcEibSSpfl2HCIZkudGAY50Z61TB3GMcRteBW/Htv4oiGj8uSC6G5g5KlmQHVNix3QLAr3OZI0w4K70XN5l01M6gdkhhyyCaXtW8dVGEYG6nlWu3szwIqOpSMHCQerxd/m9lIqTGtOzI+wuRYvGW6nlHP3KKGVKjaCdqwQ9NBCbXF52aHROnvzI2iQePHi5ZjKEmEgUBpRYpRn9e1HhoQ57KH5CVAikcZr9vODT3Yrbg9+U9piin5KUzSWO/y1HcpvznkbcD83cDq7TVzJHQs8t7zHaC1d56viOkJ1P8EhLKdpBK47lhTqEIsSgKyszCXtJAJbd7sElz6ASSfPAJYR7YNmgPhCU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR08MB11819.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(7416014)(10070799003)(22082099003)(18002099003)(4143699003)(6133799003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L3FLNytZRko0aFB2QmczUUNjL09BaUY5UXByTnljdmNBa0lvKzlHcDhDbXRy?=
 =?utf-8?B?S1h2amJxVVBuL2NncDdONUNYWSs1MGZhekVrLzdnS28xdHZPVVRDVGJBN2RV?=
 =?utf-8?B?MnpMZlBPczllMFQrRnQ4bFBCejlKRzE4NFBsVUlhVklnYmljWEZ1ZWkxd01S?=
 =?utf-8?B?b1I4TFR2Rkd1OGtXSHZVQkdYczlFQVc4cDdjSU1ucjd2c0FlVmdIby9WVmtT?=
 =?utf-8?B?UEVTZXErajF4WnZyY1FLWXVVcHA3eCtuYWU5M2V6T2NkSzNwY0FWZjFST0xl?=
 =?utf-8?B?bmkyY0IrU2ptckJ1QlV5ZWNWeUdCdkl1ZCttL3FvTSs2aE1RQ24zWkFaZTAx?=
 =?utf-8?B?Mnd2dkZTN0hGQXEvQ0ZHaE92MGtZVDc1aDJUWHZ2NDl6UzNFSnRlbDN0NE9H?=
 =?utf-8?B?anhlYWJYUTdIaHFkNkZacjF4OWdHajVEaWQ1OUQ2aDJEakUwR3dNbHpsSUY2?=
 =?utf-8?B?U0xYOU92Q2VPVm5OL3ZSUkdOMHJFaGp4dUh6d0dXYkRSSENSS3ZtQ1M1UXpV?=
 =?utf-8?B?QjM2ZUNOVDFCQVdjR0xxeTdOVElXVlM0QnlVK0YrRGJkMUtsVmVMaGs3SHZ6?=
 =?utf-8?B?eENoV0QwZXNMTTNzTkgwT0lNRENwY3kwMEVuWGVoOGRQMndhNE9RQkNXSm1D?=
 =?utf-8?B?TXZDdHVCZFUwcnFUdmdjSERXc3lLODdLQm1qdnMzR0pGMEZLb05LZzl2RHA0?=
 =?utf-8?B?OUNRZGZ5RWJkS3JNV3JYUGdKNko1Rkl1WGkwZktIT2xPWWkxSWNOWk5iQ0dV?=
 =?utf-8?B?WUlRUWtDUE0xRW9GL2ZKWkdwT211SVRlQ3U2YjlFTVowcmlqS0Yyd2F0bFU5?=
 =?utf-8?B?WjVNVXVSV3ZBUkhsY2p1ZVBkNSs0S1VNNHZkUW9lNUhhK0FvM0ZWU3dTS1ow?=
 =?utf-8?B?SlY1UHp2aVZGOXl1L05OYkdkYTFLSDhHOE9abEdmeVd4MnFEYWx2UVlqeXl5?=
 =?utf-8?B?VGpuRGJSakIzS01jL0lsc1E0TlFhbkZ3bU0rMlh4N0FqUVZzczRHS2NDUFhI?=
 =?utf-8?B?d3pWU0xiYW9BUmE5cEFleHhORzZQdmdQQzlsOVlzZmp6YVJ3Mno3alhWbzE0?=
 =?utf-8?B?WWVWZndVS25EZ2J1clZpMEk1bkduTHZXQzljdTRmb2dYdGVIRGFucVpEOGN5?=
 =?utf-8?B?QnhleGVucktzdkRSYUlTenl6aExmaVZFTGw2ajY4MHZoVlByNUVaT3gyQnF3?=
 =?utf-8?B?L2czendTMEE2TzNoelhOWFBSdkdKQUlqRDNXc2RTajIxd1ZGMzRPajNMZTJ3?=
 =?utf-8?B?WEVLUWdxMXRYRW0rcXl4Y29ycU1rR0cybHR4NGhPOHBuTjEyVldFV2ZORG1z?=
 =?utf-8?B?MmQ0dW5GbEEzTVNkSkRZcXhyNFBQRkQ0Q3VGTkh3NnVGaFVUVGxvRE5iWlJS?=
 =?utf-8?B?b1M3YTRpMkppVjNsbFBIQ1JUakNQajBJNHhDdTBtM080RkxjZXBZcTRMTDIz?=
 =?utf-8?B?MWtIWklOd1ZseTdtYzEwTXdYQ1ZFVHUxdUhXWk9MWUhBbXJReWI2ckFFNWlw?=
 =?utf-8?B?WmIwUWV2UkppOE05Sm9OYzFxSXNuUStMZ1F6WFQxS2pXMkpSY3E1NUVZVHBm?=
 =?utf-8?B?aU1pQnB3Rldta3ZNR2h5eUpVYXV2MjdWMzNjOHhpWDJVekZES3J3OEQzdHQx?=
 =?utf-8?B?bnQwSXlLQWJFVGd1ekd5SWNUWHIxYkoyOERxV2FRU2xJLzF2cW9wYXFaS1FV?=
 =?utf-8?B?azBwYWxldGh4cjJPWXEyTExjQTNHZ25PNHo4NHlBdjdPS2c5TEZoSWRtSVU4?=
 =?utf-8?B?L3Z4djVQa0s3b3JKeWFsekQvWkx2TTFuZzZVOWFEZmRHV01yZnZWZExJREpx?=
 =?utf-8?B?RW02MkhBaWZvY0lmcmFHUmszNmp0dTBTYXhGZm1zb0l1RVVwMjNOeWx2MHdh?=
 =?utf-8?B?ZkhCMUp5QnptVFVRd3hLMUtvVHN4L3pnblJHaEZlUGVzaWJQU3g5b3JIYmxj?=
 =?utf-8?B?UmdvR0RuSFc2dlJsck4yVTBnMlN1UFE3NEg2TG5GRFAySFUrcDRaejZRcnFQ?=
 =?utf-8?B?ZnN5cE1lSHR0eG9NMkpZOXZodlV6cCtQY3A0WDU4cGFyTzV3Zmh6WkRkKzVy?=
 =?utf-8?B?TUVhd2g0TlJERkoxUWl1Z3h1THdPbVFheHF6RDVhMXBya2t2cHJLbE1QQjF0?=
 =?utf-8?B?bitOVzZVT2J0blN1ZXdOcEk5a0JFV1NWYU41M2hzTHdHM2E4bzdpTWF0R0V2?=
 =?utf-8?B?WU5iY1p0U2RGWXZubmNQTEJxQWRncnNlTVBJejN3Q0tlTUljS3BNc3EwczBM?=
 =?utf-8?B?UU8xZTZjRkt6S2EvNnU2SXlQcjQrMHUyVmxOVnoyNE1mMTFnWUFUT3k0RGlT?=
 =?utf-8?B?VzhaTzcyOTFobSt4Q3VOZUNYNTQ5WStFNnI3OHhmSTNwY0drcEhvalozeHBM?=
 =?utf-8?Q?DtiRAJ/JySAlRF6QbIUP2ovdUnBfvKY0O6Q2eTAibaLcA?=
X-MS-Exchange-AntiSpam-MessageData-1: dLtwYHT6LOcKIaYLfmDNHRp0QVinnyr3vv8=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50097950-1df0-4512-692c-08ded1eb36a0
X-MS-Exchange-CrossTenant-AuthSource: GV2PR08MB11819.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2026 12:22:09.8441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z81nfT2knpTpBjMS/1A3vz2qYZo4wjdV7P40byrgqkGCTokC3A8YkN0wxgl/Ki1plPEWdg6YN2bDyNtSmA1q/1Uxb/f+Y2pyg8EBJSBrLqU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6401



On 6/23/26 18:13, Nhat Pham wrote:
> On Tue, Jun 23, 2026 at 4:15 AM Pavel Tikhomirov
> <ptikhomirov@virtuozzo.com> wrote:
>>
>> Mount an overlayfs, create and write a file in the merged directory, and
>> run cachestat() on it, reusing the existing test_cachestat() helper.
>>
>> Also bump NR_TESTS to the actual number of tests run: it was 9 while
>> ten tests were already executed, and this adds an eleventh.
>>
>> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
>> ---
>>  .../selftests/cachestat/test_cachestat.c      | 75 ++++++++++++++++++-
> 
> Hmm this looks strange...?

That's just how git-format-patch formats it for long path and big
change ("++...++") it hides part of the path.

> 
>>  1 file changed, 74 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/cachestat/test_cachestat.c b/tools/testing/selftests/cachestat/test_cachestat.c
>> index 542cd09cb4434..1662d9817c50b 100644
>> --- a/tools/testing/selftests/cachestat/test_cachestat.c
>> +++ b/tools/testing/selftests/cachestat/test_cachestat.c
>> @@ -4,21 +4,25 @@
>>
>>  #include <stdio.h>
>>  #include <stdbool.h>
>> +#include <stdlib.h>
>>  #include <linux/kernel.h>
>>  #include <linux/magic.h>
>>  #include <linux/mman.h>
>>  #include <sys/mman.h>
>> +#include <sys/mount.h>
>>  #include <sys/shm.h>
>> +#include <sys/stat.h>
>>  #include <sys/syscall.h>
>>  #include <sys/vfs.h>
>>  #include <unistd.h>
>>  #include <string.h>
>>  #include <fcntl.h>
>>  #include <errno.h>
>> +#include <limits.h>
>>
>>  #include "kselftest.h"
>>
>> -#define NR_TESTS       9
>> +#define NR_TESTS       11
>>
>>  static const char * const dev_files[] = {
>>         "/dev/zero", "/dev/null", "/dev/urandom",
>> @@ -294,6 +298,62 @@ bool run_cachestat_test(enum file_type type)
>>         return ret;
>>  }
>>
>> +/*
>> + * Set up an overlayfs mount and run cachestat on a freshly created file in the
>> + * merged directory. Overlayfs forwards data I/O to the underlying (upper)
>> + * inode, so the page cache lives there and not in the overlay inode's mapping.
>> + * This is a regression test for cachestat returning all zeroes on overlayfs.
>> + */
>> +static int run_cachestat_overlayfs_test(void)
>> +{
>> +       char tmpl[] = "/tmp/cachestat_ovl.XXXXXX";
>> +       char lower[PATH_MAX], upper[PATH_MAX], work[PATH_MAX];
>> +       char merged[PATH_MAX], opts[4 * PATH_MAX], file[PATH_MAX];
>> +       char *base;
>> +       int ret;
>> +
>> +       base = mkdtemp(tmpl);
>> +       if (!base) {
>> +               ksft_print_msg("Unable to create overlayfs base dir: %s\n",
>> +                              strerror(errno));
>> +               return KSFT_FAIL;
>> +       }
>> +
>> +       snprintf(lower, sizeof(lower), "%s/lower", base);
>> +       snprintf(upper, sizeof(upper), "%s/upper", base);
>> +       snprintf(work, sizeof(work), "%s/work", base);
>> +       snprintf(merged, sizeof(merged), "%s/merged", base);
>> +
>> +       if (mkdir(lower, 0755) || mkdir(upper, 0755) ||
>> +           mkdir(work, 0755) || mkdir(merged, 0755)) {
>> +               ksft_print_msg("Unable to create overlayfs dirs: %s\n",
>> +                              strerror(errno));
>> +               ret = KSFT_FAIL;
>> +               goto cleanup;
>> +       }
>> +
>> +       snprintf(opts, sizeof(opts), "lowerdir=%s,upperdir=%s,workdir=%s",
>> +                lower, upper, work);
>> +
>> +       if (mount("overlay", merged, "overlay", 0, opts)) {
>> +               ksft_print_msg("Unable to mount overlayfs (need root?): %s\n",
>> +                              strerror(errno));
>> +               ret = KSFT_SKIP;
>> +               goto cleanup;
>> +       }
>> +
>> +       snprintf(file, sizeof(file), "%s/merged/cachestat", base);
>> +       ret = test_cachestat(file, true, true, false, 4, O_CREAT | O_RDWR, 0600);
>> +
>> +       umount(merged);
>> +cleanup:
>> +       /* Best-effort recursive cleanup of the temporary tree. */
>> +       snprintf(opts, sizeof(opts), "rm -rf %s", base);
>> +       if (system(opts))
>> +               ksft_print_msg("Unable to clean up %s\n", base);
> 
> nit: no helper for these? :)

This is similar to e.g. ./tools/testing/selftests/bpf/prog_tests/test_local_storage.c's
cleanup, I didn't find a common selftest helper for temporary directory removal.

> 
>> +       return ret;
>> +}
>> +
>>  int main(void)
>>  {
>>         int ret;
>> @@ -361,5 +421,18 @@ int main(void)
>>                 ksft_test_result_fail("cachestat fails with a mmap file\n");
>>                 ret = 1;
>>         }
>> +
>> +       switch (run_cachestat_overlayfs_test()) {
>> +       case KSFT_FAIL:
>> +               ksft_test_result_fail("cachestat fails with an overlayfs file\n");
>> +               ret = 1;
>> +               break;
>> +       case KSFT_PASS:
>> +               ksft_test_result_pass("cachestat works with an overlayfs file\n");
>> +               break;
>> +       case KSFT_SKIP:
>> +               ksft_test_result_skip("overlayfs not available\n");
>> +               break;
>> +       }
>>         return ret;
>>  }
>> --
>> 2.54.0
>>

-- 
Best regards, Pavel Tikhomirov
Senior Software Developer, Virtuozzo.

