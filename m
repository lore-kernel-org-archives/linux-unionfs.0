Return-Path: <SRS0=S/v9=A2=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD82C433E1
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Jul 2020 09:12:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7602020672
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Jul 2020 09:12:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q5A9zafk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730572AbgGOJMc (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 05:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730560AbgGOJMb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 15 Jul 2020 05:12:31 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E37C061755
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Jul 2020 02:12:31 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id x9so1366787ila.3
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Jul 2020 02:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PxoA9D12l/82rB2PiNaz9KCeFT2taW5YMiFMCNaaP0M=;
        b=q5A9zafk61yVG8/Nz3gkLUo/GGqdapeRjYYXYlV0izHX0AIi8RPIDVV+Gtu2vuRd6x
         jFWqLMVHWHIY1TJVeP7xaL+/3utYN0NKqIDU3wgVEP7XtfJ2vdQOLsFiALDgRXLtmxxr
         Olngg9oGJtBuK6zNe3iGUSfLpnlXEgmV//lduIsSntCpi3w1Asjkbp1bDmHntVfvk+Gs
         LQFJFfo0nce+rDM36cZc94jkKROcZ5w4JI2RaEUu3JMysIb3KcSqHhIUqezRtYaFiL8p
         /mm2a78LRkZlbeSq4dZoUKgjH40P8fEqjHmRv271UuYbZSmiUVQEBgfGQZyJ3DWhYJC0
         rA/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PxoA9D12l/82rB2PiNaz9KCeFT2taW5YMiFMCNaaP0M=;
        b=CPmsZGhZrQeVGBoN5TSXGb3djGfK5hz6QgYXW+/yB++ZSL96FXqH1/+RSB0Eic7BN8
         rWmN0izMqgU4Gw9cLfrvqgTaQYc0yaB4MWig7g8yfnvhtUn6qldqJUGxPvQ+hsC56+zZ
         O9O6pOdjMFAAyt5Dqzac5Z2RFZIguUw5gsIgjT3xdhLuAe7OUAAP0g9Gt+tOqiVjUqQe
         UHbkog2zgwyQY8lrZ2mAJ4uPbyEEugj+jL6z+PQmRVgD6fu0sRcPR3C3pL/DECicyZNN
         GTNIwFxOeacke3wZcpGU5mbtBqtmcCfKwJ2XcdHAFpPvPhrimyUgkGy57jQv51NOccDB
         FIYg==
X-Gm-Message-State: AOAM5316G+begUVykDQyqw/OnPWzBgS5rMv05uoDdQJGsIWSOf+TT1gr
        C/uykeJ/6SdI4hW1BtJkNeax2roRcDrXOotUsOA=
X-Google-Smtp-Source: ABdhPJzoCSXfU+f6tQCXphi4IXXdMC+HLzIcElIsowxAZyZfffmMulg55uF48SmFx8da1m1PSlbjZXOWwC8uVnMuR3k=
X-Received: by 2002:a92:b6d4:: with SMTP id m81mr8971279ill.72.1594804350771;
 Wed, 15 Jul 2020 02:12:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200713105732.2886-1-amir73il@gmail.com> <20200713105732.2886-2-amir73il@gmail.com>
 <20200713192517.GA286591@redhat.com> <CAOQ4uxiXWH2RtXdLXRJY-pcZt=zFK-urhcTSQYNbPpmMjFCJdw@mail.gmail.com>
 <20200714134135.GC324688@redhat.com> <CAOQ4uxgGV4v+8_ziFZ0_qd9J8e=a8mzyHWcxDSE5quQ3+Wh41A@mail.gmail.com>
 <CAJfpeguoOSvMPu7fz=EFQqr+aUsPTgKM9YuBRnH9mkc-35+Jng@mail.gmail.com>
In-Reply-To: <CAJfpeguoOSvMPu7fz=EFQqr+aUsPTgKM9YuBRnH9mkc-35+Jng@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 15 Jul 2020 12:12:19 +0300
Message-ID: <CAOQ4uxjoUf_3wfU8wRM3FmnnCKjKtqRwUbjyoX0Wq9pgTOhUfg@mail.gmail.com>
Subject: Re: [PATCH RFC 1/2] ovl: invalidate dentry with deleted real dir
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Vivek Goyal <vgoyal@redhat.com>, Josh England <jjengla@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jul 15, 2020 at 11:57 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Tue, Jul 14, 2020 at 4:05 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> > Today, if a user deletes/renames underlying lower that leaves
> > the overlayfs dentry in a vulnerable state.
> > I do not have a reproducer to OOPS the kernel with that, but
> > syzbot has created some crashes of similar nature in the past.
>
> Can you back that up with references?

What I meant by "similar nature" is the overlapping layers
shenanigans.
So no, I do not have any concrete evidence to reproducible
OOPS, but we both know that the bugs are there somewhere.
If not a proper OOPS then some WARN_ON must be possible.

>
> Don't misunderstand me, I'm all for making behavior more
> deterministic, but I'd also like to fully understand the current
> behavior.
>

So as I said, I needed those local fs change invalidations for the
snapshot use case and those patches are now in my branch
passing the snapshot tests.

I posted them for consideration, because they *seem* to
slightly improve things, even if not by a lot.

I can claim that they will buy us some more time before syzbot
evolves to finding an OOPS triggered by an underlying change,
but I do not have any real evidence to support this claim.

If you want me to take this one step further and verify overlay
dentry before ovl_lookup() and ovl_iterate() (anything else?)
I can do that.

ovl_lookup() on parent dentry with mangled lowerstack sounds
like a possible source of trouble.

Thanks,
Amir.
