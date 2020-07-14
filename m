Return-Path: <SRS0=Lx5L=AZ=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44247C433DF
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 18:45:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 179E420771
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 18:45:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mOPDD9JU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgGNSp2 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 14:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbgGNSp2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Jul 2020 14:45:28 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 743EDC061755
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Jul 2020 11:45:28 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id t18so15120501ilh.2
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Jul 2020 11:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4l8wvTIoGhQU7qcUO4z6gYTvoaWyX3iuScLfiFjPHsM=;
        b=mOPDD9JU9i4Y4pagdXosoyKUYSzi+A6AuDmTQzjNmdNxu+AMxWewEYHlgoCHM6i2tq
         i0mHfJe4/6JFDdTWoXKl005B83hIcJvGNX05vgXV6fNBnWczQSP/pQNW1p2a4lQBxw5p
         Xcgq2/QE8u0EapX7/HPNTcWAAdzAM5EF3pVBgCRy1mrNJfhXXn4fz1khXFdUp7EFTkqP
         bYiuTgoqpC6nApS64luVbJCs3672uY+8YsIDEpf0IiZLP0UnQSXzjLnQJcR2nsQVfWwK
         eURCBnDIAv18Lm4yo5k9rMNDjY8mXL3e9YMlPYj/UMEXEI0Z1Zo6dgKXHtF8P+Ur1YC9
         N0Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4l8wvTIoGhQU7qcUO4z6gYTvoaWyX3iuScLfiFjPHsM=;
        b=Fu6pJc+p6Qr0stAzgb553V8k+BiB3zul5OSaO89asTFu3GbPbywVbM89gSL1b2eUA1
         2IbclXvYoydAyD0/C4DXrUY+qldH+TFFSJx3hdkfQENVj584LiGCJ36iQoQfu70V0nM5
         y7/1MN58Zb/Ns6Vd1r93ekxdgmTzbX97Z+3XoQsUUkDcsJIwiu84Jo2MNRv8MZghPDJG
         GDjwRuBUlAOKrDpk3WjCXnct3Dh4bF87ugQHJLfzuziOSaCnETodZekrPqLW7V/7cQfX
         dnzy8Bb9/lZBjAvF/5EMnx3HS1LP0DMsnyV9sjDI73thi4YldDU29sKb9mZgcvhRxwd/
         97xQ==
X-Gm-Message-State: AOAM530Ks4pLNL2h1mB56PHxgWNeD2AgyTRTF/BknfHIhgLuZ/3HjLwS
        QbWbfbceuXjMIa72G7sQtSTEuenyzktb1sgG7a4R5A==
X-Google-Smtp-Source: ABdhPJz6WWso8Sfb81QImxpRsPtZsJmMtjMkExZFPfqFJ3Cs/BMfWrlIVFBJbqXcM5JRbbPTNXCxFx/lMz3xbDGQqLE=
X-Received: by 2002:a05:6e02:13e2:: with SMTP id w2mr6253991ilj.9.1594752327848;
 Tue, 14 Jul 2020 11:45:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200713141945.11719-1-amir73il@gmail.com> <20200713141945.11719-2-amir73il@gmail.com>
 <20200714181804.GF324688@redhat.com> <CAOQ4uxj_GMcWvSGSWkTQvKj2gPCP1=R9T-t=baDrH+V3Q1mPrQ@mail.gmail.com>
 <20200714183819.GH324688@redhat.com>
In-Reply-To: <20200714183819.GH324688@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 14 Jul 2020 21:45:16 +0300
Message-ID: <CAOQ4uxg7BL6FiHJ9LNvoBWiCEuDKEjGVC86-3guSiYqHteokAQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] ovl: force read-only sb on failure to create index dir
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jul 14, 2020 at 9:38 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Tue, Jul 14, 2020 at 09:32:51PM +0300, Amir Goldstein wrote:
> > On Tue, Jul 14, 2020 at 9:18 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > On Mon, Jul 13, 2020 at 05:19:43PM +0300, Amir Goldstein wrote:
> > > > With index feature enabled, on failure to create index dir, overlay
> > > > is being mounted read-only.  However, we do not forbid user to remount
> > > > overlay read-write.  Fix that by setting ofs->workdir to NULL, which
> > > > prevents remount read-write.
> > > >
> > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > >
> > > This patch does not apply for me. What branch you have generated it
> > > against. I am using 5.8-rc4.
> >
> > It's from my ovl-fixes branch.
> >
> > Sorry I did not notice that it depends on a previous patch that Miklos
> > just picked up:
> >
> > "ovl: fix oops in ovl_indexdir_cleanup() with nfs_export=on"
>
> I dont see it here.
>
> https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git/log/?h=overlayfs-next
>
> Is there another tree/branch miklos is maintaining which I should use? Or
> you just happen to know that Miklos has committed this internally and
> not published yet.
>

Sorry. He just replied to the email "applied" a few hours ago.
If you need the patch it's on my ovl-fixes branch in github.

Thanks,
Amir.
