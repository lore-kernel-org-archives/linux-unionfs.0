Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60DE6C433EF
	for <linux-unionfs@archiver.kernel.org>; Mon, 24 Jan 2022 15:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235386AbiAXPWZ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 24 Jan 2022 10:22:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:47962 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235204AbiAXPWZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 24 Jan 2022 10:22:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643037744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X3nzb8Kb2pOdd4W/ZCxjX+bJ2HvpTp4PXFlhCz6DEsY=;
        b=JKaBm9sW2SnqYTAjddAEmk48n28ZejHc0M8+ijxTJh6NqOqzLoY3+O8iwf7sj+3JLJUXxB
        B5D7FAWpYzQg2TGj+RzFmt1ZyQL7Z3hmS1O/+PhzPdvA1m5tBeQeV898T717LwMvDCHhJq
        LX5ieMN+1Ydqo7q4kA14dRDw4IqUGv4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-T8UMhOmDNu-5avCYif1azQ-1; Mon, 24 Jan 2022 10:22:23 -0500
X-MC-Unique: T8UMhOmDNu-5avCYif1azQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F071835B8F;
        Mon, 24 Jan 2022 15:22:22 +0000 (UTC)
Received: from horse.redhat.com (unknown [10.22.16.148])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD9FE798DB;
        Mon, 24 Jan 2022 15:22:01 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 5D8C8220370; Mon, 24 Jan 2022 10:22:01 -0500 (EST)
Date:   Mon, 24 Jan 2022 10:22:01 -0500
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, Pei Zhang <pezhang@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org
Subject: Re: [PATCH] block: loop: set discard_granularity as PAGE_SIZE if
 sb->s_blocksize is 0
Message-ID: <Ye7EGS2eYzhJX/e0@redhat.com>
References: <20220124100628.1327718-1-ming.lei@redhat.com>
 <Ye6yE2Ephyv+WBYY@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ye6yE2Ephyv+WBYY@infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jan 24, 2022 at 06:05:07AM -0800, Christoph Hellwig wrote:
> On Mon, Jan 24, 2022 at 06:06:28PM +0800, Ming Lei wrote:
> > If backing file's filesystem has implemented ->fallocate(), we think the
> > loop device can support discard, then pass sb->s_blocksize as
> > discard_granularity. However, some underlying FS, such as overlayfs,
> > doesn't set sb->s_blocksize, and causes discard_granularity to be set as
> > zero, then the warning in __blkdev_issue_discard() is triggered.
> > 
> > Fix the issue by setting discard_granularity as PAGE_SIZE in this case
> > since PAGE_SIZE is the most common data unit for FS.
> 
> sb->s_blocksize really does not mean anything.  kstat.blksize might
> be a better choice, even if it someimes errs on the too large side.

[ CC linux-unionfs, Miklos ]

This should work well for overlayfs too. I see it just passes the query
to underlying filesystem and that should report optimal I/O size.

On my overlayfs instance, I see.

# stat -c '%o' foo.txt
4096

Vivek

