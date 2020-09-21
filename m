Return-Path: <SRS0=ehig=C6=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DFF2C43463
	for <linux-unionfs@archiver.kernel.org>; Mon, 21 Sep 2020 08:55:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4840A20739
	for <linux-unionfs@archiver.kernel.org>; Mon, 21 Sep 2020 08:55:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgIUIzb (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 21 Sep 2020 04:55:31 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:19173 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726324AbgIUIzb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 21 Sep 2020 04:55:31 -0400
X-IronPort-AV: E=Sophos;i="5.77,286,1596470400"; 
   d="scan'208";a="99460103"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 21 Sep 2020 16:55:20 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
        by cn.fujitsu.com (Postfix) with ESMTP id 3DE1148990F3;
        Mon, 21 Sep 2020 16:55:20 +0800 (CST)
Received: from [10.167.220.69] (10.167.220.69) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Mon, 21 Sep 2020 16:55:16 +0800
Message-ID: <5F686A74.4040002@cn.fujitsu.com>
Date:   Mon, 21 Sep 2020 16:55:16 +0800
From:   Xiao Yang <yangx.jy@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.2; zh-CN; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To:     Amir Goldstein <amir73il@gmail.com>
CC:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH] ovl: Support FS_IOC_[SG]ETFLAGS and FS_IOC_FS[SG]ETXATTR
 ioctls on directories
References: <20200921072127.373125-1-yangx.jy@cn.fujitsu.com> <CAOQ4uxitZDVjbvBnb95UHWD6CzaBeoJ8deqR6nbmgRRJ3P2=UA@mail.gmail.com>
In-Reply-To: <CAOQ4uxitZDVjbvBnb95UHWD6CzaBeoJ8deqR6nbmgRRJ3P2=UA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.220.69]
X-ClientProxiedBy: G08CNEXCHPEKD06.g08.fujitsu.local (10.167.33.205) To
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206)
X-yoursite-MailScanner-ID: 3DE1148990F3.A8D67
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: yangx.jy@cn.fujitsu.com
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On 2020/9/21 16:17, Amir Goldstein wrote:
> On Mon, Sep 21, 2020 at 10:41 AM Xiao Yang<yangx.jy@cn.fujitsu.com>  wrote:
>> Factor out ovl_ioctl() and ovl_compat_ioctl() and take use of them for
>> directories.
>>
>> Signed-off-by: Xiao Yang<yangx.jy@cn.fujitsu.com>
>> ---
> This change is buggy. I had already posted it and self NACKed myself [1].
>
> You can find an hopefully non-buggy version of it on my ovl-shutdown [2] branch.
>
> As long as you are changing ovl_ioctl(), please also take the second
> commit on that
> branch to replace the open coded capability check with the
> vfs_ioc_setflags_prepare()
> generic helper.
Hi Amir,

Thanks a lot for your quick reply. :-)
I will try to read and understand the metioned patches on your 
ovl-shutdown branch.

Best Regards,
Xiao Yang
> Thanks,
> Amir.
>
>
> [1] https://lore.kernel.org/linux-unionfs/CAOQ4uxhRgL2sMok7xsAZN6cZXSfoPxx=O8ADE=72+Ta3hGoLbw@mail.gmail.com/
> [2] https://github.com/amir73il/linux/commits/ovl-shutdown
>
>
> .
>



