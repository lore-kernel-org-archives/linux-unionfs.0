Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11E5CC433DB
	for <linux-unionfs@archiver.kernel.org>; Mon, 21 Dec 2020 11:15:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCFEF227BF
	for <linux-unionfs@archiver.kernel.org>; Mon, 21 Dec 2020 11:15:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgLULP2 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 21 Dec 2020 06:15:28 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:41503 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725807AbgLULP2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 21 Dec 2020 06:15:28 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UJIATZk_1608549284;
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0UJIATZk_1608549284)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 21 Dec 2020 19:14:44 +0800
Subject: Re: [PATCH v2] ovl: fix dentry leak in ovl_get_redirect
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Liangyan <liangyan.peng@linux.alibaba.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201220120927.115232-1-liangyan.peng@linux.alibaba.com>
 <20201221062653.GO3579531@ZenIV.linux.org.uk>
From:   Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <52a76e73-d46b-d0fd-a75a-76b4a86149b3@linux.alibaba.com>
Date:   Mon, 21 Dec 2020 19:14:44 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201221062653.GO3579531@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Viro,

On 12/21/20 2:26 PM, Al Viro wrote:
> On Sun, Dec 20, 2020 at 08:09:27PM +0800, Liangyan wrote:
> 
>> +++ b/fs/overlayfs/dir.c
>> @@ -973,6 +973,7 @@ static char *ovl_get_redirect(struct dentry *dentry, bool abs_redirect)
>>  	for (d = dget(dentry); !IS_ROOT(d);) {
>>  		const char *name;
>>  		int thislen;
>> +		struct dentry *parent = NULL;
>>  
>>  		spin_lock(&d->d_lock);
>>  		name = ovl_dentry_get_redirect(d);
>> @@ -992,7 +993,22 @@ static char *ovl_get_redirect(struct dentry *dentry, bool abs_redirect)
>>  
>>  		buflen -= thislen;
>>  		memcpy(&buf[buflen], name, thislen);
>> -		tmp = dget_dlock(d->d_parent);
>> +		parent = d->d_parent;
>> +		if (unlikely(!spin_trylock(&parent->d_lock))) {
>> +			rcu_read_lock();
>> +			spin_unlock(&d->d_lock);
>> +again:
>> +			parent = READ_ONCE(d->d_parent);
>> +			spin_lock(&parent->d_lock);
>> +			if (unlikely(parent != d->d_parent)) {
>> +				spin_unlock(&parent->d_lock);
>> +				goto again;
>> +			}
>> +			rcu_read_unlock();
>> +			spin_lock_nested(&d->d_lock, DENTRY_D_LOCK_NESTED);
>> +		}
>> +		tmp = dget_dlock(parent);
>> +		spin_unlock(&parent->d_lock);
>>  		spin_unlock(&d->d_lock);
> 
> Yecchhhh....  What's wrong with just doing
> 		spin_unlock(&d->d_lock);
> 		parent = dget_parent(d);
> 		dput(d);
> 		d = parent;
> instead of that?
> 

Now race happens on non-RCU path in lookup_fast(), I'm afraid d_seq can
not close the race window.

Thanks,
Joseph

