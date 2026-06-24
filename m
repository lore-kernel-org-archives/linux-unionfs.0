Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11023127.outbound.protection.outlook.com [40.107.159.127])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0ED327603F;
	Wed, 24 Jun 2026 11:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.127
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782301575; cv=fail; b=m3697txyWJ0tFI5FsUGLmHGAIlZ8CV9/l38m8pM8+M+hZWZFHT64DMk4trNDs2lS7Epwz/3tw0b1CO1HBS19x0R0wrzHgaOW8//KhDGVQIZTsaCLcSotQtvFNUUe+MQRjBPwLhRSw/7oLipG8V1jp+zMhtye9GWtbDTrOboKz7s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782301575; c=relaxed/simple;
	bh=kpn9Yh4gMLzEZa+OwEsyqu4uARGSt98pgj6WszA/X7w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uJxTNx4EbX+ni6lGkPAYl9pZWf5AHgV7exdHgbSOUj6AoIvAT/RBtHnoGNABIIv/YmU/Wv9GPcNHU7aLpNMv0tgt89LQSX4TFEhyIhNOVaiqTm7KZFLBYkeMRLxAteakRAQNYJzijdgI0iUbw1jmeDhDWRbt0SmLk95GbhRNUP0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com; spf=pass smtp.mailfrom=virtuozzo.com; dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b=JyGskMnz; arc=fail smtp.client-ip=40.107.159.127
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="JyGskMnz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sR3ExQwNsXNe8z6vn7mkJkjOwZrkdVo7hS0dg+Qdk8vnbBTR42D9a4U7kccqZuZkHwwx7YUAEJ/SbtQyLhlBInU1wc1WY4HklmBgjf1Ut9+m/kWL8aWJiqzHq7ZmOfsOCKUT+RrqiC/qicgcBpyGbBKEc5nF0CzpRaS+wQZe7NAeOsMi5pljfWKJcbQJZwMokctkVaxQlXjryywbwxxzUjsNooazlqjx83VyL0Q0xliigkWohRET+bmWmTdmkqQPWZ+T7z0cD7wlV6l5Y1OdhzrcyOGdkM7vf4i6vQaPR4egd+dZkco+I50Gw3bYKS3HNz33ly9HN4qQaFAyZyVamw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+07F28CPE+PL9VGIi9CeEflcclistzlB+O/xMytf/4s=;
 b=l6r7X1m0jmfcSF8VPRLTJzfXbaCw/Qin+PGTwEP0zHflh4RvizvhNCao8ujhAUP4Mw3AP3/LlS7bAo8GkdIOn1iAxf0WM2FT9wbpl6uMO97V9y+3FxFKGy7jjhWMqVR1ARvvvruObFaauhAezSQM77Ytam+zUp+up+w0Ph4UQrrmXQkGtbx4RfwW75HTBFv0M7rOv7qdsOO9V4QODUHgvXLwHsri3Z2xKJOgdVkL9PJOwA2+D5VkHykmBmNUNYX/Jz1oGKCd2UxmOFYkqzefHh6dPQEBMGkEbR65PRsX+8gqzcm7KteOzBZVcLUzrCyGLX38IG/yigg6bDK5yfslOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+07F28CPE+PL9VGIi9CeEflcclistzlB+O/xMytf/4s=;
 b=JyGskMnzwzqKrGqIe1rHuujEJLqeY1/xjwqZSh3jbX05JxErzsJ8yS7PdusPaBcmSDkKQ2bomrXVwGbner2S7TjMM/Zgxbutqt1LdydqS7KQGwNHdLIUQyGtNDFjW5A7GgeL02MFiEiVeMbS+eIJPsGc8fYRTf96RnNRRPiV6kV2Bef54B9NXgZ4kgO+FBRW65ZsroV4VHod3Kk26BeR/ztrEYDRt/aaQYtUCzIky8ucCl+QS9o+VYTJQ3E1qe7Q5XI3XsA+0t4vFyAyoXNbQ5tMhO6CfZuSuGX/MEv4tyfja/JvEWI6KzdFieuGz1Tf7P8ILJRPPicQEuVdDMSAPQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from GV2PR08MB11819.eurprd08.prod.outlook.com
 (2603:10a6:150:301::23) by PAXPR08MB7465.eurprd08.prod.outlook.com
 (2603:10a6:102:2b9::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.13; Wed, 24 Jun
 2026 11:46:04 +0000
Received: from GV2PR08MB11819.eurprd08.prod.outlook.com
 ([fe80::cf17:c42a:92:b6e3]) by GV2PR08MB11819.eurprd08.prod.outlook.com
 ([fe80::cf17:c42a:92:b6e3%4]) with mapi id 15.21.0159.007; Wed, 24 Jun 2026
 11:46:04 +0000
Message-ID: <32d45066-060e-4f8c-bc87-acb18ac81d60@virtuozzo.com>
Date: Wed, 24 Jun 2026 13:46:03 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] fs, mm: add ->cachestat() file operation
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
 <20260623111533.2285005-2-ptikhomirov@virtuozzo.com>
 <CAKEwX=Omr29YZ+ZtDXtVLKQVoinGo3y9xWBJojRCBpewgswycg@mail.gmail.com>
Content-Language: en-US
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
In-Reply-To: <CAKEwX=Omr29YZ+ZtDXtVLKQVoinGo3y9xWBJojRCBpewgswycg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0348.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7d::6) To GV2PR08MB11819.eurprd08.prod.outlook.com
 (2603:10a6:150:301::23)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR08MB11819:EE_|PAXPR08MB7465:EE_
X-MS-Office365-Filtering-Correlation-Id: 713a6973-387b-46c2-58f4-08ded1e62c10
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|10070799003|23010399003|1800799024|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ovBcxPEsXplx1dIDEAycQzOJsLJ7vlyIEtK9Vskt4FL8/+bE9opHqqFvVrpbESJIAiAnYjmjjbpFljxKZ3E7KO3jKw+UwqQR7hBcqgf37mlX+o5VQiuDrU8+aoWkBa7T46Osq40C1EIdmawMJxZWasDbCxCtV0f6NIPRyOgU1mNm6u6HRD88djwOxpgU8lLWxuHTXUiBkERrn0Kr+Tf73bjBpFHSU2EE+rPbAxVHpsEiIBLb2DwEsc0e/kkC3dEe8mNCgghfQs8BtW5ugfHtTYgDvtU5atwqKL8GEvJoVOgdDhKg/64awiasDU3UQlb1nc7XPft2K++MoWZPyoLyG9fFYMS+u/xqCel9955tmTc5ef0WaNNAQKW643jdCTMeV6S5Asc2NmoVMotUoaxAvXjlvrrz/Dwo2lzDETi7MIour+BKZipmvJVPyYSAF/HunItcy4I7yO2ibMCpSoQrVSIm8BaKy0ddoU2JuIQiJ/O5tggM8vIviMYV+99r3LihRqL0F3/biLJVupY3akCz4fqA04zE6zvc8CTYV/vbaJLNEGYRcTia30mBVnv1pB2V7K0CCvXb6OYZKZ8SK7BVorm37VcOQhYClMQ0GfIezf7J09c+kioMsHeSfkxyjd/xI95gk9wnVabsdrGsrfAaBhCMM57itmCZIR/poAiUXx8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR08MB11819.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(10070799003)(23010399003)(1800799024)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cTM2aURsdjIvaWw1ZU53ZkpkSGZ6bjFvM1ZoK2lwYTlzZEJnUmY3d2pXVGxC?=
 =?utf-8?B?VXhlU2F2TmxsWlN6aE1xWno3Y0J6cGFSRTRta3FieGtFaVZLQ2dpN1pSQ2R4?=
 =?utf-8?B?UnkybGFqUDl4blJuV01sck96QmMvQUFWZGcxT1RFeVBGU01OQXg2SjdVZWFz?=
 =?utf-8?B?b2lYdkluYXdQa2NTYmxYWEg0a0hRK0k0dzkzZCtuZ1FVUE9kVkFydExsL0dV?=
 =?utf-8?B?OUZFTDgxLzcvVG1LRC94UjYzTno4TUtpb3c1YjAvSWErSWxGZU5yVHFOWmts?=
 =?utf-8?B?YlFBcndOWjlkNzVBL0FML0pPeTBXbzBNQS96b3MwR0YvazIzbHBiK0c2Vnps?=
 =?utf-8?B?SmpzY2ZBYjJCUGlGTHFSL0I0R3d4UTJ0b1BkbzNpRnhCcjJDaGxXNlhpVmVk?=
 =?utf-8?B?NHRqdE5NeUF1aXIwRXUyaG8zTWE4ODZUd1F6RmNyMWVZMU03T3h2OTYvcjBz?=
 =?utf-8?B?OGJTcDhQbXZFQlVBTHRKS0ZWZE5rbDJERkJOL1NIWDdJZWJwKzVPQkRtT011?=
 =?utf-8?B?ZGY2TFJ2RGxzRS9PVkJQOTFud0UrUU1MbmhlRkl0eFZRU2I4WlpwaGJoWVkz?=
 =?utf-8?B?enlpREYzZHJVMmNlOU8rVVRod1BtSVU1OS9ZYUE0QkhoMnk1RXAwSzdHNXZu?=
 =?utf-8?B?NGtzWkhxZ3c0c2ZMSWlYcWUrTzhGUngwUFFDZlVQVWdoaHN3VFNaN1RLOGsv?=
 =?utf-8?B?MmUzYmNrNHQ0VjRKQ05BdzhHdUdmT1NDbVNSV1dpNEhpenQ4ZUphL1RwS29W?=
 =?utf-8?B?amVkZllIRW8xTzNNZ3BzL0g3bk9YRGdiWC9pWFZVUjVqVmw0cXZNMytPMjRs?=
 =?utf-8?B?ZGlyRzJFLzltTzZHc3V1bmVCY0VDTFJPWW1GOXpYS0JtSUdJcGV3ZUs3cGVh?=
 =?utf-8?B?c2R5cGh2ZmdxOWZNdlBkeVpQNDA5NllHR0dJREJEK2RBK0h3NU5wNzQyVnAy?=
 =?utf-8?B?NmJFVk0zbFhRSzI4MmdaK1BvUnVEblFvMmlLaGR2ZGdMVmszT0M2V0Fna3E3?=
 =?utf-8?B?V0pRRFRkWTA2U0FHakpSOVB2ZGNJZDdqZHRISGRDWklxdmdFM01MODhvcGNU?=
 =?utf-8?B?SnpMb3AvNk9mWUUwVkFJMXhvOFk4UGtLQ2xhbmw2VU80aTRHZ1pzZ1VmeXVY?=
 =?utf-8?B?YWNNMFR0RnpSSGlDM1Q5OFpUa3YyZG5XeWRXbFhrYXB3SU5QMjhSdndCYnI0?=
 =?utf-8?B?Vmk4RTdKN3Bmb3hwL25HNkRhdUdFU3BkL0IzdHU3Smh6d2ZuUitpeXM2VStX?=
 =?utf-8?B?dFRkSTVDZWYzb3dTQ3RHc29oL2JGRTVFTTVuQzJUODYrQ3dORzE4bDFLNmxz?=
 =?utf-8?B?Nkxycm9XaCtBSXJIV25TNFgwNVVUN1lqL3VhMTF6RkUzenBsRkNGU2tBa0pr?=
 =?utf-8?B?WGwwZ3d3QnI4VDU3TlFJMi9xaEpGb0l0SVk4TU0ybXVFR0MvakNYbHhobWZq?=
 =?utf-8?B?cHNnelMwRFFTVFo1WFpXaGkwaUg0a0xlWmdRYnY5N21lOTVwQ0lyQU1salpr?=
 =?utf-8?B?bXEraThyZVM0NVpGQy9GeUVBbU1CTWVEYk9RVnlCa1VBaGpxditGdzMyMTBl?=
 =?utf-8?B?SXlzb0xRcktiS2tLTWtJK01ZNHNLT1AzWDZSQVpoaTZ4RWJxWEQxanA0ZFRD?=
 =?utf-8?B?UDd0djd5M05lYlBLYWJ1VHNIS0F5WWJoRXBiaThuTTlCUXFlRHhnQVkwVGpK?=
 =?utf-8?B?WXdnelB4RTBFWXVQSzZTRmY1M3hMM3RoK1VpRTZUTEd6OW54ZnFnRktHTFlU?=
 =?utf-8?B?SUk4RTFYSTE2TEU5RzN1SVdnOHFldmxZdWFVd2lsaE9GNG5TcU83aC9UZGFx?=
 =?utf-8?B?Q0I3ek5kT0ZPblAvQ1piY3dsUzZKN0ZBQkl3VU9zSXU2OEFINTIwaFpuUmRU?=
 =?utf-8?B?em5YdE8rSEdEeGNadkhDK281YklXQ1E3SmMyaWJ1RXdiZkhTRERtVHRIMTAr?=
 =?utf-8?B?cWlVSFdGeWdLQWlOTzFTbWpMd20wQVNEOUI4Vng5azhyaUpoalJYVGdaQXZX?=
 =?utf-8?B?Slp6RGxtYXdkdjJ1Rm9kRkp1NGxOUHd5cnRhOHlwTlZXZVFXcE1LVHFCMk9k?=
 =?utf-8?B?RTNxWDcvdWw4Y0VTY1E3dmk2cTY4WlRUTjR3QUZPN0lTcUJrdjNDNDBtQWdF?=
 =?utf-8?B?a2JHUWRremdHL1ByS3hOM2pycVJJSmpNcE83OVdoVmg0VFFqVm5Ecjk3VzBp?=
 =?utf-8?B?ZnZEdWhFd0UyTytLZFdiZjAvQm00U3RyWWZGMVB4eUg5ZUVkUXVNYWlTaE1u?=
 =?utf-8?B?MHUrTGErQ085T2pMUk5RckRkQUdDVU5IbzhLdHI5Sk4zdTJWNFBmRXUyRWN1?=
 =?utf-8?B?dWlMOHR1T0IweEV2dE9Ec3Z0bXcwYmMzTzdUa3F3UE1CODE5KytlUVQ4bVo1?=
 =?utf-8?Q?avDKjM+nMts2cNgv91N6Vg5L+45jRXQd45XgAZSTHMR22?=
X-MS-Exchange-AntiSpam-MessageData-1: mXDH8EXiCrXU3BurtVxl7GH4kvkSsGmPqxo=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 713a6973-387b-46c2-58f4-08ded1e62c10
X-MS-Exchange-CrossTenant-AuthSource: GV2PR08MB11819.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2026 11:46:04.6054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y5uhJOv0tFVCodtLowpaKeM5hA5rAQ64PTi1rYErNxVhmEAXg9tOCDNt25ULlB9Yn++92INxbulupN7VMUsefK5/YyZsYGMYOvZLfbYpEf0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7465



On 6/23/26 18:01, Nhat Pham wrote:
> On Tue, Jun 23, 2026 at 4:15 AM Pavel Tikhomirov
> <ptikhomirov@virtuozzo.com> wrote:
>>
>> The cachestat() syscall reads page cache statistics straight from the
>> file's f_mapping. Stackable filesystems such as overlayfs keep the data
>> pages in an underlying inode's mapping rather than in the overlay
>> inode's, so cachestat() reports all zeroes for them.
>>
>> Add a ->cachestat() file operation and route the syscall through a new
>> vfs_cachestat() helper that calls it when present, falling back to
>> file's f_mapping otherwise. This lets stackable filesystems forward the
>> query to the file that actually owns the page cache. No behaviour change
>> for regular files.
>>
>> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
>> ---
>> Note: Memset change might be a bit tricky, I moved it to no
>> ->cachestat() path to avoid multiple memset on nested overlayfs, that
>> means that ->cachestat() is expected to be able to handle unitialized
>> cs.
> 
> nit: maybe a comment somewhere to document this?

Sure, will do in v2.

> 
>> ---
>>  include/linux/fs.h | 10 ++++++++++
>>  mm/filemap.c       | 43 +++++++++++++++++++++++++++++++++++--------
>>  2 files changed, 45 insertions(+), 8 deletions(-)
>>
> 
> LGTM otherwise. With Amir's suggestions incorporated:
> 
> Acked-by: Nhat Pham <nphamcs@gmail.com>

-- 
Best regards, Pavel Tikhomirov
Senior Software Developer, Virtuozzo.

