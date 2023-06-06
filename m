Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F7B0C77B73
	for <linux-unionfs@archiver.kernel.org>; Tue,  6 Jun 2023 09:01:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236305AbjFFJBP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 05:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237384AbjFFJBN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Jun 2023 05:01:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D476FE40
        for <linux-unionfs@vger.kernel.org>; Tue,  6 Jun 2023 02:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686042029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lukpN6V3bZQwkW/hRkozUz4ZlKrQD2UWjx9TfhoM1xY=;
        b=Y1FqX1Ag1VuvTu1HjsEKcolEcvqjzntjxK6pzzl+PZIMfSH3wShAxf53OPCzm7FrlgjHvl
        4vRDbj9+0gJh8Gus5WfiloMKyogEE58fKqC8l1N8m+S6ql3PbkijqEJw4ZsljRZo2nKWKV
        PeiISOVuw5k7rSKnZtmxYB6yzn0PPns=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-JRIkDfArOyGzHLeE5P9-lQ-1; Tue, 06 Jun 2023 05:00:25 -0400
X-MC-Unique: JRIkDfArOyGzHLeE5P9-lQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6197F1C0A585;
        Tue,  6 Jun 2023 09:00:24 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A28D40CFD46;
        Tue,  6 Jun 2023 09:00:13 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <202306061226.7564fc39-oliver.sang@intel.com>
References: <202306061226.7564fc39-oliver.sang@intel.com>
To:     kernel test robot <oliver.sang@intel.com>
Cc:     dhowells@redhat.com, oe-lkp@lists.linux.dev, lkp@intel.com,
        Christian Brauner <brauner@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        John Hubbard <jhubbard@nvidia.com>,
        David Hildenbrand <david@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, ying.huang@intel.com,
        feng.tang@intel.com, fengwei.yin@intel.com
Subject: Re: [dhowells-fs:iov-old-dio] [overlayfs] 05b2c21a37: phoronix-test-suite.stress-ng.SENDFILE.bogo_ops_s 370.2% improvement
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1844120.1686042013.1@warthog.procyon.org.uk>
Date:   Tue, 06 Jun 2023 10:00:13 +0100
Message-ID: <1844121.1686042013@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

kernel test robot <oliver.sang@intel.com> wrote:

> commit: 
>   83e79d429d ("shmem: Implement splice-read")
>   05b2c21a37 ("overlayfs: Implement splice-read")

An improvement is certainly feasible, though a 3.7x improvement would be quite
a surprise.

shmem_file_splice_read() and filemap_splice_read() have a shorter call chain
than using ->read_iter() with ITER_PIPE.

overlayfs now delegates the splice directly to the lower filesystem.

David

