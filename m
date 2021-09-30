Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FEE1C433F5
	for <linux-unionfs@archiver.kernel.org>; Thu, 30 Sep 2021 08:11:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6671161528
	for <linux-unionfs@archiver.kernel.org>; Thu, 30 Sep 2021 08:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349009AbhI3IMz (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 30 Sep 2021 04:12:55 -0400
Received: from mail-eopbgr1320044.outbound.protection.outlook.com ([40.107.132.44]:59582
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348840AbhI3IMu (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 30 Sep 2021 04:12:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=To44y7xDDfqb7d9plwBjmVOZqJ3kjnbjzZKUTgiPLGYJBzxIsnZV6LwatMaG3U15fPhQZNYV5LcDqEgiRhsgnJd85DfGyQi89x+uJH6sUom4HUSqe+flrc/dpNLKHCQ6P9YmoGiCjqzoGFoHTmEI2f/xnQreCSlWAeXAkFye1lH1wsSqbGSHj5ByeF2NnlLUwPKxfGOzDffN4/btS0eSdR6kBCs3q/ri8h9KEEPh+rWwn6O3K1zrbNiStAKiUSk/v+lHtYv1YK408xo4e8WflLFVRRp93Nd3VYtIAO783sKbuxZtJhIELRubXBf3SBVs8LtkdofhTRZjP7wFliKmUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=9NEtVbj46FVaSPP1w/Oi1f2Wig61sIrjKBfulWjNt2I=;
 b=a7sTPeZb16uauK8jikiyoLLqH+FLNmfmhckNQg5iUCx1CHJ2CcVpCv6yBcIDvQS/209pdm+CrEI3z1r03O1+SllAh5S75/S6E/amHDsKKtSUk2HB5KV6JzzrOZFfLf0r8fIYszqPZFj9C9jxJXeSJHnnEzl3ZLGByZwxAglczX1FX3fUUsk75D3PBkSXNbxahRaXQDLgPfy4d6BiA16UcXw2uZYgufiX3ZEJET+GxZT8BsbDqKGVipK4eSpaeOKiAyeBMKRLuZz0Us5M6MWyazm8aESCjSXj3kx5QAvNPmOBYQhhgAzSaHfp6EjfYBUq3jsl5azxsTtx4znxpfA6Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9NEtVbj46FVaSPP1w/Oi1f2Wig61sIrjKBfulWjNt2I=;
 b=tdWZhs+aOduQsfuo5KdbAfLVAij6ihmlD24wXNp3Jwtl/f85ptzqbnmClOqkKNwNS3Y52zGlRpm8TujJra9OXIGyNV2jzX9kITvh+Hcck8mavVUJiWs9txWQGiCe4nX1NtyfqEVinJb/AkngEmH0qxzcGyK6lYxte7IAHXQW7z8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oppo.com;
Received: from SG2PR02MB4108.apcprd02.prod.outlook.com (2603:1096:4:96::19) by
 SG2PR02MB3943.apcprd02.prod.outlook.com (2603:1096:4:2c::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4544.13; Thu, 30 Sep 2021 08:11:05 +0000
Received: from SG2PR02MB4108.apcprd02.prod.outlook.com
 ([fe80::5919:768f:2950:9504]) by SG2PR02MB4108.apcprd02.prod.outlook.com
 ([fe80::5919:768f:2950:9504%4]) with mapi id 15.20.4544.022; Thu, 30 Sep 2021
 08:11:05 +0000
Subject: Re: [PATCH] ovl: set overlayfs inode's a_ops->direct_IO properly
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        Miklos Szeredi <mszeredi@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
References: <20210928124757.117556-1-cgxu519@mykernel.net>
 <2ef5a5e3-234f-5b1b-5463-726d200e7e96@oppo.com>
 <CAJfpegsJuprveXYHCz7wu11nZU2ZG+pOQ6Jy--PSO6Km1VnTng@mail.gmail.com>
From:   Huang Jianan <huangjianan@oppo.com>
Message-ID: <39bf616b-d962-4295-f7a4-e120ad569d7d@oppo.com>
Date:   Thu, 30 Sep 2021 16:11:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <CAJfpegsJuprveXYHCz7wu11nZU2ZG+pOQ6Jy--PSO6Km1VnTng@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: HK2PR0302CA0011.apcprd03.prod.outlook.com
 (2603:1096:202::21) To SG2PR02MB4108.apcprd02.prod.outlook.com
 (2603:1096:4:96::19)
MIME-Version: 1.0
Received: from [10.118.7.229] (58.255.79.105) by HK2PR0302CA0011.apcprd03.prod.outlook.com (2603:1096:202::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.7 via Frontend Transport; Thu, 30 Sep 2021 08:11:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9552d0cb-07a2-41c0-02aa-08d983e9d98f
X-MS-TrafficTypeDiagnostic: SG2PR02MB3943:
X-Microsoft-Antispam-PRVS: <SG2PR02MB3943EB6FE8DD401E0F7E1635C3AA9@SG2PR02MB3943.apcprd02.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sxlaMWRA5Kt4Ia09nnTTZc+yv/GVJKegHEM6Xc/caNZr+/V4oG7PEm1iSqzFNVCCz4YFtujaLXUlMyvJMpkw44Y2Cg1FKq98jVKiGbz2Q1BkaJz+Gh9N8oN3yo1LLvO4/25dAa1Wrd3jD/jrPMlTw0qgTaoFwuA7uLbqhwlym/QzAm+F9buOTcWNOY9ntIrOv8VRcI41uwpPNrNupFjARhMgpT+Ie7bZbabVRffcoyiwXNoNLbRPDILBeoMnLPq+bb/kFMKy/vyfCd19WLVAIPF/xTA5SLRQ+p9IeXFzFLr/CCWTjw6Vnl7B0RoZcrjZzUckEHGuJM1JYCVyBN4iDXEmDcsg4LWwcxrbbKjqXNg1UPOw2+vEYZxoIU0nPBUxDF3U+wh/oUeD1HkKPqc5BrkXPReVW+aEGasbeFuDcCBCzIKkB2LWXDlA3JCzz5Eomlr+qV1DN4G8SpF2EtTJ5qZCe+ltn94ADR5bH324BQanjeLi2iO7sYh9MgpcJVfd4ZSMb3vcXjtsRTYfJZgXHEmka6nxERXo4vTZjzP5UgI5Hf1lsJKg+whEqMfiq+d1nPgNtG8uxb0MCDwbiSA9mEZ4JZPFDBYg+p4NqTgT4grm23saqIWiPufg18gxXYgAa94DW31pSLWq8V2ifK6NI9kqhbU+xpBXMWrPa5luGt02YuyaaqF0IJ7c//WItZiuFLJ8bgXs5J9MJEUxqcDNW27TUHT7gaPfLW8iFjblWF9pBqTCOypy/+kQxj9wTycSkYeLYy2QL3Xj3DHAAAJ9fDyTo7bskuQQyVP+Unm52B0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR02MB4108.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(38350700002)(54906003)(66556008)(2906002)(2616005)(956004)(6916009)(5660300002)(316002)(16576012)(36756003)(86362001)(8936002)(4326008)(83380400001)(66476007)(4744005)(66946007)(6486002)(26005)(186003)(31696002)(508600001)(8676002)(52116002)(31686004)(11606007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V2tJTnprQW1QNjZranBCNkxkSUd3VjB1KzBBTmlxbDZaSk10dGx6dzM5akto?=
 =?utf-8?B?U0JXY2syUXF0SVBJZGFHRGlZNllmQXJhLzZqTnVCNjExajgxckRzTzFCdktx?=
 =?utf-8?B?ZWU3UnpsMTJjSzltSWhqaktkdFFock50S0NXN2VrQ1hnejRFaXQ0UUlXOCs5?=
 =?utf-8?B?MzV6aVdvUlF4Z3VyVkUra0cxMCt0em96UmhTc1RUaW1oNGpsWTBkRXdHUzB5?=
 =?utf-8?B?dVVCeXlpUFJEMUF3Z2hCczU4ZHRjYW5JOExKVjNlLzV6c284UVZQQThIa1k1?=
 =?utf-8?B?Uzd4VzJNbDFQMEtLczhXZk1TSXpSaWVlZ1dtZko1K2dCK1FVMUdNS0xDS0xy?=
 =?utf-8?B?TG1qWEtudWJoMFJLeHZlcStCeGNZeVQxWnJQdXRDbzFqR0IreSt0emRKQWg1?=
 =?utf-8?B?ZTFoWVROT0pqOFZ1NUF2V2thN202OGUwVDZqNXd6K2NidjF6Z0N2WVUzclpC?=
 =?utf-8?B?M1Q3a2FCV0xWbmVybzYvSVAxZUxEVURJR2YyU0Nod2RiQ2xZcjAwMDhsZkxJ?=
 =?utf-8?B?b3k5c2VFQ2ZUZ2ZhZi83eVNxdDlDdm8wTnVHZ0s1ZTRVUUFvb3NOaG5CbzlY?=
 =?utf-8?B?d3RtYUY3bEgvSnRWT1h4L2FGYzJLS0JTa1hYTms1SzNzeVZCdVRWazdVaXJQ?=
 =?utf-8?B?eUxUQlM2QW44SXJlakhIWE0wOWZzM2NRSEJZWkVzSEwrMGJ6dFI1NFJ4MW54?=
 =?utf-8?B?MFVmQ01YZ0JaMEpFNVdjSVFicEd5OTBxMnVnY0hvVTdXMVNWNUl2T3dYVUxR?=
 =?utf-8?B?YjZhNCszREx0L0VEZFBrOGZ1VXdQbDArTW9Nb0xvYkNLTy9EVElXeFNEaVhI?=
 =?utf-8?B?Mnc4cWZXZ01uN3creTFKQnpWYm94WmRjYVhGRHQrVmd0eXRPVzEwSkg2Qlk4?=
 =?utf-8?B?WVRyVG95TEc1dGh3Smh4NVFmNCtVUnBGYkZOcjMvUWRmTXdPTTVHYzl1WStn?=
 =?utf-8?B?MW1wRi9XeWROYm9Lb0hCVFVvUWlIMkFKWkVoNFdRVUpNQ25Qalpta0xMM1R3?=
 =?utf-8?B?b2NzbmVERkVBb1hVQ29QbW9zRERydHV5M3FSS3NnK1MxVENEK0RSV1dEaDc4?=
 =?utf-8?B?UmNxRnkvQU9mZUhvK0JFSnF1NHh3cTMwbE5iQjZhT05zdzNoMFJQN01FVEx5?=
 =?utf-8?B?UElUV1ZUYk5YcnRSMzVMcm5ob25VNlFKOGpJNnNjZXA2czZSbWNTeGFnVEk3?=
 =?utf-8?B?anRGVDVuVGNSbE5pNzZPVnRCdm9ZVmJWT2xLWDR1dnJkNkZiMXRhcnI5ZnBJ?=
 =?utf-8?B?MysyYjZLaWNuQXNSeGlkWklFQVArTmViUHZyaEtQUmxvQ1FhaDczTDJFOWV1?=
 =?utf-8?B?K2NLMUlCNm5vVUZHTC9SMU5EWXNERVgrUldqQmdQazlDVFovMFZkTWhCT09C?=
 =?utf-8?B?bFUwUmt1RTg2NnArVklqc1JFcE1QM3NCMXUrcWVoZ3gxUEViWk1tTWphckF6?=
 =?utf-8?B?TGNjdXVQVTdRdDRRbG4vRWc5aENDbThaMUVLcVkvbVFSNnkrUk1ncllvM3Fo?=
 =?utf-8?B?a0RkaXg3bmZCZjVGZUk5WmNUL0UrT2N2bndyRDcrOUh6dDJCbkV3VXRRT25H?=
 =?utf-8?B?bjBrMTJTZXRzTlJrU0lzcHVHL3FWWXlLOWhZTndwalVlZWZxWTF1c3A4Tyt0?=
 =?utf-8?B?L1VxbDhOb0o5MUJLanIzOG1PbXB5L0RwQ1ZIQVg3N2xaWmpzcys2U1dhVTBU?=
 =?utf-8?B?eFk0S2toeXhVZXhDMkhaRkxyNFo2cEFONUhHazhueHQ1VU0vSENmb2tIVkpN?=
 =?utf-8?Q?MLbMXPzDGWWKpI/N+rJvkBRD2zETwCGj/+zayj0?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9552d0cb-07a2-41c0-02aa-08d983e9d98f
X-MS-Exchange-CrossTenant-AuthSource: SG2PR02MB4108.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 08:11:05.3520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: obcG06PdnGZBQPxbN5rsjk70WTldoa7ENhCQXhLEFvwQbCaskXj7ifmaNGRwGWjQp5G8YdNhzxRd2/UE31BGuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR02MB3943
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

在 2021/9/30 16:02, Miklos Szeredi 写道:
> On Thu, 30 Sept 2021 at 08:52, Huang Jianan <huangjianan@oppo.com> wrote:
>> This patch can ensure that loop devices based on erofs and overlayfs
>> can't set dio through __loop_update_dio.
> So does this mean that you tested the "loop on overlayfs on erofs"
> setup and it works?
Yes, I think this has always been able to work normally. But recently we
found  that the direct_IO flag will be set incorrectly in the Android apex
scenario, which leads to oops.

With this patch, Android apex can work normally through loop on overlayfs
on erofs using bufferd IO.

Thanks,
Jianan
> Thanks,
> Miklos

