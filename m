Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1AABC05027
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Feb 2023 13:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbjBNNGK (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Feb 2023 08:06:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbjBNNGK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Feb 2023 08:06:10 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5A92386A
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Feb 2023 05:06:02 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id rp23so39848975ejb.7
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Feb 2023 05:06:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UO1S8iW9/QAKVzEJhMRyzNECLihlHvjUObjxxMYI9O0=;
        b=EHFPpiUbwjhpMXxUIF7LhqG6rIpi+UqGSBGeWDQmMdq/H/4cSj5dy+pWLbjn+5Q2PE
         3Uu+8cgbrs8l1cedRkQIXA0oImCzK2Kua9ZjbNyB6hSMdCLJ6XuLOzwN/NXwmPLQ9Z/N
         VnyvAkJeiLtHgPm9ccQpnGJhDezr7ST2P6LuY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UO1S8iW9/QAKVzEJhMRyzNECLihlHvjUObjxxMYI9O0=;
        b=6cyMOgVl4w8INNkl5QZsvoSj3nwKoN4By5y2WihhXPuD3oUpWgQRzZYKHNAjQ775++
         V62c7XQ91cw8RaxuxTtYta503/BbXtTdRMJaeCfz/BLXeF48dmNHpuXU9SmELBneacPB
         c5IPkeAAUkff+CByDMpHUTs7QKD9APdUMe+SyW3PYNelfByujniXmhvPuWqF5DxDM+hl
         YmFsdFE79WcfpBNr1Q4kN2NZ27DBdpt3E71oEv4KmAFEghWc6LgxjzSPrXCbk9nuRHEO
         MyEYCxVXC8hkSNtOj4BtlfmFfHaLVYp8hsrUr8uQcsCi9L1aqNaKMZyIcU0Qz24UBVZv
         u63Q==
X-Gm-Message-State: AO0yUKVtFoQyGo78Xx+NLQtCiKwk6KzVtstW3ZRq/rjaqzrria52ASPY
        J3konWZ31iKWhkuOKm1R13ozHJXj2zhyXHgB+GTsgw==
X-Google-Smtp-Source: AK7set+I/XMXzZKvwt68Wb9MWG1DTRZ//RvsjWH1cHJPqXhfYhA6+T3VMQPi9934Peu7job2YIQNxIo0BpMeuOgtl80=
X-Received: by 2002:a17:907:1ddc:b0:878:790b:b7fd with SMTP id
 og28-20020a1709071ddc00b00878790bb7fdmr1259822ejc.14.1676379960856; Tue, 14
 Feb 2023 05:06:00 -0800 (PST)
MIME-Version: 1.0
References: <20230214083710.2547248-1-dhowells@redhat.com> <20230214083710.2547248-6-dhowells@redhat.com>
In-Reply-To: <20230214083710.2547248-6-dhowells@redhat.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 14 Feb 2023 14:05:49 +0100
Message-ID: <CAJfpegvjTL7X6KRZnFR6=reme63GiaACBZQ4RicvJ6B+-nLVKw@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] shmem, overlayfs, coda, tty, proc, kernfs, random:
 Fix splice-read
To:     David Howells <dhowells@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Jeff Layton <jlayton@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Hillf Danton <hdanton@sina.com>, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Daniel Golle <daniel@makrotopia.org>,
        Guenter Roeck <groeck7@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        John Hubbard <jhubbard@nvidia.com>,
        Hugh Dickins <hughd@google.com>,
        Jan Harkes <jaharkes@cs.cmu.edu>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        coda@cs.cmu.edu, codalist@coda.cs.cmu.edu,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 14 Feb 2023 at 09:38, David Howells <dhowells@redhat.com> wrote:
>
> The new filemap_splice_read() has an implicit expectation via
> filemap_get_pages() that ->read_folio() exists if ->readahead() doesn't
> fully populate the pagecache of the file it is reading from[1], potentially
> leading to a jump to NULL if this doesn't exist.
>
> A filesystem or driver shouldn't suffer from this if:
>
>   - It doesn't set ->splice_read()
>   - It implements ->read_folio()
>   - It implements its own ->splice_read()
>
> Note that some filesystems set generic_file_splice_read() and
> generic_file_read_iter() but don't set ->read_folio().  g_f_read_iter()
> will fall back to filemap_read_iter() which looks like it should suffer
> from the same issue.
>
> Certain drivers, can just use direct_splice_read() rather than
> generic_file_splice_read() as that creates an output buffer and then just
> calls their ->read_iter() function:
>
>   - random & urandom
>   - tty
>   - kernfs
>   - proc
>   - proc_namespace
>
> Stacked filesystems just need to pass the operation down a layer:
>
>   - coda
>   - overlayfs
>
> And finally, there's shmem (used in tmpfs, ramfs, rootfs).  This needs its
> own splice-read implementation, based on filemap_splice_read(), but able to
> paste in zero_page when there's a page missing.
>
> Fixes: d9722a475711 ("splice: Do splice read from a buffered file without using ITER_PIPE")

The fixed commit is not upstream.  In fact it seems to be on the same
branch as this one. Please reorder the patches so that a Fixes tag is
not needed.

Thanks,
Miklos
