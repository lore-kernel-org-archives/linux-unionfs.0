Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A10FC433ED
	for <linux-unionfs@archiver.kernel.org>; Wed, 19 May 2021 04:03:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43B3461363
	for <linux-unionfs@archiver.kernel.org>; Wed, 19 May 2021 04:03:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbhESEFM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 19 May 2021 00:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbhESEFM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 19 May 2021 00:05:12 -0400
Received: from mail-vk1-xa32.google.com (mail-vk1-xa32.google.com [IPv6:2607:f8b0:4864:20::a32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 177DAC06175F
        for <linux-unionfs@vger.kernel.org>; Tue, 18 May 2021 21:03:53 -0700 (PDT)
Received: by mail-vk1-xa32.google.com with SMTP id c17so2508784vke.3
        for <linux-unionfs@vger.kernel.org>; Tue, 18 May 2021 21:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=005H25oHztKG+nSEcvMKBfVQtGisiCUjlVtB3nCowos=;
        b=egv+k4Y1QK40T83FZPtN2cnbcTTdb67akYxAI57beGc81D97buewAMUxLHAkKJ7Uhi
         E7fzELVUKv3vIAuvYdZHUg/1czub1vvwUNzTSeuHGEUGSX+LPDI8LYMZcUwnNsHmbJTf
         dMryL+gz8iODLu5Uj33M2BYyKxL5chy1ayncs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=005H25oHztKG+nSEcvMKBfVQtGisiCUjlVtB3nCowos=;
        b=W8tY6mcBnNi9pq/Q1GpnxNdKyhtoWMyn5cQEIFQ5+oSj4olQECeNuIF5n7Xc3tnihr
         awxLNBQJo1zbW5b4WYDhbuTa8DTESKSDxfefkBn1kSevHTzM7Vgkjb9Sk9TlGC5qZQ4k
         JNeBVh0sko5javiAD9klFj2hi1Kqdld3dCRKpSy0L4y0QFqIP1fLCD4RNgBNhGproOQm
         oPiM5kzG3qwPyU7Y9S+AxWj8SJMbezamL1IgBn8askQLLu+MuDuNlkVIXvRTe0NXkZ0g
         Ir76jyujLSaZpk+PHAUgz5iHWQ/9pA3/ISMx80rpKa8M2/Aw6iduXvYFvutHwybkxGWn
         weYw==
X-Gm-Message-State: AOAM531DWYgzCxScSsb6+NqiB5gOGQLBPHEAKQ+p/8eWifIwU8ntS3Jm
        nbRZnOBm3qd8lqTGM/DU0UsJNW9hiEgsrVecbOz7BA==
X-Google-Smtp-Source: ABdhPJzMMU+SSCanJuoajJVYxSRVMJVmh+7Zem+oOk6V9klKze7by2oM00gAyXfOIDfSuLQmjBJGZ4MhF2dJPyrs7ig=
X-Received: by 2002:a05:6122:124b:: with SMTP id b11mr515013vkp.11.1621397032184;
 Tue, 18 May 2021 21:03:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210518122138.22914-1-yaohaidong369@gmail.com>
 <CAJfpeguv0uMN4zc8OUkYEJ995KAhtBcAwVo4v0nTa-hMoMLbBA@mail.gmail.com> <CA+kUaCcaZCb4+zqQthsUvEApG4xFdGsSZ_vQ_1s=G49JHQQh9w@mail.gmail.com>
In-Reply-To: <CA+kUaCcaZCb4+zqQthsUvEApG4xFdGsSZ_vQ_1s=G49JHQQh9w@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 19 May 2021 06:03:41 +0200
Message-ID: <CAJfpegv_TPLFumONsoCOKP5vuO7Gdy91TkV3LUvNg4tdPSs6zA@mail.gmail.com>
Subject: Re: [PATCH] ovl: useing ovl_revert_creds() instead of revert_creds(),
To:     Yao Haidong <yaohaidong369@gmail.com>
Cc:     Orson Zhai <orsonzhai@gmail.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Chunyan Zhang <Chunyan.Zhang@unisoc.com>,
        Orson Zhai <Orson.Zhai@unisoc.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Haidong Yao <haidong.yao@unisoc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, 19 May 2021 at 05:29, Yao Haidong <yaohaidong369@gmail.com> wrote:

> Miklos Szeredi <miklos@szeredi.hu> =E4=BA=8E2021=E5=B9=B45=E6=9C=8818=E6=
=97=A5=E5=91=A8=E4=BA=8C =E4=B8=8B=E5=8D=889:41=E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Tue, 18 May 2021 at 14:21, Haidong Yao <yaohaidong369@gmail.com> wro=
te:
> > >
> > > From: Haidong Yao <haidong.yao@unisoc.com>

[...]

> > > diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> > > index 4d53d3b7e5fe..d9bc658f22ee 100644
> > > --- a/fs/overlayfs/file.c
> > > +++ b/fs/overlayfs/file.c
> > > @@ -60,7 +60,7 @@ static struct file *ovl_open_realfile(const struct =
file *file,
> > >                 realfile =3D open_with_fake_path(&file->f_path, flags=
, realinode,
> > >                                                current_cred());
> > >         }
> > > -       revert_creds(old_cred);
> > > +       ovl_revert_creds(inode->i_sb, old_cred);
> >
> > Upstream kernel doesn't have ovl_revert_creds().

> Hi Miklos:
>
> Sorry,
> Sometimes=EF=BC=8Cold_cred is NULL.
> Do you think this is a problem?
> Can I add ovl_revert_creds()? or You have a better way?

old_cred can't be NULL on upstream (Linus) kernel.

From the taint flags I can see that this is some weird setup.  Please
contact the distro that is providing the kerne/modules about this
issue.  It's not anything the upstream kernel maintainers can help
with.

Thanks,
Miklos
