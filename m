Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF4E8C433B4
	for <linux-unionfs@archiver.kernel.org>; Sat, 10 Apr 2021 17:36:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C1D0610A4
	for <linux-unionfs@archiver.kernel.org>; Sat, 10 Apr 2021 17:36:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234879AbhDJRgi (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 10 Apr 2021 13:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234513AbhDJRgi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 10 Apr 2021 13:36:38 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79E4C06138A
        for <linux-unionfs@vger.kernel.org>; Sat, 10 Apr 2021 10:36:21 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id w4so4953865wrt.5
        for <linux-unionfs@vger.kernel.org>; Sat, 10 Apr 2021 10:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jhm4jac+LlkZkHJhaVWxMaO7C1pE7y6tVLm9Nc9lhFY=;
        b=gpnAiUHxqYfHsGJmiaPN7S4EzPbpEkoE6BevcViiKvluGcXRLtV1i7TxfUcEDSHQvK
         RNQ+DIXkiOF6tbvznS1jvC50VNW3qK9MbgvJkXSNPZkAohTpG0aQB737lKsQI+GPjtDL
         Vva0lRco526X/4f8a6pTyxTMXUS5VB/C+Ik1aS2dN2Ud0r39KO9dKtrPrt35n+/vJVDL
         lUI0TN9+cC9sxe8Yv+n00oPp+Ew7e8nObbSVgL+Jwim7eTw/Q2p+C4gB4n6vNlfCNzzt
         n0tbgypSD+I8OFb4k8eDbUs/1hwK4/+Qfmy4ROzMtbpEuanW+J3zj0D8l05Id7fyHe/0
         iYoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jhm4jac+LlkZkHJhaVWxMaO7C1pE7y6tVLm9Nc9lhFY=;
        b=RXz+mDyBLIwwx4jmu36Kc9ym7LqGw+Ox293sX1NVY2zzh8klZdQ3v59tyQfhvOJzYN
         Lf7nm/FOcwZZVXI2swoH6I/ac03s7YdFptE9bAOXLbz5pBM13MBI7TLKSn3jf9WqfenG
         vhfXTL7m5z2g6lXVDkbl43Jm3H7tc0LbyKrSR3N4Ks669CSUuLCNl6nbcVq8LvDSYxDR
         VXJBKwdxLLa64+pzBfC/qZKTb+885bJyVXuGsPUs60fofm39UIWu+KJvfZTjIiHHi34g
         Urk0NQV97O/89xoZeyi5cl1wVKRzqVEXKOKYyHX1JuqZk0CkV5WSrO4kJlxs4Ro3zV7Z
         +E5g==
X-Gm-Message-State: AOAM533U/hffK0bmxtnC0tc1nue164v0FGfeorNCmUHzDUg1R+ctRkEJ
        L5Daww7813Ib9esQrUxJNfgHdDs/shQK04tuaKMXrQ==
X-Google-Smtp-Source: ABdhPJyp/VO1W1jqT56vtB3cYwFUtcBwHEY+Np+VvxWBpIwHCtHx/mWPDNS2xqmJXcqvZitj+G9Hidug3UREygl1Ijg=
X-Received: by 2002:adf:d84d:: with SMTP id k13mr23357716wrl.65.1618076180517;
 Sat, 10 Apr 2021 10:36:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAJCQCtTp0aXBssEr4ZXGX=DS_+RyGghmoANCKDdxG59QWu8LVA@mail.gmail.com>
 <CAOQ4uxht70nODhNHNwGFMSqDyOKLXOKrY0H6g849os4BQ7cokA@mail.gmail.com>
In-Reply-To: <CAOQ4uxht70nODhNHNwGFMSqDyOKLXOKrY0H6g849os4BQ7cokA@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sat, 10 Apr 2021 11:36:04 -0600
Message-ID: <CAJCQCtRGdBzyskifrYLbBGAAm0g7VeC6GeD7xBN-hRqE3GAWYA@mail.gmail.com>
Subject: Re: btrfs+overlayfs: upper fs does not support xattr, falling back to
 index=off and metacopy=off.
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chris Murphy <lists@colorremedies.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

I can reproduce the bolt testcase problem in a podman container, with
overlay driver, using ext4, xfs, and btrfs. So I think I can drop
linux-btrfs@ from this thread.

Also I can reproduce the title of this thread simply by 'podman system
reset' and see the kernel messages before doing the actual reset. I
have a strace here of what it's doing:

https://drive.google.com/file/d/1L9lEm5n4-d9qemgCq3ijqoBstM-PP1By/view?usp=sharing

It may be something intentional. The failing testcase,
:../tests/test-common.c:1413:test_io_dir_is_empty also has more
instances of this line, but I don't know they are related. So I'll
keep looking into that.


On Sat, Apr 10, 2021 at 2:04 AM Amir Goldstein <amir73il@gmail.com> wrote:

> As the first step, can you try the suggested fix to ovl_dentry_version_inc()
> and/or adding the missing pr_debug() and including those prints in
> your report?

I'll work with bolt upstream and try to further narrow down when it is
and isn't happening.

> > I can reproduce this with 5.12.0-0.rc6.184.fc35.x86_64+debug and at
> > approximately the same time I see one, sometimes more, kernel
> > messages:
> >
> > [ 6295.379283] overlayfs: upper fs does not support xattr, falling
> > back to index=off and metacopy=off.
> >
>
> Can you say why there is no xattr support?

I'm not sure. It could be podman specific or fuse-overlayfs related.
Maybe something is using /tmp in one case and not another for some
reason?

> Is the overlayfs mount executed without privileges to create trusted.* xattrs?
> The answer to that may be the key to understanding the bug.

Yep. I think tmpfs supports xattr but not user xattr? And this example
is rootless podman, so it's all unprivileged.


> My guess is it has to do with changes related to mounting overlayfs
> inside userns, but I couldn't find any immediate suspects.
>
> Do you have any idea since when the regression appeared?
> A bisect would have been helpful here.

Yep. All good ideas. Thanks for the fast reply. I'll report back once
this has been narrowed down futher.


-- 
Chris Murphy
