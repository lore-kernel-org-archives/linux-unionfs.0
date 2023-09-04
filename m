Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B072FC71153
	for <linux-unionfs@archiver.kernel.org>; Mon,  4 Sep 2023 15:03:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbjIDPDI (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 4 Sep 2023 11:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjIDPDI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 4 Sep 2023 11:03:08 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD4C1A5
        for <linux-unionfs@vger.kernel.org>; Mon,  4 Sep 2023 08:03:04 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-99c1d03e124so214138666b.2
        for <linux-unionfs@vger.kernel.org>; Mon, 04 Sep 2023 08:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1693839783; x=1694444583; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NAz9K1stn827xWJn7h3lTZ1VKMTzi/tuxr0gM2qCz5k=;
        b=gkBnFylGGAdlSJTC74GUkoK9QkVR4nwgy4Lw8Fq4E3fKI7wrhw6r31Cj+ROuryi4mn
         PCL/1V+tGUdvR95wmRdeuGefk7zA2Sa6BdRVLTereHB1p/LHagZ0Fa4KA0zRLvwxfbaB
         /waIV3w37GNP1Mg7C2/BpLjUS9j5iXmAKllKA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693839783; x=1694444583;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NAz9K1stn827xWJn7h3lTZ1VKMTzi/tuxr0gM2qCz5k=;
        b=YebvRr/mVGrKyX3rACCTPqV0OC9R0WFwlbsL9WzcDMfEIpW2EJ6F7/OPWvhVB6nIPt
         TZBfVFmRNmfECkPda1EBQpghFDHjCvZT1elde0aYA9v3JZg4yvFd7UFq5iQIOATX9TCr
         nXpevpNIu631BPoA+bBecq1n+n3cooS4f9Iy0iUojIJl27ut8aayJjjgyymrtQc7Xd4S
         jqOsZ5XedDAbF3Xedimnp+pzH/bkxBuSycxmWJhShM+tejiPO0uYOx0EwZ+iW/LuXkN/
         6QdvvnQ6W/6Q9jv5e4dwuR5AID8O0s+DcXruTOdK7Rq6rM/PkpQOxOQTYdEkSmpT2Oyf
         zU3g==
X-Gm-Message-State: AOJu0YxtgYsqplHKJ4FtohS7NqJupejYf0TNvNsJrQAIgopZDuflB7Gy
        XpAOco1gEOICQPn2ClNYGGGsQnhvA77+y/yVT19GoA==
X-Google-Smtp-Source: AGHT+IFxBH9pJ7r6Nc69goLEfRbrAqnTo69SZviQkZJtbMTIACdd9uySFNxN9/QA8pCWpHuB0DIXG9D8hEwUSCxwy4Q=
X-Received: by 2002:a17:907:270b:b0:9a1:b967:aca8 with SMTP id
 w11-20020a170907270b00b009a1b967aca8mr7013772ejk.4.1693839782678; Mon, 04 Sep
 2023 08:03:02 -0700 (PDT)
MIME-Version: 1.0
References: <20230904144718.2707411-1-amir73il@gmail.com>
In-Reply-To: <20230904144718.2707411-1-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 4 Sep 2023 17:02:51 +0200
Message-ID: <CAJfpegvP+_ERUU_LvB2b=N13C=vqczYmtTrbM=opjXKYmva4Vw@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix incorrect fdput() on aio completion
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     yangerkun <yangerkun@huawei.com>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, 4 Sept 2023 at 16:47, Amir Goldstein <amir73il@gmail.com> wrote:
>
> ovl_{read,write}_iter() always call fdput(real) to put one or zero
> refcounts of the real file, but for aio, whether it was submitted or not,
> ovl_aio_put() also calls fdput(), which is not balanced.  This is only a
> problem in the less common case when FDPUT_FPUT flag is set.
>
> To fix the problem use get_file() to take file refcount and use fput()
> instead of fdput() in ovl_aio_put().
>
> Fixes: 2406a307ac7d ("ovl: implement async IO routines")
> Cc: <stable@vger.kernel.org> # v5.6
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Miklos,
>
> This is the refcount leak fix that I found during work on backing_fs [1]
> that deserves to be fast tracked into stable.
>
> If it's ok with you, I will prepare a PR after rc1 including this
> fix and the symlink fileattr fix.

Looks good.

Thanks,
Miklos


>
> Thanks,
> Amir.
>
> [1] https://lore.kernel.org/r/CAOQ4uxgzYevVCaGBjjckOr1vv0gKvVPYiOAL6E_KQY-YQx_7hg@mail.gmail.com/
>
>  fs/overlayfs/file.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 3b4cc633d763..c743820e5c61 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -19,7 +19,6 @@ struct ovl_aio_req {
>         struct kiocb iocb;
>         refcount_t ref;
>         struct kiocb *orig_iocb;
> -       struct fd fd;
>  };
>
>  static struct kmem_cache *ovl_aio_request_cachep;
> @@ -280,7 +279,7 @@ static rwf_t ovl_iocb_to_rwf(int ifl)
>  static inline void ovl_aio_put(struct ovl_aio_req *aio_req)
>  {
>         if (refcount_dec_and_test(&aio_req->ref)) {
> -               fdput(aio_req->fd);
> +               fput(aio_req->iocb.ki_filp);
>                 kmem_cache_free(ovl_aio_request_cachep, aio_req);
>         }
>  }
> @@ -342,7 +341,7 @@ static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *iter)
>                 if (!aio_req)
>                         goto out;
>
> -               aio_req->fd = real;
> +               get_file(real.file);
>                 real.flags = 0;
>                 aio_req->orig_iocb = iocb;
>                 kiocb_clone(&aio_req->iocb, iocb, real.file);

It might be clearer to do the get_file() here:

+                 kiocb_clone(&aio_req->iocb, iocb, get_file(real.file));

Looks good otherwise.

Thanks,
Miklos
