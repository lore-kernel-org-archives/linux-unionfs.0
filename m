Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADA53C2D0E4
	for <linux-unionfs@archiver.kernel.org>; Tue, 24 Nov 2020 11:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56462206F7
	for <linux-unionfs@archiver.kernel.org>; Tue, 24 Nov 2020 11:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732852AbgKXLuG (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 24 Nov 2020 06:50:06 -0500
Received: from verein.lst.de ([213.95.11.211]:54161 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728491AbgKXLuG (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 24 Nov 2020 06:50:06 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id EDB576736F; Tue, 24 Nov 2020 12:50:04 +0100 (CET)
Date:   Tue, 24 Nov 2020 12:50:04 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Dmitry Vyukov <dvyukov@google.com>,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
Subject: Re: [RFC PATCH] vfs: fs{set,get}attr iops
Message-ID: <20201124115004.GB22619@lst.de>
References: <20201123141207.GC327006@miu.piliscsaba.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201123141207.GC327006@miu.piliscsaba.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Looks pretty neat from a quick look, but you probably want to split
it into a patch or two adding the infrastructure and then one patch
per file system to ease review and bisection.
