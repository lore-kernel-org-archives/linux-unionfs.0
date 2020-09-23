Return-Path: <SRS0=0kBH=DA=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32265C4727F
	for <linux-unionfs@archiver.kernel.org>; Wed, 23 Sep 2020 11:13:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9D422145D
	for <linux-unionfs@archiver.kernel.org>; Wed, 23 Sep 2020 11:12:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="Al/0M9tp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgIWLM7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 07:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgIWLM6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 23 Sep 2020 07:12:58 -0400
Received: from mail-vk1-xa44.google.com (mail-vk1-xa44.google.com [IPv6:2607:f8b0:4864:20::a44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B628CC0613D1
        for <linux-unionfs@vger.kernel.org>; Wed, 23 Sep 2020 04:12:58 -0700 (PDT)
Received: by mail-vk1-xa44.google.com with SMTP id c63so5068533vkb.7
        for <linux-unionfs@vger.kernel.org>; Wed, 23 Sep 2020 04:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pUaYPz6V6mqKYkTBzYciA/Nd6dmCAIBjuZdXae6Bnuk=;
        b=Al/0M9tpcK5GvaMgjw2rCMySpOStv0EXxyHLllD7Kro026/Ruaibl33KtQb1lEJFbv
         xbdW0o66wYGYpTm1yGyWzwGwwpMZrVMz++MGfxciu/TanSiVL4NFrgud1Mv69j3EmBnf
         EoJXNe5sCaSMVgSgNnUw6esMTuhK8gQgI1z44=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pUaYPz6V6mqKYkTBzYciA/Nd6dmCAIBjuZdXae6Bnuk=;
        b=MwE5H3JRI8KzNc0xGqW7dz9/NAZ6WnNLkii83fgu2x3ASR4L/aOeEWwpS3sFvwaLHT
         nML37a6GpOH09mFhc9BiOliSd/Mbddtoh16Z791TzrkKXdmL0kF6DewyfRjHvsDCSy+s
         6D+Fe+TdaXP+E4GylQ1YfohluhM7j08DiueQ1w87sgAukWnpWlYhUDKF84aM0ZyVLOpe
         JeJq84eHjCtCiXk+NkMi0txHo7E8UDDC0JKJWoOUXlzBfgtpfAZzU74lTTYUeh8LTQ5k
         yoY4IPwPvVwMsWMPRvgaORsyQUNeiiUQncqlwbOKhY5+JvWUdi/8vIP2BVuSYTt/n5Sa
         QREw==
X-Gm-Message-State: AOAM531xcMszQMvYyKoQNH8+LvgqYX2b9q0LMSep99cTVS+14mg9xH/O
        g1ShEmR3X7eGSi7uXnz9+0ogZvAw1kAMkd4/vxcvxg==
X-Google-Smtp-Source: ABdhPJxwoBoaJUAj4plt+pdIU7wdSzuC0ZpgsoMtyEiUZb3FLtCyC2h4coD4m6h+xB/PogKudj7M6FJYYRHp3NZovvQ=
X-Received: by 2002:a1f:368d:: with SMTP id d135mr6094526vka.23.1600859577612;
 Wed, 23 Sep 2020 04:12:57 -0700 (PDT)
MIME-Version: 1.0
References: <a8828676-210a-99e8-30d7-6076f334ed71@virtuozzo.com>
 <CAOQ4uxgZ08ePA5WFOYFoLZaq_-Kjr-haNzBN5Aj3MfF=f9pjdg@mail.gmail.com>
 <1bb71cbf-0a10-34c7-409d-914058e102f6@virtuozzo.com> <CAOQ4uxieqnKENV_kJYwfcnPjNdVuqH3BnKVx_zLz=N_PdAguNg@mail.gmail.com>
 <dc696835-bbb5-ed4e-8708-bc828d415a2b@virtuozzo.com> <CAOQ4uxg0XVEEzc+HyyC63WWZuA2AsRjJmbZBuNimtj=t+quVyg@mail.gmail.com>
 <20200922210445.GG57620@redhat.com> <CAOQ4uxg_FV8U833qVkgPaAWJ4MNcnGoy9Gci41bmak4_ROSc3g@mail.gmail.com>
 <CAJfpegvNZ6Z7uhuTdQ6quBaTOYNkAP8W_4yUY4L2JRAEKxEwOQ@mail.gmail.com> <CAOQ4uxgKr75J1YcuYAqRGC_C5H_mpCt01p5T9fHSuao_JnxcJA@mail.gmail.com>
In-Reply-To: <CAOQ4uxgKr75J1YcuYAqRGC_C5H_mpCt01p5T9fHSuao_JnxcJA@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 23 Sep 2020 13:12:46 +0200
Message-ID: <CAJfpegviT38gja+-pE+5DCG0y9n3GUv4wWG_r3XmSWW6me88Cw@mail.gmail.com>
Subject: Re: virtiofs uuid and file handles
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Max Reitz <mreitz@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Sep 23, 2020 at 11:57 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Wed, Sep 23, 2020 at 10:44 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Wed, Sep 23, 2020 at 4:49 AM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > > I think that the proper was to implement reliable persistent file
> > > handles in fuse/virtiofs would be to add ENCODE/DECODE to
> > > FUSE protocol and allow the server to handle this.
> >
> > Max Reitz (Cc-d) is currently looking into this.
> >
> > One proposal was to add  LOOKUP_HANDLE operation that is similar to
> > LOOKUP except it takes a {variable length handle, name} as input and
> > returns a variable length handle *and* a u64 node_id that can be used
> > normally for all other operations.
> >
> > The advantage of such a scheme for virtio-fs (and possibly other fuse
> > based fs) would be that userspace need not keep a refcounted object
> > around until the kernel sends a FORGET, but can prune its node ID
> > based cache at any time.   If that happens and a request from the
> > client (kernel) comes in with a stale node ID, the server will return
> > -ESTALE and the client can ask for a new node ID with a special
> > lookup_handle(fh, NULL).
> >
> > Disadvantages being:
> >
> >  - cost of generating a file handle on all lookups
>
> I never ran into a local fs implementation where this was expensive.
>
> >  - cost of storing file handle in kernel icache
> >
> > I don't think either of those are problematic in the virtiofs case.
> > The cost of having to keep fds open while the client has them in its
> > cache is much higher.
> >
>
> Sounds good.
> I suppose flock() does need to keep the open fd on server.

Open files are a separate issue and do need an active object in the server.

The issue this solves  is synchronizing "released" and "evicted"
states of objects between  server and client.  I.e. when a file is
closed (and no more open files exist referencing the same object) the
dentry refcount goes to zero but it remains in the cache.   In this
state the server could really evict it's own cached object, but can't
because the client can gain an active reference at any time  via
cached path lookup.

One other solution would be for the server to send a notification
(NOTIFY_EVICT) that would try to clean out the object from the server
cache and respond with a FORGET if successful.   But I sort of like
the file handle one better, since it solves multiple problems.

Thanks,
Miklos

>
> Are there any other states for an open fd that must be preserved?


>
> Thanks,
> Amir.
