Return-Path: <SRS0=xQay=6J=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FC17C55186
	for <linux-unionfs@archiver.kernel.org>; Sat, 25 Apr 2020 09:44:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16E9A2071C
	for <linux-unionfs@archiver.kernel.org>; Sat, 25 Apr 2020 09:44:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BEJTMa6q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgDYJn4 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 25 Apr 2020 05:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726046AbgDYJn4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 25 Apr 2020 05:43:56 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC03C09B04A;
        Sat, 25 Apr 2020 02:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3DlQ8ZnRScvyKzq/lpT+XdAwEdxgGA1reTTkPrNBrJQ=; b=BEJTMa6qlqlanHbw9YGhD4RCHg
        6xgFoTyFKTtwzhDhlHDcDo1wgwyHzBlPGsgSbV/OK5Q3USFRLANCGbYqs8cGYVvOTh5qCLKwpcgJx
        ooU80jPHqxo8oYBGCLKvyS1XjcPZwVnog7GJ7QG8+LdhoiCwqx0Ubt8R25pVZi98E6WxXJho3fD0M
        U696Zy/CsCyP2nMWlt6I3Bii6CHG60NFcTXvpaS8OgmcvRxJqGNdH+uTWeDm/jKaRtgSwLCaozZ//
        vPQNBfytELNn6LXvJlTUJ6CBiAHHubpi0QtirCTIweNIaDTf9UZg0xh1KECOvvDveygu5ziCNcjq3
        8RK9Yfeg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSHLi-0003RE-V8; Sat, 25 Apr 2020 09:43:50 +0000
Date:   Sat, 25 Apr 2020 02:43:50 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Ritesh Harjani <riteshh@linux.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Ext4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>,
        Andreas Dilger <adilger@dilger.ca>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Murphy Zhou <jencce.kernel@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH 0/5] ext4/overlayfs: fiemap related fixes
Message-ID: <20200425094350.GA11881@infradead.org>
References: <cover.1587555962.git.riteshh@linux.ibm.com>
 <20200424101153.GC456@infradead.org>
 <20200424232024.A39974C046@d06av22.portsmouth.uk.ibm.com>
 <CAOQ4uxgiome-BnHDvDC=vHfidf4Ru3jqzOki0Z_YUkinEeYCRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgiome-BnHDvDC=vHfidf4Ru3jqzOki0Z_YUkinEeYCRQ@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Apr 25, 2020 at 12:11:59PM +0300, Amir Goldstein wrote:
> FWIW, I agree with you.
> And seems like Jan does as well, since he ACKed all your patches.
> Current patches would be easier to backport to stable kernels.

Honestly, the proper fix is pretty much trivial.  I wrote it up this
morning over coffee:

    http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/fiemap-fix

Still needs more testing, though.
