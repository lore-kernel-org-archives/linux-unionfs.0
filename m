Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF09CC433B4
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Apr 2021 11:03:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4FCD6144D
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Apr 2021 11:03:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234810AbhDULE1 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 07:04:27 -0400
Received: from mail-dm6nam12on2053.outbound.protection.outlook.com ([40.107.243.53]:38974
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234244AbhDULEV (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Apr 2021 07:04:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iS/WA3JvOpHD8LR3EIhGWH2icXefUcp/lvy8CDctcFnxqnnTokWfYFzF6SOWSiQAJ09N/CVX20yOagezSooyrPuKk0MdLI1XlKPxMGwQi75P8x2CD8lrXqxygL50CPhmQyIKXwK760GIh7H/lvb7qFVZvj1TUAtp8jVZc2F7ngJRs8PZvObOZjETUiJX5jIIpCVVlGpXsD13N79FzplfIxFg1749wxX7NB/ChzGPNivnrI54q7fbbKoE/n6IftMclcG2yVq1y/xQi5RzRTfjPaSNNXhdvA93u/5wxZSAOkcglypEhJAzkS4fVdPN/hY8igxFrJHfvxHMOZrfmwwamw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v+ejPZxFIzjbBgRLDA0Tgk8I0jrXWpHGSm7yhCd/Tzw=;
 b=gjYC35SWowzf7PI/9SDIPsUx6Jk0kf4Sid1XY5vkrrhmO11elkOUhtwNyhoIvKvQGUagadIcTilclfu4AsrI49dLVk4clzSK0ylZx01/ubI5ZjSz+vXr8snk1u8oQkI6T1SMduTZpdOr8eXYkPZVY+ikN8EjIS5odJzOozjXx7/p1mZzNu8AFuu1oZfCZWOhw4hileke/gZx5HCOojXSJWjFRnsPHBZ0p9QCdxQ5HrC1+J30slqfav/Qrjifw4R1qbmqYpaZy3oCO7/XclSUW+vnPjK44bXpTpUW39bqDedAY7JpUGjcJlynXcougUgNONEmn1gXh/jw4LBYpreYiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v+ejPZxFIzjbBgRLDA0Tgk8I0jrXWpHGSm7yhCd/Tzw=;
 b=x/Pg+LLUHrsZumniNhevWTmdrzyFfpBaH62JjfalP05EWNuipUKm/nBnGLaSIMa3oWNAF1i3skIb9WAcT6H2Zt2xPJPscGNYHVlV9UvUk4QZ4hOmk9IPivrDZi+OC9Ewfmr9igL+vvGKkaM195ydIGtywNREwh81zmeeuqEZ/Jc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3775.namprd12.prod.outlook.com (2603:10b6:208:159::19)
 by MN2PR12MB3726.namprd12.prod.outlook.com (2603:10b6:208:168::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Wed, 21 Apr
 2021 11:03:46 +0000
Received: from MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::6d4d:4674:1cf6:8d34]) by MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::6d4d:4674:1cf6:8d34%6]) with mapi id 15.20.4042.024; Wed, 21 Apr 2021
 11:03:46 +0000
Subject: Re: [PATCH] ovl: restore vma->vm_file to old file
To:     Miklos Szeredi <miklos@szeredi.hu>,
        Chengguang Xu <cgxu519@mykernel.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
References: <20210420020738.201670-1-cgxu519@mykernel.net>
 <CAJfpegvfGAynZ1kz287eJHVRc6+81FzUwSq_V9E36qXCB7WtYQ@mail.gmail.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <481e8c92-3084-f0bc-56ec-86099abfdc55@amd.com>
Date:   Wed, 21 Apr 2021 13:03:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <CAJfpegvfGAynZ1kz287eJHVRc6+81FzUwSq_V9E36qXCB7WtYQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2a02:908:1252:fb60:30c1:a1b7:433d:2c5d]
X-ClientProxiedBy: AM9P193CA0008.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::13) To MN2PR12MB3775.namprd12.prod.outlook.com
 (2603:10b6:208:159::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:908:1252:fb60:30c1:a1b7:433d:2c5d] (2a02:908:1252:fb60:30c1:a1b7:433d:2c5d) by AM9P193CA0008.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:21e::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Wed, 21 Apr 2021 11:03:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cbe0210d-6eb5-492e-ef8d-08d904b521fb
X-MS-TrafficTypeDiagnostic: MN2PR12MB3726:
X-Microsoft-Antispam-PRVS: <MN2PR12MB37265C9053596BB0081B713383479@MN2PR12MB3726.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:813;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6i+Yoqihn46p/YRoq957MnF79ecLIYmJ+UARWiluPXqLh1CQW8g8YfESxgnlo7QFpBRVHdGUve0agjCAR4lPLB+mkbEnv0A0PyUXH2aW/rKT5aATC3cCgSjI9ruX5Wm43wjntTcxmtkcXUL/ZI0t4X4Q8FC+PNw9njG3SHEQywJa83oDNxlBUAZL+V33PnXnzd7Kih+n8drhBgYg5e/TvOmc7v5yFobP3r7PGeCRoooxBW9jEcQyqzhmdxM0nVLpDDlFLI/4alomhVP1gkwOeFfmd7t/2MSLpU5NJ32THnBhXCFTqnV9/jhmJvdF5k1F/nmmGizHNU6wFv6Esx4fpvIyPnOaJfMdzIZm259vOgUde3RN7ZtRGtzee/9Fu6Q3Pz7taI0EXeN0RIH+7puHUi+XVhPm1u9PwV3xnds8mNUi2RlfpDf5rXXzcfZQHV+fOmPfQIiB+rOJRomCnt7gzy2iWV4LXYcfe8y/b+v19tuVuJyD9Vyg8znn8wwdih+oiZVa9oDg+6f7bSoLqR8kPR3aLMIe8s3c7vgn+E7YeLAQQPCfTTFhnjqNbzGh/KEzKzbcvK+kU+RT7lMOOgdEC4FAZLP2c3EBL9Dijxwt5RZWV0Ic6cW/LNQv0n/vN35syXBqnyzm1L67bHJJ2fmKWKhpSAVs6MhIzM1nRPRyGMFWbin6w4LLDQ46aW5GIx79
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3775.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(66946007)(5660300002)(8676002)(316002)(66556008)(53546011)(31696002)(478600001)(52116002)(2616005)(86362001)(6486002)(66574015)(66476007)(110136005)(83380400001)(6666004)(186003)(16526019)(38100700002)(2906002)(8936002)(31686004)(4326008)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?THVWWkI2bE0vejF0Uk1Fa2g1ZXV2SHc0TlR1RjNxSXdMV1NTdlR6K0ZralFG?=
 =?utf-8?B?UGZXUjhaczRZZTJ4UDhsbG8yQ1VqRC9BM3lYN2M2V1FpMFNhSHIydndObEd3?=
 =?utf-8?B?cTV6Q3o4SHJuM0g3VDIwUmFzcjBUaytiR3pvaGZSSGt4bm90bldSWVI2WXdB?=
 =?utf-8?B?cFV0ZUVPU0xaelhzTU5BQ3VwTm40dVpPL0xzSVBuTlBvT3pUWjdZSkZSVEdU?=
 =?utf-8?B?MzYxajZTRkZlZUxWa3lBQVJPWXdwVnJGbnQwODJQMWpycSsxTkFtdzVZVTFk?=
 =?utf-8?B?YzJ3TVFQbVhBdDdRUmFyRk1ZdlN6V21UNFpsOWxwZzUvTUFkQ1c2YTVQeXR1?=
 =?utf-8?B?WWh0TmYxbFhWU2JQOFpqQmpkeFJNZGtEVmRCSGpkQWlEcm1PbGduYzRJOS82?=
 =?utf-8?B?YWd0aEZncHl5OW9UeDd6cjNyUDNoQURXMGplRkFrQno3RnIvWTZXU0F3T2wx?=
 =?utf-8?B?ckdnQzBoMzBldDc5aUhNdmlDa0xQcGNJSFpFSVhUWFNaY3dxU3ljK2lROXVE?=
 =?utf-8?B?TXB0ZXp0eVVCeTI1SGpKTDlsdCtqek9WaG9FNlFMeTRTVFdCcFJJaTE5V2lF?=
 =?utf-8?B?QTZ1RDFFWFdoUW9Sa3doYm1GSTJUWEQ0MzVSWmIzbFBQMm93SE9XYTlQWFl5?=
 =?utf-8?B?Q3R4Q2FlOXRQSUJuN1dHdGhkdUI2Y0VZMkw5b0FWZHNFQ005ZWp1a1k5ZFdJ?=
 =?utf-8?B?enh4WGljdm5HYmdEc2VSYUhzVjlKeUlqUC9LbzBDTFkxYUdGcHp6UjJ2R0do?=
 =?utf-8?B?Sk1LeU9kdFV3SHdXK25MaDVrS3d2dUZmMmlsZVpaZFlHMU5tU3dpWTVSRWF3?=
 =?utf-8?B?UEVxcTFMU21reW1BRjd6TUVNZHNiOGFxdTF4TVJKaTkxSzJ3OGVraXc1L3NP?=
 =?utf-8?B?ZHUrbU1DckNDZjlWQk5ZS3czWktldjdGZTNvMmFueENsMzRkRmJmT0FpRUlN?=
 =?utf-8?B?RXNBUDJXdmZZdWZwcWsxb3QvSm8vc1Z0S08vMWxzUkxRSG9PcHF0L2UwK0cv?=
 =?utf-8?B?QzQ2enF2QWJkNU9xbXFLaHhzL0plYVJZdFFYUVBXejB1TVk2MWQvVWtYcXNI?=
 =?utf-8?B?UjVQVlY0UnFsNGhVUmd5VzFyYzJEUWZtTmpzTElhRldUUll0RmNaOW5pMU1N?=
 =?utf-8?B?RmdEbTBmSC9iL0NCcWtNaDBBR29YUVpTaS80M2Fha01KRTlEZHkxYXlKRjUy?=
 =?utf-8?B?dTRPdE15Y2xlUWNNSVN5dlNrZkpKRGt6b3F4VFVNZlR3YWtnbnZ1YU9HR0c3?=
 =?utf-8?B?N2hRQmMraE1IU3ZHVXV4SVhXM1FBK3M5Ly9LdTZRSGd0dncwWG5DR1NqWVVV?=
 =?utf-8?B?UlkwU3RiQUtsWjlCOEtvTkxPWCtBb2J5VWlJWE9LMGlYb0hrTlJCako5NHNX?=
 =?utf-8?B?RVZEeEdJQXRuYU1HSWlFSXNxODc3U3R2eHJ2S1F0UlVmTmwyYUJzV3J5R3Q0?=
 =?utf-8?B?T2xXajBDWFE5U2JhdjcvZ29hUGpRQjJvdHcvRlVmVnM0QWtGWTc4T1RjNWJB?=
 =?utf-8?B?VEpxc1ZEeVFNWExKNmUvTXJYTTJWYnVlWWxJdDU0RGFPNUpjK1pGeDR2eG5V?=
 =?utf-8?B?OFgvem0xSnp5ZFcxR2MzQTQzT2x5YUFlbU1VdWVITVlMdm9wNTNKcmJFcnk0?=
 =?utf-8?B?VlBuSStuT09LTGFTemYxVVNwRTJiMmVNUzhRdXF3RE8ydmhTVHJMOVhSV3Fm?=
 =?utf-8?B?ekFqampqK05mWnVXKzJRYURjb2laNFhLZDhJT2dGUVNQWjBBS3FjcDlGUDhC?=
 =?utf-8?B?ejc4Wld2ZGZlOFZTY1JJcElqaWlUcmxGMGhHVnFlN3pyQVdkbGxTMnBpR1E2?=
 =?utf-8?B?UTRsQkFPeWVPWEpRa3ArVFBqZC9aenFRc2E5VlJrVjF4bW5xbVdHQzlUcnVL?=
 =?utf-8?Q?6MdDTVwY2ZVHU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbe0210d-6eb5-492e-ef8d-08d904b521fb
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3775.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 11:03:45.8634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HJuEFGHUz7urL13Xey7mC0tb512NkorV/QPrCG+ADsBc9TQpkekIV2QDD2+IP5k4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3726
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Am 21.04.21 um 11:47 schrieb Miklos Szeredi:
> On Tue, Apr 20, 2021 at 4:08 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>> In the error case of ->mmap() we should also restore vma->vm_file
>> to old file in order to keep correct file reference in error path.
>>
>> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
>> ---
>>   fs/overlayfs/file.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
>> index 6e454a294046..046a7adb02c5 100644
>> --- a/fs/overlayfs/file.c
>> +++ b/fs/overlayfs/file.c
>> @@ -439,6 +439,7 @@ static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
>>          if (ret) {
>>                  /* Drop reference count from new vm_file value */
>>                  fput(realfile);
>> +               vma->vm_file = file;
> That's interesting: commit 1527f926fd04 ("mm: mmap: fix fput in error
> path v2") which went into 5.11-rc1 seems to have broke the refcounting
> in overlayfs in the name of cleaning up a workaround.   Wondering if
> there's any other damage done by this "fix"?

Can you give wider context? In other words why did the patch broke the 
reference counting in overlayfs?

> Changing refcounting rules in core kernel is no easy matter, a full
> audit of ->mmap instances (>200) should have been done beforehand.

Which is pretty much what was done, see the follow up commit:

commit 295992fb815e791d14b18ef7cdbbaf1a76211a31 (able/vma_file)
Author: Christian König <christian.koenig@amd.com>
Date:   Mon Sep 14 15:09:33 2020 +0200

     mm: introduce vma_set_file function v5

     Add the new vma_set_file() function to allow changing
     vma->vm_file with the necessary refcount dance.

It just looks like I missed the case in overlayfs while doing this.

Sorry for the noise.

Regards,
Christian.

>
> I suggest reverting this commit as a first step.
>
> Thanks,
> Miklos

