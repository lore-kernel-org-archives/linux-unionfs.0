Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAACDC05027
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Feb 2023 14:01:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbjBNOBP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Feb 2023 09:01:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232529AbjBNOBN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Feb 2023 09:01:13 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D0425E0D;
        Tue, 14 Feb 2023 06:00:38 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pRvqg-0004pq-28;
        Tue, 14 Feb 2023 14:59:58 +0100
Date:   Tue, 14 Feb 2023 13:59:49 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     David Howells <dhowells@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Jeff Layton <jlayton@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Hillf Danton <hdanton@sina.com>, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Guenter Roeck <groeck7@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        John Hubbard <jhubbard@nvidia.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Hugh Dickins <hughd@google.com>,
        Jan Harkes <jaharkes@cs.cmu.edu>,
        Arnd Bergmann <arnd@arndb.de>, coda@cs.cmu.edu,
        codalist@coda.cs.cmu.edu, linux-unionfs@vger.kernel.org
Subject: Re: [PATCH v3 5/5] shmem, overlayfs, coda, tty, proc, kernfs,
 random: Fix splice-read
Message-ID: <Y+uT1SGEzjMrUbFI@makrotopia.org>
References: <20230214083710.2547248-1-dhowells@redhat.com>
 <20230214083710.2547248-6-dhowells@redhat.com>
 <Y+tMMAEiKUEDzZMa@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+tMMAEiKUEDzZMa@kroah.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Feb 14, 2023 at 09:54:08AM +0100, Greg Kroah-Hartman wrote:
> On Tue, Feb 14, 2023 at 08:37:10AM +0000, David Howells wrote:
> > The new filemap_splice_read() has an implicit expectation via
> > filemap_get_pages() that ->read_folio() exists if ->readahead() doesn't
> > fully populate the pagecache of the file it is reading from[1], potentially
> > leading to a jump to NULL if this doesn't exist.
> > 
> > A filesystem or driver shouldn't suffer from this if:
> > 
> >   - It doesn't set ->splice_read()
> >   - It implements ->read_folio()
> >   - It implements its own ->splice_read()
> > 
> > Note that some filesystems set generic_file_splice_read() and
> > generic_file_read_iter() but don't set ->read_folio().  g_f_read_iter()
> > will fall back to filemap_read_iter() which looks like it should suffer
> > from the same issue.
> > 
> > Certain drivers, can just use direct_splice_read() rather than
> > generic_file_splice_read() as that creates an output buffer and then just
> > calls their ->read_iter() function:
> > 
> >   - random & urandom
> >   - tty
> >   - kernfs
> >   - proc
> >   - proc_namespace
> > 
> > Stacked filesystems just need to pass the operation down a layer:
> > 
> >   - coda
> >   - overlayfs
> > 
> > And finally, there's shmem (used in tmpfs, ramfs, rootfs).  This needs its
> > own splice-read implementation, based on filemap_splice_read(), but able to
> > paste in zero_page when there's a page missing.
> > 
> > Fixes: d9722a475711 ("splice: Do splice read from a buffered file without using ITER_PIPE")
> > Signed-off-by: David Howells <dhowells@redhat.com>
> > cc: Daniel Golle <daniel@makrotopia.org>
> > cc: Guenter Roeck <groeck7@gmail.com>
> > cc: Christoph Hellwig <hch@lst.de>
> > cc: Jens Axboe <axboe@kernel.dk>
> > cc: Al Viro <viro@zeniv.linux.org.uk>
> > cc: John Hubbard <jhubbard@nvidia.com>
> > cc: David Hildenbrand <david@redhat.com>
> > cc: Matthew Wilcox <willy@infradead.org>
> > cc: Miklos Szeredi <miklos@szeredi.hu>
> > cc: Hugh Dickins <hughd@google.com>
> > cc: Jan Harkes <jaharkes@cs.cmu.edu>
> > cc: Arnd Bergmann <arnd@arndb.de>
> > cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > cc: coda@cs.cmu.edu
> > cc: codalist@coda.cs.cmu.edu
> > cc: linux-unionfs@vger.kernel.org
> > cc: linux-block@vger.kernel.org
> > cc: linux-fsdevel@vger.kernel.org
> > cc: linux-mm@kvack.org
> > Link: https://lore.kernel.org/r/Y+pdHFFTk1TTEBsO@makrotopia.org/ [1]
> > ---
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Confirming that the above indeed fixes the NULL pointer bug.

Tested-by: Daniel Golle <daniel@makrotopia.org>
