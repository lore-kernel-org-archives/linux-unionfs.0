Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68C2BC433E6
	for <linux-unionfs@archiver.kernel.org>; Mon, 21 Dec 2020 18:16:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F14723107
	for <linux-unionfs@archiver.kernel.org>; Mon, 21 Dec 2020 18:16:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbgLUSQa (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 21 Dec 2020 13:16:30 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:43374 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726666AbgLUSQa (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 21 Dec 2020 13:16:30 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R911e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=liangyan.peng@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UJNHBfZ_1608574546;
Received: from LiangyandeMacBook-Pro.local(mailfrom:liangyan.peng@linux.alibaba.com fp:SMTPD_---0UJNHBfZ_1608574546)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 22 Dec 2020 02:15:47 +0800
Subject: Re: [PATCH v2] ovl: fix dentry leak in ovl_get_redirect
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Joseph Qi <joseph.qi@linux.alibaba.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201220120927.115232-1-liangyan.peng@linux.alibaba.com>
 <20201221062653.GO3579531@ZenIV.linux.org.uk>
 <52a76e73-d46b-d0fd-a75a-76b4a86149b3@linux.alibaba.com>
 <20201221121148.GP3579531@ZenIV.linux.org.uk>
 <b7c5da61-6c17-fe19-957c-4c8b6d6e86fe@linux.alibaba.com>
 <20201221173538.GQ3579531@ZenIV.linux.org.uk>
From:   Liangyan <liangyan.peng@linux.alibaba.com>
Message-ID: <f3e1d7bc-b350-6fe6-7a26-7c65f7122023@linux.alibaba.com>
Date:   Tue, 22 Dec 2020 02:15:46 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201221173538.GQ3579531@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Exactly, i missed this definition of d_lock and treat it as a single 
member in dentry.
#define d_lock	d_lockref.lock

Thanks for the explanation. i will post a new patch as your suggestion.

Regards,
Liangyan

On 20/12/22 上午1:35, Al Viro wrote:
> On Tue, Dec 22, 2020 at 12:51:27AM +0800, Liangyan wrote:
>> This is the race scenario based on call trace we captured which cause the
>> dentry leak.
>>
>>
>>       CPU 0                                CPU 1
>> ovl_set_redirect                       lookup_fast
>>    ovl_get_redirect                       __d_lookup
>>      dget_dlock
>>        //no lock protection here            spin_lock(&dentry->d_lock)
>>        dentry->d_lockref.count++            dentry->d_lockref.count++
>>
>>
>> If we use dget_parent instead, we may have this race.
>>
>>
>>       CPU 0                                    CPU 1
>> ovl_set_redirect                           lookup_fast
>>    ovl_get_redirect                           __d_lookup
>>      dget_parent
>>        raw_seqcount_begin(&dentry->d_seq)      spin_lock(&dentry->d_lock)
>>        lockref_get_not_zero(&ret->d_lockref)   dentry->d_lockref.count++
> 
> And?
> 
> lockref_get_not_zero() will observe ->d_lock held and fall back to
> taking it.
> 
> The whole point of lockref is that counter and spinlock are next to each
> other.  Fastpath in lockref_get_not_zero is cmpxchg on both, and
> it is taken only if ->d_lock is *NOT* locked.  And the slow path
> there will do spin_lock() around the manipulations of ->count.
> 
> Note that ->d_lock is simply ->d_lockref.lock; ->d_seq has nothing
> to do with the whole thing.
> 
> The race in mainline is real; if you can observe anything of that
> sort with dget_parent(), we have much worse problem.  Consider
> dget() vs. lookup_fast() - no overlayfs weirdness in sight and the
> same kind of concurrent access.
> 
> Again, lockref primitives can be safely mixed with other threads
> doing operations on ->count while holding ->lock.
> 
