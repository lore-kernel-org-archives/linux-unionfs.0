Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E596CE743D5
	for <linux-unionfs@archiver.kernel.org>; Fri, 29 Sep 2023 01:08:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbjI2BIT (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 28 Sep 2023 21:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbjI2BIS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Sep 2023 21:08:18 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2059.outbound.protection.outlook.com [40.107.244.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180D0B4
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Sep 2023 18:08:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UzkhOY/cQL3MW4pFLONuNrU7AXNl2S0SCuf72DC+kT+6Ntrqi7IUiOh3t2lDIReAiE4pqt1fYunXYwEsLoMRRD5mibHZ4Nm1lBlDiHt59uYB3fgKYOYb1hHrByA/d6qCqi8LcQJvh+JZ+8UNpjR1X+lHVb/RDaIL3x6t2eDCVN/JhZwEaQcfYGhq2IUVCa6VkJrpwDttDFPvh5QnWV9xHSe3HVqDJRyMR0dl4eIR7sX6WyLJGiWGIqYlroMui9u+DItJbJRI1NhaM3budAPs+k/ssv2SE/q+hQHFQB0B2J/HWomKWznAT6/CXxGRJtiXYcVPM8ajAN+qQb4SlzrmRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FLEyEpObFbiGeGKl72DmNMiu2FymGok95CknjMWBEmQ=;
 b=XliEWHao+TB6OpHWCaCRM/SXWwCgp/95V9nwUCRf5avBKF2LgzeWE4kS429BdAKBbw0G9Fexji+SL+9E4rKd6NvL2h9aC87G+ee6rvcXAZict8lT7Azl3AIzZ0SUSPyjSu+DS+0UYCBLYMtj5qlvppuz57iVxtgM+11jWx2/Z8ddwirU8DpPR1owx43/OZ/kBKI1vXPrzqVOQGaQey7FDuHvNz9Mo1dsJzFijC5xBkM9J2tfQx4X8SWpElCrm2h8PEuZRg62IlCOoSUbwWp79F51KOJjZ2fdDon3MDt5gHPCjXrS+6SqTTy0gWIXxgPKCseBElUvO3EkAROUh0RbRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 18.7.68.33) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=alum.mit.edu;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=alum.mit.edu;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alum.mit.edu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FLEyEpObFbiGeGKl72DmNMiu2FymGok95CknjMWBEmQ=;
 b=CEHFWxAjhO7o99c9ra+yot1QS7r+Un3gFcydOkCpOKRLOVHmiWE+C8Z1dJkaTFCjazun8in+++Hif9bIw4dkSCHEi8DmHucKUJuVyq6UUuDs+iL8q7Vd5PXdPz/EIlYG1bd9pcP0PScN/FGLpyfvo/RyNw84il2YVjCK+VKbwxE=
Received: from CH2PR10CA0018.namprd10.prod.outlook.com (2603:10b6:610:4c::28)
 by IA1PR12MB6211.namprd12.prod.outlook.com (2603:10b6:208:3e5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.35; Fri, 29 Sep
 2023 01:08:13 +0000
Received: from SA2PEPF00001507.namprd04.prod.outlook.com
 (2603:10b6:610:4c:cafe::48) by CH2PR10CA0018.outlook.office365.com
 (2603:10b6:610:4c::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.26 via Frontend
 Transport; Fri, 29 Sep 2023 01:08:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 18.7.68.33)
 smtp.mailfrom=alum.mit.edu; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=alum.mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of alum.mit.edu designates
 18.7.68.33 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.7.68.33; helo=outgoing-alum.mit.edu; pr=C
Received: from outgoing-alum.mit.edu (18.7.68.33) by
 SA2PEPF00001507.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.14 via Frontend Transport; Fri, 29 Sep 2023 01:08:12 +0000
Received: from charles (c-24-218-5-141.hsd1.ct.comcast.net [24.218.5.141])
        (authenticated bits=0)
        (User authenticated as ryan.hendrickson@ALUM.MIT.EDU)
        by outgoing-alum.mit.edu (8.14.7/8.12.4) with ESMTP id 38T17t6l014407
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Sep 2023 21:08:10 -0400
Date:   Thu, 28 Sep 2023 21:07:47 -0400 (EDT)
From:   Ryan Hendrickson <ryan.hendrickson@alum.mit.edu>
To:     Miklos Szeredi <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org
Subject: [regression?] escaping commas in overlayfs mount options
Message-ID: <8da307fb-9318-cf78-8a27-ba5c5a0aef6d@alum.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001507:EE_|IA1PR12MB6211:EE_
X-MS-Office365-Filtering-Correlation-Id: 06c320fe-21de-469c-8d94-08dbc0888d74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ThAkMAl/us4RAw6SlkBVmdsZNyg0pNGvtylWNzu00BNF42p2kSBoSocY7BgMVMOsh+SZ+zR3tFF3cl3ju+fTIBFqJ3qLodWkRXHegFpo4B7mUvMG1koWKrLlKTPom3AGatxxhB3abvUaR57s01dDADKiF69ePQBJVlKWpWP3vDqu1SgX6HFmPXHmsf3HKOx0pJK9agIxyK+LuL/le7cYnIrwonvG81ppIELsOgwdHPmwC6xeGq4/TJyaL24ooI9/QCkaQioyat4pchU+jQZ8QW7hwIxlQV89GV80Vz9DUT+aIcLMBiQpl9ZEd7ZQGAXfYMJ9Vq+Cft+o6dZ1CHLKccNzx/CcFxtcZuZwvoY0TKK8+0sFmT9lPOuAizDpdgkQaJpZmzzzvr4q/H1xLVWb4ttmuMVGfTjbfoS4wlPM6rx0Is7nF2Vqcb9l5nv1f7iGLxc1tjdB6tKdfclYe5dM7mCNfSyw1o/Q9+c9sNbN2Xhjk0weSDGrqL/BkqnJ83hTLPMO837um72mihI5ro5OJkD9bCGLqBZttXgxmKZTUiePCsyQ29ixEvzq+9rri+/GTxB2YxtTRu0jGflhkQGDENuOMTQI0wfAzIVF9BhIR4T+8dpMl7FU0Xghfn12/FEDAvWAu0pPP/I84zROFgEbhy1th9n5TimVhNCa+ecTSRG+twOY4YS9QNVxs6O83WPppQMnzUb6nK8kpg+rFKQKsXaS3pbuSsr7xlU4GbYcEO4xWtpTg9NSgAJ3+6h7QvnT
X-Forefront-Antispam-Report: CIP:18.7.68.33;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:outgoing-alum.mit.edu;PTR:outgoing-alum.mit.edu;CAT:NONE;SFS:(13230031)(136003)(396003)(39860400002)(376002)(346002)(230922051799003)(186009)(82310400011)(451199024)(8000799017)(1800799009)(64100799003)(46966006)(40470700004)(36840700001)(956004)(6666004)(966005)(478600001)(83380400001)(2616005)(44832011)(26005)(8936002)(41300700001)(70586007)(316002)(70206006)(786003)(5660300002)(8676002)(2906002)(110136005)(86362001)(36860700001)(47076005)(356005)(31696002)(7596003)(41320700001)(82740400003)(40480700001)(336012)(40460700003)(31686004)(75432002);DIR:OUT;SFP:1101;
X-OriginatorOrg: alum.mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2023 01:08:12.0774
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 06c320fe-21de-469c-8d94-08dbc0888d74
X-MS-Exchange-CrossTenant-Id: 3326b102-c043-408b-a990-b89e477d582f
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3326b102-c043-408b-a990-b89e477d582f;Ip=[18.7.68.33];Helo=[outgoing-alum.mit.edu]
X-MS-Exchange-CrossTenant-AuthSource: SA2PEPF00001507.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6211
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Up to and including kernel 6.4.15, it was possible to have commas in 
the lowerdir/upperdir/workdir paths used by overlayfs, provided they were 
escaped with backslashes:

     mkdir /tmp/test-lower, /tmp/test-upper /tmp/test-work /tmp/test
     mount -t overlay overlay -o 'lowerdir=/tmp/test-lower\,,upperdir=/tmp/test-upper,workdir=/tmp/test-work' /tmp/test

In 6.5.2 and 6.5.5, this no longer works; dmesg reports that overlayfs 
can't resolve '/tmp/test-lower' (without the comma).

I see that there is a commit between the 6.4 and 6.5 lines titled [ovl: 
port to new mount api][1]. I haven't compiled a kernel before and after 
this commit to verify, but based on the code it deletes I strongly suspect 
that it, or if not then one of the ovl commits committed on the same day, 
is responsible for this change.

[1]: https://github.com/torvalds/linux/commit/1784fbc2ed9c888ea4e895f30a53207ed7ee8208

Does this count as a regression? I can't find documentation for this 
escaping feature anywhere, even as it pertains to the non-comma characters 
'\\' and ':' (which, I've tested, can still be escaped as expected), so 
perhaps it was never properly supported? But a search for escaping commas 
in overlayfs turns up resources like [this post][2], suggesting that there 
are others who figured this out and expect it to work.

[2]: https://unix.stackexchange.com/a/552640

Is there a new way to escape commas for overlayfs options?

Thanks,
Ryan
