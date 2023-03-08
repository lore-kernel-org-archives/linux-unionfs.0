Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74089C64EC4
	for <linux-unionfs@archiver.kernel.org>; Wed,  8 Mar 2023 15:35:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbjCHPfa (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 10:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbjCHPfD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 8 Mar 2023 10:35:03 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5359CB074
        for <linux-unionfs@vger.kernel.org>; Wed,  8 Mar 2023 07:34:00 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id da10so67445255edb.3
        for <linux-unionfs@vger.kernel.org>; Wed, 08 Mar 2023 07:34:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1678289628;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FOdmNK9WOQhlHB8lGx17ROzXlswee6Xo6KzJiX35bEc=;
        b=IGbyZwzKWrnuucRDByz/T9XdybVORTyEUzEwmCw9V8AeXk4C/Vbt1Y9DvTo+PocdyV
         +ZglmnhJlRwQjA/yEvs2zTY7iaEoULmcBkV+DAWRRr7fxQYcxZn3ZnjPnJxGm2wQLGZ3
         SBE0Kx8A4/knCvNrWKZl4R6AwwC/zngJc0cDg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678289628;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FOdmNK9WOQhlHB8lGx17ROzXlswee6Xo6KzJiX35bEc=;
        b=rfD3u4exkjzlMEwai9CXKxMQ6yLh8IYXYTdzmYzbwKED9mc0ygHCKCJGHtbfO/bqgB
         q2cj5PX/DRrMT2mtAGUgioJoLFsFksuotzmDSoE+WJyGdFC30zKLYY7CrmAan6o1uqej
         eHlSs+xHmzatBGhAY75qcDg97nSPQ+mRnFZ4E+UJjqb/q0SPkLuKERrnA0BScTbnxURK
         /H/1gLthPU5Ys38jZOKAFT3Cx/wnZkrBqiPnTJBnWmjsNcz4t1tEc2Squw4l6DoqBmxr
         /m4QmIPWp/vWAfBQOGhAw4V+d2BA7vP7Ykm1hRoAgcb1UDlsA1p4GeeONCX1RP123QeP
         s5kQ==
X-Gm-Message-State: AO0yUKXXc7N2uoFv5hMWkjWaJkV82dsTOCyFCUl5CWDTByzLOQ7HtLBh
        iEM8QKDv1dKT4AxSeJa31krebDjn+vDYEP3vF9CoVA==
X-Google-Smtp-Source: AK7set8fCE+xVLpgwIvK6mlnHQtOhFn2Tstvgvpl6/ijsEsoNnESBLlosp3w1GqSEiDUZi7rq+daTFslIoRw8G0vaGE=
X-Received: by 2002:a50:d615:0:b0:4bc:7c78:4304 with SMTP id
 x21-20020a50d615000000b004bc7c784304mr10244649edi.8.1678289627857; Wed, 08
 Mar 2023 07:33:47 -0800 (PST)
MIME-Version: 1.0
References: <20230308143754.1976726-1-dhowells@redhat.com> <20230308143754.1976726-4-dhowells@redhat.com>
In-Reply-To: <20230308143754.1976726-4-dhowells@redhat.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 8 Mar 2023 16:33:37 +0100
Message-ID: <CAJfpeguGksS3sCigmRi9hJdUec8qtM9f+_9jC1rJhsXT+dV01w@mail.gmail.com>
Subject: Re: [PATCH v16 03/13] overlayfs: Implement splice-read
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, 8 Mar 2023 at 15:38, David Howells <dhowells@redhat.com> wrote:
>
> Implement splice-read for overlayfs by passing the request down a layer
> rather than going through generic_file_splice_read() which is going to be
> changed to assume that ->read_folio() is present on buffered files.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Christoph Hellwig <hch@lst.de>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Al Viro <viro@zeniv.linux.org.uk>
> cc: John Hubbard <jhubbard@nvidia.com>
> cc: David Hildenbrand <david@redhat.com>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: Miklos Szeredi <miklos@szeredi.hu>
> cc: linux-unionfs@vger.kernel.org
> cc: linux-block@vger.kernel.org
> cc: linux-fsdevel@vger.kernel.org
> cc: linux-mm@kvack.org
> ---
>
> Notes:
>     ver #15)
>      - Remove redundant FMODE_CAN_ODIRECT check on real file.
>      - Do rw_verify_area() on the real file, not the overlay file.
>      - Fix a file leak.
>
>  fs/overlayfs/file.c | 33 ++++++++++++++++++++++++++++++++-
>  1 file changed, 32 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 7c04f033aadd..a12919e9ccba 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -419,6 +419,37 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
>         return ret;
>  }
>
> +static ssize_t ovl_splice_read(struct file *in, loff_t *ppos,
> +                              struct pipe_inode_info *pipe, size_t len,
> +                              unsigned int flags)
> +{
> +       const struct cred *old_cred;
> +       struct fd real;
> +       ssize_t ret;
> +
> +       ret = ovl_real_fdget(in, &real);
> +       if (ret)
> +               return ret;
> +
> +       ret = -EINVAL;
> +       if (!real.file->f_op->splice_read)
> +               goto out_fdput;
> +
> +       ret = rw_verify_area(READ, real.file, ppos, len);
> +       if (unlikely(ret < 0))
> +               goto out_fdput;
> +
> +       old_cred = ovl_override_creds(file_inode(in)->i_sb);
> +       ret = real.file->f_op->splice_read(real.file, ppos, pipe, len, flags);

I don't think you replied to my suggestion of using a helper here.
E.g. it could be as simple as exporting do_splice_to(), or renaming it
to vfs_splice_read() to be more readable.  It would remove the
boilerplate and be more robust if any changes are done to the splice
reading code.

Thanks,
Miklos
