Return-Path: <SRS0=aVUC=BY=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05132C433DF
	for <linux-unionfs@archiver.kernel.org>; Fri, 14 Aug 2020 06:20:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF41720838
	for <linux-unionfs@archiver.kernel.org>; Fri, 14 Aug 2020 06:20:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WPX7pXyQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbgHNGUU (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 14 Aug 2020 02:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726122AbgHNGUU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 14 Aug 2020 02:20:20 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331F2C061757
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Aug 2020 23:20:20 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id s189so9825447iod.2
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Aug 2020 23:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1h0ETPNi86aTrTO0uLbudHp7Idtl8Q0bJqoZwOUsrPo=;
        b=WPX7pXyQj7Ok6MfTEA2CVUgKeG+3IRDRCHG5JYz/Z35EubslKDV02mLg+F/ErKoJPP
         GR1gcNq7emdF8Q4OSQ/+VZQqIeh++W83rlVWTxPThL+2TitAmu4mIhubQzyqmC7uEH7Y
         CRgsUXjwYH3J3Rc5F202z50ziR8f7o8Zi+PS1vEDQoOQHPs97w2adFvrrKTjF9hRyz4O
         przHm1lNPp3rGyfQBlNbs0ozvgeSDswhaFs1YP8ET2XUEh7bsVmqyRN5Ec2D/rez6SiX
         vUvRx5WHD9rec8NuFI6Wf4k2gMavepByalp9xaxwos8UHTtbJ2ifl0Nzh7qw4kJISM12
         bTxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1h0ETPNi86aTrTO0uLbudHp7Idtl8Q0bJqoZwOUsrPo=;
        b=JzPWQ9Qg5p0xYo67+2zkgTsb0V8lJ+peRVYxEzHA/Lpdnn+tUQNl+Sl3sjm9GbT42p
         wO6PJZI9hIMvX7GwrrGdW3ddGX55ZVS8pi7rLRO267w/w/0kGgZfTK085djCsTVq2kYV
         KFanEvHm2ag+IhoInqRuW4PVFPYHbcwErtkZqlEDBK+m5btBUTDuqCAQCjUrh6o0FdGK
         +oiE9jjr+0Ie8elpbQ2paVYF7T6xmWSohLZ2TrgVMWr8il0MTo/qwuOhOJcXTNnALBaW
         hX7R+UIdaRa2eztOeKgywkHb4VIQUP7ISc6lHIw1GpC25bcHTKKxlbu0ZcSBqv+Aa2QO
         0klg==
X-Gm-Message-State: AOAM5316ET0kzCwb9K8zwcCzLJeXcDqKZmE7ZcSzZ5I7R0qM4F9DMewa
        HDSUIamSIgG5odatiX7ZgtrF85dCqIBVCn4aArM=
X-Google-Smtp-Source: ABdhPJzhdsqqprdKSZrXDnAEnQuAQxNq5mudsbX+eS2u8YLZ1xnxsesr7tm1OkApDq7D2KPb+YvuQSrsboDY49DJe98=
X-Received: by 2002:a02:3f16:: with SMTP id d22mr1436867jaa.30.1597386019409;
 Thu, 13 Aug 2020 23:20:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200812135529.GA122370@kevinolos> <CAOQ4uxih2aDb7_LPSUb5Q4xBL5_gDaqtmC0M0M4EtCDgKLvi3w@mail.gmail.com>
 <20200812160513.GA249458@kevinolos> <CAOQ4uxi23Zsmfb4rCed1n=On0NNA5KZD74jjjeyz+et32sk-gg@mail.gmail.com>
 <20200813172218.GA298313@kevinolos>
In-Reply-To: <20200813172218.GA298313@kevinolos>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 14 Aug 2020 09:20:08 +0300
Message-ID: <CAOQ4uxjA-+EsUz2LuEc2PYQzZkO+aBK4dBMsoSvBgNjaU9Nj_Q@mail.gmail.com>
Subject: Re: EIO for removed redirected files?
To:     Kevin Locke <kevin@kevinlocke.name>,
        Amir Goldstein <amir73il@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Cc:     kmxz <kxzkxz7139@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Aug 13, 2020 at 8:22 PM Kevin Locke <kevin@kevinlocke.name> wrote:
>
> Thanks again Amir!  I'll work on patches for the docs and adding
> pr_warn_ratelimited() for invalid metacopy/redirect as soon as I get a
> chance.
>
> On Wed, 2020-08-12 at 20:06 +0300, Amir Goldstein wrote:
> > On Wed, Aug 12, 2020 at 7:05 PM Kevin Locke <kevin@kevinlocke.name> wrote:
> >> On Wed, 2020-08-12 at 18:21 +0300, Amir Goldstein wrote:
> >>> I guess the only thing we could document is that changes to underlying
> >>> layers with metacopy and redirects have undefined results.
> >>> Vivek was a proponent of making the statements about outcome of
> >>> changes to underlying layers sound more harsh.
> >>
> >> That sounds good to me.  My current use case involves offline changes to
> >> the lower layer on a routine basis, and I interpreted the current
> >
> > You are not the only one, I hear of many users that do that, but nobody ever
> > bothered to sit down and document the requirements - what exactly is the
> > use case and what is the expected outcome.
>
> I can elaborate a bit.  Keep in mind that it's a personal use case which
> is flexible, so it's probably not worth supporting specifically, but may
> be useful to discuss/consider:
>
> A few machines that I manage are dual-boot between Windows and Linux,
> with software that runs on both OSes (Steam).  This software installs a
> lot (>100GB) of semi-static data which is mostly (>90%) the same between
> OSes, but not partitioned by folder or designed to be shared between
> them.  The software includes mechanisms for validating the data files
> and automatically updating/repairing any files which do not match
> expectations.
>
> I currently mount an overlayfs of the Windows data directory on the
> Linux data directory to avoid storing multiple copies of common data.
> After any data changes in Windows, I re-run the data file validation in
> Linux to ensure the data is consistent.  I also occasionally run a
> deduplication script[1] to remove files which may have been updated on
> Linux and later updated to the same contents on Windows.
>

Nice use case.
It may be a niche use case the way to describe it, but the general concept
of "updatable software" at the lower layer is not unique to your use case.
See this [1] recent example that spawned the thread about updating the
documentation w.r.t changing underlying layers.

[1] https://lore.kernel.org/linux-unionfs/32532923.JtPX5UtSzP@fgdesktop/

> To support this use, I'm looking for a way to configure overlayfs such
> that offline changes to the lower dir do not break things in a way that
> can't be recovered by naive file content validation.  Beyond that, any
> performance-enhancing and space-saving features are great.
>
> metacopy and redirection would be nice to have, but are not essential as
> the program does not frequently move data files or modify their
> metadata.

That's what I figured.

> If accessing an invalid metacopy behaved like a 0-length
> file, it would be ideal for my use case (since it would be deleted and
> re-created by file validation) but I can understand why this would be
> undesirable for other cases and problematic to implement.  (I'm

I wouldn't say it is "problematic" to implement. It is simple to convert the
EIO to warning (with opt-in option). What would be a challenge to implement
is the behavior, where metadata access is allowed for broken metacopy,
but data access results in EIO.

> experimenting with seccomp to prevent/ignore metadata changes, since the
> program should run on filesystems which do not support them.  An option
> to ignore/reject metadata changes would be handy, but may not be
> justified.)
>
> Does that explain?  Does it seem reasonable?  Is disabling metacopy and
> redirect_dir likely to be sufficient?

Yes, disabling metacopy and redirect_dir sounds like the right thing to do,
because I don't think they gain you too much anyway.

>
> Best,
> Kevin
>
> [1]: Do you know of any overlayfs-aware deduplication programs?  If not,
> I may consider cleaning up and publishing mine at some point.

I know about overlayfs-tools's "merge" command.
I do not know if anyone is using this tool besides perhaps it's author (?).
Incidentally, I recently implemented the "deref" command for overlayfs-tools [2]
which unfolds metacopy and redirect_dir and creates an upper layer without
them. The resulting layer can then be deduped with lower layer using the
"merge" command.

[2] https://github.com/kmxz/overlayfs-tools/pull/11

I also implemented (in the same pull request) awareness of overlayfs-tools
to metacopy and redirect_dir with existing commands. "merge" command
simply aborts when they are encountered, but "vacuum" and "diff" commands
work correctly. I also added the "overlay diff -b" variant, which
creates an output
equivalent to that of the standard diff tool (diffutils) just by
analyzing the layers.

Thanks,
Amir.
