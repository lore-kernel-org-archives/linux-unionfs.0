Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012012.outbound.protection.outlook.com [40.107.200.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F343D25C6;
	Fri, 15 May 2026 12:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778847931; cv=fail; b=XWqbHHUMLP3lX863/UNt4uzBrROqkE0B/NiCgMAWinkgYHKDRg8r7sChRMbHd5ISb0dbyjp4UOmyjiKlf6EXgdfTaw2Xa3D1NYvDypYYX1HQc5M29K1KB6PQ5W4qtjIo4LRVnFwptbK1YAZ8rbW1M0RM7PUBGV5QpUSiVt6X88Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778847931; c=relaxed/simple;
	bh=jbCw/CJNLNM6rjO9e20k6JpxDe9IqjhalcjcSncV1FA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=MM/o+zSoDgEN15xio9/dVgTlYHn48WdEa0DlMq/0dh5hQMsrGQhLoOJTHJEdHI23MOx0zAYhZ2r79g9QZCoKpAYIwqx0gsKvjTlpGISQvJ6wceRWsU0xkWni1BE7jLIJ/FKPtzk0je6LmAFF6bpZtHzJw/fhtGct0I+SMlodBdU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kR06XFT3; arc=fail smtp.client-ip=40.107.200.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kR06XFT3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cXyUVakz9Wpaw6bS1C/2oXpX3Caw0GjPt/txDT6lLQlim/n9ggDzstpfDkOjGkFH8trfbLxCrSspmTHi6X0jREQ5LiRlbey8nYANxFsXN5RfuD6LFsPGb91YQ5jVjYSRCDeUG1kS1Wm7MQYMIO8BqH5G/BoPSk12EXaJXpMihqHsN0MxFkmJFpSU7UbnzYYil9ZXgtE9pbL4FYfJM1Vo5NxXqCVxP0U7vdQXR3zm1T3CLoAnF9y9Ojrd2zyiO0sWkeodxryvg1aktqBXlDFGJF3wc/vOArzpeO8lJFUgdaBOkQZdujrwawcCdmxM2k8Hkx/yn6PEHlS/MmYPntRhWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L1Y906uVE49k8S0M61h7FbGHrZi7syIY0nfya4oj2JM=;
 b=lcEAY8/HRgxItIT++ZxQb9au+JzDyZ61Kum/iSMZm2tND2GcxveXoVjT2Ffg4l50Ize49X4vKMkXIn1WrQQq4VxN3uCUR//7PGgzJoHzRwLYcoN+mYB6FgJCwI+CVzsIcwCba0bGsRl5wi0qUyexusV7/iJkdh2W3takbdtfcv+37vxOUhrv2pZHLdI490Y9OBbglHkd1VWL6rk/N7R9Io3PkKtkolfPp77fHQC4cFAgsPfEIDzzI7E7pDvRxxMgxYNja2eFvTQx1HLygPFLeeFCPs77U44p8i6UGsTSzfadtPoYdrinw2cV5+lWVoIHqJja0oeLFAff7XSR9oJHsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L1Y906uVE49k8S0M61h7FbGHrZi7syIY0nfya4oj2JM=;
 b=kR06XFT3fTeMX8prC0EoXpQRWbIdbnvh6qFIcddnum9zZpChwwLAsB6HYeKtCaRwf/+/s72KUxf2JyhCRx/xzKDHZc5JyfjGoJnQdV8itjxZaWpWMq7foJCJjktSfFN1FNfV8GwMT9jldhRVfm1RF5KZBxAsqyROtwzraCHprYwYV4BARqeAoIgsBAmcsDpUgIy3lvedhx4peCl6r74QlVl9WBxwaRAbr5ECwugOGQAiYxTUTaGVVXNsZHLamB2tOhGP9+8yyzBPbaTKdsiO2fzupRCTDVCp88V2LzgbVOLZzpUXcwHVrQ46Gou/PYqa/JFGQdVRs9lY/JqPhhc6Ig==
Received: from SJ0PR13CA0126.namprd13.prod.outlook.com (2603:10b6:a03:2c6::11)
 by PH8PR12MB6746.namprd12.prod.outlook.com (2603:10b6:510:1c1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.19; Fri, 15 May
 2026 12:25:25 +0000
Received: from SJ5PEPF000001F1.namprd05.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::e4) by SJ0PR13CA0126.outlook.office365.com
 (2603:10b6:a03:2c6::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.11 via Frontend Transport; Fri, 15
 May 2026 12:25:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF000001F1.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.13 via Frontend Transport; Fri, 15 May 2026 12:25:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 15 May
 2026 05:25:08 -0700
Received: from [10.64.160.70] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 15 May
 2026 05:25:05 -0700
Message-ID: <d6254282-8ae8-470b-8285-9dcc44b4d588@nvidia.com>
Date: Fri, 15 May 2026 14:25:03 +0200
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] err_ptr.h: introduce ERR_PTR_SAFE()
To: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
CC: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Al Viro
	<viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>,
	<linux-unionfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
References: <20260514200129.94862-1-amir73il@gmail.com>
Content-Language: en-US
From: Nirmoy Das <nirmoyd@nvidia.com>
In-Reply-To: <20260514200129.94862-1-amir73il@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F1:EE_|PH8PR12MB6746:EE_
X-MS-Office365-Filtering-Correlation-Id: 142a7a12-3880-4066-8e7f-08deb27d09fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|376014|1800799024|13003099007|22082099003|56012099003|18002099003|4133799003|11063799003;
X-Microsoft-Antispam-Message-Info:
	ILVFBB9iWkWOSsQA1z2wuccepLbgKBj7ZISAljCMJztA0+3BlXAPiZcWCyqSPvEGOgdNpPmITX4GtL/mayrLSOskQQwJj75O68JNthxMMPEOzZwqGK5T/WxUvZaCwNrfsGp8W0soNpWt4uDf12oB8F/TI0Q1z23pW+Ogw5y+PI8d664zhsGcZt6eHyKn+OueF9/0k/Fp+4dOYszCRnVi4cCmmviqf1dvdyN6t0fPOSR+oz7nA+q2h6Hro0XR7+sl56k2SLOmzFfcpMw48Hdq8+iUuGhm9HmnlaHI+O3fCzMaDySHW6jHV68RHHWFVNrMgDb9GHU+izBChJkl5Mj7ovqRle7iYYcAdcDfoGpuPe+deqrc7P2gv7AaCqntHALHlt6NubyWhgcuax+UU3F7ZA4m+fU+zqkUIUoZPBpt+Qvv0Yp3+BcbbLYI6+Mtf3AqMxNL3ngmYTZC9aJ39jDMd9DhQxBY7GZzTmkDoJnkyeBSbYl7fIOE3mxXfnpO6G1IRXZxSc0wUQAyzRcnGykGyGhEUeE/xweWw8RQ5n2O6UEteFOwUtE/FSEK/y+Yl/va+6DCTAIDKbscZJLO1p7VTvRo1CxaYw3bFHdaPajKdsVMsKx7q4hJP6QMSIBmTjOiGCj9ksBPMR3MyrpCQwwKe90gJlAQzlkTCKYVOVe+09jAk8sRvslDPyLZIokzYWboJMqQNnLPcuJU2lCysoPoFSzIIPaY32GIvO1Xi4ZoB5w=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(376014)(1800799024)(13003099007)(22082099003)(56012099003)(18002099003)(4133799003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	KC+CWWo+jTeuTxbDtSNrBIWW3h/pkmXoQBky0qSJjlBSYiBRFnnO5QZFdyUiPqQZFyj3cemdzX5wORHATaS4db+uM5UE/Nei8NCXecIYriwMy5GVHJ4Fuq6nptZQ172ehfbrxfJ/eNNCmAXqyT+pdkj2wu+s1Ul51K8WVPDyqJwW70E6MOZm9txTxgsI82FrIFYQQL67LuEkAcwJEOBiEBRZ0PE9oZNMlB9pmVDXdEigp1OKQKCySbq3s7reF/+eOtgnf95Ycy/XDnJ3kXCJ1RsDQtsYhGXoMLzvwD3YoSNmk7QVMDMHOzODVbY7lvMhXXIfULiNFHQSI/Aps376uPExGD0Ic1itpbe1qPaifjqvEsZdR+i/CaJfIVUWLNuUgSqkhxDBPYKe5UMUFy9zQZvfJT6Fq9IY8r2yOxk0xrMFRXwC4sCjWJOyt4pb/jZI
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2026 12:25:24.1129
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 142a7a12-3880-4066-8e7f-08deb27d09fe
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6746


On 14.05.26 23:01, Amir Goldstein wrote:
> Code using ERR_PTR() is almost certainly intending to produce a value
> which qualified as IS_ERR_OR_NULL(), but this is not the case when
> code calls ERR_PTR(err) with positive or large negative err.
>
> Introduce a fortified variant of ERR_PTR() whose return value is
> guaranteed to qualify as IS_ERR_OR_NULL().
>
> We add this in a new header file err_ptr.h which includes bug.h
> for the build/run time assertions.
>
> Subsystems may opt-in for fortified ERR_PTR() for specific call sites
> or by #define ERR_PTR(err) ERR_PTR_SAFE(err).
>
> Link: https://lore.kernel.org/r/CAOQ4uxg=gONUh5QEW5KJcyXLDF15HbLnc9Ea7RKPcgtyfPasTA@mail.gmail.com/
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

I tested this on top of Amir's ovl-fixes branch[0], with overlayfs opted 
in to
ERR_PTR_SAFE() and with ovl_iterate_merged() fix reverted.

The syz reproducer triggered the new WARN_ON() from ERR_PTR_SAFE():
WARNING: fs/overlayfs/readdir.c:511 at ovl_iterate+0x4c0/0x5bc
  Call trace:
    ovl_iterate+0x4c0/0x5bc
    wrap_directory_iterator+0x60/0x90
    shared_ovl_iterate+0x18/0x24
    iterate_dir+0x10c/0x3a4
    __arm64_sys_getdents64+0xe0/0x1e4


Tested-by: Nirmoy Das <nirmoyd@nvidia.com>
Acked-by: Nirmoy Das <nirmoyd@nvidia.com>

[0] https://github.com/amir73il/linux/commits/ovl-fixes/

> ---
>
> Guys,
>
> Please follow the Link to see the sneaky bug that Nirmoy tracked down.
> syzbot has complained about this a while ago, but neither me nor my AI
> helpers were able to track it down from code analysis.
>
> Honestly, with AI review, this class of bugs (return a stale err value)
> should not be happening anymore, but it annoyed me that ERR_PTR() can
> return a value which is not an IS_ERR(). It messes with code flow
> analysis.
>
> What do you think about this macro?
>
> I intend to #define ERR_PTR(err) ERR_PTR_SAFE(err) in overlayfs.h
> to fortify all of the ERR_PTR() in overlayfs code.
>
> What do you think about this opt-in method?
> Any reason to make this more widespread by default?
>
> Thanks,
> Amir.
>
>
>   include/linux/err_ptr.h | 29 +++++++++++++++++++++++++++++
>   1 file changed, 29 insertions(+)
>   create mode 100644 include/linux/err_ptr.h
>
> diff --git a/include/linux/err_ptr.h b/include/linux/err_ptr.h
> new file mode 100644
> index 0000000000000..829ec5f771528
> --- /dev/null
> +++ b/include/linux/err_ptr.h
> @@ -0,0 +1,29 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_ERR_PTR_H
> +#define _LINUX_ERR_PTR_H
> +
> +#include <linux/err.h>
> +#include <linux/bug.h>
> +
> +/**
> + * ERR_PTR_SAFE - Create an error pointer, with validation.
> + * @error: An error code to encode as an error pointer.
> + *
> + * Like ERR_PTR(), but validates @error:
> + * - For constant @error: fails the build if the value is not a valid errno
> + *   (zero is allowed, producing NULL).
> + * - For variable @error: warns and clamps to -MAX_ERRNO if out of range.
> + *
> + * Subsystems may opt in for all ERR_PTR() call sites by adding after includes:
> + *   #undef ERR_PTR
> + *   #define ERR_PTR(err) ERR_PTR_SAFE(err)
> + */
> +#define ERR_PTR_SAFE(error) ({						\
> +	long __e = (error);						\
> +	if (__builtin_constant_p(__e))					\
> +		BUILD_BUG_ON(__e && !IS_ERR_VALUE(__e));		\
> +	__builtin_constant_p(__e) ? (void *)__e :			\
> +		(void *)(WARN_ON(__e && !IS_ERR_VALUE(__e)) ? -MAX_ERRNO : __e);\
> +})
> +
> +#endif /* _LINUX_ERR_PTR_H */
