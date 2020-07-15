Return-Path: <SRS0=S/v9=A2=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C72BC433E3
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Jul 2020 13:56:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65B1B20657
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Jul 2020 13:56:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AsOjvWsz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729924AbgGON46 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 09:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729086AbgGON45 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 15 Jul 2020 09:56:57 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7EE6C061755
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Jul 2020 06:56:57 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id h16so2010719ilj.11
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Jul 2020 06:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YeNvlX5qWYm1dwO/I9ADMbL7XUjRA8EiXjek3vOQlRs=;
        b=AsOjvWszisagE1QbVT/6pJZV91ZF45gMFgvZbur3+Dd2y2UVY7kczfAXywQP6SWQjJ
         3I0V5gSwupY7+Ui3wzJ+0qRdjW/jnb4yWra10AG7IzDOsnS+JWg8MMiZHkotpdFcqjYw
         bEsIgDW27ntsvXZSSFsHSc9rqvwxIy9NbtDr2VYSSDTr283fxoRCrkOXGmhwlQGc9hoc
         Bg2gHHrkk9+F5t/t6+Bfli1/krUgUlZDPTsl8/LbdfqUeWhGs3ZM8jR7mvlqJzmu82d1
         PxpENq61RE3jJMNdxzCaOfNrE9CJ/V1G2djNyWoGofESbhO0hBNZZdDdyiZBpTCQAfr+
         Pwrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YeNvlX5qWYm1dwO/I9ADMbL7XUjRA8EiXjek3vOQlRs=;
        b=FuYGFufqF1PMf8zZVZc9u+WVdFE5WwojqTboEehI0ZZoP+XvIkl1xgcnWl3DbRUDb+
         NipjzPiYLMhEyyIERokLwNp5t9c9Yky+3UflXJ/ynq/j5nf6tyUjAVorjvfDnHeeVhRa
         OoAJdz1Dr4s7UAEl+qOn6UjEVnBeIcSzYud+PYL+pDWSVQkkIdC2SFkOaC6MGFBhD4hv
         rav9tkJW5jlcf36OMMaouMYzuq8HYAxZKFfCJVljipyQ+cU+qlV5xcEH6LDUWNOlKqg/
         WcrGZe3w06CKlKjnHVARYO5UrbsTz8q5YKLSMQ5Elu5HLJ+rZPR/Mf2V3dBOVoL4gn+r
         XpLA==
X-Gm-Message-State: AOAM533jXPHoakEJa5Usx8p8AMoBtyzsBfkOGsFOVT3p0EhPzRnOX8ro
        1v/ZLyEWdU3fDrlMDVdmbKP18B1M52kCgfMOpBE=
X-Google-Smtp-Source: ABdhPJxf9F3EriV8kpSSmmmdtcvl2gqMmDOSFvEdvtiLkrbZVzSECFGAyOHvjBBoSP57jBtpjtOGQHQt7UNr4mACSsU=
X-Received: by 2002:a92:b6d4:: with SMTP id m81mr10053461ill.72.1594821416364;
 Wed, 15 Jul 2020 06:56:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200713141945.11719-1-amir73il@gmail.com> <20200714180705.GE324688@redhat.com>
 <CAOQ4uxh-fUKhiQOhRmZ5LT2sjtM3Wx5wo_wcKYtX+-DbYjXp0Q@mail.gmail.com> <20200715130648.GA379396@redhat.com>
In-Reply-To: <20200715130648.GA379396@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 15 Jul 2020 16:56:45 +0300
Message-ID: <CAOQ4uxjV93TAUGLAL_1uAtm2+eJv7poj_mmO5K_-07TYjBh7vA@mail.gmail.com>
Subject: Re: [PATCH 0/3] Misc. redirect_dir=nofollow fixes
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

> > TBH I never really understood the thread that led to redirect_dir=nofollow.
> > I don't think anyone has presented a proper use case that can be discussed,
>
> IIUC, idea was that automated mounting can mount a handcrafted upper on
> usb hence allow access to directories on host which are otherwise
> inaccessible.
>

That is an *idea* described by hand waving.
That is not a threat I can seriously comment on.
How exactly is that USB auto mounted? where to?
How is that related to overlay?

> > so I just treat this config option as "paranoia" or "don't give me anything that
> > very old overlay did not give me".
> > Therefore I suggested piggybacking on it.
>
> Even if it is paranoia, put more unrelated checks under this option does
> not make much sense to me. It will make things just more confusing.
>
> Anyway, redirect_dir=nofollow is a thing of past. Now if you want to
> not follow origin, then we first need to have a genuine explanation
> of why to do that (and not be driven by just paranoia).
>
> > Of course if we do, we will need to document that.
>
> redirect_dir=nofollow resulting in origin not being followed is plain
> unintuitive to me. Why not introduce another option if not following
> origin is so important.
>

Because cluttering the user with more and more config options for
minor and mostly unimportant behaviors is not ideal either.
See what Kconfig help has to say about the config option:

config OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW
        bool "Overlayfs: follow redirects even if redirects are turned off"
        default y

       Disable this to get a possibly more secure configuration, but that
       might not be backward compatible with previous kernels.

That is a VERY generic description that fits not following origin very
well IMO, and not following unverified dir origin as well for that matter.
Nobody outside overlayfs developers knows what "redirects" means
anyway. To me, following non-dir origin sounds exactly the same
as following non-dir metacopy redirect or dir redirect. It's just the
implementation details that differ.

So my claim is that we *can* piggyback on it because I really
don't believe anybody is using this config out there for anything
other than "to be on the safe side".

But I do not make the calls here and it doesn't look like I managed
to convince you to take my side of the argument :-)

Thanks,
Amir.
