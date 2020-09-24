Return-Path: <SRS0=188/=DB=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04628C4346E
	for <linux-unionfs@archiver.kernel.org>; Thu, 24 Sep 2020 07:40:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A37D23741
	for <linux-unionfs@archiver.kernel.org>; Thu, 24 Sep 2020 07:40:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="KI1teLAO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgIXHkW (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 03:40:22 -0400
Received: from mail-vi1eur05on2095.outbound.protection.outlook.com ([40.107.21.95]:47585
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726655AbgIXHkV (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 24 Sep 2020 03:40:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ESMbszK3UPM9WrFp29LMvuBajsOGX3xaqq5Ww+IWlF3iTWkWP63+7EZz10s8A2LRDEpkjr7otFfJtVc8/sQ7m4Y3HnWTCWdjsBoRppgh33zsM12ecldaGBlRW5pNSDCNl4IV49ycNTbhkwWT8HenP1RR78MtEJcZTwiFH9vaAxyku9JPSl/leMEBBpxa3KoJN2C8JQD9WjqI7yh37TRGT+6pVA9q0k5hicFqgJkTKBygx7ln4MODQbsVmWafcqpXHM3nyxSA70NaxfET3OD2G+MAazdzjzIiiBL4sHaEyKSmru5i6qZc7/jI497aivL7nK8atBBhXNaYkbfk5MeqGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F8ITny2QJnNQ3gEXK15kvwsUC/6DjiHrPCzRQw9Dmsk=;
 b=UTMoIQ2ePVCTt7nWJUYVfBr7xXOZrKI8KdYqRPcUafir7C/S/gLgj0jxOCwiv8me4MvLBgKs7/XK+qq/Se+1rmdqSLve1GgnXgLIL/VZo9ERvL4iGy3Y3L+qa+IIVCuRocKd/3SlJ+MQOymNBgjxHRrLEjg4nPkuVt4fwTCG03vuJhIlolgddu7qcJ3Ip1Er8zJpqF3zE8f2pULFQe4GMuFmz80RrQkZNeKfH/hKS+uciBQRoG6nt8rnFxnrMbdzLOjTrfvrcLnbZig70EfDnZgV62/2gyc8PYXrgx80AO43h4eK0vfb+hbBx3DWjjta+ogvYntKNQUirHvc/JYISQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F8ITny2QJnNQ3gEXK15kvwsUC/6DjiHrPCzRQw9Dmsk=;
 b=KI1teLAO7oW5FcSiimrNxF9h/gd3NFGrUddUZM+1HFRteCwYVkY1L1LlmCpLpnJuCzz83h6rv0P00RuONMD+qvjcz3FqlNue8Kro+RAJtj16UXv0wx9vII+2Rva1wq6hNz1j8BEM/6UbyJXyxxyo8GhLL6ctJdLHzT/1TbMieJo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=virtuozzo.com;
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com (2603:10a6:20b:cd::17)
 by AM6PR08MB3335.eurprd08.prod.outlook.com (2603:10a6:209:4c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Thu, 24 Sep
 2020 07:40:18 +0000
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::71e0:46d9:2c06:2322]) by AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::71e0:46d9:2c06:2322%7]) with mapi id 15.20.3391.027; Thu, 24 Sep 2020
 07:40:18 +0000
Subject: Re: [PATCH v2] ovl: introduce new "index=nouuid" option for inodes
 index feature
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20200923152308.3389-1-ptikhomirov@virtuozzo.com>
 <CAOQ4uxjxYjRkkB3tFqdZiOwj=2_+Ghzf5AvmptVLQM22K5DWfg@mail.gmail.com>
 <CAOQ4uxhjWsK1dfQu4K8uvRyGeGnFrM6opq32RxMOT4pWdqm+3A@mail.gmail.com>
From:   Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Message-ID: <1302ac46-f24c-bb49-9fac-6a3db748e57c@virtuozzo.com>
Date:   Thu, 24 Sep 2020 10:40:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
In-Reply-To: <CAOQ4uxhjWsK1dfQu4K8uvRyGeGnFrM6opq32RxMOT4pWdqm+3A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR04CA0114.eurprd04.prod.outlook.com
 (2603:10a6:208:55::19) To AM6PR08MB4756.eurprd08.prod.outlook.com
 (2603:10a6:20b:cd::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.41] (95.179.127.150) by AM0PR04CA0114.eurprd04.prod.outlook.com (2603:10a6:208:55::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Thu, 24 Sep 2020 07:40:17 +0000
X-Originating-IP: [95.179.127.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b019744-d731-43de-4b1f-08d8605d159e
X-MS-TrafficTypeDiagnostic: AM6PR08MB3335:
X-Microsoft-Antispam-PRVS: <AM6PR08MB3335F93C7E9344E8F48A8C49B7390@AM6PR08MB3335.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BKQumXwv5hjhVx/KDfSHziMcxDnhqtI+7I4DMp+En5iBf97+hpCERHxWiR8zEYjcRSfjjUDG77OU6duygRNB69t1GpoThzBO+T0fMfGRt5eeO2UuYjUPCvLWIetSMH0qDwQwwUxMSMBnRUlhSGPRdvNN6aHLj+J2nDZr3CEsCx2o0nNUrCRy7E7Y1OxvYEyG+EzmrCD9903yN07RklpzetIAB7u60a4BXWikXKJZhBAE6otyKyIAHacpH0k4GgEkUwK3py2foEwvTr181kezc+Q0Y48e39CdNqZlQzHAevL/iWhlPE7Tr0uWDDP0w1QdQTfryLNmf8OVFSLWSd2fTgyOL6Pf1a30o0Varx5u/UB9hct5EPJUzpaZCKqu1xNm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4756.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39840400004)(346002)(376002)(136003)(26005)(6486002)(316002)(86362001)(52116002)(16576012)(2906002)(4326008)(36756003)(478600001)(6916009)(31686004)(66556008)(5660300002)(16526019)(186003)(83380400001)(8676002)(54906003)(2616005)(956004)(66946007)(8936002)(53546011)(31696002)(66476007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: SNxXi6aswnuoTYrU3p8sTaGFttC0YuEiHzkB1ulDUGzV3VhPEGC2BHEkgQTTJv/9E9h+CNLRHNPnKFcH389VdPfabjLYr94ZM/vyVmZSWor08plceprYlRWqKHlEw42NTnuPSYww5hktBorSmHQsz1XMt/6kHO+DcEH1G6mGoGP2j/kmvNMAyRd4x1ROULWguBp6g+XrTdeFg+4sGL0zhiQ8QnzC707eo8LgVKhKF0zISIlrsB8A54eS9VeGfEfynYYaEjbow3RGAoJKQrdjg7KM59IEwaKM49h+3vZdGDJRrIhE/qm47WqdG96+TR1jAQJrpeYfO5Qpc3PRJTrWM5aEol35lfSRPktaDtDZt2OCLdN9U7izLYSkq65sV7/0GJNhBtKQ/4mwm83jf6Uz2hxQhZyRbM7ML3qR0gTv1ypKVJuwLEFE87GMIU1BJy0JAo8o3NlEK03TVj1TzMpzdPiga6/OCeEuFzxWj2mWccPr+aaeVkVJhm1cOhyzUglYeb+B1txMX5LYzbrAZLIvdg3s4WDroDTCnxsiRgineMeBnI+MDQDyx2py74LEyrwOgqYXpWnDJzpZ+Jx6vYgHVDFhZwDvzS09NhkYuUw+1ozPxv2aDRbAyaKkFviNoZExQMNEevdxcvPqKxJQRSIRoA==
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b019744-d731-43de-4b1f-08d8605d159e
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4756.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2020 07:40:18.6014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mOVUqjmi4QwiAaA6e0MGlixL6mRz0cERwUCAnCh/CCcua0L41OuGCRlrWo9zo71YWNHa/E72bqXIZDhLzRzopVw1VB5QLN58IdwGTeibras=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3335
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org



On 9/23/20 7:36 PM, Amir Goldstein wrote:
>>> @@ -414,7 +415,7 @@ static int ovl_check_origin(struct ovl_fs *ofs, struct dentry *upperdentry,
>>>    * Return 0 on match, -ESTALE on mismatch, < 0 on error.
>>>    */
>>>   static int ovl_verify_fh(struct dentry *dentry, const char *name,
>>> -                        const struct ovl_fh *fh)
>>> +                        const struct ovl_fh *fh, bool nouuid)
>>>   {
>>>          struct ovl_fh *ofh = ovl_get_fh(dentry, name);
>>>          int err = 0;
>>> @@ -425,8 +426,14 @@ static int ovl_verify_fh(struct dentry *dentry, const char *name,
>>>          if (IS_ERR(ofh))
>>>                  return PTR_ERR(ofh);
>>>
>>> -       if (fh->fb.len != ofh->fb.len || memcmp(&fh->fb, &ofh->fb, fh->fb.len))
>>> +       if (fh->fb.len != ofh->fb.len) {
>>>                  err = -ESTALE;
>>> +       } else {
>>> +               if (nouuid && !uuid_equal(&fh->fb.uuid, &ofh->fb.uuid))
>>> +                       ofh->fb.uuid = fh->fb.uuid;
>>> +               if (memcmp(&fh->fb, &ofh->fb, fh->fb.len))
>>> +                       err = -ESTALE;
>>> +       }
>>>
> 
> On second thought I am wondering if we should do that differently.
> If users want to work with index=nouuid, they need to work with it from day 1.
> index=nouuid should export null uuid in NFS handles and write null uuid
> in trusted.overlay.origin xattr.
> 
> So in ovl_encode_real_fh() you set null uuid and
> instead of relaxing uuid_equal() in ovl_decode_real_fh()
> you change it to uuid_is_null().
> 
> Do you have a problem with that for Virtuozzo use case?

Actually we've enabled index=on by default in kernel config in Virtuozzo 
only in the new update which is not yet released. So probably we can 
switch to index=nouuid with null uuid in fh.

> 
> Thanks,
> Amir.
> 

-- 
Best regards, Tikhomirov Pavel
Software Developer, Virtuozzo.
