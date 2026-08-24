Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11020129.outbound.protection.outlook.com [52.101.84.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D258357D0C
	for <linux-unionfs@vger.kernel.org>; Mon, 24 Aug 2026 09:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.129
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787563371; cv=fail; b=uulPvCeTNHXvWz+MAV/g5aY4/6SZbD/RE7NuxKtcMHZNfTyO/GnWE2QS7sCTK1xQMUTq7g5/c38OJ929hs1JjlORB4E1yvDdfSi2/sL7vazLAcF+p6rpvd/pxdn0buMn5/rF/90IxvDjxyW/eW9bY569GErHg0LYGfXPnaW34dw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787563371; c=relaxed/simple;
	bh=S5Klp6aEzY/HWrRGb1PGkgGH3mxvHVQwHHLdw01rhy0=;
	h=Message-ID:Date:Subject:To:References:Cc:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CyyF6XbpvguXvBppyVQlrZ8k73rvkxx4zVOz882k/reV9hCUiEGAcETLzw2FEKH3u+vUNRjOJiVaS8HT0FVOq1+Tt1s0FUdk85eUV3FghEvYmmDiDAMZWGRVQdmtLIZLg4+Zrfb9E0k51YsbX1tjJ2fxXp90yBkLONUJkfe2zHc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com; spf=pass smtp.mailfrom=virtuozzo.com; dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b=HQecHmsC; arc=fail smtp.client-ip=52.101.84.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="HQecHmsC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jUGjhgByA87lk0/cgL/zplKFtSXanAgv9yhz1oIbGggs2VZwZKH7/MgM9TNT6Cqd5OxGQCGA/guAUz+EtWiie3Wlo5QhuzujZn4JK6DEKjpvin5ylmtgTALaVXS+tZlLYOY5JCPaWil+wJT6RJULnu6z4K3XiKWfFIrgowr2xQHVMp0uuFNL9q6BaKa3jgUnwP2Vurh9kTjKkw8jRoCTd1EGx3C2D2hfLKg+W5wcWC3yIw6d0kaKADNcGWlnE7+AyHRiZQx+FPWkFlJXINMgat0I70U8/yC8JLYef2TZDI5mhDKq1WcH9ZigqMTVeIVq2i7e7dOGiAETI5P8zUEZVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aVbgGjnR1vZhbMLcMSIfcZdbQgmpmxgtljuifzP3dbI=;
 b=pW+fb+gmJlq8LV2Z2L31y/9HtYZjXvLIk4ZxPVrCQ2ncGffQegkGE64hgPMlJLbAPVtxwqD25s9JKLoEluFs8B+LVrAPhfQOrgGEIUXPzBzyvnJ7nRZSQJUT4PWuPfHxjpHQlDxED14Cj9P+JrzCZZBmS2XpXOfs5UiMzrtG/JnR9PplOSLeFNmEPa93UiINo+kVNJy0/6wNVW5zWYB9ZLm6k39EXUWSEKxXjtXO6mwxYCSS8qhLaXyoqS0tZk2ZLCHr+bOOoWqdt1aSKXToNrSj4S/9OHHeKCtApvpVND/RKZLz+YIYdsnquXhGwowuraFzGI8iM9kc8ORq7PO0CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aVbgGjnR1vZhbMLcMSIfcZdbQgmpmxgtljuifzP3dbI=;
 b=HQecHmsCfKAWJIawhEqJQKT5Zs8pbm7igzt94kgZ+sz76by0u9LTnbw8beiGzli4R36NnGO/IRsr9Em7HsEhNJ0qo9LtJH9/We9kwl0zrdSdzD88xjO7UodHOdrAlCYbgj5vM5c4eQaipYAZFJMna3P4eXDSK11NhpBF9aILdNfSyKk+tf4D997GyqKXco9gwuv5Lt9r2cGgxIcAouHUSRS0ACX7QZqaoGUeJxoo6FmwaB/feFr5pU1faGC2XxSqk5THC/Tq/HHPhLP5+q/qSk+R6k4gtj982zD6iLz7wdrI7XaH11TVTvUnhYE29cl0ZxjDMDHprB25RHYkrZfGjQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from DU0PR08MB8470.eurprd08.prod.outlook.com (2603:10a6:10:406::17)
 by AS8PR08MB10001.eurprd08.prod.outlook.com (2603:10a6:20b:632::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Mon, 24 Aug
 2026 09:22:43 +0000
Received: from DU0PR08MB8470.eurprd08.prod.outlook.com
 ([fe80::3db0:9d70:4641:5f47]) by DU0PR08MB8470.eurprd08.prod.outlook.com
 ([fe80::3db0:9d70:4641:5f47%4]) with mapi id 15.21.0339.012; Mon, 24 Aug 2026
 09:22:42 +0000
Message-ID: <95d27da3-8fa1-44c0-bba7-b6e0adc77d7f@virtuozzo.com>
Date: Mon, 24 Aug 2026 11:22:40 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ovl: Fix NULL dereference in ovl_get_index_name_fh
To: miklos@szeredi.hu, amir73il@gmail.com, linux-unionfs@vger.kernel.org
References: <20260824091040.155481-1-vladimir.riabchun@virtuozzo.com>
Content-Language: en-US
Cc: wangzhaolong1@huawei.com
From: Vladimir Riabchun <vladimir.riabchun@virtuozzo.com>
In-Reply-To: <20260824091040.155481-1-vladimir.riabchun@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR09CA0164.eurprd09.prod.outlook.com
 (2603:10a6:800:120::18) To DU0PR08MB8470.eurprd08.prod.outlook.com
 (2603:10a6:10:406::17)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR08MB8470:EE_|AS8PR08MB10001:EE_
X-MS-Office365-Filtering-Correlation-Id: 8368e095-48c1-4880-78cd-08df01c13fdf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|10067099003|5023799004|56012099006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	xXIqBYzOx5GaQIEYJ/+iCrSm3HDgq+ZYGr7OUKjCTZjAhzlYIGY3jaKcfpRONAYVr9/ynjqQ9IY8vWvKWjSROmHHDLvs8YiNBhPaORVgaxFR7IDmg5jlwdOmHjTBDjW8KoOgBI5s9ObKLvy3oZFkISxvI7lNgqdup2F4xn63COI5WbVPsgeKIVx6O2AV9SqdP52hSeN4SqzS1MxEu5MXu8EUH8NqcTiL+0qokNFBhVPao7YPf1hhuziZbUk4pI8iWdxfk2SG26sJiBP8wujU4qlXwoLfcBLOz/jYqksazDar6M5V/jLyALkBcP63MChit5FostNGDc4uqh5a9XFHcVopooqFMe8eks8CSNy5f+8sDdUlBGWBL09IxDXBqjk9wBSHzECkIcbZN1TL1/MMt+bHD4zoAwy65hXqGbuNRMxOVv9rgMDhz6KC0RQqhd5chxG0ULu54bvTApNLNTcvXbGrY8VEK5Q5/J2EqrlkiUsEfhHh9b2hVeRhM2UkubuDIMT3u9zPVnvq2gDOggsFBzgpAQk931Jiw5cp3+UIjpgT8P7UmFZGVjSNeyI2DRM1XzRBZ9Mf9NhkDUUXw0cjHS0meWA7q8YsMABFYoiuHjVe0XmcrKRATlwWEOiuqQTh/HT5P+fApk3Kspv2ppeVMrc2jytua10/7i4D889OEHs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8470.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(10067099003)(5023799004)(56012099006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Vys0R3RaVmM5UGFWSEZTWDV0OERCOUZZNEE2VkZWUkFWTUcrWWtxZTBsUndk?=
 =?utf-8?B?NnlwR1ZuZDVzYytwaldtZTJ3YTNRb3Q0L2JpRTNWQVJPWThRTXdFeTg3bVNu?=
 =?utf-8?B?NDRrWDNqQzFjVGxUNC9EZk9mcVVFMk9JazY3TFZacWYzek9IUTRXa3dvUFha?=
 =?utf-8?B?cXYzSm5zY3NuejdxY2hrS2ZaRmFROFcwVjdHUmNYMEZFMEZOQ3RTdmV5MjFj?=
 =?utf-8?B?K0U3UndFZ1VBZjVQMkFwcytFTW5VYWE1UW9FSDkzb04rQ1NMUFVpeC9jcExj?=
 =?utf-8?B?dzJpeGVnTHc3T3VLYmR5U1JmTUIxdnhpRElHai9FWGRqNC9KeDkvS2oya1BR?=
 =?utf-8?B?UHZ1aXVrUVhJTUdXejJoSmMzWmVSd0RlcEFBbDl5ZEk0dGZuY3pnWnVoV3lG?=
 =?utf-8?B?cjhjWnZHajVkOXFGbGlDTk1TMnlvT01mRUlEY1JmMjAzUDJQUXVzQU03ek83?=
 =?utf-8?B?V1hKdVF5a2dDUUdneGVpTG04Ym9zdlRJVXloTmMrTHZ4dUY4eWprYkNQS3pK?=
 =?utf-8?B?ZFRJeGlPeVdFNW45ejBPeXlIOU04dmR2WERZeUVWS3FVQ1NjNHVzNk1XMjRs?=
 =?utf-8?B?UWkrSCs3djVONWROcWVIenc3SEtKSFJ2dnlSOHAxRUNhMFJOVVFRSEFzaEVn?=
 =?utf-8?B?VEhSNGh1Z05icGFCeXhXbzh6MWRrZlhpQ3dLVENGOEd6eDRlUXhBSUZMK0Z1?=
 =?utf-8?B?V2RhbjkzOUtaNVRySEdJZ01aR0o0d3I1WmNoSkJZVlBOK1FVNTMxN3NSUjVT?=
 =?utf-8?B?azZtU0pyS3JvVC9BanNEbFAyek51aGF3T2NEcWs4dUxYb2tia1VpdStXaHRv?=
 =?utf-8?B?YzJ5bGxpK3BhalFvd242WFdjaENZUU9sRXoxcmMvRGIrWi9yVVg5eEJqL2M3?=
 =?utf-8?B?aWZHMnVwNjJNbndVMjZBMVc3YmFSeDVSb0Z2ekM1eU1BUUpLdWtJM0pLdllw?=
 =?utf-8?B?QWViSzFXanRUbnFXT3BqQnB2enloTXJZSFRWQkdQdlRvczlZSWVRZTlmLzNM?=
 =?utf-8?B?MnJpZDRMNzZFQTVyWVNlOEVTWFk1TUpMcXUvUG9VakJxTk9yeDBSdjk4Zi9h?=
 =?utf-8?B?ekQ0N05aUDgvdXlUa3YzcjhZTGZXL1FiVGtnYU1yMUJscWdZamFVUnJWcnFo?=
 =?utf-8?B?Q2V0dWYyalZYeFVnL3BjcDB0ME1FSnBZMTJpWmdjYUVRQm9WVStCcGY0anFi?=
 =?utf-8?B?N2JXRnR5UkJTbG5NVWd2WWZYbEhzQW9uZ253R01aS2hGbGxWM2FmMlF4cTZL?=
 =?utf-8?B?R1FrTE5mTGlJSk5pbVRxYmhUQmZDV0lwMkFLRkd0WDV3cWl4b3FheHpGbnlX?=
 =?utf-8?B?NFR2ZThXRXFCY25zZmJuNERVZVplanFsUVNTdU96R0U1RzBLcW8vTVU2OGU1?=
 =?utf-8?B?TkUzdm40U1ZjaXJ0WXRDTVpORVQwVUQ1Y0NpQVZsUUk4L3p5WHFqbnlKb0VZ?=
 =?utf-8?B?T3dVME0zbzJrRGphSFVUUHl4ZFNQNkVVT3BYS3dHYm1Jc3FBUVpUTkI2Y0gy?=
 =?utf-8?B?RHVzMDd4SFU2TnNIMHoraW1uYTJVaUp5WVdOOFdENlArL3JZc1B3RGZObmhF?=
 =?utf-8?B?YlBlWUNSemhpZXEvT2VsZTdRYzFjUGlTL3R3bXRtWWZ5QWlBaTZSWkcxc3NP?=
 =?utf-8?B?VTFvbi93UGhVblFnZ25rMzFTK3cvdndkUkZVNURwVmdUZUc5TkZLazhlekt0?=
 =?utf-8?B?Z2VEUTA5RDJpa21yRnBVbXgrNzdhQ2U0d1FEb0xLWDBieHdUQ2JJOXVyMzBw?=
 =?utf-8?B?cHJxY0FtbkVWMitHTmR1T3hiZ0xwakpyL2ZxcS84dTl6ako2TVFQV0IwSVJT?=
 =?utf-8?B?TC9BcVkxSG5VNUlpSDE2emdtNmNZTFVQU1FBZ0s1d2N2OVdxdkVNUUg5WUxr?=
 =?utf-8?B?TXdIMEJhMnhmb1hKWVFFQkdPa2RaYks1aUZaK0JUNWFiTWdKdjVGYmFXQW5h?=
 =?utf-8?B?VXlSVDhvUk5KVWdFOXJuWHpUN2Zxakp1Y2RaNlFZVmZnZnJGUm9ROXdob0FP?=
 =?utf-8?B?TG9tV3ZVckk0a2RQQ2J2T3AvNFd1SzJ3aUxiQ3BJWXJlT0kzeWE3Q3hMWUF3?=
 =?utf-8?B?dFUxSWJ0N08wd29HQ1ZCeG84VEY4OWU1TTUvVzE1WmxCSzNacFFranZNcXRu?=
 =?utf-8?B?T2wyZXBwNW00R29uWVJoSndRMXpSOTdFR3pJbzhidDlYMWpKWkRrOGsreU9l?=
 =?utf-8?B?bTZRdHlOelF4UzVWaVdVbzFBY1grZGQ0cVZYL3RDaXRyVGFOY1ExZm0yOHJ4?=
 =?utf-8?B?c0p1MDNIbHlIT2o4c2Q0T2l3ZDliZHNVSStRSzlLNmVBTTRFMGJZRk5LQWVE?=
 =?utf-8?B?c3dsZG01aW1VNU1HYzlHcGJWeGFZbklBQk81Sm5yM2tEYnQxcXREdzZSL2kw?=
 =?utf-8?Q?ZOchcqQR1/VQuxX8=3D?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8368e095-48c1-4880-78cd-08df01c13fdf
X-MS-Exchange-CrossTenant-AuthSource: DU0PR08MB8470.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2026 09:22:42.3347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hL/4hAwhRTmBOB936JBP6vIICioyBAUA2NoZsKP0DkwBR9tGyusuvjFfR1Zjr0ZKDYW5HEWSrSNt/sYLhB0SNBHfGxiRgFHYzniwpuGg08E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB10001



On 8/24/26 11:10, Vladimir Riabchun wrote:
> We observed several crashes in overlayfs with the following trace:
> [ 2300.870181] BUG: kernel NULL pointer dereference, address: 0000000000000005
> [ 2300.871537] #PF: supervisor read access in kernel mode
> [ 2300.872577] #PF: error_code(0x0000) - not-present page
> [ 2300.873595] PGD 800000010a18f067 P4D 800000010a18f067 PUD 10730c067 PMD 0
> [ 2300.874900] Oops: Oops: 0000 [#1] SMP PTI
> [ 2300.875742] CPU: 1 UID: 0 PID: 5419 Comm: criu ve: 0 Kdump: loaded Not tainted 6.12.0-211.39.1.16.6.vz10.x86_64 #1 16.6 PREEMPT(voluntary)
> [ 2300.878057] Hardware name: Acronis OpenStack Compute/Virtuozzo, BIOS 1.16.1-1.vz9.2 04/01/2014
> [ 2300.879684] RIP: 0010:ovl_get_index_name_fh+0x18/0x70 [overlay]
> [ 2300.880859] Code: 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 0f 1f 00 0f 1f 44 00 00 41 54 49 89 f4 be c0 0d 00 00 55 53 48 89 fb <0f> b6 7f 05 48 01 ff e8 bc 42 2f ea 48 85 c0 74 33 0f b6 53 05 48
> [ 2300.884128] RSP: 0018:ffffd32582e0f7c0 EFLAGS: 00010246
> [ 2300.885153] RAX: 0000000000000010 RBX: 0000000000000000 RCX: ffff8ba4497480a8
> [ 2300.886480] RDX: ffff8ba45535dc00 RSI: 0000000000000dc0 RDI: 0000000000000000
> [ 2300.887824] RBP: ffff8ba68f9daa80 R08: ffff8ba4497480a8 R09: 000000000000030e
> [ 2300.889139] R10: 0000000000000000 R11: ffff8ba44862d6d0 R12: ffffd32582e0f800
> [ 2300.890498] R13: 0000000000000000 R14: ffff8ba497cb0110 R15: ffff8ba517548cc0
> [ 2300.891838] FS:  00007f5a2f492880(0000) GS:ffff8bab9fc80000(0000) knlGS:0000000000000000
> [ 2300.893376] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 2300.894476] CR2: 0000000000000005 CR3: 000000033403a005 CR4: 00000000003726f0
> [ 2300.895807] Call Trace:
> [ 2300.896397]  <TASK>
> [ 2300.896938]  ? show_trace_log_lvl+0x1b0/0x2f0
> [ 2300.897854]  ? show_trace_log_lvl+0x1b0/0x2f0
> [ 2300.898748]  ? ovl_create_index+0x82/0x260 [overlay]
> [ 2300.899766]  ? __die_body.cold+0x8/0x12
> [ 2300.900582]  ? page_fault_oops+0x148/0x160
> [ 2300.901562]  ? exc_page_fault+0x7f/0x150
> [ 2300.902406]  ? asm_exc_page_fault+0x26/0x30
> [ 2300.903298]  ? ovl_get_index_name_fh+0x18/0x70 [overlay]
> [ 2300.904435]  ovl_create_index+0x82/0x260 [overlay]
> [ 2300.905406]  ovl_copy_up_workdir+0x30a/0x330 [overlay]
> [ 2300.906427]  ovl_do_copy_up+0x10d/0x2e0 [overlay]
> [ 2300.907387]  ovl_copy_up_one+0x456/0x720 [overlay]
> [ 2300.908376]  ? xa_load+0x7b/0xb0
> [ 2300.909090]  ? _raw_spin_unlock+0xe/0x30
> [ 2300.909913]  ? list_lru_add+0x11b/0x160
> [ 2300.910736]  ovl_copy_up_flags+0x81/0x110 [overlay]
> [ 2300.911740]  ovl_create_object+0x51/0x130 [overlay]
> [ 2300.912719]  vfs_mkdir+0x194/0x250
> [ 2300.913470]  do_mkdirat+0x14c/0x180
> [ 2300.914223]  __x64_sys_mkdir+0x46/0x70
> [ 2300.915019]  do_syscall_64+0x7d/0x160
> [ 2300.915798]  ? do_sys_openat2+0x9c/0xe0
> [ 2300.916672]  ? syscall_exit_work+0xf3/0x120
> [ 2300.917540]  ? syscall_exit_to_user_mode+0x32/0x190
> [ 2300.918518]  ? do_syscall_64+0x89/0x160
> [ 2300.919316]  ? syscall_exit_work+0xf3/0x120
> [ 2300.920181]  ? syscall_exit_to_user_mode+0x32/0x190
> [ 2300.921173]  ? do_syscall_64+0x89/0x160
> [ 2300.921991]  ? exc_page_fault+0x7f/0x150
> [ 2300.922814]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [ 2300.923823] RIP: 0033:0x7f5a2f8de3eb

Seems to be the same case as in
https://lore.kernel.org/all/20250429001308.370040-1-wangzhaolong1@huawei.com/#t
Please, take a look at it as well.
> 
> It seems that after commit 5b02bfc1e7e3 ("ovl: do not encode lower fh
> with upper sb_writers held") fh may be NULL and it is dereferenced
> without check in ovl_get_index_name_fh.
> In our case NULL value came from !capable(CAP_DAC_READ_SEARCH)
> in ovl_can_decode_fh.
> 
> Fix this by checking fh before using its fields,
> if fh is NULL - use buf = NULL and len = 0.
> For ovl_get_index_name_fh use empty string with length 1 so
> the following bin2hex and kfree(name.name) are fine.
> 
> Fixes: 5b02bfc1e7e3 ("ovl: do not encode lower fh with upper sb_writers held")
> Signed-off-by: Vladimir Riabchun <vladimir.riabchun@virtuozzo.com>
> ---
> There is one more place where I can see the possibility of this problem:
> ovl_get_indexdir calls ovl_get_origin_fh which can return NULL, fh is
> then passed to ovl_verify_origin_fh -> ovl_verify_set_fh -> ovl_verify_fh,
> which doesn't check fh for NULL and dereferences it.
> 
> I'm not very familiar with the code, so I'd like to hear what should be
> returned there in !fh case (my guess - return 0 if ofh is NULL as well
> and -SOME_ERROR otherwise).
> 
>   fs/overlayfs/copy_up.c | 5 +++--
>   fs/overlayfs/namei.c   | 6 ++++--
>   2 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 4388004a319d..63a783473b60 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -492,7 +492,7 @@ int ovl_set_origin_fh(struct ovl_fs *ofs, const struct ovl_fh *fh,
>   	/*
>   	 * Do not fail when upper doesn't support xattrs.
>   	 */
> -	err = ovl_check_setxattr(ofs, upper, OVL_XATTR_ORIGIN, fh->buf,
> +	err = ovl_check_setxattr(ofs, upper, OVL_XATTR_ORIGIN, fh ? fh->buf : NULL,
>   				 fh ? fh->fb.len : 0, 0);
>   
>   	/* Ignore -EPERM from setting "user.*" on symlink/special */
> @@ -510,7 +510,8 @@ static int ovl_set_upper_fh(struct ovl_fs *ofs, struct dentry *upper,
>   	if (IS_ERR(fh))
>   		return PTR_ERR(fh);
>   
> -	err = ovl_setxattr(ofs, index, OVL_XATTR_UPPER, fh->buf, fh->fb.len);
> +	err = ovl_setxattr(ofs, index, OVL_XATTR_UPPER,
> +		fh ? fh->buf : NULL, fh ? fh->fb.len : 0);
>   
>   	kfree(fh);
>   	return err;
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index efa2a072aa69..81607a24589f 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -721,12 +721,14 @@ int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index)
>   int ovl_get_index_name_fh(const struct ovl_fh *fh, struct qstr *name)
>   {
>   	char *n, *s;
> +	size_t len = fh ? fh->fb.len : 1;
> +	const char *buf = fh ? fh->buf : (const u8 *)"";
>   
> -	n = kcalloc(fh->fb.len, 2, GFP_KERNEL);
> +	n = kcalloc(len, 2, GFP_KERNEL);
>   	if (!n)
>   		return -ENOMEM;
>   
> -	s  = bin2hex(n, fh->buf, fh->fb.len);
> +	s  = bin2hex(n, buf, len);
>   	*name = (struct qstr) QSTR_INIT(n, s - n);
>   
>   	return 0;

-- 
Best regards, Riabchun Vladimir
Linux Kernel Developer, Virtuozzo

