Return-Path: <SRS0=h8cR=6T=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B30FC47254
	for <linux-unionfs@archiver.kernel.org>; Tue,  5 May 2020 10:44:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2511120735
	for <linux-unionfs@archiver.kernel.org>; Tue,  5 May 2020 10:44:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbgEEKoR (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 5 May 2020 06:44:17 -0400
Received: from verein.lst.de ([213.95.11.211]:34604 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728233AbgEEKoR (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 5 May 2020 06:44:17 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4F60368C4E; Tue,  5 May 2020 12:44:14 +0200 (CEST)
Date:   Tue, 5 May 2020 12:44:14 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
        viro@zeniv.linux.org.uk, jack@suse.cz, tytso@mit.edu,
        adilger@dilger.ca, riteshh@linux.ibm.com, amir73il@gmail.com,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
Subject: Re: [PATCH 10/11] fs: remove the access_ok() check in ioctl_fiemap
Message-ID: <20200505104414.GD15815@lst.de>
References: <20200427181957.1606257-1-hch@lst.de> <20200427181957.1606257-11-hch@lst.de> <20200428152124.GL6741@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428152124.GL6741@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Apr 28, 2020 at 08:21:24AM -0700, Darrick J. Wong wrote:
> On Mon, Apr 27, 2020 at 08:19:56PM +0200, Christoph Hellwig wrote:
> > access_ok just checks we are fed a proper user pointer.  We also do that
> > in copy_to_user itself, so no need to do this early.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Hmm.  It's a minor behavioral change that we no longer require the
> entire extent array to be accessible at the start even if parts of it
> would never have gotten accessed, but I don't think that matters, so:

Note that access_ok only checks if the memory actually is in userspace,
so they only thing seeing a behavior difference would be an exploit of
some kind.
