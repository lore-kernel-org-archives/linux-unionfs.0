Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB745C636D4
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Feb 2023 16:40:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjBOQkS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 15 Feb 2023 11:40:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjBOQkR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 15 Feb 2023 11:40:17 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E653C22
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Feb 2023 08:40:16 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id fi26so23076966edb.7
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Feb 2023 08:40:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uRPFQs3djXckE7Oktaa+X2AruZRRb1EX46zdXuL2aNA=;
        b=O1Sb/PuAScpXjzzcEcRfdw765yckWsrlp60Zyj2Buh5pRD57qJFkPGXYlYGCSzbLKZ
         0OZJxcmxT4DRgg7vRAKUywcu+0OCNVsBpF50NrQuVlyfYQKR1YKZkGKhonllv6EdWSWj
         S4d4opyn+39fcS7g6apBLJVuIfqAPFopssH38=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uRPFQs3djXckE7Oktaa+X2AruZRRb1EX46zdXuL2aNA=;
        b=No7HH9QNsWsrZiO8inilIDmKOMqb+ii6vDohHhiXzGbGgLhuumD2mZw6+YrGhgwfJt
         zFYeZ8o7IF4m6VArrZ88f2rloLyj1TimrlIGkHbp1Z14MT2pmWfQxkPUJujME8fUKtGn
         tLT2pWYtV7qDcsJhjKzUhOPlskc4qiM7MjUMKdH/wNSy0fqc5M9FuXYahB1/yKTep+po
         7wP77aCozjAzSj9rLZPFaqsPaTGlJlDwie2ssGU1R844ZRdnDmMrIjD+06J2mc7z4xYt
         c3sMiQUGGFCypjj2i7WS1dy8he0CucwVdqIppNXAKE9/HYdPMY3ytqlasycc+WawRKag
         pPYQ==
X-Gm-Message-State: AO0yUKXLylOza9UT9qXF5DRvUZH8wnQUhtKoyebUwdEtBqI7k/+JsWxW
        SZv63fhr8HxXHQvaoIZV+ieItg+Q9PJRwcm4W10y2w==
X-Google-Smtp-Source: AK7set/iPBXeldwcN/CINqXYZtP94LHe3RbLgypUPLbVvQFOUAvYldPBfIvqSUN53v/EVz7QuOACKnzaFEzlWm2AvNQ=
X-Received: by 2002:a17:906:8604:b0:878:790b:b7fd with SMTP id
 o4-20020a170906860400b00878790bb7fdmr1331614ejx.14.1676479214862; Wed, 15 Feb
 2023 08:40:14 -0800 (PST)
MIME-Version: 1.0
References: <20230214171330.2722188-1-dhowells@redhat.com> <20230214171330.2722188-6-dhowells@redhat.com>
 <CAJfpegshWgUYZLc5v-Vwf6g3ZGmfnHsT_t9JLwxFoV8wPrvBnA@mail.gmail.com>
 <3370085.1676475658@warthog.procyon.org.uk> <CAJfpegt5OurEve+TvzaXRVZSCv0in8_7whMYGsMDdDd2EjiBNQ@mail.gmail.com>
 <Y+z/85HqpEceq66f@casper.infradead.org>
In-Reply-To: <Y+z/85HqpEceq66f@casper.infradead.org>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 15 Feb 2023 17:40:04 +0100
Message-ID: <CAJfpegsuDWqVYa2n2tmQP0EfkcWtRjxFwU1EbG0On-XfQ8ZhFg@mail.gmail.com>
Subject: Re: [PATCH v15 05/17] overlayfs: Implement splice-read
To:     Matthew Wilcox <willy@infradead.org>
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, 15 Feb 2023 at 16:53, Matthew Wilcox <willy@infradead.org> wrote:
>
> On Wed, Feb 15, 2023 at 04:50:04PM +0100, Miklos Szeredi wrote:
> > Looks good.  One more suggestion: add a vfs_splice() helper and use
> > that from do_splice_to() as well.
>
> I really hate call_read_iter() etc.  Please don't perpetuate that
> pattern.

I didn't suggest call_splice_read().  vfs_splice_read() would have the
rw_verify_area() as well as the check for non-null ->splice_read().

Doing it that way from the start would have prevented two of the bugs
that David introduced in the first version.

Thanks,
Miklos
