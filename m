Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB55C433ED
	for <linux-unionfs@archiver.kernel.org>; Fri, 23 Apr 2021 10:21:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AE8D61445
	for <linux-unionfs@archiver.kernel.org>; Fri, 23 Apr 2021 10:21:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236059AbhDWKVi (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 23 Apr 2021 06:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhDWKVi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 23 Apr 2021 06:21:38 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D0BC061574;
        Fri, 23 Apr 2021 03:21:02 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id l21so5198358iob.1;
        Fri, 23 Apr 2021 03:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LI1uEIPaDv1tYtFJMR8Owm4Ez9505mm/YkjCYTUeYH8=;
        b=Oa3h9uoob1mQQXLqIXzpRwEWbEKf7MXVR9IPncUHP2i5bxhYRamrDHZvJmbgsH9N56
         IaGw57N3hFzbBNMlZ0BLQEFOJAXAkmVMwbqmW6zLZ2irrKYIiJEiA35hluwW0jAy9MpL
         egVDtmU/rYDtXbb/ohTOtJ97pgslr7k52clQloRf+GGkLZicEtNqmWkc61mVOMyzMJv4
         /auzhQ14ZBpya1/z5PUNAAiyHnlLyDhxgU7NC5mYKMWd/pN0vGhminY8yWBSIhxwF2Ik
         iFqYMQ7h202/iZS0q27Ky1ks513zPaHDZrdxWB26QeTrBsoNbNJYQwKIF+TguZUITu5S
         q72w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LI1uEIPaDv1tYtFJMR8Owm4Ez9505mm/YkjCYTUeYH8=;
        b=EauHrKfoVDWTf1WMRuhxFmX2gpcVZR/QigI5Zqq9ciO2s0GSet6XNsKzHcG8Tt+OqY
         oWHVj3nZoDHSjfXxbawgmdK8PHuhPpjWpUlif23m+8bfI4QZ5WCE9ilS+D/T/WaJATOC
         EAMr9v6qX4k8g9uUzdOhxgXZQN0fmrvl0nCEs5jGADPQVJWnybQBp3oPf/RlZWOCdOnC
         6PFW5xX4cI9SLKfn/igs1AQ/7DFti0wBxh0L2Ng7ojM7ABJvnfMiBYA3U5aR08PG0PSP
         Dis0+twqUPZCH+FQs/gV04Fbb2icbcnj8MWYjyBzMwERzUMt18gJ48EWqwiLZRscGUhx
         LDNg==
X-Gm-Message-State: AOAM533AEzftjHHA9ZdEk+jgJoEuQQx604r7SIAvPKXrGCiovgwQ5LpG
        Nt4Bvml+Hk8PgRuNa4CdkiXYFk9ghYOCIhJSNv4=
X-Google-Smtp-Source: ABdhPJwoA56JUQ4V8xAwZkg9nsa9IGW95/edBYE4zEbbJTjqEucd0Mmjeeiuw5xTO7c5FVWDUFTjbhm0dBPzwOP5NgI=
X-Received: by 2002:a05:6638:dc2:: with SMTP id m2mr2929837jaj.123.1619173261545;
 Fri, 23 Apr 2021 03:21:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210421092317.68716-1-amir73il@gmail.com> <CAOQ4uxhh305WPZ-puLONej2TLQTe54-FUtrsgp2R8ohdDcNP0A@mail.gmail.com>
 <CAJfpegtoTJRnNQnttVw54pndEqrpzfxttp=NCQ_2za859fWMqA@mail.gmail.com>
In-Reply-To: <CAJfpegtoTJRnNQnttVw54pndEqrpzfxttp=NCQ_2za859fWMqA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 23 Apr 2021 13:20:50 +0300
Message-ID: <CAOQ4uxh7jaSZA01b1cgEpn4=KkgjzN5X4CfELNtbqsRjLvct=g@mail.gmail.com>
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

That makes the test I posted wrong, because it expects the
dir modifications to be visible after seek to 0.

The thing is, unlike readdir(3) implementation, overlayfs keeps the
readdir cache on the inode, so by keeping the original fd open
and opening a new fd, I could reproduce stale and missing entries
for a new opendir, which is definitely a bug.

Will post the updated test.

Thanks,
Amir.
