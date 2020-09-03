Return-Path: <SRS0=37bb=CM=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD66DC433E7
	for <linux-unionfs@archiver.kernel.org>; Thu,  3 Sep 2020 09:02:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7541820709
	for <linux-unionfs@archiver.kernel.org>; Thu,  3 Sep 2020 09:02:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RFTJtSZ6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgICJCL (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 3 Sep 2020 05:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbgICJCK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 3 Sep 2020 05:02:10 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4850CC061244
        for <linux-unionfs@vger.kernel.org>; Thu,  3 Sep 2020 02:02:10 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id d190so1923273iof.3
        for <linux-unionfs@vger.kernel.org>; Thu, 03 Sep 2020 02:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HgZnCq75P16HIaCmuon7LG/vx2i8dm1cvzLekWSGMrQ=;
        b=RFTJtSZ6VNdvY9cAztcxLOqVh6hZz2eVyhbD0D+B5qXdp3xo6/Ts3Q4w98FuyEdvuK
         FeBBsqQIXaIItaBQ65igTiDEpmoFEBY7LLPtxUbdkKNf8mMGhInwXfwhPX0HJU2kYO6k
         5ZE7qhxesGXyohTzDnQF4Mxyv0g/+sAaz/nopP6B2p/P74riIrIkAOWFRyMu0Yhy2hAx
         541BzNVeIbYEGoJP+KnTZm6EO7/LOv/OHlbRpNsBVKHY7ZjafMcKad6611g92DoArekS
         BD00ntmcVebIqw7O6/3ZHhWFf9EAaUBfpzvRV29qLAo9rBlbKJC60REd+AP3/MI4Vx+D
         2Ipg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HgZnCq75P16HIaCmuon7LG/vx2i8dm1cvzLekWSGMrQ=;
        b=fF1ikKX2/SbfXS47PMandWMnUeeDIcuFDnlBBUkg8CLOxwVe0csh+QBa84wBL50YnF
         pTGGKGZhJ5+QmchnfOlfgyvJRZtfZCr0qZTBlfAYP6NQDoE5+clXQj4XS32U7trKh3cr
         lP4KLQwcH3vIbnNxm3zJuXTCmp0luOpj3e+D7+rT4dW2i9D3bN14QJGwkpNLa7AyrsPQ
         h9lomPcMpp/RS4BjXIUjn9ImA+3pCZ9Ep4XbP0nXb0xpHQgpMaQX9a2YXYvjF4fuK8j6
         1MXc0up67jcbz3cRMX7iHs5Lh5abavGyrCWhz9qj4T423LY1HnCFmqSTGpZ3Pgrl3KCy
         jOGw==
X-Gm-Message-State: AOAM5330AJaVd/fiU11j2+aLU21W24gry1VbucXp6etBbkyQjNj7YDOX
        X2RmkDKaxCnMfs8rMPzPNNw+qIrgUhMGd5DJJ3o=
X-Google-Smtp-Source: ABdhPJwYZ1Obo3PP2fjE08F736903H7wPqSyEVz4sVZJ/OaNC5MP2le9tJ4yR/WMeFMm8LcWYYkPX8+4chDv5xkspws=
X-Received: by 2002:a02:3f16:: with SMTP id d22mr2316240jaa.30.1599123728694;
 Thu, 03 Sep 2020 02:02:08 -0700 (PDT)
MIME-Version: 1.0
References: <d5dc093b-71aa-8656-a4d3-c27c14015d79@mclink.it>
 <CAOQ4uxgHL2H8RBXbovyFNn_GOC9YE2N6L+AZ6XO=qkA2hhLr=w@mail.gmail.com>
 <2da4dd97-d7cb-ce1b-ada7-0152d65ce701@mclink.it> <CAOQ4uxjk78aWc4rXd3_4Kr_Hy74AF4Yzk8Dur9VyadeyS33MGg@mail.gmail.com>
 <20200902132921.GA1263242@redhat.com> <7862cfc2-03e1-61b8-ae36-96ef5d28915e@mclink.it>
 <20200902202048.GD1263242@redhat.com> <8a5fb512-e430-40c1-2266-e90625385e62@mclink.it>
 <CAOQ4uxg9p2w-z9c+WzVjr5CO3xmf2gqK-VrhhUOcbA2uQJiseA@mail.gmail.com>
 <89bc9214-bb3c-49e9-16d1-c630b463c901@mclink.it> <CAOQ4uxjQW8YcagfLn+8Eh4NuQ-45R5HYbLdmNpZL=q4_k_vT3w@mail.gmail.com>
In-Reply-To: <CAOQ4uxjQW8YcagfLn+8Eh4NuQ-45R5HYbLdmNpZL=q4_k_vT3w@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 3 Sep 2020 12:01:57 +0300
Message-ID: <CAOQ4uxg03_JfdO+3RqRgeTS=fR105=ObiZ3ukXcXiqGw0KPuYw@mail.gmail.com>
Subject: Re: Frequent errors with OverlayFS on root
To:     Mauro Condarelli <mc5686@mclink.it>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Mark Salyzyn <salyzyn@android.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Sep 3, 2020 at 12:00 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> > > Just so you know, Android is another "system image provider" project
> > > whose developers were talking about using overlayfs to provide
> > > "debug mode", wherein developers can modify system files.
> > > This is the use case for the proposed override_creds=off feature [1].
> > >
> > > I do not know if this mode was deployed on existing phones, but anyway,
> > > it is not enabled in production mode, so it limits very much the problem
> > > of conflict resolution.
> > I'm not sure about what You mean exactly, but I'll try to check it
> > if You so suggest.
> >
>
> There is nothing for you to check.
> Only informing you of another user that may be doing the same thing that
> you do and expects it to continue working.
>
> FWIW, if Android *are* using overlayfs like this they should encounter
> the same problem you encountered and the upstream fix will not solve it....
>

Correction. I made the same mistake before when posting the patch
and Miklos corrected me. Lower fs with UUID (ext4/f2fs) does not suffer from
the specific problem that the fix commit fixes.

Thanks,
Amir.
