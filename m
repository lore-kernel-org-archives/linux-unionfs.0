Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E41F1C433ED
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Apr 2021 11:25:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA51861439
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Apr 2021 11:25:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235040AbhDUL0E (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 07:26:04 -0400
Received: from mail-mw2nam10on2050.outbound.protection.outlook.com ([40.107.94.50]:30433
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235070AbhDUL0D (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Apr 2021 07:26:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LvP1SfgNdPHdOCRImEJ/r7saikHde+3VeNDc8PHmW4BbD8pjkeoYkhPbSy/N2DPrRY5SjS3k6KA1ws1//VZmDFS8U1ovMbDTbQWKR0ThOvIdPZKX2Ak2nHeFCWsEnV3i0xwBWLRtR1r5vhtNjM9Ogmgv6uIxctJVuK0BD0vhcdi2sHwgiABOOAjp/2hqqn4rTiQSGNTFuEcEQrLVV0iPw7UneAry/ue3qw388stps+44ZPegKWw/oXqjpP+k9qJ6RdwqZzxIYZrE4UXwvJxYRktFy/Hw+07HSFtsjdNZEx3N5U4b6lZmMvqAOAIcg9szszOd6IwGzlm5VXigVSD/Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n4Ip7qLaVKRtXQjdvFyRrIzJxJcH3jM0WpKUGD9SIVw=;
 b=MmLSavepgnI7np4S9i34/n7ngftUbQ8qxGjZhrTKc5zuepx2J06Ns0/LVrXln+cCAlUJFdg2AFqHY9zE5M/kkAxncrSa+R9yviLI/WJaWRRn5CL8gg/pgSOLIShDfHI6v7rEuySnzKS3zGujEWT46iB3oMhJcbXVeFj8K0/ElGCscxumMxphiFq0Nag+7JVtr7w1u+wH+E6iUk4js8lYRnip2HG7arDDh4JdGS5ubZ/dsc+1Yqb53QG2cd0OZTuq1P+Lhxu9PnQ7QcrJM2my8iF+VJMNMZufBEAlRdPoFzA3HBF+l5oMJ3NIs6Fu/Bt7CR6/uXhp1zOrg8fVU9SQog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n4Ip7qLaVKRtXQjdvFyRrIzJxJcH3jM0WpKUGD9SIVw=;
 b=kkYa8OE1ypu7uUt66NPPO0bf0svkSzT5NRg0+YXrwPH1KFOOpQMjhfm22X8yUqG1tzmtB5M9oWTtqP2+I+F3Ac3IfY+gXu0bA+MbuDVjiM+Vdjw52eSvJ81KSP/5+f7lZ3YBHOnco7QNmJ/jUCTJ2VIGVvdHtzvz4kmukpBKn5M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3775.namprd12.prod.outlook.com (2603:10b6:208:159::19)
 by BL0PR12MB4932.namprd12.prod.outlook.com (2603:10b6:208:1c2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Wed, 21 Apr
 2021 11:25:26 +0000
Received: from MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::6d4d:4674:1cf6:8d34]) by MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::6d4d:4674:1cf6:8d34%6]) with mapi id 15.20.4042.024; Wed, 21 Apr 2021
 11:25:26 +0000
Subject: Re: [PATCH] ovl: restore vma->vm_file to old file
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
References: <20210420020738.201670-1-cgxu519@mykernel.net>
 <CAJfpegvfGAynZ1kz287eJHVRc6+81FzUwSq_V9E36qXCB7WtYQ@mail.gmail.com>
 <481e8c92-3084-f0bc-56ec-86099abfdc55@amd.com>
 <CAJfpegvMcitbZ=APBE7Eu4te1LR+thwH=iYrWMvqn80mFFvmLQ@mail.gmail.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <0a34847c-2db0-4901-2206-7df1f348e32e@amd.com>
Date:   Wed, 21 Apr 2021 13:25:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <CAJfpegvMcitbZ=APBE7Eu4te1LR+thwH=iYrWMvqn80mFFvmLQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2a02:908:1252:fb60:30c1:a1b7:433d:2c5d]
X-ClientProxiedBy: AM9P192CA0001.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::6) To MN2PR12MB3775.namprd12.prod.outlook.com
 (2603:10b6:208:159::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:908:1252:fb60:30c1:a1b7:433d:2c5d] (2a02:908:1252:fb60:30c1:a1b7:433d:2c5d) by AM9P192CA0001.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Wed, 21 Apr 2021 11:25:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0fcd015f-9b0c-40fe-f921-08d904b82971
X-MS-TrafficTypeDiagnostic: BL0PR12MB4932:
X-Microsoft-Antispam-PRVS: <BL0PR12MB4932597DF629F7F563F37D5883479@BL0PR12MB4932.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0H8E70QaY5l0twdwSkb4W9rGMOpAyXBOqPvfyrnF+cjTydOFdTwlDZk1iZM+hGk09CSL9Ejdcp7blNSWDVyWgMVsbu2H1EVfk73QR7l4vlZu9/D6CW2ncZTuOhCUxMS1RjboQULstOz5quiE6LXOXDthYOXzEPSBrBidujBqubhDmbousXmr+rKxO0BcIH2dStjD9vYfuNT+kVdmdOGHAZe6qC4Bz2uWPu/uXG4Yy8MES7/Pic8hXn+2mpILkus10Hhh/WzqzbvtGd0G/ggssW3k/wlIvhXGqMqINQOUcxN8G+L5ud09HZRX/Hd10dzVk4VgojdGpDCHEMkBHGASfr51X9c/ID8uHVUcqiLr5W1QG6lU7RaJ1NwB81u3dtGaF5qzHZPj17N36dprPTlwtrYSE7YoWL8ESLT2cYlfMIGRU7L4jPRVwXd/tb+VQg9P3TxmnVAujaJnXX4zpgfbGN7wk071/HIciSR6/LuI/coo0z1Go9L5E/Pj1Ilf/AAjkI5MXdApMXdQdWTI10EAZ9SHpDt+8dY2OJ0mSI2HPa3oNf80E72hGnexcAfVQZE0egbDoYxHdDRGIPwE3Q072oJzcrTYX6U+fBFAU2PllSRaHgnvxfOo3kVJ/6oClDxvozNnAsBvbIDYpZaznaW3etwz8YIvBE4P6Nf5HLW7F/PaZCYpjVRnLX+Dsb8drVNm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3775.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(39860400002)(396003)(376002)(5660300002)(6916009)(6666004)(31696002)(86362001)(31686004)(66946007)(36756003)(66556008)(66476007)(16526019)(186003)(4326008)(8676002)(2616005)(53546011)(478600001)(6486002)(38100700002)(316002)(54906003)(52116002)(8936002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RnNyaVkxdE82d1hEY3oyQm1LQmRFUFJCZ3lqVVlBVE1QbDFnWFJTbWU0ZjMy?=
 =?utf-8?B?Y1MzczdWMXM3T2NTOXU0T2JPcTFRT2JDeXI5ZlVObHVQeE02RXBQL0dabUxt?=
 =?utf-8?B?REVaRkpzdHV3KzRJeDE1d1dQSDhiRXpSS2RZbXZscWRsVmdXRHRCV08xYUZo?=
 =?utf-8?B?L3pQcUw2QUZETXUvbVZ3SVBxVmlDemQ0amNPMDJvaEpjTWNNemhOVWVyMjl2?=
 =?utf-8?B?SThndHovZGZQMlNIN3F1Y21FSWk4QU1qZVBENlBFVDNPVXg4alI2S0dsQXhJ?=
 =?utf-8?B?bnJuZS9qejBnMkdvTTFhT0NMTXg3RVNnR1lMOU1RakpFMXhyVFJkK0NBT0dr?=
 =?utf-8?B?N3RrQ0t1MHl5MzhDY0FXVjdVVjBiYnl3YURya01Cb0tXVW9hSldtSjlIcTdj?=
 =?utf-8?B?aTNoWWhYaDVLQzBZWUUwbFpXMFp0TG82YmFsb1RXYU9kbUZwUlFKUHgyQjdD?=
 =?utf-8?B?QVBkOWd4TE8rcFA5aUhQTURyL3M3dTc1KzBGTFR1b0daWkdMQWl4OWxCUzVN?=
 =?utf-8?B?RjF0eDZsK2F0dkNYZ3JISExwMnZCbkZXQUtBMk9uY2d6ck9aRDZ3b3NwZnZ0?=
 =?utf-8?B?REdxUFJNSnVBOXpkYzBpVE54YUdTbkJQaUxUL2dGdHVoa1U4byt1RUpHOVZp?=
 =?utf-8?B?aHhwOVJLT0N6dlhDbStacEtaZmhhN212dUZKQUNuUk04cUFXTzF0aG9Jc05l?=
 =?utf-8?B?b2tEMGNVK1JqN1ZWWWZQUnZYNTQ1UzJzZERvNGt0cDZYQ25vd3hQbXdaUHhP?=
 =?utf-8?B?bVBhb1d4NTRUTWZZaGw2WGdhRUUrUGJsYWl6UUpIVXFHSGd1V3Z3VER3dDdu?=
 =?utf-8?B?TWtEWk5wY3FycUc2R0NaTFIzQUxLV081VWdBVG9YWmZXSVYyVy9VNVZoTG9Z?=
 =?utf-8?B?S2c5NlVYMGFaTmpmbUNOalVjZlRCUkxHTkNaKzQ4V1kwSHJZLzVzVlBUT1Vy?=
 =?utf-8?B?QUlPT1ZDa2pTbjV1eGh0NGlJYTZoYWRSVnUvcThlcnBwZkY4eFRyRUtBRWVU?=
 =?utf-8?B?QmxyZlJZM1poRXVJVUVIOFluR3lwNjN4UDQ0KzdtMldEelJ3em5MbTlzbDFY?=
 =?utf-8?B?c0tVOVc3ZWNpUzJZOWsyWUpzWi80NmMyZXZnWk45QnczZ2pGd2dMZXVwS0lS?=
 =?utf-8?B?N1VMdTRYTlFFQWpqVjNoL3lIY2IwVTVxVHNEY281U2VHZEVwWVVhVFlXdUdi?=
 =?utf-8?B?S3ZGRitpTjZDZEJVM0ZmdnlpRnhaN29UQlJ5bFdSTU1uZ2ROSHBMK01qcGIw?=
 =?utf-8?B?bENhWWZINk8zUWVaZmt6N2JWaHozNHVMUS85M00vcjZaSk9nYlpSbm1QSTMz?=
 =?utf-8?B?SzlMTmg3QVRMNnVCSVMzN2V5WFBKOFJ2NitCWWU1NG5OMWNYL2JEbW1nYUdk?=
 =?utf-8?B?SFlGT1lVUERTTExLTWdQM3VtK1FoMytWRDJraW43eXhzZUNRVnVCbXE1Q0pD?=
 =?utf-8?B?WkdvVmVQbzByaFpKdzlqNkd4NVVKTDV1cTdocmYrMlFib0FjRHJKTnBpb3Ar?=
 =?utf-8?B?SmFvYzJUWTVkTWxDeU0xeFArNy80a3Bvdk1TZ2x0SjVSNUtKbG00UkFtQk5h?=
 =?utf-8?B?RUFud3Y3WnZDRy9GUDQyYXNPSkZGdDREL2JOSGllU25OMGxnSGlKT0E0QnYw?=
 =?utf-8?B?cW1JWUt5K1g0S1ZWYzFib3lmWVhOU0xJbDRiVEpnczZQZEZUL0FHTUU4VWNk?=
 =?utf-8?B?REFPdnZXY1NIUEZrcUJUUFhneURabGVYUkx3d3VlOUp2K05scTdybWFZVjdh?=
 =?utf-8?B?NEhwRDNIMVJHZW5ZRnBWUmdjRzJwOFZsZ2d0R2UvZmNzY0ZtWm45SG94S2tU?=
 =?utf-8?B?YWp0SkE4QjNqM2NNTmdUWUJ5K2lMN2lQcEdxdEYyWHQ1d0hpckx6aEJNUjNp?=
 =?utf-8?Q?+tsuEpAXQ6MVk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fcd015f-9b0c-40fe-f921-08d904b82971
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3775.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 11:25:26.6893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3rAiCCW6U6uj9/fMSVAM065zotCQQTPQg+/WVDa1igI7r+iS///O/DX5UhBtFd7d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4932
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Am 21.04.21 um 13:14 schrieb Miklos Szeredi:
> On Wed, Apr 21, 2021 at 1:03 PM Christian König
> <christian.koenig@amd.com> wrote:
>> Am 21.04.21 um 11:47 schrieb Miklos Szeredi:
>> [SNIP]
>> Can you give wider context? In other words why did the patch broke the
>> reference counting in overlayfs?
> In the error case overlayfs would put the reference on realfile (which
> is vma->vm_file at that point) and mmap_region() would put the
> reference to the original file (which was vma->vm_file before being
> overridden).
>
> After your commit mmap_region() puts the ref on the override vm_file,
> but not on the original file.

Ah, of course. Double checking the mmap callback implementation of 
overlayfs that is rather obvious.

>>> Changing refcounting rules in core kernel is no easy matter, a full
>>> audit of ->mmap instances (>200) should have been done beforehand.
>> Which is pretty much what was done, see the follow up commit:
>>
>> commit 295992fb815e791d14b18ef7cdbbaf1a76211a31 (able/vma_file)
>> Author: Christian König <christian.koenig@amd.com>
>> Date:   Mon Sep 14 15:09:33 2020 +0200
>>
>>       mm: introduce vma_set_file function v5
>>
>>       Add the new vma_set_file() function to allow changing
>>       vma->vm_file with the necessary refcount dance.
>>
>> It just looks like I missed the case in overlayfs while doing this.
> Yes.  And apparently a number of other cases where vm_file is assigned...

Yeah, I wasn't aware that filesystems do that as well and only 
concentrated on the drivers.

Just did a "grep -R 'vm_file[[:space:]]*=' on the full kernel source and 
it only showed one more case in fs/coda/file.c.

Do you see any other occurrences I potentially missed?

Otherwise I would say I provide patches for those two cases in a minute.

Thanks,
Christian.

>
> Thanks,
> Miklos

