Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CACD7C433E0
	for <linux-unionfs@archiver.kernel.org>; Mon, 21 Dec 2020 06:27:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6677420798
	for <linux-unionfs@archiver.kernel.org>; Mon, 21 Dec 2020 06:27:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbgLUG1s (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 21 Dec 2020 01:27:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727224AbgLUG1s (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 21 Dec 2020 01:27:48 -0500
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79BE6C0613D3;
        Sun, 20 Dec 2020 22:27:07 -0800 (PST)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1krEej-002pGJ-Ob; Mon, 21 Dec 2020 06:26:53 +0000
Date:   Mon, 21 Dec 2020 06:26:53 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Liangyan <liangyan.peng@linux.alibaba.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, joseph.qi@linux.alibaba.com
Subject: Re: [PATCH v2] ovl: fix  dentry leak in ovl_get_redirect
Message-ID: <20201221062653.GO3579531@ZenIV.linux.org.uk>
References: <20201220120927.115232-1-liangyan.peng@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201220120927.115232-1-liangyan.peng@linux.alibaba.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Dec 20, 2020 at 08:09:27PM +0800, Liangyan wrote:

> +++ b/fs/overlayfs/dir.c
> @@ -973,6 +973,7 @@ static char *ovl_get_redirect(struct dentry *dentry, bool abs_redirect)
>  	for (d = dget(dentry); !IS_ROOT(d);) {
>  		const char *name;
>  		int thislen;
> +		struct dentry *parent = NULL;
>  
>  		spin_lock(&d->d_lock);
>  		name = ovl_dentry_get_redirect(d);
> @@ -992,7 +993,22 @@ static char *ovl_get_redirect(struct dentry *dentry, bool abs_redirect)
>  
>  		buflen -= thislen;
>  		memcpy(&buf[buflen], name, thislen);
> -		tmp = dget_dlock(d->d_parent);
> +		parent = d->d_parent;
> +		if (unlikely(!spin_trylock(&parent->d_lock))) {
> +			rcu_read_lock();
> +			spin_unlock(&d->d_lock);
> +again:
> +			parent = READ_ONCE(d->d_parent);
> +			spin_lock(&parent->d_lock);
> +			if (unlikely(parent != d->d_parent)) {
> +				spin_unlock(&parent->d_lock);
> +				goto again;
> +			}
> +			rcu_read_unlock();
> +			spin_lock_nested(&d->d_lock, DENTRY_D_LOCK_NESTED);
> +		}
> +		tmp = dget_dlock(parent);
> +		spin_unlock(&parent->d_lock);
>  		spin_unlock(&d->d_lock);

Yecchhhh....  What's wrong with just doing
		spin_unlock(&d->d_lock);
		parent = dget_parent(d);
		dput(d);
		d = parent;
instead of that?
