Return-Path: <SRS0=0kBH=DA=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32775C2D0A8
	for <linux-unionfs@archiver.kernel.org>; Wed, 23 Sep 2020 12:53:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C5862137B
	for <linux-unionfs@archiver.kernel.org>; Wed, 23 Sep 2020 12:53:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="L12sg0z0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgIWMxp (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 08:53:45 -0400
Received: from mail-am6eur05on2090.outbound.protection.outlook.com ([40.107.22.90]:5089
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726130AbgIWMxp (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 23 Sep 2020 08:53:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Za9AyjWouFehPWx87iMa9vvzGxgnA1u9EWmLokTrgoop7vGkxaCoWb4P5su6pNHHVrwG/VYo4X0Q6HQzmalvkplQHs8q9V0pzB6vSCXx3ZWR31T1vsYjPgwrfs5A5AWDSM6pZ8ct1Bi+b7YFIhggskaSVuyJWcwCNBv5u3C6rEDVoTHKidBQy7vibRynrWdpByOsm14W7Av3H851fZgS6492O6lLrae5/osg6y2LtLwQ2+mgY1fzn7WzDRWYVGKIuwh5BgfCUBB3v720TJDKiYKnRedDAmysVHonkxkcnr7JvslTEdjcRUwKG4R9U7VDuhLmF6dvsFrhpqsl0sj9mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mECJz6l/hPVTi5uo1BrOuTzdwm7ipOj/xhKO3W4iGO0=;
 b=B+XwtA6q/E8vjG4PKM9+EfP4nbdIwoYZj0hAlVwgqcGZItv57k6COSml/vHeAGnecnsdGvfGfM6aMe52dlg8p9kD/MNmkE60Wtqf1i15hZCyfeCE/qLQdSb28WuXc8t0EmTlXWMyrYPeHtX17ScKCh+B+rqOSY04KsJNmtkbha0X4gmkttQRiK463tD6AfTl4b64zVN3yhTE1/Ofduap01z8l+1WP4IrHaJRmCs3viWtTaKZnAtA7+oJWlhTJGpJmbv1Bw4z1ZWHeaePNU3nfY4qIqhc80ScBmDRW6egqQPR6sJ4yT7uq19CdpKCBSMdqJyiii2znPqqeMxPPnQ8dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mECJz6l/hPVTi5uo1BrOuTzdwm7ipOj/xhKO3W4iGO0=;
 b=L12sg0z0B08XleVMxgMNhF2w3Yc/olarjiCVNcOStVksSetTXAhmIF4HeBfV/EpTwNqdm5Xtehl/eUpRLu8Mg4XuaLGeG9jnM13N30vuR/qQ3DLyHO87CKa+cOoRb19d0p/tfbVnHOWHTAFbFGTMMFKJGZ25gtVRFrAa005QePQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=virtuozzo.com;
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com (2603:10a6:20b:cd::17)
 by AM7PR08MB5415.eurprd08.prod.outlook.com (2603:10a6:20b:10d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Wed, 23 Sep
 2020 12:53:41 +0000
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::71e0:46d9:2c06:2322]) by AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::71e0:46d9:2c06:2322%7]) with mapi id 15.20.3391.027; Wed, 23 Sep 2020
 12:53:41 +0000
Subject: Re: Copying overlayfs directories with index=on
To:     Amir Goldstein <amir73il@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>
Cc:     Pavel Tikhomirov <snorcht@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org
References: <a8828676-210a-99e8-30d7-6076f334ed71@virtuozzo.com>
 <CAOQ4uxgZ08ePA5WFOYFoLZaq_-Kjr-haNzBN5Aj3MfF=f9pjdg@mail.gmail.com>
 <1bb71cbf-0a10-34c7-409d-914058e102f6@virtuozzo.com>
 <CAOQ4uxieqnKENV_kJYwfcnPjNdVuqH3BnKVx_zLz=N_PdAguNg@mail.gmail.com>
 <dc696835-bbb5-ed4e-8708-bc828d415a2b@virtuozzo.com>
 <CAOQ4uxg0XVEEzc+HyyC63WWZuA2AsRjJmbZBuNimtj=t+quVyg@mail.gmail.com>
 <20200922212534.GH57620@redhat.com>
 <CAOQ4uxjp6NpF_Q0QqUTzE5=YiKz9w6JbUVyROG+rNFcHPAThFg@mail.gmail.com>
From:   Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Message-ID: <e928fcf0-45f2-f2a8-f8f1-1ad300eb6fde@virtuozzo.com>
Date:   Wed, 23 Sep 2020 15:53:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
In-Reply-To: <CAOQ4uxjp6NpF_Q0QqUTzE5=YiKz9w6JbUVyROG+rNFcHPAThFg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR04CA0102.eurprd04.prod.outlook.com
 (2603:10a6:208:be::43) To AM6PR08MB4756.eurprd08.prod.outlook.com
 (2603:10a6:20b:cd::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.41] (95.179.127.150) by AM0PR04CA0102.eurprd04.prod.outlook.com (2603:10a6:208:be::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22 via Frontend Transport; Wed, 23 Sep 2020 12:53:41 +0000
X-Originating-IP: [95.179.127.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6983530f-9fb4-4697-bc7e-08d85fbfb2c4
X-MS-TrafficTypeDiagnostic: AM7PR08MB5415:
X-Microsoft-Antispam-PRVS: <AM7PR08MB541512D6E8A8295AB49117E9B7380@AM7PR08MB5415.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ThgJgaeZHrXe7asJl08B2qRJWKD32YPB9Xo1M/vUGVDg2/tBkz6dggvocmQlUQhhFVjaem7eZi8CRoW8wcB+pGUuueMNUqKhGgFFsC3NpAVRaH6plNoyt3VAy1C+o9AeNXf2MKNHltFxbcki/fedL1r+SjFlu5WEFQKTjjLV0/YWnSvNs5sIgbaMyLN39d5R04r8ixuWYHkz366hDVxFrQb9ElOlGVGHnvglF8ddTClkurK583aQsZqvwe/BwaxsD541s7trG8r+SnUQ7gPpns/atmmVt/l1GWWmT8rW//TEz+/0MCpXMcMmEv7nYzqbmhtLUCVT2xkLs4rExEBDWHBZfBNdu/rI43SLaQbQ9lb7tulaqmrtgnkL3NhS4KXWmnC1znt9lmOe1SxzmYsCI4FRqRgzpEdnvz0KtHbQTQ/KxfEqGZFRanwq8HU/uUWr5GdLUI8V9E4QE1NTCPQDS0RZQXFeBJmJKlIiafuiD+TcVBYd/pBa3bye9qO2w6Mg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4756.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39840400004)(366004)(136003)(376002)(346002)(8676002)(36756003)(316002)(478600001)(66946007)(66556008)(66476007)(8936002)(2906002)(2616005)(4326008)(956004)(31696002)(5660300002)(26005)(966005)(110136005)(31686004)(52116002)(54906003)(86362001)(6486002)(16526019)(53546011)(186003)(16576012)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: AonzWlzaiWJWmYPRwLJJYE7UVdpJ7MjaHcaXD8qm8IJVTz/NxqvCAlTO5qAWJ5d9Me11fL52ktU4q0Tu0090YTQRl9YG4e5IKJI2XdDWRShK4k6DH4RqfFeP39l2XhWcCnCwrPbGraKAVHcur8pPEiRdLVN/BWqgWq3rlxxngW/TSgJ3Jm+OOqnXKnozr3NCSwlIbuBmoIcFxThREIrThzJyO0FHMaqUvuaDLFH1GVng/moC/BZax3O/fOvncyn8VNE7prdPV+xwnfjh445vX4ovMDgVQtF0CFjOtUA8Vj5JHF2tnycIBDlm1n00dLImfSjDzh7GSf8s9yVvOshGPGldzxUJywVHhPCPatl9CodlyvKwZqgC9kMT8tfYabAyNb/P0eke/EGge6Ik3Yyqec+zeYNoTqnlyCZ83zvR3sXRjTCE5ES5cfkoNLaMwWppD4VqJIDQOFP3ktbWBCl9j6rAVvrW13H9qdKnOiMJyNqIZ1eNdlG9MYBpNb6WviIpAZ0ub7kyf93HOmFE6VrdumvD79e4ovjlR+NwtA/Zv2kt1eCTrieOmDFkTNWW6QZCAQyWj2c1NfzJtUei9Yxk9pGTB56fnpxYwstyyziqudZy8vaM5u64TfbEvcg5ZkUjR5RmazlRvB/WN4HY/V24og==
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6983530f-9fb4-4697-bc7e-08d85fbfb2c4
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4756.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2020 12:53:41.7923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L6mzV4SWTswRysB3yS1xqNwciUvDSbZqGZL6seVfP4GsrYNTIHNzAnGRUejRqRqO9RHZa/8ByUHPWYd73ugWSESg0AvrmbFvyJ3GV+XsCqY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5415
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi, I've sent a patch which is trying to acheive what Amir had 
suggested. Please take a look:

[PATCH] ovl: introduce new "index=nouuid" option for inodes index feature

On 9/23/20 5:10 AM, Amir Goldstein wrote:
> On Wed, Sep 23, 2020 at 12:25 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>>
>> On Tue, Sep 22, 2020 at 02:15:55PM +0300, Amir Goldstein wrote:
>>
>> [..]
>>>
>>> No objection, but if I were you I wouldn't bother re-writing new ovl_fh.
>>> If you know you don't care about matching uuid in the first place,
>>> it is better to add a mount option to overlayfs 'index=nouuid' to relax the
>>> uuid comparison check for ovl_fh.
>>
>> So is it possible that somebody uses "nouuid" and then a different file
>> got same file handle (as stored in upper). I think that's one issue
>> you were worried about while addressing squashfs fix. IIRC, Miklos had said
>> with-in same filesystem it will not happen and across filesystems
>> sb->uuid check will ensure this does not happen. IOW, "nouuid" will
>> open the possibility of upper file handle matching a different file?
>>
> 
> Well, to be accurate, I did write that when cloning a base lower fs (like with
> dm-thinp) the problem reported with re-created lower squashfs still exists but
> that it is a corner case [1].
> 
> But what I suggested is that index=nouuid will only be allowed for all layers
> on the same fs, where this is not a problem.
> 
> Thanks,
> Amir.
> 
> [1] https://lore.kernel.org/linux-unionfs/CAOQ4uxiq7hkaew4LoFZkf4R73iH_pU7OHOriycLCnnywtA0O0w@mail.gmail.com/
> 

-- 
Best regards, Tikhomirov Pavel
Software Developer, Virtuozzo.
