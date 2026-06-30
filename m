Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11023075.outbound.protection.outlook.com [52.101.72.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBB629ACF7;
	Tue, 30 Jun 2026 09:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782812745; cv=fail; b=aPu+bHqbIfvI7IP2X1e9s+PHOFfQ3k7pE9KxAbCh+j4guomZ03D+5Q3H30SzoSzbbLZIV0ov2cckEz1OUpHYmNiSHP5CqNhg3oCNcwbPgXXP2eceFMNeeBgl4U9JEh+1BPzKp401v7SObJ5tgj3qGBdtMIQf7jgMfoRS1fsGyJA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782812745; c=relaxed/simple;
	bh=5GbMqx1jaXdOtxURrlMhBHYckqKWzIS9muze/S9S4nc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=auxarNGg0f8Yap7hP1VVdpkLkBsSrAOXrq7/kiVEtteaLiq9mxz48cN9mP1E7uAV44EuDskD3CVTTKnARZzadqriTSIDBD2q3mr21dxEHUCuneJbrJpn3B/04I5QW057HyoaS1Kl6kjehKoe8HdcGlclA42rSOVKbleTzYI7qsw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com; spf=pass smtp.mailfrom=virtuozzo.com; dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b=F0++cj7O; arc=fail smtp.client-ip=52.101.72.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="F0++cj7O"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HAy0bwSyfwjLkQABUI9WQ6+UVyQ2Sx6BI9qvC3md7pi9gLQnFb7eYXMN29R70A9+7oI0daHDo3szxRykqY0Fl2lyGv8Ns4v9JvMP5gFW68zRI6vc8/e65koV1ZXDdvIv1icqn1a3WleIEaFsHX60U8xZIt4Li4jjFdEsaOL5sYK/KodHayuQKekUC/+haZFGjY7gY/hoL2WjMLMOjcni1jRrfejxOz1kJUBBYmbNRLihIMRVFZGZEw2L6+HvBGZ/rQsQdi323K6xpp/4bBpQI6lTJle9MN/HhgbZxXqwPn3YlyyZ9bPq4Y6LGLcFAUe02txwFwkxaaUX62S7VPtKVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9sp0A27jwgTu8QMIj5sEhN1ih4nrHHOv5GXd4HIXUyI=;
 b=Fm4DpILIFio3taPaotTr+AoyZddEuYn4/eZuU7ve89MPLb3JEhd8gUwSpE8mUN7zUHCmVAVso9arZ+fEKTLVq/Iz0WOQTGf2GSzMwja7hrDSX919U9R0isaAdL6C0tCESKg9Bzucjs3ua4JoNB2QhingGRMRJCxGw71xcT0QAgkjURV9ZbS4ueVEWD5AqeIRxOxnNWBQDMcspiQLhezPVwhO2l/1XIZDy4CAti04MRrNqOKcLrneJpAN8tx9zDmokzbmgzCoH5EDIXTuui+wAtNyD4CQLj7Z3CQBAt8TVvSRZ4HdilSHvkaslbcwLBn/r9odoKS1BuIi4ZHulkffqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9sp0A27jwgTu8QMIj5sEhN1ih4nrHHOv5GXd4HIXUyI=;
 b=F0++cj7OXQyOJ7vo1duApE36GB4op22PnvYVEcliIqzbqqvZf6ylsn43vVQt/iExo1orf6fQRmqH8sZVFEITedFYQonMnKrtT4JSrnPSNhXLIrjlfAZxxr7lqf8JOBfcVRSi8VAvvUSuLXdD3X5I0uKQ3Kkv4a/wHUCNibWIc2cNlohSjg4gVHeXi+8BS/05LkuelXngPitNuMYr/vbEUW8I8s70u7+glN4Ubw1hlrn5YUuQYh9UvbpmSEYiuVeVpPYpelKRFTBqs56kFdMPP93HME+EFqMdtcMt92VpRJYeEshkJRvoiPlrsvNHGAsaBf9iW2ECBUB20JeFodMpHQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from AM0PR08MB11804.eurprd08.prod.outlook.com
 (2603:10a6:20b:747::14) by AMBPR08MB11885.eurprd08.prod.outlook.com
 (2603:10a6:20b:75e::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.18; Tue, 30 Jun
 2026 09:45:38 +0000
Received: from AM0PR08MB11804.eurprd08.prod.outlook.com
 ([fe80::bf46:f137:f6d2:5b3a]) by AM0PR08MB11804.eurprd08.prod.outlook.com
 ([fe80::bf46:f137:f6d2:5b3a%6]) with mapi id 15.21.0181.008; Tue, 30 Jun 2026
 09:45:38 +0000
Message-ID: <6e7c1429-9f3f-47d2-8aa8-272ed0a8d305@virtuozzo.com>
Date: Tue, 30 Jun 2026 11:45:36 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] fs, mm: add ->cachestat() file operation
To: Christian Brauner <brauner@kernel.org>,
 Amir Goldstein <amir73il@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Miklos Szeredi <miklos@szeredi.hu>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
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
 <20260625-lehrbuch-gehalt-wichen-1b2f3533efbe@brauner>
 <CAOQ4uxiNrEZ8rsRc11mdjkMWe3dfThE0DJ2vXuO0yiNemnpR6A@mail.gmail.com>
 <20260630-tierisch-ehrbaren-errichten-bed402a0a26c@brauner>
Content-Language: en-US
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
In-Reply-To: <20260630-tierisch-ehrbaren-errichten-bed402a0a26c@brauner>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0445.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:81::14) To AM0PR08MB11804.eurprd08.prod.outlook.com
 (2603:10a6:20b:747::14)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR08MB11804:EE_|AMBPR08MB11885:EE_
X-MS-Office365-Filtering-Correlation-Id: dd00aeec-414e-42ae-d8e2-08ded68c5726
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|376014|23010399003|366016|7416014|4143699003|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	l4yeWcGq6Kwb8g4AoMRdsBRpUxlXiCpLdmVG3hBGf31lOKx8uT7oOOjcudDja0ugGPMM1NJqYGV6MUGk3g11ITNc1teftbisjH6CwjlJKvYAVBH1yXRryiAXzYi0tmoUOn+ITLov+szPQBLzeXOxtblbE5gSJPfLLzpQ0DGLw5/QzUA6WWezBduU5prcaC5MMWDQnEhAZ5s+k9T27ln4f2r/T4gV1B6GhECgQXlzfmfl2ata9wJv9JmqWoZ4vWQqA5/2qu8J26ZNx5qyXcCf+U4R/3FYHzk4jk09sRFRHLdstBOY71rB1Ah9p9n4Q2eN9BBD7ZpW2tDi2gUdthgtGbDtpqWqeFF/TrmPLE1nRv5YXAKQbfCMUAEXyQphZMJMLF1xUaLYFq0FZR17bJT4mGtNSNLw+upu47nO3VzIULbnKijJ3JuZdybKEJpdEj+Yd9v02V846akL1gz9E3Y+qOxLxi4Wu+3W+J8D7dfTWaKn+6JI5BZ1YPnhf+M2aSypxD+s+1dUS3fm6IRhxv33M+TLMnRYbFzzuFvjICtVm+YUys2yBjip8A9CUxryuLgvMT4lbHNft7N4pman+IMVIPEXE+8G3uz9cXqwiAensmrzUCl7fwaKXBJPB+RAJuu6K2qjXPZH7xdPCbxA47b7bNTADa94vBzb24nTR11yM14=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR08MB11804.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(23010399003)(366016)(7416014)(4143699003)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bkx5djIwb0FOYlpTbU5XSlVST1JDc1NBcjRNaTBrNTBFK0dNTHp6WTNUYXRn?=
 =?utf-8?B?c0RaVVh2TkZKb0JaaXhxcVROM3BEQW95Z1dacTlIOGIyS1hCOWZOZloydTc2?=
 =?utf-8?B?WW5HRGNhL0Rmc09jeGtmVXhYdmdpMXRHYjBJaHYxazBHYy9kK09id0lER1Jp?=
 =?utf-8?B?RUNINVVMdlZ0ZGF5MjBsNlFiZzZzRDZxS1g2WWFXT2xUU0VPeHFiWGtOdXUy?=
 =?utf-8?B?amxaZmtLN1A4OC9TRFc2RmZrYVhLTkNyRTlBbkI4T2liM1VlRHVCOVh0UStm?=
 =?utf-8?B?QlErem5iOGcxRk5mVU1lQnhJNUlkLzlwbnNnWDQ2S0dmamw5YlZjYUpmMDBI?=
 =?utf-8?B?VVRnc3JGdUhKWmZjQm5xbVgxL2FTSERGT1dMSnVCRGtiM3pVVUk2YlFRNUg1?=
 =?utf-8?B?a2pESDZzRnVBeW5lcHdBME5QUGovckc4VFJiTm1jNm9KRWJSVUU1OXhKcDFz?=
 =?utf-8?B?amlFVVl5eEd6djc3VEZZdXV1bmdSM21lcG5lQXIzNktwOWdmbmRSTHMyWkVQ?=
 =?utf-8?B?dDR3QUN3clNxL0hLS0FqWmFIYWQ2MDRaZC91T24vNnYrMG80T1kxb0hLUml0?=
 =?utf-8?B?UXc3U1BvdVZBZkpxVTZqdS9JQ3hKSmNwMzh4NFlOSFZndHpYZmNwMUo4bUMz?=
 =?utf-8?B?MHdFR1FCNWVnTjZDUHZ2MXl3RW9OSUVvU0dmUDd4RnFRRFRPdlFRSjNCK0tj?=
 =?utf-8?B?NlhGOVBWckhDakkrTnpSdzJtOWNFSkxPUDdCMFNrQllObWxPTERmU0RHdmpW?=
 =?utf-8?B?YW40TlBKYnVZaFVpL1pJdWJEYlZ6VWN1ZlVLMXdFZTZQZElQQ1E0Q0hhKy91?=
 =?utf-8?B?MitxZTdUWFd4WW5uUXd5ZHcrV3JkRDNpWWd4TjhmSDdFb1hXSVVGYUFmSlBj?=
 =?utf-8?B?bDJMdHV3TjhlQ2RSc25JcDlYZi9Ia2NGaEdTbUxqVzJ2VjVDa3dSdHFWSnlO?=
 =?utf-8?B?TlU1QWdNL3FyZENJT2hwTjZiTkRpZXo2bE5CNWg5UHM1eXFhUHExS2pWc3Vz?=
 =?utf-8?B?UlJZSHVtdS94UnhjaDRCNGVVdjZFcUVIOUVyWExKWGNWcXB4TzRWdGNHUkRF?=
 =?utf-8?B?M0lFcllGQms0ZHRjdXBJem05U3NKSG9UVnJ5RU4ycTV0cVZTOEMrR1l1L0Ry?=
 =?utf-8?B?Njgzc1piNmJZQU56ZG9ybEZKOHlpbGxkWlFIdlBCeTh6UThEa2VXUzlWWHVv?=
 =?utf-8?B?N3I4YjQ4S3Z0NkQ2TDI1d3N4L2RFQitiMXZKOFh4WEtBWWZybmJMaTVERUFv?=
 =?utf-8?B?Q2NybTExMGVUWDlXcWFWWVRvTWxXQ0c2dllOd0tmSUp4M09lNTE5b3Y2Zmxz?=
 =?utf-8?B?QkFqRzhvODhGNTVWRTJEY3JNVWtzSVJYUTVHeVhXZit6SDVJOTNvYlRSbEJz?=
 =?utf-8?B?cDhNK2tLM0tvMEZUbVlIOUMxZjdKOEpCUjFTeUw1UDZBeE8vTnNBc3daNDR5?=
 =?utf-8?B?VitUeDVlMSt4UXRSbHA1V2lSZWdoM3kvN2Q4V2huakxIbUxXR09PYm43OW1z?=
 =?utf-8?B?Zkg5Z3psSXhjWjVOejhqalFWcXRvOE16bW02Z3pJdVRabkpQRVhlVGgvN2lB?=
 =?utf-8?B?a0lDK1FFU3lyQ0oyREZiUEtHUWQ1Uy9oVm1BWm5VL3hJR3AvMFpkTUpPWmln?=
 =?utf-8?B?TkwwbU4zcU1ENG5jZFVzZmtFbDJYWDRualRGYy9CM3dOeGdVb0RwYWswaWxs?=
 =?utf-8?B?cUQ3eVR0UURFZGF3MEVXOFpiZnBhaXRCc1JNV2ZHTk5GVW11aS9maktXOU5V?=
 =?utf-8?B?bEhhNzZ1ZFFjZGhHd1lxYVpGd2E5Qkx0dGRJWm1Bd1VOU3ozb2R4ems3SG5H?=
 =?utf-8?B?UjdrUXl3RlUzWTNDQk5ERHRaQitnZ1FMZHQyYVhPOStHSjJqWDJTK0s2eERJ?=
 =?utf-8?B?YnFkZ08xbEE2MGtkSC9hM0tILzEwUjRsenh3ZmZLMG5DQ1ZISUI1MEV2SVlp?=
 =?utf-8?B?NE91Y3QzRUVnU3IxT0E2cXZiWHdHdTVHS2JNNDRGRnd3dW5JUnZnM0h0UkZC?=
 =?utf-8?B?anlMaG9UQWFUUkMrUFZDa2dWVEVka1V0TDB4V3hNQnlCUjk0NmVXQytaQlNY?=
 =?utf-8?B?WTJ2blB6YXJMdGl5ZlpnSDBxb0F5NE1ybjQrR1JDOUwrSG1TaHYybDhrdExi?=
 =?utf-8?B?eUwyRVFYS2p3Ym8xOVlQbW1kRzJ5MXFFMkRNT0RSRHQvL3MwN1Jtdk5pOE5v?=
 =?utf-8?B?amQ3cExyRDRYaWFtNmhrK0x5L0svNFVDakNHNXB4c1ZVTmdXS2dwNGpjQVJu?=
 =?utf-8?B?Y0VBNzJoZE5JUW1PQWs1UDZDSlFWU3I1VGFrb2NRY1pFcUtmL2E1Vk1aSHRZ?=
 =?utf-8?B?SWZEOXZKL0VqV044TkpMaElGdDJQUis1WXZYSTEvVXAxSHdqMkhRZ2pyeCtC?=
 =?utf-8?Q?/39NDHggtoHfHerFxiRS62afioF7EOiBt+UPMu+QT855j?=
X-MS-Exchange-AntiSpam-MessageData-1: a2U2DLBH0gXl/ibRNZ/gE0YTv/ecEbQWygU=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd00aeec-414e-42ae-d8e2-08ded68c5726
X-MS-Exchange-CrossTenant-AuthSource: AM0PR08MB11804.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 09:45:38.0346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fjKf6QfRZIyq5J+HsepIomRV6KPoEJyqAXJ9l8buxzmX7ejX/GudD5bPk7/62rR5tHzhbxQIBvYFjI11fnjjsR0rPgWu59zNTFuy85TQPzE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMBPR08MB11885



On 6/30/26 09:55, Christian Brauner wrote:
> On 2026-06-26 17:18 +0200, Amir Goldstein wrote:
>> On Thu, Jun 25, 2026 at 12:36 PM Christian Brauner <brauner@kernel.org> wrote:
>>>
>>> On 2026-06-23 17:34:47+02:00, Amir Goldstein wrote:
>>>> On Tue, Jun 23, 2026 at 4:55 PM Pavel Tikhomirov
>>>> <ptikhomirov@virtuozzo.com> wrote:
>>>>
>>>>> On 6/23/26 15:48, Johannes Weiner wrote:
>>>>>
>>>>> Yes, AFAIU in overlay when we use realfile we should always use it
>>>>> with_ovl_creds(), even though I don't think there is anything cred related
>>>>> in filemap_cachestat(), I still think we should follow the common pattern
>>>>> other overlay helpers use (similar to ovl_fadvise() and ovl_flush()).
>>>>>
>>>>> note: Actually some places get ovl_real_file() and use it without
>>>>> with_ovl_creds(), e.g.: ovl_read_iter, ovl_write_iter, ovl_splice_read,
>>>>> ovl_splice_write. But those look more of an exception than the general
>>>>> rule. All other instances use with_ovl_creds().
>>>>
>>>> Use with_ovl_creds() is a good practice to keep the mental security model,
>>>> but it is useless if the security check (can_do_cachestat) is not in the
>>>> vfs helper (vfs_cachestat), so please move it there.
>>>>
>>>> Also it kind of makes more sense to check (flags != 0) in sys_cachestats
>>>> before checking permissions.
>>>>
>>>>> Also there are simingly no other file_operations which return "realfile"
>>>>> for further processing, mostly the operation from fsops simply replaces
>>>>> general operation with its own logic completely.
>>>>>
>>>>> Thanks for your review!
>>>>>
>>>>> ps: Hope overlay maintainers will correctly if I'm getting this wrong.
>>>>
>>>> I don't think this is wrong per-se, except for can_do_cachestat().
>>>>
>>>> Just be aware that the real file could change from one cachestat
>>>> call to the next (i.e. due to copy up).
>>>
>>> I'm really grump about adding a new file operation just for a
>>> special-sauce system call which is under a CONFIG_* option even. We're
>>> not going to set the precedent of piling on custom file operations for a
>>> single filesystem everytime someone adds a new system call unless
>>> absolutely necessary.
>>
>> I had a similar reaction.
>>
>>> This looks like it could just use a new helper in
>>> fs/backing_file.c that the cachestat thing can call to use the correct
>>> file.
>>>
>>
>> I was considering suggesting this as well.
>> Having f_real_file() complement
>>
>> but technically, can_do_cachestat() should be checked against
>> the overlayfs file/inode AND also against the real file/inode with
>> ovl_creds.
>>
>> I'd love to be able to provide a backing_file "template" for
>> operations, but I don't have a good idea how to do that.
>> Do you?
> 
> diff --git a/fs/file_table.c b/fs/file_table.c
> index c68b8c0a4097..d93059d53e88 100644
> --- a/fs/file_table.c
> +++ b/fs/file_table.c
> @@ -57,6 +57,8 @@ struct backing_file {
>  #ifdef CONFIG_SECURITY
>         void *security;
>  #endif
> +       unsigned int flags;
> +       struct cred *backing_cred;
>  };
> 
>  diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 27cc07738f33..64e07ebc43b0 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -50,6 +50,12 @@ static struct file *ovl_open_realfile(const struct file *file,
> 
>                         realfile = backing_file_open(file,
>                                                      flags, realpath, current_cred());
> +
> +                       // Raises ->flags |= BACKING_FILE_CREDS and sets ->creds to ->backing_cred.
> +                       backing_file_set_creds(file, ovl_creds(file_inode(file)->i_sb));
> +                       // Now add a helper that performs permission checks on
> +                       // both creds for that cachestat() thing and returns
> +                       // the actual file to operate on.

I'm not sure I fully understand it, sorry.

The idea seems to be to replace file operation customization helper ->cachestat() with some way for cachestat syscall to access a backing file directly. At the same time providing the credentials from overlay with which to check permissions on this backing file.

I think the inherent recursiveness of overlay (e.g. one can mount overlayfs where lower fs is again an overlay) is effectively making us check permissions recursively for each level of backing file, so it would be hard to have just one backing file. But maybe I miss something.

>                 }
>         }
> 
> something like that?
> 

-- 
Best regards, Pavel Tikhomirov
Senior Software Developer, Virtuozzo.

