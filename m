Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C52CC47080
	for <linux-unionfs@archiver.kernel.org>; Mon, 31 May 2021 15:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0DF3610A6
	for <linux-unionfs@archiver.kernel.org>; Mon, 31 May 2021 15:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbhEaPUT (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 31 May 2021 11:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232648AbhEaPSI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 31 May 2021 11:18:08 -0400
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A7BC06129E
        for <linux-unionfs@vger.kernel.org>; Mon, 31 May 2021 07:11:56 -0700 (PDT)
Received: by mail-ua1-x92e.google.com with SMTP id f20so6651247uax.6
        for <linux-unionfs@vger.kernel.org>; Mon, 31 May 2021 07:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vNIjVp5U1cElMCI70hXwJr7OYzhPLEPInOFf3Mw2iYE=;
        b=c3SzenalqbMH7AkuKol5QqFTE9dxA+I/YNAdrZqmCT/jg2NUrKdOvNsqrmKwZMnwv/
         0UDObdoyi7Jp3K3PoRmd8MJcE+XRqDmEwRXm2k+saMLoilMYKyJTnBMFPYI2lTtfcKUQ
         uMtI2YomqxK+1QI9z2ZrDx0L7fXQ9TwUlrs4o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vNIjVp5U1cElMCI70hXwJr7OYzhPLEPInOFf3Mw2iYE=;
        b=LR54euvqYokRLKbXeumRCCZch6DAwB7yZ9E3PMeyvAAxFCUs1dRPtav2Weql8dbdza
         LX2pFV8Eseqx60nbfOOpXu71mkZudPHVMAds1zcc7xC7O134L0Yr32Yy+vBPoPQAWjnd
         rf0qp7QeinQqlNpGvXxz0H6+FeS6CSWMtn2kk1H3v/H0gTktpQ8Bs3Fg0weTkVPek5rM
         wIrmcITw7OPpFMSuuvUfjI0lsiH5Ys692iBIOv3oqmjOKj4kt3SEIxP8NjFpo3Ufsvbk
         tRFPq0caljS7U8+BfFSqC9VVmjHF4Gv+MNtl0lbJMDEmE7YblKc6nq8E6KJnHpFHqvQZ
         VAhg==
X-Gm-Message-State: AOAM532GV5Qdd9IV8HR8S5qpnyJ0Gn3mqWREiljGul49JFF7gq+UMaem
        wzdfr5V/KxHrlfKbtO4iX9WveGDAioyitrS+E5SNKw==
X-Google-Smtp-Source: ABdhPJyRNqC7aXSy3nKyxDNn+avdFJ/rdx4p4YQsJJ39xUbRg965T8uztjxLiE6kHR51P7ncUlC5z9PU0kW2PSRvMmE=
X-Received: by 2002:a1f:30cd:: with SMTP id w196mr12917140vkw.3.1622470315793;
 Mon, 31 May 2021 07:11:55 -0700 (PDT)
MIME-Version: 1.0
References: <a8828676-210a-99e8-30d7-6076f334ed71@virtuozzo.com>
 <CAOQ4uxgZ08ePA5WFOYFoLZaq_-Kjr-haNzBN5Aj3MfF=f9pjdg@mail.gmail.com>
 <1bb71cbf-0a10-34c7-409d-914058e102f6@virtuozzo.com> <CAOQ4uxieqnKENV_kJYwfcnPjNdVuqH3BnKVx_zLz=N_PdAguNg@mail.gmail.com>
 <dc696835-bbb5-ed4e-8708-bc828d415a2b@virtuozzo.com> <CAOQ4uxg0XVEEzc+HyyC63WWZuA2AsRjJmbZBuNimtj=t+quVyg@mail.gmail.com>
 <20200922210445.GG57620@redhat.com> <CAOQ4uxg_FV8U833qVkgPaAWJ4MNcnGoy9Gci41bmak4_ROSc3g@mail.gmail.com>
 <CAJfpegvNZ6Z7uhuTdQ6quBaTOYNkAP8W_4yUY4L2JRAEKxEwOQ@mail.gmail.com>
 <CAOQ4uxgKr75J1YcuYAqRGC_C5H_mpCt01p5T9fHSuao_JnxcJA@mail.gmail.com>
 <CAJfpegviT38gja+-pE+5DCG0y9n3GUv4wWG_r3XmSWW6me88Cw@mail.gmail.com> <CAOQ4uxjNcWCfKLvdq2=TM5fE5RaBf+XvnsP6v_Q6u3b1_mxazw@mail.gmail.com>
In-Reply-To: <CAOQ4uxjNcWCfKLvdq2=TM5fE5RaBf+XvnsP6v_Q6u3b1_mxazw@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 31 May 2021 16:11:45 +0200
Message-ID: <CAJfpeguOLLV94Bzs7_JNOdZZ+6p-tcP7b1PXrQY4qWPxXKosnA@mail.gmail.com>
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

On Sat, 29 May 2021 at 18:05, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Wed, Sep 23, 2020 at 2:12 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Wed, Sep 23, 2020 at 11:57 AM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > On Wed, Sep 23, 2020 at 10:44 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > >
> > > > On Wed, Sep 23, 2020 at 4:49 AM Amir Goldstein <amir73il@gmail.com> wrote:
> > > >
> > > > > I think that the proper was to implement reliable persistent file
> > > > > handles in fuse/virtiofs would be to add ENCODE/DECODE to
> > > > > FUSE protocol and allow the server to handle this.
> > > >
> > > > Max Reitz (Cc-d) is currently looking into this.
> > > >
> > > > One proposal was to add  LOOKUP_HANDLE operation that is similar to
> > > > LOOKUP except it takes a {variable length handle, name} as input and
> > > > returns a variable length handle *and* a u64 node_id that can be used
> > > > normally for all other operations.
> > > >
>
> Miklos, Max,
>
> Any updates on LOOKUP_HANDLE work?
>
> > > > The advantage of such a scheme for virtio-fs (and possibly other fuse
> > > > based fs) would be that userspace need not keep a refcounted object
> > > > around until the kernel sends a FORGET, but can prune its node ID
> > > > based cache at any time.   If that happens and a request from the
> > > > client (kernel) comes in with a stale node ID, the server will return
> > > > -ESTALE and the client can ask for a new node ID with a special
> > > > lookup_handle(fh, NULL).
> > > >
> > > > Disadvantages being:
> > > >
> > > >  - cost of generating a file handle on all lookups
> > >
> > > I never ran into a local fs implementation where this was expensive.
> > >
> > > >  - cost of storing file handle in kernel icache
> > > >
> > > > I don't think either of those are problematic in the virtiofs case.
> > > > The cost of having to keep fds open while the client has them in its
> > > > cache is much higher.
> > > >
> > >
> > > Sounds good.
> > > I suppose flock() does need to keep the open fd on server.
> >
> > Open files are a separate issue and do need an active object in the server.
> >
> > The issue this solves  is synchronizing "released" and "evicted"
> > states of objects between  server and client.  I.e. when a file is
> > closed (and no more open files exist referencing the same object) the
> > dentry refcount goes to zero but it remains in the cache.   In this
> > state the server could really evict it's own cached object, but can't
> > because the client can gain an active reference at any time  via
> > cached path lookup.
> >
> > One other solution would be for the server to send a notification
> > (NOTIFY_EVICT) that would try to clean out the object from the server
> > cache and respond with a FORGET if successful.   But I sort of like
> > the file handle one better, since it solves multiple problems.
> >
>
> Even with LOOKUP_HANDLE, I am struggling to understand how we
> intend to invalidate all fuse dentries referring to ino X in case the server
> replies with reused ino X with a different generation that the one stored
> in fuse inode cache.
>
> This is an issue that I encountered when running the passthrough_hp test,
> on my filesystem. In tst_readdir_big() for example, underlying files are being
> unlinked and new files created reusing the old inode numbers.
>
> This creates a situation where server gets a lookup request
> for file B that uses the reused inode number X, while old file A is
> still in fuse dentry cache using the older generation of real inode
> number X which is still in fuse inode cache.
>
> Now the server knows that the real inode has been rused, because
> the server caches the old generation value, but it cannot reply to
> the lookup request before the old fuse inode has been invalidated.
> IIUC, fuse_lowlevel_notify_inval_inode() is not enough(?).
> We would also need to change fuse_dentry_revalidate() to
> detect the case of reused/invalidated inode.
>
> The straightforward way I can think of is to store inode generation
> in fuse_dentry. It won't even grow the size of the struct.
>
> Am I over complicating this?

In this scheme the generation number is already embedded in the file
handle.  If LOOKUP_HANDLE returns a nodeid that can be found in the
icache, but which doesn't match the new file handle, then the old
inode will be marked bad and a new one allocated.

Does that answer your worries?  Or am I missing something?

Thanks,
Miklos
