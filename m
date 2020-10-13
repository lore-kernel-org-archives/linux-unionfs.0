Return-Path: <SRS0=fTQB=DU=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24E98C43457
	for <linux-unionfs@archiver.kernel.org>; Tue, 13 Oct 2020 13:54:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 813872478D
	for <linux-unionfs@archiver.kernel.org>; Tue, 13 Oct 2020 13:54:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="t9QU9y+W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388068AbgJMNyo (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 13 Oct 2020 09:54:44 -0400
Received: from mail-vi1eur05on2104.outbound.protection.outlook.com ([40.107.21.104]:46817
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387903AbgJMNyn (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 13 Oct 2020 09:54:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ieBVks/CufMxYqK4akZv4GkuP7A/SJry5/skTAhCu5Iulgy3uOEiDo6XO19oZBx0Su1FOjS+Loa3q7xY9WszDchAQ5KrhPvEbQbvPNCvqmVJUOAXxSa4ShDZuWjl+lOlrDZlsoszCQImFE4H2gB2RLJznyDC6EC8uIfv+ZNevrkiLRawRfgE1CTJRHCPuEf69cUyWd45BuCzK+H5NNquRPZv1JZZ9zFNedoCakqwfuVTOVtP7FF867yyb4lmMAIG3GYfIlyrs2qYXSZAFoGJUM1ERqQNpWx/yh4d2+TW6Mxa5KOxlKX9s+513UgBE59Ld0nvcYNZFXdBx+sxmu5J4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ce09F5ZlHGgP4yIdHwOBPzqM3AmwlUmPMGG6rsx9Mw8=;
 b=jR+qfvbIWgFAbxfnl2WKwscMgfr7lkyZGAfpnfdmDjngNrkl4A6VRp0RMXTMi9TErEsfLrXX5Tvq6svXTUT9IjgYQzhonHsGGhD8hVGuf3euKB2Krr29sjf/B+u0BmBa8KNc9+SQyDgGkeLfFxYCBhabofnLhmhBniIH/CMp4BLLer7au6ten1Yh4wh/4bbXj6vWwZNk0vXG5drvyRm6fMhtyezuJyP3QaYlbw7y3PyOgys0IVgV7eLVesI0DbmqO4vgiBMcAkRcsvixxJSTCIsojMl0bdwkQIffNBUg3brqdPZX9eE3KmrZXVFSNez7ypamVrVT5Drj+p4kWv2XoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ce09F5ZlHGgP4yIdHwOBPzqM3AmwlUmPMGG6rsx9Mw8=;
 b=t9QU9y+WYJzdZc3hOnrSz1bD9mUXsp4l0GNxvT1GK3OWZ+4++LmQnjWpEQTODp4jJoF6YDmd4PlB9zIT/glM6l1tnsSIBMnhVSOiAHyNma4d7p7Ee7crhLq4bqRALakpc5re9WhIB+Wt3BsXIGubOu5uMVsulmQyM6rQhjbZYjA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=virtuozzo.com;
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com (2603:10a6:20b:cd::17)
 by AS8PR08MB5926.eurprd08.prod.outlook.com (2603:10a6:20b:29d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.30; Tue, 13 Oct
 2020 13:54:40 +0000
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::dcd8:72a6:60fc:1fa4]) by AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::dcd8:72a6:60fc:1fa4%5]) with mapi id 15.20.3455.030; Tue, 13 Oct 2020
 13:54:40 +0000
Subject: Re: [PATCH v4 2/2] ovl: introduce new "uuid=off" option for inodes
 index feature
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org
References: <20200925083507.13603-1-ptikhomirov@virtuozzo.com>
 <20200925083507.13603-3-ptikhomirov@virtuozzo.com>
 <CAJfpegvgmnWrmsACuWe_hYCfVm2r0Ltv0C+sN+3T1DBMzrGE9w@mail.gmail.com>
From:   Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Message-ID: <abac619b-dec4-8179-cb59-52c8f14422a1@virtuozzo.com>
Date:   Tue, 13 Oct 2020 16:54:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
In-Reply-To: <CAJfpegvgmnWrmsACuWe_hYCfVm2r0Ltv0C+sN+3T1DBMzrGE9w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.39.230.109]
X-ClientProxiedBy: AM0PR01CA0144.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::49) To AM6PR08MB4756.eurprd08.prod.outlook.com
 (2603:10a6:20b:cd::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.192] (46.39.230.109) by AM0PR01CA0144.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22 via Frontend Transport; Tue, 13 Oct 2020 13:54:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3860706d-1435-4629-96e7-08d86f7f8771
X-MS-TrafficTypeDiagnostic: AS8PR08MB5926:
X-Microsoft-Antispam-PRVS: <AS8PR08MB592695A97454895C9DAF400DB7040@AS8PR08MB5926.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 55JLPyElBzMB3MM4ZihTHpYtwdBdio8q5dPPo34HLm5GR9fpTbE/4QiAHJKlONPWwqGDSgmavpK7p2WELsJ4W1SlM+QlZ93D4hCLyY9swosWLrKuuoH+vNQRE+XK1BhcYSg2nEXe/Rlj1bskd0XZ5j9t8wnJ3MeicxaJKr3ak1PuzUReVFdW3X2GUGP5OZK73bxFrIHTZHDZ1nUg2ylcik07iod4kh+XcAf4LpraA8IXagkmezthBg6pHXCUOVnB5hU2YQhwm/w9auWnb6kQ5UQGy/kUiqf4Ty6EDwU3P4+F8+ySPSqu963oUT6j1l47ayS/Z2MDp3UMU1Vk8EdZQ1YZES/+qokNREHAmMGkKgHcIUEUzxBPVEPWiTTy1Qcp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4756.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(366004)(39840400004)(136003)(26005)(66556008)(2906002)(478600001)(6916009)(16526019)(186003)(66946007)(53546011)(5660300002)(66476007)(6486002)(4326008)(36756003)(316002)(86362001)(8676002)(54906003)(31696002)(956004)(16576012)(2616005)(31686004)(8936002)(52116002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: o7UhRrgPytxc6Yska8JLj5qfPDGGe4hJ0bCfM1J85faPpm0VsTpWUtTaCI0lifOCiHUzB/EqD4MGL5tAJjT8u7QtE9GLcfcnOj7izJ6UFggBStrDtVV1psnWvZVV2AqPJRKwdQBmf6stf3w2o6wlzFCIZQMPWTe9vaU+VMDligBXU2JHc4fyVOFoE82elpUI83ZeC3CAcVcIncLaVHOYcukYeqMeZ1+5xbi+6zgk3YzmSfnEHU+qqtw9x3zH+ESC1V7KfTGRbuIdZ3EXgeqLHr9WeaDpoBf1d8pucCioARMlZJoRoxOgq1c9AEmvKIERQRB8xpnXktFqpp8rnTFTqXtkDU3abv9fH+hfFJVixDS2sAU/UvzuFSDOZW3rLWN0ObkqhxoR3zUXiyYVhh3BZOc/rTmTv3gQqEOShPnFP9dB3GM0crqK4xkIa9BP2L0ErT99FGxhbpVHP3mxUOH/2ICInWCuUgXQUcKX5kHhD4i0C8k9f5Hx3eMC6C4BdNO8tFJAgZflV8+855wm7w7C7MpGAs/SB4TiMM30umO7o1Gp8pu9SmFK7RCxX+o4TVocceLgS+QNLxBKkvhcfSnRs7eCqW2dAbeKwHI0PbUs4fwodWbHx5GYkIcePPC+7x9b6Gi/SUOlyplvbNcFmFCHjA==
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3860706d-1435-4629-96e7-08d86f7f8771
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4756.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2020 13:54:39.9111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N5ay7yKhIZFn8xWvGXHVW2DTW9BkE4YHMj/exoCf9ru+uba2UG5Xbbin2dzSrWdS6BV4BC8FkKfTxbw9BQvDA5VxUn6cZW+BqvjmKmvjC00=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB5926
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org



On 10/6/20 6:13 PM, Miklos Szeredi wrote:
> On Fri, Sep 25, 2020 at 10:35 AM Pavel Tikhomirov
> <ptikhomirov@virtuozzo.com> wrote:
> 
>> Note: In our (Virtuozzo) use case users inside a container can create
>> "regular" overlayfs mounts without any "index=" option, but we still
>> want to migrate this containers with CRIU so we set "index=on" as kernel
>> default so that all the container overlayfs mounts get support of file
>> handles automatically. With "uuid=off" we want the same thing (to be
>> able to "copy" container with uuid change) - we would set kernel default
>> so that all the container overlayfs mounts get "uuid=off" automatically.
> 
> I'm not sure I buy that argument for a kernel option.   It should
> rather be a "container" option in that case, but AFAIK the kernel
> doesn't have a concept of a container.  I think this needs to be
> discussed on the relevant mailing lists.
> 
> As of now mainline kernel doesn't support unprivileged overlay mounts,
> so I guess this is not an issue.  Let's just merge this without the
> kernel and the module options.

Virtuozzo kernel does have a "container" concept and we do have 
unprivileged overlay mounts to support docker inside Virtuozzo 
containers. We don't face any major issues with it. But you are right 
it's not mainstream.

Probably a normal user of mainstream kernel also might want to set 
index=on+uuid=off by default, so that all their docker containters 
automatically support inotifies and survive backing disk uuid change 
automaticaly.

I will prepare next patchset version without default.

> 
> Thanks,
> Miklos
> 

-- 
Best regards, Tikhomirov Pavel
Software Developer, Virtuozzo.
