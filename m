Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E039FC433E0
	for <linux-unionfs@archiver.kernel.org>; Fri, 22 Jan 2021 06:00:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9995722D50
	for <linux-unionfs@archiver.kernel.org>; Fri, 22 Jan 2021 06:00:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbhAVGAj (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 22 Jan 2021 01:00:39 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:32577 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726248AbhAVGAg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 22 Jan 2021 01:00:36 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UMUmrC5_1611295184;
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0UMUmrC5_1611295184)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 22 Jan 2021 13:59:44 +0800
Subject: Re: [PATCH v4] ovl: fix dentry leak in ovl_get_redirect
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Liangyan <liangyan.peng@linux.alibaba.com>
References: <20201222030626.181165-1-liangyan.peng@linux.alibaba.com>
 <20201222032633.GS3579531@ZenIV.linux.org.uk>
From:   Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <c9ca7e00-acfa-3718-8e0d-fc3b9df28f69@linux.alibaba.com>
Date:   Fri, 22 Jan 2021 13:59:44 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20201222032633.GS3579531@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Miklos,

Any comments on this patch?

Thanks,
Joseph

On 12/22/20 11:26 AM, Al Viro wrote:
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
