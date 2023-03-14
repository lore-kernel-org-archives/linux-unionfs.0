Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9302C05027
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Mar 2023 17:31:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbjCNRbq (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Mar 2023 13:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbjCNRbo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Mar 2023 13:31:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAABEACB86;
        Tue, 14 Mar 2023 10:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hrjqNDyAxanW6Co1Z6mFKhPGQa8P4t5dCZ7joNbFdBE=; b=Uzb0eoUXwE1MCiBG8y/Yd2LmbS
        10U6878KSXCi+r53vZ/MsWmXAHA6cqZ58eA8y6i/1rL9ZD7ZXyz9/bHMKqT4nW1hSojmG/xUalFdb
        w1bqloAOrptDtSsWc0NpHL8CMYnM57qw82GtEs5b17l+VFh2dX2+SxC/VqGUJVxYgWMIzO32zkeNP
        xHdizoj+vjVm/wQvZrxsj7H5oManfqiqhsk0Jihs3lDf06GHisha6OiQ1mHPgb7db+trGTHUdmOkx
        K0m17FVRBtF40lPOemVEhLvT/bkmYKX8yjSCMyGenvCZQU+vOguUgcygyTVsFCRW/Nn0cVVR1RG+p
        /ANrQYyA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pc8Um-00B1OQ-1v;
        Tue, 14 Mar 2023 17:31:32 +0000
Date:   Tue, 14 Mar 2023 10:31:32 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     David Howells <dhowells@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Jeff Layton <jlayton@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Hillf Danton <hdanton@sina.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@lst.de>,
        John Hubbard <jhubbard@nvidia.com>,
        linux-unionfs@vger.kernel.org
Subject: Re: [PATCH v17 02/14] splice: Make do_splice_to() generic and export
 it
Message-ID: <ZBCvdKQskS46qyV3@infradead.org>
References: <20230308165251.2078898-1-dhowells@redhat.com>
 <20230308165251.2078898-3-dhowells@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308165251.2078898-3-dhowells@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

> -static long do_splice_to(struct file *in, loff_t *ppos,
> -			 struct pipe_inode_info *pipe, size_t len,
> -			 unsigned int flags)
> +long vfs_splice_read(struct file *in, loff_t *ppos,

The (pre-existing) long here is odd given that ->splice_read
returns a ssize_t.  This might be a good time to fix that up.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
