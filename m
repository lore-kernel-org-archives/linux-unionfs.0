Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.83.79
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795166708;
	b=iPXhwcRpvX1fAKIy6aIBsQcBxlBZYTljH3iGurG1DasHAM7QSy/LSbk9wz/+UV92/tNQ
	 jbKVEhVDbYUy/O8qFnFsKz1RRx1E2vF+0VFM3EvxBTGyJxKZduVbeROzcJplswDwnDFJS
	 Q1o1Apn4S8mcczXsNJWYp8Smxaz4PHCgNocNqI+fuwC9A4QWkV/f9qHhoY+weX2Jhp1Da
	 JXXjGMQzyREWKSA3/tE5SEqvdQkr+LdM6LAKKE2vO703AbZPgQtBPcaZBUYdFLybF+0Bi
	 4zjnM+sYDAMdDIHKdwxAH9kRYGo2uFk8m1+DeITwaBFziHB85MNQijWGBPfErSVXXFg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795166708;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Content-Type:
	 Content-Transfer-Encoding:Subject:From:To:Cc:In-Reply-To:References:
	 Date:Message-Id:X-Mailer:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-AntiSpam-MessageData-1:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=tSnpyigWvRK8uoUJ6RkbgfGersLaAGqDze50zOaXSGA=;
	b=Y/WPEVGEPgezTEKVnqq20FqyRqLn0uI8N9TzG7lm+qUrA/dxq1cBI1rnbiu6LFyfeQoC
	 bi6nNfmQr27QfoCMxPGnxQk7FWbgV6Cu1hZzRbY37jLcsjek09tXw7Z63rNVW0MvzEr2I
	 tjZDBRHwZl1t7QSi4Gnrae+0dlQPKXd/Pavc+bCfwM0JA29hvmh80synSQ5HrGEH5Tjlh
	 QpImMf7m2f95VYa0qrsQELVaUpEObimOLYEqpkkN8bBgKiCRyLDwDILiIjY0VkoP7I1yl
	 rJRtWC2ncCcoKFgq8Ibblvzm9ll1fd0f2uNIM7lXtEvCwj+zNUBq0wc65oDXE7hoiZQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=virtuozzo.com;
	spf=pass smtp.mailfrom=virtuozzo.com;
	dkim=pass header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=selector2 header.b=kysJRG4R;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.83.79
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11023079.outbound.protection.outlook.com [52.101.83.79])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7D1606A326;
	Fri, 20 Nov 2026 09:25:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E7D1606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=selector2 header.b=kysJRG4R
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OOji3XbWTyidpjul1qiEKLg//0uGnJOTaaHxegxS8hdbK1IYqtmkWzzFs8IH3mtxRR2efK1ADje6bw41FTnTRCBYgA/IJ/xiPUNsxctvW4oHrGSiO1H+4A/B5gP0WhJaqMiY9qubXXqT0Tex6WiX44VwtkyVjvPxyAujeSANGCSXhHyIfhKlBgNBuEs5Yn1YkZxVG2kmvuWxl7inpo6hORvxni1LYqNzDCuvAnw+zlgD5EOIIeEuu5wZ0+WTVOiYOOEhzO9C0ImLI49lgpSfqRnd6Q4hnX1nfAPzifx/tKpiIJq/vpSc9WdVwWe4yRfNo2awwLJbXXtqYs9OXNVTIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tSnpyigWvRK8uoUJ6RkbgfGersLaAGqDze50zOaXSGA=;
 b=Ej0NeiQWCJIcUzg1jPSXhn62P4Mqpj0MGdkApCJbM2GGggOesi2Qi7dp8pX/oCSx3XOL49aMyiLKslGfJhNjGwC1EB+/32p+NX2rE8wPbZMfbz7wHrU4+Xa8fkgyIzYlrFOuKvqU5oC9Ti7IegStCzNI0XbyZ0g7e9xJB26UXAVsCnX3tWtvYLo+zL30+UBCqBiMTy3opRfRq+TIM4oH5PpC2xCJvwmhqRS7pJfrAUKCXlpUB5v9ZNO6qv37EiuzEllZsi9LzHg0O5r+a847LZJYLK6BmhEIPz+RUBYwVA/F6LuMpePMYwmMp7SmULLL+Cr6UQv0nlQDmvOdb3Ihrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tSnpyigWvRK8uoUJ6RkbgfGersLaAGqDze50zOaXSGA=;
 b=kysJRG4R9NU3dQPFDI23u7Wl+ZAfS1UEBIl7DNAWc4uKDu6kmr3PYdIXqGYlUt0+IwASac67QNAidb8rp35Z17NGNsPjnerwgM80AVWzGAJ+zJdw7t074hnAVjb+BPYt/+HcKiq7bfLCT4dguEACvtCAHsMbHr2tsZaTv+HXHxdyAFltRkevUBxGYCwrFirTpd4PUQ9SRCMM8fdQpEBwlHKOIgucGzePdeMA2nyrlZzT4RQFCWFwnZwVuh279foyjqTHAQnES3HNHITztg9WJLGHDChtzwfnk8Y2fBAPHrfPEKrDaE7hrOtHYVbfCbbGzOzhcjRC0bGGdAMDyGX3zw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from AM0PR08MB11804.eurprd08.prod.outlook.com
 (2603:10a6:20b:747::14) by FRZPR08MB11071.eurprd08.prod.outlook.com
 (2603:10a6:d10:13c::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Fri, 20 Nov
 2026 09:25:04 +0000
Received: from AM0PR08MB11804.eurprd08.prod.outlook.com
 ([fe80::bf46:f137:f6d2:5b3a]) by AM0PR08MB11804.eurprd08.prod.outlook.com
 ([fe80::bf46:f137:f6d2:5b3a%7]) with mapi id 15.21.0639.011; Fri, 20 Nov 2026
 09:25:01 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] fs: add ->f_real() file operation
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, 
 Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org, 
 linux-unionfs@vger.kernel.org, Ding Feng <dingf3ng@gmail.com>, 
 Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
In-Reply-To: <20261119211542.1509119-1-amir73il@gmail.com>
References: <20261119211542.1509119-1-amir73il@gmail.com>
Date: Fri, 20 Nov 2026 10:24:56 +0100
Message-Id: <179516669664.1556963.13937178338102275101.b4-review@b4>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: BE0P281CA0036.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:14::23) To AM0PR08MB11804.eurprd08.prod.outlook.com
 (2603:10a6:20b:747::14)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR08MB11804:EE_|FRZPR08MB11071:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f04beb2-942e-46e6-3e10-08df46e8275b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|23010399003|10070799003|22082099003|18002099003|261022105027099003|261026140227099003|261028144727099003|261021123027099003|261021121427099003|261102123227099003|56012099006|10067099003|5023799004;
X-Microsoft-Antispam-Message-Info:
	4N6Dd3Szn/YuZ7KbJyCdJ+52XKgbzOWkvfqY2KxnQ2ou4jH+7JvEnrTa7vGgTuDRWLwloMI1+feL+WgunjKoHjAo/2jC4z0u/mIWk+kPIaLiUhGKe6KYHeSRRIpAfbpKucDfmGzQR8MhKa9KiebXbOW75R8te4UJy2xS+eDhTxuhG2j16P3k3gOBGM/m1IKJqBMjkVj6kRvLMfKqmuhxyLHiTH0llfYJZ7D4byN3LMTviDysMmlHu2fzCmeMCWzl1FUGKPKPH9VTTDju0D3mALWxIO+QyCvDmTpf1BQSESunyrtRcwqD2REHnvJT19M2HUr++giBdD3vcvjduMcQyrxzuhiV+x6m/ZA01ZD0ETFAus5ENUS7M8dPwDjQXlwiZ0nPW2m0vm/oBd5kzZnRSTitQvEAxXD29UetwY8a56MGSuaeAsimUiGT9uPd0gjlw+pxXZwKDrHv8VgqAHj7qb6gPTYcVyyxAAoyNKU8FrPrQBoOFwFo9ivM8QhL48CpTGTFW/T5qYDwzpUS9RWetU438Yp0dyIUocTgLuy2Ij1vS8tXg1SGqfq9Ncmj+PxyQYwrAUV7M+K3GvoC7fRIKeWJlMypePKOBUoEIVfIBj/VQUwiItaVBI3KQidhpNHNqLMtSD0n4Flpp7eykxT9VULxAMnAdNNjA8WdEe+712Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR08MB11804.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(23010399003)(10070799003)(22082099003)(18002099003)(261022105027099003)(261026140227099003)(261028144727099003)(261021123027099003)(261021121427099003)(261102123227099003)(56012099006)(10067099003)(5023799004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cjNZVzFjdjhIZDl1U0t6eng5YXhZZkxXbWxWUXVRVm1zemFYVlk5SUV2STAw?=
 =?utf-8?B?TGkzUkxTU0xnY0VJWUJrYTErRXRVcXBjeERFdmErcU9lMW9XL25WL1N6SGdn?=
 =?utf-8?B?cHE4NFJkUGtKUGZBaU1FME9qWitudDFIRVlIRHErTGx1MVFibThucFhpTHlC?=
 =?utf-8?B?MktDdUhCVzJPekluSDJFSzRzMjZySUVhUWFhcnJMYllGbXNyTGFrajZZbUZp?=
 =?utf-8?B?cXlrMlh3UExHbkZIQU16SnNRQmhrTTkxSkRWRVJkQ0MzUG5PT05yemxmQWpN?=
 =?utf-8?B?emtKZVp4M2hiNExFaUJrNEttZlhEYlFSTEZadkE2UHJrZkRBeSszdVNxeVlP?=
 =?utf-8?B?SXBlRjJTV3FNWnZhb242bjI2Z2tnR2s2WW1SVmErM0EzNFMyZ1I2VDdsUFdr?=
 =?utf-8?B?ZUUwUlZKendhVFcwVTZSMGwrVUFzMnlLa3FXV2hVcVhXSzhqTEkrdzBsSjRZ?=
 =?utf-8?B?Ny83WXQ5bDNyTFZCTG9wemU1L3dsdjhKUUgrWUNEdEU4eFZkdlYzTVQ1OVh2?=
 =?utf-8?B?a0dQOUV1WTM5dUlONGxmU3pxVjlFNUZRWGdSbjJWdWpsNFhmNXhGR0gvQlht?=
 =?utf-8?B?S0J0M3dqTWFISTF5bFVsV0k0bFFLam43VkxXZ25uc2VYKzZpRVBReWhOc1Jq?=
 =?utf-8?B?YnBkbUNSMnMyU0VhNmFiOEszTHhBb3JsRlJQWTR4NlllSGVjTmFMaUpHWkd3?=
 =?utf-8?B?Y1A3S3ZTVnoxMnN5cmpTZjV4czhIVGZTUnQwRURNdWlKbzVxQVRnOTVFcFpw?=
 =?utf-8?B?ZmJzczV2WHZEbnZGdVJWdzhBSVR6VXcrTnh2NDRoMTNiVDJzaGNxdThtSEdU?=
 =?utf-8?B?Mno3ajloTFIzM3hoVmlXR3hycEgxOWJudHFMemdvcUg2VEJseEtyVUFuRnBR?=
 =?utf-8?B?THNiVVdlK0xCaG54TEYyNzBKWEV2STFxb290TzV4TVpXeDQrRDJvQnVtUUFz?=
 =?utf-8?B?VllSVjdMd0R0VlgrMWhVNjRzRTcxNkw3SkFZeHNpYkY0UnQ1MkZ2ckVVS2ta?=
 =?utf-8?B?cVlGMG9TV0dlcHdyVmZWdGVNbWtWOWFVOXFGZmFXTXlHSld1ZjQzMzFreEQw?=
 =?utf-8?B?U3RnSjJGdmM5eVRrbm42MnNTMWlpTDJEZ3ZQK1B5L3BIUTZBSnc1R2xCaUp4?=
 =?utf-8?B?eStSMWxrU25KaU9QT2V6eWxpakljMGEvLzNkZTdpMElNeXdIQ0lGOUhxenpF?=
 =?utf-8?B?Rlh5eGlJWndqTXFxOEwyUjFPZnphbURZU3pxbEMxblN6T0FuMTViVWNrdVJ0?=
 =?utf-8?B?VzRxRTU3KzhEMU1qWWt0K041SDFkMndBZjRQTTh5a0ZuMktMQTAxUDVVVnEy?=
 =?utf-8?B?YnVmWDFXZHRldEttaVBDY3Vvbi9MakRIV0g1QTdNckNOL2ttQ1Axcm1hdTVT?=
 =?utf-8?B?VU1QOGpiZlF3S2Z6Y3JuV0k1NTljcEY4dWZKbnRZK0FzQVVLcUtrQnNiU0Vy?=
 =?utf-8?B?blF0ZXF2d1hOVFd2NnAzQVZINnRsRXRQazVidklHemlLNkZRUHluTThSY3dT?=
 =?utf-8?B?VENmZlRsOVNXc1JubUplV2JFVHNWVnhoeXlBZ3E2eXB2Qk03cUh6OFNpYU9m?=
 =?utf-8?B?VkNyY2pWMWdFaUdIMWpDaDVXT1JLOUhhZWFDMS9WWVlhaHhQbk9FbWh3SDlu?=
 =?utf-8?B?UWJ6Vmg1aFF4VVU0SEx6RFhIblAvNTAzYXc0N001aGJQVThYN29PU3EySjJV?=
 =?utf-8?B?UnRmaWszSGJoWEo3ZDJDcy9kcjZxalA3cFRGZkxiSExWQU0vaEJ3ZWc2NDhm?=
 =?utf-8?B?QlhwY1A2WUdNODgrbFFQbHpidUtSNVJYaDhxM1Mxd3ltK1hwbGJFRlhmUEw0?=
 =?utf-8?B?T3lGRGZ4STBIdSs0c0IyaTRZdjA1WEtTTzh2V25PclJqYitWaEtlNzdNWFNP?=
 =?utf-8?B?WjdhN2dUdHNsUWNBSkZBWkZWZzBUNHZDNytHdFpnQ1psQU1ST1BFaUM1NDMw?=
 =?utf-8?B?c3RyUC9zV0I3WDRPbDBFRXMrU2ZBM1RzVWt0WE0wQWZwY1lsamVaaXgxUjJp?=
 =?utf-8?B?blU5bHVmbWdud0lGWXd5UWsxYW5TanJYR1VueXowWnVuOEdtYnB5eTh5UGgz?=
 =?utf-8?B?RzcxcGJDZGJ1YUZLTnpCb1Y2eHBhSDR3aWdEUUlQZlBHTjNxQTlKelQyMXVp?=
 =?utf-8?B?bWZDTjNOSk4yWlJJOXJZbVVLZ0JPRlVVMDVqZjhETkYrYjRjbklyUTd3Vmcw?=
 =?utf-8?B?MXg2OWw1WFlqNUNSMGhrZ2M4VlVKb3hvWTYxWXJMSVNFMCtyKzVuRFJLZ0xB?=
 =?utf-8?B?bFozaHJVN29JUmZGNVp1Q3dPRlBxTXk5K0N0OFdvM0dXZnN4OVJxODJRcThU?=
 =?utf-8?B?dlNXQm5qdzZZSjRrN2c1djIvZUJvUWpZSFVaa0plRFl4Z2xkNTNLb21FZHNN?=
 =?utf-8?Q?3p060UQhghgGXZNH//6kxCHxa+aMNVtwdiViU4Uffcr9e?=
X-MS-Exchange-AntiSpam-MessageData-1: S/srPqV9TCUJJb0ru4PtcDz6FU+DMkMaaO0=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f04beb2-942e-46e6-3e10-08df46e8275b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR08MB11804.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 09:25:01.8337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LraflHfpC3aqEt7KyGw16xfHw6C0qNnM+bCzWxApjwz9jdzP9Whc4Oh2cNHmwaxn9rQdvBPyK2iRz4VqPEwQEIUmyMnfXNEy/SQbglfJj8k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FRZPR08MB11071

On Thu, 19 Nov 2026 22:15:42 +0100, Amir Goldstein <amir73il@gmail.com> wrote:
> sync_file_range(2) and cachestat(2) operate on file->f_mapping.  For a
> file on a stacking filesystem, such as overlayfs, the data and its page
> cache are in the real (backing) file, so on a stacked file
> sync_file_range() writes back nothing and cachestat() reports nothing.
> 
> Add a ->f_real() file operation, modelled after ->d_real(), and a
> file_real() helper in backing-file.h that returns the backing file
> holding the data of a stacked file, or the file itself.  file_real() is
> a no-op without CONFIG_FS_STACK; otherwise it calls backing_file_real()
> in fs/backing-file.c, which calls ->f_real() and verifies that it
> returned a backing file.  The real file is owned by the stacked file, so
> it is valid for as long as the caller holds the stacked file.
> 
> [...]

Reviewed-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

-- 
Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
