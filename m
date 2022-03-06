Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6193DC433EF
	for <linux-unionfs@archiver.kernel.org>; Sun,  6 Mar 2022 04:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbiCFEhE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 5 Mar 2022 23:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiCFEhE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 5 Mar 2022 23:37:04 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49CE224BC4;
        Sat,  5 Mar 2022 20:36:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Y6IRrwM9XbIc9OImDeEJKAn2uhHKqiedoDrNGSRpu4g=; b=AQmadDiwfjVWyyySRxV//3KZkQ
        aeexEdj4JEOcM1yo4N01ZtuJZjeiXCI+Fu7Zhusm/7TAW9P1aJYk0pxa5axDFl4nn/J3FeC6PUrUl
        N8sncEvKispevm1wo87a51sQE2cJsFpitIHcgsPWcN+2AJkLqf51AJEjYSaE+R/b01eeVWYeFNPkc
        DNJK7pw49C8yrGasV2lIGCIyKVRv8Z2wDMCXZKRg2njCqG1PTggVp/a/2bYkQGuD+fX58FvN36ve7
        qFf0PwLnd0ZG3KvxgZWH0plfkNICc1nmffc1bUj/AciAx1GKmfKFENeGVZ0VhMoau0IRhs0WFYtCq
        bQtR54ZA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nQicl-00E6AT-2W; Sun, 06 Mar 2022 04:36:03 +0000
Date:   Sun, 6 Mar 2022 04:36:03 +0000
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
Message-ID: <YiQ6M/FsdHRV41DF@casper.infradead.org>
References: <20220306021534.83553-1-jarkko@kernel.org>
 <YiQjM7LdwoAWpC5L@casper.infradead.org>
 <YiQop71ABWm7hbMy@iki.fi>
 <YiQv7JEBPzgYUTTa@casper.infradead.org>
 <YiQ0aWhwY4BGLEMK@iki.fi>
 <YiQ2ThvkvnBBFRzD@casper.infradead.org>
 <YiQ30O/5LGh84z3t@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YiQ30O/5LGh84z3t@iki.fi>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Mar 06, 2022 at 06:25:52AM +0200, Jarkko Sakkinen wrote:
> > Are you deliberately avoiding the question?  I'm not asking about
> > implementation.  I'm asking about the semantics of MAP_POPULATE with
> > your driver.
> 
> No. I just noticed a bug in the guard from your comment that I wanted
> point out.
> 
> With the next version I post the corresponding change to the driver,
> in order to see this in context.

Oh, good grief.  Don't bother.  NAK.
