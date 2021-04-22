Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABA6AC43460
	for <linux-unionfs@archiver.kernel.org>; Thu, 22 Apr 2021 07:53:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 845796145C
	for <linux-unionfs@archiver.kernel.org>; Thu, 22 Apr 2021 07:53:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235160AbhDVHx7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 22 Apr 2021 03:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235156AbhDVHx6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 22 Apr 2021 03:53:58 -0400
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC93C06138B
        for <linux-unionfs@vger.kernel.org>; Thu, 22 Apr 2021 00:53:22 -0700 (PDT)
Received: by mail-vk1-xa2f.google.com with SMTP id h130so4373226vkh.11
        for <linux-unionfs@vger.kernel.org>; Thu, 22 Apr 2021 00:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f3L6OFLFVKmSBwUD5MZIeckeBluD+yaeY0hIVTa96o4=;
        b=FShTQqsOWV+L7QsQLW+wve3/xiQ5YVx0WCBJxz9jHSj+ZUK6uYKlC8lZXB3qtGJqD7
         z2u+CGKUeKClPYzKFOg9hgKczHGN14ZNBETaznJlf9aZjnBVx2WymvvAh5Mefl4HWSDT
         ZxC5SMxcr9GJFJuV9hn2iMok1QxC4LlKPYM6o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f3L6OFLFVKmSBwUD5MZIeckeBluD+yaeY0hIVTa96o4=;
        b=BgHJbyHL/aPj9k3UVosiDGwygW39h5wfKE5f4URXLBSDC7i9cN7otYtKzPFRmfmMfR
         OVdES65iLeGhNCzEyke5OIgY8V3cCilYTVjnlEOIpGMXWb8ZkDTYr6E14CEwFIQEYxDr
         vcyAbWpBViCY1URe3FtZeLDCfS85Q+haqvkZAkWsAhrPYdEJcOqZnhIYBFE0ynas6/iR
         kQYezrVesFk7rjnFCPIDN3mkWSYlPByTZdePCeFdeItt2DcjwlOJlIbWGZH2XwtNNuNk
         nzpMQKzP+0yby1JVzPWIxWKGawE43E3RDtVDvq0xLvVP2UpkCmw2NzsOHHOlFJwAw11A
         22PA==
X-Gm-Message-State: AOAM530XFlhAH6xC+Nz0lInsA0JrkhwlqhiXtJMo37Miz7s/GeAQlnyS
        9ooX7ZIzHPV5n3SJ3Jy+8WhwhUBQlrGVpAecF6J0MA==
X-Google-Smtp-Source: ABdhPJzKuU3DSytjKjNvR7vWTl2gVbBxnWaI5urjwTPTuJe0j985K2xEBgQQZtAlxyox/2CD48Q3bcarvYpExGLow8w=
X-Received: by 2002:ac5:cb50:: with SMTP id s16mr1320490vkl.14.1619077999544;
 Thu, 22 Apr 2021 00:53:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210421092317.68716-1-amir73il@gmail.com> <CAOQ4uxhh305WPZ-puLONej2TLQTe54-FUtrsgp2R8ohdDcNP0A@mail.gmail.com>
In-Reply-To: <CAOQ4uxhh305WPZ-puLONej2TLQTe54-FUtrsgp2R8ohdDcNP0A@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 22 Apr 2021 09:53:08 +0200
Message-ID: <CAJfpegtoTJRnNQnttVw54pndEqrpzfxttp=NCQ_2za859fWMqA@mail.gmail.com>
Subject: Re: [PATCH 0/2] Test overlayfs readdir cache
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Apr 22, 2021 at 8:18 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Wed, Apr 21, 2021 at 12:23 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > Eryu,
> >
> > This extends the generic t_dir_offset2 test to verify
> > some more test cases and adds a new generic test which
> > passes on overlayfs (and other fs) on upstream kernel.
> >
> > The overlayfs specific test fails on upstream kernel
> > and the fix commit is currently in linux-next.
> > As usual, you may want to wait with merging until the fix
> > commit hits upstream.
> >
> > Miklos,
> >
> > I had noticed in the test full logs that readdir of
> > a merged dir behaves strangely - when seeking backwards
> > to offsets > 0, readdir returns unlinked entries in results.
> > The test does not fail on that behavior because the test
> > only asserts that this is not allowed after seek to offset 0.
> >
> > Knowing the implementation of overlayfs readdir cache this is
> > not surprising to me, but I wonder if this behavior is POSIX
> > compliant, and if not, whether we should document it and/or
> > add a failing test for it.
> >
>
> I think the outcome could be worse.
> If a copied up entry is unlinked after populating the dir cache
> but before ovl_cache_update_ino() then ovl_cache_update_ino()
> and subsequently the getdents call will fail with ENOENT.
>
> This test is not smart enough to cover this case (if it really exists).
> I think we need to relax the case of negative lookup result in
> ovl_cache_update_ino() and just set p->whiteout without and
> continue with no error.
>
> This can solve several test cases.
> In principle, we can "semi-reset" the merge dir cache if the dir was
> modified after every seek, not just seek to 0.
> By "semi-reset" I mean use the list, but force ovl_cache_update_ino()
> to all upper entries, similar to ovl_dir_read_impure().
>
> OR.. we can just do that unconditionally in ovl_iterate().
> The ovl dentry cache for the children will be populated after the first
> ovl_iterate() anyway, so maybe the penalty is not so bad?

POSIX does allow stale readdir data (not just in case of non-zero seek):

"If a file is removed from or added to the directory after the most
recent call to opendir() or rewinddir(), whether a subsequent call to
readdir() returns an entry for that file is unspecified."

If you think about the way readdir(3) is implemented by the libc, this
is inevitable.

Returning ENOENT from readdir(3) is obviously a bug.

The merge case being not super high performance is perfectly okay.
The only thing I've worried about in that case is unbound memory use,
but apparently that hasn't been an issue in practice.

Thanks,
Miklos
