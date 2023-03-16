Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 509DCC6FD19
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Mar 2023 10:49:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbjCPKtH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 06:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbjCPKs3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Mar 2023 06:48:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419BEBDD2A;
        Thu, 16 Mar 2023 03:47:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21C6261FBC;
        Thu, 16 Mar 2023 10:47:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5EDC433D2;
        Thu, 16 Mar 2023 10:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678963669;
        bh=adDp088lfsRx00jTnzbgcWozbhk6SX4/HzArAfWHhL8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GHUYMytmwKFfch6AOme8SGcvXM0XGlwVDta3+wv17+MoBHhMIZMmmzFaV0kOah6Kw
         WI/SOSOBeeznqsCWoXSVOz4ylZFi6ylsikplsJ+6EmqLQAHFzYNwKBDa9nnFt+q1kd
         cA/N1dhpg0heFYO9eZWsjphZq2knApXmNn4r5mFM4uAWCpE71ZaXk+8525L5BDWLyB
         gTI8WgYYRFT6xGidQidZNEQ4g0HIaEcM/dqrzhYXddqRchl5p359TBnas7gyYaVIMP
         B65H5dPF11JZbxY23Y6LDugpZl3OxMaGq0rDZU8NZvLx2ylfx1S5kTaFiO2agx7rZ1
         j9rCZtThEheuA==
Date:   Thu, 16 Mar 2023 11:47:42 +0100
From:   Christian Brauner <brauner@kernel.org>
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
        Christoph Hellwig <hch@lst.de>,
        John Hubbard <jhubbard@nvidia.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org
Subject: Re: [PATCH v19 04/15] overlayfs: Implement splice-read
Message-ID: <20230316104742.hstef2opz2atctl6@wittgenstein>
References: <20230315163549.295454-1-dhowells@redhat.com>
 <20230315163549.295454-5-dhowells@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230315163549.295454-5-dhowells@redhat.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Mar 15, 2023 at 04:35:38PM +0000, David Howells wrote:
> Implement splice-read for overlayfs by passing the request down a layer
> rather than going through generic_file_splice_read() which is going to be
> changed to assume that ->read_folio() is present on buffered files.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Christoph Hellwig <hch@lst.de>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Al Viro <viro@zeniv.linux.org.uk>
> cc: John Hubbard <jhubbard@nvidia.com>
> cc: David Hildenbrand <david@redhat.com>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: Miklos Szeredi <miklos@szeredi.hu>
> cc: linux-unionfs@vger.kernel.org
> cc: linux-block@vger.kernel.org
> cc: linux-fsdevel@vger.kernel.org
> cc: linux-mm@kvack.org
> ---

Looks good,
Reviewed-by: Christian Brauner <brauner@kernel.org>
