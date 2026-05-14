Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012037.outbound.protection.outlook.com [40.107.209.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B713C4B89;
	Thu, 14 May 2026 14:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778769480; cv=fail; b=fipXRbSxNSls4SrtDeXlJ1GT9dhsL/UUqprvdcpys8At5PIDizQAjF2xVX/xxQdeuNC47N+/tOqrXzxb+ZceteVf9uVKqrMv1VMn9dMq6Ya+v/cMDtRSy8rG1NndtvzZxvInQZjqp126/voufbHtHTgRIUvZNaZCkkgbTNucuKY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778769480; c=relaxed/simple;
	bh=aTNZjZ7l3SUgoKGdSl/akVM0OwOC3kfpYCKw326x79M=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ZvVEcU7xuvU1Uyz6xo9ksEH62fjoBhKaGSi/xDUSzlb1iwnVTh6OCSjXvpiw2pV4l91N9GsO7ixq22kPF9bFhVBkf9Shn3gD17of9DnyMsyfmoGRLY2wPOcJcxe4KWon/5HWfEeI6FYJfgE0JmtvdQXAHErAMiIOjKxsGf4Cjo8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lbphaYLP; arc=fail smtp.client-ip=40.107.209.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lbphaYLP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JUAKZr6vf+QrS6HVKs/zVu61wyB+UVIFFvvojZBAYrf+UeiRmuAfg3I0B/bfG3zndhVE+np0kczsoRgaybE+nsetuRs53XMqR+6yXN4PbxrjjYeEWZuUBeQ4YjI3AiFD7cvHviuiOy45q1XtXibEC7+z6poUrTpDMjAjMwoN3l5Lm7B18iy3xTngFezKJG6chR+WKvT7ey8mf+5CUXlY9nmeH52ATPCO879fxFXoHmOBd0kvQ8k0OYQQFJXr64cPNcyc8PTyfvXDQhh85ZukDG8dR8jbGjP98IEpu4ZSnlmHMcDRx9PFwPu991tZHx1vLTHjq0b/Vt6jKN3i9lQpCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y7VkuhYXkzT4Szy9lu4tpUb03xpCalL9A2wpbNf2kWg=;
 b=yRIYPZk431C3z7XeVOHxhkhhaT7V6UhvtMY10DpSCOekGE+/MuomTM1fINkKVc/2slm9NadDi/Z+3243UYvTR2r5InpK7M1k8dLdM4f3Hyb/jWNi+KRuSx7gWLV5wizsN8Xjte1VLsHU6vhzITtmBjNsmC99qs31RmNrevvEx4hftY1C6XhT+Q31yHaw96tHs1Afb3G+L817eeRGUfOrE7Me0la2aJJF5b60VseFwD+IRKb4vDdZ9i+CL2MbYXTHy6aBQKryJKb5rvtwDMo5iWYMjSvzRtuRMZWv981J0pGjOcCuZ7stkO7gkxBfBjcffHGFAKCLHMFM848glzdd0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y7VkuhYXkzT4Szy9lu4tpUb03xpCalL9A2wpbNf2kWg=;
 b=lbphaYLPP5JVxcRBu7eW0eAKd2pQ8aBhDeWDv/u8sLjQz/d9Lqf5NDna3hGaMYP3WQNHBnRsjuGyXdMRGhRjLcpmXmLovgKCRvP9DrrG3mawbRNsLzgkNUPQZEZUYg/NBJiTZg4Ulv/+T1wnxho+/RZe4aCsk4Xy+r0ALVOkjIHhxYurQsTdXGk+YGdx3YGi60kGVzjOETApK2kgPSijNeQK4kQDyeqDoiOwErF9KZXsXpntKI2TEttTQGrrSJAyTY3M9mCor7cRmxp8mKq1f51jfDdA+iKV8V8/H9I1i75fbQRgOzHpjoqDXqQLX9KbZFGbECY15exNv3/C75+nkw==
Received: from SJ0PR05CA0074.namprd05.prod.outlook.com (2603:10b6:a03:332::19)
 by CH1PPF934D73F2C.namprd12.prod.outlook.com (2603:10b6:61f:fc00::61a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Thu, 14 May
 2026 14:37:53 +0000
Received: from CO1PEPF00012E81.namprd03.prod.outlook.com
 (2603:10b6:a03:332:cafe::8c) by SJ0PR05CA0074.outlook.office365.com
 (2603:10b6:a03:332::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.25.16 via Frontend Transport; Thu, 14
 May 2026 14:37:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF00012E81.mail.protection.outlook.com (10.167.249.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.13 via Frontend Transport; Thu, 14 May 2026 14:37:53 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 14 May
 2026 07:37:31 -0700
Received: from [10.125.196.95] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 14 May
 2026 07:37:29 -0700
Message-ID: <12c79ebf-1763-4403-a829-8a573efb0b86@nvidia.com>
Date: Thu, 14 May 2026 16:37:26 +0200
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ovl: keep err zero after successful ovl_cache_get()
To: Amir Goldstein <amir73il@gmail.com>
CC: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner
	<brauner@kernel.org>, <linux-unionfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>,
	<syzbot+a16fb0cce329a320661c@syzkaller.appspotmail.com>,
	<stable@vger.kernel.org>
References: <20260514111354.3552538-1-nirmoyd@nvidia.com>
 <CAOQ4uxiamuv4uqrN5KedzmJKjz0AX8xVrDuEdMqJ_uD4gEm24w@mail.gmail.com>
Content-Language: en-US
From: Nirmoy Das <nirmoyd@nvidia.com>
In-Reply-To: <CAOQ4uxiamuv4uqrN5KedzmJKjz0AX8xVrDuEdMqJ_uD4gEm24w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E81:EE_|CH1PPF934D73F2C:EE_
X-MS-Office365-Filtering-Correlation-Id: c6279ade-7f11-4c55-d413-08deb1c661c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|82310400026|376014|4143699003|22082099003|18002099003|56012099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	llw5qO5svzWOkN59XjiafeFFRXUo/xjNIMG6tNNYkiUWFtTgRBIhorSjlhdZkJamLHUKEzCLnwffUTqSxGNrso1mzJSBpkD5uqdSiW5kVKCfFqkWmMeDxPU+tn4jgB8rBZAyTnRWpNZQeh96tlMYx5O4Vq8tDIuyd8t0f9XM5koBbfKVT/8xPBJc9HCocP8kxUOZHbGc4fWEeOXQ/N26PazII1GGxflDEbGvEKJVvGTPc4UDifyguPcIGuRPWwgEKFOEKBc+X4I/g7+Qyiph1Yv1zh0W5diuf1qp9rH2PJkweYAY4+eWFwS+DKHcfEIZzKlQbl4SuRmwXMc2OLFMT1jmrll758JDEhEk/ytFbyjM8jM1LydN/4kaXOiWKY58e5wmmZO21m0CJiz/eqPTEUxfsZw6SenToEIWC65A3dKPBC7Jueqlkr2k8SAVBpwF8wHc1ryZhMgE0T5Kae2izvmrxmkc1TxvIlOUD241eqPLEN7F86wC3m4iYNv9ktMkSGMrEyVM5tXds9veZg8/Dmkt2c5rTNyeos4g5rWzfM1j2DRn4Id2ID+mvbRS7dX+WcYalShv/164egrQTmA7OnlqgHNRqCPfKkVkfXCK2NczWsUsY7O82lQvby9gUzMAcRTRZ2Rs2mmEJ4Sw0fOka95Op7SVNLxaSa99x1OSOlHSfWH8Cw9bWSLnsQ2oGacrcw6x5UDQ7dZBes2oi9tmY4i46O1lGes6wL3GjFrPGms=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(82310400026)(376014)(4143699003)(22082099003)(18002099003)(56012099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	vKHHowtzg37g7Qa9xWs7iFRUBePcxFJKnbMQBAzncY2trYkdN5NwteRSHQ4iZgXvrfM+8dKx/dSmAj0JmDzcV4cpslRqtLg5V6b8p8JsgETZKt/8MG8nnnMwU/8qy3WpjoX8VWIpo16GUA1JMakErLsADseF80YezOyktpTf0SUwRm7ul42lH8fHC7w4AfEIPe7qpoTqxRNaTu6zY8PhCnitfkTk/WWHqvL+vxeZPvAYr+/+50lvBr8DhkG0TrBpjQDYcITkC3KYOjYPCZ2iFa/wIVbs5tlnmZVafji+2bgW8E+jbonNSnQDpQ8oy+TG9GrVGH5ww59GA8PDnc1eYwCCp2vbZP+GhpJmM85Q5sLrL1wA0O1pureCYtGuccb+CBmQypGvzjHYVLjerUMTZKFdrh7cfMx26TapZj8woFQ0cPrmmfg+QJ08PPhpcUV5
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2026 14:37:53.4013
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c6279ade-7f11-4c55-d413-08deb1c661c1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E81.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF934D73F2C

Hi Amir,

On 14.05.26 15:36, Amir Goldstein wrote:
> Hi Nirmoy!
>
> Nice catch!
>
> On Thu, May 14, 2026 at 1:14 PM Nirmoy Das <nirmoyd@nvidia.com> wrote:
>> ovl_iterate_merged() stores PTR_ERR(cache) in err before checking
>> IS_ERR(cache). On success err holds the truncated cache pointer and
>> can be returned as a bogus non-zero error.
>>
>> The syzbot reproducer reaches this through overlay-on-overlay readdir:
>>
>>    getdents64
>>      iterate_dir(outer overlay file)
>>        ovl_iterate_merged()
>>          ovl_cache_get()
>>            ovl_dir_read_merged()
>>              ovl_dir_read()
>>                iterate_dir(inner overlay file)
>>                  ovl_iterate_merged()
>>
>> Only compute PTR_ERR(cache) on the error path.
>>
>> Fixes: d25e4b739f83 ("ovl: refactor ovl_iterate() and port to cred guard")
>> Reported-by: syzbot+a16fb0cce329a320661c@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=a16fb0cce329a320661c
> Does this fix really close the bug?
> The report is a UAF, which was fixed by the other patch.
> Right?
I think the previous patch was masking this.

KASAN says "maybe wild-memory-access in range". If I'm not wrong, we 
would see "use-after-free" or "slab-use-after-free" for a real UAF.

Reproducing on aarch64 virtme-ng + KASAN with the unpatched kernel I get:

Unable to handle kernel paging request at virtual address ffffffffc1c02d50
KASAN: maybe wild-memory-access in range
[0x0003fffe0e016a80-0x0003fffe0e016a87]
[ffffffffc1c02d50] pgd=0..., p4d=..., pud=..., pmd=0000000000000000

The patch fixes the issue. Without the fix the reproducer hits the 
crashes around ~1500 iteration. With the fix applied it runs > 5000 
iterations with no error.

>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Nirmoy Das <nirmoyd@nvidia.com>
>> ---
>>   fs/overlayfs/readdir.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
>> index 1dcc75b3a90f9..0d471064cfea1 100644
>> --- a/fs/overlayfs/readdir.c
>> +++ b/fs/overlayfs/readdir.c
>> @@ -844,9 +844,8 @@ static int ovl_iterate_merged(struct file *file, struct dir_context *ctx)
>>                  struct ovl_dir_cache *cache;
>>
>>                  cache = ovl_cache_get(dentry);
>> -               err = PTR_ERR(cache);
>>                  if (IS_ERR(cache))
>> -                       return err;
>> +                       return PTR_ERR(cache);
>>
> This is good but also no point for returning err at end on function at all:
>
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -838,7 +838,7 @@ static int ovl_iterate_merged(struct file *file,
> struct dir_context *ctx)
>          struct ovl_dir_file *od = file->private_data;
>          struct dentry *dentry = file->f_path.dentry;
>          struct ovl_cache_entry *p;
> -       int err = 0;
> +       int err;
>
>          if (!od->cache) {
>                  struct ovl_dir_cache *cache;
> @@ -869,7 +869,7 @@ static int ovl_iterate_merged(struct file *file,
> struct dir_context *ctx)
>                  od->cursor = p->l_node.next;
>                  ctx->pos++;
>          }
> -       return err;
> +       return 0;
>   }

I will send a v2 with this suggestion.

Regards,

Nirmoy

> Thanks,
> Amir.
