Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E628C433EF
	for <linux-unionfs@archiver.kernel.org>; Sun,  6 Mar 2022 03:52:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232590AbiCFDxN (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 5 Mar 2022 22:53:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbiCFDxN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 5 Mar 2022 22:53:13 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9ED349F12;
        Sat,  5 Mar 2022 19:52:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9sW6PT9UhN7TdCknrB4vEZzr80Evyo9BiN2TBCQrpu8=; b=mexz5CF+uqowjqVXolKHAmICBZ
        /gBgallofA7ozgz6jmmxeLDOiLP+ug6bK856a/z+a9w7TUyxkvWlRyWXibD8YaVX9xEhWkvXfvJ0c
        T9CsFtuhgdywtjyO5X9YgUt7T7PWomuTwyfHCOGFUDiGUHpzGsSie9GdiLq7+5D36BobFZ/yP2NUj
        qr1wqTzCzqTn0g1ebz0/mAsEBexkspvGujBr22b3rqg8CDfMkfi2+IvRyah//kltQsrveMxB400WD
        J0XLKsOaVBufmV3UVpDkBZF539qZ0MxKfcyCwprq0N/9p+ZQ6jqDwbiBbdFzFrSEzsOcI1kPbIRAL
        xGmlkpYw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nQhwK-00E56f-PJ; Sun, 06 Mar 2022 03:52:12 +0000
Date:   Sun, 6 Mar 2022 03:52:12 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Nathaniel McCallum <nathaniel@profian.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        linux-sgx@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, codalist@coda.cs.cmu.edu,
        linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH RFC] mm: Add f_ops->populate()
Message-ID: <YiQv7JEBPzgYUTTa@casper.infradead.org>
References: <20220306021534.83553-1-jarkko@kernel.org>
 <YiQjM7LdwoAWpC5L@casper.infradead.org>
 <YiQop71ABWm7hbMy@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YiQop71ABWm7hbMy@iki.fi>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Mar 06, 2022 at 05:21:11AM +0200, Jarkko Sakkinen wrote:
> On Sun, Mar 06, 2022 at 02:57:55AM +0000, Matthew Wilcox wrote:
> > On Sun, Mar 06, 2022 at 04:15:33AM +0200, Jarkko Sakkinen wrote:
> > > Sometimes you might want to use MAP_POPULATE to ask a device driver to
> > > initialize the device memory in some specific manner. SGX driver can use
> > > this to request more memory by issuing ENCLS[EAUG] x86 opcode for each
> > > page in the address range.
> > > 
> > > Add f_ops->populate() with the same parameters as f_ops->mmap() and make
> > > it conditionally called inside call_mmap(). Update call sites
> > > accodingly.
> > 
> > Your device driver has a ->mmap operation.  Why does it need another
> > one?  More explanation required here.
> 
> f_ops->mmap() would require an additional parameter, which results
> heavy refactoring.
> 
> struct file_operations has 1125 references in the kernel tree, so I
> decided to check this way around first. 

Are you saying that your device driver behaves differently if
MAP_POPULATE is set versus if it isn't?  That seems hideously broken.
