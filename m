Return-Path: <SRS0=37bb=CM=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D53FDC433E7
	for <linux-unionfs@archiver.kernel.org>; Thu,  3 Sep 2020 09:00:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EB4D206E7
	for <linux-unionfs@archiver.kernel.org>; Thu,  3 Sep 2020 09:00:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZdqqWOmY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgICJAh (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 3 Sep 2020 05:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbgICJAe (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 3 Sep 2020 05:00:34 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E23EC061244
        for <linux-unionfs@vger.kernel.org>; Thu,  3 Sep 2020 02:00:33 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id q6so1774840ild.12
        for <linux-unionfs@vger.kernel.org>; Thu, 03 Sep 2020 02:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FtCmIngnUqOHrNnGJIDvWVZ1cMmDVDeUCiN8+cTjkLw=;
        b=ZdqqWOmYZvIMx9LzMGDjLVO4146lNrKFPjQfUdYqObxJIus5y3ecRsONpsDNogHUnx
         Owe+kHCumU1Iki5y0++VdJsArnI16WEVYUzGHb6xvS3AJHahaPKgZbGtvTCFC5KcvxTq
         fEaR0EPOpqV1Dli0fG/jnQQEY7u9dN3yIzKC4E6AUNIeSECk4GAREJNrXrJuvbfRi6sw
         fhY3TrjIzSBxqWUfvfoBuSdE93U6kri73UT0+VHFrK2pReR+EBaxkof4g2DFGh64AR48
         eL6FdWEx2y4IYOhWdX7SFhMq6NXh08NXF0vW3J9j0+g04SX7mw776RoVLs+c0eZHoJr3
         GwMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FtCmIngnUqOHrNnGJIDvWVZ1cMmDVDeUCiN8+cTjkLw=;
        b=ZBXXM1AnIog/mW/jJNvXzcf5XLzlqhVfaHwDkHeZPkgNLgX88SjTDX0U6AloyDDSDU
         d7W2XYpqfZGjCUb4wnUOCz5bAI0sU5y4vETQPsbvznRWHMiTmPDVsg/7QP+MtEdHOlEH
         qIvwZwoS/1Hl8EFULqdXWwUMrgLCk/q2xrrGtiewuQs+S5XIGXyiX4097ct2SvkY/PfH
         zqhZ0A1LuM8JmfbKUuLPnoMZI52wwrMA11TDQGZKebX9YUd0DfIohUIyJ/8IsTK/UEc/
         q0Pwr3YyEde4j+5OmAvdisUF59ROwyUR9u8JmABcA8sT0oEj1vM8pscpS0QIb7bA2luX
         K+rw==
X-Gm-Message-State: AOAM532L2f3Io7ClzGzZeE1m09TvbjV2ITesfLaNTA2nxRQngqpj7qBM
        bAQmOWJGaIZGTL6SjwYpASd5KKCUKxLAmqAdsJk=
X-Google-Smtp-Source: ABdhPJzAGJm8EOhE99VZBmvOwqGzBUfz4kwmgpkP/tWMcGU5I/rTCkfGZNe7ZTdZH/VZcIrs3yfGjPncimjO3Me99mQ=
X-Received: by 2002:a05:6e02:c61:: with SMTP id f1mr2326761ilj.137.1599123632637;
 Thu, 03 Sep 2020 02:00:32 -0700 (PDT)
MIME-Version: 1.0
References: <d5dc093b-71aa-8656-a4d3-c27c14015d79@mclink.it>
 <CAOQ4uxgHL2H8RBXbovyFNn_GOC9YE2N6L+AZ6XO=qkA2hhLr=w@mail.gmail.com>
 <2da4dd97-d7cb-ce1b-ada7-0152d65ce701@mclink.it> <CAOQ4uxjk78aWc4rXd3_4Kr_Hy74AF4Yzk8Dur9VyadeyS33MGg@mail.gmail.com>
 <20200902132921.GA1263242@redhat.com> <7862cfc2-03e1-61b8-ae36-96ef5d28915e@mclink.it>
 <20200902202048.GD1263242@redhat.com> <8a5fb512-e430-40c1-2266-e90625385e62@mclink.it>
 <CAOQ4uxg9p2w-z9c+WzVjr5CO3xmf2gqK-VrhhUOcbA2uQJiseA@mail.gmail.com> <89bc9214-bb3c-49e9-16d1-c630b463c901@mclink.it>
In-Reply-To: <89bc9214-bb3c-49e9-16d1-c630b463c901@mclink.it>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 3 Sep 2020 12:00:21 +0300
Message-ID: <CAOQ4uxjQW8YcagfLn+8Eh4NuQ-45R5HYbLdmNpZL=q4_k_vT3w@mail.gmail.com>
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

> > Just so you know, Android is another "system image provider" project
> > whose developers were talking about using overlayfs to provide
> > "debug mode", wherein developers can modify system files.
> > This is the use case for the proposed override_creds=off feature [1].
> >
> > I do not know if this mode was deployed on existing phones, but anyway,
> > it is not enabled in production mode, so it limits very much the problem
> > of conflict resolution.
> I'm not sure about what You mean exactly, but I'll try to check it
> if You so suggest.
>

There is nothing for you to check.
Only informing you of another user that may be doing the same thing that
you do and expects it to continue working.

FWIW, if Android *are* using overlayfs like this they should encounter
the same problem you encountered and the upstream fix will not solve it....

Thanks,
Amir.
