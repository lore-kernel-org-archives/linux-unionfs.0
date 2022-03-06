Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6901C43217
	for <linux-unionfs@archiver.kernel.org>; Sun,  6 Mar 2022 03:22:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbiCFDWu (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 5 Mar 2022 22:22:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232536AbiCFDWq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 5 Mar 2022 22:22:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF263336E;
        Sat,  5 Mar 2022 19:21:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5933EB80CA3;
        Sun,  6 Mar 2022 03:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BDEFC340F3;
        Sun,  6 Mar 2022 03:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646536912;
        bh=REVJSPu0LMK0qtybGjVcYKrtnj1nArD7KxhlEeXpL5g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FLMwT+NpOuEP0vOHJMxtaQQCN/mZaYJMCmAdZvyES6nO1Jm9Au4J35+ADH3prFkmM
         ZsC2YEFVN7imDE5s5m8f6PyDIVn26Y6IqFvrL83GF/k/fzjXYe3wb03jR5BRTgcRrr
         GplpnIQyNciooTCOdLNEMZ4J6FdjftAAzxXYLvLg5JuVN5xalRzaVfVDXNYEjymA2u
         G39goguDmEepx6hgQ/mKOml4CV+xaHXfjnm/O86YxVDqFDzM3UK9bjFVdOxTUxUeu7
         yImes0TPKrEI4GAgeKyN+EY3e+9oLaGDV0HhAbva7R4LTpTZ+3MuNkaM5Do/Q61952
         YLB3lWUFpmNpQ==
Date:   Sun, 6 Mar 2022 05:21:11 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
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
Message-ID: <YiQop71ABWm7hbMy@iki.fi>
References: <20220306021534.83553-1-jarkko@kernel.org>
 <YiQjM7LdwoAWpC5L@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YiQjM7LdwoAWpC5L@casper.infradead.org>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Mar 06, 2022 at 02:57:55AM +0000, Matthew Wilcox wrote:
> On Sun, Mar 06, 2022 at 04:15:33AM +0200, Jarkko Sakkinen wrote:
> > Sometimes you might want to use MAP_POPULATE to ask a device driver to
> > initialize the device memory in some specific manner. SGX driver can use
> > this to request more memory by issuing ENCLS[EAUG] x86 opcode for each
> > page in the address range.
> > 
> > Add f_ops->populate() with the same parameters as f_ops->mmap() and make
> > it conditionally called inside call_mmap(). Update call sites
> > accodingly.
> 
> Your device driver has a ->mmap operation.  Why does it need another
> one?  More explanation required here.

f_ops->mmap() would require an additional parameter, which results
heavy refactoring.

struct file_operations has 1125 references in the kernel tree, so I
decided to check this way around first. 

BR, Jarkko
