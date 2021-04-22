Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE8CC43460
	for <linux-unionfs@archiver.kernel.org>; Thu, 22 Apr 2021 06:18:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 838FA61437
	for <linux-unionfs@archiver.kernel.org>; Thu, 22 Apr 2021 06:18:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234734AbhDVGTM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 22 Apr 2021 02:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhDVGTI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 22 Apr 2021 02:19:08 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FBE7C06174A;
        Wed, 21 Apr 2021 23:18:28 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id p15so1130826iln.3;
        Wed, 21 Apr 2021 23:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bD9O8L1ftXdmtIJjkY6MHCIYIzUDY+SMfWVrJmOhq20=;
        b=CG/On5BNhOkmJxgfbdGh3W4y1Nxr57ehHqXlN2rvOUvFKF89JZK2U7V5nPPmvVCrjb
         Rp/52IaaN1eZOrwT5etzH4WqLK/fVNCe/iRle7yVOyCgx0+G9zAUhmeN5kRgv8xmNbcx
         CrI8dBYEr1pXbTtu4puFa7gZO0Iig4fQqHJfCsvP4A+KmkRQxJuh8d97A2RtBCzPi+Py
         jI0IM8Ed9fHhrJ5jkbHZwoNijt5Jevf2aKr2UBzYl30Km7m8ZVGFSHND7FUIO/p4NzxV
         Wnr8iOA7U5+/+4QrOSuSM/9npIWKlNwPpJs5OtMwHIzhi84FNRo5dpQcbPeaYPUmWQvh
         lWmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bD9O8L1ftXdmtIJjkY6MHCIYIzUDY+SMfWVrJmOhq20=;
        b=F8xkhW3p/41+7sRa9lDIjO2ckHpERi/RUxu4GyVJvbK+skdoZMYKPFiTfpff4y1n7F
         A8AkQMRJAW6huoJu4z0wYaw8+ccBLy4FFGEYOjlVaRVqFRqRU7oh+4Y0ReaVYgsixyKz
         1Uri+F+nGY0B9vJ9TmCTMJoRkY9/iGDTMYoDWDCxBml+ysIhFgoksrB4ImPmc8J8mj8P
         kpfgySsBDCHwTLQvWBSu6u5RH0yAdnWZgWPaSmkgimF2RHcr7s6mi1lDtajySDXJj1AC
         NBdy05bj/hpoto+w/s4eo7pQlD8mpWI/uNoYVOtfqkmUf8JK9RH2eszqXjlLmvEosv/B
         5vng==
X-Gm-Message-State: AOAM532PibrDhAHWzK9oNQBkuosOTnIIuQE1spq1bZ/DfORvuGDjb17+
        CtFbUXxbvM8N3rdVN9FalZDS6TtbdGUeOjpF9sA=
X-Google-Smtp-Source: ABdhPJwg0evA2cDTreoqRL5HKZkppmcpQZD9OeEbw5+gnGxCxw2fhF02soyX7l+L3cnNqCt7T6frdUeNYCtKxt1Qkpo=
X-Received: by 2002:a92:c548:: with SMTP id a8mr1375208ilj.137.1619072307915;
 Wed, 21 Apr 2021 23:18:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210421092317.68716-1-amir73il@gmail.com>
In-Reply-To: <20210421092317.68716-1-amir73il@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 22 Apr 2021 09:18:16 +0300
Message-ID: <CAOQ4uxhh305WPZ-puLONej2TLQTe54-FUtrsgp2R8ohdDcNP0A@mail.gmail.com>
Subject: Re: [PATCH 0/2] Test overlayfs readdir cache
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Apr 21, 2021 at 12:23 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Eryu,
>
> This extends the generic t_dir_offset2 test to verify
> some more test cases and adds a new generic test which
> passes on overlayfs (and other fs) on upstream kernel.
>
> The overlayfs specific test fails on upstream kernel
> and the fix commit is currently in linux-next.
> As usual, you may want to wait with merging until the fix
> commit hits upstream.
>
> Miklos,
>
> I had noticed in the test full logs that readdir of
> a merged dir behaves strangely - when seeking backwards
> to offsets > 0, readdir returns unlinked entries in results.
> The test does not fail on that behavior because the test
> only asserts that this is not allowed after seek to offset 0.
>
> Knowing the implementation of overlayfs readdir cache this is
> not surprising to me, but I wonder if this behavior is POSIX
> compliant, and if not, whether we should document it and/or
> add a failing test for it.
>

I think the outcome could be worse.
If a copied up entry is unlinked after populating the dir cache
but before ovl_cache_update_ino() then ovl_cache_update_ino()
and subsequently the getdents call will fail with ENOENT.

This test is not smart enough to cover this case (if it really exists).
I think we need to relax the case of negative lookup result in
ovl_cache_update_ino() and just set p->whiteout without and
continue with no error.

This can solve several test cases.
In principle, we can "semi-reset" the merge dir cache if the dir was
modified after every seek, not just seek to 0.
By "semi-reset" I mean use the list, but force ovl_cache_update_ino()
to all upper entries, similar to ovl_dir_read_impure().

OR.. we can just do that unconditionally in ovl_iterate().
The ovl dentry cache for the children will be populated after the first
ovl_iterate() anyway, so maybe the penalty is not so bad?

Thanks,
Amir.
