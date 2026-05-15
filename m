Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010064.outbound.protection.outlook.com [52.101.46.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F3847A0C7;
	Fri, 15 May 2026 11:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778843773; cv=fail; b=hNq1ho0QNed3TYYd2lHFGbjHvRXO2xUWXbaAzkBxz268UD8IoPoOyp9GdhUdNqZ8/jj1z56RNQBkPXnADW4lnLsngJtDp52sbzWBwa/C2UxzzIlAsV22vqlk1Q3RpD9ZOM9+U6TKj8LNjSzMODhQp/vNEhUfbX0Qk969Ydhhan8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778843773; c=relaxed/simple;
	bh=Qwy81pdOxSmrz276VfsiO0kjO8INJjgBF3XBswtowlE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=YkP503OXMe9+j+m5eX4jCi70ATjPesqh9JivTgrLP7+M2LYbSYaSYNtMriygCVNMgTILzSvP1e3uxL/kXFQmer69GFG4/ctuyHsrBUfXPMBXq6ZznrYEPs5N/LIL/5nYOC2GNRNx2TsFvqreRXIKwoqF66nv5QGnGaIRSiQ6SxQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kw2FRBMO; arc=fail smtp.client-ip=52.101.46.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kw2FRBMO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bC8e5u+9GwyPASSnzikXpBgaVcdUU8qglr2uOzqi+f1gqm2afQ/t+mSwrq3O37QqkTSIlKE/kVTsIxGMrUlqwPpw1xlfvgClj2Zj9BwKbTmCCg+DhoXBYlFBQlWp4Ww3LFG7KDZwPbkaJ/rUlhBlkyRyxViDJYpJKgrs0I+SuzN8hQiVv/y6AAh8vDQn534RF4t1N2yGbz8C5CmYJ6mL7l7Tkkg/YaHkng2g+U/TYGWs3drGMTomkRw8A9cDqE+zQRRykHLQZXG8z6WC3cWJomBaxDLf3yEbklNgyY6UAMggUBy3NQEOkTywJVSXDzEOv5wZjwkt59ClEJ9Nehxiww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=To4DNKOgUC/s4g+9Jw0a3SwPYaz1j0fhHgC9ZH+Tu5Q=;
 b=ksk3TPbxALOcb54yXKK4ubkFaff2969/2kxdIv7sxBsHGtzekxj2qgi4TGlCbbIUtckPGhhIpp7hIq5loUZAwnUqQ4RpFQpJAc6+PYw7sK6AtZudMlQdLqZyR/gnLPSqtW02GD+5qYKd4IuAz7ra4eLO75Flny4Y6iBZ6RvMulliU/XApQufW8UcPWoFz6z9H+ERMEBCgIm0vrzRDgt0HtOyg+SyUGJTSv9JQWdsO98oh0evQrc4T7YF5hFPBV2I1sJOgbFjrAB7tgeB7AwfiuMWUuE/I9Fh28c55zWTro31NTrCrt3edw6Ba3czQ3z+/y+B9+CzX7/asrUzb3N/zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=To4DNKOgUC/s4g+9Jw0a3SwPYaz1j0fhHgC9ZH+Tu5Q=;
 b=kw2FRBMOO5rY3iQ0FJci8kv3fKGmSO9PkQoXilAtFgTjt4IpmYEssTvY94zUC44BG3LaxCNgi7EnCrN4yeq8BFPKVVtBLE1IAGmkUwZcmjRhfZQvxLpoCJU6O6X6I96U6PvgKoXD/nMoCIK0/Y2o25noD/qAYo62lrasohWEJqT2urpTmslUnvOMaGde5jfiXCcDh51efsCHKkmt3naR5Bc63d3H7JX4v/fc04DoEnWZMwaybL6/RwYaYfnQn0lQwvvliNZltnVRgnCQcIz5CdlPiboeU515SNt0KqxoL+iZ0B8qFm1nXaIPEkg9/J/tlGU+e03N7xnDfaaq8z0RzQ==
Received: from CY5PR19CA0011.namprd19.prod.outlook.com (2603:10b6:930:15::13)
 by DS7PR12MB5839.namprd12.prod.outlook.com (2603:10b6:8:7a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Fri, 15 May
 2026 11:16:03 +0000
Received: from CY4PEPF0000EDD5.namprd03.prod.outlook.com
 (2603:10b6:930:15:cafe::cf) by CY5PR19CA0011.outlook.office365.com
 (2603:10b6:930:15::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9913.14 via Frontend Transport; Fri,
 15 May 2026 11:16:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EDD5.mail.protection.outlook.com (10.167.241.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.13 via Frontend Transport; Fri, 15 May 2026 11:16:02 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 15 May
 2026 04:15:45 -0700
Received: from [10.64.160.70] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 15 May
 2026 04:15:43 -0700
Message-ID: <20be39e1-8da7-4f81-9134-d748841b3611@nvidia.com>
Date: Fri, 15 May 2026 13:15:41 +0200
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
Content-Language: en-US
From: Nirmoy Das <nirmoyd@nvidia.com>
In-Reply-To: <CAOQ4uxgad=DE9wMAS6Wn9rrEkOX3p0S8jEhsjnj=Or=_7HsqyA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD5:EE_|DS7PR12MB5839:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fb4250e-597e-4718-030b-08deb27359be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|376014|1800799024|18002099003|22082099003|4143699003|13003099007|56012099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	NQyEd8VbH3rBpc0I+Gd+j80NEQCgHNSxhXiVEEcX8ZAxKXh7CMWta5E1dpa2ZgPOcYRsvqiqtupiK3m534Ba9NevUVwE1fznIX0YJRk19Wod6UdIAmBDd0x9Zia2fj/f8lEaIidPXLjEAUN55fhFP7y+KyndH0VYAuhz7yk139okPAHz/Sa/1c0Hs5A8D4ouKL7qGqmzvpejA9Qd8yJZjiQ6oba7ZNMYDD99jcNQkgvyocWlNbPcDhE1W0Rk69LLzrSOmSQexsBXa+g8XSjEa9gYJA93+C5JRde9HqDtupVDg2O+Cyyz1hAO9Xea/mdBaXPF0eIs4H4yWxGbSit1gA2jmimJ4c8eLVncqQmxBvs31fydZzdIATJ49fY324hZmmxj9iO86OYuBzLDRMNeg0gH9dP9ivRUcMT7XLakOpzHkEloXYPwDdY13GaH4HrsGVS4Outn8BEKScU1PdXxqbLafnPruhPpMa0h1+egjU/dNzez9klvlXAairQ26po03gVzNWNfXL3O36004SqcPM6OIR3ft1nIwXhYGOJUfnDHi0ZgCTottz4fBzualgrk54Y83MGlTYxSDcrOyqAq4ChWPVedN2zh9bVnB4nmzJwWX+bmdemCrq9AjV+3HuddqQwm9rfDvhlIC07IphZ1ItJxAWyx4c4WvzWkZUHlP5jnkAWN2ygAab2N59bA6xOqry7lSMgAe3P9ClWSGjkI14H6c+uqW1nQDRGaXJLoqDE=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(376014)(1800799024)(18002099003)(22082099003)(4143699003)(13003099007)(56012099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	sezpQHO02kjOEYKL6LYSe/WmfCH2BEIA+r+hTrbVg08fZ2hU1uVke47g2FabryaxdYV5cS1jFyPOltuJKwta8CuIn9ARVC3oVt1bM9BWOdNHDeoJCNvrQdKZk0VETTb24A3zSQlCbssRWBupvKotdIICRidZjJvlujWa5/7WzLyuRDBovaLaEA82tYZIHeEPSkxOzh+YBLTCuWNc/1+JVVexm8DRxVHq695l+/fk6CszUZWtck25DZ7Xj44PivufBRJWK+N0ppop7I9noPdKOstFqXromInYXAlb9//Ohr33Biw4gNzz8wKGDyKV6lQPyFgh7q9zFVnwEGaU5ch6MhWGwzRv+bKN7+2zSN9fgf5of9EIZedM6ZQeoM5ka5DdRmCsoCmlIKxM5R+VG2EDsO7oeUlRPgn/sfezNWvchCt1S3zG87fVjBGHbfvDCw8C
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2026 11:16:02.8287
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fb4250e-597e-4718-030b-08deb27359be
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD5.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5839

Hi Amir,

On 14.05.26 22:19, Amir Goldstein wrote:
> On Thu, May 14, 2026 at 5:26 PM Amir Goldstein <amir73il@gmail.com> wrote:
>> On Thu, May 14, 2026 at 4:43 PM Nirmoy Das <nirmoyd@nvidia.com> wrote:
>>> ovl_iterate_merged() stores PTR_ERR(cache) in err before checking
>>> IS_ERR(cache). On success err holds the truncated cache pointer and
>>> can be returned as a bogus non-zero error.
>>>
>>> The syzbot reproducer reaches this through overlay-on-overlay readdir:
>>>
>>>    getdents64
>>>      iterate_dir(outer overlay file)
>>>        ovl_iterate_merged()
>>>          ovl_cache_get()
>>>            ovl_dir_read_merged()
>>>              ovl_dir_read()
>>>                iterate_dir(inner overlay file)
>>>                  ovl_iterate_merged()
>>>
>>> Only compute PTR_ERR(cache) on the error path.
>>>
>>> Fixes: d25e4b739f83 ("ovl: refactor ovl_iterate() and port to cred guard")
>>> Reported-by: syzbot+a16fb0cce329a320661c@syzkaller.appspotmail.com
>>> Closes: https://syzkaller.appspot.com/bug?extid=a16fb0cce329a320661c
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Nirmoy Das <nirmoyd@nvidia.com>
>>> ---
>>> v2:
>>>   - Drop the now-redundant 'int err = 0' initializer and the trailing
>>>     'return err' in ovl_iterate_merged(); err is only used inside the
>>>     loop's update-check, so the function can just return 0 on success.
>>>     (Amir Goldstein)
>>>   - Link to v1:
>>>     https://lore.kernel.org/all/20260514111354.3552538-1-nirmoyd@nvidia.com/
>>>
>> I queue this up and will work on fortifying patches.
> Nirmoy,
>
> I pushed fortify patches to ovl-fixes on my github [1].
>
> Can you verify that the assertions trigger if you revert your fix
> and run the reproducer?
>
> I imagine they would trigger much more frequently than the KASAN
> warnings do.


Yes, the assertion triggers with your ovl-fixes branch after reverting 
my fix.

9541f25af774 Revert "ovl: keep err zero after successful ovl_cache_get()"
1c067d912e47 ovl: add assertions in dir cache code
98e3a2d258e9 ovl: fix race between copy-up and open of a directory
4f80bb375112 ovl: keep err zero after successful ovl_cache_get()
18de6460b6bd ovl: opt-in for fortified ERR_PTR()
690bd87e1fef err_ptr.h: introduce ERR_PTR_SAFE()
7fd2df204f34 Linux 7.1-rc2

Running the syz reproducer with panic_on_warn=1 triggered:

[   55.404636] ------------[ cut here ]------------
[   55.404646] WARNING: fs/overlayfs/readdir.c:511 at 
ovl_iterate+0x4c0/0x5bc, CPU#2: syz-ovl-iterate/14575
[   55.406875] CPU: 2 UID: 0 PID: 14575 Comm: syz-ovl-iterate Not 
tainted 7.1.0-rc2-g9541f25af774 #1 PREEMPT
[   55.408328] pc : ovl_iterate+0x4c0/0x5bc
[   55.408632] lr : ovl_iterate+0x4b4/0x5bc
[   55.413504] x2 : 0000000000000000 x1 : 0000000000000000 x0 : 
ffffffffc152db40
[   55.414036] Call trace:
[   55.414209]  ovl_iterate+0x4c0/0x5bc (P)
[   55.414503]  wrap_directory_iterator+0x60/0x90
[   55.414809]  shared_ovl_iterate+0x18/0x24
[   55.415125]  iterate_dir+0x10c/0x3a4
[   55.415365]  __arm64_sys_getdents64+0xe0/0x1e4
[   55.417312] Kernel panic - not syncing: kernel: panic_on_warn set ...

Regards,

Nirmoy

>
> Thanks,
> Amir.
>
> [1] https://github.com/amir73il/linux/commits/ovl-fixes/
