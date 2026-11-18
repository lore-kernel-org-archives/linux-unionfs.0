Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.66.130
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795006557;
	b=xnGXeCeXfeKKSnXI5GhyfO4IQzv/HG+42U00oZwF7oZqvsNZ+DpkkqwyPGv8f2WPttus
	 A3kyBVer5G1DRHWBt5dUk0FxZ+ZojKjnMP4KuXwizwF33qGSRhw32o1/P4HIkCP/1G0ov
	 OYoiILHlLaWQQr3CyVDa37Q9Czc6RiXTsAzJGQcf1M4BeJLzRrmjpPRzTojWch9ypLsRl
	 dD/Hq8Y15BBhMlIYNCqY7pXmURf/pTcJ3GDyrVH1iaRIGqcm4gxEYcr8cRW/FMCz2yn+K
	 2jc5cnkQ6OMccc9neHRvcxANDg4dQ0ZMYF9n7usfv14CZcXSdtrydtgE5CphtPcOJhQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795006557;
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
	bh=rlPDzbmVjHqhtzB36Q0dkgOGDVO1MRQEa+3VqCgfUGk=;
	b=mw7LyG2vzrWASv9TLpYg+7jC+SZnsFJt/6yQft03Ds66AD/FfQ7BvYsJCeiDK9SM6tVh
	 /UNczrnVWHpZShltAICeth5/ID/jOlTC2yOFn3QN9fPplOEdlCMAx+sSZOXP2z8jOqqxP
	 qfqEPKDaQbXIiZyWSnGgdCY6QSPXwo6t2pXgGYyvcHhEVM73xbOEqcvTp+3thNXQJR4Ne
	 IdkrsH/P2jWjiLxsuxHQM4haaGNoPWWnZU7lOn9DMltnLOfSD0rjBwEgpwZnujb9Lkup5
	 QwzvKlZZvkZ9ZoeiHsB7OJtJUJxOeO9DILBYE+NsQYIsyZaDNQHoIlu8HawcCksUwoQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=virtuozzo.com;
	spf=pass smtp.mailfrom=virtuozzo.com;
	dkim=pass header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=selector2 header.b=0ATUDqWO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.66.130
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11022130.outbound.protection.outlook.com [52.101.66.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108D8606A325;
	Wed, 18 Nov 2026 12:55:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 108D8606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=selector2 header.b=0ATUDqWO
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bJX8ytJJBnsTVgZnSa5IkZfs8kyudDz4xhty4YyRwG49TEyGvxxsKZcbcC2LAGDtT82jbAjzT6us1wvTxIzq4iRIYDWCglkoUs9USCHKJTOb6Pg6e2vm/8nkso02ifBNkk24FhzNxSDgogiGLU+W7Eli1u95WwkSpKHTk2eYklsZoW8ytkKNhPRfpY0tPMVOYzWXJOZpf6N6oDlmB5CQx6UG5vD9/pZJ4jLhYDii/a84fXqB8Pm2YqjznQCzAUJKEjUJmWJUqjh+Rn3WObuQiakr05KS+1+gXUclRBOZA3DrtFxlePaSp/mXaCJbJCpZBiAFH0LKITwMo8ZJFXLzOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rlPDzbmVjHqhtzB36Q0dkgOGDVO1MRQEa+3VqCgfUGk=;
 b=YwOdCuvUrB7PMLoAt58oNVmipR3EJedpUJ6y8VPHh6eNm8Gp0hv7mviwasVOYRaf7QQanwwmes97ebhoQ6keYig2iouB3AFLSfckytSpGwcMU23JoHq9c8vHW67Z+rONtbc/7sBJg/FyiMW9oFFydgRBXfaue6x9f+ro9PVEdjgvfaxjJFrl+tVHllzvj3p1RY+pH2Ol5nTJF5kM9H4BXMWs3orLowmoW7LoKMq5DAUYDCJYE1ZKTc2Q4VYxzrOCnSAwdoAt15TxCJpWMFZC/3EzFS8Z6WoYIlpmdzocVTzSAJz26xoRaDu3Pz8G5K/MrwyGoe7Oe79ewcRagurbLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rlPDzbmVjHqhtzB36Q0dkgOGDVO1MRQEa+3VqCgfUGk=;
 b=0ATUDqWOs2fqfuw8EgiZ9q4Ubqj7j8yNDcM7c8kKDFm/qLNZO2YyMxgBCKf4C/imMzIAM4D3rlxVtsf2iw2LFfM/bbs6tJw/8apNLIXNSFrtZT9y29h/KPI7S8KWAamS3IUAooK8G4KUPziyTgDEel0c2BLbAUf2xV0IAe48bayMZLbU+YuDTKxXP/YjPjWj+7yYK4i7C3RGuncBeTZb5KwmGvZl26UTopI5M3AumIuIHqjlzfmkYVAWNyCleM0bY1/CEHrk2QMzV6saTQxkOPL+zDdBY3P0Dt4Ky8ZjgPdnxgwldMmsh1h6vn2CyUEn0Uuc+hMrpSpyUfmCtQpVZg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from AM0PR08MB11804.eurprd08.prod.outlook.com
 (2603:10a6:20b:747::14) by VI0PR08MB10457.eurprd08.prod.outlook.com
 (2603:10a6:800:1b9::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 12:55:40 +0000
Received: from AM0PR08MB11804.eurprd08.prod.outlook.com
 ([fe80::bf46:f137:f6d2:5b3a]) by AM0PR08MB11804.eurprd08.prod.outlook.com
 ([fe80::bf46:f137:f6d2:5b3a%7]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 12:55:40 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v1] fs: add ->f_real() file operation
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, 
 Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org, 
 linux-unionfs@vger.kernel.org, Ding Feng <dingf3ng@gmail.com>, 
 Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
In-Reply-To: <20261118123105.1247627-1-amir73il@gmail.com>
References: <20261118123105.1247627-1-amir73il@gmail.com>
Date: Wed, 18 Nov 2026 13:55:36 +0100
Message-Id: <179500653692.684213.4730864102080566101.b4-review@b4>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: BE1P281CA0426.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:83::11) To AM0PR08MB11804.eurprd08.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: AM0PR08MB11804:EE_|VI0PR08MB10457:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f5f8d46-dbab-4c50-83ad-08df45733f8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|23010399003|376014|52116014|1800799024|22082099003|18002099003|6133799003|261009223027099003|261026140227099003|56012099006|5023799004|261102130727099003|261102123227099003|261028144727099003|261026121527099003|261022105027099003|261021121427099003|261021123027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	LehSGXlxRpQ0PPFTNLVZMU+U4o7IxriUZjuybLaT0Nu8erFNWkvgrybglufV9LSJbEjqsPTddpX36ffMhW3An3opvk8DbywU8GTU41azNYsxg75qcw2AKQMh9fe3gsFn/uloym9Son/fj3mAx/7t23sWo7+XQ0Pk4BpXfStbyaXoZ1Sd3p4JQdu0+xiYHdOQyNvQQcpoN8BFruf4nWY+meeC5ilx9dCb1wqMCD6toO9smsonM/42psbxcpX6w5tv+v1Vu5qfh+g2OrR4b8TaoRittUNpm87PLhX7ESgxHMzN9BIk51jFm/oF9Bl2MVkNi1qRthsw5dyaFFyPEhL+zYlEJhx8J2Ka+9gCyTU+dwJLwAsbOsWMAAbKmed/6WA2jBlBsPaMUmXhftmV5Gukf4t/IppWOIy8nc0Aka1U3b64BFeTBsfUuYbpdPUvfzyynuqOUjQvwfa399ydb66bWIBZF678ozeQ5PUvoY5JN+fX+jSiB3VrgmUiZeeQfE2+U2Y25EBVENpgG51qiB5m29oXUraMvNBxj6L3VbZcdlf6P0gRArHqD2cKPrs8HRKnyabJLwPiIBi7WiLxnFNgdBZ2leGaOSJzK/9KQZ+CfFoG4w74URqaUkbb8PJPQmmr
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR08MB11804.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(376014)(52116014)(1800799024)(22082099003)(18002099003)(6133799003)(261009223027099003)(261026140227099003)(56012099006)(5023799004)(261102130727099003)(261102123227099003)(261028144727099003)(261026121527099003)(261022105027099003)(261021121427099003)(261021123027099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dk5xWFdOa1FVZTJjb2Q3K2F0NTV0dlpHQnI1YjV0REtXeWw2bWF3dzlmby9r?=
 =?utf-8?B?VEhDRVZwTm9XZzh0UVc0dk9IRm9KN3lOY3ZLbkkyeUltQ1NvbGJuSDV5MDlN?=
 =?utf-8?B?NXZTV2ErbzlIN2o2SDZqYVVmd3JQaldsOXRRVkdzaGhMeGIrL3ZFTzA4OVRQ?=
 =?utf-8?B?Y1MwRzRXeDhTdEVkNkRHVmdnOTBzelY3blFwREtwbVdZc2NVamVBeGVucm9x?=
 =?utf-8?B?dDJxMHpWWTkyaFNFNk1sMzl5VDVVWGpjOEd0NnhUSU5XN0FxZDlacHV0Vnpn?=
 =?utf-8?B?ZThhZzRhOHMyVk5NMGxLeS9NZEJCZjZVZkQwYXFzcXZESHlwNTJETFJXbWhZ?=
 =?utf-8?B?QnQzZ2diVTVuSXY2Z2tzaCtVaHlTYmFDNkJ0bS9rckl3R1VmVWVXOHdsOVlB?=
 =?utf-8?B?cVNQVVg1OEJuOERFMEZoNTEvTzRvWlhIdUdYcHpkV1dEeUsrTXAyck8xSHdH?=
 =?utf-8?B?RjdtTlpGYVJTWGFDYWF4UWRuSEFvS1dmVTlWYWpxSE8yNEdrd1hOS0VUWURK?=
 =?utf-8?B?Ym11VjdKV0lCa09YY21HaUQ1TE1LV0cwVGViVi9wWjBiMUdHY25wb1RxcmJU?=
 =?utf-8?B?K3MvQTRBeGhsRUFUenZuYWMwc2o5WWJvMldnTmk1Y3NBZ29IcWt5V2hmd09K?=
 =?utf-8?B?ZEtTbFN4ZGw3cjJsdU1kMlpGTmRNK2RJUk15RWxHSE44K3dacDNQcHVUd3M3?=
 =?utf-8?B?N1RSU0hvZUhqdUdkbGhlMkFWTDl5VVRoNUtnZVFHWkhRSnRBRE5JNmNsYkFD?=
 =?utf-8?B?eTlIYldRVitNdFpnUVNWVDNRR1FwWGR2TWovdExhaWlmZ0YwV1RlZjBqYlE1?=
 =?utf-8?B?bFRWK0haMU9kT3Y0TDZvNzd3d3p0d1U3TXpVQUZ1REsvcFo4aXhodHUvOEo1?=
 =?utf-8?B?ZDVPWDF2aXc1czBqNTdwRXZGbVZCcUNHeTQwbm5nTjMyZTNWUTNna0JPSlBB?=
 =?utf-8?B?TEQxQWY1b1kzZ1pNb3ZpN1l1V2cydUlpb1ViZ0lPYk9nZVIzM3ZkaGRMRUN0?=
 =?utf-8?B?T3BHTEVyMXRIalZLOUhWV25hMWFETG5Vdm14cnlrOVpvaUZMV3VITE5GM0tJ?=
 =?utf-8?B?Q0h5Q0d1UlJxcmRYT1JMZmFoN0prTjVFVTRxQUlnNThMS3UrT0tGOWhlMWtW?=
 =?utf-8?B?ZmNpc29QTk1CaEk2cFZMWFZhempWNlVTc3Y5NVp2cUxPdFk5RVlEUWM1MTUw?=
 =?utf-8?B?a3BUcGJSazc1Qnh3alRIWGR5N2ZxV0RXKzIyeUgzK3BlbFlhNmpWZWhlYy9V?=
 =?utf-8?B?SDlFUnFyOXc5bXVnTWFKdlQ4YlFUVkt4UjQrTUEyK0VHSnFwSDh2OEltUGVr?=
 =?utf-8?B?TTJ6aGxOclhQUUdPVjJuV0xYdDNVbmZZR2hqbkJDaFcyb3VVMG0wTG9LVnFk?=
 =?utf-8?B?Zk1rWEJDQURyaGM1OEVzcHE2dEQyenRjckRNWnR2R0ZPZjZmR2diNm5yRFRz?=
 =?utf-8?B?Z2F6Tm9kY0N6eFk5azZEeGNHSGcvRno5NkZEcjhzTXM4TkptR3ljYURZakh4?=
 =?utf-8?B?aDZ4dU9VUnJrcVZVOGJaUk5EYUFLL0RmQmpjWW5iQ0xwSnE2NWlSUm93blNk?=
 =?utf-8?B?aUoyYnJuSWNKOFovZk4ra2wwUEVIaTZTckNQK2RGVm95UEdyaWRIWm45YVZI?=
 =?utf-8?B?R1I5UFZpUXhIYzBEMkpUL0NMQnB6REovZTFBYlUwOVVaYVBWbU1Pay90YW9G?=
 =?utf-8?B?RlhlN0ZBZHBBaHNpRmZCakhaMXV0ZGhIUDMxTEtyUkkrVWNsTGJwdkdJSVRo?=
 =?utf-8?B?akI2eFV5WFNHenNrNlVhTEd2MU9kOTlpdHlRRUswa0lRUjhrekZLOFVOTFdx?=
 =?utf-8?B?dGs2ejg5SzJXc0cwM1V3K1gxUE0zUFJYaVBPREVESDVUSkxKaFg4MUVlWmlU?=
 =?utf-8?B?amxUbFN1YmpIU2pvWVJBaFlGRVVXYzlKaXdvYTc1NWR1cm04VTVMcmlWMXpw?=
 =?utf-8?B?S01TS3NkQ21nZktPa20xdndoSDVwbldoTEN0WjNTZDlGOU5ESG43QlhzbzRH?=
 =?utf-8?B?Sk5ZbVMzN1k4QTJFUzkzV1BBZ3E3d2ZGK1QxTzJTUEpSOUIvckFUdkJiZ2tN?=
 =?utf-8?B?V1kvdGtLdmVNYWVCL3lIUHNReG44SjIza25aeDg4NHFlek42OWIyZFdkRmdy?=
 =?utf-8?B?YkcwNXc0Y3lGZHhibFdsNVdMa2pQclB5ZXFUUlE1UC92WnpHek1aVkw0Z1BY?=
 =?utf-8?B?RlFmcWYzSW5rUTdLMzN2T3RNRmNjYUtaR3Y3NmtZYjRlK2ttSU8zRWRlZmRQ?=
 =?utf-8?B?b2wrMXFxcC8yamFLL0pJenJKK2xiT2tMbVBNOFp3bDBvM2xsc3ZBK0dSTGg3?=
 =?utf-8?B?T3RsRnpmWGkyL2VjUm5VMlBtajJUMFpUdlF2cjI4dlFlcm5jWlNCRlBZL2JQ?=
 =?utf-8?Q?ZIZqYOF2elgeY8kRW8uAeelggr8OWn0aU3nfeVfzqpdyv?=
X-MS-Exchange-AntiSpam-MessageData-1: 66maFQjeI+6sXnAmEYg2CmZCz6R2+bdS1uY=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f5f8d46-dbab-4c50-83ad-08df45733f8f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR08MB11804.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 12:55:40.0595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tS8jf0rc/JH+eA7VDeDObX07CtfKxrvKCljpwrcplvX63Ic6fnBVHWhQMmyp6h+GlAdiouWj2Q4uutHyzpeBiazMfUr4ltSWdQfNt6PuPco=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10457

> sync_file_range(2) and cachestat(2) operate on file->f_mapping.  For a
> file on a stacking filesystem, such as overlayfs, the data and its page
> cache are in the real (backing) file, so on a stacked file
> sync_file_range() writes back nothing and cachestat() reports nothing.
> 
> Add a ->f_real() file operation, modelled after ->d_real(), and a
> file_real() helper in backing-file.h that returns the backing file
> holding the data of a stacked file, or the file itself.  file_real() is
> a no-op without CONFIG_FS_STACK; otherwise its slow path in
> fs/backing-file.c calls ->f_real() and verifies that it returned a
> backing file.  The real file is owned by the stacked file, so it is
> valid for as long as the caller holds the stacked file.
> 
> file_real() is only meant for inspecting and writing back the page cache
> of the data.  Operations that need the credentials or permission checks
> of the stacking filesystem need a dedicated file operation, like
> ->fadvise().
> 
> Use file_real() in sync_file_range() (also used by io_uring) and in
> cachestat(), and implement ->f_real() for overlayfs.

Approach looks good.

Would you mind taking the cachestat selftest patch together with it:
https://lore.kernel.org/linux-fsdevel/20260623111533.2285005-4-ptikhomirov@virtuozzo.com/

I will test it on your patch and update with results.

> 
> Tested-by: Ding Feng <dingf3ng@gmail.com>
> Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> Link: https://lore.kernel.org/r/20261118040056.6543-1-dingf3ng@gmail.com/
> Link: https://lore.kernel.org/r/20260623111533.2285005-1-ptikhomirov@virtuozzo.com/
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>
> diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
> index f7363ad770c76..db9ba2a8c13e7 100644
> --- a/Documentation/filesystems/locking.rst
> +++ b/Documentation/filesystems/locking.rst
> @@ -485,6 +485,7 @@ file_operations
>  			struct file *file_out, loff_t pos_out,
>  			loff_t len, unsigned int remap_flags);
>  	int (*fadvise)(struct file *, loff_t, loff_t, int);
> +	struct file *(*f_real)(const struct file *);
>  
>  locking rules:
>  	All may block.
> diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
> index 1824462a43711..e4ce15545244b 100644
> --- a/Documentation/filesystems/vfs.rst
> +++ b/Documentation/filesystems/vfs.rst
> @@ -1038,6 +1038,7 @@ This describes how the VFS can manipulate an open file.  As of kernel
>  					   struct file *file_out, loff_t pos_out,
>  					   loff_t len, unsigned int remap_flags);
>  		int (*fadvise)(struct file *, loff_t, loff_t, int);
> +		struct file *(*f_real)(const struct file *);
>  		int (*uring_cmd)(struct io_uring_cmd *ioucmd, unsigned int issue_flags);
>  		int (*uring_cmd_iopoll)(struct io_uring_cmd *, struct io_comp_batch *,
>  					unsigned int poll_flags);
> @@ -1162,6 +1163,22 @@ otherwise noted.
>  ``fadvise``
>  	possibly called by the fadvise64() system call.
>  
> +``f_real``
> +	stacking filesystems (e.g. overlayfs) whose file data is accessed
> +	through a backing file implement this method to return that backing
> +	file.  It is called through file_real() by system calls that operate
> +	on the page cache of the data, such as sync_file_range(2) and
> +	cachestat(2).
> +
> +	The returned file must be a backing file (FMODE_BACKING) or the file
> +	itself.  It is owned by the file and must remain valid for as long
> +	as the caller holds a reference to the file.
> +
> +	The returned file is only used to inspect and write back the page
> +	cache of the data.  Operations that need the credentials or the
> +	permission checks of the stacking filesystem need a dedicated file
> +	operation (e.g. ``fadvise``).
> +
>  ``mmap_prepare``
>  	Called by the mmap(2) system call. Allows a VFS to set up a
>  	file-backed memory mapping, most notably establishing relevant
> diff --git a/fs/backing-file.c b/fs/backing-file.c
> index c601b27f0fd35..1e0e85515b4c7 100644
> --- a/fs/backing-file.c
> +++ b/fs/backing-file.c
> @@ -102,6 +102,18 @@ struct file *backing_tmpfile_open(const struct file *user_file, int flags,
>  }
>  EXPORT_SYMBOL(backing_tmpfile_open);
>  
> +/* Slow path of file_real() for a file with ->f_real() */
> +struct file *__file_real(struct file *file)
> +{
> +	struct file *real_file = file->f_op->f_real(file);
> +
> +	if (!IS_ERR(real_file) && real_file != file &&
> +	    WARN_ON_ONCE(!(real_file->f_mode & FMODE_BACKING)))
> +		return ERR_PTR(-EIO);
> +
> +	return real_file;

This will go one level only AFAICS and in case of nested overlay we would not get to
the real file.

-- 
Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
