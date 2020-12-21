Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4A39C433E6
	for <linux-unionfs@archiver.kernel.org>; Mon, 21 Dec 2020 18:03:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E2A422D49
	for <linux-unionfs@archiver.kernel.org>; Mon, 21 Dec 2020 18:03:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgLUSDZ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 21 Dec 2020 13:03:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbgLUSDZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 21 Dec 2020 13:03:25 -0500
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A424C061282;
        Mon, 21 Dec 2020 10:02:44 -0800 (PST)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1krP5u-002yze-88; Mon, 21 Dec 2020 17:35:38 +0000
Date:   Mon, 21 Dec 2020 17:35:38 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Liangyan <liangyan.peng@linux.alibaba.com>
Cc:     Joseph Qi <joseph.qi@linux.alibaba.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ovl: fix dentry leak in ovl_get_redirect
Message-ID: <20201221173538.GQ3579531@ZenIV.linux.org.uk>
References: <20201220120927.115232-1-liangyan.peng@linux.alibaba.com>
 <20201221062653.GO3579531@ZenIV.linux.org.uk>
 <52a76e73-d46b-d0fd-a75a-76b4a86149b3@linux.alibaba.com>
 <20201221121148.GP3579531@ZenIV.linux.org.uk>
 <b7c5da61-6c17-fe19-957c-4c8b6d6e86fe@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7c5da61-6c17-fe19-957c-4c8b6d6e86fe@linux.alibaba.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Dec 22, 2020 at 12:51:27AM +0800, Liangyan wrote:
> This is the race scenario based on call trace we captured which cause the
> dentry leak.
> 
> 
>      CPU 0                                CPU 1
> ovl_set_redirect                       lookup_fast
>   ovl_get_redirect                       __d_lookup
>     dget_dlock
>       //no lock protection here            spin_lock(&dentry->d_lock)
>       dentry->d_lockref.count++            dentry->d_lockref.count++
> 
> 
> If we use dget_parent instead, we may have this race.
> 
> 
>      CPU 0                                    CPU 1
> ovl_set_redirect                           lookup_fast
>   ovl_get_redirect                           __d_lookup
>     dget_parent
>       raw_seqcount_begin(&dentry->d_seq)      spin_lock(&dentry->d_lock)
>       lockref_get_not_zero(&ret->d_lockref)   dentry->d_lockref.count++

And?

lockref_get_not_zero() will observe ->d_lock held and fall back to
taking it.

The whole point of lockref is that counter and spinlock are next to each
other.  Fastpath in lockref_get_not_zero is cmpxchg on both, and
it is taken only if ->d_lock is *NOT* locked.  And the slow path
there will do spin_lock() around the manipulations of ->count.

Note that ->d_lock is simply ->d_lockref.lock; ->d_seq has nothing
to do with the whole thing.

The race in mainline is real; if you can observe anything of that
sort with dget_parent(), we have much worse problem.  Consider
dget() vs. lookup_fast() - no overlayfs weirdness in sight and the
same kind of concurrent access.

Again, lockref primitives can be safely mixed with other threads
doing operations on ->count while holding ->lock.
