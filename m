Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10216C636D7
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Feb 2023 15:50:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbjBOPuS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 15 Feb 2023 10:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbjBOPuR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 15 Feb 2023 10:50:17 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FBAE3669B
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Feb 2023 07:50:16 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id v13so22721930eda.11
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Feb 2023 07:50:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Gxx4XcKwvyNpOp3VEGiE+719FH+KggeO1TDcZH8XIXc=;
        b=fUwRQosoarROxeHu1csL4um6cmJozX9RvBTdZqgdbzyF8Barwc8bIYcCdoDTmo/GS3
         IrM2E/JJIeMfYbsTW+034l9vqtsfBsV6SKeI/tbgP1heCoXj5YxjirQn7a2KEY1Q5MRe
         3QmYbDaieDTABhmer07N0SUOHXk1nlNqWCtBw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gxx4XcKwvyNpOp3VEGiE+719FH+KggeO1TDcZH8XIXc=;
        b=Takkms3FHD9Ip+HaCIDf2A5WjysEndcDUMnFA9+bNl8kiSIup0LxRGWJ964ySI7hLN
         PIH8Kintk38uxrOCTkjziIytyRYXLjWAU9m/I20Kqmp7wXo5bi24/0HgFgey1cTSyijO
         OaGSfLIUHXzOdK7vsfc1RAqiU4iV2Mn6HcWDBNQQFSzLCQ1xhe5WDOBVNNAyHLJt2nHY
         m8c+sJJ8ircFrXHYSbIGsn+GZrN6b1VOs1WUxBqNCl7YVi8xF03WIrrWoH135akKbmJe
         IlI/uIxwgU9OP0c8wyhZgM8i/ekNrgfVCg+T0aoX8vFplqUie9IVAtfNJDwSz07iFxH7
         0YOg==
X-Gm-Message-State: AO0yUKWfJxCyWb0/xpM6TFXNU3ByxVCGfC6XAy7CtK/yQlFzm/09w2L/
        l6h7Px0Tv0mUih2sdlNkhP7tEsYVMlwOjrw1OgWAWw==
X-Google-Smtp-Source: AK7set/c1PSjKuHwb5HoUktp2BYZfMk+QVL6t/16rqfQYUzXFAPu8C+88H0jVH04WKFY9zcgUpkjnk6LsbMVdzmu3MI=
X-Received: by 2002:a50:99c1:0:b0:4aa:b30f:c784 with SMTP id
 n1-20020a5099c1000000b004aab30fc784mr1318317edb.8.1676476215115; Wed, 15 Feb
 2023 07:50:15 -0800 (PST)
MIME-Version: 1.0
References: <20230214171330.2722188-1-dhowells@redhat.com> <20230214171330.2722188-6-dhowells@redhat.com>
 <CAJfpegshWgUYZLc5v-Vwf6g3ZGmfnHsT_t9JLwxFoV8wPrvBnA@mail.gmail.com> <3370085.1676475658@warthog.procyon.org.uk>
In-Reply-To: <3370085.1676475658@warthog.procyon.org.uk>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 15 Feb 2023 16:50:04 +0100
Message-ID: <CAJfpegt5OurEve+TvzaXRVZSCv0in8_7whMYGsMDdDd2EjiBNQ@mail.gmail.com>
Subject: Re: [PATCH v15 05/17] overlayfs: Implement splice-read
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
        linux-mm@kvack.org, Christoph Hellwig <hch@lst.de>,
        John Hubbard <jhubbard@nvidia.com>,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, 15 Feb 2023 at 16:41, David Howells <dhowells@redhat.com> wrote:
>
> How about the attached then?
>
> David
> ---
> overlayfs: Implement splice-read
>
> Implement splice-read for overlayfs by passing the request down a layer
> rather than going through generic_file_splice_read() which is going to be
> changed to assume that ->read_folio() is present on buffered files.

Looks good.  One more suggestion: add a vfs_splice() helper and use
that from do_splice_to() as well.

Thanks,
Miklos
