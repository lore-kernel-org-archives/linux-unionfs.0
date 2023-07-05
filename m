Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00CC5EB64DA
	for <linux-unionfs@archiver.kernel.org>; Wed,  5 Jul 2023 09:10:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbjGEJKF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 5 Jul 2023 05:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbjGEJKE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 5 Jul 2023 05:10:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 991581706
        for <linux-unionfs@vger.kernel.org>; Wed,  5 Jul 2023 02:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688548165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eiFA7P4RMGjmdgMoHl/w6ySnit/pa7gC/N0C4ZnDvgU=;
        b=CaRJ2LGfkiW7v5cUGRt5YMUrBFbO5I03Zd2LfB3Uv9MBgtEQqCA42jd2kfikcPst5rhL+Q
        lVKAUCleI2437fwB0IPKC69QlvVpUzHh/LqWntlw1ys3oC6S8DosJyV3VGzuOB34rhFlD+
        5SF+2jO6vYho4Dz/NepeKnap8DkakDM=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-78-YXqX0PYhN9SynQzC5uK8bQ-1; Wed, 05 Jul 2023 05:09:24 -0400
X-MC-Unique: YXqX0PYhN9SynQzC5uK8bQ-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-34603502e5aso23139075ab.1
        for <linux-unionfs@vger.kernel.org>; Wed, 05 Jul 2023 02:09:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688548163; x=1691140163;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eiFA7P4RMGjmdgMoHl/w6ySnit/pa7gC/N0C4ZnDvgU=;
        b=J06C2xwySf6P/bPFk5HqKxbAkxPiwDIr6vPqP0MFRbCQaB81hoG9hJVLgOTVUfYh+l
         dJP3gyNLG4u7cPI0ZYor2hrMFWiD5jLhhDlDYY2S3chXkhyIYD1+bUlCsO1E/U67D+K8
         K87wETzoxZGpBxV8MXTuUa+tn8eBP8Yu9lbyUSnNp2AQMM1GfZVdfziUGmxgueDxYh7x
         /jNDXKclyzih28GV0gw5MDqkkso2QT0V9jozmOEqj8j++IOcGsqIXYe4tBBPIX7NDr9n
         godBX/fkCsx7b7Yrq6ai9g3BNBBARmwXk6tWp7O7AxLmLQs5N7l6PMYjNoJMnssfxcYL
         V1jA==
X-Gm-Message-State: ABy/qLYHKolK+sQ7rwjTT7fzq+3y37C4bPvAtmLPl7bSSWXswp7Js/5u
        x0m7DGzOhFEZch0Wd43ybm5DtlrZmODnbIumOEqioZ/huVIVE4wEufbKNOtAx7swR2fd1C+4w0k
        iVXBAi9F2rx0xoo4rw+ARHcKJKKBcCqkFmZ6ROpBdx3Rsq9jyUUUl
X-Received: by 2002:a92:d710:0:b0:345:d326:9c7f with SMTP id m16-20020a92d710000000b00345d3269c7fmr14785016iln.29.1688548163730;
        Wed, 05 Jul 2023 02:09:23 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFkB4taqnhwZxeT8jJevExkCOnqfRT3EZ4R2Os2oQzvRu1q95PSSlutxrDmjLNuM/DNP6JZcVhVfJBvfLH//uM=
X-Received: by 2002:a92:d710:0:b0:345:d326:9c7f with SMTP id
 m16-20020a92d710000000b00345d3269c7fmr14785009iln.29.1688548163584; Wed, 05
 Jul 2023 02:09:23 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1687345663.git.alexl@redhat.com> <5dfdecee8f0260729c4a8e8150587f128a731ccb.1687345663.git.alexl@redhat.com>
 <20230703192434.GD1194@sol.localdomain>
In-Reply-To: <20230703192434.GD1194@sol.localdomain>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Wed, 5 Jul 2023 11:09:12 +0200
Message-ID: <CAL7ro1FH33+bBbBM4bOdR75AZ4XjkezSfThHJ2Czb_GMTxw9MQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] ovl: Validate verity xattr when resolving lowerdata
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        amir73il@gmail.com, tytso@mit.edu, fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jul 3, 2023 at 9:24=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> w=
rote:
>
> On Wed, Jun 21, 2023 at 01:18:27PM +0200, Alexander Larsson wrote:
> > +static int ovl_ensure_verity_loaded(struct path *datapath)
> > +{
> > +     struct inode *inode =3D d_inode(datapath->dentry);
> > +     const struct fsverity_info *vi;
> > +     struct file *filp;
> > +
> > +     vi =3D fsverity_get_info(inode);
> > +     if (vi =3D=3D NULL && IS_VERITY(inode)) {
>
> Can you please use '!fsverity_active(inode)' instead of
> 'fsverity_get_info(inode) =3D=3D NULL'?  The result is exactly the same, =
but
> fsverity_active() is the intended "API" for code outside fs/verity/.
> fsverity_get_info() is in the header only because fsverity_active() calls=
 it.

Changed this in git:
https://github.com/alexlarsson/linux/tree/overlay-verity

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

