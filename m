Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48849C433EF
	for <linux-unionfs@archiver.kernel.org>; Fri, 11 Mar 2022 20:53:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbiCKUyV (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 11 Mar 2022 15:54:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbiCKUyT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 11 Mar 2022 15:54:19 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D2A25598
        for <linux-unionfs@vger.kernel.org>; Fri, 11 Mar 2022 12:53:07 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id x5so12284561edd.11
        for <linux-unionfs@vger.kernel.org>; Fri, 11 Mar 2022 12:53:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1GNOH6IByfdma2vK0oN46OfXdE9F5N+dlrc1RJjEFIk=;
        b=RjeIvEgAZemAjh7MW5o+VKfWDPmEow0ENexq1P+K144S2pVSqDjee0cdc4oZOCqpUn
         owc6GknawkgmT4HhECQzAJruWMy4OX5wgfWGvHcgiqL4Qn6FKSh6eGCkSDNwOO3qdYGB
         TVWBvbiYnMqIZynJcRgG7j1ULCqToHZ8s7RStTM0nXC2XpGJcy0gpFg/MzsARoANMg+r
         k9zcJafb990WHJIKgVy/EKpW/Qcr4zOM3f5frffwcfKqHDShTtlEF/JkKxeslfOPaUpd
         8IjkL0X9Q8vwC5RBPVsVuob5Sx7UFW+kiv5dty0Da0xaxC8eAlrZfes2eJXxABHjCXT0
         KBLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1GNOH6IByfdma2vK0oN46OfXdE9F5N+dlrc1RJjEFIk=;
        b=C3dbbfFp/wI1xh49MME4n7IBDr/sqpRP7ZdAHp3YA6SiEjM6qJqKmLgGuO7cQsl6EV
         ybPD8OuZFTCH6qV1nT/wLIwKnXE3OgfVEzHTSSCRDK45W/AhonStot1r/BZrb3ltZgyp
         EyTOfpYtrdKB/Pzr1Myr4sgyj/HI99PTm3eCXZPgTHlgSq+VbKNsSO8bCMxqWe7MT27C
         265pToa4T8+Z0CBcCwbxKzZOvHuJPUrke8eSCfjYnBej+ZA5/ZRpJEu8t3SiMnA8GHfG
         xXaDZoyGg0dcYairVCHIYSFhxBXa274XnMfXbHEnS/Vi3UhtTRW6lmoVcMsIiQ4NHpoN
         6UoQ==
X-Gm-Message-State: AOAM531fsc8/GUphcxD42mJGx3TWe79cM4kmZVdP5E2XsqT1s32WWjnV
        6BBmrx2dgB/hjEWmfoKp3xVIPig2bUFrU+KrZKIo
X-Google-Smtp-Source: ABdhPJwSR0cPGoV54LnNJjSTlEQtUj6d/H5MywubGfYXG4EWqco8EDA0qvmEgqp6RbgvnM4pYc61bLNnIxwMEl9aSDA=
X-Received: by 2002:aa7:d494:0:b0:415:a309:7815 with SMTP id
 b20-20020aa7d494000000b00415a3097815mr10502424edr.340.1647031985810; Fri, 11
 Mar 2022 12:53:05 -0800 (PST)
MIME-Version: 1.0
References: <20211117015806.2192263-1-dvander@google.com> <CAOQ4uxjjapFeOAFGLmsXObdgFVYLfNer-rnnee1RR+joxK3xYg@mail.gmail.com>
 <Yao51m9EXszPsxNN@redhat.com> <CAOQ4uxjk4piLyx67Ena-FfypDVWzRqVN0xmFUXXPYa+SC4Q-vQ@mail.gmail.com>
 <YapjNRrjpDu2a5qQ@redhat.com> <CAHC9VhQTUgBRBEz_wFX8daSA70nGJCJLXj8Yvcqr5+DHcfDmwA@mail.gmail.com>
 <CA+FmFJA-r+JgMqObNCvE_X+L6jxWtDrczM9Jh0L38Fq-6mnbbA@mail.gmail.com>
 <CAHC9VhRer7UWdZyizWO4VuxrgQDnLCOyj8LO7P6T5BGjd=s9zQ@mail.gmail.com>
 <CAHC9VhQkLSBGQ-F5Oi9p3G6L7Bf_jQMWAxug_G4bSOJ0_cYXxQ@mail.gmail.com>
 <CAOQ4uxhfU+LGunL3cweorPPdoCXCZU0xMtF=MekOAe-F-68t_Q@mail.gmail.com> <YitWOqzIRjnP1lok@redhat.com>
In-Reply-To: <YitWOqzIRjnP1lok@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 11 Mar 2022 15:52:54 -0500
Message-ID: <CAHC9VhQ+x3ko+=oU-P+w4ssqyyskRxaKsBGJLnXtP_NzWNuxHg@mail.gmail.com>
Subject: Re: [PATCH v19 0/4] overlayfs override_creds=off & nested get xattr fix
To:     Amir Goldstein <amir73il@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        David Anderson <dvander@google.com>,
        Mark Salyzyn <salyzyn@android.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        John Stultz <john.stultz@linaro.org>,
        linux-doc@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        kernel-team <kernel-team@android.com>, selinux@vger.kernel.org,
        paulmoore@microsoft.com, luca.boccassi@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Mar 11, 2022 at 9:01 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Mar 11, 2022 at 06:09:56AM +0200, Amir Goldstein wrote:
> > Hi Paul,

Hi Amir, Vivek,

Thanks for the replies, I think I now have a better understanding of
the concerns which is starting to make the path forward a bit more
clear.  A few more comments below ...

> > In this thread I claimed that the authors of the patches did not present
> > a security model for overlayfs, such as the one currently in overlayfs.rst.
> > If we had a model we could have debated its correctness and review its
> > implementation.
>
> Agreed. After going through the patch set, I was wondering what's the
> overall security model and how to visualize that.
>
> So probably there needs to be a documentation patch which explains
> what's the new security model and how does it work.

Yes, of course.  I'll be sure to add a section to the existing docs.

> Also think both in terms of DAC and MAC. (Instead of just focussing too
> hard on SELinux).

Definitely.  Most of what I've been thinking about the past day or so
has been how to properly handle some of the DAC/capability issues; I
have yet to start playing with the code, but for the most part I think
the MAC/SELinux bits are already working properly.

> My understanding is that in current model, some of the overlayfs
> operations require priviliges. So mounter is supposed to be priviliged
> and does the operation on underlying layers.
>
> Now in this new model, there will be two levels of check. Both overlay
> level and underlying layer checks will happen in the context of task
> which is doing the operation. So first of all, all tasks will need
> to have enough priviliges to be able to perform various operations
> on lower layer.
>
> If we do checks at both the levels in with the creds of calling task,
> I guess that probably is fine. (But will require a closer code inspection
> to make sure there is no privilege escalation both for mounter as well
> calling task).

I have thoughts on this, but I don't think I'm yet in a position to
debate this in depth just yet; I still need to finish poking around
the code and playing with a few things :)

It may take some time before I'm back with patches, but I appreciate
all of the tips and insight - thank you!

-- 
paul-moore.com
