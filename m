Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED135EB64D7
	for <linux-unionfs@archiver.kernel.org>; Fri, 16 Jun 2023 08:12:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbjFPIMJ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 16 Jun 2023 04:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244661AbjFPIMI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 16 Jun 2023 04:12:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76588296C
        for <linux-unionfs@vger.kernel.org>; Fri, 16 Jun 2023 01:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686903080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WJJXtoHx/PWyibukTRSCD3QMM2w15zdSv1dfITtFgjc=;
        b=QuRxDZF5pSwy4n0WinRDt6IHhOIRH4kZ9kE+CrWCUHPIVL2Th0L5JxfHFxQNr8Izn/V/Fw
        eutmmoryryX/gEcVeJm6elCOrw2e7Pu02OhIwWXy0hzQOV0e1EBE3fzu1ktegWy/VvSlhx
        yrGRt1NvIWVblhSmIoSWBKr525cvr/Y=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-230-sEkItJcHNNCQwdQQUOkA-w-1; Fri, 16 Jun 2023 04:11:18 -0400
X-MC-Unique: sEkItJcHNNCQwdQQUOkA-w-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-34055a1cc0fso3759115ab.2
        for <linux-unionfs@vger.kernel.org>; Fri, 16 Jun 2023 01:11:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686903078; x=1689495078;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WJJXtoHx/PWyibukTRSCD3QMM2w15zdSv1dfITtFgjc=;
        b=EEtBHgRtPTbm59AuVPOf1ChjoCKfy+i5HanJzOGGh4cQogFr25Vv8n9Yklh2RWzV2t
         O42S8pskHv9ituWasKrDvpYf6CBxNYUAikqne//Aq6LtvIxOldDqpvJI+89EwI1wHhIS
         73PZFpZ7ziSms124XczV+bYXQYJGisdEOlIZTmhx4xWxA45n+TMnrcuKLpZQnFYYI4Em
         0F7OnUJ/IxCOc5ZdhhMOyjPtANjS/PgdnU7dIW8Dyc4YCT9Kw1hUkFy+0UZeFNgBMPGR
         XzO8i4Oge04umXV7nAP8zzbwFVY9XpVI6sDVCRQ1MIGEZ72co+gSnDa34GLKBnjFdn3N
         7bRw==
X-Gm-Message-State: AC+VfDxS/Bfm2ELPEt4rkAPqoNsVyuTx0RyA1x7mslrre0uX+wf38cTx
        T253bCfP32p70xUicXgBq0D0GcjFNiBGVUeSWfnoviB7m1aL542y2ys4Co+Kv5lqZY45WFh0zV7
        ZTc8Xki/TJMZ8cINFnuiA8N6K2nL4zTIyFFYAxG1ULA==
X-Received: by 2002:a92:d686:0:b0:341:d535:8c0a with SMTP id p6-20020a92d686000000b00341d5358c0amr1707559iln.29.1686903078117;
        Fri, 16 Jun 2023 01:11:18 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ50qTVty7I7235/QbtI1tN5/iA4lhWbPcjlb0fXch5+NkuoYv/L20ZZXG0IpNhIn/AIs6tpioU+GTgK64W8kRM=
X-Received: by 2002:a92:d686:0:b0:341:d535:8c0a with SMTP id
 p6-20020a92d686000000b00341d5358c0amr1707549iln.29.1686903077878; Fri, 16 Jun
 2023 01:11:17 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1686565330.git.alexl@redhat.com> <03ac0ffd82bc1edc3a9baa68d1125f5e8cad93fd.1686565330.git.alexl@redhat.com>
 <20230612163216.GA847@sol.localdomain> <CAOQ4uxjS5-7_PaoxM41YaXW+KxwLK_K8AyJMaoi1m-3P-vZ9Kw@mail.gmail.com>
 <20230613063704.GA879@sol.localdomain> <CAOQ4uxg6BD_RDtWob5q2eX6uQ5hcWrK7wEDcBhFVrGM3vsn=NA@mail.gmail.com>
 <20230613182233.GC1139@sol.localdomain> <CAOQ4uxhzJFpfuFLxK2s0JqS5qGQDGfndFPY7n2NDmZso4cG4Rg@mail.gmail.com>
 <CAL7ro1FF2iUjPsXrha8tELYvi9MwW7WRhksqX7ahSXc4gPHraw@mail.gmail.com> <20230615235229.GC25295@sol.localdomain>
In-Reply-To: <20230615235229.GC25295@sol.localdomain>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Fri, 16 Jun 2023 10:11:06 +0200
Message-ID: <CAL7ro1G+Dnet=M+CUY7e_9nJhOtD3rQm16C7bWkMBVnfcvm4Yg@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] ovl: Add framework for verity support
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>, miklos@szeredi.hu,
        linux-unionfs@vger.kernel.org, tytso@mit.edu,
        fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Jun 16, 2023 at 1:52=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Wed, Jun 14, 2023 at 09:57:41AM +0200, Alexander Larsson wrote:
> > When a layer containing verity xattrs is used, it means that any
> > such metacopy file in the upper layer is guaranteed to match the
> > content that was in the lower at the time of the copy-up. If at any tim=
e
> > (during a mount, after a remount, etc) such a file in the lower is
> > replaced or modified in any way, then opening the corresponding file on
> > overlayfs will result in EIO and a detailed error printed to the kernel=
 logs.
> > (Actually, due to caching the overlayfs mount might still see the previ=
ous
> > file contents after a lower file is replaced under an active mount, but
> > it will never see the wrong data.)
>
> Well, the key point of fsverity is that data is not verified until it is
> actually read.  At open time, the fsverity file digest is made available =
in
> constant time, and overlayfs will verify that.  However, invalid data blo=
cks are
> not reported until the data is actually read.  The error that application=
s get
> is EIO for syscalls, and SIGBUS for memory-mapped reads, as mentioned at
> https://www.kernel.org/doc/html/latest/filesystems/fsverity.html#accessin=
g-verity-files
>
> So overlayfs might report EIO at open time, or it might not report an err=
or
> until the modified data is read.  And in the latter case, presumably the =
error
> seen by the application matches the one for using fsverity natively?

Yes, I'm aware of that, but do we need to describe this in the
overlayfs documentation?
The text I wrote is describing the behaviour that overlayfs adds to
the mix, and I sort of
assumed the late validation from fs-verity itself would be known about
if the file already
has fs-verity enabled.

> You can link to the fsverity documentation somewhere if it would be helpf=
ul, but
> I'd still like the semantics of how this works on overlayfs to be documen=
ted.

I guess just adding a link to that is not that bad. What about:

----
When a layer containing verity xattrs is used, it means that any such
metacopy file in the upper layer is guaranteed to match the content
that was in the lower at the time of the copy-up. If at any time
(during a mount, after a remount, etc) such a file in the lower is
replaced or modified in any way, then opening the corresponding file
on overlayfs will result in EIO and a detailed error printed to the
kernel logs.  (Actually, due to caching the overlayfs mount might
still see the previous file contents after a lower file is replaced
under an active mount, but it will never see the wrong data.)  In
addition fs-verity will do late validation of the file content, as
described in :ref:`Documentation/filesystems/fsverity.rst
<accessing_verity_files>`.
---

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

