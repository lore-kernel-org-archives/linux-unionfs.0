Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB3C1C433EF
	for <linux-unionfs@archiver.kernel.org>; Mon, 24 Jan 2022 13:46:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbiAXNqy (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 24 Jan 2022 08:46:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:55421 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233895AbiAXNqx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 24 Jan 2022 08:46:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643032013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k7v/njzx2qq+aoh4uM8TKpt2Z50BNJK/hOa6V1S9Zzo=;
        b=AMpzCsr1LpJrmxIb/fiZxidTZc57iCTVEbI9COhcMz6tBuj2msX5lT1w5BDPkalq8D7hEh
        fuMniS04O9kLpUuCd2byvgc67sRDaaiALudUNnuF85IRr+Z309cZ7nT2k7lXFAwwIsrEvO
        ytVBc1+T5yeYBoQsoe/ue4j2E+6pPlE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-379-bpTXyaRSOcaWufQkHhtq3Q-1; Mon, 24 Jan 2022 08:46:50 -0500
X-MC-Unique: bpTXyaRSOcaWufQkHhtq3Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D1CC8519E2;
        Mon, 24 Jan 2022 13:46:49 +0000 (UTC)
Received: from horse.redhat.com (unknown [10.22.16.148])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 253D1108BEE6;
        Mon, 24 Jan 2022 13:46:35 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id ABF1E223E7A; Mon, 24 Jan 2022 08:36:42 -0500 (EST)
Date:   Mon, 24 Jan 2022 08:36:42 -0500
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Pei Zhang <pezhang@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org
Subject: Re: [PATCH] block: loop: set discard_granularity as PAGE_SIZE if
 sb->s_blocksize is 0
Message-ID: <Ye6rajfXFMwOBVtR@redhat.com>
References: <20220124100628.1327718-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124100628.1327718-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jan 24, 2022 at 06:06:28PM +0800, Ming Lei wrote:
> If backing file's filesystem has implemented ->fallocate(), we think the
> loop device can support discard, then pass sb->s_blocksize as
> discard_granularity. However, some underlying FS, such as overlayfs,
> doesn't set sb->s_blocksize, and causes discard_granularity to be set as
> zero, then the warning in __blkdev_issue_discard() is triggered.

[ Copying linux-unionfs and Miklos ]

Miklos mentioned that it might be ok to copy upper->s_blocksize into
ovl->s_blocksize in overlayfs as other anonymous filesystem set it to
some value (nfs, 9p, fuse, cifs) as well.

So it might be reasonable to fix overlayfs as well. But I think we need
a block layer fix as well to deal with any filesystem which supports
->fallocate() and does not advertize ->s_blocksize. Not advertizing
->s_blocksize will probably only lead to suboptimial performance and
nothing more.

> 
> Fix the issue by setting discard_granularity as PAGE_SIZE in this case
> since PAGE_SIZE is the most common data unit for FS.
> 
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Reported-by: Pei Zhang <pezhang@redhat.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> ---
>  drivers/block/loop.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index b1b05c45c07c..8c15bfab7e1a 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -776,6 +776,10 @@ static void loop_config_discard(struct loop_device *lo)
>  	} else {
>  		max_discard_sectors = UINT_MAX >> 9;
>  		granularity = inode->i_sb->s_blocksize;
> +
> +		/* Take PAGE_SIZE if the FS doesn't provide us one hint */
> +		if (!granularity)
> +			granularity = PAGE_SIZE;
>  	}
>  
>  	if (max_discard_sectors) {
> -- 
> 2.31.1
> 

