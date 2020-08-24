Return-Path: <SRS0=sCFp=CC=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A354C433DF
	for <linux-unionfs@archiver.kernel.org>; Mon, 24 Aug 2020 20:53:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50E732067C
	for <linux-unionfs@archiver.kernel.org>; Mon, 24 Aug 2020 20:53:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QzqK7hnv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgHXUxo (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 16:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726241AbgHXUxn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 24 Aug 2020 16:53:43 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D36C061574
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Aug 2020 13:53:43 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id f12so8535525ils.6
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Aug 2020 13:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6vf6AHJnMgKAPpmJcPderbcR2uwhOfhpH1wtsYO0WSM=;
        b=QzqK7hnvAKD8Ysutxp7Qq/F0Hd+GRh8e3v2PCady/IRt066R53i4mskqFCTdKOeOE1
         GUsLvkE5kxNq+h/e9RX7Mugn/X68091TKccQEUm+DiEpeOxELQEO21C2hfLAL5/JUbrh
         CMhCoq1ho4NCw1D8u0mm820Yk/f+kABLJStkxPlQS+9V6gNarJyxvqQO6xcgyiAwaacq
         BK6rSWhNCfCraQfgakiK60VMooDTbBmzHG2SuUuz130reV6aQMOQW7ZEYRfoOT1CRg1N
         n0n9oTd62/RmNjXpOk/gfzE9oILHssuN1i75SdFaFe+1XC0Bkd6qLqUwKulove2NwCSI
         KemA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6vf6AHJnMgKAPpmJcPderbcR2uwhOfhpH1wtsYO0WSM=;
        b=qQfd6SpbZIldExv8VbCI/8BNLs13FHvG6yQmg3674WWObPe0uqHifDOJ4eo3z3imOP
         OJ7kDw/AAbEphH7miLwKKpBtO3wfauBbQsh/j/YgVTShYjJjP6tnzwielN9NFXJydTX7
         /e0m69GV4iFf0ugIbt6ZoTGM3X6quMUaajyh2u4OtgdLsTQXj8771Q9TxoZwzFW3LlT8
         3k15YTy2iD7OcU+8U60COpEW1QUc0ULaZOcmlK0Ss0Kcc27DJT0Nib8+7w4wQ0URGYOL
         b8ELkMpsVPio8PfpdMZ2b+DIcIJanGoOcEnxzX0S28vQ5G06WjzZX6Rf+qyELv0nnvzx
         zzoQ==
X-Gm-Message-State: AOAM530jekoKMePV9hO1yncwi0kPmJWNbx37qnZ/+jJ++DggCNfxgzKJ
        ded0GE1WCs5ZU/A/eTHqK7MLjzA7DfdJ9zAbctM=
X-Google-Smtp-Source: ABdhPJyf/BiKC/8/sfsiGQZoPRYRgmk0SkmT+QnvmFIbIOvXIxbJBsXbrrVy/bUSn1fmPq6GRbkvUkQtklm4R+Bv748=
X-Received: by 2002:a92:1fd9:: with SMTP id f86mr6630524ilf.250.1598302422494;
 Mon, 24 Aug 2020 13:53:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200722175024.GA608248@redhat.com> <87h7svyqsd.fsf@redhat.com>
 <CAJfpegtA-16EFFoqhn25rVmXat5hhNUTAWOf+hJEs5L910oQzA@mail.gmail.com>
 <CAOQ4uxj0SF1VRbMEvVm4a9TuUtdMYuZqFkZhkUyEGMagCWk5NA@mail.gmail.com>
 <87a6yknugp.fsf@redhat.com> <CAOQ4uxg4xmvsoKVBfGJ0SVCXfM6aeNji6c8FSCevxV-FYX3LtQ@mail.gmail.com>
 <874kosnqnn.fsf@redhat.com> <CAJfpegvaUz_M0jtibOk=a6Cx=U9JBnOcVSmF2xM9cyVmCz8CFg@mail.gmail.com>
 <20200824135108.GB963827@redhat.com>
In-Reply-To: <20200824135108.GB963827@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 24 Aug 2020 23:53:30 +0300
Message-ID: <CAOQ4uxi9PoYzWxKF0c2a9zzxnrZMeB08Htomn1eHjYha-djLrA@mail.gmail.com>
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

On Mon, Aug 24, 2020 at 4:51 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Mon, Aug 24, 2020 at 03:20:20PM +0200, Miklos Szeredi wrote:
> > On Mon, Aug 24, 2020 at 3:02 PM Giuseppe Scrivano <gscrivan@redhat.com> wrote:
> > >
> > > Amir Goldstein <amir73il@gmail.com> writes:
> > >
> > > > On Mon, Aug 24, 2020 at 2:39 PM Giuseppe Scrivano <gscrivan@redhat.com> wrote:
> > > >>
> > > >> Hi Amir,
> > > >>
> > > >> Amir Goldstein <amir73il@gmail.com> writes:
> > > >>
> > > >> > On Mon, Aug 24, 2020 at 11:15 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > >> >>
> > > >> >> On Sat, Aug 22, 2020 at 11:27 AM Giuseppe Scrivano <gscrivan@redhat.com> wrote:
> > > >> >> >
> > > >> >> > Vivek Goyal <vgoyal@redhat.com> writes:
> > > >> >> >
> > > >> >> > > Container folks are complaining that dnf/yum issues too many sync while
> > > >> >> > > installing packages and this slows down the image build. Build
> > > >> >> > > requirement is such that they don't care if a node goes down while
> > > >> >> > > build was still going on. In that case, they will simply throw away
> > > >> >> > > unfinished layer and start new build. So they don't care about syncing
> > > >> >> > > intermediate state to the disk and hence don't want to pay the price
> > > >> >> > > associated with sync.
> > > >> >> > >
> > > >> >>
> > > >> >> [...]
> > > >> >>
> > > >> >> > Ping.
> > > >> >> >
> > > >> >> > Is there anything holding this patch?
> > > >> >>
> > > >> >> Not sure what happened with protection against mounting a volatile
> > > >> >> overlay twice, I don't see that in the patch.
> > > >> >
> > > >> > Do you mean protection only for new kernels or old kernels as well?
> > > >> >
> > > >> > The latter can be achieved by using $workdir/volatile/ as upperdir
> > > >> > instead of $upperdir.
> > > >> > Or maybe even use $workdir/work/incompat/volatile/upper, so if older
> > > >> > kernel tries to re-use that $workdir, it will fail to mount rw with error:
> > > >> >
> > > >> >   overlayfs: cleanup of 'incompat/volatile' failed (-39)
> > > >> >
> > > >> > If we agree to that, then upperdir= should not be provided at all when
> > > >> > specifying "volatile".
> > > >>
> > > >> in this case, what does a program need to do to remount the overlay more
> > > >> than once?  Is it enough to just delete a file?
> > > >>
> > > >
> > > > Do you mean re-mount while forgetting all changes to previous "volatile"
> > > > mount?
> > >
> > > no, without forgetting them.
> > > The original idea was to have a way to disable any sync operation in the
> > > overlay file system and let the upper layers handle it.  IOW, mount
> > > volatile overlay+umount overlay+syncfs upper dir must still be
> > > considered safe.
> > > If we want to make it safer and disallow remounting the same
> > > workdir+upperdir by default when "volatile" is used, that is fine; but I
> > > think there should still be a way to say "I know what I am doing, just
> > > remount it".
> >
> > Indeed.  "Volatile" doesn't mean you can't use the data, just that the
> > data may be lost completely in case of a crash (tmpfs analogue).
> >
> > Maybe just stick
> >
> >   $(workdir)/work/incompat/volatile/donotremove
> >
> > in there to prevent misuse.
>
> So we ask users to remove "$(workdir)/work/incompat/volatile/donotremove"
> if they want to remount with with same upper/ and work/? (Presumably
> after syncing upper/).
>

Sounds right.
Just don't rely on the workdir cleanup error yes?
That protection is for old kernels and it falls back to r/o mount.
New kernel should of course recognise $(workdir)/work/incompat/volatile
fail to mount and explicitly error about unclean "volatile" unmount and
maybe give a hint how to fix it in kernel log.

Thanks,
Amir.
