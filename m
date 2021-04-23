Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 817A3C433ED
	for <linux-unionfs@archiver.kernel.org>; Fri, 23 Apr 2021 19:04:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58A8061452
	for <linux-unionfs@archiver.kernel.org>; Fri, 23 Apr 2021 19:04:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243499AbhDWTEr (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 23 Apr 2021 15:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbhDWTEr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 23 Apr 2021 15:04:47 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7517EC061574;
        Fri, 23 Apr 2021 12:04:10 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id v13so1778812ilj.8;
        Fri, 23 Apr 2021 12:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d5k1hWarfg/LVnHlHqsHueBMGE/SK3sCSlJq1goCfww=;
        b=TDBHybMX4u1+Gu0uphWWaRVPI6dl8+uP/cQYiVlVQCm+jLRQgNJxsm4+d1Jw2Tjr7p
         /sjsTx/Y7OYv1KEV1mC7rgifRTz4bPuFIg+0lhnvkxBizR10WCWOrgKoAwILwDXklmyY
         nAyXpoXniV8o7GzspvE4L40UaNDgfaxh/6TK+XEAm7MlVt9gfJ4HCvZRt17qAdKlSrcW
         JuZBZwroCIrq9aYWQslQR13800DOznltEzUSHJyeU/UbsKzMzMDTmmh4F6J8S3ZcN5Ce
         3Mnn7n8eIy7cHR2Yww6neJAxgPTSDDD6l5O1pW7CeJ95dvx65I/rXewdgPPRJqXF6S55
         ybpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d5k1hWarfg/LVnHlHqsHueBMGE/SK3sCSlJq1goCfww=;
        b=OfUKFQIJPTS1Y47hIyqGi4TeIFyhLMPEkXqlNMS8+Z5NZ9u66ICMIRRyuGmMDg09vx
         /7UWrK6T70A0NuY1qiZA3ac1pAnkKxGbnJ27A3WjVsvfAZ9dlB5cqranOe4GyaGNT11S
         jOl4lyPb1Bj0Eoeb2YjoghLY935Qq8diTShxQrm69yIykLkH5+Z6QAuPD+plWxrhc/7q
         bTqmfMC9FfNo5bLsB3KqHnLei6GeLVpBMUXIHpoqyiBq07YxWv/JObCfKgI0iQ1HCvu4
         G4kkFUJXoFXA0DOglielF3pgV/BxuYJ2xzk1aGXmQzfNBr9RWiycjaYlqOLRi12tdiZO
         uIrA==
X-Gm-Message-State: AOAM531n4gofl4kUujrAeTt1Bkg7oJuGJMoNexp6B1Xtf4i21gzMjHMM
        gopypDTw3bB6b8btaXMbNewgSkS/SwWRaATfIE4=
X-Google-Smtp-Source: ABdhPJwXGTq/4vWviPB0TQIqZUIZx3JjmKYhkVXv1uXxXnArLwJpCD5d8o9B1q6NQym6aqRtEmrXz9Wk85OWCma7mjM=
X-Received: by 2002:a05:6e02:1a21:: with SMTP id g1mr4205531ile.9.1619204649875;
 Fri, 23 Apr 2021 12:04:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210421092317.68716-1-amir73il@gmail.com> <CAOQ4uxhh305WPZ-puLONej2TLQTe54-FUtrsgp2R8ohdDcNP0A@mail.gmail.com>
 <CAJfpegtoTJRnNQnttVw54pndEqrpzfxttp=NCQ_2za859fWMqA@mail.gmail.com>
In-Reply-To: <CAJfpegtoTJRnNQnttVw54pndEqrpzfxttp=NCQ_2za859fWMqA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 23 Apr 2021 22:03:58 +0300
Message-ID: <CAOQ4uxjxd31TJKf-B1UNWU4CRHdsd=iLOJX0HJMHEvWpVhnE3Q@mail.gmail.com>
Subject: Re: [PATCH 0/2] Test overlayfs readdir cache
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Apr 22, 2021 at 10:53 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Thu, Apr 22, 2021 at 8:18 AM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Wed, Apr 21, 2021 at 12:23 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > Eryu,
> > >
> > > This extends the generic t_dir_offset2 test to verify
> > > some more test cases and adds a new generic test which
> > > passes on overlayfs (and other fs) on upstream kernel.
> > >
> > > The overlayfs specific test fails on upstream kernel
> > > and the fix commit is currently in linux-next.
> > > As usual, you may want to wait with merging until the fix
> > > commit hits upstream.
> > >
> > > Miklos,
> > >
> > > I had noticed in the test full logs that readdir of
> > > a merged dir behaves strangely - when seeking backwards
> > > to offsets > 0, readdir returns unlinked entries in results.
> > > The test does not fail on that behavior because the test
> > > only asserts that this is not allowed after seek to offset 0.
> > >
> > > Knowing the implementation of overlayfs readdir cache this is
> > > not surprising to me, but I wonder if this behavior is POSIX
> > > compliant, and if not, whether we should document it and/or
> > > add a failing test for it.
> > >
> >
> > I think the outcome could be worse.
> > If a copied up entry is unlinked after populating the dir cache
> > but before ovl_cache_update_ino() then ovl_cache_update_ino()
> > and subsequently the getdents call will fail with ENOENT.
> >
> > This test is not smart enough to cover this case (if it really exists).
> > I think we need to relax the case of negative lookup result in
> > ovl_cache_update_ino() and just set p->whiteout without and
> > continue with no error.
> >
> > This can solve several test cases.
> > In principle, we can "semi-reset" the merge dir cache if the dir was
> > modified after every seek, not just seek to 0.
> > By "semi-reset" I mean use the list, but force ovl_cache_update_ino()
> > to all upper entries, similar to ovl_dir_read_impure().
> >
> > OR.. we can just do that unconditionally in ovl_iterate().
> > The ovl dentry cache for the children will be populated after the first
> > ovl_iterate() anyway, so maybe the penalty is not so bad?
>
> POSIX does allow stale readdir data (not just in case of non-zero seek):
>
> "If a file is removed from or added to the directory after the most
> recent call to opendir() or rewinddir(), whether a subsequent call to
> readdir() returns an entry for that file is unspecified."
>
> If you think about the way readdir(3) is implemented by the libc, this
> is inevitable.
>
> Returning ENOENT from readdir(3) is obviously a bug.

There is no ENOENT bug. I read the code in ovl_cache_update_ino()
wrong, unless lookup_one_len() returns PTR_ERR(-ENOENT) instead
of a negative dentry and I never understood if this ever happens, so
the most we need to do beyond the fix already in overlayfs-next in
to check that -ENOENT case.

Thanks,
Amir.
