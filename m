Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6140FE75459
	for <linux-unionfs@archiver.kernel.org>; Tue,  3 Oct 2023 19:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240855AbjJCTHR (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 3 Oct 2023 15:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240870AbjJCTHP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 3 Oct 2023 15:07:15 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2071.outbound.protection.outlook.com [40.107.220.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F03AC4
        for <linux-unionfs@vger.kernel.org>; Tue,  3 Oct 2023 12:07:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m4TvknlB++Z4GsEiW8b/Z4n+pCmnxosVF6kjFmQx5WqkiWpBehNhJQUxBc0yGWKn1Z7e2pTtHUnlsOu+WUMqHZWc/A/aF133ihtPNFAjgJkfZNELeqK3blJwiSgXo6KKaJp8K1YahH0qDEQUUITFbC6GlRDn4foVrUIYwqaJKk3VKBJpmvhswW0OTWedr2k9tECpexhNGPRCPfQvj6PvBi7jScAukj0ksBgLSwZsV5C+nHKOV/euY8b3okrw+nPvd0hS8Vd2MosxAoP0Ivfm5XHaf8ukdESgSEzKzEDRBwS6OrG0tJHwJk3yq7jWkC/iG6xyjLF10JJiiHSifTSSPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v86xwxWO1OGyjFMBRACyWPAH+Tqg+jssTkDwbAmKpp0=;
 b=NrDlUcYjdwloEiOI+/415h5dvKElsQYKbvxfV6Ilh3JkFrXvVxhaamx1EHdKEE5CKvUsLd8lsyCoV8TNtysNLIIaupPmXKeyhaKiN7Z7XlI1R0losVcTlPutaUfbViQEHPjfXvRV+TDksgk14Tp2ES800lEi8XZEGjBX0fr8Q2zvs7kmv/o+Q/VhrqAY/flYVgCgCWDOKSOCfkL6EZP/5tuYsY/YPRDf83RC4azcMKIq5wEzasWzL4ZlCQCQ5zZZOck+CMaO/GFIvhL2sC87AfM5BOPm9EIIOC7iBzggoOS58IuQ5RbPibtA8P8GXjpVSkxoaZXHqZF1y3g0HqPuhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 18.7.68.33) smtp.rcpttodomain=redhat.com smtp.mailfrom=alum.mit.edu;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=alum.mit.edu;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alum.mit.edu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v86xwxWO1OGyjFMBRACyWPAH+Tqg+jssTkDwbAmKpp0=;
 b=iTGdgnkGJKX7Db46RX8Q0OH7C1dhExs90IC425x7D+8c0gV3iSDADx/+qptCK2OobIWI9dSu541rK4E4NnXInb648HVgAAjZoluSAw00CzuTDJbbHJawvhcWGN1wbMUOMM7OhSky5/3/whpgJstNJa9IzaJuHCZQerJhV2hr1LY=
Received: from CY5PR04CA0019.namprd04.prod.outlook.com (2603:10b6:930:1e::22)
 by SA0PR12MB7461.namprd12.prod.outlook.com (2603:10b6:806:24b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.35; Tue, 3 Oct
 2023 19:07:09 +0000
Received: from CY4PEPF0000E9D8.namprd05.prod.outlook.com
 (2603:10b6:930:1e:cafe::8b) by CY5PR04CA0019.outlook.office365.com
 (2603:10b6:930:1e::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.33 via Frontend
 Transport; Tue, 3 Oct 2023 19:07:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 18.7.68.33)
 smtp.mailfrom=alum.mit.edu; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=alum.mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of alum.mit.edu designates
 18.7.68.33 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.7.68.33; helo=outgoing-alum.mit.edu; pr=C
Received: from outgoing-alum.mit.edu (18.7.68.33) by
 CY4PEPF0000E9D8.mail.protection.outlook.com (10.167.241.83) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.14 via Frontend Transport; Tue, 3 Oct 2023 19:07:09 +0000
Received: from charles (c-24-218-5-141.hsd1.ma.comcast.net [24.218.5.141])
        (authenticated bits=0)
        (User authenticated as ryan.hendrickson@ALUM.MIT.EDU)
        by outgoing-alum.mit.edu (8.14.7/8.12.4) with ESMTP id 393J76Ks002069
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 3 Oct 2023 15:07:06 -0400
Date:   Tue, 3 Oct 2023 15:07:05 -0400 (EDT)
From:   Ryan Hendrickson <ryan.hendrickson@alum.mit.edu>
To:     Amir Goldstein <amir73il@gmail.com>
cc:     Christian Brauner <brauner@kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Subject: Re: [regression?] escaping commas in overlayfs mount options
In-Reply-To: <CAOQ4uxheu-LXAh3nAcnufwOR=+9xPVeHdi_=dZVx6qj7ZwRGpA@mail.gmail.com>
Message-ID: <2ee75e4f-0585-d603-80c9-5d0af36eb629@alum.mit.edu>
References: <8da307fb-9318-cf78-8a27-ba5c5a0aef6d@alum.mit.edu> <CAOQ4uxhQhzv_LUW89m_BmKf+NjE+XDyY9XtLAt+SWG03M6LmYQ@mail.gmail.com> <80c265ab-1871-211e-2787-fefbf25a892a@alum.mit.edu> <CAOQ4uxheu-LXAh3nAcnufwOR=+9xPVeHdi_=dZVx6qj7ZwRGpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D8:EE_|SA0PR12MB7461:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d13bda4-ce9e-457c-ac37-08dbc443f160
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O38kmidadiM8e15l8yjLdmWZX57UJykY0OxAnb2tSbHYby8TxTgIffJpFD7PA2qF1v9EmGORTH2qb7k9f8wxlubbm05lLcSPhsW+J3o5sW3T/9kPaMUD20UzvCSMlMyGp8ihZePhZZG56Z6C7/TMQ2TwBO2Ka9fnaFEljPR7dk1+p6D+8UIVjr5Ld0/PQcZ1O5L/SLHMBtl3WexuaW6eMh/szH92fMXJ9v8ITCe0nvOekzfZt6eXzLmK7SCCfh1f6p4mhhrDagf4PsADjKWNgcSG1ii93g3iTA5h32/znp3yDbgg7wKMbP7ffs6T61aH8GwyFzitIkVDb+vPzrdYouq2v+qfK5ICwpugfdfxV0+J3VniRcgYJSGDm1Y+woHytVuML09yT+itQ8FPeFUZmIwzOvC/1lxyEzRCJj6R+wVoX5RZptVjKzH5l8YwmJnpsxsECW8/rJE4K8aq4u6/rasYld2NgCN5W7tFHHTElSEFMDDQH+7G/54QsGPlXji+U5Ovr4f0a5daBGcefS7MMyDhk6NI0oiodePu7dPmwIT5vMgLSvDZUv7/lNIOb3OaNnaDs02zrINmXi1yG61ubZjR+7Mti58FrIACP/JllF8ekP8x0OkXcbnVxXRGAMlNGrehzXM1RCVPbsXAUJ/OivlzrPg7TIvvBQBoN23Xfvhuk0cu1H0iYvUalW0TlkOI7qRznOZvH5DV/4oZstlGJ7mDvO7CndY39Ku+6ZJAMnyM9oBpST/W9C604PIMML4u
X-Forefront-Antispam-Report: CIP:18.7.68.33;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:outgoing-alum.mit.edu;PTR:outgoing-alum.mit.edu;CAT:NONE;SFS:(13230031)(396003)(39860400002)(346002)(136003)(376002)(230922051799003)(64100799003)(1800799009)(186009)(8000799017)(451199024)(82310400011)(46966006)(36840700001)(40470700004)(44832011)(83380400001)(336012)(5660300002)(2906002)(36860700001)(40480700001)(40460700003)(75432002)(47076005)(41320700001)(31696002)(356005)(7596003)(82740400003)(478600001)(86362001)(31686004)(966005)(26005)(8676002)(8936002)(4326008)(70586007)(70206006)(786003)(6916009)(316002)(54906003)(956004)(2616005)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: alum.mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2023 19:07:09.0804
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d13bda4-ce9e-457c-ac37-08dbc443f160
X-MS-Exchange-CrossTenant-Id: 3326b102-c043-408b-a990-b89e477d582f
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3326b102-c043-408b-a990-b89e477d582f;Ip=[18.7.68.33];Helo=[outgoing-alum.mit.edu]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7461
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

At 2023-10-03 12:50+0300, Amir Goldstein <amir73il@gmail.com> sent:

> What you can do is use the new mount API for kernel >=6.5
> and provide the parameters one by one, e.g.:
>
> fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir", "/tmp/test-lower,", 0);
>
> See example in commit message of
> b36a5780cb44 ("ovl: modify layer parameter parsing")

That would be great, but fsconfig doesn't appear to be documented. It's a 
new syscall? What kernel version was it introduced in, and how am I 
supposed to support older kernels?

The second part of your message suggests that the answer to older kernel 
support is libmount:

> The mount tool and libmount in util-linux 2.39 support the new mount API 
> [1]. They already auto detect and fallback to the old mount API, so you 
> wouldn't need to implement per kernel version logic.

Again sounds great, but in the libmount documentation I've been looking at 
[1], there doesn't seem to be a function for setting options individually. 
mnt_context_set_options accepts a comma-delimited string, and 
mnt_optstr_set_option modifies a comma-delimited string. What am I 
missing?

Thanks,
Ryan


[1] https://cdn.kernel.org/pub/linux/utils/util-linux/v2.39/libmount-docs/index.html
