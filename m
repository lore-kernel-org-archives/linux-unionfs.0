Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11022096.outbound.protection.outlook.com [52.101.66.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B3E483804
	for <linux-unionfs@vger.kernel.org>; Tue,  1 Sep 2026 16:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.96
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788280717; cv=fail; b=YiS9xsINBgsSlt1hQq51X72EP9RPDRQenZQ5hvrPWTvK56sHKIUU6ZOuHXcBYWQdVm8wdDz1uIQAprkK5vj/d6VBnpJzWWtaDZzG2bVfo/FQcW3QKQzYV1EyyB2zjxCa7O9ShQnIDJNMr9LZS+QjZF/SyZfQLnTnQ8fsJF/lXLw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788280717; c=relaxed/simple;
	bh=hKr71/vV8apL3NuCi+Gm9j8JYMgD8fD4e0tEveW9whs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mgs3DLea/T9dG3g8nvANvnzqlTF12lrdvJ1elq/YP0vckSl4cuis5dDjEmZmqaTk9Ae9dn3rcsKfbLM8yFILY455OKpnkAnI2D2SGwIv3oHaIhTXUD0hPn+LEFrL4VxQ00OKgtHijlRokjjBlTsSoyyDkVm4BfRtBOZnfaygORM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com; spf=pass smtp.mailfrom=virtuozzo.com; dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b=aaZRRA8t; arc=fail smtp.client-ip=52.101.66.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="aaZRRA8t"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WPoxDKNL2a1E80TXp+qzSFuiShjm0HX/3avh3OPZ34l20ymnkw0hIqaNcbV7zMNp9QP9AzVRi+xvvB4EkHA5KjdKJKcuFPS0K6d23JUI3a71JpMbkHOU+K5Q//cjAoUroMHGHksXq1JQ8m71G3j5Fg+LgnvCJzoKSqg2Tx9jzcQn9Vsv/+0qbstt0sayAO0DJ1MFuDDkwamUX609dLHhahfwhG0A/i99w7+d5SHchF/PXZkqrqb+CspFClWa860ht3dIsS1z7E5bm6mNeKhzhhOeTsXaWp8dU2kY660MbZTZKRL47LWFHsLlkxnEaPHVHkHXXY7EMuhL9UOmAbrSug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aiSKjvPY8S0XxbnwEtYv4gbh/KQYxbJxEjk9IXN57XE=;
 b=antc2wsWOl/TTG0wXczmNwBxMT0M3g732V1tEPAWLGNyEU2EDTYQhYdF1b+Md+2/10SVTCHCeKw9JA5XIYgxS5a46BkXdLv/U5LLAzHj67xWc8JxjCWwlpOmpv+Z99cRgVJ+vksdp4ITOSqIut+RG5AeWJyogoDBLuiSXyspShkX8pVBizxzTSkhGEn2mW53wkrnMNQBk0ln2Wj95587onYq94tGVMBzI94M32cdHp0vyyjrcGlKLtx0QmKtZ6xSjRZFVr/6Cq9PlNlRZakltmrtAfM3dYL+MoI5U8ILkNGhDn1V5CKlmx6dhUEXgwREn0MqlX4L2fJeeZzBKeG4mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aiSKjvPY8S0XxbnwEtYv4gbh/KQYxbJxEjk9IXN57XE=;
 b=aaZRRA8tU937I47h7ae6baZs9ywk80edKsfXEsu+E6hEVNQsVeSTOgRiw4yE7budaQGkuji//hhu7p90faXRtnEdU7RwWSY31HOh5N2EP7WgGLZgWA8BLJ1T/s+qoC0vLfqPdDS8g31bwl+OSSaGpocgSzbPPloW8o0GTzTZRV5LJBPqvRQSaoB87N3QQnphJcmjqKxuEViUaXsYlijyUVcN+hswqR9RH8VldSYnlzaJITA+SGmEV5I0V6KSG3SoYGYb6oTtfMdgROKhwh6oBRn2aVGYAhsnnTGXP7d5qpSrB9JYiG9cX6NzRC33EIZsD1bbI2uthV6jwBGAHoEkAA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from DU0PR08MB8470.eurprd08.prod.outlook.com (2603:10a6:10:406::17)
 by AS2PR08MB9000.eurprd08.prod.outlook.com (2603:10a6:20b:5fd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Tue, 1 Sep
 2026 16:38:31 +0000
Received: from DU0PR08MB8470.eurprd08.prod.outlook.com
 ([fe80::3db0:9d70:4641:5f47]) by DU0PR08MB8470.eurprd08.prod.outlook.com
 ([fe80::3db0:9d70:4641:5f47%4]) with mapi id 15.21.0382.007; Tue, 1 Sep 2026
 16:38:31 +0000
Message-ID: <7123b9c3-1f38-454f-aabb-3da3a9e5fbb0@virtuozzo.com>
Date: Tue, 1 Sep 2026 18:38:29 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ovl: Fix NULL dereference in ovl_get_index_name_fh
To: Amir Goldstein <amir73il@gmail.com>
Cc: miklos@szeredi.hu, linux-unionfs@vger.kernel.org, wangzhaolong1@huawei.com
References: <20260824091040.155481-1-vladimir.riabchun@virtuozzo.com>
 <95d27da3-8fa1-44c0-bba7-b6e0adc77d7f@virtuozzo.com>
 <CAOQ4uxgVb48iYiHgiq+gH2CoAunjJtOE2i0TvTtGmeuUiMmgAw@mail.gmail.com>
Content-Language: en-US
From: Vladimir Riabchun <vladimir.riabchun@virtuozzo.com>
In-Reply-To: <CAOQ4uxgVb48iYiHgiq+gH2CoAunjJtOE2i0TvTtGmeuUiMmgAw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR07CA0230.eurprd07.prod.outlook.com
 (2603:10a6:802:58::33) To DU0PR08MB8470.eurprd08.prod.outlook.com
 (2603:10a6:10:406::17)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR08MB8470:EE_|AS2PR08MB9000:EE_
X-MS-Office365-Filtering-Correlation-Id: b0aa3b4d-2c7b-44bf-07a4-08df08477535
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|18002099003|22082099003|56012099006|4143699003|5023799004|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	b1N/KJprs0fZpu727Bl2o83QaOdnw3w2+Ww8YncZSlhChWgk7WRjtvdaW/UiAUI3XKxDlwynTydBuXQjf4GInTsveOD9eRRVXJts7Q2aj9iK5LFRxgQdCAJTJA4/4G37/Us4w2IH4Aq3w6nBoGS6+UBzNI/TR3+5vyS6qT3BAFTANct2zRlPumtX6jpZ4QdjK02X9Dr096sJvO5fpAcyGCmqqvYiCvlqPf1Wq+xleGjla1oolpwsvr/MiNo/w7G2GRYej4tfh5n+DggcdhWYhyRk33Eqv9nik84NhZ0ApAz7S0fG7ptGmvcMLbwOFePI6C8NrbjdHqxYflMvu86RpyEzrG6bXYH69379Y2Ly52a3sAUKl+bgKnmG3iFnWccIfVF5DrHMLPjHAN4zQdmK1XM5cP2TWMdeSn4ym7Oep8ECqsDTAVzUfkQxIof4Vk/qpniCUfw0zAFWq6RfwDkmwi/7yvrmyEcIqPfJ8V6SX8zYuGpRhWCDc30M7mDKhwAkMZ5M4utk9xgj2+4SgtmVzi35iSxLheyrfEwq8V45w9xXv6syfw4yvqi6jF+/crlz6gLAArchte3DXPPaOr4BNO+JEUJlOHKtOHk7ieyfrj0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8470.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(18002099003)(22082099003)(56012099006)(4143699003)(5023799004)(10067099003)(6133799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S1psdlVGQ0xObERnY3hiU1IzdytITUZ1SDVTT1BhT0tWSzIvdGtYYzlacUZ4?=
 =?utf-8?B?TVFzZlBuMnVuZjZwUE9QZU04ejZsVWF4YXRLOEs5SVpEc1k0SmdXQ09xMHc2?=
 =?utf-8?B?WTh5eEhTRk5mSzdZdFplczJGQWZhZkhBMERqN1dKOWIybS8yTnpONG5YRi8w?=
 =?utf-8?B?Q3hZZEV3S3ZpWkxMYy9BaWt4SFE2Q3NNOXJPMGJpcFI2TTlINFYya3F0K29L?=
 =?utf-8?B?SUkweTRHK0ZWemNCZ1BFY3lyZ1VTbStFMnBtTHpCZUN6Qm1yRUMwNkRPbnJF?=
 =?utf-8?B?V3o4b2NCUEN4b0dzNlBRR2FMYnptMFdkcnoydmxHelhoOE0yZGFBZ0tjdEFQ?=
 =?utf-8?B?Y1N3elVaR2VQdFRtcVNBekNheEtCZWRPQXh2V2UrOWJneEl6cnNSMTdXeWND?=
 =?utf-8?B?VDBvZmNwdU1tOHZTZlFvelJhNVZoUG8yME1IL1dUZ2hvMWQ3aHJGc3NIWVdS?=
 =?utf-8?B?UWdzSzNVY094RnA1WStnc203cUdQekJCY2VjckZsZWxPZHNRdk1tVEt0SlA4?=
 =?utf-8?B?eXFLQWZrcmltS3BzSmFQU2V5YVNqQXFrWTJMRTZLeUlIVkRtZUxTZ3laeVor?=
 =?utf-8?B?bzM4K2UwNWR1L0prcUlDMVlTOXBzTVVVS0JLZ09UMTBFZ082eWozMlhjdnNH?=
 =?utf-8?B?bW13cDRzVTJOdllRdlcvZmV2ZWU0Zm0yS1VteVgxZ0ZHemhOdHdHemlaaDIr?=
 =?utf-8?B?elcxSVRYN1llZE9UT3AzRHpJcmcra1hwT0dDTFhycG15MjhyR040NDRMTWUz?=
 =?utf-8?B?TUIxUFVrMExIWnhUMTlEaTRkMUIrNXkrMGVYVk1wWVplWHJrb1Arb2hEZHJ2?=
 =?utf-8?B?UmlDS3lGVnV6NnlWOGxLZE1MdHQrS3pDdWhhQXU4RTBFOSszbTVtVk9IVFVR?=
 =?utf-8?B?MUQrL21VUzlDMG10d1NDeFEyaG1kb0xwdU5JdUIra0Q1UVhQMEJwZTArelU4?=
 =?utf-8?B?bjgvQWNwUzQ3U083eUFLcWRHbjBxaXRxaWJodU1FYkdHRkE4d2d4V3FhVmpI?=
 =?utf-8?B?Sm42T1RJZ09LVmUvSWtBSlhGOGx0b05kMSt6VG9mNTNiYmJta0JQTnFablZu?=
 =?utf-8?B?MzhVeVZhenJ1Y0dpK0pBNHpkNXRFRFNXckRodXNHenh2N2NGZVo3VUVXbExW?=
 =?utf-8?B?SDdXUW45aWIwY1B5YmlOWGpvd01tbEVoV0tUcC82VjRnMkhqOWRySnZsSHJh?=
 =?utf-8?B?TGc4WWJlSlVVVFJXS3FSV3paNFR2QVdlbjZKWWZtUVFLZXlSM2VybVozOHdN?=
 =?utf-8?B?Q1JWb2RjS1RnRzBQMllEZm4wWkhYVWRXdGZ1RVI1cnJ5NUFvUGlDSUtvNXNx?=
 =?utf-8?B?NSsyM1pFUTBaMnQ0ZGxRSVRGNWZPTzlWQnRMUjk1ekNRWE83NDZkRDV4Uzh1?=
 =?utf-8?B?T2F5cjhmNGl4TXhBTyt6TWw0cjZ1bkFycnRSWXN2SFBkcC9KcnI5Qy9CTEU3?=
 =?utf-8?B?TThJZms0emUveGZmT1VpU0FSb0g1b2lib3Q5bVg4Z0ZzK0w4WnVhb0Z5MGxs?=
 =?utf-8?B?VnZ6RWhoSFFSYk5VSitzTUVpWGYvclR0blA5WEQvNlJETXVPeWZGNXZyeUZl?=
 =?utf-8?B?ai9mZHVHcERnMGRFZGc4MHJ3VlJuSzlSV1FLVzR5UUkrUldxVXFDcjlhWjJX?=
 =?utf-8?B?c292a292cnA5a2VKbkJSWlI1Z1lPRWQ3QUJZdVFoS0JrWENqMkdQcENVZjVm?=
 =?utf-8?B?NGhINjUzNStOTm9Ud3YyNTFZbXZHMTc4bXNML08ycFVYbnlMcjBmV25CeXVI?=
 =?utf-8?B?ZytTaDREc2tKN3ppU0FyZVIxQXNyTWJTYUFTclZJSDZTZVdhY3BmQVJXME1P?=
 =?utf-8?B?U3lqcmZqV3UycnZSV3BwV29qMThPQkJmaGFxeVg1SXhXSFZrb2hwWStvbjcx?=
 =?utf-8?B?ekI2ZEFIZUhBQjYxREZTVXUvQ3NMTTBWaHd4cmM1ZzVkdzIrL0RiTnMyVHlj?=
 =?utf-8?B?Y1FLbFFaKzB6UFVGMXJReExUOE9rRERoYjI2WmY1N3RZOEYvZ00yUnlBRWRB?=
 =?utf-8?B?MkVCM1JlL2lrNGNQWWFvWHAwOUw3V29pQWNRVVdWMXpmTklPN0hyWWtBeWlG?=
 =?utf-8?B?M04xc2Fpd01FWFBwQXdGaE1DeEJmZDB3aEVnTkk4TjJ1OUx1ZEh5UDM0UFhH?=
 =?utf-8?B?bHNXOU9hdHVVNEVKaFNvM2tnbjdkaEorMHJZQXpNNzZneG52aERxUjZZeWp6?=
 =?utf-8?B?aHpMakJjOXVYS2F5OGpNdHowbWF4dFNwWVErTHhNeFdlQ0ZDUzhlQmNZanZj?=
 =?utf-8?B?RWtwZ1k3RXhqRGFKdnpEVDdKUG5ud0E2eXB1byt3TGZkTHlLbUlyUWF5OGZ5?=
 =?utf-8?B?ekxWN0lhRGxWWFlIdFdIa3Z4SDB3dCtibmxmSkt1UWF1RENXdlVJd2U5VWkr?=
 =?utf-8?Q?YMTwmYV4QzIHGGLE=3D?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0aa3b4d-2c7b-44bf-07a4-08df08477535
X-MS-Exchange-CrossTenant-AuthSource: DU0PR08MB8470.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 16:38:31.6100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qbt00ciQbxoLVi8minsBeh7bkzGstlbuRSNTxNrL7SLDmqAiymM8YMx7Gbuz0XXZJ7PS2G+mDDelQRDRcJNI6Po08an75+efE/GG2o7esBc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9000



On 8/24/26 12:24, Amir Goldstein wrote:
> On Mon, Aug 24, 2026 at 11:22 AM Vladimir Riabchun
> <vladimir.riabchun@virtuozzo.com> wrote:
>>
>>
>>
>> On 8/24/26 11:10, Vladimir Riabchun wrote:
>>> We observed several crashes in overlayfs with the following trace:
>>> [ 2300.870181] BUG: kernel NULL pointer dereference, address: 0000000000000005
>>> [ 2300.871537] #PF: supervisor read access in kernel mode
>>> [ 2300.872577] #PF: error_code(0x0000) - not-present page
>>> [ 2300.873595] PGD 800000010a18f067 P4D 800000010a18f067 PUD 10730c067 PMD 0
>>> [ 2300.874900] Oops: Oops: 0000 [#1] SMP PTI
>>> [ 2300.875742] CPU: 1 UID: 0 PID: 5419 Comm: criu ve: 0 Kdump: loaded Not tainted 6.12.0-211.39.1.16.6.vz10.x86_64 #1 16.6 PREEMPT(voluntary)
>>> [ 2300.878057] Hardware name: Acronis OpenStack Compute/Virtuozzo, BIOS 1.16.1-1.vz9.2 04/01/2014
>>> [ 2300.879684] RIP: 0010:ovl_get_index_name_fh+0x18/0x70 [overlay]
>>> [ 2300.880859] Code: 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 0f 1f 00 0f 1f 44 00 00 41 54 49 89 f4 be c0 0d 00 00 55 53 48 89 fb <0f> b6 7f 05 48 01 ff e8 bc 42 2f ea 48 85 c0 74 33 0f b6 53 05 48
>>> [ 2300.884128] RSP: 0018:ffffd32582e0f7c0 EFLAGS: 00010246
>>> [ 2300.885153] RAX: 0000000000000010 RBX: 0000000000000000 RCX: ffff8ba4497480a8
>>> [ 2300.886480] RDX: ffff8ba45535dc00 RSI: 0000000000000dc0 RDI: 0000000000000000
>>> [ 2300.887824] RBP: ffff8ba68f9daa80 R08: ffff8ba4497480a8 R09: 000000000000030e
>>> [ 2300.889139] R10: 0000000000000000 R11: ffff8ba44862d6d0 R12: ffffd32582e0f800
>>> [ 2300.890498] R13: 0000000000000000 R14: ffff8ba497cb0110 R15: ffff8ba517548cc0
>>> [ 2300.891838] FS:  00007f5a2f492880(0000) GS:ffff8bab9fc80000(0000) knlGS:0000000000000000
>>> [ 2300.893376] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [ 2300.894476] CR2: 0000000000000005 CR3: 000000033403a005 CR4: 00000000003726f0
>>> [ 2300.895807] Call Trace:
>>> [ 2300.896397]  <TASK>
>>> [ 2300.896938]  ? show_trace_log_lvl+0x1b0/0x2f0
>>> [ 2300.897854]  ? show_trace_log_lvl+0x1b0/0x2f0
>>> [ 2300.898748]  ? ovl_create_index+0x82/0x260 [overlay]
>>> [ 2300.899766]  ? __die_body.cold+0x8/0x12
>>> [ 2300.900582]  ? page_fault_oops+0x148/0x160
>>> [ 2300.901562]  ? exc_page_fault+0x7f/0x150
>>> [ 2300.902406]  ? asm_exc_page_fault+0x26/0x30
>>> [ 2300.903298]  ? ovl_get_index_name_fh+0x18/0x70 [overlay]
>>> [ 2300.904435]  ovl_create_index+0x82/0x260 [overlay]
>>> [ 2300.905406]  ovl_copy_up_workdir+0x30a/0x330 [overlay]
>>> [ 2300.906427]  ovl_do_copy_up+0x10d/0x2e0 [overlay]
>>> [ 2300.907387]  ovl_copy_up_one+0x456/0x720 [overlay]
>>> [ 2300.908376]  ? xa_load+0x7b/0xb0
>>> [ 2300.909090]  ? _raw_spin_unlock+0xe/0x30
>>> [ 2300.909913]  ? list_lru_add+0x11b/0x160
>>> [ 2300.910736]  ovl_copy_up_flags+0x81/0x110 [overlay]
>>> [ 2300.911740]  ovl_create_object+0x51/0x130 [overlay]
>>> [ 2300.912719]  vfs_mkdir+0x194/0x250
>>> [ 2300.913470]  do_mkdirat+0x14c/0x180
>>> [ 2300.914223]  __x64_sys_mkdir+0x46/0x70
>>> [ 2300.915019]  do_syscall_64+0x7d/0x160
>>> [ 2300.915798]  ? do_sys_openat2+0x9c/0xe0
>>> [ 2300.916672]  ? syscall_exit_work+0xf3/0x120
>>> [ 2300.917540]  ? syscall_exit_to_user_mode+0x32/0x190
>>> [ 2300.918518]  ? do_syscall_64+0x89/0x160
>>> [ 2300.919316]  ? syscall_exit_work+0xf3/0x120
>>> [ 2300.920181]  ? syscall_exit_to_user_mode+0x32/0x190
>>> [ 2300.921173]  ? do_syscall_64+0x89/0x160
>>> [ 2300.921991]  ? exc_page_fault+0x7f/0x150
>>> [ 2300.922814]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>>> [ 2300.923823] RIP: 0033:0x7f5a2f8de3eb
>>
>> Seems to be the same case as in
>> https://lore.kernel.org/all/20250429001308.370040-1-wangzhaolong1@huawei.com/#t
>> Please, take a look at it as well.
> 
> Thanks for finding this partial dup.
> Miklos' comments partly apply to the fixes in fs/overlayfs/copy_up.c
> Those seem to be moot when passing 0 size to ovl_*setxattr().
> 
>>>
>>> It seems that after commit 5b02bfc1e7e3 ("ovl: do not encode lower fh
>>> with upper sb_writers held") fh may be NULL and it is dereferenced
>>> without check in ovl_get_index_name_fh.
>>> In our case NULL value came from !capable(CAP_DAC_READ_SEARCH)
>>> in ovl_can_decode_fh.
> 
> The index feature should not be enabled if the mounter does not pass
> the ovl_can_decode_fh() permission check in ovl_make_workdir() and
> ovl_copy_up_one() should be called with mounter creds, so what is
> really happening in your splat?
> Why did !capable(CAP_DAC_READ_SEARCH) fail?
> Do we have a bug upstream? a bug in 6.12 LTS or a bug in vz kernel?
> Please explain.

After the investigation, it appears that the problem is in VZ kernel.
We changed capable -> ve_capable, which takes into account container
context and namespaces. This allowed the following situation:

- Mount created inside container. capable(CAP_DAC_READ_SEARCH) is 0, but
    ve_capable(CAP_DAC_READ_SEARCH) is 1. Container creds are stored in
    ofs->creator_cred. All the code now thinks that index feature is present.
- Trigger copy_up for directory for host. In the beginning of ovl_copy_up_one
    we have both capable and ve_capable = 1, but after switching creds to
    container ones both checks return 0 and sad things happen.

So it is completely VZ-specific and upstream can't get this situation using
capable check.

The only thing that could be done here is to add some sort of WARN check
to report ovl_can_decode_fh returning NULL while c->indexed.

Thanks for your time and help.

> 
>>>
>>> Fix this by checking fh before using its fields,
>>> if fh is NULL - use buf = NULL and len = 0.
>>> For ovl_get_index_name_fh use empty string with length 1 so
>>> the following bin2hex and kfree(name.name) are fine.
> 
> That's no good.
> The index has to be a valid fh name
> An empty index name makes no sense that's why those helpers
> are gated with the index feature which pre-checks the can_decode
> condition on mount.
> 
> Thanks,
> Amir.
> 
>>>
>>> Fixes: 5b02bfc1e7e3 ("ovl: do not encode lower fh with upper sb_writers held")
>>> Signed-off-by: Vladimir Riabchun <vladimir.riabchun@virtuozzo.com>
>>> ---
>>> There is one more place where I can see the possibility of this problem:
>>> ovl_get_indexdir calls ovl_get_origin_fh which can return NULL, fh is
>>> then passed to ovl_verify_origin_fh -> ovl_verify_set_fh -> ovl_verify_fh,
>>> which doesn't check fh for NULL and dereferences it.
>>>
>>> I'm not very familiar with the code, so I'd like to hear what should be
>>> returned there in !fh case (my guess - return 0 if ofh is NULL as well
>>> and -SOME_ERROR otherwise).
>>>
>>>    fs/overlayfs/copy_up.c | 5 +++--
>>>    fs/overlayfs/namei.c   | 6 ++++--
>>>    2 files changed, 7 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
>>> index 4388004a319d..63a783473b60 100644
>>> --- a/fs/overlayfs/copy_up.c
>>> +++ b/fs/overlayfs/copy_up.c
>>> @@ -492,7 +492,7 @@ int ovl_set_origin_fh(struct ovl_fs *ofs, const struct ovl_fh *fh,
>>>        /*
>>>         * Do not fail when upper doesn't support xattrs.
>>>         */
>>> -     err = ovl_check_setxattr(ofs, upper, OVL_XATTR_ORIGIN, fh->buf,
>>> +     err = ovl_check_setxattr(ofs, upper, OVL_XATTR_ORIGIN, fh ? fh->buf : NULL,
>>>                                 fh ? fh->fb.len : 0, 0);
>>>
>>>        /* Ignore -EPERM from setting "user.*" on symlink/special */
>>> @@ -510,7 +510,8 @@ static int ovl_set_upper_fh(struct ovl_fs *ofs, struct dentry *upper,
>>>        if (IS_ERR(fh))
>>>                return PTR_ERR(fh);
>>>
>>> -     err = ovl_setxattr(ofs, index, OVL_XATTR_UPPER, fh->buf, fh->fb.len);
>>> +     err = ovl_setxattr(ofs, index, OVL_XATTR_UPPER,
>>> +             fh ? fh->buf : NULL, fh ? fh->fb.len : 0);
>>>
>>>        kfree(fh);
>>>        return err;
>>> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
>>> index efa2a072aa69..81607a24589f 100644
>>> --- a/fs/overlayfs/namei.c
>>> +++ b/fs/overlayfs/namei.c
>>> @@ -721,12 +721,14 @@ int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index)
>>>    int ovl_get_index_name_fh(const struct ovl_fh *fh, struct qstr *name)
>>>    {
>>>        char *n, *s;
>>> +     size_t len = fh ? fh->fb.len : 1;
>>> +     const char *buf = fh ? fh->buf : (const u8 *)"";
>>>
>>> -     n = kcalloc(fh->fb.len, 2, GFP_KERNEL);
>>> +     n = kcalloc(len, 2, GFP_KERNEL);
>>>        if (!n)
>>>                return -ENOMEM;
>>>
>>> -     s  = bin2hex(n, fh->buf, fh->fb.len);
>>> +     s  = bin2hex(n, buf, len);
>>>        *name = (struct qstr) QSTR_INIT(n, s - n);
>>>
>>>        return 0;
>>
>> --
>> Best regards, Riabchun Vladimir
>> Linux Kernel Developer, Virtuozzo
>>

-- 
Best regards, Riabchun Vladimir
Linux Kernel Developer, Virtuozzo

