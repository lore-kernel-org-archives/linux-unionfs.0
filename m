Return-Path: <SRS0=cJ4F=CH=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12819C433E2
	for <linux-unionfs@archiver.kernel.org>; Sat, 29 Aug 2020 15:41:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2C96206B5
	for <linux-unionfs@archiver.kernel.org>; Sat, 29 Aug 2020 15:41:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=sargun.me header.i=@sargun.me header.b="k7Rx1dzo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbgH2PlU (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 29 Aug 2020 11:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728196AbgH2PlP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 29 Aug 2020 11:41:15 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60BE0C061236
        for <linux-unionfs@vger.kernel.org>; Sat, 29 Aug 2020 08:41:14 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id a26so3051985ejc.2
        for <linux-unionfs@vger.kernel.org>; Sat, 29 Aug 2020 08:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=64FN1MGxhBWlNF4OVlX0wMFKnJlgUYNSyVxv7Q1pPo0=;
        b=k7Rx1dzobIX6aQK68EIO125za9REv/tKzSmvOJsTEbTdORCYfyxPnCZw76HogwspKa
         oX++2gKzn9oTfxfE7K7rSwRNSXsj8fQvVOEvcsPUsDUviPPIx3Cqr6xv24FhD+7PlNi8
         5TT9WxRWnECSFDTgGmi+8qW8ahUxE2mOtLB/c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=64FN1MGxhBWlNF4OVlX0wMFKnJlgUYNSyVxv7Q1pPo0=;
        b=tT+J+cGX/h7NO2o9KrxRvE0aPRLUVuw3bqiKq3XQ9PO3JUzOiTltAWRjR3m7QuNmSG
         L9P+j5Ok3rnjy2RzG6n2k7aQMdM2Jf8OjSL0gCtCaRBjI0/IG5a1dyjz4kZ8mfKJ65UQ
         /hesb34r91cvg5w+BBGB2S66wFYOKDj+LyUhDW9iKxMyIS71GhcYY036agAlR1wOga4p
         /XbnfnHKZFhSLrrtZbGaIaSARUm8uCvHDOQpkyStdrB1Ora7/P+LFAgJhLm76V+saRqc
         5qa8Wxg9n5icO6MsEKNI566RB9ov4C4NmEMTXoveHqRNjJ0co3Dz7FUwMXMuk/O3vJvw
         YO7w==
X-Gm-Message-State: AOAM532AWG1Mr4nK9U2AU/6EajmSRrO4UylsBNT/PDo+39K5EPiPU2Rj
        5KAlkEjaM+vE9Vrav1Uex5AFpLieuIJf/7bg1paP6Q==
X-Google-Smtp-Source: ABdhPJxKZJiaAQZfxxzd1r42MrxASEuooxd+Rd2LI8Gcysn1tys9iyEksvon0AdGBff2SOOv6BxcvCQ2S5QDLPyohfI=
X-Received: by 2002:a17:906:3609:: with SMTP id q9mr4020781ejb.138.1598715672580;
 Sat, 29 Aug 2020 08:41:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAOQ4uxjXZdXZAaeiJ_p9n7NJziBv2yvWqSDs0hDd1ONUrVKxOQ@mail.gmail.com>
 <87tuwmiy4j.fsf@x220.int.ebiederm.org> <20200828155849.k46uk3x63aio3g3o@yavin.dot.cyphar.com>
In-Reply-To: <20200828155849.k46uk3x63aio3g3o@yavin.dot.cyphar.com>
From:   Sargun Dhillon <sargun@sargun.me>
Date:   Sat, 29 Aug 2020 08:40:36 -0700
Message-ID: <CAMp4zn83CwpfuFq7+JSkYGZmFC03pUrt_30Wzn42AxqAaSDSpg@mail.gmail.com>
Subject: Re: Overlayfs @Plumbers
To:     Aleksa Sarai <asarai@suse.de>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Aug 28, 2020 at 8:59 AM Aleksa Sarai <asarai@suse.de> wrote:
>
> On 2020-08-28, Eric W. Biederman <ebiederm@xmission.com> wrote:
> > Amir Goldstein <amir73il@gmail.com> writes:
> >
> > > Hi Guys,
> > >
> > > It's been nice to virtually meet with you yesterday.
> > > Some of you wanted to follow up on overlayfs related issues.
> > >
> > > If you want to discuss, try to find me in one of the
> > > https://meet.2020.linuxplumbersconf.org/hackrooms
> > > today between 16:00-17:00 UTC
> > > (No need to enter the room to see who's inside)
> > >
> > > If those times do not work for you, contact me and we can try
> > > to schedule another time.
> >
> > Did this conversation wind up happening?  Do we need to reschedule?
>
> This conversation already happened in a Hackroom on Tuesday. I'm not
> sure if the Hackrooms will have their recordings published, so maybe
> Amir can post any of the takeaways we had?
>
> --
> Aleksa Sarai
> Senior Software Engineer (Containers)
> SUSE Linux GmbH
> <https://www.cyphar.com/>

I unfortunately missed this conversation. I wanted to bring up OverlayFS, and
ephemeral upper dirs. We use overlayfs with Docker containers, and we waste
a lot of time on writing things back to disk.

We're not so peeved about the fact that OVL does any sync operations, as that's
what our users have been used to. The big problem is on unmount, ovelfs decides
syncing the upperdirs is a good idea. IIRC, this regression was
introduced somewhere
in the 4.X series.

We've been carrying a patch to short-circuit this behaviour for a while now:
https://github.com/Netflix-Skunkworks/linux/commit/edb195d9b73cc22d095078010a14a690f41ee253

I know that this behaviour (and any behaviour that short-circuits
O_SYNC / FUA is
technically "wrong", but in this case, can we make an exception? I originally
thought about using device mapper to remove the FUA bit from all BIOs, but it
turns out that my underlying storage *always* persists data to disk,
so every write
takes...a long time.

Amir, what's your take?
