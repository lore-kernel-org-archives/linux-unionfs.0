Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB8A6C6FD1C
	for <linux-unionfs@archiver.kernel.org>; Mon, 13 Mar 2023 13:28:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbjCMN2q (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 13 Mar 2023 09:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbjCMN2g (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Mar 2023 09:28:36 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4C028237
        for <linux-unionfs@vger.kernel.org>; Mon, 13 Mar 2023 06:28:04 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id r5so13054056qtp.4
        for <linux-unionfs@vger.kernel.org>; Mon, 13 Mar 2023 06:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.cmu.edu; s=google-2021; t=1678714083;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wyfnm20ZcESTZZICXzvfZBrwNfquIlw/nie6VPg8U74=;
        b=X+al1sOiAsPAhBRCww81YtjFkVTVxccjSPzp1nBHd2IQgpRx3v9o+RE806ZA0PRYG4
         BgpU56JUTbexA5gywGNmboNInkeEkEG7hTe6o+aLWyEZ/VIpEWivtJAMvgPcKjYgQFWx
         DqzS4Xpu8XEvnlm9t1nxPZLmSqEeVa9bTxD/IkDVQwEOnSraLGGxTsXaV6wgbvBdHOAW
         0mI5d4V3ujTO65mnXfRAmoVVDsrSWu4ymG2i3c4YQH/vn6kmXHcL0RcGvATqNNT8kWUW
         MdGyqQaSUIdUa0Y2DIcos61471PGhU6rMB2A7wyfpzevEs+476dYhdUyhsCoUia11lzZ
         tZ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678714083;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wyfnm20ZcESTZZICXzvfZBrwNfquIlw/nie6VPg8U74=;
        b=FIy5MaHsFtfCr+6SgafJemQeLTwj5E1FSDWyVhP5V4ZoVTWFq6ao6LCbiR3kZ+AQuI
         qbaSj0clSiRsYYlgyEGsmUQgFL6rAy65XrrIcpgWVgbgrIIjFoHGD449ZCDDAoBoQpmg
         zRxH22GY7pxF4u5uvsx0bwnkAi7cUQMUYRIScZYP7JcAXmqaI5DQsf/OiPIWqpwqwN1G
         Z90AySg6gDxZtxmZmi+yVR0WFcAcAixnys8vSl3onO2UEU2nF/3u582Jn2cqcj8qqIpV
         nyJ9giwEqelmZhx6EkXThUsLn+reS505mjwOA4wuUGCGJ+4qOVgNptEyXS1bQpr7bziM
         /kaA==
X-Gm-Message-State: AO0yUKVr3DLCl8+MGZqnZ4Spi/cG5vrR5BGbrKOARnRd7C2tTwIVPEB0
        LscR2U+ird5tWbEmYTWHSW7S4A==
X-Google-Smtp-Source: AK7set9tuv7Xfd9Fa/zMlcJpqFBFMylrI/FwvAimLLz1Dc7kbKUinONv1rS/iHv0eiBgE5Mm0zynRA==
X-Received: by 2002:ac8:4e86:0:b0:3bf:c961:9309 with SMTP id 6-20020ac84e86000000b003bfc9619309mr55930056qtp.37.1678714083568;
        Mon, 13 Mar 2023 06:28:03 -0700 (PDT)
Received: from cs.cmu.edu (tunnel29655-pt.tunnel.tserv13.ash1.ipv6.he.net. [2001:470:7:582::2])
        by smtp.gmail.com with ESMTPSA id s138-20020a374590000000b007436d0e9408sm5296993qka.127.2023.03.13.06.28.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 06:28:03 -0700 (PDT)
Date:   Mon, 13 Mar 2023 09:28:00 -0400
From:   Jan Harkes <jaharkes@cs.cmu.edu>
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
        linux-unionfs@vger.kernel.org
Subject: Re: [PATCH v17 05/14] coda: Implement splice-read
Message-ID: <20230313132800.ebjr2zk4utln5i6r@cs.cmu.edu>
Mail-Followup-To: David Howells <dhowells@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
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
        Christoph Hellwig <hch@lst.de>, John Hubbard <jhubbard@nvidia.com>,
        linux-unionfs@vger.kernel.org
References: <20230308165251.2078898-1-dhowells@redhat.com>
 <20230308165251.2078898-6-dhowells@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308165251.2078898-6-dhowells@redhat.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

That actually looks better than the original code because this brings
in the experimental read intent hinting which allows userspace to
mediate access to partially cached files.

Jan


On Wed, Mar 08, 2023 at 11:53:19AM -0500, David Howells wrote:
> Implement splice-read for coda by passing the request down a layer rather
> than going through generic_file_splice_read() which is going to be changed
> to assume that ->read_folio() is present on buffered files.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Jan Harkes <jaharkes@cs.cmu.edu>

> cc: Jan Harkes <jaharkes@cs.cmu.edu>
> cc: Christoph Hellwig <hch@lst.de>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Al Viro <viro@zeniv.linux.org.uk>
> cc: John Hubbard <jhubbard@nvidia.com>
> cc: David Hildenbrand <david@redhat.com>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: coda@cs.cmu.edu
> cc: codalist@coda.cs.cmu.edu
> cc: linux-unionfs@vger.kernel.org
> cc: linux-block@vger.kernel.org
> cc: linux-fsdevel@vger.kernel.org
> cc: linux-mm@kvack.org
> ---
> 
> Notes:
>     ver #17)
>      - Use vfs_splice_read() helper rather than open-coding checks.
> 
>  fs/coda/file.c | 29 ++++++++++++++++++++++++++++-
>  1 file changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/coda/file.c b/fs/coda/file.c
> index 3f3c81e6b1ab..12b26bd13564 100644
> --- a/fs/coda/file.c
> +++ b/fs/coda/file.c
> @@ -23,6 +23,7 @@
>  #include <linux/slab.h>
>  #include <linux/uaccess.h>
>  #include <linux/uio.h>
> +#include <linux/splice.h>
>  
>  #include <linux/coda.h>
>  #include "coda_psdev.h"
> @@ -94,6 +95,32 @@ coda_file_write_iter(struct kiocb *iocb, struct iov_iter *to)
>  	return ret;
>  }
>  
> +static ssize_t
> +coda_file_splice_read(struct file *coda_file, loff_t *ppos,
> +		      struct pipe_inode_info *pipe,
> +		      size_t len, unsigned int flags)
> +{
> +	struct inode *coda_inode = file_inode(coda_file);
> +	struct coda_file_info *cfi = coda_ftoc(coda_file);
> +	struct file *in = cfi->cfi_container;
> +	loff_t ki_pos = *ppos;
> +	ssize_t ret;
> +
> +	ret = venus_access_intent(coda_inode->i_sb, coda_i2f(coda_inode),
> +				  &cfi->cfi_access_intent,
> +				  len, ki_pos, CODA_ACCESS_TYPE_READ);
> +	if (ret)
> +		goto finish_read;
> +
> +	ret = vfs_splice_read(in, ppos, pipe, len, flags);
> +
> +finish_read:
> +	venus_access_intent(coda_inode->i_sb, coda_i2f(coda_inode),
> +			    &cfi->cfi_access_intent,
> +			    len, ki_pos, CODA_ACCESS_TYPE_READ_FINISH);
> +	return ret;
> +}
> +
>  static void
>  coda_vm_open(struct vm_area_struct *vma)
>  {
> @@ -302,5 +329,5 @@ const struct file_operations coda_file_operations = {
>  	.open		= coda_open,
>  	.release	= coda_release,
>  	.fsync		= coda_fsync,
> -	.splice_read	= generic_file_splice_read,
> +	.splice_read	= coda_file_splice_read,
>  };
> 
> 
