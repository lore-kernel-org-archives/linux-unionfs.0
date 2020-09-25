Return-Path: <SRS0=6QjP=DC=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DAC3C4741F
	for <linux-unionfs@archiver.kernel.org>; Fri, 25 Sep 2020 15:12:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2651620878
	for <linux-unionfs@archiver.kernel.org>; Fri, 25 Sep 2020 15:12:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729219AbgIYPM3 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 25 Sep 2020 11:12:29 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:27540 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728333AbgIYPM2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 25 Sep 2020 11:12:28 -0400
X-IronPort-AV: E=Sophos;i="5.77,302,1596470400"; 
   d="scan'208";a="99619965"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 25 Sep 2020 23:12:16 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
        by cn.fujitsu.com (Postfix) with ESMTP id A62B648990CB;
        Fri, 25 Sep 2020 23:12:10 +0800 (CST)
Received: from [10.167.220.69] (10.167.220.69) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Fri, 25 Sep 2020 23:12:08 +0800
Message-ID: <5F6E08C8.8050305@cn.fujitsu.com>
Date:   Fri, 25 Sep 2020 23:12:08 +0800
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
References: <20200921072127.373125-1-yangx.jy@cn.fujitsu.com> <CAOQ4uxitZDVjbvBnb95UHWD6CzaBeoJ8deqR6nbmgRRJ3P2=UA@mail.gmail.com> <5F686A74.4040002@cn.fujitsu.com> <CAOQ4uxhfUbFhecA9ShKUxyjS=LsMoyztXwWUJw-ZXm+Z0eJ6DQ@mail.gmail.com> <5F69B2A4.2050407@cn.fujitsu.com> <CAOQ4uxg-4xOSVxkLZrH_zrd9054z+SH_+YdcPnT3PVNYogJ3gw@mail.gmail.com>
In-Reply-To: <CAOQ4uxg-4xOSVxkLZrH_zrd9054z+SH_+YdcPnT3PVNYogJ3gw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.167.220.69]
X-ClientProxiedBy: G08CNEXCHPEKD06.g08.fujitsu.local (10.167.33.205) To
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206)
X-yoursite-MailScanner-ID: A62B648990CB.A872C
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: yangx.jy@cn.fujitsu.com
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On 2020/9/22 20:01, Amir Goldstein wrote:
> On Tue, Sep 22, 2020 at 11:15 AM Xiao Yang<yangx.jy@cn.fujitsu.com>  wrote:
>> On 2020/9/21 17:09, Amir Goldstein wrote:
>>> On Mon, Sep 21, 2020 at 11:55 AM Xiao Yang<yangx.jy@cn.fujitsu.com>   wrote:
>>>> On 2020/9/21 16:17, Amir Goldstein wrote:
>>>>> On Mon, Sep 21, 2020 at 10:41 AM Xiao Yang<yangx.jy@cn.fujitsu.com>    wrote:
>>>>>> Factor out ovl_ioctl() and ovl_compat_ioctl() and take use of them for
>>>>>> directories.
>>>>>>
>>>>>> Signed-off-by: Xiao Yang<yangx.jy@cn.fujitsu.com>
>>>>>> ---
>>>>> This change is buggy. I had already posted it and self NACKed myself [1].
>>>>>
>>>>> You can find an hopefully non-buggy version of it on my ovl-shutdown [2] branch.
>>>>>
>>>>> As long as you are changing ovl_ioctl(), please also take the second
>>>>> commit on that
>>>>> branch to replace the open coded capability check with the
>>>>> vfs_ioc_setflags_prepare()
>>>>> generic helper.
>>>> Hi Amir,
>>>>
>>>> Thanks a lot for your quick reply. :-)
>>>> I will try to read and understand the metioned patches on your
>>>> ovl-shutdown branch.
>>> Please also verify my claim in the patch commit message, that the
>>> the test result of xfstest generic/079 changes from "notrun" to "success".
>> Hi Amir,
>>
>> With your patches, I have confirmed that generic/079 actually changed from
>> "notrun" to "success".  Besides, one minor issue:
>> Could we avoid the following compiler warning?
>> -------------------------------------------------
>> fs/overlayfs/readdir.c: In function ‘ovl_dir_real_file’:
>> fs/overlayfs/readdir.c:883:37: warning: passing argument 1 of
>> ‘ovl_dir_open_realfile’ discards ‘const’ qualifier from pointer target
>> type [-Wdiscarded-qualifiers]
>>     883 |    realfile = ovl_dir_open_realfile(file,&upperpath);
>>         |                                     ^~~~
>> fs/overlayfs/readdir.c:842:56: note: expected ‘struct file *’ but
>> argument is of type ‘const struct file *’
>>     842 | static struct file *ovl_dir_open_realfile(struct file *file,
>>         |                                           ~~~~~~~~~~~~~^~~~
>> -------------------------------------------------
>>
> Shouldn't be a problem to change ovl_dir_open_realfile()
> to take a const struct file * argument I think.
Hi Amir,

Other than the compiler warning I tested your patches on our
enviroment and didn't find any issue, so add:
Reviewed-by: Xiao Yang <yangx.jy@.cn.fujisu.com>

Thank you for sharing these patches again. :-)

Best Regards,
Xiao Yang
> Thanks,
> Amir.
>
>
> .
>



