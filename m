Return-Path: <SRS0=UrPG=A3=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ECF6C433E1
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Jul 2020 13:43:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA97F20760
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Jul 2020 13:43:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oBEDAf9H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbgGPNnf (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 09:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbgGPNnf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Jul 2020 09:43:35 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB7DC061755
        for <linux-unionfs@vger.kernel.org>; Thu, 16 Jul 2020 06:43:34 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id p15so5035353ilh.13
        for <linux-unionfs@vger.kernel.org>; Thu, 16 Jul 2020 06:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9/1+/0KhecQ+aVqX4AXbAtzC9CTmGTVH1FW3Vswrn/Y=;
        b=oBEDAf9HOsRorTaWjZweg/loVz3txZh/dTgplHh3vS+6/Z9ncduPjM1lUk3iahkNk4
         hIUNT4dyu9qm6KIAS8k0bqH1YCn3D+zyPvUt0kIz3DDrgjOcNSvSQDypR3EMlemO0HQ4
         4e9vmk9mT8lKR+/dKGj1y8UQz/Yfr6W197HGjm5Qt9SpZvyGtHskZRE7xWAqMTNMElrn
         1K0kVDZXxVhJWfhFXZ3JZrdyUzETlIJkk3etSu6T0pZITlxEDQIqZHjs/sMJOWyuAOJd
         mnjEK2ssjcL+LlM924bKQvUDGhqziQctAD9powoPyaYdI0uKl07zP8Uruxj02nl2e+Ee
         /kkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9/1+/0KhecQ+aVqX4AXbAtzC9CTmGTVH1FW3Vswrn/Y=;
        b=AZrMWDaaQg2DNDHlZDzdZ8ktaABnTg++meXrs7WSj8WL4J1eKINszQImj+D9Rr527a
         SDCANbokWpadEHz9WBUvplSI4Xl2m7iWV0qHROkfNYleWdGn5YZSeMHlcn0vXi0nUX2i
         AQxZPOjjVMURpxxUt8bLz7l0O8h0SQwVhTKRkOpv1ea/jlxu758iGVRlMlnb5craxzfL
         2hbOP7q7Db5Lzhp0BUqqDzQd1SzgVfxhim7eNl0KYTaAJ8d4YvN8L2AZzTMu/266lMcx
         dkeQh6g8KKxDxllQMA7w0gF/kRD7E/6PNPDLz6Yw/f/VWf9eYn3UBiJNR8NA9Y2tLw7P
         rDEg==
X-Gm-Message-State: AOAM533dSReHKVh+7rim80wo2qMlh0saJv8CgTvz95elXc9P5x1W52R2
        qudXeH9IBOOGXRb5CamJy6FPJS82ceFXudvI9qnwig==
X-Google-Smtp-Source: ABdhPJyVD1/wlYSh5wNSkh7HkSYHp4e8jG0UcuL/6jTWzjx5TbCnQYD+wtWlJz2U3zJ4B6f0lt76lDy2h5h2BZ+4Zv8=
X-Received: by 2002:a05:6e02:13e2:: with SMTP id w2mr4799197ilj.9.1594907014367;
 Thu, 16 Jul 2020 06:43:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200713141945.11719-1-amir73il@gmail.com> <20200714180705.GE324688@redhat.com>
 <CAOQ4uxh-fUKhiQOhRmZ5LT2sjtM3Wx5wo_wcKYtX+-DbYjXp0Q@mail.gmail.com>
 <20200715130648.GA379396@redhat.com> <CAOQ4uxjV93TAUGLAL_1uAtm2+eJv7poj_mmO5K_-07TYjBh7vA@mail.gmail.com>
 <20200716132743.GB422759@redhat.com>
In-Reply-To: <20200716132743.GB422759@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 16 Jul 2020 16:43:22 +0300
Message-ID: <CAOQ4uxhZ0kx-c_nkP8Njf2ZMY4d2RvWQH0A0gShmA_w3TLzbcQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] Misc. redirect_dir=nofollow fixes
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Jul 16, 2020 at 4:27 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Wed, Jul 15, 2020 at 04:56:45PM +0300, Amir Goldstein wrote:
> > > > TBH I never really understood the thread that led to redirect_dir=nofollow.
> > > > I don't think anyone has presented a proper use case that can be discussed,
> > >
> > > IIUC, idea was that automated mounting can mount a handcrafted upper on
> > > usb hence allow access to directories on host which are otherwise
> > > inaccessible.
> > >
> >
> > That is an *idea* described by hand waving.
> > That is not a threat I can seriously comment on.
> > How exactly is that USB auto mounted? where to?
> > How is that related to overlay?
> >
> > > > so I just treat this config option as "paranoia" or "don't give me anything that
> > > > very old overlay did not give me".
> > > > Therefore I suggested piggybacking on it.
> > >
> > > Even if it is paranoia, put more unrelated checks under this option does
> > > not make much sense to me. It will make things just more confusing.
> > >
> > > Anyway, redirect_dir=nofollow is a thing of past. Now if you want to
> > > not follow origin, then we first need to have a genuine explanation
> > > of why to do that (and not be driven by just paranoia).
> > >
> > > > Of course if we do, we will need to document that.
> > >
> > > redirect_dir=nofollow resulting in origin not being followed is plain
> > > unintuitive to me. Why not introduce another option if not following
> > > origin is so important.
> > >
> >
> > Because cluttering the user with more and more config options for
> > minor and mostly unimportant behaviors is not ideal either.
> > See what Kconfig help has to say about the config option:
> >
> > config OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW
> >         bool "Overlayfs: follow redirects even if redirects are turned off"
> >         default y
> >
> >        Disable this to get a possibly more secure configuration, but that
> >        might not be backward compatible with previous kernels.
> >
> > That is a VERY generic description that fits not following origin very
> > well IMO, and not following unverified dir origin as well for that matter.
> > Nobody outside overlayfs developers knows what "redirects" means
> > anyway. To me, following non-dir origin sounds exactly the same
> > as following non-dir metacopy redirect or dir redirect. It's just the
> > implementation details that differ.
> >
> > So my claim is that we *can* piggyback on it because I really
> > don't believe anybody is using this config out there for anything
> > other than "to be on the safe side".
>
> On one hand you are saying redirect=nofollow is paranoia, most people
> don't understand it and don't use it. And on top of that you want
> to add more to it. Adding more to something which nobody does not
> understand and uses, sounds like more trouble to me.
>

I am sorry, my POV is exactly the opposite of that.
No need to argue about it though ;-)

> Anyway, before we go further into this, what's the use case. Why
> do you want to provide option to disable following origin for non-dir?
>

I started thinking about this because of the squashfs bug report
(replacing lower layers) for which I had sent a patch to automatically
disable non-dir origin.

Reproducing the same problems with underlying fs with uuid is harder
but not impossible to think of a scenario.
My line of thinking is why should force feed the users with a feature they
didn't ask for if it can break something.
The very least we could do is allow users to opt-out.

But then again, if no one complains, we don't really need to do anything.
I have that feature (no follow origin) anyway for snapshot, but I can enable
it only for the snapshot case, so I don't mind if it can be enabled with
another config option or not - just wanted to put it out there for discussion.

Thanks,
Amir.
