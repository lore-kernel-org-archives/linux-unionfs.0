Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BC70C433EF
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 Oct 2021 18:52:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F68F60F11
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 Oct 2021 18:52:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243812AbhJGSxx (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 7 Oct 2021 14:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243811AbhJGSxx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Oct 2021 14:53:53 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DADFC061570
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Oct 2021 11:51:59 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id 66so7816341vsd.11
        for <linux-unionfs@vger.kernel.org>; Thu, 07 Oct 2021 11:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IpVV/iS/slfiNLSYszxf18SrC9/xTM7dslxkNEPwfTI=;
        b=pp9QUGn1eEBn3Igh3E0wg9uT0yoMtbtkUl5FSHZp2vad6jTD1p3Txoy0dnuAS17+Ob
         V+NVa5snrCfTZFfiHA1K7laFRTbGlJTTKEK3Ti3voS4/Ol2eQj8DzR1Kq9G361kvPwRM
         J7U4Cos3yEM6/U7XJUNg+2vDgAT7p99VTd0I8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IpVV/iS/slfiNLSYszxf18SrC9/xTM7dslxkNEPwfTI=;
        b=TWsR9vbCB80vQ3Bid3/QteYYseEi6pXGHKcADV0ALHesOhBnqEWARs1G224uPm6UXj
         bO+Csn9U5I54F1rFTv18wuQVGIhErPLxzrhZrFLm+ktqMeTc7mM7a1D6abI/C6xj+v8g
         UY+iX+dloMitnE0gf5FiEdmnIbkuP8r1hQVMiDZtShf0UwoaMt6sa0OhWXcyA8V8GiBJ
         269p2VQRkeOlVS1wBSQgUob1g5KTuHfqO4QL9VMkud0HC0CmLp55843emd+/YoLPehUB
         3kesRl731V23NtWmslKy7QrYAh3PKdFQAXQpuu0RdxUREIbCMYowrrbjGOrujj5VQxMP
         9mHg==
X-Gm-Message-State: AOAM530CsbDd8s9b13ailV2GfbWSJZ8ndgSQuRygUAGAwbtZMf+CsuSO
        GKGeia+ecFVKlsnkzLRRKABFN7GfZADn2jtVqzadjw==
X-Google-Smtp-Source: ABdhPJzAgeKYnF/Bky9Wn40IKQoLYr/GHMAQaltU4AmNnvnRWUmbGybh52CrelSwFv/Hl6n0jBNsGR735Mi/L3HpSVM=
X-Received: by 2002:a05:6102:3c3:: with SMTP id n3mr6474901vsq.19.1633632718216;
 Thu, 07 Oct 2021 11:51:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210923130814.140814-1-cgxu519@mykernel.net> <20210923130814.140814-7-cgxu519@mykernel.net>
 <CAJfpeguqj2vst4Zj5EovSktJkXiDSCSWY=X12X0Yrz4M8gPRmQ@mail.gmail.com>
 <17c5aba1fef.c5c03d5825886.6577730832510234905@mykernel.net>
 <CAJfpegtr1NkOiY9YWd1meU1yiD-LFX-aB55UVJs94FrX0VNEJQ@mail.gmail.com>
 <17c5adfe5ea.12f1be94625921.4478415437452327206@mykernel.net>
 <CAJfpegt4jZpSCXGFk2ieqUXVm3m=ng7QtSzZp2bXVs07bfrbXg@mail.gmail.com>
 <20211007144646.GL12712@quack2.suse.cz> <17c5b3e4f2b.113dc38cd26071.2800661599712778589@mykernel.net>
In-Reply-To: <17c5b3e4f2b.113dc38cd26071.2800661599712778589@mykernel.net>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 7 Oct 2021 20:51:47 +0200
Message-ID: <CAJfpegvek6=+Xk+jLNYnH0piQKRqb9CWst_aNHWExZeq+7jOQw@mail.gmail.com>
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

On Thu, 7 Oct 2021 at 16:53, Chengguang Xu <cgxu519@mykernel.net> wrote:
>
>  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2021-10-07 22:46:46 Jan Kara=
 <jack@suse.cz> =E6=92=B0=E5=86=99 ----
>  > On Thu 07-10-21 15:34:19, Miklos Szeredi wrote:
>  > > On Thu, 7 Oct 2021 at 15:10, Chengguang Xu <cgxu519@mykernel.net> wr=
ote:
>  > > >  > However that wasn't what I was asking about.  AFAICS ->write_in=
ode()
>  > > >  > won't start write back for dirty pages.   Maybe I'm missing som=
ething,
>  > > >  > but there it looks as if nothing will actually trigger writebac=
k for
>  > > >  > dirty pages in upper inode.
>  > > >  >
>  > > >
>  > > > Actually, page writeback on upper inode will be triggered by overl=
ayfs ->writepages and
>  > > > overlayfs' ->writepages will be called by vfs writeback function (=
i.e writeback_sb_inodes).
>  > >
>  > > Right.
>  > >
>  > > But wouldn't it be simpler to do this from ->write_inode()?
>  >
>  > You could but then you'd have to make sure you have I_DIRTY_SYNC alway=
s set
>  > when I_DIRTY_PAGES is set on the upper inode so that your ->write_inod=
e()
>  > callback gets called. Overall I agree the logic would be probably simp=
ler.
>  >
>

And it's not just for simplicity.  The I_SYNC logic in
writeback_single_inode() is actually necessary to prevent races
between instances on a specific inode.  I.e. if inode writeback is
started by background wb then syncfs needs to synchronize with that
otherwise it will miss the inode, or worse, mess things up by calling
->write_inode() multiple times in parallel.  So going throught
writeback_single_inode() is actually a must AFAICS.

Thanks,
Miklos
