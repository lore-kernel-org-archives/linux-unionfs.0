Return-Path: <SRS0=VDYA=5Z=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DFBFC2BA2B
	for <linux-unionfs@archiver.kernel.org>; Thu,  9 Apr 2020 13:26:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E08612072F
	for <linux-unionfs@archiver.kernel.org>; Thu,  9 Apr 2020 13:26:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgDIN0H (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 9 Apr 2020 09:26:07 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12708 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726632AbgDIN0H (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Apr 2020 09:26:07 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9B7509C9A900279B3AB8;
        Thu,  9 Apr 2020 21:25:33 +0800 (CST)
Received: from [127.0.0.1] (10.173.220.179) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Thu, 9 Apr 2020
 21:25:25 +0800
Subject: Re: [PATCH v2] ovl: sharing inode with different whiteout files
To:     Amir Goldstein <amir73il@gmail.com>,
        Chengguang Xu <cgxu519@mykernel.net>
CC:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Hou Tao <houtao1@huawei.com>
References: <20200403064444.31062-1-cgxu519@mykernel.net>
 <CAOQ4uxi8eMWRc6uuNt_R9nS9UjrOsqupcCEST4ub-kCwEpx=_Q@mail.gmail.com>
 <17153e5b537.c827c90942921.7568518513045332175@mykernel.net>
 <CAOQ4uxiHwQ4_rGLZeKS8VwP84YoUDZcju76KeYugt+SOAKVGKQ@mail.gmail.com>
 <17153f590e5.13f80af2342991.2831629093514707476@mykernel.net>
 <CAOQ4uxjhfOXaHMaXY+J67winJzFMDVfiHfF4m=yed7XNcPvFUw@mail.gmail.com>
 <171578e6477.12630feab161.147743050045149370@mykernel.net>
 <CAOQ4uxhU-KC2Yiewso_rDa3HhafzBaVWk9i8Sra4W0Y_EEiShA@mail.gmail.com>
 <1715deb04cf.11a7e625f2245.4913788754434070520@mykernel.net>
 <CAOQ4uxgQZf+RYsHAKY2=298nmRpBv5-YQDzuOqcXXOFumK058g@mail.gmail.com>
From:   "zhangyi (F)" <yi.zhang@huawei.com>
Message-ID: <54ff2e61-422a-224a-7474-972bd154d844@huawei.com>
Date:   Thu, 9 Apr 2020 21:25:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxgQZf+RYsHAKY2=298nmRpBv5-YQDzuOqcXXOFumK058g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.220.179]
X-CFilter-Loop: Reflected
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi, Amir

On 2020/4/9 19:21, Amir Goldstein wrote:
[...]
> 
> Thanks for taking the time to report all those failures.
> You must be one of few developers to actually use fsck.overlayfs...
> 
> You need this fix for fsck.overlayfs:
> https://github.com/hisilicon/overlayfs-progs/pull/1
> 
> Sorry, I forgot I was carrying this patch on my setup.
> 
> Zhangyi,
> 
> Any chance of merging my fix?
> 

Thanks for the patch, I think we'd better to remove the FS_LAYER_XATTR flag
for a nested overlayfs layer, so we could skip checking OVL_XATTR_PREFIX
xattrs when scanning the layer. Something like this,

+	/* A nested overlayfs does not support OVL_XATTR_PREFIX xattr */
+	if (statfs.f_type == OVERLAYFS_SUPER_MAGIC)
+		return 0;

I will modify this and merge your patch.

Thanks,
Yi.

