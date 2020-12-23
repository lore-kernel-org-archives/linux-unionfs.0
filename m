Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E443AC433E0
	for <linux-unionfs@archiver.kernel.org>; Wed, 23 Dec 2020 06:20:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9560D224DF
	for <linux-unionfs@archiver.kernel.org>; Wed, 23 Dec 2020 06:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgLWGUb (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 23 Dec 2020 01:20:31 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:46978 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726069AbgLWGUb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 23 Dec 2020 01:20:31 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R511e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=liangyan.peng@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UJVvGLe_1608704385;
Received: from LiangyandeMacBook-Pro.local(mailfrom:liangyan.peng@linux.alibaba.com fp:SMTPD_---0UJVvGLe_1608704385)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 23 Dec 2020 14:19:46 +0800
Subject: Re: [PATCH v4] ovl: fix dentry leak in ovl_get_redirect
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        joseph.qi@linux.alibaba.com, stable@vger.kernel.org
References: <20201222030626.181165-1-liangyan.peng@linux.alibaba.com>
 <20201222032633.GS3579531@ZenIV.linux.org.uk>
From:   Liangyan <liangyan.peng@linux.alibaba.com>
Message-ID: <fb1dac63-34aa-b72f-e7f5-12703eba0578@linux.alibaba.com>
Date:   Wed, 23 Dec 2020 14:19:45 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201222032633.GS3579531@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Thanks Viro.

@Miklos, can you please advise?

On 20/12/22 上午11:26, Al Viro wrote:
> On Tue, Dec 22, 2020 at 11:06:26AM +0800, Liangyan wrote:
> 
>> Cc: <stable@vger.kernel.org>
>> Fixes: a6c606551141 ("ovl: redirect on rename-dir")
>> Signed-off-by: Liangyan <liangyan.peng@linux.alibaba.com>
>> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>> Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> Fine by me...  I can put it through vfs.git#fixes, but IMO
> that would be better off in overlayfs tree.
> 
