Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D686C43460
	for <linux-unionfs@archiver.kernel.org>; Mon, 26 Apr 2021 10:15:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EF796135B
	for <linux-unionfs@archiver.kernel.org>; Mon, 26 Apr 2021 10:15:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232266AbhDZKP7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 26 Apr 2021 06:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232103AbhDZKP7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 26 Apr 2021 06:15:59 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF926C061574;
        Mon, 26 Apr 2021 03:15:16 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id l21so12182363iob.1;
        Mon, 26 Apr 2021 03:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ysVDzww8BP9qPYsIeMfo+xmyckmmnpBhwROzj6XbrNQ=;
        b=ndTV9KtLxJitfAUOzSmL7hDo2fv1Qn1wa4Aa+N6Ri9gV0khbiKe0CfiaMsRonLYK4W
         qz6cDjM/WTWNgKE68cOPRNLVkP+IGvGpANQiCo247ErpntE1U7Dw7wh554U/qGw0SakF
         sJSqttXLxp0Vom+5l45y9w+N/HaMJUvNcFQCxCODD3Wql/56UnlxPZT/S4KSaX7Mud6F
         tSH4yGUaWB8W1DPgG8B5Ep/nTcO2fsyceEB1scO3xvK5aj5OWlohuCttInNISzqJ7gNC
         keJ824uwtroITjt5RRS8r9IQqhdGzc3sh3lGIEfCk8bxUD9E5OEm5ZW1MSkYZF7Zk4YU
         xYeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ysVDzww8BP9qPYsIeMfo+xmyckmmnpBhwROzj6XbrNQ=;
        b=lrynoVFy4kWHdJraxm3EzDOAFekE2mYLKp8ac57VIJ2WpwhXKd1X6jEj7FXeNc3WQj
         Gai1LWFaUzoxkD/uiotmi94ZgTDwxET63VAFiel4dGIm+FsJX4OqPdFng/xxMRiw1mUX
         2QBsS6MPFi8VLNIN10muAih/EYJmyVsEnwKPinDtiOriVQNK9EqHDROH6BoBlEmaE0bC
         8H8Seccuj26fsBtzW3WgDYIngc07BTMcFfCmAhLCrkchgIjiMLpgBXoxPJzV8DkT5F/i
         3hCrv/9NF/hOVv3IPKt6iC7dm2b65plx7Bu2gkIO8pdlEq5Yna4QgH/Dv6Nx0jaoQ/iz
         3ZXQ==
X-Gm-Message-State: AOAM530ezwkbVrXdEhI6ItaCn8bdfzmU/EaScKQixyTbnxCs3s26Gi8W
        xPBJnMGLCIu2PbysjNsssqZfFXHAmWnYQvZ5PBk=
X-Google-Smtp-Source: ABdhPJySvNm2fmNy1YxbZzvVlxVCKQIb01e2an+V4raFeWsfZuFnp1Md03Wa+bZj7BQBtsgJPSyJEhc6CQbxuStuZuE=
X-Received: by 2002:a6b:f115:: with SMTP id e21mr13688101iog.5.1619432116264;
 Mon, 26 Apr 2021 03:15:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210425071445.29547-1-amir73il@gmail.com> <CAJfpeguHn32-BJV=986963SCGs8RwBN+fMEfRdwc1d_LFecFxw@mail.gmail.com>
In-Reply-To: <CAJfpeguHn32-BJV=986963SCGs8RwBN+fMEfRdwc1d_LFecFxw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 26 Apr 2021 13:15:05 +0300
Message-ID: <CAOQ4uxiEx-KcMYdfM9yLygvD5eYgs_58kOvr0NabKqgpB0ybug@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] Test overlayfs readdir cache
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Apr 26, 2021 at 1:07 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Sun, Apr 25, 2021 at 9:14 AM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > Eryu,
> >
> > This extends the generic t_dir_offset2 helper program to verify
> > some cases of missing/stale entries and adds a new generic test which
> > passes on overlayfs (and other fs) on upstream kernel.
> >
> > The overlayfs specific test fails on upstream kernel and the fix commit
> > is currently in linux-next.  As usual, you may want to wait with merging
> > until the fix commit hits upstream.
> >
> > Based on feedback from Miklos, I changed the test to check for the
> > missing/stale entries on a new fd, while old fd is kept open, because
> > POSIX allows for stale/missing entries in the old fd.
> >
> > I was looking into another speculated bug in overlayfs which involves
> > multiple calls to getdents.  Although it turned out that overlayfs does
> > not have the speculated bug, I left both generic and overlay test with
> > multiple calls to getdents in order to excersize the relevant code.
> >
> > The attached patch was used to verify that the overlayfs test excercises
> > the call to ovl_cache_update_ino() with stale entries.
> > Overlayfs populates the merge dir readdir cache with a list of files in
> > the first getdents call, but updates d_ino of files on the list in
> > subsequent getdents calls.  By that time, the last entry is stale and the
> > following warning is printed (on linux-next with patch below applied):
> > [   ] overlayfs: failed to look up (m100) for ino (0)
> > [   ] overlayfs: failed to look up (f100) for ino (0)
> >
> > Miklos,
> >
> > Do you think it is worth the trouble to set p->is_whiteout and skip
> > dir_emit() in this case? and do we need to worry about lookup_one_len()
> > returning -ENOENT in this case?
>
> So lookup_one_len() first does a cached lookup, and if found returns
> that.  If not then it calls the filesystem's ->lookup() callback,
> which in this case is ovl_lookup().  AFAICS ovl_lookup() will never
> return ENOENT, even if the underlying filesystem does.
>
> Which means it's not necessary to worry about that case.
>
> The other case you found it that in case of a stale direntry the i_ino
> update will be skipped and so it will return an inconsistent result,
> right?

Right. It returns a stale entry with the old real ino.
Not sure if that is an "inconsistent" result.
inconsistent w.r.t what?

> Fixing that looks worthwhile, yes.
>

Will look into it.

Thanks,
Amir.
