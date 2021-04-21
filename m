Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A43C433B4
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Apr 2021 12:15:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC7CF61001
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Apr 2021 12:15:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238110AbhDUMPs (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 08:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237991AbhDUMPr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Apr 2021 08:15:47 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A856AC06174A
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Apr 2021 05:15:13 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id h19so2446929vsa.10
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Apr 2021 05:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Jjuj60NefN9MYrzAmLyfxeAMOu/07rIE9lxbN4jUnuw=;
        b=EznyFXcdX5LSJvFA98EbwV2utnPmaOFCjpf06Vn4wPlaFM6QVfcOhTrZUYGoAfjamH
         rEjP5akqsJrlMV/iZhqkqV97SUNgDYk+u2lFa9fOhWEKWW/HD3RsO9DQD3WEMhYOQphn
         PEVRVbeT9R3PEcy89Aisi2dUXQcFFctJ6gNIg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Jjuj60NefN9MYrzAmLyfxeAMOu/07rIE9lxbN4jUnuw=;
        b=QLNjicxGaGPfUf/vhGUjxD9kO74oE1YxoE9Qm/EoKFVqqEu2oKPG3+z8uXA8IYelQd
         WECrc+vmUXxqCjJwCQNqPDR0bI8BDKSuo8W61hWAThT6qIMl/gV/iUGlpP0KQqwLlwOC
         2QI6mBzCOj/Hwo8yy7eO6MorZ3Sb8716nWAVfacuBr/+OBqVmUwEiHjSxrM1OJrK6zRE
         4AwGUAl5CeQoaXtXnlgw5uJXUSW/FBCoePJdpKfpN+kqbLWZlINEfqzZFVXCAR7KcHoc
         LNL+x4FA4u4TuBYU5t55yuQvAY/iJrww6XlljKzisL0APlK9MuaKH0qu8b7HDTciyeg1
         LyAA==
X-Gm-Message-State: AOAM532iIVM3JWyoGAyQOjIAcMctb1tTW3PhX4HWded2Oljq2RLUUCu5
        LuH3F+AqBu1uAVZRfvkA5LahfFyBozXYfQYodYzYRg==
X-Google-Smtp-Source: ABdhPJwDpZ+9/p4oOKGuJtxoHWfiTOiV8D2U8zSRCGRIwDE4WG6nG/Su1txwC+4FnLSu0YhAuDHRt8A99HMlouZ53DY=
X-Received: by 2002:a67:6647:: with SMTP id a68mr24506544vsc.21.1619007312890;
 Wed, 21 Apr 2021 05:15:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210420020738.201670-1-cgxu519@mykernel.net> <CAJfpegvfGAynZ1kz287eJHVRc6+81FzUwSq_V9E36qXCB7WtYQ@mail.gmail.com>
 <481e8c92-3084-f0bc-56ec-86099abfdc55@amd.com> <CAJfpegvMcitbZ=APBE7Eu4te1LR+thwH=iYrWMvqn80mFFvmLQ@mail.gmail.com>
 <0a34847c-2db0-4901-2206-7df1f348e32e@amd.com>
In-Reply-To: <0a34847c-2db0-4901-2206-7df1f348e32e@amd.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 21 Apr 2021 14:15:01 +0200
Message-ID: <CAJfpeguEUMz4M85mu-M6JO-z+4VJftD1Y5m0wVV5W2so_EQj6Q@mail.gmail.com>
Subject: Re: [PATCH] ovl: restore vma->vm_file to old file
To:     =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Apr 21, 2021 at 1:25 PM Christian K=C3=B6nig
<christian.koenig@amd.com> wrote:
>
> Am 21.04.21 um 13:14 schrieb Miklos Szeredi:
> > On Wed, Apr 21, 2021 at 1:03 PM Christian K=C3=B6nig
> > <christian.koenig@amd.com> wrote:
> >> Am 21.04.21 um 11:47 schrieb Miklos Szeredi:
> >> [SNIP]
> >> Can you give wider context? In other words why did the patch broke the
> >> reference counting in overlayfs?
> > In the error case overlayfs would put the reference on realfile (which
> > is vma->vm_file at that point) and mmap_region() would put the
> > reference to the original file (which was vma->vm_file before being
> > overridden).
> >
> > After your commit mmap_region() puts the ref on the override vm_file,
> > but not on the original file.
>
> Ah, of course. Double checking the mmap callback implementation of
> overlayfs that is rather obvious.
>
> >>> Changing refcounting rules in core kernel is no easy matter, a full
> >>> audit of ->mmap instances (>200) should have been done beforehand.
> >> Which is pretty much what was done, see the follow up commit:
> >>
> >> commit 295992fb815e791d14b18ef7cdbbaf1a76211a31 (able/vma_file)
> >> Author: Christian K=C3=B6nig <christian.koenig@amd.com>
> >> Date:   Mon Sep 14 15:09:33 2020 +0200
> >>
> >>       mm: introduce vma_set_file function v5
> >>
> >>       Add the new vma_set_file() function to allow changing
> >>       vma->vm_file with the necessary refcount dance.
> >>
> >> It just looks like I missed the case in overlayfs while doing this.
> > Yes.  And apparently a number of other cases where vm_file is assigned.=
..
>
> Yeah, I wasn't aware that filesystems do that as well and only
> concentrated on the drivers.
>
> Just did a "grep -R 'vm_file[[:space:]]*=3D' on the full kernel source an=
d
> it only showed one more case in fs/coda/file.c.
>
> Do you see any other occurrences I potentially missed?

No, the others seem to be okay.

Thanks,
Miklos
