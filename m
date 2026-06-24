Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11021135.outbound.protection.outlook.com [52.101.70.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E789388369;
	Wed, 24 Jun 2026 11:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.135
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782302347; cv=fail; b=YSlNwtqOysNJhKh3h6J4WsU6+jW+7s56ER+ROLKjO6RftL1QQp6ZYM0is9B9aHduMkSE0ssFdJlqE+V+9QJZ9RgTIZtowQt8i4NU0QLCsPNA6p/4Ge1h9n2EIROaaGEkZ8X8LckH7R/lsuYxiRcVaiCD2+mGW71UiPZjzXDk0II=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782302347; c=relaxed/simple;
	bh=EwiJBa/y2ZqJd5b4OBIAHr9EyzjTeJDKJ2z+nVelKrc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LSBi+rFNxLwk8+ooZ8SxqXmEIFII47TweLbXY93Jcww3HIICxXxNZqCD3Ka+IfwyWRXKNZbmEbsAFJM8mYxfM3R6GvJqBTd0Fy6/WilFvlFl4MiwyyyKeGxWmdtBrLk4BVrZsggKG03//lvn0ae4nCTxqobLv2gB/9MUcMXkcpM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com; spf=pass smtp.mailfrom=virtuozzo.com; dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b=v/qEfqU6; arc=fail smtp.client-ip=52.101.70.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="v/qEfqU6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yy+zTlnPXP41aDdTqdgpo9JRbXIYhmoW3JjEqoxcQn7kkFjHFFp5FjDzuVPcipBH2zhvDrbqzXyoO6DeU6qXcPsmPTzfeAV2obUhgmnI22GJGpHe1pgSg8ra3+jmZmXlOw1J90IJYPngNplEHKwzx2elyFNoglrepf0HD8h/ZIGg2oNy2eU2U9f3E5RlQ4rWE4PDGN6mrs8lfdOg2ncGLc/MJQRoQyWY+kZ6mMEEerJqVXNLHv3iwz9ruZFfaEvNqRzsDQLubSEcL1/EsMC/rQhHO94T65HJySJNjw9sOC5wYG/zylYUX+vBUilF9FAb/MQ/sxlohN0jRMZpn9+XHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PXQYMdRDm1ElR/po0ADuZJ5QrMBbdBxtrTVaCoaq0Po=;
 b=bG+8soT6wV9GMBav4gZCt7OUzrMb241bC9XwAWUoEfuGT+F9uKbcigVZqgdoXBX81dHGYweD5dU5QUr4IMt74/SsqdvjmLNd+/4qK4di6IhMioGl84dKkGiY8KcQXbFDs1jVmt003n6u7gxABBOtWn7By+uaE1/iUA1CrgisNJhCVv74djLN8HJDYvGWiNG7cnkIG6j3yqPS+hk7bbAjmqoH9PnLRBLooHorW5KfoXt6j9kvhYgTCYNHjAU6jf8fWDpw44eZUpmSgFrTR6xSkij7a0f6hk8XS17oweMgN1ne5k5PWTeIOHGkYkr8Z2o5ISj7hinPRKD15luR+hH0VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PXQYMdRDm1ElR/po0ADuZJ5QrMBbdBxtrTVaCoaq0Po=;
 b=v/qEfqU69qMrC3L8ItklcwYTo8b+lHUkMmXiYrRUmYsz89eVyO/vjG6CgSnRqY23GNkFCQ9eQeJUjFAT8ryAl55HoeNX2l6rWrdb5W431DEOPGkIG0csFccfINq2hmkSL872yoQVfGAOc2O92WJ8ZjH6C+YK9kx8caZAYFcReXVuCtuOt1keZT6sV/wKtNAhnZghMhQnTceHAIAOk6MF3kpamNHJ90nMvlxmaLMeJFTbDCwIt7ZCoYCS231fZdQIQAprSyMZgH7GRjq2bomzcZ/Ciq60Ni2hAe6MAn1tCKFwmWW45YrxAGWYhfQbMxl2PdLks9o2feHdhb1ztbFA0Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from GV2PR08MB11819.eurprd08.prod.outlook.com
 (2603:10a6:150:301::23) by AM9PR08MB6196.eurprd08.prod.outlook.com
 (2603:10a6:20b:283::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.15; Wed, 24 Jun
 2026 11:59:02 +0000
Received: from GV2PR08MB11819.eurprd08.prod.outlook.com
 ([fe80::cf17:c42a:92:b6e3]) by GV2PR08MB11819.eurprd08.prod.outlook.com
 ([fe80::cf17:c42a:92:b6e3%4]) with mapi id 15.21.0159.007; Wed, 24 Jun 2026
 11:59:02 +0000
Message-ID: <5c7e8c24-0981-4677-aa42-9a74b67bac04@virtuozzo.com>
Date: Wed, 24 Jun 2026 13:59:01 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] fs, mm: add ->cachestat() file operation
To: Amir Goldstein <amir73il@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Miklos Szeredi <miklos@szeredi.hu>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>,
 Shuah Khan <shuah@kernel.org>, linux-unionfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
 <20260623111533.2285005-2-ptikhomirov@virtuozzo.com>
 <ajqOyIA8tPQsxfz6@cmpxchg.org>
 <3f6392aa-c1f6-4263-8892-978dacbbd8ca@virtuozzo.com>
 <CAOQ4uxhras5YAr8_HBpuHSDwvfiEF8vAr0NDB0R_PXtGDhnqjQ@mail.gmail.com>
Content-Language: en-US
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
In-Reply-To: <CAOQ4uxhras5YAr8_HBpuHSDwvfiEF8vAr0NDB0R_PXtGDhnqjQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0447.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:81::26) To GV2PR08MB11819.eurprd08.prod.outlook.com
 (2603:10a6:150:301::23)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR08MB11819:EE_|AM9PR08MB6196:EE_
X-MS-Office365-Filtering-Correlation-Id: 38f2acf2-602b-4d96-bff1-08ded1e7fbdc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|10070799003|22082099003|18002099003|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	gMG82wNisB24xGZqlDs+JR8hHgVv9hQpP23YViXfPs3z0pIEA4qJ3yZIaFAGR6DLJUyDRIieBGuEHHCJ9UjtBcnyaRNHbdoArpcirj9uvxqmpzDnvrm7Mk0Ui0H8yoDbFxCVlR90Md9BEHXEGWHekXIWpczTuWvDxg2kTU33UBeiVNvnGQbf/oJFXUJXoXBaEymEnM3YBBNYYvXZuxMZuyG73DOcaFbR/vW8u5TGDLnTNwsPKD31ohJ3Xz/Z046DdOnJv8eSD3GzfGJO8Jw47rXPzJm9b08qKUNiflCbzrmaBApefnddGAd6B1Kr3Tl0rWKGZUJH3UcjOQ9l+0FwMLXAZdIFdp+5Ap7cVutW8c2QYGw2S+nGZdOxH1BWJn3hfu6JT7w0AAu6+DZEhLPO3oZhLcNTXX1l9yF6j6k1m7LYR95auLxjLzG7wRzg5olXIl/EK8kTkbd5lCmZbpyHriQ6Eck1hwTtr2NVEQ6hMihAC4E+XzH+GSyoSd55DBynK3SC9Y8wOzyDIwMPhJ3NFXy1VGWf1zDkle+XwdpnbsGIHuyFFwC7fkyPqqV/2F6UpiuASHVLyjIBBqhcR+NWGoRUmT3cpbp0jzR+tlI5WnnSj9pYwpxE03s8NcShNrd/BQvBaN3nQpbY7gyzTrYJ9H0Cc4YLqQC0S2GUiYYARak=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR08MB11819.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(10070799003)(22082099003)(18002099003)(4143699003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?anJ2WWhhalhDK1ZvcThINkdpdHI4MnIwQ1FUUUlCSWlkSEtXNTduK2tMMm1w?=
 =?utf-8?B?UDZLS1dWMTlPbzg3dUpac1VnRXlHcWZ1M0QxaDVkN1Yva0VKNUJqbGlDcVVm?=
 =?utf-8?B?Z0FaUm1ZenZWNk1pMWg2MGNTeC95dEpOSzhVRWh4R25TbzBrSkpqWjBiWUtB?=
 =?utf-8?B?bWN1SGFjMTl6bjR4TWowckZ3dDJqZHdoVDhoNlRsc0MzUjl4WjRZWXozRFNE?=
 =?utf-8?B?c3l3cGFFWDFvR0xtSEhvQjJibnhCVXVtV0wvZGxwbHpsZ0t5NFlyYi9PMktz?=
 =?utf-8?B?bGVtQTRIUW9razl0OStMOXFIYkdhMXdmWjZlQi9BOXhqMUlScEY3Y1l5N0pn?=
 =?utf-8?B?U0tncXJxaGxPNGVWeWU3UzRqKy84OU9HTW90VEpzQTdvekszMUw1RDFYZkVV?=
 =?utf-8?B?N2NHQ25BMldqT3I1Vm41Q2tTdWFIUEVwS2xGemRlNkNyZUZsVm40MFNwNUlt?=
 =?utf-8?B?L0xkTWppcGZQWTN1SHFxcFJKcHFJd1BGUnhpUTdmdWtSSmpUR2ZRUlRVQ3Vi?=
 =?utf-8?B?WXArTUc3ZUxmVXVQbzJvTFd5ZmN1eDJXVGRyaVhkSHlxWFJEaSt4TFdMWWFn?=
 =?utf-8?B?YjNGbzhjQWFIRjdycUJ4KzRHOGZOS3ZXZTZ4MWhoZVNkTDlMM3pRRXg0M3FW?=
 =?utf-8?B?NmFmQ3Raek5uS3VUcmlsWXJ1TjhtbGVEZ3BsSkNTcWNleUYxa01wanFROHlN?=
 =?utf-8?B?UGppSGhIT3V3Vm1uVDdPWk12dkVQYVpvTWJHMER0K1FXdXYxTVhpQnhGVmRV?=
 =?utf-8?B?VHF1Tys2SUpJcEl5bzVnNlYwTWxnNDhVZFpqdmZKVEpUTGNmYmc2VkhPTmpM?=
 =?utf-8?B?a2JnSEF3anF3WVRXSWR3SHNVa29CWDMzMHBzYUlvZGVxN0xlU3pQeXVweGdB?=
 =?utf-8?B?b0lPMEUyL1ZYbjExOGRSY3M0UkIzSmZoL2pycjhCK3paeUdCcHkxa1BmZ2pT?=
 =?utf-8?B?NjNWNEI0d09WM2YzdnZPejB6NmpGZExBWjdQMlBwV3FTZmlQYTlCcHAvaElC?=
 =?utf-8?B?bXhFaWFiOXRBaVNrVXltN2drZnUxcmxYUzhCSk15eEh5V2hqdVRjZE5ENXVi?=
 =?utf-8?B?MjdreXFPeXhadU15VXZja0M3TWlObjFlVHJ6eVdiYkRZR0VVVldhcEhaclpv?=
 =?utf-8?B?MlFFWnlZR1lBSWdMZ2hTRG1PdE9IdWpnV0J5M3dBTUplbm83Y0w4UXpzWDcz?=
 =?utf-8?B?amR5MmpsMXlyWUpFY3IwN0FOa0ZrTGZtbFAzbjJLSk1IdWFhcnlPaG9Tbk5j?=
 =?utf-8?B?eE5oRHFsb25qNUhIVXQ0MllSTDhxRVE2OS91OGdieWR1ejN1OU5YM2V6dUEw?=
 =?utf-8?B?ek03b1ZnSDE4RlF0N2c2dDJtbWFESGNIWWRyb2ExK09BSXQ2VWhtQlh6alU2?=
 =?utf-8?B?VTRiWlpORkJLaGVSMmRhVTdyNk0zZy9yYVdBb0dDMmgzSjJid25RWWNzR25w?=
 =?utf-8?B?VzBIS3lrSUM4VUtXSkd0dHBiL01VMUl2RnFhRXdDK3huQUplakw2WGF5TDRJ?=
 =?utf-8?B?WUIxZWE4bUpORWI1aFd0dXJIbHd5VmZOZXZ6cVRVRFNmRjd6Y1dvNTQ4WmVP?=
 =?utf-8?B?T2NrVkI4VHh6M01FTi82OStObTdILzhKMnp4TVJhQnV6SGw5V2VjR3l5bzBX?=
 =?utf-8?B?aUdSK29wd0M4U0lhbzlxcmZYdGd4dGxwa1JBNlpqbWF4Tmlha1Z3Z2NTemY3?=
 =?utf-8?B?QTd1dWx0K1diNTcydHJZWm43RVJSSzhTS29UdkxjN2ducWFFK0kzS0dOdTl3?=
 =?utf-8?B?Z09mOHdkaGloeGpVVXNNVk13enN0OGZaQ0hidUo5SVQ0ampSNWZUaGdCdmFm?=
 =?utf-8?B?am1GR0dFVlhhak93dDBabUYxM2N1bjk5OHVMbEV0WlhxeU5CWVU2aGphVnBW?=
 =?utf-8?B?WG5QaGRSU2piSG0yRnNWUGlXakViVUtiRVZnTmhRcGt6bWpQYllZTnltQllX?=
 =?utf-8?B?UEZKZm56a2R2WityelhvZHNXWWQyWUt4OTZ6bktCcHBuYjExb2grQXVvTXNN?=
 =?utf-8?B?eGUrazY0Y0FxTGVYd3ZRK2FVTmhtS05IaUxXVERvUDNjcXd2K2FFVWp3amsx?=
 =?utf-8?B?QlFtUXY2NjlPcm1ycWxVVGtpQjZvakFzMG4rTFNVTUpOV3FybEZTaHRpZlVZ?=
 =?utf-8?B?eW8wWWErdUtBYVNVZHVQeXVocnVuVFBBOWVWd25ua3dmdXBrUnEwdXVicXNF?=
 =?utf-8?B?dVFaZCthbnBEejRhN1FUZjlWVGRCYlI4dG9PbGhCaVNGS0JMZUFPM2U2YTJR?=
 =?utf-8?B?dFJMTW5PeU1WMmVPWHQyMlZWMjVOV0hOL016K3crL1poMTBRTHl3ODYyWkpK?=
 =?utf-8?B?U0RNUjlKNTZ4d1hnU0w3RnZsRGZJMHA4RVNLaWNHYzBHcFI2c3BvVjhIYnFV?=
 =?utf-8?Q?A9BKjnBvHDyn95Vb6N3821gs/ckRrfWx+tfJPvyUFq9h2?=
X-MS-Exchange-AntiSpam-MessageData-1: 1Xzn9oCyQnRsdvbh7laRAfFgpsAI/X2pEes=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38f2acf2-602b-4d96-bff1-08ded1e7fbdc
X-MS-Exchange-CrossTenant-AuthSource: GV2PR08MB11819.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2026 11:59:02.7302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nMTpjUYoDwhVmOZ+UT3PB+iiZxUmCvUyzp8ov7Z3aUvjVcrA+iYP1dGgZQKM7wB0HML6nUzISCLaYNAph0i26ZSlG2DKOXFfOhSek0Ojh+g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6196



On 6/23/26 17:34, Amir Goldstein wrote:
> On Tue, Jun 23, 2026 at 4:55 PM Pavel Tikhomirov
> <ptikhomirov@virtuozzo.com> wrote:
>>
>>
>>
>> On 6/23/26 15:48, Johannes Weiner wrote:
>>> On Tue, Jun 23, 2026 at 01:14:48PM +0200, Pavel Tikhomirov wrote:
>>>> The cachestat() syscall reads page cache statistics straight from the
>>>> file's f_mapping. Stackable filesystems such as overlayfs keep the data
>>>> pages in an underlying inode's mapping rather than in the overlay
>>>> inode's, so cachestat() reports all zeroes for them.
>>>>
>>>> Add a ->cachestat() file operation and route the syscall through a new
>>>> vfs_cachestat() helper that calls it when present, falling back to
>>>> file's f_mapping otherwise. This lets stackable filesystems forward the
>>>> query to the file that actually owns the page cache. No behaviour change
>>>> for regular files.
>>>>
>>>> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
>>>> ---
>>>> Note: Memset change might be a bit tricky, I moved it to no
>>>> ->cachestat() path to avoid multiple memset on nested overlayfs, that
>>>> means that ->cachestat() is expected to be able to handle unitialized
>>>> cs.
>>>> ---
>>>>  include/linux/fs.h | 10 ++++++++++
>>>>  mm/filemap.c       | 43 +++++++++++++++++++++++++++++++++++--------
>>>>  2 files changed, 45 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>>>> index 6da44573ce450..966b6564707e4 100644
>>>> --- a/include/linux/fs.h
>>>> +++ b/include/linux/fs.h
>>>> @@ -53,6 +53,8 @@
>>>>
>>>>  struct bdi_writeback;
>>>>  struct bio;
>>>> +struct cachestat_range;
>>>> +struct cachestat;
>>>>  struct io_comp_batch;
>>>>  struct fiemap_extent_info;
>>>>  struct kiocb;
>>>> @@ -1963,6 +1965,8 @@ struct file_operations {
>>>>                                 struct file *file_out, loff_t pos_out,
>>>>                                 loff_t len, unsigned int remap_flags);
>>>>      int (*fadvise)(struct file *, loff_t, loff_t, int);
>>>> +    int (*cachestat)(struct file *file, struct cachestat_range *csr,
>>>> +                     struct cachestat *cs);
>>>
>>> I suppose you can't just have it return the real file because of the
>>> with_ovl_creds() scope you need during access?
>>
>> Yes, AFAIU in overlay when we use realfile we should always use it
>> with_ovl_creds(), even though I don't think there is anything cred related
>> in filemap_cachestat(), I still think we should follow the common pattern
>> other overlay helpers use (similar to ovl_fadvise() and ovl_flush()).
>>
>> note: Actually some places get ovl_real_file() and use it without
>> with_ovl_creds(), e.g.: ovl_read_iter, ovl_write_iter, ovl_splice_read,
>> ovl_splice_write. But those look more of an exception than the general
>> rule. All other instances use with_ovl_creds().
> 
> Use with_ovl_creds() is a good practice to keep the mental security model,
> but it is useless if the security check (can_do_cachestat) is not in the
> vfs helper (vfs_cachestat), so please move it there.

Totally, I feel stupid now that I missed it originally, will move it in v2.

> 
> Also it kind of makes more sense to check (flags != 0) in sys_cachestats
> before checking permissions.
> 
>>
>> Also there are simingly no other file_operations which return "realfile"
>> for further processing, mostly the operation from fsops simply replaces
>> general operation with its own logic completely.
>>
>> Thanks for your review!
>>
>> ps: Hope overlay maintainers will correctly if I'm getting this wrong.
>>
> 
> I don't think this is wrong per-se, except for can_do_cachestat().
> 
> Just be aware that the real file could change from one cachestat
> call to the next (i.e. due to copy up).

I guess the copy-up between two cachestat calls is an equivalent of cache pages
being dropped/reclaimed between the calls, right? (I assume old pages will not
be used anymore and will be reclaimed in due time.) So userspace should not be
overly confused by such a cache usage change.

> 
> Thanks,
> Amir.

-- 
Best regards, Pavel Tikhomirov
Senior Software Developer, Virtuozzo.

