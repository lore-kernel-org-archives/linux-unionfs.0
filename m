Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013046.outbound.protection.outlook.com [40.93.201.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F163859D3;
	Tue, 12 May 2026 18:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778610491; cv=fail; b=Xngu5CfdTdTOdSDfWD51+mGPb/kMVc77clkCXdK3rhlDeRqSs5akiBSeJoG7O8pPKP52TDcv8v0WMoQcxUlYd5OJ2Vse2UpYsm50/pn8Q0NfMlPQ4muqFvC+n2ggOmzvIHBNL0bjt2AWyTpe0ogHzt683J2DJX52D4kE5ccFr38=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778610491; c=relaxed/simple;
	bh=4oVKwXe7l5COxxZZTq0F4ZotXxHFDImv7ggzapXyJ2Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=gfDe6+YW+nDdAnpBk4kK8HIOmJCbwFC6nnX50m8pVw/PGUxe5zawYCdX/UFnDPczLI+DXnLU0Sf14EDkjBS+j4TfEDK85Fwe/+QeJM8v+ESH2DizFI5BjApB7vGFA2/TaB2ePsk7henqLe+7ZVOVnYipxO4SoX9tDTWdVIYB0yE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jUCxzeQ8; arc=fail smtp.client-ip=40.93.201.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jUCxzeQ8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dcd0ch73hy43HZgDbxjvxhBjzI45a5+Waf93rqKP8YW+mj0cVKe620yfGQoE3Pp+DHt0x/jRhtS+IZoqfSgWgd92QbjpLs1sCAZ/B8n47pqy+SouJ6Sw1v/tavIk56fHnYxHQ5eQXIczQ0LfxOUBy5DXvjdT8ceyr4ZTHwKj6dUwBRzTN8kB3O+6EjDE8dhWFF3KYMxfoV0i8kgKOSi6DvXcWhYS16i++6yxHDTyyhzx354YF0Ndtsz5rKqUv5J6d9r8ZOC9ZhIFlMUeYRFyCthwK57VYEkABNbz3PKhPYnUQnT74Jby2dhskNTjuzKhFo4HUPwX4zQxDu/yNeTwSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CeDfPeuIF37VaaJV87JutByrqFo2iCVK25AvQfspr+I=;
 b=C9ejyhwQOKEqRcJiSleBM0tfLmJ+k/bhESTc7iVigl5Zic7ot/Vw37wWsxgBj6QJU4c+rlFHzwXNz/r7lwQJ4U9BRSzTU/K+qtppPcEjNt/+/xcj8KzGz68oX6ga9LTRVKC1FvX/2IcYtYRktN+4N8q7S7dihTagXh6bUJvIWdbm65y1yJxxwgWDN/gfDSEFdg3jhCNd+Y6Xs1IZsjgOLaNW/HpGUH02nSaeD1qjAcM8Y547JRur2biAW5fnXHiPm3O9kyqm8I3ke4ne3MhaBIvUYeYIwxemSyjxOOTEH+GrHWTsYuG6Dk63+FkBpQBMKfTsyDa2h/E0QhCAFq18oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CeDfPeuIF37VaaJV87JutByrqFo2iCVK25AvQfspr+I=;
 b=jUCxzeQ8gBwWvuyGemD5Ujr41PhD0spEbzbsDLSCkmElEGGkIPbdwXgOLejojZIRWVIB1y1uS8YMaNSHMNxtksceCePqPVSn/I5vTbmv7IJj7iqtzLdvqRuztNCNexjMKZLkZJgIGRNg+RKP1YsoBo2QwiE+7YUcK8t1lug/W1Xmm/AUwC57LERra5WcAUziLnNWOSU849DcUo2QgRHBm2FJ6O6bVXXCAPHK53NqvrH9IXF0PqyPI2QDBfycGtqDDxUmoOgZH9vQsDPtS2Zz+9+qLdHz7mU7OPOwYRV/eJ028kHCfl7ms4IaNJ+OAZaPt/rGFgn/PVECPuYDeC5GYA==
Received: from SJ0PR03CA0367.namprd03.prod.outlook.com (2603:10b6:a03:3a1::12)
 by IA1PR12MB8556.namprd12.prod.outlook.com (2603:10b6:208:452::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.23; Tue, 12 May
 2026 18:28:06 +0000
Received: from SJ5PEPF000001D7.namprd05.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::7b) by SJ0PR03CA0367.outlook.office365.com
 (2603:10b6:a03:3a1::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9913.11 via Frontend Transport; Tue,
 12 May 2026 18:28:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF000001D7.mail.protection.outlook.com (10.167.242.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.13 via Frontend Transport; Tue, 12 May 2026 18:28:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 12 May
 2026 11:27:46 -0700
Received: from [10.125.196.95] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 12 May
 2026 11:27:45 -0700
Message-ID: <3d6a1a50-5937-47f8-9910-cae66ffab6ee@nvidia.com>
Date: Tue, 12 May 2026 20:27:43 +0200
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] ovl: keep merged and impure readdir caches separate
To: Amir Goldstein <amir73il@gmail.com>
CC: Miklos Szeredi <miklos@szeredi.hu>, <linux-unionfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>,
	<syzbot+a16fb0cce329a320661c@syzkaller.appspotmail.com>
References: <20260511062057.2365769-1-nirmoyd@nvidia.com>
 <CAOQ4uxh-1J2OBjnDVbrrrjy1puSOW0kABvghN85ih6dtKUBTyA@mail.gmail.com>
Content-Language: en-US
From: Nirmoy Das <nirmoyd@nvidia.com>
In-Reply-To: <CAOQ4uxh-1J2OBjnDVbrrrjy1puSOW0kABvghN85ih6dtKUBTyA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D7:EE_|IA1PR12MB8556:EE_
X-MS-Office365-Filtering-Correlation-Id: d4e302f3-02cd-4ab5-813f-08deb05435e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|1800799024|376014|56012099003|18002099003|22082099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	f9Bj4k95moksr88ZVB66B3iT71wB2TXFRp2EO/h1jyuXHG4LrGflj1lDfnZQ1+JvcmtmippeiWQUPLbI19cFp9E5bG7wchTDfbfHh1si02HZi2nQw/hdZVtvWxhgBtbFivOLu/FPbWCejSIHUZYkFZttEOfaXvfKQNZ5N0TYMo/tnpI04Ruom/7Fpw6bEBaxxyEH/9J3+27ckndyieLW+8TTjWVs5CLkeEuusZR7C7baN1MlYOushmd5GpQmnD9XZrGS5HpEL/hiusJIbFC3oHEIP3PsgmgkDGx1EYUamuI7/et17WPehRfUacDYvq88de90noUE66+BtAk11GI+vg1stQVx+4HpWFBPI9D1NIi7DgGznynGjC9lwyC93KXNMDpz1516pXmPMzMyxfj0ufbb3HZyZJeADVVIlcJlBc/fJkSAtCIkIg7dpbD6QH+2r+8kYbkiKlqutBdFJMo0KQE2fH0gLtP2ar21qGtJAULE2ZXCH6RH+7iyy9MmJdkL7Dkt5vDFbk1gx0L2MCDDJq9XAkqXzceP8ieIfe0FdAFkuD0Z6odeHSrgUYh9XR9XsoesvmI6jECKMb5rb0a3StCVNG5eAs8qXNIRjZKRZxn1HuqAAi4sh9+z0taF9zJZ7Q2xy3yBDyX1l+rHqr96kXcrgtjHJXXwhXG/ja3lqUerpiHl5DkUKhjRQsBbCvfOZBMAk5j1965n59dzb2oa+tcAoL2rvjQLZ1jpPoxRV+4=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(1800799024)(376014)(56012099003)(18002099003)(22082099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	U8+1PTemfDW5D8e36k2gdz0LPDmw5KSqakcc+mVfzg38phrerM6qo+HJVVk5Ygp+9OAArfJ1NbWjkwRdhm41Y5Ud2iOqo9ln2n+X4cfnHaS7RZEbBckMG57kzGz+bkKXvlzXlmNQg6fLZEQ5XJZXd9vq7rBR9oL4wSmIdaNctw4t9udYPWxraROn9IuXuBn+qWdoUSxJJ4qjr/+lSyZ/Cc350hZ5NzXRLWvUd1PdoobC4aV2pdDATfNP6pNjs6pkc4IZwjIOOtvgQ6vkqWT1WF5jTKKQjnHkp04iokb4jFZTial15+3SKBjTmWBIXNabavoK8aTddtLuaEQ7copF6cyIrzaPssoLdXovI49/aVZIz4a+oC82kq1XuQx8KlJ0+N8TxJvaY4LO7Ux3LxnVrVKaZCtpN2+4QdzhgjEe8pJSAwuTi2xL94UYbYEUHnKo
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2026 18:28:06.0218
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d4e302f3-02cd-4ab5-813f-08deb05435e3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D7.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8556

Hi Amir,

On 11.05.26 23:54, Amir Goldstein wrote:
> Hi Nirmoy,
>
> Thanks for the patch.
>
> On Mon, May 11, 2026 at 8:21 AM Nirmoy Das <nirmoyd@nvidia.com> wrote:
>> Overlayfs uses one inode cache slot for two readdir cache users with
>> different lifetime rules. Merged directory iteration pins the cache from
>> open directory files with cache->refcount. Impure real-directory iteration
>> uses the inode cache as an unrefcounted lookup table.
>>
>> Those caches cannot be reused interchangeably. If merged iteration finds
>> an impure cache in the inode slot, it can pin and seek through a cache
>> that was not built for merged iteration. If impure iteration finds a merged
>> cache, it can walk an object whose lifetime is controlled by open directory
>> files. Either direction can leave ovl_iterate() using stale cache entries.
>>
>> Add ovl_dir_cache_drop() to detach the inode cache before freeing it. Keep
>> refcounted merged caches alive until ovl_cache_put(), stop publishing new
>> merged caches through the inode slot,
> This is unacceptable - invalidating merged dir cache to paper over
> another root bug, which was not really fixed.
>
>> and let impure iteration reuse only
>> unrefcounted caches.
> All those guards are nice, but how does a directory inode change from
> being merged to impure or vice versa?
> This should never happen.
>
> It took a lot of arguing with Sonnet about wrong leads to find the real bug.
>
> Real bug was introduced by:
> b79e05aaa1667 ("ovl: no direct iteration for dir with origin xattr")
>
> It changed the test from:
>
> od->is_real = !OVL_TYPE_MERGE(type);
> od->is_upper = OVL_TYPE_UPPER(type);
>
> to:
>
> od->is_real = !ovl_test_flag(OVL_WHITEOUTS, d_inode(dir));
> od->is_upper = OVL_TYPE_UPPER(type);
>
> But there is a race window in copy up of a directory where
> upper is set and published before the OVL_WHITEOUTS flag
> is set.
>
> an opendir() observing this state inside the race window will
> wrongly start to iterate_real and another opendir later will
> observe the flag and start iterate_merged - boom!
>
> Attached is what I think is a correct fix.
> WDYT?

This looks correct with my limited understanding of the overlay code. I 
still see the issue when running with

the syzkaller-derived C reproducer in a loop inside an arm64 virtme/qemu 
VM with a KASAN/debug kernel.


Let me try to debug it more and get back.

Regards,

Nirmoy

>
> Thanks,
> Amir.
