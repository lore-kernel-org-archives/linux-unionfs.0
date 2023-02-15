Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64450C636D7
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Feb 2023 15:54:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjBOPx7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 15 Feb 2023 10:53:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjBOPxz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 15 Feb 2023 10:53:55 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCAD238B61;
        Wed, 15 Feb 2023 07:53:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rTc8CXcuV5cpdjC3iO0SGA6L8ZyQnZe5ss7R/+Fqmh8=; b=HNO8pH29scO5qLGRTFQ9MUd+oG
        Kwk1WNceb6YmZTaNOYA1oUb2COUwj52M3DhHT6dWzY+nC5Ozl4dhh8M8HYePc/s7CGdvwwwqAIMn/
        2dderB0nxXLQLMxSN2dokF0XHDGStNJ44fotckJ4s3c2hsQvWF2Buf2glU+v/TvHxEM1/jMclEx/k
        /sicLzkEGmgg9hJ6KzP8agem448nMFXJLleiiauXmTk82LnFnw0ea5/sQkaF1uLadnB4vGgPgkPyK
        nYU8Fmgei/Ei89UkQrKY0y7TYwfTyuWkObuxhUx+1PBSSl4w+ReAjduCB46UfFr8OqviYT7GcbpGI
        E0X8rqbg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pSK5z-007al5-U4; Wed, 15 Feb 2023 15:53:24 +0000
Date:   Wed, 15 Feb 2023 15:53:23 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     David Howells <dhowells@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Jeff Layton <jlayton@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Hillf Danton <hdanton@sina.com>, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Christoph Hellwig <hch@lst.de>,
        John Hubbard <jhubbard@nvidia.com>,
        linux-unionfs@vger.kernel.org
Subject: Re: [PATCH v15 05/17] overlayfs: Implement splice-read
Message-ID: <Y+z/85HqpEceq66f@casper.infradead.org>
References: <20230214171330.2722188-1-dhowells@redhat.com>
 <20230214171330.2722188-6-dhowells@redhat.com>
 <CAJfpegshWgUYZLc5v-Vwf6g3ZGmfnHsT_t9JLwxFoV8wPrvBnA@mail.gmail.com>
 <3370085.1676475658@warthog.procyon.org.uk>
 <CAJfpegt5OurEve+TvzaXRVZSCv0in8_7whMYGsMDdDd2EjiBNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegt5OurEve+TvzaXRVZSCv0in8_7whMYGsMDdDd2EjiBNQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Feb 15, 2023 at 04:50:04PM +0100, Miklos Szeredi wrote:
> Looks good.  One more suggestion: add a vfs_splice() helper and use
> that from do_splice_to() as well.

I really hate call_read_iter() etc.  Please don't perpetuate that
pattern.
