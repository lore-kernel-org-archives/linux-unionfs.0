Return-Path: <SRS0=sCFp=CC=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10C2BC433DF
	for <linux-unionfs@archiver.kernel.org>; Mon, 24 Aug 2020 12:38:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC47920706
	for <linux-unionfs@archiver.kernel.org>; Mon, 24 Aug 2020 12:38:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W26jwNmM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725904AbgHXMiY (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 08:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgHXMiX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 24 Aug 2020 08:38:23 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D59C061573
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Aug 2020 05:38:21 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id b16so8442274ioj.4
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Aug 2020 05:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R2u/hN6BKhZxeB3rC1zulyeGb7tNzQx0xDhuG9B3or4=;
        b=W26jwNmMNbNUDUolbjXXmjNWobrsCl87K2Wy5pWKb4fQdux8AjNYed3uTPCyNaJn3q
         YfOg3szg0EQ5SPBgomYm4+Qfaf+RHkQhemC1nIkvOO1fGxb3uXcyNHZtBSGN7nMD6Y0F
         jNIBay+ZjcbQ+G1LnWVYTN3I3FpWKcZ1kFfarsg0Or/7XYwDT3bPD9269bY94/ZOi7wD
         DWivrjl3nQmbzEzp+ewYyv1KaLPBjNCkRIiYpOZXLkKc2esmtQdnULi2Xa38xPvi0rHU
         cqGUNGdAC0OU9n9RBPYu2DUAZ6/L5mxKL/Z8uowAjUB7WZmtNSlu7yznD5sQhJYImyIs
         t5kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R2u/hN6BKhZxeB3rC1zulyeGb7tNzQx0xDhuG9B3or4=;
        b=ORw+LXtgLxCzSFuqOQwxsehQR/xCx2js0gGCxZZ5iVNa6uQWZrhuUxOJCfMUz6go8b
         K8ZYGHmH4FEK9VhYUCTOAX/lsS1que10/naXywUf70wUdRrv87iqts3ZUoE2+S+uZQ3K
         NIBxYt1nKB3gWqpU6/oPbZvBeyTi9hQ6sP/dtSvkHTk3BtsJla33XSrf9sw9UkWe+PVf
         4/tm3pv5dIMwYpMP4WWkTiq5ZqkxAzd9Ar8oKPrrYQ2bFZ1RnUvYoN4M0ngxVPURlGs1
         CYs6TSm46ohxDj+Han1EqnYKEPECsRl0cqelZK/JOVthnXS0zSqDfJbp19EUG6AzxA0l
         Mvaw==
X-Gm-Message-State: AOAM5309kgRhAUXYzg4bF+fJx84UQJHg5AyBrQq67q2pypsFdhrddcYR
        Yrt4S7gua+EODJXgJAbHL8Uu/xq4KDk4VC4i8+I=
X-Google-Smtp-Source: ABdhPJwnQ6pKi/RxF8KoCL8CDdq0BNcM///Q7P4UT7QEbWWpt6O6wV3VQiivok53z1pT/1TMXYKCltmgXxZuPd7tTvs=
X-Received: by 2002:a05:6602:2439:: with SMTP id g25mr4273769iob.5.1598272701099;
 Mon, 24 Aug 2020 05:38:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200722175024.GA608248@redhat.com> <87h7svyqsd.fsf@redhat.com>
 <CAJfpegtA-16EFFoqhn25rVmXat5hhNUTAWOf+hJEs5L910oQzA@mail.gmail.com>
 <CAOQ4uxj0SF1VRbMEvVm4a9TuUtdMYuZqFkZhkUyEGMagCWk5NA@mail.gmail.com> <87a6yknugp.fsf@redhat.com>
In-Reply-To: <87a6yknugp.fsf@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 24 Aug 2020 15:38:09 +0300
Message-ID: <CAOQ4uxg4xmvsoKVBfGJ0SVCXfM6aeNji6c8FSCevxV-FYX3LtQ@mail.gmail.com>
Subject: Re: [PATCH v5] overlayfs: Provide a mount option "volatile" to skip sync
To:     Giuseppe Scrivano <gscrivan@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Daniel J Walsh <dwalsh@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Aug 24, 2020 at 2:39 PM Giuseppe Scrivano <gscrivan@redhat.com> wrote:
>
> Hi Amir,
>
> Amir Goldstein <amir73il@gmail.com> writes:
>
> > On Mon, Aug 24, 2020 at 11:15 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >>
> >> On Sat, Aug 22, 2020 at 11:27 AM Giuseppe Scrivano <gscrivan@redhat.com> wrote:
> >> >
> >> > Vivek Goyal <vgoyal@redhat.com> writes:
> >> >
> >> > > Container folks are complaining that dnf/yum issues too many sync while
> >> > > installing packages and this slows down the image build. Build
> >> > > requirement is such that they don't care if a node goes down while
> >> > > build was still going on. In that case, they will simply throw away
> >> > > unfinished layer and start new build. So they don't care about syncing
> >> > > intermediate state to the disk and hence don't want to pay the price
> >> > > associated with sync.
> >> > >
> >>
> >> [...]
> >>
> >> > Ping.
> >> >
> >> > Is there anything holding this patch?
> >>
> >> Not sure what happened with protection against mounting a volatile
> >> overlay twice, I don't see that in the patch.
> >
> > Do you mean protection only for new kernels or old kernels as well?
> >
> > The latter can be achieved by using $workdir/volatile/ as upperdir
> > instead of $upperdir.
> > Or maybe even use $workdir/work/incompat/volatile/upper, so if older
> > kernel tries to re-use that $workdir, it will fail to mount rw with error:
> >
> >   overlayfs: cleanup of 'incompat/volatile' failed (-39)
> >
> > If we agree to that, then upperdir= should not be provided at all when
> > specifying "volatile".
>
> in this case, what does a program need to do to remount the overlay more
> than once?  Is it enough to just delete a file?
>

Do you mean re-mount while forgetting all changes to previous "volatile"
mount?

The "workdir" should be re-created from scratch.
IOW, rm -rf $workdir/volatile or rm -rf $workdir/incomapt depending
on which one of my suggested alternatives is chosen.

Thanks,
Amir.
