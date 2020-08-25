Return-Path: <SRS0=uqCX=CD=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA2C4C433DF
	for <linux-unionfs@archiver.kernel.org>; Tue, 25 Aug 2020 05:31:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 838A320738
	for <linux-unionfs@archiver.kernel.org>; Tue, 25 Aug 2020 05:31:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OZlE/1JT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbgHYFbZ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 25 Aug 2020 01:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728676AbgHYFbW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 25 Aug 2020 01:31:22 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C2FC061574
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Aug 2020 22:31:21 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id p18so9372947ilm.7
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Aug 2020 22:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F30n/XyA9N6wL5uJFadrlVcTvJNu3KJYELAxayzhy3E=;
        b=OZlE/1JT10ocRz5bXVkncaUAR/CYVFhHiSAgs9T/AqAdlg6ueXKlNLAnAmCy6lIFB7
         W04OYyOz9Uga6AcVj1J95mf+ewM6qyvfeUKxxKeeWxDD/oK9Yqg2b+9btS9p9w3uLwva
         hRcU69b4KLBs/BzbNJ6Q0beYDP3FwS+RqBNmxqLXbWYwUadybO3InWpk667aTXm1qeee
         PzNu4w9KMXF1u+LlnCpali0rIhZy7YxhIf1BBUuj5GjqJmVG2vwx2DvLLnlPdH/qtm5w
         GM57kCGHLGGkTEc+RDekIDodGXXsU9+xTpZScjdYd4ty8EREIFF+gypqZdXIVfBm9XS+
         +hUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F30n/XyA9N6wL5uJFadrlVcTvJNu3KJYELAxayzhy3E=;
        b=BTQw/463+5H8Itgf7xGB88iSVK0dWvfo1Z69Fe0MUebP77WrWP55maSrH0Hi+0f1iu
         CCNu7Ruerry5Pv1HKaQ+OH1614DhnAygtKq2Z7OoV5/OxScmcdgZImogxR1LA6gBIfIg
         sZjXxuKWfYjr1euDB4xVUADH89w0/x56ibQ0UyjwVoeL+TSC/6lv8MW3vOu4baSQwwO4
         AYfYfawsJv2esVZ4LDESw9dFN/QKTNteb33bEMV2acCPy/rRcIu+ADFjHY5VapPMaspM
         Q9CVeSJqdt94YuOZiaSoe5oJgCbz2hSTOVn+ckwPH4EsQIBIPlpGIxIFLV6r3crqAB2B
         vF+g==
X-Gm-Message-State: AOAM530xmKNlMXf0o9nQJGZ2LE+aljZF+FBzPeA+Y3WE6w9dpUaQSgST
        TSix1MBr9DDs+h82BFjidz+rIcitpddCuQnEq5Fok5s1SXI=
X-Google-Smtp-Source: ABdhPJxQoyfxnDNDyK1B/GJM1lTMbZuJeccDQ8bo/KnNP7+yP3fHIUbxUqt18nkisj4dFGcrPQ+0NXEc30yp3FT9fGY=
X-Received: by 2002:a92:da0a:: with SMTP id z10mr7829305ilm.275.1598333481184;
 Mon, 24 Aug 2020 22:31:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAJfpegtA-16EFFoqhn25rVmXat5hhNUTAWOf+hJEs5L910oQzA@mail.gmail.com>
 <CAOQ4uxj0SF1VRbMEvVm4a9TuUtdMYuZqFkZhkUyEGMagCWk5NA@mail.gmail.com>
 <87a6yknugp.fsf@redhat.com> <CAOQ4uxg4xmvsoKVBfGJ0SVCXfM6aeNji6c8FSCevxV-FYX3LtQ@mail.gmail.com>
 <874kosnqnn.fsf@redhat.com> <CAJfpegvaUz_M0jtibOk=a6Cx=U9JBnOcVSmF2xM9cyVmCz8CFg@mail.gmail.com>
 <20200824135108.GB963827@redhat.com> <CAOQ4uxi9PoYzWxKF0c2a9zzxnrZMeB08Htomn1eHjYha-djLrA@mail.gmail.com>
 <20200824210053.GL963827@redhat.com> <CAOQ4uxhvi5wHhPKivrWzOJ8ygyETDVqc4h4MW6uYN=h1T2B+BA@mail.gmail.com>
 <20200825005504.GN963827@redhat.com>
In-Reply-To: <20200825005504.GN963827@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 25 Aug 2020 08:31:09 +0300
Message-ID: <CAOQ4uxjHs96Ehoi6JCTMjgGogUw3hgwPOrUJ73S79y9jU68Hjw@mail.gmail.com>
Subject: Re: [PATCH v5] overlayfs: Provide a mount option "volatile" to skip sync
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Daniel J Walsh <dwalsh@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Aug 25, 2020 at 3:55 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Tue, Aug 25, 2020 at 12:51:55AM +0300, Amir Goldstein wrote:
> > > Ok, I am wondering why are we concerned about older kernels. I mean,
> > > if we introduce new features, we don't provide compatibility with
> > > older kernels. Say "metacopy", "redirect_dir". If you mount with
> > > older kernel, they will see something which you don't expect.
> > >
> >
> > True. We missed the opportunity to do the work/incompat trick
> > with metacopy etc.
> >
> > > So why "volatile" is different. We seem to be bending backward and
> > > using an unrelated behavior of overlay to provide this.
> > >
> > > Why not simply drop a file $workdir/volatile for volatile mounts
> > > and check for presence of this file when mounting?
> > >
> >
> > That's an option.
> > But what's the problem with
> >   $workdir/work/incompat/volatile/dirty
> > compared to:
> >   $workdir/volatile
> >
> > It's not more complicated to implement is it?
> > So we get some extra protection with little extra cost. No?
>
> Ok, I will look into it.
> >
> > I don't feel strongly about it.
> >
> > But I must say, according to Giuseppe's description of the use case:
> > "mount volatile overlay+umount overlay+syncfs upper dir..."
> > looks like what he is looking for is "volatile,sync=shutdown", is it not?
> >
> > And if this is the case, I think it would be much preferred to implement
> > "volatile,sync=shutdown", over documenting how to make a "volatile"
> > overlay mountable from outside overlay. Don't you guys agree?
>
> When it comes to requirements, to me it felt that Giuseppe seemed
> to have two requirements. For running containers, he did not care
> seem to care about syncing upper to disk at all. For building
> images he probably wanted to sync upper to disk.
>

You know, I am not sure that building images requires syncing to disk.
Why is syncfs() needed between unmount and copying/tar'ing the layers?
Why is it needed before mounting again? It is not.
It is only needed "before crash", so whether or not "dirty volatile" overlay
can be mounted is a decision better be made by userspace.

The only problem with this approach is that it is a bit harder to document
the filesystem behavior, but I think that we need to.

> From overlayfs perspective, "volatile,sync=shutdown" seems like
> a nicer interface because overlay will take care of removing
> "dirty" file and until and unless crash happens, user does
> not have to step in and there is less confusion about syncing
> upper and removing dirty file etc.
>
> Last time Miklos seemed to prefer to implement just "volatile"
> for now and drop "sync=shutdown".
>
> https://lore.kernel.org/linux-unionfs/CAJfpegt2k=r6TRok57tKPcLyUhCBOcBAV7bgLSPrQYXsPoPkpQ@mail.gmail.com/
>
> I personally think that "volatile,sync=shutdown" is first good step
> because it is less error prone and overlayfs manages dirty file
> and it will provide lot of benefits in terms of not having to
> do very frequent sync.
>
> And if this does not prove to be enough for certain use cases,
> then one can extend this to also implement "volatile,sync=none".
>
> But frankly speaking, there has been so much of back and forth
> on this patch, that I am fine with any of the option which is
> acceptable to Miklos.
>

I agree.
Miklos accepted $workdir/work/incompat/volatile/dirty.
I assume the name 'dirty'/'donotremove' is not an issue.
It's simple.
Let's go with that.

Thanks,
Amir.
