Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01D01C433E0
	for <linux-unionfs@archiver.kernel.org>; Mon, 21 Dec 2020 16:52:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCB1622525
	for <linux-unionfs@archiver.kernel.org>; Mon, 21 Dec 2020 16:52:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbgLUQwM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 21 Dec 2020 11:52:12 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:36830 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725780AbgLUQwM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 21 Dec 2020 11:52:12 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R381e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=liangyan.peng@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UJMguq4_1608569487;
Received: from LiangyandeMacBook-Pro.local(mailfrom:liangyan.peng@linux.alibaba.com fp:SMTPD_---0UJMguq4_1608569487)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 22 Dec 2020 00:51:28 +0800
Subject: Re: [PATCH v2] ovl: fix dentry leak in ovl_get_redirect
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201220120927.115232-1-liangyan.peng@linux.alibaba.com>
 <20201221062653.GO3579531@ZenIV.linux.org.uk>
 <52a76e73-d46b-d0fd-a75a-76b4a86149b3@linux.alibaba.com>
 <20201221121148.GP3579531@ZenIV.linux.org.uk>
From:   Liangyan <liangyan.peng@linux.alibaba.com>
Message-ID: <b7c5da61-6c17-fe19-957c-4c8b6d6e86fe@linux.alibaba.com>
Date:   Tue, 22 Dec 2020 00:51:27 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201221121148.GP3579531@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This is the race scenario based on call trace we captured which cause 
the dentry leak.


      CPU 0                                CPU 1
ovl_set_redirect                       lookup_fast
   ovl_get_redirect                       __d_lookup
     dget_dlock
       //no lock protection here            spin_lock(&dentry->d_lock)
       dentry->d_lockref.count++            dentry->d_lockref.count++


If we use dget_parent instead, we may have this race.


      CPU 0                                    CPU 1
ovl_set_redirect                           lookup_fast
   ovl_get_redirect                           __d_lookup
     dget_parent
       raw_seqcount_begin(&dentry->d_seq)      spin_lock(&dentry->d_lock)
       lockref_get_not_zero(&ret->d_lockref)   dentry->d_lockref.count++ 



On 20/12/21 下午8:11, Al Viro wrote:
> On Mon, Dec 21, 2020 at 07:14:44PM +0800, Joseph Qi wrote:
>> Hi Viro,
>>
>> On 12/21/20 2:26 PM, Al Viro wrote:
>>> On Sun, Dec 20, 2020 at 08:09:27PM +0800, Liangyan wrote:
>>>
>>>> +++ b/fs/overlayfs/dir.c
>>>> @@ -973,6 +973,7 @@ static char *ovl_get_redirect(struct dentry *dentry, bool abs_redirect)
>>>>   	for (d = dget(dentry); !IS_ROOT(d);) {
>>>>   		const char *name;
>>>>   		int thislen;
>>>> +		struct dentry *parent = NULL;
>>>>   
>>>>   		spin_lock(&d->d_lock);
>>>>   		name = ovl_dentry_get_redirect(d);
>>>> @@ -992,7 +993,22 @@ static char *ovl_get_redirect(struct dentry *dentry, bool abs_redirect)
>>>>   
>>>>   		buflen -= thislen;
>>>>   		memcpy(&buf[buflen], name, thislen);
>>>> -		tmp = dget_dlock(d->d_parent);
>>>> +		parent = d->d_parent;
>>>> +		if (unlikely(!spin_trylock(&parent->d_lock))) {
>>>> +			rcu_read_lock();
>>>> +			spin_unlock(&d->d_lock);
>>>> +again:
>>>> +			parent = READ_ONCE(d->d_parent);
>>>> +			spin_lock(&parent->d_lock);
>>>> +			if (unlikely(parent != d->d_parent)) {
>>>> +				spin_unlock(&parent->d_lock);
>>>> +				goto again;
>>>> +			}
>>>> +			rcu_read_unlock();
>>>> +			spin_lock_nested(&d->d_lock, DENTRY_D_LOCK_NESTED);
>>>> +		}
>>>> +		tmp = dget_dlock(parent);
>>>> +		spin_unlock(&parent->d_lock);
>>>>   		spin_unlock(&d->d_lock);
>>>
>>> Yecchhhh....  What's wrong with just doing
>>> 		spin_unlock(&d->d_lock);
>>> 		parent = dget_parent(d);
>>> 		dput(d);
>>> 		d = parent;
>>> instead of that?
>>>
>>
>> Now race happens on non-RCU path in lookup_fast(), I'm afraid d_seq can
>> not close the race window.
> 
> Explain, please.  What exactly are you observing?
> 
