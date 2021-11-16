Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 339F4C433F5
	for <linux-unionfs@archiver.kernel.org>; Tue, 16 Nov 2021 12:36:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DD9A619E3
	for <linux-unionfs@archiver.kernel.org>; Tue, 16 Nov 2021 12:36:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235942AbhKPMjW (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 16 Nov 2021 07:39:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236319AbhKPMjE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 16 Nov 2021 07:39:04 -0500
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F77C061570
        for <linux-unionfs@vger.kernel.org>; Tue, 16 Nov 2021 04:36:07 -0800 (PST)
Received: by mail-ua1-x92f.google.com with SMTP id l24so37733029uak.2
        for <linux-unionfs@vger.kernel.org>; Tue, 16 Nov 2021 04:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zNmSVnxPetdA0L3V4GkasCFzJmUbdsvVFKb52Nomjig=;
        b=g4US1ExxJigUReu0nCm6t7eenv87wdEvhvIC9IPkm5AUhqVQCYDiktBcoWD0ZZ25Xl
         AxOl19gDUJhflVAcMIDol8Msye7P9p12QxCgqu48YcxwK4It+3cELtjGCt7B+rET5OQU
         0QH8DhxxbMcTJUwdW5NuzCXgNoS+StGwY3EAw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zNmSVnxPetdA0L3V4GkasCFzJmUbdsvVFKb52Nomjig=;
        b=1FRsknrza9MbH9s7+FLLXb+mdFU77q+6WRwT6EtPi3j3rRZ/n3K8d5Fkq0f9CbOGzf
         qjlTvxMYngMG/oQT9L6B8/lYYklvmYI0Z0QSFH92ag4aXLgE9jgdEi8pp4tNKiO5ulsN
         iJPMHqzP3/efG7D7JZOIoanZJmAEmseIBWFlp1R9qxd/YGX87tlRDHlszIJ2Wni3f6eF
         pc7PmRBdGLZl+udGpxAlsAsOL5R/1Cca165LUr5oGs9lzQm7/5ORE41W6TkfOMHD/KOt
         wuWCUNx8i+1JQN+IuNAHg/RZ0UPO1bw2X1uoIgftycNdjJQBqVyEsx2q2KOmHFREaxVg
         YmvA==
X-Gm-Message-State: AOAM531mFIvvZ9BLx5jc/dpxRJUzMJWN45rfyq96OdNFRvKNn+57bxu9
        fgJHJBaBJY1DdNphuYDU/N29g1hjRgRRBVHcnG4XLw==
X-Google-Smtp-Source: ABdhPJzHYyzPvcxM6korW49fJ4HfL4hi+nMo6aC6cPBOiY6HTGLaUERL/do/oqHiPu5HovfkCuQ7/ow/7kyvew2ELZw=
X-Received: by 2002:ab0:25da:: with SMTP id y26mr10449936uan.72.1637066166488;
 Tue, 16 Nov 2021 04:36:06 -0800 (PST)
MIME-Version: 1.0
References: <20210923130814.140814-1-cgxu519@mykernel.net> <20210923130814.140814-7-cgxu519@mykernel.net>
 <CAJfpeguqj2vst4Zj5EovSktJkXiDSCSWY=X12X0Yrz4M8gPRmQ@mail.gmail.com>
 <17c5aba1fef.c5c03d5825886.6577730832510234905@mykernel.net>
 <CAJfpegtr1NkOiY9YWd1meU1yiD-LFX-aB55UVJs94FrX0VNEJQ@mail.gmail.com>
 <17c5adfe5ea.12f1be94625921.4478415437452327206@mykernel.net>
 <CAJfpegt4jZpSCXGFk2ieqUXVm3m=ng7QtSzZp2bXVs07bfrbXg@mail.gmail.com> <17d268ba3ce.1199800543649.1713755891767595962@mykernel.net>
In-Reply-To: <17d268ba3ce.1199800543649.1713755891767595962@mykernel.net>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 16 Nov 2021 13:35:55 +0100
Message-ID: <CAJfpegttQreuuD_jLgJmrYpsLKBBe2LmB5NSj6F5dHoTzqPArw@mail.gmail.com>
Subject: Re: [RFC PATCH v5 06/10] ovl: implement overlayfs' ->write_inode operation
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 16 Nov 2021 at 03:20, Chengguang Xu <cgxu519@mykernel.net> wrote:
>
>  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2021-10-07 21:34:19 Miklos S=
zeredi <miklos@szeredi.hu> =E6=92=B0=E5=86=99 ----
>  > On Thu, 7 Oct 2021 at 15:10, Chengguang Xu <cgxu519@mykernel.net> wrot=
e:
>  > >  > However that wasn't what I was asking about.  AFAICS ->write_inod=
e()
>  > >  > won't start write back for dirty pages.   Maybe I'm missing somet=
hing,
>  > >  > but there it looks as if nothing will actually trigger writeback =
for
>  > >  > dirty pages in upper inode.
>  > >  >
>  > >
>  > > Actually, page writeback on upper inode will be triggered by overlay=
fs ->writepages and
>  > > overlayfs' ->writepages will be called by vfs writeback function (i.=
e writeback_sb_inodes).
>  >
>  > Right.
>  >
>  > But wouldn't it be simpler to do this from ->write_inode()?
>  >
>  > I.e. call write_inode_now() as suggested by Jan.
>  >
>  > Also could just call mark_inode_dirty() on the overlay inode
>  > regardless of the dirty flags on the upper inode since it shouldn't
>  > matter and results in simpler logic.
>  >
>
> Hi Miklos=EF=BC=8C
>
> Sorry for delayed response for this, I've been busy with another project.
>
> I agree with your suggesion above and further more how about just mark ov=
erlay inode dirty
> when it has upper inode? This approach will make marking dirtiness simple=
 enough.

Are you suggesting that all non-lower overlay inodes should always be dirty=
?

The logic would be simple, no doubt, but there's the cost to walking
those overlay inodes which don't have a dirty upper inode, right?  Can
you quantify this cost with a benchmark?  Can be totally synthetic,
e.g. lookup a million upper files without modifying them, then call
syncfs.

Thanks,
Miklos
