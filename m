Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95BFCC61DA4
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Mar 2023 19:00:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbjCOTAB (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 15 Mar 2023 15:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbjCOS77 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 15 Mar 2023 14:59:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E711A8C589
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Mar 2023 11:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678906751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3pRuFXv24zO9iZj6MhHQgS7pRqlQAfg3F2hO5yqQOu0=;
        b=RuPdYPWyEtf+Dd6brSDoaHrf/5zsqig1q8rj0lr6x7LU2nSJ4qLxRtMQN3WRIBNZ4PFBWl
        61Jj3yRfUzR0552ZAJV6TqmSbjqs3t63lz/Uli7iNlm23nnEsT2MlAeXZpB4ORCS66hesa
        lMrxSZEXruXV/PWemm9yVueuAN9rs8w=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-408-kAOhDdORM1Gpq_v4qvB1FQ-1; Wed, 15 Mar 2023 14:59:08 -0400
X-MC-Unique: kAOhDdORM1Gpq_v4qvB1FQ-1
Received: by mail-wm1-f71.google.com with SMTP id o31-20020a05600c511f00b003ed2ed2acb5so1417108wms.0
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Mar 2023 11:59:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678906747;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3pRuFXv24zO9iZj6MhHQgS7pRqlQAfg3F2hO5yqQOu0=;
        b=ftWpjGmVGWN0eclhzNe7ghMoT9+W23DzlBGxCxXoFiQRBAsl9Jv0+zJR+BIVsX9POB
         6ofVzH4t03wNQ5RXXvRmmHbImg9yiwOFhSYIQLm0iBNS7QtDxjAw2epxxc+S94VYQBij
         Y/su1poLrVm0Y1ZamtBr25fU1RgwBDqKbum4pPlE3eQ3c+B97C2UBzQ3C2nWky8An/Zx
         lqzmhKIl3bCCpNXfgcybxsxWAOOTd7Tgnb6QIWiV9XlmIVn20ycGiARdhR895b2sBR0n
         +GDWxeD/1nN32piFzRLJ5Rr0AFRZuiqWTO2r4LcWSqb1f5uHPUmm9/yqt8cbIMem+1uN
         5dKQ==
X-Gm-Message-State: AO0yUKXfwMwZcdeikhfwCe5Zn+4qfjbic4CKM1y+ZEFOZC55bnOQV99B
        yfVaH43Tf6V+nqH7VLUOPtpaOY2Wtl/2wafYh/boAYr264rZtlmgL0SzXo+0rZ9gA9dO49rqm3I
        qQmP68PZwvDNPdGE5F1Q8cVkW8Q==
X-Received: by 2002:a5d:452b:0:b0:2cf:ec84:b63a with SMTP id j11-20020a5d452b000000b002cfec84b63amr2499466wra.43.1678906746989;
        Wed, 15 Mar 2023 11:59:06 -0700 (PDT)
X-Google-Smtp-Source: AK7set/id0A51e2uD6Xav4KlpzhQfvsr1WBJ6M12HWKP+dMN7x79MowOlKwVntfM4m25nbOzwjbzYQ==
X-Received: by 2002:a5d:452b:0:b0:2cf:ec84:b63a with SMTP id j11-20020a5d452b000000b002cfec84b63amr2499453wra.43.1678906746804;
        Wed, 15 Mar 2023 11:59:06 -0700 (PDT)
Received: from ?IPV6:2003:cb:c702:2f00:2038:213d:e59f:7d44? (p200300cbc7022f002038213de59f7d44.dip0.t-ipconnect.de. [2003:cb:c702:2f00:2038:213d:e59f:7d44])
        by smtp.gmail.com with ESMTPSA id b10-20020a5d45ca000000b002ca864b807csm5451460wrs.0.2023.03.15.11.59.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 11:59:06 -0700 (PDT)
Message-ID: <0064f021-ac21-8bbc-5156-90328da61b8f@redhat.com>
Date:   Wed, 15 Mar 2023 19:59:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v19 02/15] splice: Make do_splice_to() generic and export
 it
Content-Language: en-US
To:     David Howells <dhowells@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>
Cc:     Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Jeff Layton <jlayton@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Hillf Danton <hdanton@sina.com>,
        Christian Brauner <brauner@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Christoph Hellwig <hch@lst.de>,
        Miklos Szeredi <miklos@szeredi.hu>,
        John Hubbard <jhubbard@nvidia.com>,
        linux-unionfs@vger.kernel.org
References: <20230315163549.295454-1-dhowells@redhat.com>
 <20230315163549.295454-3-dhowells@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230315163549.295454-3-dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On 15.03.23 17:35, David Howells wrote:
> Rename do_splice_to() to vfs_splice_read() and export it so that it can be
> used as a helper when calling down to a lower layer filesystem as it
> performs all the necessary checks[1].
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> cc: Miklos Szeredi <miklos@szeredi.hu>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Al Viro <viro@zeniv.linux.org.uk>
> cc: John Hubbard <jhubbard@nvidia.com>
> cc: David Hildenbrand <david@redhat.com>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: linux-unionfs@vger.kernel.org
> cc: linux-block@vger.kernel.org
> cc: linux-fsdevel@vger.kernel.org
> cc: linux-mm@kvack.org
> Link: https://lore.kernel.org/r/CAJfpeguGksS3sCigmRi9hJdUec8qtM9f+_9jC1rJhsXT+dV01w@mail.gmail.com/ [1]
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

