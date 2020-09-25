Return-Path: <SRS0=6QjP=DC=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB87EC4363D
	for <linux-unionfs@archiver.kernel.org>; Fri, 25 Sep 2020 08:39:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DF19208B6
	for <linux-unionfs@archiver.kernel.org>; Fri, 25 Sep 2020 08:39:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="EcstNhPP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgIYIjT (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 25 Sep 2020 04:39:19 -0400
Received: from mail-eopbgr70092.outbound.protection.outlook.com ([40.107.7.92]:16800
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727063AbgIYIjS (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 25 Sep 2020 04:39:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X8QBKGLemzQwne0Oz4kglkKeQq+I5wNK/TTEBmj0UtnUidsRrPKRbeSO4kqhTee3nEhpo5TDfYBYcfi9VQP82TVaWNd1bop/0KEt78VOsFM8hrSTUbwmPwZ5wicTT+2V7diuK2kg/0OaWHNvKp/2y0dMnD0DrPgPMJgT66hBodwbC6UFnw8W7n5oD9SsuPw76+X1I1ogPGyQAAJ5aqmkI4T5SbvPtPr6Np5+dmBtmlgY/cv8iCKnrDMgQ5DLa7pbrt5Bl8hDFfOliAZ0uTZZxy5+3CFj94p9zbcrwV9KX74w9goF6JwdKQ3cdDP/iTpCPLQuuar5rwxm5xEiiHbhqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dg7TaSyH+fYwjCpdjoxg4x5TNasJTBj1NdKwrZt/sEs=;
 b=fkBJ6A3SGfhWCx+6m/iqMCqUiApgQaUqFL35rK4FDanZT1laNlganFWMgJYjCXxAMVfB152igB57M7yaDuGeJ62uCGDvHnAwrSyp7G3BazL5OqEk4GWw3KuR76MLGoSlbaQe1VeoXzrpv/wH2FPsshhU5peHwxUgnrg6gIAcoJJwX3Ex6JUHqT2c91VbchIhhCVWvU5K/gAU5L5+cvaFjdU3FJDWAuNyQoCeYk5bq4FJmKcLq/nmbySqbWJn+1Wtfi4OAcWnlrOu2K2L3WrqdI7WlYGS9at46FwcHr2rpBfrVs4E/wJRgDH1jlGDSt4QPIxSCB/5AnNqO27pGv79eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dg7TaSyH+fYwjCpdjoxg4x5TNasJTBj1NdKwrZt/sEs=;
 b=EcstNhPPPw00AA+G5DDNqhSyCoDSBxEdkH8ifmXOLbpkB385H/pXxiZbX2aKEDtVi+xOzAT0xsPC8be5bwCtjqgMX6U0hqledmJ1IqOrCfXcAlQ0Bj4iHOEVnk+GvsH33g64F/qy1/HTnE6X3aSeTo1b2EwKOvHHCsH1PSt7t+s=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=virtuozzo.com;
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com (2603:10a6:20b:cd::17)
 by AM6PR08MB3333.eurprd08.prod.outlook.com (2603:10a6:209:45::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.21; Fri, 25 Sep
 2020 08:39:13 +0000
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::71e0:46d9:2c06:2322]) by AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::71e0:46d9:2c06:2322%7]) with mapi id 15.20.3391.027; Fri, 25 Sep 2020
 08:39:13 +0000
Subject: Re: [PATCH v3 2/2] ovl: introduce new "uuid=off" option for inodes
 index feature
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20200924163755.7717-1-ptikhomirov@virtuozzo.com>
 <20200924163755.7717-3-ptikhomirov@virtuozzo.com>
 <CAOQ4uxgb9+_=YhVe0bcO+W-vy3k2X2=nw1YHJOq27SjA33VDYg@mail.gmail.com>
From:   Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Message-ID: <32a5de5d-a86a-b6f3-2f7f-d80e48d80a0e@virtuozzo.com>
Date:   Fri, 25 Sep 2020 11:39:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
In-Reply-To: <CAOQ4uxgb9+_=YhVe0bcO+W-vy3k2X2=nw1YHJOq27SjA33VDYg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR0701CA0001.eurprd07.prod.outlook.com
 (2603:10a6:200:42::11) To AM6PR08MB4756.eurprd08.prod.outlook.com
 (2603:10a6:20b:cd::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.41] (95.179.127.150) by AM4PR0701CA0001.eurprd07.prod.outlook.com (2603:10a6:200:42::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.13 via Frontend Transport; Fri, 25 Sep 2020 08:39:12 +0000
X-Originating-IP: [95.179.127.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c3e7a76-5d14-4a2c-f219-08d8612e7ad0
X-MS-TrafficTypeDiagnostic: AM6PR08MB3333:
X-Microsoft-Antispam-PRVS: <AM6PR08MB3333A2BCC5887C84ADEB8239B7360@AM6PR08MB3333.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8BPK/XuhcIW9uIP6IvXuK5Nn7JB5ZC49JNS7svdpaXjnkaRxIi6NqYMcGiEp/eAu9KrplVqsqXrnFIJkJU7DMuGDXyAHHAKGG18efZfm42IoZbZpLKsuISdCi0irDJpyn9FPMSsBSmNtulh8GsJO3qaXVeAsHRt3h/qY1JqJa5Z2szff3ORYSfDh+eOq5ExocXPXJg18btHFiUTClKSQSIEMifyBz2kxaorSxzhksyGmWfC4YY1dWG/3aoNvC510fXtZoJsKVpRPNNR2DU3J2fA1YoIHWFpCJt+opmPL2GbcXBlG5JDvgd1ydAG6XuFpZCvYBRAOJjmVk6uQ01zOrVfg5LWvgRbqG0Bieov4mGwAaWPeLepP7dwGDXMkHJI8o/TiB/Ot0H3t2vpeZuFKTEkMle4dPmA+2oK8/NmcYX2ZMa/k4snFJQVHYpEJ5EuQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4756.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(136003)(346002)(39840400004)(16576012)(186003)(36756003)(31696002)(66946007)(8676002)(86362001)(16526019)(956004)(66556008)(6916009)(8936002)(2906002)(66476007)(316002)(5660300002)(6486002)(2616005)(31686004)(4326008)(53546011)(83380400001)(54906003)(478600001)(52116002)(26005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: uvfxifwGtAP0lKrLaKh/Y88gOqv3+1DMD6JkNaWL8lfRjD+H/QUZ9RSYFf+Kv3KGJoe2JMcSi5/frvn393WcU69Fz0VJEzMO+gC+HLsAZNlFaU3iQXH4He8EwEWY38uW8/70bcC28hsXMMMy9jKkFvZYdkYEh+FcUFDj/Diek9gOVsV3UMk7xVbhByQYHWjrJRTsniRiDbuO6aEPpnk2MnXo7VbV/p5eAWux6tQnmkjFhsMwDVQGSW3Z3nbg5hEYJk9SLg+SHcoyqAsCgqRbD/7Bd4Rg+1QkHflax4/kOwMhnuwubbhha26kgTNCo9IjOto/pMyMjWDtiACHBlbNnw37eUdQSxJ3oj4VaowR8uZpdi7t3qW0zR0nrLTwpOESYLcE8X3wIc5vgnlILE1uTgQt11r+wI6B6EnRoCzPlyfuEg82uZbd3jhx8WdHOVik4YHcSCdWiJeG4gpPjYcWi8iz8PW13VywmbGhrnANGxShSr8+2O/mbeGfWvFamAR2SvHU6WIgzjM4HcI020xR/tMIHE38M8n6/5jL8hIKwFw0GrLDGkbDSZ8EiIlKMg37vm+c625zCqaaQj8sGLOTRuU4GO7vp3EkGlsgH26GIpZ62HP93d1eDA2Zx6ii4KxMyVTikrIKWj+DVBJqQWFDfA==
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c3e7a76-5d14-4a2c-f219-08d8612e7ad0
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4756.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 08:39:13.1847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m4I2HDp0p/VEpRvGsoyIqpa9EekLSjTsu0U5iUXqcchC93upnryiLmhRyJkwCxfU0RjMHVgMomyIQqRGnXGIkTSeyj8vrhK1ZxHHt4pztKY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3333
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Thanks for review! I've sent v4 to address all your comments. I've also 
noticed that I had inconsistent config option naming:

+config OVERLAY_FS_INDEX_UUID_OFF
+static bool ovl_uuid_off_def = IS_ENABLED(CONFIG_OVERLAY_FS_UUID_OFF);

this is also fixed.

On 9/24/20 8:02 PM, Amir Goldstein wrote:
> On Thu, Sep 24, 2020 at 7:38 PM Pavel Tikhomirov
> <ptikhomirov@virtuozzo.com> wrote:
>>
>> This replaces uuid with null in overelayfs file handles and thus relaxes
>> uuid checks for overlay index feature. It is only possible in case there
>> is only one filesystem for all the work/upper/lower directories and bare
>> file handles from this backing filesystem are uniq. In other case when
>> we have multiple filesystems lets just fallback to "uuid=on" which is
>> and equivalent of how it worked before with all uuid checks.
>>
>> This is needed when overlayfs is/was mounted in a container with index
>> enabled (e.g.: to be able to resolve inotify watch file handles on it to
>> paths in CRIU), and this container is copied and started alongside with
>> the original one. This way the "copy" container can't have the same uuid
>> on the superblock and mounting the overlayfs from it later would fail.
>>
>> Note: In our (Virtuozzo) use case users inside a container can create
>> "regular" overlayfs mounts without any "index=" option, but we still
>> want to migrate this containers with CRIU so we set "index=on" as kernel
>> default so that all the container overlayfs mounts get support of file
>> handles automatically. With "uuid=off" we want the same thing (to be
>> able to "copy" container with uuid change) - we would set kernel default
>> so that all the container overlayfs mounts get "uuid=off" automatically.
>>
>> That is an example of the problem on top of loop+ext4:
>>
>> dd if=/dev/zero of=loopbackfile.img bs=100M count=10
>> losetup -fP loopbackfile.img
>> losetup -a
>>    #/dev/loop0: [64768]:35 (/loop-test/loopbackfile.img)
>> mkfs.ext4 loopbackfile.img
>> mkdir loop-mp
>> mount -o loop /dev/loop0 loop-mp
>> mkdir loop-mp/{lower,upper,work,merged}
>> mount -t overlay overlay -oindex=on,lowerdir=loop-mp/lower,\
>> upperdir=loop-mp/upper,workdir=loop-mp/work loop-mp/merged
>> umount loop-mp/merged
>> umount loop-mp
>> e2fsck -f /dev/loop0
>> tune2fs -U random /dev/loop0
>>
>> mount -o loop /dev/loop0 loop-mp
>> mount -t overlay overlay -oindex=on,lowerdir=loop-mp/lower,\
>> upperdir=loop-mp/upper,workdir=loop-mp/work loop-mp/merged
>>    #mount: /loop-test/loop-mp/merged:
>>    #mount(2) system call failed: Stale file handle.
>>
>> If you just change the uuid of the backing filesystem, overlay is not
>> mounting any more. In Virtuozzo we copy container disks (ploops) when
>> crate the copy of container and we require fs uuid to be uniq for a new
>> container.
>>
>> v2: in v1 I missed actual uuid check skip
>> v3: rebase to overlayfs-next, replace uuid with null in file handles,
>> split ovl_fs propagation to function arguments to separate patch, add
>> separate bool "uuid=on/off" option, move numfs check up, add doc note.
> 
> change log does not belong in commit message.
> Move after --- please.
> 
>>
>> CC: Amir Goldstein <amir73il@gmail.com>
>> CC: Vivek Goyal <vgoyal@redhat.com>
>> CC: Miklos Szeredi <miklos@szeredi.hu>
>> CC: linux-unionfs@vger.kernel.org
>> CC: linux-kernel@vger.kernel.org
>> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
>> ---
>>   Documentation/filesystems/overlayfs.rst |  6 ++++++
>>   fs/overlayfs/Kconfig                    | 17 +++++++++++++++++
>>   fs/overlayfs/copy_up.c                  |  3 ++-
>>   fs/overlayfs/namei.c                    |  5 ++++-
>>   fs/overlayfs/ovl_entry.h                |  1 +
>>   fs/overlayfs/super.c                    | 25 +++++++++++++++++++++++++
>>   6 files changed, 55 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
>> index 580ab9a0fe31..4f9cc20f255c 100644
>> --- a/Documentation/filesystems/overlayfs.rst
>> +++ b/Documentation/filesystems/overlayfs.rst
>> @@ -563,6 +563,12 @@ This verification may cause significant overhead in some cases.
>>   Note: the mount options index=off,nfs_export=on are conflicting for a
>>   read-write mount and will result in an error.
>>
>> +Note: the mount option uuid=off (or corresponding module param, or kernel
>> +config) can be used to replace UUID of the underlying filesystem in file
>> +handles with null, and effectively disable UUID checks. This can be useful in
>> +case the underlying disk is copied and the UUID of this copy is changed. This
>> +is only applicable if all lower/upper/work directories are on the same
>> +filesystem, otherwise it will fallback to normal behaviour.
>>
>>   Volatile mount
>>   --------------
>> diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
>> index dd188c7996b3..888c6e5e71ee 100644
>> --- a/fs/overlayfs/Kconfig
>> +++ b/fs/overlayfs/Kconfig
>> @@ -61,6 +61,23 @@ config OVERLAY_FS_INDEX
>>
>>            If unsure, say N.
>>
>> +config OVERLAY_FS_INDEX_UUID_OFF
> 
> Please get rid of all the double negatives.
> config/param uuid_off should be uuid and default to Y.
> Otherwise this looks fine to me.
> 
>> +       bool "Overlayfs: export null uuid in file handles"
>> +       depends on OVERLAY_FS
>> +       help
>> +         If this config option is enabled then overlay will replace uuid with
>> +         null in overlayfs file handles, effectively disabling uuid checks for
>> +         them. This affects overlayfs mounted with "index=on". This only can be
>> +         done if all upper and lower directories are on the same filesystem
>> +         where basic fhandles are uniq. In case the latter is not true
>> +         overlayfs would fallback to normal uuid checking mode.
>> +
>> +         It is needed to overcome possible change of uuid on superblock of the
>> +         backing filesystem, e.g. when you copied the virtual disk and mount
>> +         both the copy of the disk and the original one at the same time.
>> +
>> +         If unsure, say N.
>> +
>>   config OVERLAY_FS_NFS_EXPORT
>>          bool "Overlayfs: turn on NFS export feature by default"
>>          depends on OVERLAY_FS
>> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
>> index 3380039036d6..0b7e7a90a435 100644
>> --- a/fs/overlayfs/copy_up.c
>> +++ b/fs/overlayfs/copy_up.c
>> @@ -320,7 +320,8 @@ struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs, struct dentry *real,
>>          if (is_upper)
>>                  fh->fb.flags |= OVL_FH_FLAG_PATH_UPPER;
>>          fh->fb.len = sizeof(fh->fb) + buflen;
>> -       fh->fb.uuid = *uuid;
>> +       if (ofs->config.uuid)
>> +               fh->fb.uuid = *uuid;
>>
>>          return fh;
>>
>> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
>> index f058bf8e8b87..0262c39886d0 100644
>> --- a/fs/overlayfs/namei.c
>> +++ b/fs/overlayfs/namei.c
>> @@ -159,8 +159,11 @@ struct dentry *ovl_decode_real_fh(struct ovl_fs *ofs, struct ovl_fh *fh,
>>          /*
>>           * Make sure that the stored uuid matches the uuid of the lower
>>           * layer where file handle will be decoded.
>> +        * In case of index=nouuid option just make sure that stored
> 
> leftover index=nouuid
> 
> Thanks,
> Amir.
> 

-- 
Best regards, Tikhomirov Pavel
Software Developer, Virtuozzo.
