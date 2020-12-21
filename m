Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB399C433E0
	for <linux-unionfs@archiver.kernel.org>; Mon, 21 Dec 2020 12:12:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E38D2253A
	for <linux-unionfs@archiver.kernel.org>; Mon, 21 Dec 2020 12:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726226AbgLUMMr (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 21 Dec 2020 07:12:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgLUMMq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 21 Dec 2020 07:12:46 -0500
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61CBCC0613D3;
        Mon, 21 Dec 2020 04:12:06 -0800 (PST)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1krK2W-002uPH-LQ; Mon, 21 Dec 2020 12:11:48 +0000
Date:   Mon, 21 Dec 2020 12:11:48 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Joseph Qi <joseph.qi@linux.alibaba.com>
Cc:     Liangyan <liangyan.peng@linux.alibaba.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ovl: fix dentry leak in ovl_get_redirect
Message-ID: <20201221121148.GP3579531@ZenIV.linux.org.uk>
References: <20201220120927.115232-1-liangyan.peng@linux.alibaba.com>
 <20201221062653.GO3579531@ZenIV.linux.org.uk>
 <52a76e73-d46b-d0fd-a75a-76b4a86149b3@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52a76e73-d46b-d0fd-a75a-76b4a86149b3@linux.alibaba.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Dec 21, 2020 at 07:14:44PM +0800, Joseph Qi wrote:
> Hi Viro,
> 
> On 12/21/20 2:26 PM, Al Viro wrote:
> > On Sun, Dec 20, 2020 at 08:09:27PM +0800, Liangyan wrote:
> > 
> >> +++ b/fs/overlayfs/dir.c
> >> @@ -973,6 +973,7 @@ static char *ovl_get_redirect(struct dentry *dentry, bool abs_redirect)
> >>  	for (d = dget(dentry); !IS_ROOT(d);) {
> >>  		const char *name;
> >>  		int thislen;
> >> +		struct dentry *parent = NULL;
> >>  
> >>  		spin_lock(&d->d_lock);
> >>  		name = ovl_dentry_get_redirect(d);
> >> @@ -992,7 +993,22 @@ static char *ovl_get_redirect(struct dentry *dentry, bool abs_redirect)
> >>  
> >>  		buflen -= thislen;
> >>  		memcpy(&buf[buflen], name, thislen);
> >> -		tmp = dget_dlock(d->d_parent);
> >> +		parent = d->d_parent;
> >> +		if (unlikely(!spin_trylock(&parent->d_lock))) {
> >> +			rcu_read_lock();
> >> +			spin_unlock(&d->d_lock);
> >> +again:
> >> +			parent = READ_ONCE(d->d_parent);
> >> +			spin_lock(&parent->d_lock);
> >> +			if (unlikely(parent != d->d_parent)) {
> >> +				spin_unlock(&parent->d_lock);
> >> +				goto again;
> >> +			}
> >> +			rcu_read_unlock();
> >> +			spin_lock_nested(&d->d_lock, DENTRY_D_LOCK_NESTED);
> >> +		}
> >> +		tmp = dget_dlock(parent);
> >> +		spin_unlock(&parent->d_lock);
> >>  		spin_unlock(&d->d_lock);
> > 
> > Yecchhhh....  What's wrong with just doing
> > 		spin_unlock(&d->d_lock);
> > 		parent = dget_parent(d);
> > 		dput(d);
> > 		d = parent;
> > instead of that?
> > 
> 
> Now race happens on non-RCU path in lookup_fast(), I'm afraid d_seq can
> not close the race window.

Explain, please.  What exactly are you observing?
