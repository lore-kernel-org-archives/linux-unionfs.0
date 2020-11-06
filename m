Return-Path: <SRS0=vZRj=EM=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49D10C55178
	for <linux-unionfs@archiver.kernel.org>; Fri,  6 Nov 2020 19:00:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D329720882
	for <linux-unionfs@archiver.kernel.org>; Fri,  6 Nov 2020 19:00:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mlslyXS6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbgKFTAV (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 6 Nov 2020 14:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727257AbgKFTAT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 6 Nov 2020 14:00:19 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7565DC0613CF
        for <linux-unionfs@vger.kernel.org>; Fri,  6 Nov 2020 11:00:19 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id s10so2559455ioe.1
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Nov 2020 11:00:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IxIwwBHSnEWsDhc3sbw+VLMxii9om/r2g/5gya267xQ=;
        b=mlslyXS6kg8fSGfaXHhORJO76B4ygwWnau04sgaHRkw5GuqO/vDaUIS0wslewofqZX
         Y6dkJZERvdRCDMFHUC3oZ9v4/i3EZPb6nRNdQdIp0T8dKn9cuL+Gfj4THXnDomOBU4s3
         5yG9sj2SSyJo3TjVET8rPGqgBI10zEYHQ7acc/6L1pDsQNCI8vjuhZM0nsJdDFrlYA4F
         pGRfTfyfr8gjUM4CymfcWAQQKJYe7r0LhgQ/Vmap0Gli3LyBP7Quq6My290tYeNZK71q
         zyrGhJaHJa2PDwgPCchh4TcpUrDsbPrqwjORxQBgqSu769LVZ3Py2umz+eXTbL6gHTN8
         3WyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IxIwwBHSnEWsDhc3sbw+VLMxii9om/r2g/5gya267xQ=;
        b=M6xwFzTtu2BGrFr4rdqsHp8zbTgCZGFK4gONV4F6jc0xHEtbH69GwhsNiFFAvWUnfb
         vg7bY4fhIzyu/kqZJN0hTTkoAIZ5to9EV0+iWGvYpdvmlnifs/FLNSRuxNGaKStkyK/K
         ToMSDA9cS+x8LSg8Fa6Fd+07zAF5BOXlB+zJIa/aXKyZNEhOANTL7zzO8CbUCJRaN9Md
         bM+oT9xvKydg0zRtkZJ9jK/gI7CYO2SERW47y2jjLCeLvDXLUTGKCrtamQVVWP3pykwb
         JFxPFN4ZOyP4E98XKKvzKzkbHd7uy6S0gTxoxNtc3XUtB9LTwg7wuktHy3zJBHUdGK6Q
         kfdg==
X-Gm-Message-State: AOAM5325GU7sm8r2KKL4SWwN6gnDtIoSujC5MsfcxPbGe44biiT7ffFK
        7wLsThNTZv15OLVSGdpIB1yaLskEaa247a9tNXQ=
X-Google-Smtp-Source: ABdhPJyn9K+q8Lnc3XuDlDSViocm9+7dMTMQsdB94xcyBnibTE0yRLSZ4RYoTGWs+Tl4GWETyTs8lgS5GHdbqG+9c/w=
X-Received: by 2002:a05:6638:dcc:: with SMTP id m12mr2751641jaj.30.1604689218629;
 Fri, 06 Nov 2020 11:00:18 -0800 (PST)
MIME-Version: 1.0
References: <20200831181529.GA1193654@redhat.com> <CAMp4zn9dF-umZF-LP=f6qWekyupsXTB6B8CeH6km7=9oVYV+NA@mail.gmail.com>
In-Reply-To: <CAMp4zn9dF-umZF-LP=f6qWekyupsXTB6B8CeH6km7=9oVYV+NA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 6 Nov 2020 21:00:07 +0200
Message-ID: <CAOQ4uxhadzC3-kh-igfxv3pAmC3ocDtAQTxByu4hrn8KtZuieQ@mail.gmail.com>
Subject: Re: [PATCH v7] overlayfs: Provide a mount option "volatile" to skip sync
To:     Sargun Dhillon <sargun@sargun.me>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Nov 6, 2020 at 7:59 PM Sargun Dhillon <sargun@sargun.me> wrote:
>
> On Mon, Aug 31, 2020 at 11:15 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > Container folks are complaining that dnf/yum issues too many sync while
> > installing packages and this slows down the image build. Build
> > requirement is such that they don't care if a node goes down while
> > build was still going on. In that case, they will simply throw away
> > unfinished layer and start new build. So they don't care about syncing
> > intermediate state to the disk and hence don't want to pay the price
> > associated with sync.
> >
> > So they are asking for mount options where they can disable sync on overlay
> > mount point.
> >
> > They primarily seem to have two use cases.
> >
> > - For building images, they will mount overlay with nosync and then sync
> >   upper layer after unmounting overlay and reuse upper as lower for next
> >   layer.
> >
> > - For running containers, they don't seem to care about syncing upper
> >   layer because if node goes down, they will simply throw away upper
> >   layer and create a fresh one.
> >
> > So this patch provides a mount option "volatile" which disables all forms
> > of sync. Now it is caller's responsibility to throw away upper if
> > system crashes or shuts down and start fresh.
> >
> > With "volatile", I am seeing roughly 20% speed up in my VM where I am just
> > installing emacs in an image. Installation time drops from 31 seconds to
> > 25 seconds when nosync option is used. This is for the case of building on top
> > of an image where all packages are already cached. That way I take
> > out the network operations latency out of the measurement.
> >
> > Giuseppe is also looking to cut down on number of iops done on the
> > disk. He is complaining that often in cloud their VMs are throttled
> > if they cross the limit. This option can help them where they reduce
> > number of iops (by cutting down on frequent sync and writebacks).
> >
[...]
> There is some slightly confusing behaviour here [I realize this
> behaviour is as intended]:
>
> (root) ~ # mount -t overlay -o
> volatile,index=off,lowerdir=/root/lowerdir,upperdir=/root/upperdir,workdir=/root/workdir
> none /mnt/foo
> (root) ~ # umount /mnt/foo
> (root) ~ # mount -t overlay -o
> volatile,index=off,lowerdir=/root/lowerdir,upperdir=/root/upperdir,workdir=/root/workdir
> none /mnt/foo
> mount: /mnt/foo: wrong fs type, bad option, bad superblock on none,
> missing codepage or helper program, or other error.
>
> From my understanding, the dirty flag should only be a problem if the
> existing overlayfs is unmounted uncleanly. Docker does
> this (mount, and re-mounts) during startup time because it writes some
> files to the overlayfs. I think that we should harden
> the volatile check slightly, and make it so that within the same boot,
> it's not a problem, and having to have the user clear
> the workdir every time is a pain. In addition, the semantics of the
> volatile patch itself do not appear to be such that they
> would break mounts during the same boot / mount of upperdir -- as
> overlayfs does not defer any writes in itself, and it's
> only that it's short-circuiting writes to the upperdir.
>
> Amir,
> What do you think?

How do you propose to check that upperdir was used during the same boot?

Maybe a simpler check  is that upperdir inode is still in cache as an easy way
around this.

Add an overlayfs specific inode flag, similar to I_OVL_INUSE
I_OVL_WAS_INUSE.

Thanks,
Amir.
