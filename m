Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C51AEC83F2C
	for <linux-unionfs@archiver.kernel.org>; Mon,  4 Sep 2023 15:09:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236296AbjIDPJP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 4 Sep 2023 11:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235331AbjIDPJP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 4 Sep 2023 11:09:15 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5A2BD
        for <linux-unionfs@vger.kernel.org>; Mon,  4 Sep 2023 08:09:11 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id 46e09a7af769-6bd3317144fso1361595a34.1
        for <linux-unionfs@vger.kernel.org>; Mon, 04 Sep 2023 08:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693840150; x=1694444950; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B8aXDqKxB3z9PsOFAHiQV01ufdENPCdMeiraEXTut4U=;
        b=B+sjVKyZ8elPz6yNYh+WOQhY985Vn4VysyKekOHjYuqf1pIELEK3Ykw0arDf8KamLS
         aH+M6sHVOuqoRZAjL3WhJXQDvxQAov3M6vgWCEbMbhm7F5slb4oFq7RxR76jkTZRd3Fy
         ktEIZkzrIG312zdQghLRnjYAg4Z0UjwJX05yKXiyBJVbAQvfRtEq1ypbao8en+7k1HqD
         ZSBr/6RkUpm9vtS1GR6GVjpRj6VHUsUAs5V0xEwsV5SU6gpuWQChuJSYY9H+6ZEQRhtl
         e3XEH8jvWoBTB/urdcaPxWe2GYj58U+Nhj8UK81h4cgNFy2L6kCwJY5k5UKlRTmYivFG
         RAoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693840150; x=1694444950;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B8aXDqKxB3z9PsOFAHiQV01ufdENPCdMeiraEXTut4U=;
        b=ZP/W3guZGbtIZt1wqVleUTwhksW/RG6L8Nx9FB1hfnEL17IYezCm97MHrbGQLiFNiW
         qFLZGmqc8hOnqlYi9iP2KTvGuuvdv1dNb5etafw3oxQZghYPbsTku6gTxfxXDv40jzmb
         peo74ipuM1ymKQ2QV71/vvujk3U8N3tCpj478HnEp7YYK4m91NeiyRIp5Hzl12y021sy
         M0o7JX1GHUw6HoIXFup88MKg3iWzSCTXX0aD+EJUdz/OVujK8vxREBVq+wXEZQa8tJZ6
         t26a35Rv7NW/6V+WIpJLwX9m6ACokwrRdB2XsFJ66z4acCfPlDBAcfBDSLg6ezx40D96
         iUcA==
X-Gm-Message-State: AOJu0YzZS5Lq8gxvZ3fwYSGOe0ZGd91PInoSjbAs9km/0e3duFmrOmpL
        x3rdVxjePtr6N1x6kqyDur1kEKOrN3VTxZC6inZh27DX
X-Google-Smtp-Source: AGHT+IE1tbShtJHl6VzDF4Fwi6FCkLvRLzWbMU3B+g2I9CzKCEIA+pnZAEyNF7oJ3+3XL9vQrMfnSSOAz2nrYJHGYL8=
X-Received: by 2002:a9d:7d10:0:b0:6bd:af4:274d with SMTP id
 v16-20020a9d7d10000000b006bd0af4274dmr11078492otn.8.1693840150703; Mon, 04
 Sep 2023 08:09:10 -0700 (PDT)
MIME-Version: 1.0
References: <20230904144718.2707411-1-amir73il@gmail.com> <CAJfpegvP+_ERUU_LvB2b=N13C=vqczYmtTrbM=opjXKYmva4Vw@mail.gmail.com>
In-Reply-To: <CAJfpegvP+_ERUU_LvB2b=N13C=vqczYmtTrbM=opjXKYmva4Vw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 4 Sep 2023 18:08:59 +0300
Message-ID: <CAOQ4uxiuZHhxBMupBPTmkf8rg3QQM7M=7EPg9XmNeGZOR9Eb=Q@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix incorrect fdput() on aio completion
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     yangerkun <yangerkun@huawei.com>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Sep 4, 2023 at 6:03=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> w=
rote:
>
> On Mon, 4 Sept 2023 at 16:47, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > ovl_{read,write}_iter() always call fdput(real) to put one or zero
> > refcounts of the real file, but for aio, whether it was submitted or no=
t,
> > ovl_aio_put() also calls fdput(), which is not balanced.  This is only =
a
> > problem in the less common case when FDPUT_FPUT flag is set.
> >
> > To fix the problem use get_file() to take file refcount and use fput()
> > instead of fdput() in ovl_aio_put().
> >
> > Fixes: 2406a307ac7d ("ovl: implement async IO routines")
> > Cc: <stable@vger.kernel.org> # v5.6
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >
> > Miklos,
> >
> > This is the refcount leak fix that I found during work on backing_fs [1=
]
> > that deserves to be fast tracked into stable.
> >
> > If it's ok with you, I will prepare a PR after rc1 including this
> > fix and the symlink fileattr fix.
>
> Looks good.
>
> Thanks,
> Miklos
>
>
> >
> > Thanks,
> > Amir.
> >
> > [1] https://lore.kernel.org/r/CAOQ4uxgzYevVCaGBjjckOr1vv0gKvVPYiOAL6E_K=
QY-YQx_7hg@mail.gmail.com/
> >
> >  fs/overlayfs/file.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> > index 3b4cc633d763..c743820e5c61 100644
> > --- a/fs/overlayfs/file.c
> > +++ b/fs/overlayfs/file.c
> > @@ -19,7 +19,6 @@ struct ovl_aio_req {
> >         struct kiocb iocb;
> >         refcount_t ref;
> >         struct kiocb *orig_iocb;
> > -       struct fd fd;
> >  };
> >
> >  static struct kmem_cache *ovl_aio_request_cachep;
> > @@ -280,7 +279,7 @@ static rwf_t ovl_iocb_to_rwf(int ifl)
> >  static inline void ovl_aio_put(struct ovl_aio_req *aio_req)
> >  {
> >         if (refcount_dec_and_test(&aio_req->ref)) {
> > -               fdput(aio_req->fd);
> > +               fput(aio_req->iocb.ki_filp);
> >                 kmem_cache_free(ovl_aio_request_cachep, aio_req);
> >         }
> >  }
> > @@ -342,7 +341,7 @@ static ssize_t ovl_read_iter(struct kiocb *iocb, st=
ruct iov_iter *iter)
> >                 if (!aio_req)
> >                         goto out;
> >
> > -               aio_req->fd =3D real;
> > +               get_file(real.file);
> >                 real.flags =3D 0;
> >                 aio_req->orig_iocb =3D iocb;
> >                 kiocb_clone(&aio_req->iocb, iocb, real.file);
>
> It might be clearer to do the get_file() here:
>
> +                 kiocb_clone(&aio_req->iocb, iocb, get_file(real.file));
>

Right. I will fix and stage.

> Looks good otherwise.
>

I will take it as Reviewed-by ;-)
and will do the same for symlink fileattr fix.

Thanks,
Amir.
