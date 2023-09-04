Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E42CC83F2C
	for <linux-unionfs@archiver.kernel.org>; Mon,  4 Sep 2023 15:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237826AbjIDPNC (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 4 Sep 2023 11:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjIDPNB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 4 Sep 2023 11:13:01 -0400
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA9F6CC3
        for <linux-unionfs@vger.kernel.org>; Mon,  4 Sep 2023 08:12:57 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R821e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VrMNdsz_1693840371;
Received: from 30.25.202.3(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0VrMNdsz_1693840371)
          by smtp.aliyun-inc.com;
          Mon, 04 Sep 2023 23:12:54 +0800
Message-ID: <bc9b3731-9eac-28be-e635-44a098e87d76@linux.alibaba.com>
Date:   Mon, 4 Sep 2023 23:12:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: [potential issue, question] whiteout shows up in merged directory
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Jingbo Xu <jefflexu@linux.alibaba.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Xiang Gao <xiang@kernel.org>,
        "zhangyi (F)" <yi.zhang@huawei.com>, kmxz <kxzkxz7139@gmail.com>
References: <a05e13c7-2fc2-77d8-05b5-759a73d7f5e2@linux.alibaba.com>
 <CAOQ4uxj_gM1BBCUE6p=TfVketOZohLPZs3fbw0BLacQFKEsuGg@mail.gmail.com>
 <9a89150e-cd84-c541-8088-41c2dfe863ac@linux.alibaba.com>
 <fe799167-249b-8fe2-a6c8-b222ac9acaf0@linux.alibaba.com>
 <CAOQ4uxgAoxgjQV2R0CJr-9UpyMTwdbGMYKb+qApco1YjBzE2HA@mail.gmail.com>
 <6a43ee5c-cc25-ff9f-1198-7c2b445d3775@linux.alibaba.com>
 <CAOQ4uxgiBNcD-vBi3OLF5Nc8gHYS-Hm1=yA4+At=nRUk18A9ng@mail.gmail.com>
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CAOQ4uxgiBNcD-vBi3OLF5Nc8gHYS-Hm1=yA4+At=nRUk18A9ng@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org



On 2023/9/4 23:03, Amir Goldstein wrote:
> On Mon, Sep 4, 2023 at 5:38 PM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:

..

>>>>
>>>
>>> Let me put it this way:
>>> If there was an official offline tool to merge overlayfs layers
>>> I would expect that tool to mark the offline merged directories
>>> with an empty "trusted.overlayfs.origin", to be able to distinguish
>>> them from pure non-merge directories.
>>>
>>> I do not consider dealing with this in erofs-utils side a workaround
>>> I consider it crafting layers in expected overlayfs format.
>>
>> Thanks for the hints.
>>
>> Ok, marking impure makes sense as long as it's properly described.
>>
>> Just tried to describe the background since the question I think
>> is not quite erofs-utils specific, btw, if there could be some
>> reference official offline tool, that would be great!
>>
> 
> There is this tool from kmxz that supports offline merge:
> https://github.com/kmxz/overlayfs-tools
> but it is not in any way "official".
> 
> I have contributed redirect and metacopy support in 2020
> and there hasn't been much traffic since.
> This tool does not deal with origin and impure xattrs.

Thanks, very useful link! will also check this later.

> 
> Thanks,
> Amir.
