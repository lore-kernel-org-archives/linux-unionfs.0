Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012018.outbound.protection.outlook.com [52.101.53.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F2535E1A2;
	Fri, 15 May 2026 19:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778872702; cv=fail; b=A4pPQhvgjJfsJc3P78JEk2medCf5yiD74O5xAMriNwruohjVKUloFrPKvEDt/qVeVpvH3AgnkOU9RWGi2Xauc77NHEN5YXvpvPndU1j5jXoo9rLESioB6j3C3IpAcaXilszgqRhGOKCbtGfx8QhB0DOVGa16/B34+MA3wwituzA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778872702; c=relaxed/simple;
	bh=RTawQjefqIicWIh2DcrHXPrK17bCws+lfrRT19+Pzgk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=OWUcInaiY77WVzmaIhaWRzpZXFQVh213iQPHlUtT9zxl4Kh+WPjsy2oYDfIKcqYyHO0JLSeqGT04GO5S4RiKrDjeQPU3avRR/We0YLUKaTVQRxRbBOfgM1io9wkVpBnYMxzy69coa/YDnYUz0FdY8FYV30WveK3cZ8zTuNDgpdk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jX5lnG/o; arc=fail smtp.client-ip=52.101.53.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jX5lnG/o"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wUM4bCZpVm7Wb7QCimfs2R6hpu8G4q5rTH/pQ1wRKL8tQQhXQEKqN7Sc4sVzPBMt0sk05UTJJIkjWRnlLvuDqj2iJFsPOgH9ZSthTr1j/gcmla9Yt+B/8wCRKUyvag7N7p9xyST2kzgDF41fmkiviRxBpydUv0t+zZLDY9gY8r5AtrjEZuG9RzCu+U1LLk8+V2eOIK/Vm8mNyzNbRDJruljV6zt5EYzeaa0A8Mrx7zk/uUdx90+DvJu5Fv5Vg6f4vQdXAi5Gi4Ny4QH4/SlkelDwhxi0dnmRP3z865yZr4C7hWkOU69ECoayBKR6N9z/xmdtkdtnfEJ3dghwaQ+zmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m0ns46uhb8Y3Owuj58IVFSOro4PP64xAC4n3l/gygvQ=;
 b=FTidhjgaHzE15dy6GhUpt+qbHSel8ZHlX+zEt75Eo4mmGm2PA6TEa8Sw6h1cDQUtZ5y5pQbPd2uTTR7p6TW7JnfBXvM2xVF+PkmmfLrvHXtkRQ5Dw6kKRC7A655wq0sHvMGoSAcnclaOrQIMroenEWKCZ2vUE3BwUJ1GIr5BvPiy57VnHymwXAvo4Cr2vl+NssNOFrMq+NeVxQ3F5ejwGZRLzbA/K9IeA896w46GZJOAAQTn7ZbfV127GEadZT4KEIigtcHH1k6y/7MzjVPzQmBfWq3vgRHsWlVvOcfo8/LkqwSsGzZl7JZzy82a3yO45sj/AEPMJ0p28nIT2L4D0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m0ns46uhb8Y3Owuj58IVFSOro4PP64xAC4n3l/gygvQ=;
 b=jX5lnG/ohp9JZ+kvSSO2WLwcco1MXrPXjSAQ8iB7R20zv8BDegVmOLCUs092eTDyBPRDMpaV2yTyfi/ax6KiRbV/YZojm17np/HYUDINeTnaYLFIhdaLSgYhXy8OeTMklCSOZmRVPlt64vb0xcdUg36zQz1D3iGQwSSx3QScw+brOSS29Vj00DeZaeyRT1zkrHj56tbLXbC4BN9Y165i6AKO9dxBRfhbSuFtEf8lHwMKXObxeOeo4CnC7ES4dywyJxh9c/nzQbgWDjGVNtSkN4BXQnd9BeUx29+AhZ8snnVleoD2LMdTXEIvtaaZ5xrqfOrw5G/BuZVl3mp80N8URg==
Received: from BLAPR05CA0012.namprd05.prod.outlook.com (2603:10b6:208:36e::21)
 by SJ2PR12MB8979.namprd12.prod.outlook.com (2603:10b6:a03:548::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.12; Fri, 15 May
 2026 19:18:11 +0000
Received: from BN3PEPF0000B071.namprd04.prod.outlook.com
 (2603:10b6:208:36e:cafe::85) by BLAPR05CA0012.outlook.office365.com
 (2603:10b6:208:36e::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.10 via Frontend Transport; Fri, 15
 May 2026 19:18:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF0000B071.mail.protection.outlook.com (10.167.243.116) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.13 via Frontend Transport; Fri, 15 May 2026 19:18:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 15 May
 2026 12:17:51 -0700
Received: from [10.64.160.70] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 15 May
 2026 12:17:49 -0700
Message-ID: <69c67d3e-84d6-4a86-a233-c89da9d28fc4@nvidia.com>
Date: Fri, 15 May 2026 21:17:47 +0200
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ovl: keep err zero after successful ovl_cache_get()
To: Amir Goldstein <amir73il@gmail.com>
CC: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner
	<brauner@kernel.org>, <linux-unionfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>,
	<syzbot+a16fb0cce329a320661c@syzkaller.appspotmail.com>,
	<stable@vger.kernel.org>
References: <20260514111354.3552538-1-nirmoyd@nvidia.com>
 <20260514144258.3068715-1-nirmoyd@nvidia.com>
 <CAOQ4uxjGhRLnuU_=m=P-omUMM=0F+Mxs1O=zTasVnLdLz8ut3A@mail.gmail.com>
 <CAOQ4uxgad=DE9wMAS6Wn9rrEkOX3p0S8jEhsjnj=Or=_7HsqyA@mail.gmail.com>
 <20be39e1-8da7-4f81-9134-d748841b3611@nvidia.com>
 <CAOQ4uxifua9RvEGJfU0ho28Lkdn_oqS8fBYiyxBC0Q8PWc2nJA@mail.gmail.com>
Content-Language: en-US
From: Nirmoy Das <nirmoyd@nvidia.com>
In-Reply-To: <CAOQ4uxifua9RvEGJfU0ho28Lkdn_oqS8fBYiyxBC0Q8PWc2nJA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B071:EE_|SJ2PR12MB8979:EE_
X-MS-Office365-Filtering-Correlation-Id: 3694d353-04de-471a-7e76-08deb2b6b485
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700016|56012099003|22082099003|18002099003|11063799003|4143699003;
X-Microsoft-Antispam-Message-Info:
	RTUYYGqQGxiLqbaaZa9yeafuGsZD5Jbp4I30Pn3OR6X5qQBc8oZJB6Qh2j3QZWQn96ytrtZoUJKku3gvjW7tBrXVnpNc7uDk+Y5pCRaKHbEUkh6s7Gmui349VZ2bbTTVr/YoTrXPmin/SRUZmxzH4HrV2J5GfjKIqlcVsTuHgBruMSYgtQy3nlPQv3d9xHoS6lNfkXbCYnM11JMBbjqhpFbzJtlj3py6d2jOyT4cE+VN99vGp5GyHkNN4oDRu4l6qmvTyRLZ5gneTxJRmz+b6Wz4ZSFqSprrfxOLWlpM5RR2Mf2/sK57FsGCIInNwOL3Jot+elO3FGNCdONURa46qIujPZW+SWTQubQYkJOi5ywAwfORWEW3kU3Odj357G5zbtg3Fe4UI6SZE00g/+NIfZkbYU3L60/4GeKQrLBRaoXfudkIA6+aG9ACSCcIcfraGklVS8IfkQ7CsIFOUlk4suGNJNvD44JTmP/YzlZDq8S2en8cwoBkPHerNx+w8O1uIVSKBkL16thl/sydTr0qTr+c2KpHhg/4RozrYigV7ohcMWYb7q0UBmWQAGPzD8RefdFGXP4/Uc4tib5IL9jrquOHX6w5Z91fMkBcw83ILkTnIoe2/UkjWoifv+mEO3Xixg7K0wa2bHvxSLDhmTIChQ/PfFJVyPcCglbzqkwpOLROw82KlHKKzrGgP05/gG1Jr/yRlVgATkdxwO0UWf51FqWhoo5R5C/sbNbzCkg9044=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700016)(56012099003)(22082099003)(18002099003)(11063799003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	c9lRf7ot9YZhQtiCyVhpCqBgr4FEr0TI4xrFUsMXvCFUj0D+itYsMMJ2orARCwnPJZ5X4tXUxpKCx1Gxcujog7gAuoYaeoFBy7Xabm7Fe1w+ZEMB1o7qteqfkVhWC6pcUPJz0qYiFqvan7bg7lTU8kYOVcoAzBKdWJx11jOWH/RCuzGkGWg/V3CgwaGB4Mr3hizqJ3LPAxE+TZxC0Q3MoHtdOOCW6AHctca3iWuAoOr1Hk8AzKjkTvFiETP9K0g2HatbeVhR+FXW3aJ+or6SSrhqjHndEiWIEuGtc3PbXpZBSK6eBy7ohSZ0R4FWpZZ1/W4RxMi8KoZTJeK+WmUXeP256fDtg2BMYUMu4SKVnJDqD9UnHgP0Lm9BJvadiuV4rbA3cNNuPl1qatUw4+66+gBn2y2w5eDU/X9TbH7HYZWvFdwELt4m+WeUmUuN07RE
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2026 19:18:11.3807
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3694d353-04de-471a-7e76-08deb2b6b485
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B071.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8979

Hi Amir,

On 15.05.26 19:39, Amir Goldstein wrote:
> On Fri, May 15, 2026 at 1:16 PM Nirmoy Das <nirmoyd@nvidia.com> wrote:
>> Hi Amir,
>>
>> On 14.05.26 22:19, Amir Goldstein wrote:
>>> On Thu, May 14, 2026 at 5:26 PM Amir Goldstein <amir73il@gmail.com> wrote:
>>>> On Thu, May 14, 2026 at 4:43 PM Nirmoy Das <nirmoyd@nvidia.com> wrote:
>>>>> ovl_iterate_merged() stores PTR_ERR(cache) in err before checking
>>>>> IS_ERR(cache). On success err holds the truncated cache pointer and
>>>>> can be returned as a bogus non-zero error.
>>>>>
>>>>> The syzbot reproducer reaches this through overlay-on-overlay readdir:
>>>>>
>>>>>     getdents64
>>>>>       iterate_dir(outer overlay file)
>>>>>         ovl_iterate_merged()
>>>>>           ovl_cache_get()
>>>>>             ovl_dir_read_merged()
>>>>>               ovl_dir_read()
>>>>>                 iterate_dir(inner overlay file)
>>>>>                   ovl_iterate_merged()
>>>>>
>>>>> Only compute PTR_ERR(cache) on the error path.
>>>>>
>>>>> Fixes: d25e4b739f83 ("ovl: refactor ovl_iterate() and port to cred guard")
>>>>> Reported-by: syzbot+a16fb0cce329a320661c@syzkaller.appspotmail.com
>>>>> Closes: https://syzkaller.appspot.com/bug?extid=a16fb0cce329a320661c
>>>>> Cc: stable@vger.kernel.org
>>>>> Signed-off-by: Nirmoy Das <nirmoyd@nvidia.com>
>>>>> ---
>>>>> v2:
>>>>>    - Drop the now-redundant 'int err = 0' initializer and the trailing
>>>>>      'return err' in ovl_iterate_merged(); err is only used inside the
>>>>>      loop's update-check, so the function can just return 0 on success.
>>>>>      (Amir Goldstein)
>>>>>    - Link to v1:
>>>>>      https://lore.kernel.org/all/20260514111354.3552538-1-nirmoyd@nvidia.com/
>>>>>
>>>> I queue this up and will work on fortifying patches.
>>> Nirmoy,
>>>
>>> I pushed fortify patches to ovl-fixes on my github [1].
>>>
>>> Can you verify that the assertions trigger if you revert your fix
>>> and run the reproducer?
>>>
>>> I imagine they would trigger much more frequently than the KASAN
>>> warnings do.
>>
>> Yes, the assertion triggers with your ovl-fixes branch after reverting
>> my fix.
>>
>> 9541f25af774 Revert "ovl: keep err zero after successful ovl_cache_get()"
>> 1c067d912e47 ovl: add assertions in dir cache code
>> 98e3a2d258e9 ovl: fix race between copy-up and open of a directory
>> 4f80bb375112 ovl: keep err zero after successful ovl_cache_get()
>> 18de6460b6bd ovl: opt-in for fortified ERR_PTR()
>> 690bd87e1fef err_ptr.h: introduce ERR_PTR_SAFE()
>> 7fd2df204f34 Linux 7.1-rc2
>>
>> Running the syz reproducer with panic_on_warn=1 triggered:
>>
>> [   55.404636] ------------[ cut here ]------------
>> [   55.404646] WARNING: fs/overlayfs/readdir.c:511 at
>> ovl_iterate+0x4c0/0x5bc, CPU#2: syz-ovl-iterate/14575
>> [   55.406875] CPU: 2 UID: 0 PID: 14575 Comm: syz-ovl-iterate Not
>> tainted 7.1.0-rc2-g9541f25af774 #1 PREEMPT
>> [   55.408328] pc : ovl_iterate+0x4c0/0x5bc
>> [   55.408632] lr : ovl_iterate+0x4b4/0x5bc
>> [   55.413504] x2 : 0000000000000000 x1 : 0000000000000000 x0 :
>> ffffffffc152db40
>> [   55.414036] Call trace:
>> [   55.414209]  ovl_iterate+0x4c0/0x5bc (P)
>> [   55.414503]  wrap_directory_iterator+0x60/0x90
>> [   55.414809]  shared_ovl_iterate+0x18/0x24
>> [   55.415125]  iterate_dir+0x10c/0x3a4
>> [   55.415365]  __arm64_sys_getdents64+0xe0/0x1e4
>> [   55.417312] Kernel panic - not syncing: kernel: panic_on_warn set ...
>>
> Thanks for testing!
>
> Did it trigger faster than the KASAN warning?
> I'd imagine that it would?


I lost my setup. I think it was quicker but I don't conclusive data. I 
will update you next week.


Regards,

Nirmoy

>
> Thanks,
> Amir.
