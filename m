Return-Path: <SRS0=dsgN=7S=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A051C433DF
	for <linux-unionfs@archiver.kernel.org>; Fri,  5 Jun 2020 08:41:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E01B20772
	for <linux-unionfs@archiver.kernel.org>; Fri,  5 Jun 2020 08:41:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="RyBWw6mX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgFEIlh (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 5 Jun 2020 04:41:37 -0400
Received: from mail-eopbgr130108.outbound.protection.outlook.com ([40.107.13.108]:53380
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726062AbgFEIlh (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 5 Jun 2020 04:41:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FIJJxViQjgAP/hyq73JGIlFhctedy4YsmYRvcJ0h48yKpyU5aX7ZXVCR+FeXTM5guMncIOq0WiwSb4pmDnW9th148rUigqeWlLkzZ53NTLKpElTTAAR4m+kdHUCdEGL274bAQYJD3r7YlSvxzGC1AwYcGZ0KdRPTcT7uM/dua9YB2rphzcxAxt0/SvFBCQf+0wA5n8dfYUONePD8gwtq+XSou6OqFHknE9sqB1HK2tUYZ4NxRDXndq385bEQcXMCi3qw3oRjdYMuK9jBYPZuc8sR2nNtM5OwPACWhq1hmb/IY2zF5hGVgXbAzgGbKQxm0EIHEQoQI5pjNcJFF4mFbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d1eMp6xmFijeA7f+J9K1NHtO6WkvZ/KOFBsj7vmqQNc=;
 b=JT5h0Iqz8L+tgcdiEo8V/j4FpqEtNhv7aKhJXKlMhQ7PpCfNuO+AsjIb8UyddU22T5+CCqZ7DJxainhR2S7iXTs5YJj0z+627uLGhN1FHEcHueFrIbTHhhpCllE8bx39Tea3BS4RwqcR+BUT53B+GPYXFnqCFkBY07a/xhvyopwmB0FWaTNU8wAOMaaUPHnKpu89Zp0ga6qLFvTaeWaCAHL+OYfaMKfTiVtmlrk5CVncgVVpDWFi5VtSNgkTDFbNaQEmR0ZyR+Y2E/kKCco64H4LS99hT0e9bjaxJh+uPqJbRJWbNwUoi4IWflbde7PF+uLDOF9LBErGwjK2JStSgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d1eMp6xmFijeA7f+J9K1NHtO6WkvZ/KOFBsj7vmqQNc=;
 b=RyBWw6mXRF3GNXsW8pX+YXBx0I72yqgUTyOP8DgUYsl30u28RtPmtoTHOoIBVPCl/QKF4Qlg2VXOVcH1J5q8B1ahM1jZ7/P/0sut3R2N8ey5DJ9iyQB9ZYDt2Ot8Wo+T6ueHfKh9t4JeLUr4AgwBgFZj2ydBB0gqGCf5OtQWcgM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=virtuozzo.com;
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com (2603:10a6:20b:cd::17)
 by AM6PR08MB5061.eurprd08.prod.outlook.com (2603:10a6:20b:d6::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.20; Fri, 5 Jun
 2020 08:41:32 +0000
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::1c7f:9e05:5b3a:96cc]) by AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::1c7f:9e05:5b3a:96cc%5]) with mapi id 15.20.3066.018; Fri, 5 Jun 2020
 08:41:32 +0000
Subject: Re: [PATCH 0/2] overlayfs: C/R enhancements
To:     Amir Goldstein <amir73il@gmail.com>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Andrey Vagin <avagin@virtuozzo.com>,
        Konstantin Khorenko <khorenko@virtuozzo.com>,
        Vasiliy Averin <vvs@virtuozzo.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20200604161133.20949-1-alexander.mikhalitsyn@virtuozzo.com>
 <CAOQ4uxhGswjxZjc3mN7K99pPrDgMV9_194U46b2MgszZnq1SDw@mail.gmail.com>
 <AM6PR08MB36394A00DC129791CC89296AE8890@AM6PR08MB3639.eurprd08.prod.outlook.com>
 <CAOQ4uxisdLt-0eT1R=V1ihagMoNfjiTrUdcdF2yDgD4O94Zjcw@mail.gmail.com>
From:   Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Message-ID: <fb79be2c-4fc8-5a9d-9b07-e0464fca9c3f@virtuozzo.com>
Date:   Fri, 5 Jun 2020 11:41:29 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <CAOQ4uxisdLt-0eT1R=V1ihagMoNfjiTrUdcdF2yDgD4O94Zjcw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR01CA0108.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::49) To AM6PR08MB4756.eurprd08.prod.outlook.com
 (2603:10a6:20b:cd::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.193] (81.200.16.181) by AM0PR01CA0108.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18 via Frontend Transport; Fri, 5 Jun 2020 08:41:31 +0000
X-Originating-IP: [81.200.16.181]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9606faf-79e5-4f69-b223-08d8092c3f4b
X-MS-TrafficTypeDiagnostic: AM6PR08MB5061:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR08MB5061FB2294FC76F9F416D20FB7860@AM6PR08MB5061.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0425A67DEF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GtMCkbBLGs/jFsVEq9YBvNe0N3ACmIK0cMtp9hncfIh2OdWHcDA1FaVk4CbfyUhBi9NxR2WTIIIzXYE4exGr37PgUlbggv9h/gwnhnYlgETSVP7JbL7YeTYHK/TgGTLgcptQdDR5rzNwcz1twDJbMNy6ZGL7EfAQgwmINg4snBnQbtsmVGBU/0LUyvKL+kQ1AHN2dKhPl4eSXp4wiakO5x7rrxzdzxhJe177jq/GGSCyh6Sknaqr/ngaiVABjlYKxvMX8Jg5nHFe5xxATv1gkpkimuUzSfqjBCTNZI1zl0OpGeI/9nxOt97cctRvKERhHM/sibJaiCm1kkDkM0EwwY+Q93KhA4TGna9CWeMcJCA5s2EgoZv62aItVtrs9W2W
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4756.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39840400004)(376002)(346002)(6636002)(478600001)(16526019)(66476007)(31686004)(186003)(83380400001)(52116002)(31696002)(26005)(66946007)(4326008)(66556008)(53546011)(86362001)(54906003)(6486002)(36756003)(5660300002)(110136005)(2616005)(8936002)(8676002)(16576012)(2906002)(956004)(316002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Gzgcw0PYMIRbFQGL1NMmEfdUipp0Yfk7aa+vjXy1SCNSX+d7X23S0GJFOz95asGmoAKhpmkHqxPNBPdupF/xPCjcWRnJ5GbfLq3eASkVZhAIfq7HD8Xy8xJLmxX3V5PIE57fx+lRktdaMhN4exbVvXJmxo0UIPpVZUBoFH6lIJxQOLhakyPtmIIZWFmO2IgnBFtCxIun5jTsUein6tARf/KAj3xlzFMctfFbzmPnUEoojhnnFJeCWsrEBjeHLRd2ld+wCz4pta45gdP6s8ar3iurft2lMxNMQU4zUNb1o8Qq6foe0yeqBJ8Kc5VrWPk+F06WyadRhbrVAJ1ATFO9uGaHxvRTwMC06dCqdftBl6mgkfK+w/87HDCayia1RH64RiHS2IuIuIap1m4MzNfOcSA/6rZhNgUDO7pVKBU8AGd4XHGC+URXHDMsPC2kVdjDES8Cy6ePceBQQl2Q94ECfZdwHqju7L1SNiMX38U2geA=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9606faf-79e5-4f69-b223-08d8092c3f4b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2020 08:41:32.0100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e+GxaH3sJlRDJHMAaNff4sznwpxGz46H3/7rww4JsbLGQc/BAmQQIf/527U2v9JV9qP74BftZ2hQV5+Q8a6Hv3X7T1NHT+MZaopJVFGM+y8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB5061
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org



On 6/5/20 5:35 AM, Amir Goldstein wrote:
> On Fri, Jun 5, 2020 at 12:34 AM Alexander Mikhalitsyn
> <alexander.mikhalitsyn@virtuozzo.com> wrote:
>>
>> Hello,
>>
>>> But overlayfs won't accept these "output only" options as input args,
>> which is a problem.
>>
>> Will it be problematic if we simply ignore "lowerdir_mnt_id" and "upperdir_mnt_id" options in ovl_parse_opt()?
>>
> 
> That would solve this small problem.

This is not a big problem actually as these options shown in mountinfo 
for overlay had been "output only" forever, please see these two 
examples below:

a) Imagine you've mounted overlay with relative paths and forgot (or you 
never known as you are another user) where your cwd was at the moment of 
mount syscall. - How would you use those options as "input" to create 
the same overlay mount somethere else (bind-mounting not involved)?

b) Imagine you've mounted overlay with absolute paths and someone (other 
user) overmounted lower (upper/workdir) paths for you, all directory 
structure would be the same on overmount but yet files are different. - 
How would you use those options from mountinfo as "input" ones?

We try to make them much closer to "input" ones.

Agreed, we should ignore *_mnt_id on mount because paths identify mounts 
at the time of mount call.

> 
>>> Wouldn't it be better for C/R to implement mount options
>> that overlayfs can parse and pass it mntid and fhandle instead
>> of paths? >>
>> Problem is that we need to know on C/R "dump stage" which mounts are used on lower layers and upper layer. Most likely I don't understand something but I can't catch how "mount-time" options will help us.
> 
> As you already know from inotify/fanotify C/R fhandle is timeless, so
> there would be no distinction between mount time and dump time.

Pair of fhandle+mnt_id looks an equivalent to path+mnt_id pair, CRIU 
will just need to open fhandle+mnt_id with open_by_handle_at and 
readlink to get path on dump and continue to use path+mnt_id as before. 
(not too common with fhandles but it's my current understanding)

But if you take a look on (a) and (b) again, the regular user does not 
see full information about overlay mount in /proc/pid/mountinfo, they 
can't just take a look on it and understand from there it comes from. 
Resolving fhandle looks like a too hard task for a user.

> About mnt_id, your patches will cause the original mount-time mounts to be busy.
> That is a problem as well.

Children mounts lock parent, open files lock parent. Another analogy is 
a loop device which locks the backing file mount (AFAICS). Anyway one 
can lazy umount, can't they? But I'm not too sure for this one, maybe 
you can share more implications of this problem?

> 
> I think you should describe the use case is more details.
> Is your goal to C/R any overlayfs mount that the process has open
> files on? visible to process
We wan't to dump a container, not a simple process, if the container 
process has access to some resource CRIU needs to restore this resource.

Imagine the process in container mounts it's own overlay inside 
container, for instance to imulate write access to readonly mount or 
just to implement some snapshots, don't know exact use case. And we want 
to checkpoint/restore this container. (Currently CRIU only supports 
overlay as external mount, e.g. for docker continers docker engine 
pre-creates overlay for us and we just bind from it - it's a different 
case.) If the in-container process creates the in-container mount we 
need to recreate it on restore so that the in-container view of the 
filesystem persists.

> For NFS export, we use the persistent descriptor {uuid;fhandle}
> (a.k.a. struct ovl_fh) to encode
> an underlying layer object.
> 
> CRIU can look for an existing mount to a filesystem with uuid as restore stage
> (or even mount this filesystem) and use open_by_handle_at() to open a
> path to layer.

On restore we can be on another physical node, so I doubt we have same 
uuid's, sorry I don't fully understand here already.

> After mounting overlay, that mount to underlying fs can even be discarded.
> 
> And if this works for you, you don't have to export the layers ovl_fh in
> /proc/mounts, you can export them in numerous other ways.
> One way from the top of my head, getxattr on overlay root dir.
> "trusted.overlay" xattr is anyway a reserved prefix, so "trusted.overlay.layers"
> for example could work.

Thanks xattr might be a good option, but still don't forget about (a) 
and (b), users like to know all information about mount from 
/proc/pid/mountinfo.

> 
> Thanks,
> Amir.
> 

-- 
Best regards, Tikhomirov Pavel
Software Developer, Virtuozzo.
