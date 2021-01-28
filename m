Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48458C433DB
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:50:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF5F264DD6
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:50:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbhA1Gty (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 01:49:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231450AbhA1Gq1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Jan 2021 01:46:27 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678C8C061573;
        Wed, 27 Jan 2021 22:45:47 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id h11so4484606ioh.11;
        Wed, 27 Jan 2021 22:45:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y+UeA9jl6KRuLK0zjOL1ouLa5UZUMOsZ2UjTSLjU4PE=;
        b=EpeEHjk+nCXzSlp+TmSdxN81JbXwdnjmWl9oTd6x4//cM3X1lpHU+vpeJ+hM3tbQla
         8CfLxvAn+yWl0wbf65ezhu6Q69NCdCChwoBl4IFlg4E4XrRpWbkiwdWdsPJ4Rlft0MeE
         AK6xJC6ibXbui5WmCj6eg8GwVkuEM+3FJN2zkjyBp/IvXrf+9oHdYs9S9pYhWi1SCtRp
         A0M6s7Ujwetkj3ufK3s6VHz4Sr8gR3GlKySL2Ax7jEBw5Zb1PkMwqFNqC+SIm4NcIld1
         AXzbUln5OUysX1d872/IX15p+4hwlaT5iP/ALIlTdWnJeBlAg6MwExdNvcqKPeGA8rPb
         q5Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y+UeA9jl6KRuLK0zjOL1ouLa5UZUMOsZ2UjTSLjU4PE=;
        b=R0uhq3TA1wtcmoAPZ1nykRWbJdMF2XNMSpuuT4nmeB6xejtNIlELjxxSv5HSL14y5a
         LmccRN61IImMnFp/FaxD1ZBqJdReC1hnf5OkPM9L+xcyqQZcsvUAX5s6fL3cQ/+maLC7
         Zh59bHFpM80aZdAlsRXxQspNCrzgoe5IALZt1VKCbiDpSbKkzNOMcvH962eB8NufsjHf
         IFVjMKZ7H1espxevts8GetHCM9q9nmfEm/5JXqMiD+BUzkLwHVpLuFJj5evwnIMJC/y+
         B/MUT60g/3N+Zy4n4Q6Ty/1c7Qvk0uKRY1GIm5uRHmI9bCmZMWQoAz/kIM4CXF1/SbJp
         /5hw==
X-Gm-Message-State: AOAM532TzhmzXHEcPlWUWw0Wki/Nl/jEF0Ox4PCPz/Ds5Iq+lUDzF7bO
        pkCO1ignqQrIXBTh87I2P/OYKafm5KSTkqxjDxs=
X-Google-Smtp-Source: ABdhPJxgRe2AeOPuJPsRYEmLA94mrVggnFSuBcwivAhSqcPQz8mICHTWbnSLoPf+l7/9A/dBWRAZO3VFOqmCHPDiVoI=
X-Received: by 2002:a02:b0dc:: with SMTP id w28mr11660285jah.123.1611816345223;
 Wed, 27 Jan 2021 22:45:45 -0800 (PST)
MIME-Version: 1.0
References: <20210116165619.494265-1-amir73il@gmail.com> <20210116165619.494265-5-amir73il@gmail.com>
 <CAOQ4uxiXUN7LkzNLZto6iK2YuDdxp7PGoQMGCm89p1kNWUf=YA@mail.gmail.com> <20210127025752.GG58500@e18g06458.et15sqa>
In-Reply-To: <20210127025752.GG58500@e18g06458.et15sqa>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 28 Jan 2021 08:45:34 +0200
Message-ID: <CAOQ4uxi1wpoeWXnkf6BJjttt=c2cd1cuckvfO6G3xMHUb4w_OA@mail.gmail.com>
Subject: Re: [PATCH 4/4] overlay: Test lost immutable/append-only flags on copy-up
To:     Eryu Guan <eguan@linux.alibaba.com>
Cc:     Eryu Guan <guaneryu@gmail.com>, Icenowy Zheng <icenowy@aosc.io>,
        Chengguang Xu <cgxu519@mykernel.net>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jan 27, 2021 at 4:58 AM Eryu Guan <eguan@linux.alibaba.com> wrote:
>
> On Mon, Jan 25, 2021 at 03:24:07PM +0200, Amir Goldstein wrote:
> > On Sat, Jan 16, 2021 at 6:56 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > Chengguang Xu reported [1] that append-only flag is lost on copy-up.
> > > I had noticed that for directories, immutable flag can also be lost on
> > > copy up (when parent is copied up). That's an old overlayfs bug.
> > >
> > > Overlayfs added the ability to set inode flags (e.g. chattr +i) in
> > > kernel 5.10 by commit 61536bed2149 ("ovl: support [S|G]ETFLAGS and
> > > FS[S|G]ETXATTR ioctls for directories").
> > > Icenowy Zheng reported [2] a regression in that commit that causes
> > > a deadlock when setting inode flags on lower dir.
> > >
> > > There is a commented line in the test that triggers this deadlock,
> > > but it has been left commented out until a fix is merged upstream.
> > >
> >
> > Re-iterate in correct thread:
> >
> > The fix for above is in overlayfs-next:
> >
> > * 147ec02b8705 - ovl: avoid deadlock on directory ioctl
> >
> > But I wouldn't uncomment that line in the test just yet.
>
> Then I'd prefer wait for the deadlock fix land in upstream first, and
> merge the test with the deadlock trigger in place.
>
> Or as you mentioned in previous thread, we could seperate the deadlock
> case as a new test (also remove it from current overlay/075), so we
> could merge the [s,g]etxflags case first, then the deadlock case only
> when the fix is upstreamd.
>
> Either way works for me, I just want to avoid merging the test without
> the deadlock trigger, then uncomment it when the fix is available.
>

So let's wait for the deadlock fix to land and I will re-post with split
tests and address your minor comment.

Thanks,
Amir.
