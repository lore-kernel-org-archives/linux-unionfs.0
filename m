Return-Path: <SRS0=voRt=7G=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 107A2C433E0
	for <linux-unionfs@archiver.kernel.org>; Sun, 24 May 2020 11:57:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1C02207FB
	for <linux-unionfs@archiver.kernel.org>; Sun, 24 May 2020 11:57:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgEXL5K (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 24 May 2020 07:57:10 -0400
Received: from verein.lst.de ([213.95.11.211]:36936 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726734AbgEXL5K (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 24 May 2020 07:57:10 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 576A468C4E; Sun, 24 May 2020 13:57:07 +0200 (CEST)
Date:   Sun, 24 May 2020 13:57:06 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
        jack@suse.cz, tytso@mit.edu, adilger@dilger.ca,
        riteshh@linux.ibm.com, amir73il@gmail.com,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
Subject: Re: fiemap cleanups v4
Message-ID: <20200524115706.GA1800@lst.de>
References: <20200523073016.2944131-1-hch@lst.de> <20200523155216.GZ23230@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200523155216.GZ23230@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, May 23, 2020 at 04:52:16PM +0100, Al Viro wrote:
> Hmmm...  I can do an immutable shared branch, no problem.  What would
> you prefer for a branchpoint for that one?

This needs pretty much latest Linus' tree as it sits on top of the bug
fixes merged this week.  But then again I'm not sure we even need
a shared tree, as there shouldn't be any conflicts.  But looking at
linux-next it seems Ted has actually pulled in the whole series, so
I think we actually are done.

But while I've got you attention:  Can you take a look at my
"clean up kernel_{read,write} & friends v2" series?
