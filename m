Return-Path: <SRS0=do5T=BW=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 399A1C433E0
	for <linux-unionfs@archiver.kernel.org>; Wed, 12 Aug 2020 17:06:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E42F2076C
	for <linux-unionfs@archiver.kernel.org>; Wed, 12 Aug 2020 17:06:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BPh+2E5O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgHLRGr (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 12 Aug 2020 13:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726459AbgHLRGr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 12 Aug 2020 13:06:47 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D02AAC061383
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Aug 2020 10:06:46 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id q14so2504876ilj.8
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Aug 2020 10:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K87qVExCKnPcYPLmX/GguPBrMGVp+colxV/5UJKXp4E=;
        b=BPh+2E5Op5/GBM0yW6CA12XkeufxH6Pt6onmclgWKFSoDBVFcAyacmsH69wGmKw+M3
         EqK+e1IjUqCavNCczJemn7sZiT+rQIietkUm2n/v7YP50s3jSWnQ3nCjAkVYsAV2ijLh
         i2e9ce2x3q5aI7ftf3ImCipX9QRIMmTLkUN8aEDN6ClXPsjrKkCvRh88S7Bl7ZTE0mGD
         +Jk8vZve12SNNvS/EEgS5VgdcWliM3wyq8pLgVGv9Oif0sSGfx8BHzBmFxuz+rm6uX8T
         KzzOQIusRBGm3jI1p/W+Mnun/KN9CJnwNEQ2LtjobLAoKL1V12GbIB0fzHxsOujyzBMN
         7xTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K87qVExCKnPcYPLmX/GguPBrMGVp+colxV/5UJKXp4E=;
        b=T+3JRS7ogfkPH8kHrFWqCMFggDr/ILzaFjYIgGYs/w0TP1Hex4caOZFymkYfGXhYBq
         tl7jJ7MvGirPBQAB+UIisfuFrrXpElKCISP+GhIcc+pOBBU7SnaAeRs3P2yz3LEE0tc0
         +DXnCoOa7F/1Ein4AhpRbQUnYGj9f9bxcvLPilR24ioMsiIfcnbsRLdGbUJ7bvhP2s7u
         DTWbp7aUtFUq72UotoKMjWu+3rIPzY1o6nDNXJ53Rrq4mu+qZ7w8uC91soTH4JWDnGTr
         cJIOYVcI+zkYhb4a6o7hwTZSjZyzg3KwNjdH5KgGYtxbjKQJ8PVV26ZHGv47YONV/YYO
         6guw==
X-Gm-Message-State: AOAM532phbiZz+fN251QhO3eFEcTZnU+QUZ7mxdCKjU+agrSEhve435a
        ybXi2BgBcueqDWC60hODYZjw6LB1sdkNR73hhF0=
X-Google-Smtp-Source: ABdhPJwiJH3C3Ra6dW+R1jl+AAGfAT3lp0IWb5OdgSYbrPCpgZJ6OtxTFJDECV+Qc6Q6uROqxWoIo2+eSAruKyUadXw=
X-Received: by 2002:a92:2810:: with SMTP id l16mr623798ilf.9.1597252005843;
 Wed, 12 Aug 2020 10:06:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200812135529.GA122370@kevinolos> <CAOQ4uxih2aDb7_LPSUb5Q4xBL5_gDaqtmC0M0M4EtCDgKLvi3w@mail.gmail.com>
 <20200812160513.GA249458@kevinolos>
In-Reply-To: <20200812160513.GA249458@kevinolos>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 12 Aug 2020 20:06:34 +0300
Message-ID: <CAOQ4uxi23Zsmfb4rCed1n=On0NNA5KZD74jjjeyz+et32sk-gg@mail.gmail.com>
Subject: Re: EIO for removed redirected files?
To:     Kevin Locke <kevin@kevinlocke.name>,
        Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Aug 12, 2020 at 7:05 PM Kevin Locke <kevin@kevinlocke.name> wrote:
>
> Thanks for the quick response Amir!
>
> On Wed, 2020-08-12 at 18:21 +0300, Amir Goldstein wrote:
> > On Wed, Aug 12, 2020 at 5:06 PM Kevin Locke <kevin@kevinlocke.name> wrote:
> >> I recently encountered files on an overlayfs which returned EIO
> >> (Input/output error) for open, stat, and unlink (and presumably other)
> >> syscalls.  I eventually determined that the files had been redirected
> >
> > It's *empty* redirected files that cause the alleged problem.
>
> When I replace `touch foo.txt` with `echo 123 > foo.txt` I observe the
> same behavior.  If I understand you correctly, you are saying that EIO
> is correct for non-empty files, but potentially incorrect for empty
> files (which could be copied rather than redirected, since there is no
> space saving)?
>

I wouldn't call it "incorrect" more like "unnecessary".

> >> At this point, the only way to recover appears to be unmounting the
> >> overlay and removing the file from upper (or updating the
> >> overlay.redirect xattr to a valid location).  Is that correct?
> >>
> >> Is this the intended behavior?
> >
> > Yes.
> > What would you expect to happen when data of metacopy file has been removed?
>
> After reflection, EIO probably makes the most sense for open/stat.  It
> might be nice to be able to unlink the file to allow recovery (in the
> sense of being able to reuse the name) without unmounting the overlay,

It would be nice, but somebody needs to care enough to implement it
and it is not going to be trivial, because error on lookup is much easier
then selective error on a "broken" dentry depending on the operation...

> but the documentation updates may be sufficient to keep users from
> getting into this state.
>
> >> unionmount-testsuite.  If so, perhaps the behavior could be noted in
> >> "Changes to underlying filesystems" in
> >> Documentation/filesystems/overlayfs.rst?  I'd be willing to write a
> >> first draft.  (I doubt I understand it well enough to get everything
> >> right on the first try.)
> >
> > I guess the only thing we could document is that changes to underlying
> > layers with metacopy and redirects have undefined results.
> > Vivek was a proponent of making the statements about outcome of
> > changes to underlying layers sound more harsh.
>
> That sounds good to me.  My current use case involves offline changes to
> the lower layer on a routine basis, and I interpreted the current

You are not the only one, I hear of many users that do that, but nobody ever
bothered to sit down and document the requirements - what exactly is the
use case and what is the expected outcome.

> wording "Offline changes, when the overlay is not mounted, are allowed
> to either the upper or the lower trees." to mean that such offline
> modifications would not break things in unexpected ways.
>

The truth is that this documentation is old, before all the new features
were added. See here [1], Vivek suggested:
"Modifying/recreating lower layer only works when
 metacopy/index/nfs_export are not enabled at any point of time. This
 also will change inode number reporting behavior."

> In retrospect, I should have expected this behavior, but as someone
> previously unfamiliar with overlayfs, I hadn't considered that metacopy
> results in file redirects and that if the underlying file were removed
> without removing any redirects pointing to it that it would manifest in
> this way and be so difficult to clean up.
>
> If metacopy and dir_redirect are disabled, are offline modifications to
> the lower layer permitted, or could any such modification result in
> undefined behavior?
>

With metacopy/index/nfs_export/redirect_dir disabled code behaves mostly
like it did at the time that this documentation was written, so I guess you may
say that changes are permitted and result in "defined" behavior.

> >> Also, if there is any way this could be made easier to debug, it might
> >> be helpful for users, particularly newbies like myself.  Perhaps logging
> >> bad redirects at KERN_ERR?  If that would be too noisy, perhaps only
> >> behind a debug module option?  Again, if this is acceptable I'd be
> >> willing to draft a patch.  (Same caveat as above.)
> >
> > There are a handful of places in overlayfs where returning EIO is
> > combined with informative pr_warn_ratelimited().
>
> Ah, indeed.  Would doing so for missing/invalid metacopy/redirect make
> sense?
>

It seems fine to me.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-unionfs/20200708173601.GD103536@redhat.com/T/#m75db6db2fc8d9739ce6fed9dfebe81bb1dd53bf9
