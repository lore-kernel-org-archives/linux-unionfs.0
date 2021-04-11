Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2793C433B4
	for <linux-unionfs@archiver.kernel.org>; Sun, 11 Apr 2021 04:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC60A6023B
	for <linux-unionfs@archiver.kernel.org>; Sun, 11 Apr 2021 04:45:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbhDKEqJ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 11 Apr 2021 00:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbhDKEqI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 11 Apr 2021 00:46:08 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C633C06138B
        for <linux-unionfs@vger.kernel.org>; Sat, 10 Apr 2021 21:45:53 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id x16so10033830iob.1
        for <linux-unionfs@vger.kernel.org>; Sat, 10 Apr 2021 21:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dtL3TJLjMpAv30kcyW6LafoNo9Yd64B6mh0FeHgimVg=;
        b=kBHT3XaFUPgU54gq9zwSShTx7cniQe//fDkxd0FmLP/VoNd8gVVid05Wlv7PxmHlLn
         wsXnrBLidrmhV92Tw2d3Ffv2RU7DyY+AMuEwBzevYf4u985FUKTzWSpECCSX3aTHIR5d
         Giaso1t+CUyrK7UQsKfbg1RtDY58wuj34kGpfzOgaJ3mZXf9gkdySFU7NpuBgzzLV1m1
         If8HUXUdT/V39CIwVP3tyT9uyEDQAydJx6tN6eBqO1rBlQs9Xg8OvTroz2hZrgABofcR
         qsfYzF1tSCvxrIItOqq/Ky57kNCfnYhaENTTW1EnUYzMF2irQhBFUQnZ3gw7shlNFEhO
         arfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dtL3TJLjMpAv30kcyW6LafoNo9Yd64B6mh0FeHgimVg=;
        b=gGIGCVup0n5usY+wMNW0D71FwJG48fs5LpsS+CKpFwLcM6G66Vvr2j7aHYMrqdbHi0
         PIljyvqOYSmDxHlQIO0SgSXAcFn1bbXL6T2QS0nVghnN/igZ2QIVhfRCfaGYS+BIEWK/
         bv5enKrIDXor/MGwzEe4mRUbS3MYMBXY3QHAnGihZSRIGSUVdcdJYcvBAuB/VNVR/1Tl
         KdAgOHP1+/v0pcUCt51x4HLAUYk2I9pjWDQlrM3QxRYPaNA5BmP6e4jWy5X+0zMF6AH7
         sStI2Y9CmzsljzfIzuiKvOmBfHldGZBPflE+q2RFySZJKlW0yFB47R/AdMMKozkz7Zx6
         Zqfg==
X-Gm-Message-State: AOAM531zrWrTt/MFrqzhp4jPQVBe/r20lU7BOoU6OTFqr1zYBa85BfhB
        vNP/YnfDatl8aC0kai2+/hBNeh/qLFN0q4TojwnNYqas
X-Google-Smtp-Source: ABdhPJyw9YMSz8ZkjDHgs3uvq+G57C4z3wkuurz7HHXa9ni+KC/qFpEiPdk0gd+edj2YfzpJrPWSQh4BClp/ULPTi20=
X-Received: by 2002:a02:b615:: with SMTP id h21mr22428247jam.93.1618116352741;
 Sat, 10 Apr 2021 21:45:52 -0700 (PDT)
MIME-Version: 1.0
References: <606F526A.1040405@tlinx.org> <CAOQ4uxj4bdzcdcy7jpkRCZTNv=4b8BPVVP+1L_3OLWFwMnV-kQ@mail.gmail.com>
 <6071FDE0.2070009@tlinx.org>
In-Reply-To: <6071FDE0.2070009@tlinx.org>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 11 Apr 2021 07:45:41 +0300
Message-ID: <CAOQ4uxhw+a7NFpAiqVC9pZNSaWh+-RPsv2okym3UNOo=mGGC6Q@mail.gmail.com>
Subject: Re: odd error: why: mount: /home2: mount(2) system call failed: Stale
 file handle
To:     L A Walsh <lkml@tlinx.org>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Apr 10, 2021 at 10:34 PM L A Walsh <lkml@tlinx.org> wrote:
>
> On 2021/04/08 22:44, Amir Goldstein wrote:
> > It is generally not allowed to reuse the upper layer and replace the
> > lower layers after overlayfs has been mounted once.
> >
> > If you say you did not change anything, it is not clear what is the
> > benefit of reusing  the empty upper layer.
> >
> ---
>     I can understand that, the upper layer is an empty fs+work dir

You must mean empty fs+upper dir+work dir. No?

> with no changes.  It was attached to the wrong lower layer,
> unattached/unmounted.
>
>     I then made sure both upper+work were both empty and tried again
> elsewhere.  I want to avoid unnecessary steps, so destroying and recreating
> an empty partition didn't seem logical.

I am probably missing something. How is this complicated?
rmdir upperdir workdir; mkdir upperdir workdir

> How do you disassociate a
> previous connected state?  What needs to be initialized on the
> unmounted upper and working dir (on the same fs), to reuse the same
> file system?
>

You need to remove the trusted.overlay.* xattrs, but I still don't
understand what's the complication with re-creating two empty dirs.

Thanks,
Amir.
